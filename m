Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5970A1C758
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:09:51 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-56938733c13so20976647b3.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722190; x=1688314190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hryh0ZWAFdBP/1ensclnMWOs6DFcoKq9t8dEIwwzMjM=;
        b=yFcSJ5sk1YiYcQktVHUrIraA4vq3gzBg01wawQ+99X99BcERdv6aw79BJglFIsX38X
         Jmk2e5UaolCr5t1qAVgv5xhRcuwqz8qsPeKTN4dMinvHjEGhpXtPGawN2ICvlDQZGj8D
         ZmOScsl1sdyn4gxehMyRauugNpIrQjpu1KxL67VdJydhpwrAe8TXpUojYixIDTXpkYLZ
         L/KcS63c1WkLy8I19gAWFgXf90HgC8c3L1xN5Hze37jt9RE4scxALJ3lb9KGpgKF7m+y
         IPNOsGvdWwTPZEtqpxeUuo6lpLAcPxZcX9jQeWMRNApjKkg5jyviIXgCTWMDwLFLuVTH
         Fsfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722190; x=1688314190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hryh0ZWAFdBP/1ensclnMWOs6DFcoKq9t8dEIwwzMjM=;
        b=U41m5CkB67QjeskwbAeM0/hHxLXv7Sr4yT/pDIWsoPym+eokyP0wDktXkhyPB5VW6A
         PMb0t539cAYWJ8KoKGraUQxHaVpcZLmRi7J3q9qLkwV2TfGJROzeHucW1Sk4W64vp8+4
         wH4du/9wda7dRgGaWKW53yWfqbDTGm2undHQ+Gv+bwI8rnURmc1avM6/FCMkmkyGFpie
         lDVTiIL+nrxgX2MYpaOGf/784dI/vsBPiq+v8xojYXLEOJLnXBfRdJiBaR9HBymWD8rh
         0skq6fA98tZ0kXIJThjaA37A43XGwub8AnVMdU7ZMXOtPcWaICDgSLm/UMWH0ItqO0MH
         LdJA==
X-Gm-Message-State: AC+VfDyyEXi9Dl7HP5C7E+Q9wN00AAiBOKy/Mgope74J/KA7+J7QNKYp
	xplJLuy+yc8TngI7YxkdWc+JbYUwf0IQ
X-Google-Smtp-Source: ACHHUZ5M9AG9HKhKFMo8prXUgGc/ucGnPOZDLd1OSRiqHslc40DT/QGSesfErKBawc3k99MHt4wj3TuQ4IOn
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a25:bc7:0:b0:ba8:cbd2:61b3 with SMTP id
 190-20020a250bc7000000b00ba8cbd261b3mr1223005ybl.5.1685722190144; Fri, 02 Jun
 2023 09:09:50 -0700 (PDT)
Date: Fri,  2 Jun 2023 09:09:13 -0700
In-Reply-To: <20230602160914.4011728-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602160914.4011728-1-vipinsh@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602160914.4011728-16-vipinsh@google.com>
Subject: [PATCH v2 15/16] KVM: arm64: Provide option to pass page walker flag
 for huge page splits
From: Vipin Sharma <vipinsh@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, 
	tsbogend@alpha.franken.de, anup@brainfault.org, atishp@atishpatra.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com, 
	ricarkol@google.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Pass enum kvm_pgtable_walk_flags{} to kvm_mmu_split_huge_pages().
Use 0 as the flag value to make it no-op.

In future commit kvm_mmu_split_huge_pages() will be used under both MMU
read lock and MMU write lock. Flag allows to pass intent to use shared
or non-shared page walkers to split the huge pages.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/arm64/kvm/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 34d2bd03cf5f..6dd964e3682c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -118,7 +118,8 @@ static bool need_split_memcache_topup_or_resched(struct kvm *kvm)
 }
 
 static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
-				    phys_addr_t end)
+				    phys_addr_t end,
+				    enum kvm_pgtable_walk_flags flags)
 {
 	struct kvm_mmu_memory_cache *cache;
 	struct kvm_pgtable *pgt;
@@ -153,7 +154,8 @@ static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
 			return -EINVAL;
 
 		next = __stage2_range_addr_end(addr, end, chunk_size);
-		ret = kvm_pgtable_stage2_split(pgt, addr, next - addr, cache, 0);
+		ret = kvm_pgtable_stage2_split(pgt, addr, next - addr, cache,
+					       flags);
 		if (ret)
 			break;
 	} while (addr = next, addr != end);
@@ -1112,7 +1114,7 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
 	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
 	write_lock(&kvm->mmu_lock);
-	kvm_mmu_split_huge_pages(kvm, start, end);
+	kvm_mmu_split_huge_pages(kvm, start, end, 0);
 	write_unlock(&kvm->mmu_lock);
 }
 
@@ -1149,7 +1151,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	 * again.
 	 */
 	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
-		kvm_mmu_split_huge_pages(kvm, start, end);
+		kvm_mmu_split_huge_pages(kvm, start, end, 0);
 	write_unlock(&kvm->mmu_lock);
 }
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

