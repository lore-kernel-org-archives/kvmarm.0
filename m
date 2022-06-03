Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 572B3C43334
	for <kvmarm@archiver.kernel.org>; Sat,  4 Jun 2022 08:02:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C95554B321;
	Sat,  4 Jun 2022 04:02:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dbUKPHrwmTus; Sat,  4 Jun 2022 04:02:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63B694B2E5;
	Sat,  4 Jun 2022 04:02:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31B5D4B0DF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2022 23:42:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nztN7cgYQ05q for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jun 2022 23:42:04 -0400 (EDT)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com
 [209.85.215.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 279694B0C0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2022 23:42:04 -0400 (EDT)
Received: by mail-pg1-f182.google.com with SMTP id g184so6316859pgc.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jun 2022 20:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:from:date:message-id:subject:to;
 bh=F1sWw2zEV2XOw0f1Ov9d+nL/zpQLjvGHbO68knQ3RsY=;
 b=m2Al+sICmmZmyeavHnSK4v4FI1cf0ntQHru4pMdbdxfLvL7GFvK6TTTYjeHPBLN63m
 ef3g0XhvyQYGZIWtj3/AhSFYXKMWRRIPmXJPLj72m5nKB0aCluIJS43h36DLPzroIwmC
 cbCSuTyOug2I3MKU4sbc5mezypOt7zyvWlm5ynazDncnUuO/kN1dlEaiXxJfm1bBu5gR
 txgeoTjxFQ/XX9Adg+hmnUp4UnMMi7741TrLalf7+UyeYHeGRu9v46Y3slWb/NrBu1om
 PW5jrcPG9gmx/0fOFP5CyU17owUiimOc5ZzIaERbz9TarYXJ9h/lkarT1YV98Y9tYjWS
 ffew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
 bh=F1sWw2zEV2XOw0f1Ov9d+nL/zpQLjvGHbO68knQ3RsY=;
 b=X09JOVeUc3i2iKoKVDLPsp74IfeMbC2d7JqbE1WtS7bc9VW3WlUSxszldk8fGznblK
 DMrwwa9PyAGSL/MVJr5wyqYzpajA1/8UfaVpo4mKAqfFeTiMkpa/COjMV2jpWGxPHDIx
 u3uuY1pPEwODwePHFpQJmTWPpTuMmUW/rgVoL/FfsetcO4P2tdb1kKIfiU9Fe3Lnh/g8
 tzRfJBzKNlJS4IYUZhVpDLp+nW3kde17O9dCeVUFwbgp0DBURpfODWw7AuKVJNQ4Vu7G
 6LkY6AnOtr1WxMIBMZo7I0a7CpQQ2KDXgAXgJ20ZxlSE0xAVhFZcdLygRwnAk2VUoiUN
 6q8g==
X-Gm-Message-State: AOAM530ga4jtFoSgjNHgMexzJJ+6LeBDW0zXZOZ7hP/xLyb1pjzySweR
 Tn2qa9esLhndRztbidlN4xQQ2PT8TpqnE2+xHbFqSTuR
X-Google-Smtp-Source: ABdhPJz4e5KhxwVs4e4CH/XDbnlJEy2nIC4KVAJQCVO08AefRuRsfPHa2nmNm8pmphAz2Z5r7y4VPSofoCE+w07QZcQ=
X-Received: by 2002:a62:d40c:0:b0:51b:bc02:703b with SMTP id
 a12-20020a62d40c000000b0051bbc02703bmr8257891pfh.65.1654227722736; Thu, 02
 Jun 2022 20:42:02 -0700 (PDT)
MIME-Version: 1.0
From: Ivan Masum <heromasum@gmail.com>
Date: Fri, 3 Jun 2022 09:41:50 +0600
Message-ID: <CAEVNJ6vPN1nv1ec2r_SupYaKR6o0prgaO765y2W1Ltf+SMDwBw@mail.gmail.com>
Subject: Need to run kvm/qemu on ARM
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Sat, 04 Jun 2022 04:02:12 -0400
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
Content-Type: multipart/mixed; boundary="===============4503894981921396558=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============4503894981921396558==
Content-Type: multipart/alternative; boundary="000000000000ca9b0105e082e75d"

--000000000000ca9b0105e082e75d
Content-Type: text/plain; charset="UTF-8"

Hello team,
I am a new fee in linux. Recently i am using oracle cloud free tier with
4core 24gb ram. I am learning Devops. So i need many virtual machine. How
do i easily install kvm or qemu on arm machine while oracle not suppot
virtualization?
I whould like to hear the solution from you. Morover how do i contact with
you in quick chat?

Thanks in advance
Masum

--000000000000ca9b0105e082e75d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Hello team,<div dir=3D"auto">I am a new fee in linux. Rec=
ently i am using oracle cloud free tier with 4core 24gb ram. I am learning =
Devops. So i need many virtual machine. How do i easily install kvm or qemu=
 on arm machine while oracle not suppot virtualization?</div><div dir=3D"au=
to">I whould like to hear the solution from you. Morover how do i contact w=
ith you in quick chat?</div><div dir=3D"auto"><br></div><div dir=3D"auto">T=
hanks in advance</div><div dir=3D"auto">Masum</div></div>

--000000000000ca9b0105e082e75d--

--===============4503894981921396558==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4503894981921396558==--
