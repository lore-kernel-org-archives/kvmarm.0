From: Eugene Bagdasaryan <eb693@cornell.edu>
Subject: Re: development guide for installing KVMARM kernel
Date: Wed, 12 Oct 2016 06:45:14 +0000
Message-ID: <934F2AEF-A7A2-49DE-BDC5-3A90F3D81EC0@cornell.edu>
References: <CY1PR0401MB1629013D592E886EF2332C80EEC50@CY1PR0401MB1629.namprd04.prod.outlook.com>
 <8a3d33a861d6dc90ef2da82ad3f1950c@www.loen.fr>
 <CY1PR0401MB16290C3826BFA5ED46E3F81BEEC70@CY1PR0401MB1629.namprd04.prod.outlook.com>
 <bd6adc0e4698903a5bc986e88f4ab9dd@www.loen.fr>
 <77b4ee22-a823-07e1-e4f8-9677efb839f9@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6433680799392985741=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB5154113E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Oct 2016 02:35:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xV92LNA6iJ1H for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Oct 2016 02:35:14 -0400 (EDT)
Received: from limerock04.mail.cornell.edu (limerock04.mail.cornell.edu
 [128.84.13.244])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B195410D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Oct 2016 02:35:13 -0400 (EDT)
In-Reply-To: <77b4ee22-a823-07e1-e4f8-9677efb839f9@suse.de>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

--===============6433680799392985741==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_934F2AEFA7A249DEBDC53A90F3D81EC0cornelledu_"

--_000_934F2AEFA7A249DEBDC53A90F3D81EC0cornelledu_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Alex

Thanks a lot for this info will let you know about progress!


Eugene
On Oct 11, 2016, at 16:11, Alexander Graf <agraf@suse.de<mailto:agraf@suse.=
de>> wrote:



On 10.10.16 15:50, Marc Zyngier wrote:
On 2016-10-06 19:54, Eugene Bagdasaryan wrote:
Hey Marc

I basically want to try and install OpenStack on RPi, which I guess
is possible.

Sounds pretty ambitious, but I guess someone has to try...

(1) For the 64-bit arm OS, what would you suggest?

I'll defer that to the local RPi zealot (Alex, cc'd), because I've
stopped caring about this platform long before it even existed.

Alex, would you mind letting Eugene know how to run a full 64bit
mainline kernel + userspace on a RPi3?

Sure! If everything works (and if it doesn't, please report to the
mailing list), just follow the description below:


https://en.opensuse.org/HCL:Raspberry_Pi3#Installing_the_64-bit_non-upstrea=
m_openSUSE_Tumbleweed_image

Get the image, put it on an SD card, boot it up (it takes ~5 minutes for
the first boot), then install your own upstream kernel on it and run it.
4.8 should work just fine.

If you also want KVM, make sure you have the user space irqchip fixes in
your kernel.


Alex


--_000_934F2AEFA7A249DEBDC53A90F3D81EC0cornelledu_
Content-Type: text/html; charset="us-ascii"
Content-ID: <A442161EFF185341A48F55EE60D1BACE@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
</head>
<body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-lin=
e-break: after-white-space;" class=3D"">
Alex&nbsp;
<div class=3D""><br class=3D"">
</div>
<div class=3D"">Thanks a lot for this info will let you know about progress=
!</div>
<div class=3D""><br class=3D"">
</div>
<div class=3D""><br class=3D"">
</div>
<div class=3D"">Eugene<br class=3D"">
<div>
<blockquote type=3D"cite" class=3D"">
<div class=3D"">On Oct 11, 2016, at 16:11, Alexander Graf &lt;<a href=3D"ma=
ilto:agraf@suse.de" class=3D"">agraf@suse.de</a>&gt; wrote:</div>
<br class=3D"Apple-interchange-newline">
<div class=3D""><br style=3D"font-family: Helvetica; font-size: 12px; font-=
style: normal; font-variant-caps: normal; font-weight: normal; letter-spaci=
ng: normal; orphans: auto; text-align: start; text-indent: 0px; text-transf=
orm: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-te=
xt-stroke-width: 0px;" class=3D"">
<br style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; f=
ont-variant-caps: normal; font-weight: normal; letter-spacing: normal; orph=
ans: auto; text-align: start; text-indent: 0px; text-transform: none; white=
-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width:=
 0px;" class=3D"">
<span style=3D"font-family: Helvetica; font-size: 12px; font-style: normal;=
 font-variant-caps: normal; font-weight: normal; letter-spacing: normal; or=
phans: auto; text-align: start; text-indent: 0px; text-transform: none; whi=
te-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-widt=
h: 0px; float: none; display: inline !important;" class=3D"">On
 10.10.16 15:50, Marc Zyngier wrote:</span><br style=3D"font-family: Helvet=
