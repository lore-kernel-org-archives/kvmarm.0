From: Mike Bazov <mike@perception-point.io>
Subject: Compiling KVM/ARM as a separate kernel module.
Date: Tue, 10 Apr 2018 11:23:43 +0300
Message-ID: <CAE3G1Z_HJqkWeGEESTVg+5yarWND7KR-QLOL1sRu_ey-xGZdKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7933726823221746244=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AED6F4048A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Apr 2018 04:15:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9qxWF9m-vrmJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Apr 2018 04:15:02 -0400 (EDT)
Received: from mail-lf0-f44.google.com (mail-lf0-f44.google.com
 [209.85.215.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DCEEF49FD3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Apr 2018 04:15:01 -0400 (EDT)
Received: by mail-lf0-f44.google.com with SMTP id g203-v6so10383181lfg.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Apr 2018 01:23:45 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============7933726823221746244==
Content-Type: multipart/alternative; boundary="94eb2c1a6594993dce05697a3d25"

--94eb2c1a6594993dce05697a3d25
Content-Type: text/plain; charset="UTF-8"

Greetings,

I hope i have reached the correct mailing list(referred here:
https://www.linux-kvm.org/page/Lists,_IRC)

I'm trying to compile the KVM/ARM as a separate kernel module, just like
the x86 modules. When i compile the x86 modules, i get the "kvm.ko" and
"kvm-intel.ko" as an output. Is there any way of compiling the KVM/ARM as
modules as well?

I have tried this approach:
$ make M=arch/arm64/kvm/

This does compile all of the source files to object files, but doesn't
create any kernel modules at the end:

>   Building modules, stage 2.
>   MODPOST 0 modules


There is also no option for specifying "M" (modular) in the menuconfig when
choosing the virtualization and KVM option, like in x86.

Thank you,

Mike.

--94eb2c1a6594993dce05697a3d25
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Greetings,<div><br></div><div>I hope i have reached the co=
rrect mailing list(referred here:=C2=A0<a href=3D"https://www.linux-kvm.org=
/page/Lists,_IRC">https://www.linux-kvm.org/page/Lists,_IRC</a>)</div><div>=
<br></div><div>I&#39;m trying to compile the KVM/ARM as a separate kernel m=
odule, just like the x86 modules. When i compile the x86 modules, i get the=
 &quot;kvm.ko&quot; and &quot;kvm-intel.ko&quot; as an output. Is there any=
 way of compiling the KVM/ARM as modules as well?<br><br></div><div>I have =
tried this approach:</div><div><div>$ make M=3Darch/arm64/kvm/</div></div><=
div><br></div><div>This does compile all of the source files to object file=
s, but doesn&#39;t create any kernel modules at the end:</div><div><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px=
 solid rgb(204,204,204);padding-left:1ex">=C2=A0 Building modules, stage 2.=
<br>=C2=A0 MODPOST 0 modules</blockquote></div><div><br></div><div>There is=
 also no option for specifying &quot;M&quot; (modular) in the menuconfig wh=
en choosing the virtualization and KVM option, like in x86.</div><div><br><=
/div><div>Thank you,</div><div><br></div><div>Mike.</div><div><br></div></d=
iv>

--94eb2c1a6594993dce05697a3d25--

--===============7933726823221746244==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7933726823221746244==--
