Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AF31C758
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:09:52 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-653d8974c49so170765b3a.2
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722192; x=1688314192;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pnaTvciscS5chSJrFdy/XWmGw+v5DL+sKG313yn6vtE=;
        b=3qM+gPLnKOcFkte53nrFJ4yxYHfRvj6VAQ74elJ+qIzLMj97WYlQnMm+LRqHDvoho4
         8AW7RUIjuOvTDqJRc6MGpLfknZTHUVt0ac+jf1e4fznmqTNQB1YeAez2Pbf+vu4gX/wo
         xA9uw3YiFJ59xCiKuG3PqvgkOpwn1kfOyfDGnV3P6/41gfMjzqB9OHhb0wbZKNfck3ux
         QuubqPWPIMr2dr+usJ/0oHW/nWAg0PkVCfHTFjYBlz4FbohVSt4JZLXej+/lCcVIkw51
         dikq26nIlv8414HoG8qlckcW0gk8fed5eU7B/bJPELllDOCa6K4cYwpu/yZBPdgX/sdW
         NMYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722192; x=1688314192;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pnaTvciscS5chSJrFdy/XWmGw+v5DL+sKG313yn6vtE=;
        b=A28/hGbac1TnZJP0v2amG/sKLsNKgRvMgYp41HvMl/ZxsyC0j6kxd+sf7f7W3CyYRg
         fnfdMCfKZ4ht/CzlK6CpgUAgy2RPGBJfOJaxo6qM7pmS/baR1OiSzF0wygvCs8/bFpP0
         rYtVRkIx0xoY8nTPHR85oWgw5U/cJzHOoufb3QG9v/bEaaeOGulZM9SH8M1EGsU8JTPs
         ehOUi1z/cnQsUZSmTjNp9BTumG/mo8nJ4FKSWO1TXzpHo1xI82gD/qYmHaB/Y8lsPGFD
         gkiujSxMccUeswsc0fSwWkNoGWdIBpGttwlm/cbhu8Jt/2wYOPE5bmWPh/e7a3HbE7zM
         Lczw==
X-Gm-Message-State: AC+VfDz/nP1O7eGnRlGpeQ1wv0NQJ/mzujyKOYEYwR8SMFuyKfIqTQ56
	fZmXS9o1mEGRvY/2Z4lBVDk10W1Uly5W
X-Google-Smtp-Source: ACHHUZ7CrgQcXBBk0scZtBwPutYqwQ0i1jeHWFv03iHedZStcHfAHgjqtsGQJinldbGkFtIY3nwdqwhDBsPu
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:2e1a:b0:64f:9e1b:d4a8 with SMTP
 id fc26-20020a056a002e1a00b0064f9e1bd4a8mr4922796pfb.1.1685722192061; Fri, 02
 Jun 2023 09:09:52 -0700 (PDT)
Date: Fri,  2 Jun 2023 09:09:14 -0700
In-Reply-To: <20230602160914.4011728-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602160914.4011728-1-vipinsh@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602160914.4011728-17-vipinsh@google.com>
Subject: [PATCH v2 16/16] KVM: arm64: Split huge pages during clear-dirty-log
 under MMU read lock
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

Split huge pages under MMU read lock instead of write when clearing
dirty log.

Running huge page split under read lock will unblock vCPUs execution and
allow whole clear-dirty-log operation run parallelly to vCPUs.

Note that splitting huge pages involves two walkers. First walker calls
stage2_split_walker() callback on each huge page. This callback will call
another walker which creates an unlinked page table. This commit makes
first walker as shared page walker which means, -EAGAIN will be retried.
Before this patch, -EAGAIN would have been ignored and walker would go
to next huge page. In practice this would not happen as the first walker
was holding MMU write lock. Inner walker is unchanged as it is working
on unlinked page table so no other thread will have access to it.

To improve confidence in correctness tested via dirty_log_test.

To measure performance improvement tested via dirty_log_perf_test.

Set up:
-------
Host: ARM Ampere Altra host (64 CPUs, 256 GB memory and single NUMA
      node)

Test VM: 48 vCPU, 192 GB total memory.

Ran dirty_log_perf_test for 400 iterations.
 ./dirty_log_perf_test -k 192G -v 48 -b 4G -m 2 -i 4000 -s anonymous_hugetlb_2mb -j

Observation:
------------

+==================+=============================+===================+
| Clear Chunk size | Clear dirty log time change | vCPUs improvement |
+==================+=============================+===================+
| 192GB            | 56%                         | 152%              |
+------------------+-----------------------------+-------------------+
| 1GB              | -81%                        | 72%               |
+------------------+-----------------------------+-------------------+

When larger chunks are used, clear dirty log time increases due to lots
of cmpxchg() but vCPUs are also able to execute parallelly causing
better performance of guest.

When chunk size is small, read lock is very fast in clearing dirty logs
as it is not waiting for MMU write lock and vCPUs are also able to run
parallelly.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/arm64/kvm/mmu.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6dd964e3682c..aa278f5d27a2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -126,7 +126,10 @@ static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
 	int ret, cache_capacity;
 	u64 next, chunk_size;
 
-	lockdep_assert_held_write(&kvm->mmu_lock);
+	if (flags & KVM_PGTABLE_WALK_SHARED)
+		lockdep_assert_held_read(&kvm->mmu_lock);
+	else
+		lockdep_assert_held_write(&kvm->mmu_lock);
 
 	chunk_size = kvm->arch.mmu.split_page_chunk_size;
 	cache_capacity = kvm_mmu_split_nr_page_tables(chunk_size);
@@ -138,13 +141,19 @@ static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
 
 	do {
 		if (need_split_memcache_topup_or_resched(kvm)) {
-			write_unlock(&kvm->mmu_lock);
+			if (flags & KVM_PGTABLE_WALK_SHARED)
+				read_unlock(&kvm->mmu_lock);
+			else
+				write_unlock(&kvm->mmu_lock);
 			cond_resched();
 			/* Eager page splitting is best-effort. */
 			ret = __kvm_mmu_topup_memory_cache(cache,
 							   cache_capacity,
 							   cache_capacity);
-			write_lock(&kvm->mmu_lock);
+			if (flags & KVM_PGTABLE_WALK_SHARED)
+				read_lock(&kvm->mmu_lock);
+			else
+				write_lock(&kvm->mmu_lock);
 			if (ret)
 				break;
 		}
@@ -1139,9 +1148,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 
 	read_lock(&kvm->mmu_lock);
 	stage2_wp_range(&kvm->arch.mmu, start, end, KVM_PGTABLE_WALK_SHARED);
-	read_unlock(&kvm->mmu_lock);
 
-	write_lock(&kvm->mmu_lock);
 	/*
 	 * Eager-splitting is done when manual-protect is set.  We
 	 * also check for initially-all-set because we can avoid
@@ -1151,8 +1158,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	 * again.
 	 */
 	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
-		kvm_mmu_split_huge_pages(kvm, start, end, 0);
-	write_unlock(&kvm->mmu_lock);
+		kvm_mmu_split_huge_pages(kvm, start, end, KVM_PGTABLE_WALK_SHARED);
+	read_unlock(&kvm->mmu_lock);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
-- 
2.41.0.rc0.172.g3f132b7071-goog

