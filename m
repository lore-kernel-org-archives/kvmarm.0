Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D847C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 15:23:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E078A4B174;
	Wed,  8 Dec 2021 10:23:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NR90c5n4nyBk; Wed,  8 Dec 2021 10:23:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC69C4B186;
	Wed,  8 Dec 2021 10:23:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DF654B0DD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 10:23:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MJttwNcla0gb for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 10:23:15 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8994D4B166
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 10:23:15 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 201-20020a1c04d2000000b003335bf8075fso1483217wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Dec 2021 07:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=dgTcer4H5x2V6vg1108kd2kvmSCOK/fdrPt0IEA/yAc=;
 b=OO++pgN0LQkRixb3Sq7Hd5w4QXWKTHU22mu8fVnumx/eTq9CxL7X2F8nL4x04jkISf
 kipUAI4bu44wE9v5DHK56LMB2no0ObvfG7M8kGv5bzcym0vpdnDAJ8Lk4yq+49UtdWo3
 bZ8yP9xdUCTiHdkctcvrwAgccOD0TBjeYFZucZKb836bHeZhaqsMS2NSKTW1g1P7/re0
 9AgPiRniaapcw/g+FhGxeT0goa83px619Dqwd1v+txQWUZTOE5sF8onQT6zmISmitbWL
 81NrTCgrmHgZ5NfFOREPevSqkUNFg6S1AEJOfg+NXVGsl4K9TjJThlPj455oD1dIYaT3
 +3JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=dgTcer4H5x2V6vg1108kd2kvmSCOK/fdrPt0IEA/yAc=;
 b=Vh8FtUWmJOut/5hHzdRdel9McWGvs7nl6bSY/ySirbSvt93TR8uoYThdFNTdeRpZVx
 ZfosweYyDekpbbtg7kUTwkTIFQ/uVtGGzbMDXkKcotOIFdVCDmlQtUMBwWEwB/6h6SmW
 dSd5GbWHMzxUWzi7P65H1hs7AuPMX/CyjindZtYkYIzBdlGtRLUVwvOwKJ3u3qckHCZb
 b9u9dMUyS9fzQby+OfDDQAMWCMj+c9qSr+7fkHXewg6vcfYpWoofjRQ8dzFGmCCue+k7
 HKMPxDPW+5rTiUYdw/zz9emtBfKWlq9MXrfNCkywpaHiDZml8tmSd3Gd0F9v1F7d8EJo
 wyBw==
X-Gm-Message-State: AOAM532JUCVOTYWlMUUCG5StyINGL75y7qnmoG790FCdDFQYuwkwYNYA
 gFUIusrLqCvrcDAZorIeUaOu2i2kIbsi
X-Google-Smtp-Source: ABdhPJzw57yyhlFRsGBdsMP0b1MuPYqG3wH3zEnWZDUhTXBl2eHsIR7+DocFx3KMxHXiRp33Wa8qily/O8bz
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:c718:14b8:982a:57d5])
 (user=qperret job=sendgmr) by 2002:a7b:c407:: with SMTP id
 k7mr16929430wmi.35.1638976994756; Wed, 08 Dec 2021 07:23:14 -0800 (PST)
Date: Wed,  8 Dec 2021 15:22:57 +0000
In-Reply-To: <20211208152300.2478542-1-qperret@google.com>
Message-Id: <20211208152300.2478542-5-qperret@google.com>
Mime-Version: 1.0
References: <20211208152300.2478542-1-qperret@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 4/6] KVM: arm64: Make __io_map_base static
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

The __io_map_base variable is used at EL2 to track the end of the
hypervisor's "private" VA range in nVHE protected mode. However it
doesn't need to be used outside of mm.c, so let's make it static to keep
all the hyp VA allocation logic in one place.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mm.h | 1 -
 arch/arm64/kvm/hyp/nvhe/mm.c         | 3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 3f60d6cc5368..2d08510c6cc1 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -12,7 +12,6 @@
 
 extern struct kvm_pgtable pkvm_pgtable;
 extern hyp_spinlock_t pkvm_pgd_lock;
-extern u64 __io_map_base;
 
 int hyp_create_idmap(u32 hyp_va_bits);
 int hyp_map_vectors(void);
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 9e0ff5a700dd..526a7d6fa86f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -19,11 +19,12 @@
 
 struct kvm_pgtable pkvm_pgtable;
 hyp_spinlock_t pkvm_pgd_lock;
-u64 __io_map_base;
 
 struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
 unsigned int hyp_memblock_nr;
 
+static u64 __io_map_base;
+
 static int __pkvm_create_mappings(unsigned long start, unsigned long size,
 				  unsigned long phys, enum kvm_pgtable_prot prot)
 {
-- 
2.34.1.400.ga245620fadb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
