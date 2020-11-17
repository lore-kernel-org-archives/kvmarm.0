Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7434C5519F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:17:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 48D822467D
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:17:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="BwMpHLzz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48D822467D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F25544B8F0;
	Tue, 17 Nov 2020 13:17:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3RhYVwr2wp1E; Tue, 17 Nov 2020 13:17:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3ECA4B8F7;
	Tue, 17 Nov 2020 13:17:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D18454B559
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:17:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MtBpOs2rzrsM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:17:19 -0500 (EST)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDD2A4B79D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:17:19 -0500 (EST)
Received: by mail-qt1-f202.google.com with SMTP id m17so11855809qtu.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=E22eq9BAxEe+AO1nuitRnkTYq4b0+jwZ2QqbOY4WjS4=;
 b=BwMpHLzzaf2zH+ej4IZ+ZkIk/2jWr7L+FHUmN9hGsyCqOGOmdabExESKfOLgOuQEMx
 NHx/9YL1ICL/V6NTINPSEuafCnh+jEpymTyAt+ffdheOuo7jOJ8vS/yeL41NvksNjLOE
 x8t+7P7Bm81+jxi2AQWLRtbYG98F660Av+2v6E1SVR18iUDIbjud6M7WtnnUxBYtf4yg
 aCkEG1Nbb7InqizJzHfB0W0Noq7MOQtxHUbyYkRV8CEDKX/4SUjh+2KgSkkYcs5KTcOv
 9gcPbPB/EtvtRoo0fWhkrwKl79dMwsmHYYo8KVVxYYexbKJ9YZA/vmIK3+v8nlSTkUDs
 TWaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=E22eq9BAxEe+AO1nuitRnkTYq4b0+jwZ2QqbOY4WjS4=;
 b=cUT6kTFc1NESR7yp4oeeteeTHAiu1ENVyOeTLt7iudZQ/P12WL2HQK3DA1PqXwTO7M
 nDzfrNzm08ztbKbxglQYFV1SdTloYOmJBqoX6XLziEl/0Kj6EubIQaW+j2xAz0LPmm/H
 Sv7/KEDc68s6cbq2LJKunxzQA3gdiLVf6DnxZNdumGgwlICeIhCbmxoggRwJ8ba/KkbO
 070lHnwChyiZDicS+SER/BIDVKO76G9jR1bluaqTa7RSGAybQrOLXt8l+dhq0ALWby+w
 5k1Z7f+8stWxrch4F6zelyeG/5rxl5HIgHpaF/nkWVNIqKTxOBZ6T64S4etw5DgYJuqK
 80eQ==
X-Gm-Message-State: AOAM531528jaaTegPDzPRv85j0ruFKVJ8WgH43HX7QIpCCOkHpiyNLGC
 JziiE2NohbJfxPcrGE5yoslRjeTo7ltH
X-Google-Smtp-Source: ABdhPJz/mVc1v+qYJqOE8yeahxM0e0LR02PFTS4Ofl1niXl14opy+AyQuh/+jpD0RcsQFfuxJf4epmdjTYs2
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:ad4:53c8:: with SMTP id
 k8mr531726qvv.40.1605637039404; Tue, 17 Nov 2020 10:17:19 -0800 (PST)
Date: Tue, 17 Nov 2020 18:16:06 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-27-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 26/27] KVM: arm64: Sort the memblock regions list
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, android-kvm@google.com,
 open list <linux-kernel@vger.kernel.org>, kernel-team@android.com,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

The hypervisor will need the list of memblock regions sorted by
increasing start address to make look-ups more efficient. Make the
host do the hard work early while it is still trusted to avoid the need
for a sorting library at EL2.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/hyp/reserved_mem.c | 18 ++++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 53b01d25e7d9..ec304a5c728b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -746,6 +746,7 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 extern phys_addr_t hyp_mem_base;
 extern phys_addr_t hyp_mem_size;
 void __init reserve_kvm_hyp(void);
+void kvm_sort_memblock_regions(void);
 #else
 static inline void reserve_kvm_hyp(void) { }
 #endif
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e06c95a10dba..8160a0d12a58 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1685,6 +1685,7 @@ static int kvm_hyp_enable_protection(void)
 		return ret;
 
 	kvm_set_hyp_vector();
+	kvm_sort_memblock_regions();
 	ret = kvm_call_hyp_nvhe(__kvm_hyp_protect, hyp_mem_base, hyp_mem_size,
 				num_possible_cpus(), kern_hyp_va(per_cpu_base));
 	if (ret)
diff --git a/arch/arm64/kvm/hyp/reserved_mem.c b/arch/arm64/kvm/hyp/reserved_mem.c
index c2c0484b6211..7da8e2915c1c 100644
--- a/arch/arm64/kvm/hyp/reserved_mem.c
+++ b/arch/arm64/kvm/hyp/reserved_mem.c
@@ -6,6 +6,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/memblock.h>
+#include <linux/sort.h>
 
 #include <asm/kvm_host.h>
 
@@ -31,6 +32,23 @@ void __init early_init_dt_add_memory_hyp(u64 base, u64 size)
 	kvm_nvhe_sym(hyp_memblock_nr)++;
 }
 
+static int cmp_hyp_memblock(const void *p1, const void *p2)
+{
+	const struct hyp_memblock_region *r1 = p1;
+	const struct hyp_memblock_region *r2 = p2;
+
+	return r1->start < r2->start ? -1 : (r1->start > r2->start);
+}
+
+void kvm_sort_memblock_regions(void)
+{
+	sort(kvm_nvhe_sym(hyp_memory),
+	     kvm_nvhe_sym(hyp_memblock_nr),
+	     sizeof(struct hyp_memblock_region),
+	     cmp_hyp_memblock,
+	     NULL);
+}
+
 extern bool enable_protected_kvm;
 void __init reserve_kvm_hyp(void)
 {
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
