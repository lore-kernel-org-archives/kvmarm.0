Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54236568B
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 16:53:25 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2476a31ef4aso1352673a91.3
        for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 09:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682096005; x=1684688005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EZkpp0Q8jjYvxCvjV0ny/+Rc/wVVpL1bL7ck4xeVhlc=;
        b=0h1fkH+Qg9TAAOhRy5ByqB0jrA5qVCSK4v4VOevyiT2ApjSQTkdNJB5NveNHYdDJyn
         UJHQdihO3xA3kzsZEepsUYjUUldoQQHE3IwikHmH626x/P3dqcuE74kUFvi/fYfmL8id
         EDHpOrTTDrdls8Ay6MgcRCV+nPsBif06WnlTwtqTPlBkRDbsQd0Ihsksz1E+BPVTlwL+
         Wr1jDKNxfs+qyRuwYH973UQwgCLkK4mXV3n/qkGEbaFtetzvIDazfRsZNp9s0jwVrFs5
         k56stUv4Ja+Quv0wmKFN8uJmrJL9UvFWW6XEpyc/9yhzn8gHY1vEcRlztKntO6uIDVGX
         jZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682096005; x=1684688005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EZkpp0Q8jjYvxCvjV0ny/+Rc/wVVpL1bL7ck4xeVhlc=;
        b=TQRd0N5sjhEUrwEkDwGnTrbF2LC7G+JvOWyj2TO1szVD1ZqkkLS5hyjj3d2CMwD0js
         3gRG2KFy+XxM5lJef0NeM8rKo5XzAAwtJAdBNFvzyjEeJL9LptXqkH6aviJfvDd2lFd7
         +U+X6UIWAYIxYpB8WZhXUN1l+Df8LutM8E71kXlBFLZxe2lIHuTcmAV+buxn5cGNY+z9
         4mEkV+3U6doeX1hJfK21LZEj9hfiIYXvpEBBrg/EYCq/3IpaGChTChbLCdpirYMY8McT
         ViyIG6lNbNhylQAMsaz0G4+9F2F1XaohqAc1l1KCxe8u5EILQTA39/WJSGQPsF8RcT2n
         vTfQ==
X-Gm-Message-State: AAQBX9cDbP1QC1mPCfFT5GAEkqD0eF0KwdtBp7ijwOGNRhA/0RKAa/PX
	U4x+nwIDqtBQ2PF6MW9vDyrtEht/XFiE
X-Google-Smtp-Source: AKy350bDKAEiJjC/uv+A89c39cSNVyu8ADQH7b61iTn5O1CeNgQ8Eu2os+9yNYOIL6Af0Fk180jnNb9Y53o2
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:690d:b0:23f:a851:4f04 with SMTP id
 r13-20020a17090a690d00b0023fa8514f04mr1467442pjj.3.1682096004881; Fri, 21 Apr
 2023 09:53:24 -0700 (PDT)
Date: Fri, 21 Apr 2023 09:53:05 -0700
In-Reply-To: <20230421165305.804301-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230421165305.804301-1-vipinsh@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230421165305.804301-10-vipinsh@google.com>
Subject: [PATCH 9/9] KVM: arm64: Run clear-dirty-log under MMU read lock
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

Take MMU read lock for write protecting PTEs and use shared page table
walker for clearing dirty logs.

Clearing dirty logs are currently performed under MMU write locks. This
means vCPUs write protection fault, which also take MMU read lock,  will
be blocked during this operation. This causes guest degradation and
especially noticeable on VMs with lot of vCPUs.

Taking MMU read lock will allow vCPUs to execute parallelly and reduces
the impact on vCPUs performance.

Tested improvement on a ARM Ampere Altra host (64 CPUs, 256 GB
memory and single NUMA node) via dirty_log_perf_test for 48 vCPU, 96
GB memory, 8GB clear chunk size, 1 second wait between Clear-Dirty-Log
calls and configuration:

Test command:
./dirty_log_perf_test -s anonymous_hugetlb_2mb -b 2G -v 48 -l 1 -k 8G -j -m 2

Before:
Total pages touched: 50331648 (Reads: 0, Writes: 50331648)

After:
Total pages touched: 125304832 (Reads: 0, Writes: 125304832)

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/arm64/kvm/mmu.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e0189cdda43d..3f2117d93998 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -67,8 +67,12 @@ static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t addr,
 		if (ret)
 			break;
 
-		if (resched && next != end)
-			cond_resched_rwlock_write(&kvm->mmu_lock);
+		if (resched && next != end) {
+			if (flags & KVM_PGTABLE_WALK_SHARED)
+				cond_resched_rwlock_read(&kvm->mmu_lock);
+			else
+				cond_resched_rwlock_write(&kvm->mmu_lock);
+		}
 	} while (addr = next, addr != end);
 
 	return ret;
@@ -994,7 +998,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
 
-	stage2_wp_range(&kvm->arch.mmu, start, end, 0);
+	stage2_wp_range(&kvm->arch.mmu, start, end, KVM_PGTABLE_WALK_SHARED);
 }
 
 /*
@@ -1008,9 +1012,9 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
 		gfn_t gfn_offset, unsigned long mask)
 {
-	write_lock(&kvm->mmu_lock);
+	read_lock(&kvm->mmu_lock);
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
-	write_unlock(&kvm->mmu_lock);
+	read_unlock(&kvm->mmu_lock);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
-- 
2.40.0.634.g4ca3ef3211-goog

