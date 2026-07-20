Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778AB436BEE
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 16:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784564671; cv=none; b=SFvoHVExFlRvG3CM4rZXHRkRFNF+nUm/ZE+EAJRrAxEOQ8mr+8PeYuX272L6MGA+h5kSm+29AXEUIO8fEbCM199ZrNhIrz1AwUaulJzzEPyFTwSZ7mD6VpkVBsQkROozDDcDJ2/zZnmW3YoEKQRTYqKJmYnAEVCS/yjJdK6QY0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784564671; c=relaxed/simple;
	bh=K46ORbYIQ7ZqMsF/QW8DBVYINhBr6gEQR9wASE4BnEw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WybejD2/YVjwU5c2ACpfb18uiwvIkFPfjVzJa4GHElFyX3FVUlKNq6OzeaYFx9huf1GufhCk32kes3uHtgeq3VIfaxpYOFvr1ek5yQocqCkpWeWbMyTwYu/eX/SnW4WZWwljcP09ohPnpywahM2sfCW2Z6KkKw/bjQwOUqbwT1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a9FQzt1s; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a9FQzt1s"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784564660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/TRPSX3J5InSXjftas7xX2k53zlMJOLoFrumSzVW9P4=;
	b=a9FQzt1sft5w+RF4KEpCwHdSgeRH9IEVSEpH2hTCm8PJuU0iV3xwCg0t8LCFAc7seSim8e
	SbOGUrQ8n4kEbSUIgYUzWPr4TTucb+0BD/BwoxDvBY7mf5cdvwiT5YqIaQc0X11fc3GHxx
	N3UkzCcADZ51snRk6o9qvkbtR3hEk58=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	alexandru.elisei@arm.com,
	vdonnefort@google.com,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	ardb@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	tabba@google.com,
	fuad.tabba@linux.dev
Subject: [PATCH v1 10/11] KVM: arm64: nVHE: Check hypercall handlers against the declared ABI
Date: Mon, 20 Jul 2026 17:24:11 +0100
Message-Id: <20260720162412.1401272-1-fuad.tabba@linux.dev>
In-Reply-To: <20260720161343.1367007-1-fuad.tabba@linux.dev>
References: <20260720161343.1367007-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Each hypercall handler unmarshals its arguments from the host context
with hand-written DECLARE_REG() casts that nothing ties to what the
caller passed: a handler can disagree with its caller in argument type,
count or register index without a diagnostic.

Generate the unmarshalling instead. DEFINE_KVM_HOST_HCALL() expands to
the handle_<name>() glue, modelled on the syscall wrappers, and checks
the handler's parameter list against the signature declared in
kvm_hcall.h, so both ends of every hypercall are now compiled against
the same declaration. Handler bodies keep their logic and lose the
DECLARE_REG() and return-register boilerplate. The compiled handlers
are instruction-for-instruction identical, apart from flush_hyp_vcpu()
and sync_hyp_vcpu() now being inlined into their only caller.

Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_hcall.h |  19 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 420 ++++++++++++++---------------
 2 files changed, 213 insertions(+), 226 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hcall.h b/arch/arm64/include/asm/kvm_hcall.h
index 51bfd14748464..6aa2df90a14a4 100644
--- a/arch/arm64/include/asm/kvm_hcall.h
+++ b/arch/arm64/include/asm/kvm_hcall.h
@@ -41,6 +41,8 @@ struct vgic_v5_cpu_if;
 #define __KVM_HCALL_MAP(n, ...) __KVM_HCALL_MAP##n(__VA_ARGS__)
 
 #define __KVM_HCALL_DECL(t, a)	t a
+#define __KVM_HCALL_LONG(t, a)	unsigned long a
+#define __KVM_HCALL_CAST(t, a)	(__force t) a
 #define __KVM_HCALL_ARGS(t, a)	a
 
 #ifndef __KVM_NVHE_HYPERVISOR__
@@ -124,10 +126,19 @@ struct vgic_v5_cpu_if;
 #define kvm_call_hyp_ret(f, ...) f(__VA_ARGS__)
 #define kvm_call_hyp_nvhe(f, ...) f(__VA_ARGS__)
 
