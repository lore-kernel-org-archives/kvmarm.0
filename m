Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C8FC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 11 Oct 2022 21:28:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCAD94B19F;
	Tue, 11 Oct 2022 17:28:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=jesse=cypress-tech.com@a1189921.bnc3.mailjet.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YqoKCNMi8CSk; Tue, 11 Oct 2022 17:28:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C73D4B239;
	Tue, 11 Oct 2022 17:28:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A72A49EFA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Oct 2022 15:21:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F8tehqkIV7Do for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Oct 2022 15:21:10 -0400 (EDT)
Received: from o22.p38.mailjet.com (o22.p38.mailjet.com [185.250.237.22])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADB2249ECB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Oct 2022 15:21:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; q=dns/txt;
 d=bnc3.mailjet.com; i=jesse=3Dcypress-tech.com@a1189921.bnc3.mailjet.com;
 s=mailjet2; 
 h=message-id:mime-version:from:from:to:to:subject:subject:date:date:list-id:list-unsubscribe-post:
 list-unsubscribe:feedback-id:precedence:x-campaignid:x-csa-complaints:
 x-mj-mid:x-mj-smtpguid:x-report-abuse-to:content-type;
 bh=4jA/5Xy1gYmH7SaMPVxAASr5qnDDkd0qWZg2W6eOoPU=;
 b=OELiE8tD3rYkWyo2WPTQFujmqtgKtiZtQskqnG/qRrnofqWgqbA6aFbSW
 Izx23iSOhU1fZN4lX4H5lzFWv8DP8cfJ9XZuz/4Ky81y4TmT44pANX+tsnVR
 EZWsC5DkI/HZh8OL8+/cActDIgjtJaJFLnxrCJxwN2B+uc/uCmzg2c=
Message-Id: <fecc9105.AV8AACyp26kAAcjIYbYAAM5EfHEAAYCrYzIAnGIiABIoIQBjRcIl@mailjet.com>
MIME-Version: 1.0
From: Jesse Dougherty <jesse@cypress-tech.com>
To: kvmarm@lists.cs.columbia.edu
Subject: HP PA-RISC / IA64 hardware platform for Linux Debian, Gentoo,
 NetBSD, OpenBSD and HP-UX Unix
Date: Tue, 11 Oct 2022 19:21:08 +0000 (UTC)
List-Unsubscribe-Post: List-Unsubscribe=One-Click
Feedback-Id: 42.1189921.1191387:MJ
Precedence: bulk
X-CampaignID: 7663542710
X-CSA-Complaints: csa-complaints@eco.de
X-MJ-Mid: AV8AACyp26kAAcjIYbYAAM5EfHEAAYCrYzIAnGIiABIoIQBjRcIlaplgVaPYRrKYjSs4_NJi5wASLds
X-MJ-SMTPGUID: 6a996055-a3d8-46b2-988d-2b38fcd262e7
X-REPORT-ABUSE-TO: Message sent by Mailjet please report to
 abuse@mailjet.com with a copy of the message
X-Mailman-Approved-At: Tue, 11 Oct 2022 17:28:44 -0400
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8188575341052208914=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============8188575341052208914==
Content-Type: multipart/alternative; boundary="=-xsdjpNxWuY6X1oK9ZO3h"

--=-xsdjpNxWuY6X1oK9ZO3h
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi, I'm Jesse at Cypress Technology Inc. We at Cypress sell HP hardware. Be=
low are some links to HP PA-RISC and IA64 boxes that support the Linux Debi=
an, Gentoo, NetBSD, OpenBSD Linux and HP-UX Unix platforms. If you are in n=
eed of systems, feel free to email back with any question or requests. We a=
lso sell / buy all boxes and parts that HP made for the HP-UX / Unix (PA-RI=
SC & ia64) line.

PA-RISC
www.ebay.com/itm/385130495455
www.ebay.com/itm/384211227917

IA64
www.ebay.com/itm/384272059488
www.ebay.com/itm/384211228177

IA64 - For Telco / Data Center users / 48v DC
www.ebay.com/itm/384966825704

Thanks
Jesse Dougherty
Resellers of HP hardware
Jesse@cypress-tech.com
www.cypress-tech.com=

