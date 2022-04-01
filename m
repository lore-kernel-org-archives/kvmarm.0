Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BC7C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:21:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 127C24B2A3;
	Fri,  1 Apr 2022 14:21:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eos4J-J7IlAR; Fri,  1 Apr 2022 14:21:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94A3D4B301;
	Fri,  1 Apr 2022 14:20:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15D514B266
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZfML4S1ActjG for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:35 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6E1E4B216
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:35 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 b7-20020a633407000000b0038413d39ca9so2019301pga.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=rk47OwLDTUZoPp3sSFPqcpIfMojh6XvvX1htIIdRD8M=;
 b=s72V80y7tDOh1F0V57dD8TPMVDGZRFJLVeRypa2j6NOIeyK6OdhN/vMWnCocaWrr7k
 CTCwsrxCAl4hj3azp9KbFVRgymRC6cGX41YRf3bKbcz4hip3E1y1CUleOkW/mRUjOv72
 4q0juwIAEhigFEFYWcTUd2u5Yv+XnqXVD6a3pn/Ui+K8aArSkJYYBVjZFCZK1SOZsjC5
 7Yesg542/Fq0ocOM9rn7tyOyRxQKZ3AxCieAlZZBYn/IE9/hjt2QS80Tz+PLFcorlflQ
 sdxYZkSU8ub5I6xHkzMHujo97FILxUXUQ+MHykloWi+evJGsQ9HO/j+9n0zxGqN3fxiy
 QTYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=rk47OwLDTUZoPp3sSFPqcpIfMojh6XvvX1htIIdRD8M=;
 b=NM1Cl/+mUCUUTbWQniUs+VXxmLLPDXlmF17KyAL8ZhMM696SSih+WmysBzEzNGsNux
 at7f3eL43NJznu+O2UM361XWwkT/FHtVJqN5ajL5pMPk0mOiZUvAmhc5Kot68VQN9+c9
 fb4NVjHj1Z+PG/IJMUzKSbv8tte18ROJkJ2ndqMf7aclJtIXmKgmYSE466mR1O9ICQOZ
 4UvFbGRxnvCoaiudHBy4+X5RWUKnDdmoCHeGUZv/1zEQ1Mz2vyS3+ivISKM4jhQmj+lX
 nP6/c6xUKwj1Zbjy3VwLYFSNSV6XMygPLYnWgC89fboRM5lUjYsAgAN+GB4cUXHuRga1
 2gyw==
X-Gm-Message-State: AOAM5300wQZY9Zw8NDbASorz47iO696LvuYCVkJMvB4J+CooqN7g8BRq
 2zPHEOon/puIil1KqJtyPODjmv/mIrXUHQ==
X-Google-Smtp-Source: ABdhPJybrRr8dD4aYv/cbz/erk9I24s3Xk9K694qQkW/0pJU9JMwG7vQGFtAvLaRQheDfdF0TPnn3iF2T50Fnw==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:ce0f:b0:156:5a4:926c with SMTP id
 k15-20020a170902ce0f00b0015605a4926cmr11415497plg.3.1648835794980; Fri, 01
 Apr 2022 10:56:34 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:52 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-22-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 21/23] KVM: Allow GFP flags to be passed when topping up
 MMU caches
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 01 Apr 2022 14:20:42 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

This will be used in a subsequent commit to top-up MMU caches under the
MMU lock with GFP_NOWAIT as part of eager page splitting.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 252ee4a61b58..7d3a1f28beb2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1335,6 +1335,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
+int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min, gfp_t gfp);
 int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
 void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
 void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c4cac4195f4a..554148ea0c30 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -369,7 +369,7 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 		return (void *)__get_free_page(gfp_flags);
 }
 
-int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
+int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min, gfp_t gfp)
 {
 	void *obj;
 
@@ -384,7 +384,7 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 	if (mc->nobjs >= min)
 		return 0;
 	while (mc->nobjs < mc->capacity) {
-		obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
+		obj = mmu_memory_cache_alloc_obj(mc, gfp);
 		if (!obj)
 			return mc->nobjs >= min ? 0 : -ENOMEM;
 		mc->objects[mc->nobjs++] = obj;
@@ -392,6 +392,11 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 	return 0;
 }
 
+int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
+{
+	return __kvm_mmu_topup_memory_cache(mc, min, GFP_KERNEL_ACCOUNT);
+}
+
 int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
 {
 	return mc->nobjs;
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
