From: Miriam Zimmerman <mutexlox@google.com>
Subject: Timekeeping on ARM guests/hosts
Date: Tue, 9 Oct 2018 16:39:37 -0700
Message-ID: <CAHSjozDb2_q9YgHsEerH_-2uc6S9W-cw_p2hTiafisQUTrwH6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1689597210909701419=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4F374A257
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Oct 2018 19:39:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WTjO1glBFIZB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Oct 2018 19:39:49 -0400 (EDT)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com
 [209.85.210.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8F954A213
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Oct 2018 19:39:49 -0400 (EDT)
Received: by mail-ot1-f52.google.com with SMTP id q50so3550461otd.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Oct 2018 16:39:49 -0700 (PDT)
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

--===============1689597210909701419==
Content-Type: multipart/alternative; boundary="000000000000dc3f1d0577d44094"

--000000000000dc3f1d0577d44094
Content-Type: text/plain; charset="UTF-8"

Hi,

I'm working with an ARM device hosting an ARM guest. When the host is
suspended, guest time stops advancing and it doesn't get adjusted on resume.

For an x86 machine, the CONFIG_KVM_GUEST flag would enable paravirt for
time and fix this problem, but CONFIG_KVM_GUEST isn't available on ARM.

Is there a configuration option to enable paravirtualized timekeeping on
ARM? If not, how can I configure ARM guests to handle timekeeping properly?

Thanks,
Miriam

--000000000000dc3f1d0577d44094
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>I&#39;m working with an ARM device =
hosting an ARM guest. When the host is suspended, guest time stops advancin=
g and it doesn&#39;t get adjusted on resume.</div><div><br>For an x86 machi=
ne, the CONFIG_KVM_GUEST flag would enable paravirt for time and fix this p=
roblem, but CONFIG_KVM_GUEST isn&#39;t available on ARM.</div><div><br>Is t=
here a configuration option to enable paravirtualized timekeeping on ARM? I=
f not, how can I configure ARM guests to handle timekeeping properly?</div>=
<div><br></div><div>Thanks,<br>Miriam</div></div>

--000000000000dc3f1d0577d44094--

--===============1689597210909701419==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1689597210909701419==--
