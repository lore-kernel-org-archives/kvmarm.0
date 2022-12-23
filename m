Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D999C4167B
	for <kvmarm@archiver.kernel.org>; Mon, 26 Dec 2022 10:26:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1B324BD42;
	Mon, 26 Dec 2022 05:26:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4dMsLBT8MiiY; Mon, 26 Dec 2022 05:26:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C34044BD2A;
	Mon, 26 Dec 2022 05:26:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF28A4BA1C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Dec 2022 06:33:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YJcjkmZPbniT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Dec 2022 06:33:47 -0500 (EST)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com
 [209.85.210.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6FB94B6E2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Dec 2022 06:33:47 -0500 (EST)
Received: by mail-ot1-f50.google.com with SMTP id
 m7-20020a9d6447000000b0066da0504b5eso2664166otl.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Dec 2022 03:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
 :date:message-id:reply-to;
 bh=EQnYO4PiPLXsbPjrfHHcGTpj54VVcn7Hj6rlJO6w9I0=;
 b=pquck8qNf4x2zgclF8yEOoE1hOzd923y2v0tEsUZbcKPBTs6oR6FzakPMf8GMeohuA
 QFpDBdDcJobNk7puKr5SZHH0AtJBSc31/RRCLTQv3BgZRny4nkzrXwKWEjPARWBYbchk
 TrsRL4T1cq+13hhty1bPzHegI3fTp1ff19/x7nVgzt8Nyday4/T8FKcnmrIvt2tJasO5
 oa0fYiGeTmw93kRs9vDMXUtyX/JBg+txxHrG17koNGdoqSHEtGVoO4YycOZPBIFt0Qon
 q+JXteNaQIyIHgmjc1Tm0VFkXSuK1UI8JlI9s1fFNQRwmobIMGndGWuEWk5u1iJ03GhF
 QWrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=to:subject:message-id:date:from:mime-version:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=EQnYO4PiPLXsbPjrfHHcGTpj54VVcn7Hj6rlJO6w9I0=;
 b=BapTBCinMEu4Kracv5emOYpPQpS1x+xfL6AVNykX7XwUC2Wkvr83CYsCM/3lr13BDl
 zXeGXGV2w9whH7NCK9C+BrS5hEJ+lNdF4s2UqLv6Y0QAon/nubRPTACQ2SujDizVtxZU
 PXdh/ejV0/tWQ37S25Dbe64z10j0tdQBp3f1d8sYBzkOqVdxgOrcTLRifaipLovNLIYf
 9ANu6q36X5KhVkRdfrjHFkqWyuncYXXv79bSuvTV3GVBkBSFdecq5C8heRGZjMHuu4mr
 vuOckZILxyGEqXiSWmmO2bjsHV5CVaF8QyQt0u3MVSXotk3ZCkLrCkiN8z2XMbwSeoiB
 nkyA==
X-Gm-Message-State: AFqh2kpTAOUl4NWIaa3/Wg9MIPdVr1RSA7gJkzK6jTesiNizhCoNHw00
 ibpz1SVHVUFTBE/kCPtlrCJabfL5RNCD5Y+iY0hiP1oNhfKTOA==
X-Google-Smtp-Source: AMrXdXv0Bl1NAZ8RwANgMgq7IvDDQ2YTx4PrdYC0orDg3SxX7lnHDI3d8+bMiKhnwJewdlNVSnX6mPcONdiF+8gaUus=
X-Received: by 2002:a05:6830:2049:b0:672:6b44:379c with SMTP id
 f9-20020a056830204900b006726b44379cmr559558otp.169.1671795226767; Fri, 23 Dec
 2022 03:33:46 -0800 (PST)
MIME-Version: 1.0
From: Sandeep Gupta <gupta.sandeep@gmail.com>
Date: Fri, 23 Dec 2022 17:03:35 +0530
Message-ID: <CAAywg7srFJg6-J0B-ny0xyx8itpbb_MoLC+07Fo56RsyyxdsAQ@mail.gmail.com>
Subject: running openbsd on KVM running on fedora over raspberry pi 4
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Mon, 26 Dec 2022 05:26:54 -0500
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8274649584322525162=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============8274649584322525162==
Content-Type: multipart/alternative; boundary="000000000000a0f74305f07d2855"

--000000000000a0f74305f07d2855
Content-Type: text/plain; charset="UTF-8"

I am trying to run openbsd as guest OS.
I am using this command to create the vm
```

virt-install --name openbsd1 --ram 2048 --vcpus 2 --disk
path=/var/lib/libvirt/images/openbsd1.qcow2,format=qcow2,bus=virtio,size=20
 --disk path=/tmp/install72.img --import --os-variant openbsd7.0
--network=default --noautoconsole

```
But, on boot the server is not picking up the openbsd boot sequence.

I have posted the question here as well (
https://serverfault.com/questions/1118710/install-openbsd-as-guest-os-in-kvm-virtualization-on-fedora-running-raspberry-pi
).
Any pointers would be of great help,
Thanks
Sandeep

--000000000000a0f74305f07d2855
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I am trying to run openbsd as guest OS. <br></div><di=
v>I am using this command to create the vm <br></div><div>```</div><div><pr=
e><code>virt-install --name openbsd1 --ram 2048 --vcpus 2 --disk path=3D/va=
r/lib/libvirt/images/openbsd1.qcow2,format=3Dqcow2,bus=3Dvirtio,size=3D20  =
--disk path=3D/tmp/install72.img --import --os-variant openbsd7.0 --network=
=3Ddefault --noautoconsole</code></pre></div><div>```<br></div><div>But, on=
 boot the server is not picking up the openbsd boot sequence. <br></div><di=
v><br></div><div>I have posted the question here as well (<a href=3D"https:=
//serverfault.com/questions/1118710/install-openbsd-as-guest-os-in-kvm-virt=
ualization-on-fedora-running-raspberry-pi">https://serverfault.com/question=
s/1118710/install-openbsd-as-guest-os-in-kvm-virtualization-on-fedora-runni=
ng-raspberry-pi</a>).=C2=A0</div><div>Any pointers would be of great help,<=
/div><div>Thanks</div><div>Sandeep</div><div><br></div><div><br></div></div=
>

--000000000000a0f74305f07d2855--

--===============8274649584322525162==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8274649584322525162==--
