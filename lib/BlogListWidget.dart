
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'BlogDetail.dart';
import 'constants/Config.dart';
import 'models/BlogList.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:platform_device_id/platform_device_id.dart';

class BlogListWidget extends StatefulWidget {
  @override
  _BlogListWidgetState createState() => _BlogListWidgetState();
  final Blog_list blog;
  String selected_category;
  String selected_sub_category;

  BlogListWidget(this.blog,this.selected_category,this.selected_sub_category);

}


class _BlogListWidgetState extends State<BlogListWidget> {
  bool showShimmer = true; // Track whether to show shimmer or data
  final Duration shimmerDuration = Duration(seconds: 2);
  late YoutubePlayerController _controller=YoutubePlayerController(
    initialVideoId: '',
    flags: YoutubePlayerFlags(
        autoPlay: false,
        controlsVisibleAtStart: true
    ),
  );
  int currentPage = 1;
  bool isLoading = false;
  String  videoId='';
  @override
  void initState() {
    super.initState();

    // Start a timer to hide the shimmer after 2 seconds
    Timer(shimmerDuration, () {
      if (mounted) {
        setState(() {
          showShimmer = false;
        });
      }
    });

  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(widget.blog.videoLink!='')
    {
       videoId = YoutubePlayer.convertUrlToId("${widget.blog.videoLink}")!;
      _controller = YoutubePlayerController(
        initialVideoId: '${videoId}',
        flags: YoutubePlayerFlags(
            autoPlay: false,
            controlsVisibleAtStart: true
        ),
      );

    }
    // Your widget implementation for displaying a single blog item
    return  GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogDetailScreen(
              widget.blog.blogPostId??"",
              '${widget.selected_category}',
              '${widget.selected_sub_category}',false,
            ),
          ),
        );
      },
      child: Card(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4,
        margin: EdgeInsets.all(16),
        child: Container(

          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              if (widget.blog.videoLink != '') ...[
                 Stack(
                  children: [
                    Image.network(
                      'https://img.youtube.com/vi/$videoId/maxresdefault.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 72.0,
                    ),
                  ],
                ),

               /* YoutubePlayer(
                  controller: _controller,
                  aspectRatio: 16 / 9,
                ),*/
                // Add your video rendering here...
              ] else ...[
                if (widget.blog.postDisplayPhoto != '') ...[
                  showShimmer
                      ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 380,
                      color: Colors.white,
                    ),
                  )
                      : CachedNetworkImage(
                    imageUrl: Config.Image_Path + 'blog/${ widget.blog.postDisplayPhoto}',
                    placeholder: (context, url) => Image.asset(
                      "assets/images/loader.gif",
                      width: 80,
                      height: 80,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/loader.gif",
                      width: 80,
                      height: 80,
                    ),
                  ),
                ],
              ],
              showShimmer?
              Column(
                children: [
                  SizedBox(height: 10),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      color: Colors.white,
                    ),
                  )
                ],
              ):
              Html(
                data: widget.blog.heading,
                style: {
                  "body": Style(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.all(0),
                  ),
                },
              ),

              showShimmer?
              Column(
                children: [
                  SizedBox(height: 10),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity/2,
                      height: 20,
                      color: Colors.white,
                    ),
                  )
                ],
              ):
              Container(
                padding: const EdgeInsets.all(8),
                child:    Row(
                  children: [

                    Text(
                      widget.blog.subCategoryName??"",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              showShimmer?
              Column(
                children: [
                  SizedBox(height: 10),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity/3,
                      height: 20,
                      color: Colors.white,
                    ),
                  )
                ],
              ):
              Container(
                padding: const EdgeInsets.all(8),
                child:    Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.grey,
                      size: 16.0,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      widget.blog.timeAgo??'',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(width: 20,),


                    if(widget.blog.postByName!="")
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey.shade600,
                              radius: 14,
                              child: Text(widget.blog.postByName![0].toUpperCase(),style:TextStyle(fontSize: 12,color: Colors.white),),
                            ),
                            const SizedBox(width: 5,),
                            Expanded(child: Text(widget.blog.postByName??"",maxLines: 1,overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
                            )),
                          ],
                        ),
                      )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
