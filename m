Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E870E2F5B
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:29 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id k16so12615641wms.2
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yvsZEZd93DQdk3Gw4NS1NraTmYfO9Oz159bdinMkA6M=;
        b=oItCvCgzbiMM79tWChYKkG5G1ZGcdUz0gKcyWcJtAcqX32+3N+ydf/mJG3YDZ3H4yU
         ZlRpMMjbnmXiOTDySDVdU5ydxmEmOVJbBDWuilJNR4fr7Om+Lwre+KiXYG+a02PzMgXl
         vA7UC+RpgBu+Dvd1PGbVsC3j2RzgivRmI3OzYGbO1h9qivNQDPZ2hCqw/OHp518gf29x
         DTLO2VAbm1JKbIUI2mup5i3KtCbnFe2NgQX7RwLjWUIC9pkcJSMfmVUdoxCboL+XsXpP
         h9osaVsOzKGfSfIR3kFDQggjhnvQvHJM8Q1oWL+hq/425+aTB8HpZdlDJp7i7xcON34p
         LZGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yvsZEZd93DQdk3Gw4NS1NraTmYfO9Oz159bdinMkA6M=;
        b=hXy2XSK6LWykUGbUK+cFUyHJOMxWKoMEd13oceIgsrhOQwHB7hBL6MXo3lK5ycTcVW
         2ACaBE3dT1Rb0jhoZSNmzjdrWwKYswd9wzOh06w5+sE9KYL+sfSFRiLHYpArfrRyS/q0
         soFEjzIyiJXmSqz/+YYuAJB1EMwuL3BCu70aHS+5FiBeETL/wlQf+1mQPFz1aSBAIZIL
         Wnsbino5yqBPQycDGYAeRn5srAVS61NBGxwcmjFRxl0BkANGV5N+2GN7fBKRzsoHtCUz
         SNW23zIdj8cn4fonebjj9FJXYYcvz5df7I/BTfVSZqA8J0gBYXxYP67Rejj0hd1/koCN
         0ikw==
X-Gm-Message-State: AO0yUKUlxeJFgaOu/j99uaZygPAylINw+R+oIq1TTEdui/x2J3XvDrMU
	M+7hhBpXFPdzmq3H6JMtfhq4Lw==
X-Google-Smtp-Source: AK7set9N6OXBd89JzPHrqu15NAgJtTXIO8rAEPNule/gn66F+3qLMRl53iaOB7E+zcMNN668hoyKoA==
X-Received: by 2002:a7b:ce94:0:b0:3dc:43a0:83bb with SMTP id q20-20020a7bce94000000b003dc43a083bbmr2087275wmj.3.1675256368023;
        Wed, 01 Feb 2023 04:59:28 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:27 -0800 (PST)
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
Subject: [RFC PATCH 11/45] KVM: arm64: pkvm: Expose pkvm_admit_host_page()
Date: Wed,  1 Feb 2023 12:52:55 +0000
Message-Id: <20230201125328.2186498-12-jean-philippe@linaro.org>
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

Since the IOMMU driver will need admit_host_page(), make it non static.
As a result we can drop refill_memcache() and call admit_host_page()
directly from pkvm_refill_memcache().

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 --
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 16 ++++++++---
 arch/arm64/kvm/hyp/nvhe/mm.c                  | 27 +++++--------------
 4 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 40decbe4cc70..d4f4ffbb7dbb 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -83,8 +83,6 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 int hyp_pin_shared_mem(void *from, void *to);
 void hyp_unpin_shared_mem(void *from, void *to);
 void reclaim_guest_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc);
-int refill_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
-		    struct kvm_hyp_memcache *host_mc);
 
 void *pkvm_map_donated_memory(unsigned long host_va, size_t size);
 void pkvm_unmap_donated_memory(void *va, size_t size);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 84db840f2057..a8c46a0ebc4a 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -26,6 +26,7 @@ int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot
 int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 				  enum kvm_pgtable_prot prot,
 				  unsigned long *haddr);
+void *pkvm_admit_host_page(struct kvm_hyp_memcache *mc);
 int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
 int pkvm_create_hyp_device_mapping(u64 base, u64 size, void __iomem *haddr);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e8328f54200e..29ce7b09edbb 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -766,14 +766,24 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) =  ret;
 }
 
+static void *admit_host_page(void *arg)
+{
+	return pkvm_admit_host_page(arg);
+}
+
 static int pkvm_refill_memcache(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
+	int ret;
 	struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
 	u64 nr_pages = VTCR_EL2_LVLS(hyp_vm->kvm.arch.vtcr) - 1;
-	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct kvm_hyp_memcache host_mc = hyp_vcpu->host_vcpu->arch.pkvm_memcache;
+
+	ret =  __topup_hyp_memcache(&hyp_vcpu->vcpu.arch.pkvm_memcache,
+				    nr_pages, admit_host_page,
+				    hyp_virt_to_phys, &host_mc);
 
-	return refill_memcache(&hyp_vcpu->vcpu.arch.pkvm_memcache, nr_pages,
-			       &host_vcpu->arch.pkvm_memcache);
+	hyp_vcpu->host_vcpu->arch.pkvm_memcache = host_mc;
+	return ret;
 }
 
 static void handle___pkvm_host_map_guest(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 318298eb3d6b..9daaf2b2b191 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -340,35 +340,20 @@ int hyp_create_idmap(u32 hyp_va_bits)
 	return __pkvm_create_mappings(start, end - start, start, PAGE_HYP_EXEC);
 }
 
-static void *admit_host_page(void *arg)
+void *pkvm_admit_host_page(struct kvm_hyp_memcache *mc)
 {
-	struct kvm_hyp_memcache *host_mc = arg;
-
-	if (!host_mc->nr_pages)
+	if (!mc->nr_pages)
 		return NULL;
 
 	/*
 	 * The host still owns the pages in its memcache, so we need to go
 	 * through a full host-to-hyp donation cycle to change it. Fortunately,
 	 * __pkvm_host_donate_hyp() takes care of races for us, so if it
-	 * succeeds we're good to go.
+	 * succeeds we're good to go. Because mc is a copy of the memcache
+	 * struct, the host cannot modify mc->head between donate and pop.
 	 */
-	if (__pkvm_host_donate_hyp(hyp_phys_to_pfn(host_mc->head), 1))
+	if (__pkvm_host_donate_hyp(hyp_phys_to_pfn(mc->head), 1))
 		return NULL;
 
-	return pop_hyp_memcache(host_mc, hyp_phys_to_virt);
-}
-
-/* Refill our local memcache by poping pages from the one provided by the host. */
-int refill_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
-		    struct kvm_hyp_memcache *host_mc)
-{
-	struct kvm_hyp_memcache tmp = *host_mc;
-	int ret;
-
-	ret =  __topup_hyp_memcache(mc, min_pages, admit_host_page,
-				    hyp_virt_to_phys, &tmp);
-	*host_mc = tmp;
-
-	return ret;
+	return pop_hyp_memcache(mc, hyp_phys_to_virt);
 }
-- 
2.39.0

