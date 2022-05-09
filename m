Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A300C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 12:03:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A091A4B2D8;
	Mon,  9 May 2022 08:03:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JGL40g0XerDR; Mon,  9 May 2022 08:03:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87B9A4B2EB;
	Mon,  9 May 2022 08:03:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE1454B2D6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 08:03:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id go7IcULrY4tM for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 08:03:33 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 861FC4A36B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 08:03:33 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 t184-20020a1c46c1000000b00394209f54f1so4174964wma.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 05:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=YMy3zUpcEva0SvcO2znuocWV4BxelK38M/0ZkCce1/o=;
 b=oyRENR29svxIjW8y0bn+9l+tm6uheonymddtzfMmxTQpEIOXTLEhsuDoJurbpf9Dql
 dX3+CwctEskmdnCkpWbD3x+1cOCMMte1IwsfWGd53lKCUL6prr6o2eO6fgLqnv16iwQX
 03jm0KF1s2/1JIqWRQm1cR6ruBfPMEtdBYU0Ye/1SZz8wWylHr73VrdvoCABDqeqEnjG
 J1LRR+rigz8Xa/Mpw4+E7EeCPWUg0QwYmRtQeDPJWdowSTH5OkzzWakvbhe1mTXevgkq
 /yavFDETEWOjUksc0HO+mBofLP0O/IerslGWCVmwI3nU2bEgoQ0q+rwK1avmEpeohVQb
 rZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=YMy3zUpcEva0SvcO2znuocWV4BxelK38M/0ZkCce1/o=;
 b=SKpo6xEqMC0HYj8ZxUDSbqkSt/GMoNOI0AI9ASlRqJpPI7zx+lJrvSkt4xr5u89Z0t
 eeG/Q4Wq8Oo2vdLxEVn39h1kBFPVmfhWZEOl07bOENexSjhrIcwliZ+beFUJOIpyLNKV
 WCF3Tbb3inb3afQp3b06FYZwnjsKsQ/OKHeO04ooAwDpFSnO35cLhaCiDuP4TOzmCvgl
 W6d5aG5x4bZKjcUvgD8ATnKpnxglH9nzlWFNhZRCy2sMvXriz+EYOi48BPNumOXHjMIH
 F0Hs+Z4JkGaIxd/kWxaqxYb16P+S6baDtMJoOEh49ndXcYDdVDwar9VnSwZEo/ZfFZpu
 YMWg==
X-Gm-Message-State: AOAM531Ia20zxGDjzHfQzIXb8513gYte25gvK2dirjYPcn6xkqsc4eDk
 KMxIF3+OmpyL2Cvpct95h7Fxj+QGUTjd+UUoLtjOya5b05fpYR0/hPEBdNhz3GZLu2Eqk1G1cpZ
 xENJBqXwBERSfpz+RBBu4UP577uGxn73nC79nbHLUhL+lDntyp34wCMnfWpfjTlDcFpw=
X-Google-Smtp-Source: ABdhPJx2gD40Jlpp+yqprlC3izQ6s8s7DSQKi5Tj7o72c7gpbpuKKc4mcoYD/msXCfnOYCYanpxgCuZG6g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:f58e:0:b0:20a:dfc8:f894 with
 SMTP id
 f14-20020adff58e000000b0020adfc8f894mr13461869wro.428.1652097812108; Mon, 09
 May 2022 05:03:32 -0700 (PDT)
Date: Mon,  9 May 2022 12:03:26 +0000
Message-Id: <20220509120330.3043773-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 0/4] KVM: arm64: Do not communicate host pmu event changes
 by accessing hyp data
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Hi,

This series changes the way KVM communicates host pmu event changes to the
hypervisor in nvhe and protected mode. Instead of accessing hyp data directly
from the host, the data is passed to hyp via the loaded vcpu. This provides
more isolation between the host and the hypervisor, and allows us to use pmu in
protected mode.

This series is based on kvmarm/next (8c22fd2d4cfa).

Changes since V2 [1]:
- Update the guest view of the pmu events after interrupts have been disabled

Changes since V1 [2]:
- Repack struct kvm_pmu to remove all (two) holes
- Updating the guest's view of the pmu events before every vcpu run rather than
vcpu load to avoid missing updates

Thanks,
/fuad

[1] https://lore.kernel.org/all/20220509095500.2408785-1-tabba@google.com/
[2] https://lore.kernel.org/linux-arm-kernel/20220408084052.3310931-1-tabba@google.com/

Fuad Tabba (4):
  KVM: arm64: Wrapper for getting pmu_events
  KVM: arm64: Repack struct kvm_pmu to reduce size
  KVM: arm64: Pass pmu events to hyp via vcpu
  KVM: arm64: Reenable pmu in Protected Mode

 arch/arm64/include/asm/kvm_host.h |  8 ++-----
 arch/arm64/kvm/arm.c              | 15 ++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c  | 20 +++++-----------
 arch/arm64/kvm/pmu-emul.c         |  3 +--
 arch/arm64/kvm/pmu.c              | 40 ++++++++++++++++++-------------
 include/kvm/arm_pmu.h             | 10 ++++++--
 6 files changed, 55 insertions(+), 41 deletions(-)


base-commit: 8c22fd2d4cfaab2ae3c5859496c894df58ab014b
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
