Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E761C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:58:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E73E0611AD
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:58:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E73E0611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ACAB4B101;
	Wed, 13 Oct 2021 11:58:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A1WX5Q0rKMW5; Wed, 13 Oct 2021 11:58:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5797C4A19A;
	Wed, 13 Oct 2021 11:58:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E521A4B10D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6Rd7d0Rpp+dv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 11:58:46 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5D4B4B129
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:46 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 y12-20020a056000168c00b00160da4de2c7so2365784wrd.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=IlppRzT2DJMrjLyWXcFQhFnQfQR5lo6YirruXy6B+jE=;
 b=nLb2GxvnfmXRJusIRGDcK6nXA+5x5AmJGRR/V/LcoUNSbMrUd2NrmL4MufI+g0eTha
 q40ku9MEJqdlYAse4Z0er9MkTvhAtXgjqPtL43Viv98eJ0NYC8Uk+HgyWvkrEpJtMYoE
 Xldub+P2soQLFdZpz8ZTsw98lRBLzdRbvDbSwdieMx8jJlopirtZXpI95UsWuokp+D9c
 hasKRs/Cqe5gS9o+94sYPs57ne89Dy5HA0+DSHQZBjSdmo227xvtSOXCHAls/UKcxA5Z
 JRCo2jkMOmfMNHEHIjOpjU1K+CD+a2tH2JsmQHBdoKCakqEJrwXRI8YWDyQMkf2b1dYc
 BcZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=IlppRzT2DJMrjLyWXcFQhFnQfQR5lo6YirruXy6B+jE=;
 b=B2Df55W5+bb0+e2sArB3WxSyfgZ5X4Rk27stzIaskPA+fUfFuffHiUyubVPG9xSSp9
 xebhLxDdhxUtJ6215+A3QU+BBST3X+FNCGTSL9yxGna0lJqHDPByj1HCKUX06UjqFKQM
 dYZwE/aSu0krbOoj0lGYJjvKu1v0kVtX9axYg3DSG57lsPFug/oleDpy9aSZelQDPUTg
 YxK68lQpL3Pdp6vgtFQ+S69MA9T06JmItwj3s5APge36W/vKYeOQUs7ghHY4lrjrSku1
 rtzhL1zJEWHEIR/cy6cebqCALtlmOUmF3Ip7tWJUt3da1e4oYJbMld+Sh9aVDzoAX45j
 fRiw==
X-Gm-Message-State: AOAM532DGM6e3WBnO0TCatTUGeN7w8GJhheu5jidi4XRGoMzTBu2a8tP
 o7yEMIVmfsO5VL57355OWxSBvOYwRrJI
X-Google-Smtp-Source: ABdhPJwoSI8DhPOgPzSbFVEj9YWz/nO03TgjiiCueH7HBTZaJedxiWCr2dApRk0NjeO38ALucY7P+geJyNYC
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:65b5:73d3:1558:b9ae])
 (user=qperret job=sendgmr) by 2002:a05:600c:1c05:: with SMTP id
 j5mr142004wms.1.1634140725692; Wed, 13 Oct 2021 08:58:45 -0700 (PDT)
Date: Wed, 13 Oct 2021 16:58:20 +0100
In-Reply-To: <20211013155831.943476-1-qperret@google.com>
Message-Id: <20211013155831.943476-6-qperret@google.com>
Mime-Version: 1.0
References: <20211013155831.943476-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 05/16] KVM: arm64: Accept page ranges in pkvm share hypercall
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, David Brazdil <dbrazdil@google.com>
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

The recently reworked do_share() infrastructure for the nVHE protected
mode allows to transition the state of a range of pages 'atomically'.
This is preferable over single-page sharing when e.g. mapping guest
vCPUs in the hypervisor stage-1 as the permission checks and page-table
modifications for the entire range are done in a single critical
section. This means there is no need for the host the handle e.g. only
half of a vCPU being successfully shared with the hypervisor.

So, make use of that feature in the __pkvm_host_share_hyp() hypercall by
allowing to specify a pfn range.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  3 ++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  4 +--
 arch/arm64/kvm/mmu.c                          | 25 +++++++------------
 4 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 56445586c755..9c02abe92e0a 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -54,7 +54,7 @@ extern struct host_kvm host_kvm;
 extern const u8 pkvm_hyp_id;
 
 int __pkvm_prot_finalize(void);
-int __pkvm_host_share_hyp(u64 pfn);
+int __pkvm_host_share_hyp(u64 pfn, u64 nr_pages);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2da6aa8da868..f78bec2b9dd4 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -143,8 +143,9 @@ static void handle___pkvm_cpu_set_vector(struct kvm_cpu_context *host_ctxt)
 static void handle___pkvm_host_share_hyp(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(u64, pfn, host_ctxt, 1);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 2);
 
-	cpu_reg(host_ctxt, 1) = __pkvm_host_share_hyp(pfn);
+	cpu_reg(host_ctxt, 1) = __pkvm_host_share_hyp(pfn, nr_pages);
 }
 
 static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 6983b83f799f..909e60f71b06 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -671,14 +671,14 @@ static int do_share(struct pkvm_mem_share *share)
 	return ret;
 }
 
-int __pkvm_host_share_hyp(u64 pfn)
+int __pkvm_host_share_hyp(u64 pfn, u64 nr_pages)
 {
 	int ret;
 	u64 host_addr = hyp_pfn_to_phys(pfn);
 	u64 hyp_addr = (u64)__hyp_va(host_addr);
 	struct pkvm_mem_share share = {
 		.tx	= {
-			.nr_pages	= 1,
+			.nr_pages	= nr_pages,
 			.initiator	= {
 				.id	= PKVM_ID_HOST,
 				.addr	= host_addr,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f80673e863ac..bc9865a8c988 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -281,30 +281,23 @@ static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
 	}
 }
 
-static int pkvm_share_hyp(phys_addr_t start, phys_addr_t end)
-{
-	phys_addr_t addr;
-	int ret;
-
-	for (addr = ALIGN_DOWN(start, PAGE_SIZE); addr < end; addr += PAGE_SIZE) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp,
-					__phys_to_pfn(addr));
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
 int kvm_share_hyp(void *from, void *to)
 {
+	phys_addr_t start, end;
+	u64 nr_pages;
+
 	if (is_kernel_in_hyp_mode())
 		return 0;
 
 	if (kvm_host_owns_hyp_mappings())
 		return create_hyp_mappings(from, to, PAGE_HYP);
 
-	return pkvm_share_hyp(kvm_kaddr_to_phys(from), kvm_kaddr_to_phys(to));
+	start = ALIGN_DOWN(kvm_kaddr_to_phys(from), PAGE_SIZE);
+	end = PAGE_ALIGN(kvm_kaddr_to_phys(to));
+	nr_pages = (end - start) >> PAGE_SHIFT;
+
+	return kvm_call_hyp_nvhe(__pkvm_host_share_hyp, __phys_to_pfn(start),
+				 nr_pages);
 }
 
 /**
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