-#define DECLARE_KVM_HOST_HCALL(ret, name, x, ...)
-#define DECLARE_KVM_HOST_HCALL_VOID(name, x, ...)
-#define DECLARE_KVM_HOST_HCALL0(ret, name)
-#define DECLARE_KVM_HOST_HCALL0_VOID(name)
+/*
+ * At EL2 each declaration emits the canonical signature of the hypercall,
+ * which DEFINE_KVM_HOST_HCALL() in hyp-main.c checks the handler
+ * definition against.
+ */
+#define DECLARE_KVM_HOST_HCALL(ret, name, x, ...)			\
+	typedef ret kvm_host_hcall_sig_##name(__KVM_HCALL_MAP(x, __KVM_HCALL_DECL, __VA_ARGS__));
+#define DECLARE_KVM_HOST_HCALL_VOID(name, x, ...)			\
+	typedef void kvm_host_hcall_sig_##name(__KVM_HCALL_MAP(x, __KVM_HCALL_DECL, __VA_ARGS__));
+#define DECLARE_KVM_HOST_HCALL0(ret, name)				\
+	typedef ret kvm_host_hcall_sig_##name(void);
+#define DECLARE_KVM_HOST_HCALL0_VOID(name)				\
+	typedef void kvm_host_hcall_sig_##name(void);
 #endif /* __KVM_NVHE_HYPERVISOR__ */
 
 /* Hypercalls that are unavailable once pKVM has finalised. */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 7537d422deab3..f2501249f4391 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -24,6 +24,62 @@
 
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
+/*
+ * Define a hypercall handler: handle_<name> unmarshals the arguments from
+ * the host context and hands them, correctly typed, to the body that
+ * follows the macro. The parameter list is type-checked against the
+ * signature declared in <asm/kvm_hcall.h>, so the handler cannot drift
+ * from what the typed caller stubs marshal in. Modelled on the syscall
+ * wrappers.
+ */
+#define KVM_HOST_HCALL_REGS(x)						\
+	__KVM_HCALL_MAP(x, __KVM_HCALL_ARGS				\
+		,, cpu_reg(host_ctxt, 1),, cpu_reg(host_ctxt, 2)	\
+		,, cpu_reg(host_ctxt, 3),, cpu_reg(host_ctxt, 4)	\
+		,, cpu_reg(host_ctxt, 5),, cpu_reg(host_ctxt, 6))
+
+#define DEFINE_KVM_HOST_HCALL(ret, name, x, ...)			\
+	static kvm_host_hcall_sig_##name __do_##name;			\
+	static __always_inline						\
+	ret __se_##name(__KVM_HCALL_MAP(x, __KVM_HCALL_LONG, __VA_ARGS__)) \
+	{								\
+		return __do_##name(__KVM_HCALL_MAP(x, __KVM_HCALL_CAST, __VA_ARGS__)); \
+	}								\
+	static void handle_##name(struct kvm_cpu_context *host_ctxt)	\
+	{								\
+		cpu_reg(host_ctxt, 1) = __se_##name(KVM_HOST_HCALL_REGS(x)); \
+	}								\
+	static ret __do_##name(__KVM_HCALL_MAP(x, __KVM_HCALL_DECL, __VA_ARGS__))
+
+#define DEFINE_KVM_HOST_HCALL_VOID(name, x, ...)			\
+	static kvm_host_hcall_sig_##name __do_##name;			\
+	static __always_inline						\
+	void __se_##name(__KVM_HCALL_MAP(x, __KVM_HCALL_LONG, __VA_ARGS__)) \
+	{								\
+		__do_##name(__KVM_HCALL_MAP(x, __KVM_HCALL_CAST, __VA_ARGS__)); \
+	}								\
+	static void handle_##name(struct kvm_cpu_context *host_ctxt)	\
+	{								\
+		__se_##name(KVM_HOST_HCALL_REGS(x));			\
+	}								\
+	static void __do_##name(__KVM_HCALL_MAP(x, __KVM_HCALL_DECL, __VA_ARGS__))
+
+#define DEFINE_KVM_HOST_HCALL0(ret, name)				\
+	static kvm_host_hcall_sig_##name __do_##name;			\
+	static void handle_##name(struct kvm_cpu_context *host_ctxt)	\
+	{								\
+		cpu_reg(host_ctxt, 1) = __do_##name();			\
+	}								\
+	static ret __do_##name(void)
+
+#define DEFINE_KVM_HOST_HCALL0_VOID(name)				\
+	static kvm_host_hcall_sig_##name __do_##name;			\
+	static void handle_##name(struct kvm_cpu_context *host_ctxt)	\
+	{								\
+		__do_##name();						\
+	}								\
+	static void __do_##name(void)
+
 /* Number of implemented GICv3 LRs. Used by flush_hyp_vcpu(). */
 unsigned int hyp_gicv3_nr_lr;
 
