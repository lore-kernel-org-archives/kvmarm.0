Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4221B2F51
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:29 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id t7so8869763wrp.5
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XRJgdMdcBYAn8GCsksV5+iIqwprfPIABeIWgyP5LWbc=;
        b=vxx76hjuHBg6kz3QouqdplT80m0HuVrQQ2SXEjueNrrxS6l2LYfPFH4yDLRiiLMsDG
         jpCcELs8krbnD4ePXxYpMlLiHUykuqQbDq4iE/TuEGr3napuMp2zDVjoaaTp/socubr0
         VOgzRpYubOM2SvtRmhnJ68dv1kOxJqbjNm1uDCQ5fJBR0/St7/iyvJhb1VGsOqCuAJjh
         KpgR2bOfqz7NNa9Ps68DJJUPhDsOHxD0mYLB50+wwhtIKhV433fD6E1DyEp2Teo6wfBM
         TRxtIwFFT8ItQB48VmGLHs6vKthvsZR6gddoMK3xQ2ilKufxjFhTL9RWCXlD594pQEob
         +vMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XRJgdMdcBYAn8GCsksV5+iIqwprfPIABeIWgyP5LWbc=;
        b=WJqhuPbBWpoEBVdsypqP4T+ozWrQLS6/cQLnVq9nuel03y3eRxt2oEDf/bVsvM3N2Q
         s6fvi3PKfQivv+KT+o4ko58Yc46czznHNPWBdxu79zDgj2GUGMXZT6qM01ZDrSApdrM0
         TRmA/gz3wG99CT6nw92q4k6b0eTB3peAHI9J+mr9/+ATEDG82iG0ECfKX0SNG1RVYvli
         +G+IKSGxixXO7/Gx5y/Y7rmGlKHGQrGK2YP8pECBm0ov7XzxKI80T4E9MftWYLajT77z
         NKFlvzue0gGqOx5769o4WZ1kqzI6oGxWqlxvQJT5061E/9XHtVc4dy+bGMotJu7omM76
         ix1Q==
X-Gm-Message-State: AO0yUKXjhUnO17IWnwtfjXkOKqm7c/uIg6FSiyh2KnOpJXwncipD4o59
	uqkPn4EaTBXMF/rPcLFf4MQIcg==
X-Google-Smtp-Source: AK7set/hW5ZAcObPErBUJzQi2gCLjPyNt9O9D278zKuPYtqDAlofquElbIfsEMoFml8u8ROlxfgf1Q==
X-Received: by 2002:a5d:684d:0:b0:2c3:293:3c64 with SMTP id o13-20020a5d684d000000b002c302933c64mr2106297wrw.71.1675256368822;
        Wed, 01 Feb 2023 04:59:28 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:28 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 12/45] KVM: arm64: pkvm: Unify pkvm_pkvm_teardown_donated_memory()
Date: Wed,  1 Feb 2023 12:52:56 +0000
Message-Id: <20230201125328.2186498-13-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tearing down donated memory requires clearing the memory, pushing the
pages into the reclaim memcache, and moving the mapping into the host
stage-2. Keep these operations in a single function.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  3 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 50 +++++++------------
 3 files changed, 22 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index d4f4ffbb7dbb..021825aee854 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -86,6 +86,8 @@ void reclaim_guest_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc);
 
 void *pkvm_map_donated_memory(unsigned long host_va, size_t size);
 void pkvm_unmap_donated_memory(void *va, size_t size);
+void pkvm_teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr,
+				  size_t dirty_size);
 
 static __always_inline void __load_host_stage2(void)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 410361f41e38..cad5736026d5 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -314,8 +314,7 @@ void reclaim_guest_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
 	addr = hyp_alloc_pages(&vm->pool, 0);
 	while (addr) {
 		memset(hyp_virt_to_page(addr), 0, sizeof(struct hyp_page));
-		push_hyp_memcache(mc, addr, hyp_virt_to_phys);
-		WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(addr), 1));
+		pkvm_teardown_donated_memory(mc, addr, 0);
 		addr = hyp_alloc_pages(&vm->pool, 0);
 	}
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index a3711979bbd3..c51a8a592849 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -602,27 +602,28 @@ void *pkvm_map_donated_memory(unsigned long host_va, size_t size)
 	return va;
 }
 
-static void __unmap_donated_memory(void *va, size_t size)
+void pkvm_teardown_donated_memory(struct kvm_hyp_memcache *mc, void *va,
+				  size_t dirty_size)
 {
-	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(va),
-				       PAGE_ALIGN(size) >> PAGE_SHIFT));
-}
+	size_t size = max(PAGE_ALIGN(dirty_size), PAGE_SIZE);
 
-void pkvm_unmap_donated_memory(void *va, size_t size)
-{
 	if (!va)
 		return;
 
-	memset(va, 0, size);
-	__unmap_donated_memory(va, size);
+	memset(va, 0, dirty_size);
+
+	if (mc) {
+		for (void *start = va; start < va + size; start += PAGE_SIZE)
+			push_hyp_memcache(mc, start, hyp_virt_to_phys);
+	}
+
+	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(va),
+				       size >> PAGE_SHIFT));
 }
 
-static void unmap_donated_memory_noclear(void *va, size_t size)
+void pkvm_unmap_donated_memory(void *va, size_t size)
 {
-	if (!va)
-		return;
-
-	__unmap_donated_memory(va, size);
+	pkvm_teardown_donated_memory(NULL, va, size);
 }
 
 /*
@@ -759,18 +760,6 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 	return ret;
 }
 
-static void
-teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr, size_t size)
-{
-	size = PAGE_ALIGN(size);
-	memset(addr, 0, size);
-
-	for (void *start = addr; start < addr + size; start += PAGE_SIZE)
-		push_hyp_memcache(mc, start, hyp_virt_to_phys);
-
-	unmap_donated_memory_noclear(addr, size);
-}
-
 int __pkvm_teardown_vm(pkvm_handle_t handle)
 {
 	size_t vm_size, last_ran_size;
@@ -813,19 +802,18 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
 		vcpu_mc = &hyp_vcpu->vcpu.arch.pkvm_memcache;
 		while (vcpu_mc->nr_pages) {
 			addr = pop_hyp_memcache(vcpu_mc, hyp_phys_to_virt);
-			push_hyp_memcache(mc, addr, hyp_virt_to_phys);
-			unmap_donated_memory_noclear(addr, PAGE_SIZE);
+			pkvm_teardown_donated_memory(mc, addr, 0);
 		}
 
-		teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
+		pkvm_teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
 	}
 
 	last_ran_size = pkvm_get_last_ran_size();
-	teardown_donated_memory(mc, hyp_vm->kvm.arch.mmu.last_vcpu_ran,
-				last_ran_size);
+	pkvm_teardown_donated_memory(mc, hyp_vm->kvm.arch.mmu.last_vcpu_ran,
+				     last_ran_size);
 
 	vm_size = pkvm_get_hyp_vm_size(hyp_vm->kvm.created_vcpus);
-	teardown_donated_memory(mc, hyp_vm, vm_size);
+	pkvm_teardown_donated_memory(mc, hyp_vm, vm_size);
 	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
 	return 0;
 
-- 
2.39.0

