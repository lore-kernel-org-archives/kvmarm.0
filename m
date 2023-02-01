Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DFC2F46
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:27 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id h12so17212663wrv.10
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JL+q7powKXjRQBM9aUxd/Ixujr3/xsGD0eW5qeS08kg=;
        b=XvIuhKnbdaSJmJH8iDjgXLwNO9bmY/agjJa9GYHK5fvNc0rbxK9E8+MePeO1hYYVkj
         BLoKe4FnYGZ+IcTOkZe7A/26QsSpzsLPFCxLtdFiID61kSy1LAZHhSepPc/I0WjajANX
         zqcV2727uc8XO/ZvNCcb3Dwjpmq+TZk1Mq07dsMCgGcMTplN5QoiX9TyV73FJGwuWPl5
         VVfuWMPqHgHHXae2ZU0wPy/5nRKQ4LHuLzsStjXWsObRhMnAWkK+9/ljtH6QUPqObP0o
         1KVNZv0lWLfSW5q9HV60q+XYtLC9dKPNWlqVRI8Ylf60E6JZU9bJG0pBGfBHyapeYBxY
         IujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JL+q7powKXjRQBM9aUxd/Ixujr3/xsGD0eW5qeS08kg=;
        b=fbkh78C45L/YXeVrCqi6gQcvM3zy5Ydf4E9mNLXZX+lNXLAUhHwcIRXn15uGdg/LiS
         hazuzrbfO3LO8RIKEX8uWTlEkwUetftB8+mhvaC0UY8PZazQX0DUbqOAxqZqvYEWhFB6
         x7jxCr/3icAq/i41QI3L5GA3y4QMus1c+v9tX1aPoWzEAnRbbpUD0UKQaIAJOccztSXR
         tI0gLPozfEQee9vYChlVGV0kT8wZB1P8sThjn+IMmAXRdbGzT9K9gG0EbZAUS1TjCSCU
         XBgkboGFBLTFl7x/9Y0lidQRbKygfTe7767yLB86GA2Ekg9p8xisBFvErnsKjJhGZDsx
         mS6Q==
X-Gm-Message-State: AO0yUKUCiS6NDP9a9xTFLZEM/k9ljN+qWqLFIM0rZJGOy02eQ3+FYr3f
	KV+2cXquV3Ztg9g3AMs6RZAZfw==
X-Google-Smtp-Source: AK7set/b2J59uvwFQEz7jZcXjC6ArgctU3mXzzUT7UxY8LgLmGH7l73VT4ZIMiNBTG1OX7/4xi4JWw==
X-Received: by 2002:a05:6000:188f:b0:2bf:cb6a:a7e with SMTP id a15-20020a056000188f00b002bfcb6a0a7emr2957190wri.42.1675256367258;
        Wed, 01 Feb 2023 04:59:27 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:26 -0800 (PST)
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
Subject: [RFC PATCH 10/45] KVM: arm64: pkvm: Expose pkvm_map/unmap_donated_memory()
Date: Wed,  1 Feb 2023 12:52:54 +0000
Message-Id: <20230201125328.2186498-11-jean-philippe@linaro.org>
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

Allow the IOMMU driver to use pkvm_map/unmap_donated memory()

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  3 +++
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 18 +++++++++---------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 38e5e9b259fc..40decbe4cc70 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -86,6 +86,9 @@ void reclaim_guest_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc);
 int refill_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
 		    struct kvm_hyp_memcache *host_mc);
 
+void *pkvm_map_donated_memory(unsigned long host_va, size_t size);
+void pkvm_unmap_donated_memory(void *va, size_t size);
+
 static __always_inline void __load_host_stage2(void)
 {
 	if (static_branch_likely(&kvm_protected_mode_initialized))
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 905c05c7e9bf..a3711979bbd3 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -592,7 +592,7 @@ static void *map_donated_memory_noclear(unsigned long host_va, size_t size)
 	return va;
 }
 
-static void *map_donated_memory(unsigned long host_va, size_t size)
+void *pkvm_map_donated_memory(unsigned long host_va, size_t size)
 {
 	void *va = map_donated_memory_noclear(host_va, size);
 
@@ -608,7 +608,7 @@ static void __unmap_donated_memory(void *va, size_t size)
 				       PAGE_ALIGN(size) >> PAGE_SHIFT));
 }
 
-static void unmap_donated_memory(void *va, size_t size)
+void pkvm_unmap_donated_memory(void *va, size_t size)
 {
 	if (!va)
 		return;
@@ -668,11 +668,11 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 
 	ret = -ENOMEM;
 
-	hyp_vm = map_donated_memory(vm_hva, vm_size);
+	hyp_vm = pkvm_map_donated_memory(vm_hva, vm_size);
 	if (!hyp_vm)
 		goto err_remove_mappings;
 
-	last_ran = map_donated_memory(last_ran_hva, last_ran_size);
+	last_ran = pkvm_map_donated_memory(last_ran_hva, last_ran_size);
 	if (!last_ran)
 		goto err_remove_mappings;
 
@@ -699,9 +699,9 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 err_unlock:
 	hyp_spin_unlock(&vm_table_lock);
 err_remove_mappings:
-	unmap_donated_memory(hyp_vm, vm_size);
-	unmap_donated_memory(last_ran, last_ran_size);
-	unmap_donated_memory(pgd, pgd_size);
+	pkvm_unmap_donated_memory(hyp_vm, vm_size);
+	pkvm_unmap_donated_memory(last_ran, last_ran_size);
+	pkvm_unmap_donated_memory(pgd, pgd_size);
 err_unpin_kvm:
 	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
 	return ret;
@@ -726,7 +726,7 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 	unsigned int idx;
 	int ret;
 
-	hyp_vcpu = map_donated_memory(vcpu_hva, sizeof(*hyp_vcpu));
+	hyp_vcpu = pkvm_map_donated_memory(vcpu_hva, sizeof(*hyp_vcpu));
 	if (!hyp_vcpu)
 		return -ENOMEM;
 
@@ -754,7 +754,7 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 	hyp_spin_unlock(&vm_table_lock);
 
 	if (ret)
-		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
+		pkvm_unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
 
 	return ret;
 }
-- 
2.39.0

