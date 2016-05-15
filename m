From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PULL 00/29] KVM/ARM Changes for v4.7
Date: Sun, 15 May 2016 09:08:00 +0200
Message-ID: <CAMJs5B-dGpg++5__cu2WOp40M0xwQjrPFfGhVhiLvnc6AkGiug@mail.gmail.com>
References: <e368c757-f5a8-d3be-8b67-8270c756bd2b@riken.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2942621640386465700=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33D6349AFA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2016 03:04:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LIDLQXs4Vh6F for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 May 2016 03:04:53 -0400 (EDT)
Received: from mail-yw0-f182.google.com (mail-yw0-f182.google.com
 [209.85.161.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AE8E412A2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2016 03:04:52 -0400 (EDT)
Received: by mail-yw0-f182.google.com with SMTP id g133so136881753ywb.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2016 00:08:01 -0700 (PDT)
In-Reply-To: <e368c757-f5a8-d3be-8b67-8270c756bd2b@riken.jp>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Itaru Kitayama <itaru.kitayama@riken.jp>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

--===============2942621640386465700==
Content-Type: multipart/alternative; boundary=001a114fa01a19b23b0532dc2b8a

--001a114fa01a19b23b0532dc2b8a
Content-Type: text/plain; charset=UTF-8

Yes, I test this for every release.

What's your config? What are the symptoms?

Are you booting with UEFI or u-boot on your mustang?

Thanks,
-Christoffer

On Saturday, May 14, 2016, Itaru Kitayama <itaru.kitayama@riken.jp> wrote:

> Hi,
>
> The tag kvm-arm-for-4.7 fails to boot on Mustang. Has anyone verified this
> tag on Mustang? The F/W I'm using is 3.05.05-beta_rc.
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>

--001a114fa01a19b23b0532dc2b8a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Yes, I test this for every release.=C2=A0<div><br></div><div>What&#39;s you=
r config? What are the symptoms?</div><div><br></div><div>Are you booting w=
ith UEFI or u-boot on your mustang?</div><div><br></div><div>Thanks,</div><=
div>-Christoffer<br><br>On Saturday, May 14, 2016, Itaru Kitayama &lt;<a hr=
ef=3D"mailto:itaru.kitayama@riken.jp">itaru.kitayama@riken.jp</a>&gt; wrote=
:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-le=
ft:1px #ccc solid;padding-left:1ex">Hi,<br>
<br>
The tag kvm-arm-for-4.7 fails to boot on Mustang. Has anyone verified this =
tag on Mustang? The F/W I&#39;m using is 3.05.05-beta_rc.<br>
_______________________________________________<br>
kvmarm mailing list<br>
<a>kvmarm@lists.cs.columbia.edu</a><br>
<a href=3D"https://lists.cs.columbia.edu/mailman/listinfo/kvmarm" target=3D=
"_blank">https://lists.cs.columbia.edu/mailman/listinfo/kvmarm</a><br>
</blockquote></div>

--001a114fa01a19b23b0532dc2b8a--

--===============2942621640386465700==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2942621640386465700==--