--=-xsdjpNxWuY6X1oK9ZO3h
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<!doctype html><html xmlns=3D"http://www.w3.org/1999/xhtml" xmlns:v=3D"urn:=
schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-microsoft-com:office:offi=
ce"><head><title>HP PA-RISC / IA64 hardware platform for Linux Debian, Gent=
oo, NetBSD, OpenBSD and HP-UX Unix</title><!--[if !mso]><!--><meta http-equ=
iv=3D"X-UA-Compatible" content=3D"IE=3Dedge"><!--<![endif]--><meta http-equ=
iv=3D"Content-Type" content=3D"text/html; charset=3DUTF-8"><meta name=3D"vi=
ewport" content=3D"width=3Ddevice-width,initial-scale=3D1"><style type=3D"t=
ext/css">#outlook a { padding:0; }
          body { margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-=
size-adjust:100%; }
          table, td { border-collapse:collapse;mso-table-lspace:0pt;mso-tab=
le-rspace:0pt; }
          img { border:0;height:auto;line-height:100%; outline:none;text-de=
coration:none;-ms-interpolation-mode:bicubic; }
          p { display:block;margin:13px 0; }</style><!--[if mso]>
        <noscript>
        <xml>
        <o:OfficeDocumentSettings>
          <o:AllowPNG/>
          <o:PixelsPerInch>96</o:PixelsPerInch>
        </o:OfficeDocumentSettings>
        </xml>
        </noscript>
        <![endif]--><!--[if lte mso 11]>
        <style type=3D"text/css">
          .mj-outlook-group-fix { width:100% !important; }
        </style>
        <![endif]--><style type=3D"text/css">@media only screen and (min-wi=
dth:480px) {
        .mj-column-per-100 { width:100% !important; max-width: 100%; }
      }</style><style media=3D"screen and (min-width:480px)">.moz-text-html=
 .mj-column-per-100 { width:100% !important; max-width: 100%; }</style><sty=
