Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27201FDE06
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 19:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734550887; cv=none; b=UdiiAvYATamIszSB1aSbImFpnemogC9OrsbF3YZBndNVfIASRWSuSCXQCGJ3cqrgyROTH1lTTbseC2Nugcb8Inz223ZOOymClrBtXYP+qLNcqxbBa2RKQ5xxvKBROnV4PYkLSsD7JUy9kUuqXu6lXRTBMR/+Wgi5VMVuBiQiGEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734550887; c=relaxed/simple;
	bh=Hoe25EExMH2tC//p9RURzQDXz5Wlno462AfLtNpftDw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dch0N+S9VBBgjdMUGKeulXII0cgW2ua7/INUIeALGCv8Hq2t7Hbi7fCZhzlDdFZr7CkEgy246PfD6P8Ewk83gUE2Of1aJoqL3DBTdBwJHJGRUAn427SDkpOdKbaLS2CL5IkgaLTPSk8nmZFPqF1W5fa+cQ2TUlhnvetZr4gGXQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fv/P+Lzf; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fv/P+Lzf"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5d3d2cccbe4so5849080a12.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 11:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734550884; x=1735155684; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fif6OryM8GaD9IrY10oouFAiMLD9Fy27Kwulc/BsLHw=;
        b=fv/P+LzfB8jYDBNOzcr9bEL4jHjjjvsMEkgbpfGW2xrC2cLHoL6GjfqmSkY7M0aYvj
         hZO2Rhpsb54yCJ2Jw1RqqQwdSL1bHUaRDIx6Qkd1MOd20+p6jp020FrDvEBBVnlaghtz
         uf7Xr65DIdW4ktpASDbAqTF7gk7bt8SYmUXileFbHVLkSbuRTo39IXXVp4cvVvDW9M5l
         QuUkS1bpJhY9ZRGEK0i+ildXD1r1VS+A6tv3JqJxx2+3W7PCsQlOK1kbPNI4vm1E5ESE
         9sma8vpeDVSCvUMKN0spiigKUd/NmIk5Xmb7upIUrKY87EOUZcCjTussSZpHWXTjp9ii
         vgjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734550884; x=1735155684;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fif6OryM8GaD9IrY10oouFAiMLD9Fy27Kwulc/BsLHw=;
        b=LzJo5P7GcB/iMTyOWMPkGXBwEeiRuSqJDeclHGzjKytAFppIBeZGAhLSiqy81HObNV
         n4me56/EV6LoLCY+JYfxUoWG/iWoZwKcJ164l9GHlt/PVvae3CoB2yyynp0aGRBMAaPY
         gCSswdgps+vXjYM+QP4tKyOBUwiK+MgSe0fZMRa/LnDviMJTLkeFwCLrKzsaNohQ+ian
         RaUXdsVn+Sirz3FrBQlOIcs/3r4zH9IHDnfiKxvrN1ltMXUqreGkiLvDWOoDvMNjjD1+
         34WDEJo/ET2jPpqsxaAJ5ZOW8aNzYq8EhuBI7Z4uwMRZ8VdtZaQXJIkWCMgj6MH8qJms
         lm9w==
X-Forwarded-Encrypted: i=1; AJvYcCXM16JjhSrqoapGmS6cbwOZrDWbJvVZOquvRaCqbZqm++MhWZ5U9cGsvKLR64bmYyWdRD/jvVo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8mQOZX4McSzZxzejYJHrIKCMo0FLZf9xpvvb//6Y+Elj8ZBCZ
	FzaMafy7nY+iYPmCT0I0+8gOouOeJd6KTbDlaQFDCTK42a10ZKbPoM6mrMqN3nUhapeE19S7G50
	7W7ykRQ==
X-Google-Smtp-Source: AGHT+IGBOe/4DPfkEF1B+NjO9Oub04g+76qddsin82OUskxL4QgNyZ1UOFjMRSpfcIHcgJgEB6gBW3Epew2h
X-Received: from edbb5.prod.google.com ([2002:a05:6402:1f05:b0:5d3:e5bd:959c])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:34c1:b0:5d0:88da:c235
 with SMTP id 4fb4d7f45d1cf-5d7ee41e646mr3798506a12.31.1734550884474; Wed, 18
 Dec 2024 11:41:24 -0800 (PST)
Date: Wed, 18 Dec 2024 19:40:51 +0000
In-Reply-To: <20241218194059.3670226-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241218194059.3670226-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241218194059.3670226-11-qperret@google.com>
Subject: [PATCH v4 10/18] KVM: arm64: Introduce __pkvm_host_share_guest()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In preparation for handling guest stage-2 mappings at EL2, introduce a
new pKVM hypercall allowing to share pages with non-protected guests.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/include/asm/kvm_host.h             |  3 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 34 +++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 72 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  8 +++
 7 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 89c0fac69551..449337f5b2a3 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -65,6 +65,7 @@ enum __kvm_host_smccc_func {
 	/* Hypercalls available after pKVM finalisation */
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e18e9244d17a..1246f1d01dbf 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -771,6 +771,9 @@ struct kvm_vcpu_arch {
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
+	/* Pages to top-up the pKVM/EL2 guest pool */
+	struct kvm_hyp_memcache pkvm_memcache;
+
 	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
 	u64 vsesr_el2;
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 25038ac705d8..15b8956051b6 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -39,6 +39,8 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
+int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
+			    enum kvm_pgtable_prot prot);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 2a5eabf4b753..34233d586060 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -46,6 +46,8 @@ struct hyp_page {
 
 	/* Host (non-meta) state. Guarded by the host stage-2 lock. */
 	enum pkvm_page_state host_state : 8;
+
+	u32 host_share_guest_count;
 };
 
 extern u64 __hyp_vmemmap;
@@ -68,7 +70,7 @@ static inline phys_addr_t hyp_virt_to_phys(void *addr)
 
 static inline struct hyp_page *hyp_phys_to_page(phys_addr_t phys)
 {
-	BUILD_BUG_ON(sizeof(struct hyp_page) != sizeof(u32));
+	BUILD_BUG_ON(sizeof(struct hyp_page) != sizeof(u64));
 	return &hyp_vmemmap[hyp_phys_to_pfn(phys)];
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 95d78db315b3..d659462fbf5d 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -211,6 +211,39 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) =  ret;
 }
 
