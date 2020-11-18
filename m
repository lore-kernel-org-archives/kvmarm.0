Return-Path: <SRS0=VMV7=EY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40513C5519F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 14:31:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B48E246BE
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 14:31:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="v2fvZNY+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B48E246BE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 891CE4B94A;
	Wed, 18 Nov 2020 09:31:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ujoUgkuDuS1J; Wed, 18 Nov 2020 09:31:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B80D4B94F;
	Wed, 18 Nov 2020 09:31:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 755354B94C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 09:31:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Up98ol6jNHxa for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Nov 2020 09:31:48 -0500 (EST)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4076A4B94A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 09:31:48 -0500 (EST)
Received: by mail-wm1-f65.google.com with SMTP id s13so2913881wmh.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 06:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=77gMImcbngsyFF3Kh1bUZt4EqmcmVNO0vErBUFdwx2w=;
 b=v2fvZNY+grT4giPGpG9AfdPemDFWlwFtdYpSOwbiaa6C9E4b1baIyzdWzuiGTlP7eS
 x7msBmtS2wkxDsy31kncXI7VGq0s/mnzfn74IKGpc1i9+QNjhLrd7j+dFe092Cn0dDjV
 KDBBZOuI5jZ5RjWsPPQtrwxEdGd6luqcgoD6zYO/sgtdKiCG8KBvsAVG/Iv4p8wQs65p
 mC5FtsmnqYnaDPfAvok/8WjV3T/akvz3RfZ2fgPXDWOAAS9WeK3XU9DWqe06ehUMfZRc
 /cUuRFAjKY3RD2J+A4EDKh5NRVcvHAClSrOyTCdwStFA3FuqGktmyzt85/OESDbT0Ssf
 k3Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=77gMImcbngsyFF3Kh1bUZt4EqmcmVNO0vErBUFdwx2w=;
 b=jnlZtrAuWSIzM7flXtHeaqHHsSbGxD20cSALc35YOjdaKy2g8yBEBXo3/xGvX2ylLn
 pT2Rhl0XbGshgC7mK7uF6Xh3Kt6M3pSB0gn2R1wPpSWeU4S6A3nApotfGLAkuwPerHqh
 yZANqFX3R0SW2echb+G5Be5Fgd1kE5bxFRG4JmNVtVFuDW33H+FBJSI6RCllwRhtXWxq
 XE2M64V2rbwT60nmyUHnqA6q7XoYS72sIghPijNzKblKjEysv1yugIfeyECn1FlyaYO9
 sVqKJ0FypJo2HjQG037hQaLmhxnsNAFzPg/yBYyBzdOHIojYapBfCfPCIt3yxy36AaZG
 52fA==
X-Gm-Message-State: AOAM533W7r2gXMX1HsR7yInlZYUVGOZPum6lNnXCFYga5CDf8OWTpJBo
 my07pcVRgqanY9Mv2/5GP+37uQ==
X-Google-Smtp-Source: ABdhPJyiO0C6fIniO9A8G4+oXO/BFYBEEq1ifMK+gP7zPSNkLa+obZh4pOi4zfnF+eiaqN3P59YUgA==
X-Received: by 2002:a7b:cbc8:: with SMTP id n8mr334272wmi.124.1605709906953;
 Wed, 18 Nov 2020 06:31:46 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id u5sm28800161wro.56.2020.11.18.06.31.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 Nov 2020 06:31:45 -0800 (PST)
Date: Wed, 18 Nov 2020 14:31:42 +0000
From: Quentin Perret <qperret@google.com>
To: Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 15/27] of/fdt: Introduce early_init_dt_add_memory_hyp()
Message-ID: <20201118143142.GA2220979@google.com>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-16-qperret@google.com>
 <CAL_Jsq+xAy9+HjH6vqfmaAEKBe9MMm+wWvUtiz5dFnHmMneqNw@mail.gmail.com>
 <20201118092547.GA2031536@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201118092547.GA2031536@google.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Wednesday 18 Nov 2020 at 09:25:47 (+0000), Quentin Perret wrote:
> I'll have a go at the memblock stuff to see if I find a way to make it
> work from that angle.

OK, no luck with the memblock API, but I figured that I can actually
postpone the KVM memory reservation to a later point, after
unflatten_device_tree(), which lets me iterate over the memory nodes
directly rather than having the fdt driver do it for me.