ica; font-size: 12px; font-style: normal; font-variant-caps: normal; font-w=
eight: normal; letter-spacing: normal; orphans: auto; text-align: start; te=
xt-indent: 0px; text-transform: none; white-space: normal; widows: auto; wo=
rd-spacing: 0px; -webkit-text-stroke-width: 0px;" class=3D"">
<blockquote type=3D"cite" style=3D"font-family: Helvetica; font-size: 12px;=
 font-style: normal; font-variant-caps: normal; font-weight: normal; letter=
-spacing: normal; orphans: auto; text-align: start; text-indent: 0px; text-=
transform: none; white-space: normal; widows: auto; word-spacing: 0px; -web=
kit-text-size-adjust: auto; -webkit-text-stroke-width: 0px;" class=3D"">
On 2016-10-06 19:54, Eugene Bagdasaryan wrote:<br class=3D"">
<blockquote type=3D"cite" class=3D"">Hey Marc<br class=3D"">
<br class=3D"">
I basically want to try and install OpenStack on RPi, which I guess<br clas=
s=3D"">
is possible.<br class=3D"">
</blockquote>
<br class=3D"">
Sounds pretty ambitious, but I guess someone has to try...<br class=3D"">
<br class=3D"">
<blockquote type=3D"cite" class=3D"">(1) For the 64-bit arm OS, what would =
you suggest?<br class=3D"">
</blockquote>
<br class=3D"">
I'll defer that to the local RPi zealot (Alex, cc'd), because I've<br class=
=3D"">
stopped caring about this platform long before it even existed.<br class=3D=
"">
<br class=3D"">
Alex, would you mind letting Eugene know how to run a full 64bit<br class=
=3D"">
mainline kernel &#43; userspace on a RPi3?<br class=3D"">
</blockquote>
<br style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; f=
ont-variant-caps: normal; font-weight: normal; letter-spacing: normal; orph=
ans: auto; text-align: start; text-indent: 0px; text-transform: none; white=
-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width:=
 0px;" class=3D"">
<span style=3D"font-family: Helvetica; font-size: 12px; font-style: normal;=
 font-variant-caps: normal; font-weight: normal; letter-spacing: normal; or=
phans: auto; text-align: start; text-indent: 0px; text-transform: none; whi=
te-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-widt=
h: 0px; float: none; display: inline !important;" class=3D"">Sure!
 If everything works (and if it doesn't, please report to the</span><br sty=
le=3D"font-family: Helvetica; font-size: 12px; font-style: normal; font-var=
iant-caps: normal; font-weight: normal; letter-spacing: normal; orphans: au=
to; text-align: start; text-indent: 0px; text-transform: none; white-space:=
 normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px;" =
class=3D"">
<span style=3D"font-family: Helvetica; font-size: 12px; font-style: normal;=
 font-variant-caps: normal; font-weight: normal; letter-spacing: normal; or=
phans: auto; text-align: start; text-indent: 0px; text-transform: none; whi=
te-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-widt=
h: 0px; float: none; display: inline !important;" class=3D"">mailing
 list), just follow the description below:</span><br style=3D"font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; orphans: auto; text-align: sta=
rt; text-indent: 0px; text-transform: none; white-space: normal; widows: au=
to; word-spacing: 0px; -webkit-text-stroke-width: 0px;" class=3D"">
<br style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; f=
ont-variant-caps: normal; font-weight: normal; letter-spacing: normal; orph=
ans: auto; text-align: start; text-indent: 0px; text-transform: none; white=
-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width:=
 0px;" class=3D"">
<br style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; f=
ont-variant-caps: normal; font-weight: normal; letter-spacing: normal; orph=
ans: auto; text-align: start; text-indent: 0px; text-transform: none; white=
-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width:=
 0px;" class=3D"">
<a href=3D"https://en.opensuse.org/HCL:Raspberry_Pi3#Installing_the_64-bit_=
non-upstream_openSUSE_Tumbleweed_image" style=3D"font-family: Helvetica; fo=
nt-size: 12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; orphans: auto; text-align: start; text-inde=
nt: 0px; text-transform: none; white-space: normal; widows: auto; word-spac=
ing: 0px; -webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px;" =
class=3D"">https://en.opensuse.org/HCL:Raspberry_Pi3#Installing_the_64-bit_=
non-upstream_openSUSE_Tumbleweed_image</a><br style=3D"font-family: Helveti=
ca; font-size: 12px; font-style: normal; font-variant-caps: normal; font-we=
ight: normal; letter-spacing: normal; orphans: auto; text-align: start; tex=
t-indent: 0px; text-transform: none; white-space: normal; widows: auto; wor=
d-spacing: 0px; -webkit-text-stroke-width: 0px;" class=3D"">
<br style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; f=
ont-variant-caps: normal; font-weight: normal; letter-spacing: normal; orph=
ans: auto; text-align: start; text-indent: 0px; text-transform: none; white=
-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width:=
 0px;" class=3D"">
