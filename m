Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E64F3C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 15:23:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A479C4B0DD;
	Wed,  8 Dec 2021 10:23:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n9We+6lIGRAd; Wed,  8 Dec 2021 10:23:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B3F54B16F;
	Wed,  8 Dec 2021 10:23:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A80574B166
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 10:23:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FMJwFbdIEiJh for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 10:23:13 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97B254B173
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 10:23:12 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 145-20020a1c0197000000b0032efc3eb9bcso3207764wmb.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Dec 2021 07:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=yo/eXM0M5vLhun4zn7QEhUouednn+qQj5dLApDQTa4k=;
 b=YQiiyTtUq3FaM4VAJoRYtem6jDT89osDA2RviQd2g7IHWgQJ2hB10vOD4CnqbX80AH
 Q03Kv0t3cWaNVFH1q6wRsylJ5jUi0wqfgyba5j8cMwuubV0aq//6Yx3rXFD3A7vFd+5a
 QaJSdPOTGPYL7v2/LTUouYfSPXGBXWEV6dqjmyQm6v5eRnmQFCNoPjtn5tvVgXgzaOXf
 UvQqBvOuCgat8swSkzUAV+FtJRHigg7wX2okKam46SRWE5L0r64Ce2BYha5fYY273J7A
 ULh+k1+ojzQY3CDqEKIVR7qDEtjRXHo6xmgkTRZFN2V1FPXKiL26iAIlSpweK5BIkit2
 QJrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=yo/eXM0M5vLhun4zn7QEhUouednn+qQj5dLApDQTa4k=;
 b=u7BZ3gzfWQQLxxSC12FKslEtVxfzxJnxAAkyTQy2OH6rxED+R+vkH4wCVtqm4wDf6+
 wne8JN1evwz4xdSb8NjBmMby5tGMpa/x+TbZ4AlMk10HkqkBQHjnm+Xu8LWcl/xhaIFO
 J7HN0GC8m4W6stgr/fFIs2mwqrDhZ4pafkH2Sv0xihQ6r/gbJKc8bhviz4PrCg+ITZYk
 XeEqMYpbzNTC/2njZnC3Ka/8zZYG+xGLT+OxzFmnGGsL6vcSrvb4ZVoBKF8t+XbKUrDV
 uRfwOC1YPRsuJwK41STLkHLV39EfkOdOpZqjFF7ly4BiG9Hc80CtdrvY64sf4McK7Uij
 DOnw==
X-Gm-Message-State: AOAM530+2N/LMX+SrqJn+BPvMnP4vCzhTkmwLZfhTNz2Qw4aBx8cLSa+
 ZRaux+LhsqMzbKYbuxCHNnyrZ1bNCsIb
X-Google-Smtp-Source: ABdhPJwOfjubqI7meWxcl9D37/U/vlVJzBvp2U2d2RIIBKuRn/8kPhrJIutIwFz0Y5iAUysi8gbYXfV0y2wu
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:c718:14b8:982a:57d5])
 (user=qperret job=sendgmr) by 2002:a05:6000:252:: with SMTP id
 m18mr59432350wrz.117.1638976991841; Wed, 08 Dec 2021 07:23:11 -0800 (PST)
Date: Wed,  8 Dec 2021 15:22:56 +0000
In-Reply-To: <20211208152300.2478542-1-qperret@google.com>
Message-Id: <20211208152300.2478542-4-qperret@google.com>
Mime-Version: 1.0
References: <20211208152300.2478542-1-qperret@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 3/6] KVM: arm64: Make the hyp memory pool static
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

The hyp memory pool struct is sized to fit exactly the needs of the
hypervisor stage-1 page-table allocator, so it is important it is not
used for anything else. As it is currently used only from setup.c,
reduce its visibility by marking it static.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mm.h | 1 -
 arch/arm64/kvm/hyp/nvhe/setup.c      | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index ef6a58a04235..3f60d6cc5368 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -12,7 +12,6 @@
 
 extern struct kvm_pgtable pkvm_pgtable;
 extern hyp_spinlock_t pkvm_pgd_lock;
-extern struct hyp_pool hpool;
 extern u64 __io_map_base;
 
 int hyp_create_idmap(u32 hyp_va_bits);
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 51e68a040d8a..e31149965204 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -18,7 +18,6 @@
 #include <nvhe/mm.h>
 #include <nvhe/trap_handler.h>
 
-struct hyp_pool hpool;
 unsigned long hyp_nr_cpus;
 
 #define hyp_percpu_size ((unsigned long)__per_cpu_end - \
@@ -28,6 +27,7 @@ static void *vmemmap_base;
 static void *hyp_pgt_base;
 static void *host_s2_pgt_base;
 static struct kvm_pgtable_mm_ops pkvm_pgtable_mm_ops;
+static struct hyp_pool hpool;
 
 static int divide_memory_pool(void *virt, unsigned long size)
 {
-- 
2.34.1.400.ga245620fadb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