The below seems to boot alright (though I'm not too familiar with
of_address_to_resource() so I may not be using right) and keeps the
whole thing in arch/arm64. Thoughts?

Thanks,
Quentin

---8<---
diff --git a/arch/arm64/kvm/hyp/reserved_mem.c b/arch/arm64/kvm/hyp/reserved_mem.c
index 7da8e2915c1c..cab5ad587a3a 100644
--- a/arch/arm64/kvm/hyp/reserved_mem.c
+++ b/arch/arm64/kvm/hyp/reserved_mem.c
@@ -6,6 +6,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/memblock.h>
+#include <linux/of_address.h>
 #include <linux/sort.h>
 
 #include <asm/kvm_host.h>
@@ -16,7 +17,7 @@
 phys_addr_t hyp_mem_base;
 phys_addr_t hyp_mem_size;
 
-void __init early_init_dt_add_memory_hyp(u64 base, u64 size)
+static int __init add_hyp_memblock_region(struct resource *rsrc)
 {
 	struct hyp_memblock_region *reg;
 
@@ -24,12 +25,14 @@ void __init early_init_dt_add_memory_hyp(u64 base, u64 size)
 		kvm_nvhe_sym(hyp_memblock_nr) = -1;
 
 	if (kvm_nvhe_sym(hyp_memblock_nr) < 0)
-		return;
+		return -ENOMEM;
 
 	reg = kvm_nvhe_sym(hyp_memory);
-	reg[kvm_nvhe_sym(hyp_memblock_nr)].start = base;
-	reg[kvm_nvhe_sym(hyp_memblock_nr)].end = base + size;
+	reg[kvm_nvhe_sym(hyp_memblock_nr)].start = rsrc->start;
+	reg[kvm_nvhe_sym(hyp_memblock_nr)].end = rsrc->end;
 	kvm_nvhe_sym(hyp_memblock_nr)++;
+
+	return 0;
 }
 
 static int cmp_hyp_memblock(const void *p1, const void *p2)
@@ -52,7 +55,10 @@ void kvm_sort_memblock_regions(void)
 extern bool enable_protected_kvm;
 void __init reserve_kvm_hyp(void)
 {
+	struct device_node *np;
+	struct resource rsrc;
 	u64 nr_pages, prev;
+	int i;
 
 	if (!enable_protected_kvm)
 		return;
@@ -60,8 +66,14 @@ void __init reserve_kvm_hyp(void)
 	if (!is_hyp_mode_available() || is_kernel_in_hyp_mode())
 		return;
 
-	if (kvm_nvhe_sym(hyp_memblock_nr) <= 0)
-		return;
+	for_each_node_by_type(np, "memory") {
+		for (i = 0; !of_address_to_resource(np, i, &rsrc); i++) {
+			if (!add_hyp_memblock_region(&rsrc))
+				continue;
+			kvm_err("Failed to add hyp memblock\n");
+			return;
+		}
+	}
 
 	hyp_mem_size += num_possible_cpus() << PAGE_SHIFT;
 	hyp_mem_size += hyp_s1_pgtable_size();
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index f81da019b677..114f788a4da4 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -391,7 +391,6 @@ void __init arm64_memblock_init(void)
 
 	reserve_elfcorehdr();
 
-	reserve_kvm_hyp();
 
 	high_memory = __va(memblock_end_of_DRAM() - 1) + 1;
 
@@ -423,6 +422,8 @@ void __init bootmem_init(void)
 
 	dma_pernuma_cma_reserve();
 
+	reserve_kvm_hyp();
+
 	/*
 	 * sparse_init() tries to allocate memory from memblock, so must be
 	 * done after the fixed reservations
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index af2b5a09c5b4..4602e467ca8b 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1099,10 +1099,6 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 #define MAX_MEMBLOCK_ADDR	((phys_addr_t)~0)
 #endif
 
-void __init __weak early_init_dt_add_memory_hyp(u64 base, u64 size)
-{
-}
-
 void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
 {
 	const u64 phys_offset = MIN_MEMBLOCK_ADDR;
@@ -1143,7 +1139,6 @@ void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
 		base = phys_offset;
 	}
 	memblock_add(base, size);
-	early_init_dt_add_memory_hyp(base, size);
 }
 
 int __init __weak early_init_dt_mark_hotplug_memory_arch(u64 base, u64 size)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