@@ -185,11 +241,9 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 		host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
 }
 
-static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL_VOID(__pkvm_vcpu_load, 3,
+	pkvm_handle_t, handle, unsigned int, vcpu_idx, u64, hcr_el2)
 {
-	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
-	DECLARE_REG(unsigned int, vcpu_idx, host_ctxt, 2);
-	DECLARE_REG(u64, hcr_el2, host_ctxt, 3);
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 
 	hyp_vcpu = pkvm_load_hyp_vcpu(handle, vcpu_idx);
@@ -206,7 +260,7 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
 	}
 }
 
-static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL0_VOID(__pkvm_vcpu_put)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 
@@ -214,9 +268,9 @@ static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
 		pkvm_put_hyp_vcpu(hyp_vcpu);
 }
 
-static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __kvm_vcpu_run, 1,
+	struct kvm_vcpu *, host_vcpu)
 {
-	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 1);
 	int ret;
 
 	if (unlikely(is_protected_kvm_enabled())) {
@@ -228,15 +282,11 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 		 * loading a vcpu. Therefore, if SME features enabled the host
 		 * is misbehaving.
 		 */
-		if (unlikely(system_supports_sme() && read_sysreg_s(SYS_SVCR))) {
-			ret = -EINVAL;
-			goto out;
-		}
+		if (unlikely(system_supports_sme() && read_sysreg_s(SYS_SVCR)))
+			return -EINVAL;
 
-		if (!hyp_vcpu) {
-			ret = -EINVAL;
-			goto out;
-		}
+		if (!hyp_vcpu)
+			return -EINVAL;
 
 		flush_hyp_vcpu(hyp_vcpu);
 
@@ -251,8 +301,8 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 		ret = __kvm_vcpu_run(vcpu);
 		fpsimd_lazy_switch_to_host(vcpu);
 	}
-out:
-	cpu_reg(host_ctxt, 1) =  ret;
+
+	return ret;
 }
 
 static int pkvm_refill_memcache(struct pkvm_hyp_vcpu *hyp_vcpu)
@@ -264,184 +314,150 @@ static int pkvm_refill_memcache(struct pkvm_hyp_vcpu *hyp_vcpu)
 			       &host_vcpu->arch.pkvm_memcache);
 }
 
-static void handle___pkvm_host_donate_guest(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_donate_guest, 2,
+	u64, pfn, u64, gfn)
 {
-	DECLARE_REG(u64, pfn, host_ctxt, 1);
-	DECLARE_REG(u64, gfn, host_ctxt, 2);
 	struct pkvm_hyp_vcpu *hyp_vcpu;
-	int ret = -EINVAL;
+	int ret;
 
 	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 	if (!hyp_vcpu || !pkvm_hyp_vcpu_is_protected(hyp_vcpu))
-		goto out;
+		return -EINVAL;
 
 	ret = pkvm_refill_memcache(hyp_vcpu);
 	if (ret)
-		goto out;
+		return ret;
 
-	ret = __pkvm_host_donate_guest(pfn, gfn, hyp_vcpu);
-out:
-	cpu_reg(host_ctxt, 1) =  ret;
+	return __pkvm_host_donate_guest(pfn, gfn, hyp_vcpu);
 }
 
-static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_share_guest, 4,
+	u64, pfn, u64, gfn, u64, nr_pages, u64, prot)
 {
-	DECLARE_REG(u64, pfn, host_ctxt, 1);
-	DECLARE_REG(u64, gfn, host_ctxt, 2);
-	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
-	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 4);
 	struct pkvm_hyp_vcpu *hyp_vcpu;
-	int ret = -EINVAL;
+	int ret;
 
 	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
-		goto out;
+		return -EINVAL;
 
 	ret = pkvm_refill_memcache(hyp_vcpu);
 	if (ret)
-		goto out;
+		return ret;
 
-	ret = __pkvm_host_share_guest(pfn, gfn, nr_pages, hyp_vcpu, prot);
-out:
-	cpu_reg(host_ctxt, 1) =  ret;
+	return __pkvm_host_share_guest(pfn, gfn, nr_pages, hyp_vcpu, prot);
 }
 