+static int pkvm_refill_memcache(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+
+	return refill_memcache(&hyp_vcpu->vcpu.arch.pkvm_memcache,
+			       host_vcpu->arch.pkvm_memcache.nr_pages,
+			       &host_vcpu->arch.pkvm_memcache);
+}
+
+static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, pfn, host_ctxt, 1);
+	DECLARE_REG(u64, gfn, host_ctxt, 2);
+	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 3);
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	int ret = -EINVAL;
+
+	if (!is_protected_kvm_enabled())
+		goto out;
+
+	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
+	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		goto out;
+
+	ret = pkvm_refill_memcache(hyp_vcpu);
+	if (ret)
+		goto out;
+
+	ret = __pkvm_host_share_guest(pfn, gfn, hyp_vcpu, prot);
+out:
+	cpu_reg(host_ctxt, 1) =  ret;
+}
+
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
@@ -420,6 +453,7 @@ static const hcall_t host_hcall[] = {
 
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
+	HANDLE_FUNC(__pkvm_host_share_guest),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 12bb5445fe47..fb9592e721cf 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -867,6 +867,27 @@ static int hyp_complete_donation(u64 addr,
 	return pkvm_create_mappings_locked(start, end, prot);
 }
 
+static enum pkvm_page_state guest_get_page_state(kvm_pte_t pte, u64 addr)
+{
+	if (!kvm_pte_valid(pte))
+		return PKVM_NOPAGE;
+
+	return pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte));
+}
+
+static int __guest_check_page_state_range(struct pkvm_hyp_vcpu *vcpu, u64 addr,
+					  u64 size, enum pkvm_page_state state)
+{
+	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
+	struct check_walk_data d = {
+		.desired	= state,
+		.get_page_state	= guest_get_page_state,
+	};
+
+	hyp_assert_lock_held(&vm->lock);
+	return check_page_state_range(&vm->pgt, addr, size, &d);
+}
+
 static int check_share(struct pkvm_mem_share *share)
 {
 	const struct pkvm_mem_transition *tx = &share->tx;
@@ -1349,3 +1370,54 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages)
 
 	return ret;
 }
+
+int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
+			    enum kvm_pgtable_prot prot)
+{
+	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
+	u64 phys = hyp_pfn_to_phys(pfn);
+	u64 ipa = hyp_pfn_to_phys(gfn);
+	struct hyp_page *page;
+	int ret;
+
+	if (prot & ~KVM_PGTABLE_PROT_RWX)
+		return -EINVAL;
+
+	ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);
+	if (ret)
+		return ret;
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = __guest_check_page_state_range(vcpu, ipa, PAGE_SIZE, PKVM_NOPAGE);
+	if (ret)
+		goto unlock;
+
+	page = hyp_phys_to_page(phys);
+	switch (page->host_state) {
+	case PKVM_PAGE_OWNED:
+		WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_OWNED));
+		break;
+	case PKVM_PAGE_SHARED_OWNED:
+		if (page->host_share_guest_count)
+			break;
+		/* Only host to np-guest multi-sharing is tolerated */
+		WARN_ON(1);
+		fallthrough;
+	default:
+		ret = -EPERM;
+		goto unlock;
+	}
+
+	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
+				       pkvm_mkstate(prot, PKVM_PAGE_SHARED_BORROWED),
+				       &vcpu->vcpu.arch.pkvm_memcache, 0));
+	page->host_share_guest_count++;
+
+unlock:
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 496d186efb03..0109c36566c8 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -795,6 +795,14 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
 	/* Push the metadata pages to the teardown memcache */
 	for (idx = 0; idx < hyp_vm->nr_vcpus; ++idx) {
 		struct pkvm_hyp_vcpu *hyp_vcpu = hyp_vm->vcpus[idx];
+		struct kvm_hyp_memcache *vcpu_mc = &hyp_vcpu->vcpu.arch.pkvm_memcache;
+
+		while (vcpu_mc->nr_pages) {
+			void *addr = pop_hyp_memcache(vcpu_mc, hyp_phys_to_virt);
+
+			push_hyp_memcache(mc, addr, hyp_virt_to_phys);
+			unmap_donated_memory_noclear(addr, PAGE_SIZE);
+		}
 
 		teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
 	}
-- 
2.47.1.613.gc27f4b7a9f-goog

