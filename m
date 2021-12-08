Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C02C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 15:23:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B47C4B0DD;
	Wed,  8 Dec 2021 10:23:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XUSEQ+Gt7lCo; Wed,  8 Dec 2021 10:23:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F4614B164;
	Wed,  8 Dec 2021 10:23:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E1064B0CC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 10:23:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l3qHgtIY0WBf for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 10:23:03 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE1FC4B092
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 10:23:03 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id
 b1-20020a5d6341000000b001901ddd352eso484217wrw.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Dec 2021 07:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=NpInubJayz+E5mMCFoPp/JkXWEPD0KY636+dH77jYzY=;
 b=sWT6qvXqOmH7K7TXoOYGiA18Nh0gUdABfkX0uCHIJnxMTOg1e7wyB7JBMjFKfulgoN
 j0hlSiM2TirUjxIKZ2sFR26qfAb4TcBGFwIi1EkJFbo7D/AiMhZq1uR4Uzyvs+83bCvz
 J4uKu5WJyFesIQZuevk7j0nX//st7s0ZsVzTjeXzpQ7XBCw3x02W+TQ/NuutfRLmJKe9
 lAlUGHspE6Gof3g6LS239KTXVUKSHq5AhtF0VbLmSaVTU9nyAydFCmE8Ujs9+SkQ/0dT
 Rm1/flPLSH03muMPVkRTsHLJ/u8sHWXd0uDICLfyrgrmGwsORDrow2R1fwL/eeRBy+Ve
 d6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=NpInubJayz+E5mMCFoPp/JkXWEPD0KY636+dH77jYzY=;
 b=1sI9ATcF1jk36ZOJh4F8qnakd9GhvLluuhwd2rTdCEfvdSOF8ne3euEE3PqVcx1DAu
 YeNyhfAmSLMVgLA+d7BMOhIJ1jLSSzU6AOyJCL2l9WPNJJoAfvzpz3g3aybQJ52tvAdP
 Xkn3VTr7sU85FLqw3QCNNUBoD5I+2QKueajI3zLAIK3czn70lmGpBGVL2ic67p5trX8I
 NGc/0R0x20oUOaL4BEklYOi3zJeHZfgNH043QSq1Itb35r5mVBfWj5uJnoSkRiiiVHGE
 j4mUtoxQhncYNmI+tMsLn2IxfO7gkPle5XZSVb0h5iDKf+tB6Y2g9U1QS44INB4gAzo3
 BcvQ==
X-Gm-Message-State: AOAM530uL4s4uO1H5cdj/Gdlw6p5wOVpYwaouPSKb/1JO+DG1g2Qw0ib
 dtRYAsHxz8FeVDDpkkKLqDmpHjwmqMlX
X-Google-Smtp-Source: ABdhPJw2Q7y7Jx3kkG65Al++LQjZ/5cO1Syp+7Mi+yj+MVYxM7EetMdMtJVWeVSbFWR53AYbWIsx0Mc0l9C0
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:c718:14b8:982a:57d5])
 (user=qperret job=sendgmr) by 2002:a05:6000:23a:: with SMTP id
 l26mr59842390wrz.215.1638976982501; Wed, 08 Dec 2021 07:23:02 -0800 (PST)
Date: Wed,  8 Dec 2021 15:22:53 +0000
Message-Id: <20211208152300.2478542-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 0/6] KVM: arm64: Miscellaneous pkvm fixes
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi all,

This series is a collection of various fixes and cleanups for KVM/arm64
when running in nVHE protected mode. The first two patches are real
fixes/improvements, the following two are minor cleanups, and the last
two help satisfy my paranoia so they're certainly optional.

Cheers!
Quentin

Quentin Perret (6):
  KVM: arm64: pkvm: Fix hyp_pool max order
  KVM: arm64: pkvm: Disable GICv2 support
  KVM: arm64: Make the hyp memory pool static
  KVM: arm64: Make __io_map_base static
  KVM: arm64: pkvm: Stub io map functions
  KVM: arm64: pkvm: Make kvm_host_owns_hyp_mappings() robust to VHE

 arch/arm64/kvm/hyp/include/nvhe/mm.h | 2 --
 arch/arm64/kvm/hyp/nvhe/mm.c         | 3 ++-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c | 2 +-
 arch/arm64/kvm/hyp/nvhe/setup.c      | 2 +-
 arch/arm64/kvm/mmu.c                 | 9 +++++++++
 arch/arm64/kvm/vgic/vgic-v2.c        | 5 +++++
 arch/arm64/kvm/vgic/vgic-v3.c        | 2 +-
 7 files changed, 19 insertions(+), 6 deletions(-)

-- 
2.34.1.400.ga245620fadb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