-static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_unshare_guest, 3,
+	pkvm_handle_t, handle, u64, gfn, u64, nr_pages)
 {
-	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
-	DECLARE_REG(u64, gfn, host_ctxt, 2);
-	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
 	struct pkvm_hyp_vm *hyp_vm;
-	int ret = -EINVAL;
+	int ret;
 
 	hyp_vm = get_np_pkvm_hyp_vm(handle);
 	if (!hyp_vm)
-		goto out;
+		return -EINVAL;
 
 	ret = __pkvm_host_unshare_guest(gfn, nr_pages, hyp_vm);
 	put_pkvm_hyp_vm(hyp_vm);
-out:
-	cpu_reg(host_ctxt, 1) =  ret;
+
+	return ret;
 }
 
-static void handle___pkvm_host_relax_perms_guest(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_relax_perms_guest, 2,
+	u64, gfn, u64, prot)
 {
-	DECLARE_REG(u64, gfn, host_ctxt, 1);
-	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 2);
 	struct pkvm_hyp_vcpu *hyp_vcpu;
-	int ret = -EINVAL;
 
 	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
-		goto out;
+		return -EINVAL;
 
-	ret = __pkvm_host_relax_perms_guest(gfn, hyp_vcpu, prot);
-out:
-	cpu_reg(host_ctxt, 1) = ret;
+	return __pkvm_host_relax_perms_guest(gfn, hyp_vcpu, prot);
 }
 
-static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_wrprotect_guest, 3,
+	pkvm_handle_t, handle, u64, gfn, u64, nr_pages)
 {
-	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
-	DECLARE_REG(u64, gfn, host_ctxt, 2);
-	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
 	struct pkvm_hyp_vm *hyp_vm;
-	int ret = -EINVAL;
+	int ret;
 
 	hyp_vm = get_np_pkvm_hyp_vm(handle);
 	if (!hyp_vm)
-		goto out;
+		return -EINVAL;
 
 	ret = __pkvm_host_wrprotect_guest(gfn, nr_pages, hyp_vm);
 	put_pkvm_hyp_vm(hyp_vm);
-out:
-	cpu_reg(host_ctxt, 1) = ret;
+
+	return ret;
 }
 
-static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_test_clear_young_guest, 4,
+	pkvm_handle_t, handle, u64, gfn, u64, nr_pages, bool, mkold)
 {
-	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
-	DECLARE_REG(u64, gfn, host_ctxt, 2);
-	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
-	DECLARE_REG(bool, mkold, host_ctxt, 4);
 	struct pkvm_hyp_vm *hyp_vm;
-	int ret = -EINVAL;
+	int ret;
 
 	hyp_vm = get_np_pkvm_hyp_vm(handle);
 	if (!hyp_vm)
-		goto out;
+		return -EINVAL;
 
 	ret = __pkvm_host_test_clear_young_guest(gfn, nr_pages, mkold, hyp_vm);
 	put_pkvm_hyp_vm(hyp_vm);
-out:
-	cpu_reg(host_ctxt, 1) = ret;
+
+	return ret;
 }
 
-static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_mkyoung_guest, 1,
+	u64, gfn)
 {
-	DECLARE_REG(u64, gfn, host_ctxt, 1);
 	struct pkvm_hyp_vcpu *hyp_vcpu;
-	int ret = -EINVAL;
 
 	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
-		goto out;
+		return -EINVAL;
 
-	ret = __pkvm_host_mkyoung_guest(gfn, hyp_vcpu);
-out:
-	cpu_reg(host_ctxt, 1) =  ret;
+	return __pkvm_host_mkyoung_guest(gfn, hyp_vcpu);
 }
 
-static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL_VOID(__kvm_adjust_pc, 1,
+	struct kvm_vcpu *, vcpu)
 {
-	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
-
 	__kvm_adjust_pc(kern_hyp_va(vcpu));
 }
 
-static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL0_VOID(__kvm_flush_vm_context)
 {
 	__kvm_flush_vm_context();
 }
 
-static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL_VOID(__kvm_tlb_flush_vmid_ipa, 3,
+	struct kvm_s2_mmu *, mmu, phys_addr_t, ipa, int, level)
 {
-	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
-	DECLARE_REG(phys_addr_t, ipa, host_ctxt, 2);
-	DECLARE_REG(int, level, host_ctxt, 3);
-
 	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
 }
 
