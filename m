Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 783F9C433F5
	for <kvmarm@archiver.kernel.org>; Sun, 12 Dec 2021 19:52:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C64574B10D;
	Sun, 12 Dec 2021 14:52:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Yl7FD7E0Ppyc; Sun, 12 Dec 2021 14:52:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87C0A4B091;
	Sun, 12 Dec 2021 14:52:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0094B49DE3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 Dec 2021 14:52:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KBxP2ktBY86B for <kvmarm@lists.cs.columbia.edu>;
 Sun, 12 Dec 2021 14:52:56 -0500 (EST)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com
 [209.85.167.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAAE24086C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 Dec 2021 14:52:55 -0500 (EST)
Received: by mail-lf1-f42.google.com with SMTP id m6so15486796lfu.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 Dec 2021 11:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:from:date:message-id:subject:to;
 bh=ELHrZbYt53oTevUkoqbrx3o1FXXAv+CjynMqBFJu08A=;
 b=DAmyX23fvyovqjzJ33sH6A6XbfV7c6JTifRbAJLTljtLkA8wwyp9DFzmxX+HPYfqte
 8x7YhlcKM+iPoWWXimJU2sEXijetqvdTsult+Kv3mRfWNac2KHoxmEvCa/bXwgOfMz+P
 xmzNgizBXq5iK9HfIXpSFmCwgdf9d2/vF1CQ+YpP90WVoMSzTSgMj1jwYoEgogXTCSjD
 50gkn8/C+RGzmzkIwEGsSKKOdXWiRwg/M4r4t48bN11iOfLc5yOGVDpkzFos4yziUxEz
 f+0JK8f2RvQP5oVq0UG2rKRdlgnoMdDJ/PgXRnAsa33+xiPuzZumA7BRtWzfAniHKHkz
 QAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
 bh=ELHrZbYt53oTevUkoqbrx3o1FXXAv+CjynMqBFJu08A=;
 b=bRA8Ze48ey9Rv2fZH9GRBQLvDNK8MNR8JzroDbOJvHzX9HnIchSXDpF7sCKMHpz4OV
 yObIs8PTnyZLFbisfTecMaIuGDqw5KBzrTG0A/aknYRial62OhVtgi0t8bd86CNl+bhI
 VNJRzda9SRp7NnRKmzE6fk1WOCa1fwnNX5CiABRYArdBOuSjmlbxMwJRPHTw4nfEEGSY
 pGpFS8s3KBLKsKo/gE7K1TwEjCFwdJz5yNY5dVssNFEMygEbQvXUkWPlJC3bm73VFuDK
 yarLcm28QNesoBVtwmbRNQ1svA44NMO8AY/A4ElpVl4oNxb+AFzEf2UoykIvOyoNySPX
 8IsQ==
X-Gm-Message-State: AOAM531jXoD5I8NxEttwvYez/pETvbQpAbbigf4IPFsTxfaAyvZAcM4p
 6U9oRRM8LbIQeiqEJr0dIA0tX8n6YpIWtNT1s8wEV54M
X-Google-Smtp-Source: ABdhPJzniqlnfK4JpuGor3oyXZ3f4Zrp9llp4mnZlYPXU8NNnTN5lbvBO3jaOOsMyKVC4IWa/9M42M/I8ZIK3EwnnCs=
X-Received: by 2002:a05:6512:4017:: with SMTP id
 br23mr24632257lfb.270.1639338774513; 
 Sun, 12 Dec 2021 11:52:54 -0800 (PST)
MIME-Version: 1.0
From: Chenxu Wang <irakatz51@gmail.com>
Date: Mon, 13 Dec 2021 03:52:41 +0800
Message-ID: <CAFLP=uDtS9fyg4nmA_tXx5dMWDMoT=ABZk_tRLyQS_toxUxZ-A@mail.gmail.com>
Subject: Some problems about TZASC configuration
To: kvmarm@lists.cs.columbia.edu
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
Content-Type: multipart/mixed; boundary="===============1771324524935630191=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============1771324524935630191==
Content-Type: multipart/alternative; boundary="000000000000524ca005d2f84d6a"

--000000000000524ca005d2f84d6a
Content-Type: text/plain; charset="UTF-8"

Hi all,

I have some problems about KVM+QEMU when it runs on a FVP with TZASC and
VHE enabled.

If I configure some DRAM region as "secure only", will KVM generate some
fault (e.g. SError) when creating a VM?

If yes, can we avoid it by restricting the physical memory region for
creating a VM?

For example, I configure 0xa0000000-0xafffffff as secure only, then i ask
KVM to create VMs in region 0x90000000-0x9fffffff, so no overlap between
them.

Sincerly,
Wang

--000000000000524ca005d2f84d6a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Hi all,<div dir=3D"auto"><br><div dir=3D"auto">I have som=
e problems about KVM+QEMU when it runs on a FVP with TZASC and VHE enabled.=
</div><div dir=3D"auto"><br><div dir=3D"auto">If I configure some DRAM regi=
on as &quot;secure only&quot;, will KVM generate some fault (e.g. SError) w=
hen creating a VM?</div><div dir=3D"auto"><br></div><div dir=3D"auto">If ye=
s, can we avoid it by restricting the physical memory region for creating a=
 VM?</div><div dir=3D"auto"><br></div><div dir=3D"auto">For example, I conf=
igure 0xa0000000-0xafffffff as secure only, then i ask KVM to create VMs in=
 region 0x90000000-0x9fffffff, so no overlap between them.</div><div dir=3D=
"auto"><br></div><div dir=3D"auto">Sincerly,</div><div dir=3D"auto">Wang</d=
iv><div dir=3D"auto"><br></div></div></div></div>

--000000000000524ca005d2f84d6a--

--===============1771324524935630191==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1771324524935630191==--