<span style=3D"font-family: Helvetica; font-size: 12px; font-style: normal;=
 font-variant-caps: normal; font-weight: normal; letter-spacing: normal; or=
phans: auto; text-align: start; text-indent: 0px; text-transform: none; whi=
te-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-widt=
h: 0px; float: none; display: inline !important;" class=3D"">Get
 the image, put it on an SD card, boot it up (it takes ~5 minutes for</span=
><br style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; orp=
hans: auto; text-align: start; text-indent: 0px; text-transform: none; whit=
e-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width=
: 0px;" class=3D"">
<span style=3D"font-family: Helvetica; font-size: 12px; font-style: normal;=
 font-variant-caps: normal; font-weight: normal; letter-spacing: normal; or=
phans: auto; text-align: start; text-indent: 0px; text-transform: none; whi=
te-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-widt=
h: 0px; float: none; display: inline !important;" class=3D"">the
 first boot), then install your own upstream kernel on it and run it.</span=
><br style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; orp=
hans: auto; text-align: start; text-indent: 0px; text-transform: none; whit=
e-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width=
: 0px;" class=3D"">
<span style=3D"font-family: Helvetica; font-size: 12px; font-style: normal;=
 font-variant-caps: normal; font-weight: normal; letter-spacing: normal; or=
phans: auto; text-align: start; text-indent: 0px; text-transform: none; whi=
te-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-widt=
h: 0px; float: none; display: inline !important;" class=3D"">4.8
 should work just fine.</span><br style=3D"font-family: Helvetica; font-siz=
e: 12px; font-style: normal; font-variant-caps: normal; font-weight: normal=
; letter-spacing: normal; orphans: auto; text-align: start; text-indent: 0p=
x; text-transform: none; white-space: normal; widows: auto; word-spacing: 0=
px; -webkit-text-stroke-width: 0px;" class=3D"">
<br style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; f=
ont-variant-caps: normal; font-weight: normal; letter-spacing: normal; orph=
ans: auto; text-align: start; text-indent: 0px; text-transform: none; white=
-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width:=
 0px;" class=3D"">
<span style=3D"font-family: Helvetica; font-size: 12px; font-style: normal;=
 font-variant-caps: normal; font-weight: normal; letter-spacing: normal; or=
phans: auto; text-align: start; text-indent: 0px; text-transform: none; whi=
te-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-widt=
h: 0px; float: none; display: inline !important;" class=3D"">If
 you also want KVM, make sure you have the user space irqchip fixes in</spa=
n><br style=3D"font-family: Helvetica; font-size: 12px; font-style: normal;=
 font-variant-caps: normal; font-weight: normal; letter-spacing: normal; or=
phans: auto; text-align: start; text-indent: 0px; text-transform: none; whi=
te-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-widt=
h: 0px;" class=3D"">
<span style=3D"font-family: Helvetica; font-size: 12px; font-style: normal;=
 font-variant-caps: normal; font-weight: normal; letter-spacing: normal; or=
phans: auto; text-align: start; text-indent: 0px; text-transform: none; whi=
te-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-widt=
h: 0px; float: none; display: inline !important;" class=3D"">your
 kernel.</span><br style=3D"font-family: Helvetica; font-size: 12px; font-s=
tyle: normal; font-variant-caps: normal; font-weight: normal; letter-spacin=
g: normal; orphans: auto; text-align: start; text-indent: 0px; text-transfo=
rm: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-tex=
t-stroke-width: 0px;" class=3D"">
<br style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; f=
ont-variant-caps: normal; font-weight: normal; letter-spacing: normal; orph=
ans: auto; text-align: start; text-indent: 0px; text-transform: none; white=
-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width:=
 0px;" class=3D"">
<br style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; f=
ont-variant-caps: normal; font-weight: normal; letter-spacing: normal; orph=
ans: auto; text-align: start; text-indent: 0px; text-transform: none; white=
-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width:=
 0px;" class=3D"">
<span style=3D"font-family: Helvetica; font-size: 12px; font-style: normal;=
 font-variant-caps: normal; font-weight: normal; letter-spacing: normal; or=
phans: auto; text-align: start; text-indent: 0px; text-transform: none; whi=
te-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-widt=
h: 0px; float: none; display: inline !important;" class=3D"">Alex</span></d=
iv>
</blockquote>
</div>
<br class=3D"">
</div>
</body>
</html>

--_000_934F2AEFA7A249DEBDC53A90F3D81EC0cornelledu_--

--===============6433680799392985741==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6433680799392985741==--