le type=3D"text/css">[owa] .mj-column-per-100 { width:100% !important; max-=
width: 100%; }</style><style type=3D"text/css"></style></head><body style=
=3D"word-spacing:normal;background-color:#F4F4F4;"><div style=3D"background=
-color:#F4F4F4;"><!--[if mso | IE]><table align=3D"center" border=3D"0" cel=
lpadding=3D"0" cellspacing=3D"0" class=3D"" role=3D"presentation" style=3D"=
width:600px;" width=3D"600" bgcolor=3D"#ffffff" ><tr><td style=3D"line-heig=
ht:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--><div style=
=3D"background:#ffffff;background-color:#ffffff;margin:0px auto;max-width:6=
00px;"><table align=3D"center" border=3D"0" cellpadding=3D"0" cellspacing=
=3D"0" role=3D"presentation" style=3D"background:#ffffff;background-color:#=
ffffff;width:100%;"><tbody><tr><td style=3D"direction:ltr;font-size:0px;pad=
ding:20px 0px 20px 0px;text-align:center;"><!--[if mso | IE]><table role=3D=
"presentation" border=3D"0" cellpadding=3D"0" cellspacing=3D"0"><tr><td cla=
ss=3D"" style=3D"vertical-align:top;width:600px;" ><![endif]--><div class=
=3D"mj-column-per-100 mj-outlook-group-fix" style=3D"font-size:0px;text-ali=
gn:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;">=
<table border=3D"0" cellpadding=3D"0" cellspacing=3D"0" role=3D"presentatio=
n" style=3D"vertical-align:top;" width=3D"100%"><tbody><tr><td align=3D"lef=
t" style=3D"font-size:0px;padding:0px 25px 0px 25px;padding-top:0px;padding=
-bottom:0px;word-break:break-word;"><div style=3D"font-family:Arial, sans-s=
erif;font-size:13px;letter-spacing:normal;line-height:1;text-align:left;col=
or:#000000;"><h1 class=3D"text-build-content" data-testid=3D"Jz34KW14Tt" st=
yle=3D"margin-top: 10px; margin-bottom: 10px; font-weight: normal;"><span s=
tyle=3D"color:#55575d;font-family:Arial;font-size:20px;line-height:22px;"><=
b>HP PA-RISC / IA64 hardware platform for Linux Debian, Gentoo, NetBSD, Ope=
nBSD and HP-UX Unix</b></span></h1></div></td></tr><tr><td align=3D"left" s=
tyle=3D"font-size:0px;padding:0px 25px 0px 25px;padding-top:0px;padding-bot=
tom:0px;word-break:break-word;"><div style=3D"font-family:Arial, sans-serif=
;font-size:14px;letter-spacing:normal;line-height:1;text-align:left;color:#=
000000;"><p class=3D"text-build-content" data-testid=3D"xnDQWx__cn" style=
=3D"margin: 10px 0; margin-top: 10px;"><span style=3D"color:#55575d;font-fa=
mily:Arial;font-size:14px;line-height:22px;">Hi, I'm Jesse at Cypress Techn=
ology Inc. We at Cypress sell and purchase HP hardware. Below are some link=
s to HP PA-RISC and IA64 boxes that support the Linux Debian, Gentoo, NetBS=
D, OpenBSD Linux and HP-UX Unix platforms. If you are in need of systems, f=
eel free to email back with any question or requests. We also sell / buy al=
l boxes and parts that HP made for the HP-UX / Unix (PA-RISC &amp; ia64) li=
ne.</span></p><p class=3D"text-build-content" data-testid=3D"xnDQWx__cn" st=
yle=3D"margin: 10px 0;"><span style=3D"color:#55575d;font-family:Arial;font=
-size:14px;line-height:22px;"><b>PA-RISC</b></span></p><ul><li><a class=3D"=
link-build-content" style=3D"color:inherit;; text-decoration: none;" target=
=3D"_blank" href=3D"http://xz01x.mjt.lu/lnk/AV8AACyp26kAAcjIYbYAAM5EfHEAAYC=
rYzIAnGIiABIoIQBjRcIlaplgVaPYRrKYjSs4_NJi5wASLds/1/uf5DAaF89eLKWXCUt3xMag/a=
HR0cDovL3d3dy5lYmF5LmNvbS9pdG0vMzg1MTMwNDk1NDU1"><span style=3D"color:#5557=
5d;font-family:Arial;font-size:14px;line-height:22px;"><u>www.ebay.com/itm/=
385130495455</u></span></a></li><li><a class=3D"link-build-content" style=
=3D"color:inherit;; text-decoration: none;" target=3D"_blank" href=3D"http:=
//xz01x.mjt.lu/lnk/AV8AACyp26kAAcjIYbYAAM5EfHEAAYCrYzIAnGIiABIoIQBjRcIlaplg=
VaPYRrKYjSs4_NJi5wASLds/2/csYZPMaggqhMdw13bhMVRw/aHR0cDovL3d3dy5lYmF5LmNvbS=
9pdG0vMzg0MjExMjI3OTE3"><span style=3D"color:#55575d;font-family:Arial;font=
-size:14px;line-height:22px;"><u>www.ebay.com/itm/384211227917</u></span></=
a></li></ul><p class=3D"text-build-content" data-testid=3D"xnDQWx__cn" styl=
e=3D"margin: 10px 0;"><span style=3D"color:#55575d;font-family:Arial;font-s=
ize:14px;line-height:22px;"><b>IA64</b></span></p><ul><li><a class=3D"link-=
build-content" style=3D"color:inherit;; text-decoration: none;" target=3D"_=
blank" href=3D"http://xz01x.mjt.lu/lnk/AV8AACyp26kAAcjIYbYAAM5EfHEAAYCrYzIA=
nGIiABIoIQBjRcIlaplgVaPYRrKYjSs4_NJi5wASLds/3/AMQE2UPIlUKb8BTXQfIVFQ/aHR0cD=
ovL3d3dy5lYmF5LmNvbS9pdG0vMzg0MjcyMDU5NDg4"><span style=3D"color:#55575d;fo=
nt-family:Arial;font-size:14px;line-height:22px;"><u>www.ebay.com/itm/38427=
2059488</u></span></a></li><li><a class=3D"link-build-content" style=3D"col=
or:inherit;; text-decoration: none;" target=3D"_blank" href=3D"http://xz01x=
.mjt.lu/lnk/AV8AACyp26kAAcjIYbYAAM5EfHEAAYCrYzIAnGIiABIoIQBjRcIlaplgVaPYRrK=
YjSs4_NJi5wASLds/4/WKTDYZ6LLa5oyxwlFRaWmg/aHR0cDovL3d3dy5lYmF5LmNvbS9pdG0vM=
zg0MjExMjI4MTc3"><span style=3D"color:#55575d;font-family:Arial;font-size:1=
4px;line-height:22px;"><u>www.ebay.com/itm/384211228177</u></span></a></li>=
</ul><p class=3D"text-build-content" data-testid=3D"xnDQWx__cn" style=3D"ma=
rgin: 10px 0;"><span style=3D"color:#55575d;font-family:Arial;font-size:14p=
x;line-height:22px;"><b>IA64 - For Telco </b>/ Data Center users / 48v DC</=
span></p><ul><li><a class=3D"link-build-content" style=3D"color:inherit;; t=
ext-decoration: none;" target=3D"_blank" href=3D"http://xz01x.mjt.lu/lnk/AV=
8AACyp26kAAcjIYbYAAM5EfHEAAYCrYzIAnGIiABIoIQBjRcIlaplgVaPYRrKYjSs4_NJi5wASL=
ds/5/e6ZUiqJ3TxH67Pjwn4uB_w/aHR0cDovL3d3dy5lYmF5LmNvbS9pdG0vMzg0OTY2ODI1NzA=
0"><span style=3D"color:#55575d;font-family:Arial;font-size:14px;line-heigh=
t:22px;"><u>www.ebay.com/itm/384966825704</u></span></a></li></ul><p class=
=3D"text-build-content" data-testid=3D"xnDQWx__cn" style=3D"margin: 10px 0;=
">&nbsp;</p><p class=3D"text-build-content" data-testid=3D"xnDQWx__cn" styl=
e=3D"margin: 10px 0;"><span style=3D"color:#55575d;font-family:Arial;font-s=
ize:14px;line-height:22px;">Thanks&nbsp;</span></p><p class=3D"text-build-c=
ontent" data-testid=3D"xnDQWx__cn" style=3D"margin: 10px 0; margin-bottom: =
10px;"><span style=3D"color:#55575d;font-family:Arial;font-size:14px;line-h=
eight:22px;">Jesse Dougherty / Jesse@Cypress-Tech.com</span></p></div></td>=
</tr></tbody></table></div><!--[if mso | IE]></td></tr></table><![endif]-->=
</td></tr></tbody></table></div><!--[if mso | IE]></td></tr></table><table =
align=3D"center" border=3D"0" cellpadding=3D"0" cellspacing=3D"0" class=3D"=
" role=3D"presentation" style=3D"width:600px;" width=3D"600" ><tr><td style=
=3D"line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-=
-><div style=3D"margin:0px auto;max-width:600px;"><table align=3D"center" b=
order=3D"0" cellpadding=3D"0" cellspacing=3D"0" role=3D"presentation" style=
=3D"width:100%;"><tbody><tr><td style=3D"direction:ltr;font-size:0px;paddin=
g:20px 0px 20px 0px;text-align:center;"><!--[if mso | IE]><table role=3D"pr=
esentation" border=3D"0" cellpadding=3D"0" cellspacing=3D"0"><tr><td class=
=3D"" style=3D"vertical-align:top;width:600px;" ><![endif]--><div class=3D"=
mj-column-per-100 mj-outlook-group-fix" style=3D"font-size:0px;text-align:l=
eft;direction:ltr;display:inline-block;vertical-align:top;width:100%;"><tab=
le border=3D"0" cellpadding=3D"0" cellspacing=3D"0" role=3D"presentation" s=
tyle=3D"vertical-align:top;" width=3D"100%"><tbody><tr><td align=3D"left" s=
tyle=3D"font-size:0px;padding:0px 20px 0px 20px;padding-top:0px;padding-bot=
tom:0px;word-break:break-word;"><div style=3D"font-family:Arial, sans-serif=
;font-size:13px;letter-spacing:normal;line-height:1;text-align:left;color:#=
000000;"><p style=3D"text-align: center; margin: 10px 0; margin-top: 10px; =
margin-bottom: 10px;"><span style=3D"line-height:22px;font-family:Arial;col=
or:#55575d;text-align:center;font-size:13px;">This e-mail has been sent to =
kvmarm@lists.cs.columbia.edu, <a href=3D"http://xz01x.mjt.lu/unsub2?hl=3Den=
&amp;m=3DAV8AACyp26kAAcjIYbYAAM5EfHEAAYCrYzIAnGIiABIoIQBjRcIlaplgVaPYRrKYjS=
s4_NJi5wASLds&amp;b=3Dfecc9105&amp;e=3Dd517eda7&amp;x=3D-_EbKqPHflRAO07EXvd=
WXMx4TzuH7i-qbgzEfrcD8XY" style=3D"color:inherit;text-decoration:none;" tar=
get=3D"_blank">click here to unsubscribe</a>.</span></p></div></td></tr></t=
body></table></div><!--[if mso | IE]></td></tr></table><![endif]--></td></t=
r></tbody></table></div><!--[if mso | IE]></td></tr></table><![endif]--></d=
iv>
<br/><img src=3D"http://xz01x.mjt.lu/oo/AV8AACyp26kAAcjIYbYAAM5EfHEAAYCrYzI=
AnGIiABIoIQBjRcIlaplgVaPYRrKYjSs4_NJi5wASLds/1152683e/e.gif" height=3D"1" w=
idth=3D"1" alt=3D"" border=3D"0" style=3D"height:1px;width:1px;border:0;"/>
</body></html>=

--=-xsdjpNxWuY6X1oK9ZO3h--


--===============8188575341052208914==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8188575341052208914==--

