Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CBB6FC5
	for <kvmarm@lists.linux.dev>; Mon,  6 Mar 2023 19:02:06 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id z63-20020a254c42000000b0087f69905709so11637639yba.10
        for <kvmarm@lists.linux.dev>; Mon, 06 Mar 2023 11:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678129326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hy1Buh0DyhAQ1dsWc1I6Y0GrKiZLM4ytS70wq/2qiU0=;
        b=Letr5LRp7bS0YmkVINmE83RF8//+0ihwPomgSJZC4+dkD9sFUFEL35AQoxcfPpIbXW
         Y1mVJA34aQ9Fn9+jBPkAovdeUPbAGsum3MVzw575zB3u4rfwK4ZVePdw3VSiVo2j9C9v
         3XnoKl7fEhlmtkQ5DdG9/UhFj+tyVjNmSih/iYAuSQ6xwOtYmbjOYgHRAkzFRXa92dze
         ZQvrRjBbIKvFglVzBDH4EAw30eROHuzuIjsYKsJXNnWsAQHIog+eYwButoAe0B9OxSD2
         pOTz7b2aOyFjFOUOaTEw5+7DJRfnksutj0fbq9nxtjgFb7SGFFpwHZTOmxj6KpssL5px
         NozA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678129326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hy1Buh0DyhAQ1dsWc1I6Y0GrKiZLM4ytS70wq/2qiU0=;
        b=GVnOnhlY0pvTVzStUydLqv+E5QEAmuY/fkhTE0ZI5nViPikqHsWLT6dFl0f0jEVkIG
         dUKS4TNEKXK8ojvEGY4WOM/04hVK2zvLBaKwSpE7bcDBljTFCuonqm1OC++XcQJ7JWwz
         f7PRyoNnCfBsSmSbcP2LQ9eOWNCs6rKWvbv7zKJbL8nYBINMPnDUvyTjUkO05T1zCCKu
         ZRPv0N9GJcflgnT28Rp5CQ53IDgcjNpcEcQ6kdNPj/SH4C4u7M6dtnFJljDRn6m7y9Sr
         iEQjTFQ5FPJjZyFAwpdXgtMGTqJ9zxTPvvr+kbrCOabCl9M/P//IQ9XFsVmaokP9bbPQ
         T4fA==
X-Gm-Message-State: AO0yUKV2TL5EvAJfd2GNgNQ+C/nbqxbo2IX7/XAXutI2sjixEVK4wTzH
	orjzQEZHYbYyXL1A/M54KbEBr2PHsCt+Ng==
X-Google-Smtp-Source: AK7set9e2oV5ajrE5TnGPzkyECRcuaio2KGOJRsM0L6WhO9k90cawVld9W/AAFXa4Ih5X3b9O+P88E69HqyVhg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:b667:0:b0:534:d71f:14e6 with SMTP id
 h39-20020a81b667000000b00534d71f14e6mr7365447ywk.9.1678129326079; Mon, 06 Mar
 2023 11:02:06 -0800 (PST)
Date: Mon,  6 Mar 2023 11:01:56 -0800
In-Reply-To: <20230306190156.434452-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230306190156.434452-1-dmatlack@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306190156.434452-5-dmatlack@google.com>
Subject: [PATCH v2 4/4] KVM: x86: Drop union for pages_{4k,2m,1g} stats
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Eric Farman <farman@linux.ibm.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, David Matlack <dmatlack@google.com>, 
	Sathvika Vasireddy <sv@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Drop the union for the pages_{4k,2m,1g} stats. The union is no longer
necessary now that KVM supports choosing a custom name for stats.

Eliminating the union also would allow future commits to more easily
move pages[] into common code, e.g. if KVM ever gains support for a
common page table code.

An alternative would be to drop pages[] and have kvm_update_page_stats()
update pages_{4k,2m,1g} directly. But that's not a good direction to go
in since other architectures use other page sizes.

No functional change intended.

Link: https://lore.kernel.org/kvm/20221208193857.4090582-1-dmatlack@google.com/
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h | 9 +--------
 arch/x86/kvm/x86.c              | 6 +++---
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 808c292ad3f4..a59e41355ef4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1473,14 +1473,7 @@ struct kvm_vm_stat {
 	u64 mmu_recycled;
 	u64 mmu_cache_miss;
 	u64 mmu_unsync;
-	union {
-		struct {
-			atomic64_t pages_4k;
-			atomic64_t pages_2m;
-			atomic64_t pages_1g;
-		};
-		atomic64_t pages[KVM_NR_PAGE_SIZES];
-	};
+	atomic64_t pages[KVM_NR_PAGE_SIZES];
 	u64 nx_lpage_splits;
 	u64 max_mmu_page_hash_collisions;
 	u64 max_mmu_rmap_size;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 072f5ba83170..101ad6b7e7b6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -240,9 +240,9 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_STAT(VM, CUMULATIVE, NONE, mmu_recycled),
 	KVM_STAT(VM, CUMULATIVE, NONE, mmu_cache_miss),
 	KVM_STAT(VM, INSTANT, NONE, mmu_unsync),
-	KVM_STAT(VM, INSTANT, NONE, pages_4k),
-	KVM_STAT(VM, INSTANT, NONE, pages_2m),
-	KVM_STAT(VM, INSTANT, NONE, pages_1g),
+	__KVM_STAT(VM, INSTANT, NONE, pages[PG_LEVEL_4K - 1], "pages_4k"),
+	__KVM_STAT(VM, INSTANT, NONE, pages[PG_LEVEL_2M - 1], "pages_2m"),
+	__KVM_STAT(VM, INSTANT, NONE, pages[PG_LEVEL_1G - 1], "pages_1g"),
 	KVM_STAT(VM, INSTANT, NONE, nx_lpage_splits),
 	KVM_STAT(VM, PEAK, NONE, max_mmu_rmap_size),
 	KVM_STAT(VM, PEAK, NONE, max_mmu_page_hash_collisions)
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