-static void handle___kvm_tlb_flush_vmid_ipa_nsh(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL_VOID(__kvm_tlb_flush_vmid_ipa_nsh, 3,
+	struct kvm_s2_mmu *, mmu, phys_addr_t, ipa, int, level)
 {
-	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
-	DECLARE_REG(phys_addr_t, ipa, host_ctxt, 2);
-	DECLARE_REG(int, level, host_ctxt, 3);
-
 	__kvm_tlb_flush_vmid_ipa_nsh(kern_hyp_va(mmu), ipa, level);
 }
 
-static void
-handle___kvm_tlb_flush_vmid_range(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL_VOID(__kvm_tlb_flush_vmid_range, 3,
+	struct kvm_s2_mmu *, mmu, phys_addr_t, start, unsigned long, pages)
 {
-	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
-	DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
-	DECLARE_REG(unsigned long, pages, host_ctxt, 3);
-
 	__kvm_tlb_flush_vmid_range(kern_hyp_va(mmu), start, pages);
 }
 
-static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL_VOID(__kvm_tlb_flush_vmid, 1,
+	struct kvm_s2_mmu *, mmu)
 {
-	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
-
 	__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
 }
 
-static void handle___pkvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL_VOID(__pkvm_tlb_flush_vmid, 1,
+	pkvm_handle_t, handle)
 {
-	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
 	struct pkvm_hyp_vm *hyp_vm = get_np_pkvm_hyp_vm(handle);
 
 	if (!hyp_vm)
@@ -451,19 +467,19 @@ static void handle___pkvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 	put_pkvm_hyp_vm(hyp_vm);
 }
 
-static void handle___kvm_flush_cpu_context(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL_VOID(__kvm_flush_cpu_context, 1,
+	struct kvm_s2_mmu *, mmu)
 {
-	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
-
 	__kvm_flush_cpu_context(kern_hyp_va(mmu));
 }
 
-static void handle___kvm_timer_set_cntvoff(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL_VOID(__kvm_timer_set_cntvoff, 1,
+	u64, cntvoff)
 {
-	__kvm_timer_set_cntvoff(cpu_reg(host_ctxt, 1));
+	__kvm_timer_set_cntvoff(cntvoff);
 }
 
-static void handle___kvm_enable_ssbs(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL0_VOID(__kvm_enable_ssbs)
 {
 	u64 tmp;
 
@@ -472,72 +488,61 @@ static void handle___kvm_enable_ssbs(struct kvm_cpu_context *host_ctxt)
 	write_sysreg_el2(tmp, SYS_SCTLR);
 }
 
-static void handle___vgic_v3_get_gic_config(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL0(u64, __vgic_v3_get_gic_config)
 {
-	cpu_reg(host_ctxt, 1) = __vgic_v3_get_gic_config();
+	return __vgic_v3_get_gic_config();
 }
 
-static void handle___vgic_v3_init_lrs(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL0_VOID(__vgic_v3_init_lrs)
 {
 	__vgic_v3_init_lrs();
 }
 
-static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL_VOID(__vgic_v3_save_aprs, 1,
+	struct vgic_v3_cpu_if *, cpu_if)
 {
-	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
-
 	__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
 }
 
-static void handle___vgic_v3_restore_vmcr_aprs(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL_VOID(__vgic_v3_restore_vmcr_aprs, 1,
+	struct vgic_v3_cpu_if *, cpu_if)
 {
-	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
-
 	__vgic_v3_restore_vmcr_aprs(kern_hyp_va(cpu_if));
 }
 
-static void handle___pkvm_init(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_init, 4,
+	phys_addr_t, phys, unsigned long, size,
+	unsigned long *, per_cpu_base, u32, hyp_va_bits)
 {
-	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
-	DECLARE_REG(unsigned long, size, host_ctxt, 2);
-	DECLARE_REG(unsigned long *, per_cpu_base, host_ctxt, 3);
-	DECLARE_REG(u32, hyp_va_bits, host_ctxt, 4);
-
 	/*
 	 * __pkvm_init() will return only if an error occurred, otherwise it
 	 * will tail-call in __pkvm_init_finalise() which will have to deal
 	 * with the host context directly.
 	 */
-	cpu_reg(host_ctxt, 1) = __pkvm_init(phys, size, per_cpu_base, hyp_va_bits);
+	return __pkvm_init(phys, size, per_cpu_base, hyp_va_bits);
 }
 
-static void handle___pkvm_cpu_set_vector(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_cpu_set_vector, 1,
+	enum arm64_hyp_spectre_vector, slot)
 {
-	DECLARE_REG(enum arm64_hyp_spectre_vector, slot, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = pkvm_cpu_set_vector(slot);
+	return pkvm_cpu_set_vector(slot);
 }
 
-static void handle___pkvm_host_share_hyp(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_share_hyp, 1,
+	u64, pfn)
 {
-	DECLARE_REG(u64, pfn, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = __pkvm_host_share_hyp(pfn);
+	return __pkvm_host_share_hyp(pfn);
 }
 
-static void handle___pkvm_host_unshare_hyp(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_unshare_hyp, 1,
+	u64, pfn)
 {
-	DECLARE_REG(u64, pfn, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = __pkvm_host_unshare_hyp(pfn);
+	return __pkvm_host_unshare_hyp(pfn);
 }
 
-static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(unsigned long, __pkvm_create_private_mapping, 3,
+	phys_addr_t, phys, size_t, size, u64, prot)
 {
-	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
-	DECLARE_REG(size_t, size, host_ctxt, 2);
-	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 3);
-
 	/*
 	 * __pkvm_create_private_mapping() populates a pointer with the
 	 * hypervisor start address of the allocation.
@@ -554,154 +559,125 @@ static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ct
 	if (err)
 		haddr = (unsigned long)ERR_PTR(err);
 
-	cpu_reg(host_ctxt, 1) = haddr;
+	return haddr;
 }
 
-static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL0(int, __pkvm_prot_finalize)
 {
-	cpu_reg(host_ctxt, 1) = __pkvm_prot_finalize();
+	return __pkvm_prot_finalize();
 }
 
-static void handle___pkvm_reserve_vm(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL0(int, __pkvm_reserve_vm)
 {
-	cpu_reg(host_ctxt, 1) = __pkvm_reserve_vm();
+	return __pkvm_reserve_vm();
 }
 
-static void handle___pkvm_unreserve_vm(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL_VOID(__pkvm_unreserve_vm, 1,
+	pkvm_handle_t, handle)
 {
-	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
-
 	__pkvm_unreserve_vm(handle);
 }
 
-static void handle___pkvm_init_vm(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_init_vm, 3,
+	struct kvm *, host_kvm, void *, vm_hva, void *, pgd_hva)
 {
-	DECLARE_REG(struct kvm *, host_kvm, host_ctxt, 1);
-	DECLARE_REG(void *, vm_hva, host_ctxt, 2);
-	DECLARE_REG(void *, pgd_hva, host_ctxt, 3);
-
-	host_kvm = kern_hyp_va(host_kvm);
-	cpu_reg(host_ctxt, 1) = __pkvm_init_vm(host_kvm, vm_hva, pgd_hva);
+	return __pkvm_init_vm(kern_hyp_va(host_kvm), vm_hva, pgd_hva);
 }
 
-static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_init_vcpu, 3,
+	pkvm_handle_t, handle, struct kvm_vcpu *, host_vcpu,
+	void *, vcpu_hva)
 {
-	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
-	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 2);
-	DECLARE_REG(void *, vcpu_hva, host_ctxt, 3);
-
-	host_vcpu = kern_hyp_va(host_vcpu);
-	cpu_reg(host_ctxt, 1) = __pkvm_init_vcpu(handle, host_vcpu, vcpu_hva);
+	return __pkvm_init_vcpu(handle, kern_hyp_va(host_vcpu), vcpu_hva);
 }
 
-static void handle___pkvm_vcpu_in_poison_fault(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL0(int, __pkvm_vcpu_in_poison_fault)
 {
-	int ret;
 	struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 
-	ret = hyp_vcpu ? __pkvm_vcpu_in_poison_fault(hyp_vcpu) : -EINVAL;
-	cpu_reg(host_ctxt, 1) = ret;
+	return hyp_vcpu ? __pkvm_vcpu_in_poison_fault(hyp_vcpu) : -EINVAL;
 }
 
-static void handle___pkvm_force_reclaim_guest_page(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_force_reclaim_guest_page, 1,
+	phys_addr_t, phys)
 {
-	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = __pkvm_host_force_reclaim_page_guest(phys);
+	return __pkvm_host_force_reclaim_page_guest(phys);
 }
 
-static void handle___pkvm_reclaim_dying_guest_page(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_reclaim_dying_guest_page, 2,
+	pkvm_handle_t, handle, u64, gfn)
 {
-	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
-	DECLARE_REG(u64, gfn, host_ctxt, 2);
-
-	cpu_reg(host_ctxt, 1) = __pkvm_reclaim_dying_guest_page(handle, gfn);
+	return __pkvm_reclaim_dying_guest_page(handle, gfn);
 }
 
-static void handle___pkvm_start_teardown_vm(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_start_teardown_vm, 1,
+	pkvm_handle_t, handle)
 {
-	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = __pkvm_start_teardown_vm(handle);
+	return __pkvm_start_teardown_vm(handle);
 }
 
-static void handle___pkvm_finalize_teardown_vm(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_finalize_teardown_vm, 1,
+	pkvm_handle_t, handle)
 {
-	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = __pkvm_finalize_teardown_vm(handle);
+	return __pkvm_finalize_teardown_vm(handle);
 }
 
-static void handle___tracing_load(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __tracing_load, 2,
+	void *, desc_hva, size_t, desc_size)
 {
-	DECLARE_REG(void *, desc_hva, host_ctxt, 1);
-	DECLARE_REG(size_t, desc_size, host_ctxt, 2);
-
-	cpu_reg(host_ctxt, 1) = __tracing_load(desc_hva, desc_size);
+	return __tracing_load(desc_hva, desc_size);
 }
 
-static void handle___tracing_unload(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL0_VOID(__tracing_unload)
 {
 	__tracing_unload();
 }
 
-static void handle___tracing_enable(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __tracing_enable, 1,
+	bool, enable)
 {
-	DECLARE_REG(bool, enable, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = __tracing_enable(enable);
+	return __tracing_enable(enable);
 }
 
-static void handle___tracing_swap_reader(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __tracing_swap_reader, 1,
+	unsigned int, cpu)
 {
-	DECLARE_REG(unsigned int, cpu, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = __tracing_swap_reader(cpu);
+	return __tracing_swap_reader(cpu);
 }
 
-static void handle___tracing_update_clock(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL_VOID(__tracing_update_clock, 4,
+	u32, mult, u32, shift, u64, epoch_ns, u64, epoch_cyc)
 {
-	DECLARE_REG(u32, mult, host_ctxt, 1);
-	DECLARE_REG(u32, shift, host_ctxt, 2);
-	DECLARE_REG(u64, epoch_ns, host_ctxt, 3);
-	DECLARE_REG(u64, epoch_cyc, host_ctxt, 4);
-
 	__tracing_update_clock(mult, shift, epoch_ns, epoch_cyc);
 }
 
-static void handle___tracing_reset(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __tracing_reset, 1,
+	unsigned int, cpu)
 {
-	DECLARE_REG(unsigned int, cpu, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = __tracing_reset(cpu);
+	return __tracing_reset(cpu);
 }
 
-static void handle___tracing_enable_event(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __tracing_enable_event, 2,
+	unsigned short, id, bool, enable)
 {
-	DECLARE_REG(unsigned short, id, host_ctxt, 1);
-	DECLARE_REG(bool, enable, host_ctxt, 2);
-
-	cpu_reg(host_ctxt, 1) = __tracing_enable_event(id, enable);
+	return __tracing_enable_event(id, enable);
 }
 
-static void handle___tracing_write_event(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL_VOID(__tracing_write_event, 1,
+	u64, id)
 {
-	DECLARE_REG(u64, id, host_ctxt, 1);
-
 	trace_selftest(id);
 }
 
-static void handle___vgic_v5_save_apr(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL_VOID(__vgic_v5_save_apr, 1,
+	struct vgic_v5_cpu_if *, cpu_if)
 {
-	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
-
 	__vgic_v5_save_apr(kern_hyp_va(cpu_if));
 }
 
-static void handle___vgic_v5_restore_vmcr_apr(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL_VOID(__vgic_v5_restore_vmcr_apr, 1,
+	struct vgic_v5_cpu_if *, cpu_if)
 {
-	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
-
 	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
 }
 
-- 
2.39.5

