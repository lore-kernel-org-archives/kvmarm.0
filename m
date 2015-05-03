From: =?UTF-8?B?5a2Z5pmT6Ziz?= <sxy.winner@gmail.com>
Subject: some questions about system calls in KVM/ARM
Date: Sun, 3 May 2015 11:37:29 +0800
Message-ID: <CAJoe4kjEDbCwBSgSamB7RW+fYYhXO2FfvMB3JDJppV-DZ+jhGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4503753335898228240=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BA4A4F6B7
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 May 2015 23:28:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vIAdcY8hPhRP for <kvmarm@lists.cs.columbia.edu>;
 Sat,  2 May 2015 23:28:52 -0400 (EDT)
Received: from mail-lb0-f170.google.com (mail-lb0-f170.google.com
 [209.85.217.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B1664F5D1
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 May 2015 23:28:51 -0400 (EDT)
Received: by lbbqq2 with SMTP id qq2so85700253lbb.3
 for <kvmarm@lists.cs.columbia.edu>; Sat, 02 May 2015 20:37:29 -0700 (PDT)
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

--===============4503753335898228240==
Content-Type: multipart/alternative; boundary=001a11c34b4e2f7eda0515252a10

--001a11c34b4e2f7eda0515252a10
Content-Type: text/plain; charset=UTF-8

Hello,
I am intersted in KVM/ARM and I am trying to do some work based on KVM/ARM.
But here is some questions :
1. if I set HCR.TGE=1, does the system calls will traps into hyp mode and
be handled by hyp_svc( arch/arm/kvm/interrupts.S)?
2. How can I get Guest OS's system call's number and address while issuing
swi instruction in Guest OS usr mode and trapped into Hyp mode?

Thank you very much!
Have a fine day!

Send from xiaoyangsun

--001a11c34b4e2f7eda0515252a10
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div class=3D"gmail_signature"><div dir=3D"ltr"><div =
dir=3D"ltr"><div>Hello,<br></div><div><div>I am intersted in KVM/ARM and I =
am trying to do some work based on KVM/ARM.</div><div>But here is some ques=
tions :</div><div>1. if I set HCR.TGE=3D1, does the system calls will traps=
 into hyp mode and be handled by hyp_svc( arch/arm/kvm/interrupts.S)?</div>=
<div>2. How can I get Guest OS&#39;s system call&#39;s number and address w=
hile issuing swi instruction in Guest OS usr mode and trapped into Hyp mode=
?</div></div><div><br></div><div>Thank you very much!</div><div>Have a fine=
 day!</div><div><br></div><div>Send from xiaoyangsun</div></div></div></div=
></div>
</div>

--001a11c34b4e2f7eda0515252a10--

--===============4503753335898228240==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4503753335898228240==--
