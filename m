Received: from mta0.migadu.com (out-66.mta0.migadu.com [91.218.175.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1174E375F88
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 14:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271474; cv=none; b=ltjx1AZKwdzKnnmn/RwZKocpwVuTh1NurcBJD2Lj0IX/CNG2Ns/AXPPve2w6ejzgPSU4wgqKEPIjfrExszGVxl6iZR992oxsd5JQV+1cTotZ+cKazisBvbVXt+QFupxKNEFIjQZxdZSFc4QmWwfPpCChNa5Sx/DZDM4GwK0Jge0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271474; c=relaxed/simple;
	bh=FpWtl4wzXI7XdGDv8U/q1SNyBuYdvIbrrIp7Sw8K448=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rp4htEqJCRATgAshFqLj0i1qedmbG9iJ3Iy0OfRxKnVxB5iW6cSqMxlw4vpsp5xr+f+SyYJv6cHbvAiaMc+q32slK7egYEa0mzgo+gM3G5/7PsCLr88irM4us694PH1P2rFM3k3rErkneJkk1keWuNHyfyPDdHpOy42Z+dP1hfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kc3D/FEH; arc=none smtp.client-ip=91.218.175.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kc3D/FEH"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=FpWtl4wzXI7XdGDv8U/q1SNyBuYdvIbrrIp7Sw8K448=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788271468; v=1; x=1788876268;
 b=Kc3D/FEHm3olWu0+bykbgeeJhbDZTCkshrDv/NxzgvNHTGW6vZzjt/WjarbDu3x1nubX8Hre
 r+2ZyAN8xyqV2uuTM6iTNyTh35m1m8Vwgh5pQCH6LVEiKIdC3Zz/dSptr6JOQjC1qqveaTYxiaU
 dbWeBFY21YxtlbhpS4oopiHg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9003767039424a1a;
	Tue, 01 Sep 2026 14:04:28 +0000
X-Mizu-Trace-ID: 9003767039424a1a
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH v4 10/11] KVM: arm64: nVHE: Check hypercall handlers against the declared ABI
Date: Tue,  1 Sep 2026 15:03:25 +0100
Message-Id: <20260901140326.3812068-11-fuad.tabba@linux.dev>
In-Reply-To: <20260901140326.3812068-1-fuad.tabba@linux.dev>
References: <20260901140326.3812068-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each hypercall handler unmarshals its arguments from the host context
with hand-written DECLARE_REG() casts that nothing ties to what the
caller passed: a handler can disagree with its caller in argument type,
count or register index without a diagnostic.

Generate the unmarshalling instead. DEFINE_KVM_HOST_HCALL() expands to
the handle_<name>() glue, modelled on the syscall wrappers, and checks
the handler's parameter list against the signature declared in
kvm_hcall.h, so both ends of every hypercall are now compiled against
the same declaration. Handler bodies keep their logic and lose the
DECLARE_REG() and return-register boilerplate. The two
get_host_hyp_vcpus() macros existed only to wrap DECLARE_REG(), so one
is dropped and the other becomes a function. The compiled handlers are
instruction-for-instruction identical, apart from flush_hyp_vcpu() and
sync_hyp_vcpu() now being inlined into their only caller.

The return-register store is picked by the declared return type, so a
void handler needs no macro of its own. The type is pasted into the
store's name, which has to be a single word, so
__pkvm_create_private_mapping is declared ulong.

Assisted-by: Antigravity:gemini-3.1-pro
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_hcall.h |  13 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 438 +++++++++++++----------------
 2 files changed, 209 insertions(+), 242 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hcall.h b/arch/arm64/include/asm/kvm_hcall.h
index c2efcb89e6e70..c709991d10cda 100644
--- a/arch/arm64/include/asm/kvm_hcall.h
+++ b/arch/arm64/include/asm/kvm_hcall.h
@@ -44,6 +44,8 @@ struct vgic_v5_cpu_if;
 #define __KVM_HCALL_MAP(m, ...) __KVM_HCALL_MAP_N(COUNT_ARGS(__VA_ARGS__), m, __VA_ARGS__)
 
 #define __KVM_HCALL_DECL(t, a)	t a
+#define __KVM_HCALL_LONG(t, a)	unsigned long a
+#define __KVM_HCALL_CAST(t, a)	(__force t) a
 #define __KVM_HCALL_ARGS(t, a)	a
 
 #ifndef __KVM_NVHE_HYPERVISOR__
@@ -113,8 +115,15 @@ struct vgic_v5_cpu_if;
 #define kvm_call_hyp_ret(f, ...) f(__VA_ARGS__)
 #define kvm_call_hyp_nvhe(f, ...) f(__VA_ARGS__)
 
-#define DECLARE_KVM_HOST_HCALL(ret, name, ...)
-#define DECLARE_KVM_HOST_HCALL0(ret, name)
+/*
+ * At EL2 each declaration emits the canonical signature of the hypercall,
+ * which DEFINE_KVM_HOST_HCALL() in hyp-main.c checks the handler
+ * definition against.
+ */
+#define DECLARE_KVM_HOST_HCALL(ret, name, ...)				\
+	typedef ret kvm_host_hcall_sig_##name(__KVM_HCALL_MAP(__KVM_HCALL_DECL, __VA_ARGS__));
+#define DECLARE_KVM_HOST_HCALL0(ret, name)				\
+	typedef ret kvm_host_hcall_sig_##name(void);
 #endif /* __KVM_NVHE_HYPERVISOR__ */
 
 /* Hypercalls that are unavailable once pKVM has finalised. */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 61fcb382197d9..9085f46c2880f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -26,6 +26,48 @@
 
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
+/*
+ * Define a hypercall handler: handle_<name> unmarshals the arguments from
+ * the host context and hands them, correctly typed, to the body that
+ * follows the macro. The parameter list is type-checked against the
+ * signature declared in <asm/kvm_hcall.h>, so the handler cannot drift
+ * from what the typed caller stubs marshal in. Modelled on the syscall
+ * wrappers.
+ */
+/* Truncate the fixed list of argument registers to the declared signature. */
+#define KVM_HOST_HCALL_REGS(...)					\
+	__KVM_HCALL_MAP_N(COUNT_ARGS(__VA_ARGS__), __KVM_HCALL_ARGS	\
+		,, cpu_reg(host_ctxt, 1),, cpu_reg(host_ctxt, 2)	\
+		,, cpu_reg(host_ctxt, 3),, cpu_reg(host_ctxt, 4)	\
+		,, cpu_reg(host_ctxt, 5),, cpu_reg(host_ctxt, 6))
+
+#define set_cpu_reg_ulong(ctxt, r, v)	{ cpu_reg(ctxt, r) = v; }
+#define set_cpu_reg_u64(ctxt, r, v)	{ cpu_reg(ctxt, r) = v; }
+#define set_cpu_reg_int(ctxt, r, v)	{ cpu_reg(ctxt, r) = v; }
+#define set_cpu_reg_void(ctxt, r, v)	{ v; }
+#define set_cpu_reg(ctxt, r, t, v)	set_cpu_reg_##t(ctxt, r, v)
+
+#define DEFINE_KVM_HOST_HCALL(ret, name, ...)				\
+	static kvm_host_hcall_sig_##name __do_##name;			\
+	static __always_inline						\
+	ret __se_##name(__KVM_HCALL_MAP(__KVM_HCALL_LONG, __VA_ARGS__))	\
+	{								\
+		return __do_##name(__KVM_HCALL_MAP(__KVM_HCALL_CAST, __VA_ARGS__)); \
+	}								\
+	static void handle_##name(struct kvm_cpu_context *host_ctxt)	\
+	{								\
+		set_cpu_reg(host_ctxt, 1, ret, __se_##name(KVM_HOST_HCALL_REGS(__VA_ARGS__))); \
+	}								\
+	static ret __do_##name(__KVM_HCALL_MAP(__KVM_HCALL_DECL, __VA_ARGS__))
+
+#define DEFINE_KVM_HOST_HCALL0(ret, name)				\
+	static kvm_host_hcall_sig_##name __do_##name;			\
+	static void handle_##name(struct kvm_cpu_context *host_ctxt)	\
+	{								\
+		set_cpu_reg(host_ctxt, 1, ret, __do_##name());		\
+	}								\
+	static ret __do_##name(void)
+
 /* Number of implemented GICv3 LRs. Used by flush_hyp_vcpu(). */
 unsigned int hyp_gicv3_nr_lr;
 
@@ -279,11 +321,9 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	sync_hyp_vgic_state(hyp_vcpu);
 }
 
-static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(void, __pkvm_vcpu_load,
+	pkvm_handle_t, handle, unsigned int, vcpu_idx, u64, hcr_el2)
 {
-	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
-	DECLARE_REG(unsigned int, vcpu_idx, host_ctxt, 2);
-	DECLARE_REG(u64, hcr_el2, host_ctxt, 3);
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 
 	hyp_vcpu = pkvm_load_hyp_vcpu(handle, vcpu_idx);
@@ -300,7 +340,7 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
 	}
 }
 
-static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL0(void, __pkvm_vcpu_put)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 
@@ -316,7 +356,7 @@ static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
 	}
 }
 
-static void handle___pkvm_vcpu_sync_state(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL0(void, __pkvm_vcpu_sync_state)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 
@@ -346,34 +386,26 @@ static struct kvm_vcpu *__get_host_hyp_vcpus(struct kvm_vcpu *arg,
 	return host_vcpu;
 }
 
-#define get_host_hyp_vcpus(ctxt, regnr, hyp_vcpup)			\
-	({								\
-		DECLARE_REG(struct kvm_vcpu *, __vcpu, ctxt, regnr);	\
-		__get_host_hyp_vcpus(__vcpu, hyp_vcpup);		\
-	})
+static struct kvm_vcpu *
+__get_host_hyp_vcpus_from_vgic_v3_cpu_if(struct vgic_v3_cpu_if *cpu_if,
+					 struct pkvm_hyp_vcpu **hyp_vcpup)
+{
+	struct kvm_vcpu *vcpu = container_of(cpu_if, struct kvm_vcpu,
+					     arch.vgic_cpu.vgic_v3);
 
-#define get_host_hyp_vcpus_from_vgic_v3_cpu_if(ctxt, regnr, hyp_vcpup)		\
-	({									\
-		DECLARE_REG(struct vgic_v3_cpu_if *, cif, ctxt, regnr);\
-		struct kvm_vcpu *__vcpu = container_of(cif,			\
-						       struct kvm_vcpu,		\
-						       arch.vgic_cpu.vgic_v3);	\
-										\
-		__get_host_hyp_vcpus(__vcpu, hyp_vcpup);			\
-	})
+	return __get_host_hyp_vcpus(vcpu, hyp_vcpup);
+}
 
-static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __kvm_vcpu_run,
+	struct kvm_vcpu *, vcpu)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	struct kvm_vcpu *host_vcpu;
 	int ret;
 
-	host_vcpu = get_host_hyp_vcpus(host_ctxt, 1, &hyp_vcpu);
-
-	if (!host_vcpu) {
-		ret = -EINVAL;
-		goto out;
-	}
+	host_vcpu = __get_host_hyp_vcpus(vcpu, &hyp_vcpu);
+	if (!host_vcpu)
+		return -EINVAL;
 
 	if (unlikely(hyp_vcpu)) {
 		/*
@@ -382,10 +414,8 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 		 * loading a vcpu. Therefore, if SME features enabled the host
 		 * is misbehaving.
 		 */
-		if (unlikely(system_supports_sme() && read_sysreg_s(SYS_SVCR))) {
-			ret = -EINVAL;
-			goto out;
-		}
+		if (unlikely(system_supports_sme() && read_sysreg_s(SYS_SVCR)))
+			return -EINVAL;
 
 		flush_hyp_vcpu(hyp_vcpu);
 
@@ -398,8 +428,8 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 		ret = __kvm_vcpu_run(host_vcpu);
 		fpsimd_lazy_switch_to_host(host_vcpu);
 	}
-out:
-	cpu_reg(host_ctxt, 1) =  ret;
+
+	return ret;
 }
 
 static int pkvm_refill_memcache(struct pkvm_hyp_vcpu *hyp_vcpu)
@@ -411,184 +441,150 @@ static int pkvm_refill_memcache(struct pkvm_hyp_vcpu *hyp_vcpu)
 			       &host_vcpu->arch.pkvm_memcache);
 }
 
-static void handle___pkvm_host_donate_guest(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_donate_guest,
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
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_share_guest,
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
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_unshare_guest,
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
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_relax_perms_guest,
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
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_wrprotect_guest,
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
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_test_clear_young_guest,
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
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_mkyoung_guest,
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
+DEFINE_KVM_HOST_HCALL(void, __kvm_adjust_pc,
+	struct kvm_vcpu *, vcpu)
 {
-	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
-
 	__kvm_adjust_pc(kern_hyp_va(vcpu));
 }
 
-static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL0(void, __kvm_flush_vm_context)
 {
 	__kvm_flush_vm_context();
 }
 
-static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid_ipa,
+	struct kvm_s2_mmu *, mmu, phys_addr_t, ipa, int, level)
 {
-	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
-	DECLARE_REG(phys_addr_t, ipa, host_ctxt, 2);
-	DECLARE_REG(int, level, host_ctxt, 3);
-
 	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
 }
 
-static void handle___kvm_tlb_flush_vmid_ipa_nsh(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid_ipa_nsh,
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
+DEFINE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid_range,
+	struct kvm_s2_mmu *, mmu, phys_addr_t, start, unsigned long, pages)
 {
-	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
-	DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
-	DECLARE_REG(unsigned long, pages, host_ctxt, 3);
-
 	__kvm_tlb_flush_vmid_range(kern_hyp_va(mmu), start, pages);
 }
 
-static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid,
+	struct kvm_s2_mmu *, mmu)
 {
-	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
-
 	__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
 }
 
-static void handle___pkvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(void, __pkvm_tlb_flush_vmid,
+	pkvm_handle_t, handle)
 {
-	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
 	struct pkvm_hyp_vm *hyp_vm = get_np_pkvm_hyp_vm(handle);
 
 	if (!hyp_vm)
@@ -598,19 +594,19 @@ static void handle___pkvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 	put_pkvm_hyp_vm(hyp_vm);
 }
 
-static void handle___kvm_flush_cpu_context(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(void, __kvm_flush_cpu_context,
+	struct kvm_s2_mmu *, mmu)
 {
-	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
-
 	__kvm_flush_cpu_context(kern_hyp_va(mmu));
 }
 
-static void handle___kvm_timer_set_cntvoff(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(void, __kvm_timer_set_cntvoff,
+	u64, cntvoff)
 {
-	__kvm_timer_set_cntvoff(cpu_reg(host_ctxt, 1));
+	__kvm_timer_set_cntvoff(cntvoff);
 }
 
-static void handle___kvm_enable_ssbs(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL0(void, __kvm_enable_ssbs)
 {
 	u64 tmp;
 
@@ -619,23 +615,23 @@ static void handle___kvm_enable_ssbs(struct kvm_cpu_context *host_ctxt)
 	write_sysreg_el2(tmp, SYS_SCTLR);
 }
 
-static void handle___vgic_v3_get_gic_config(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL0(u64, __vgic_v3_get_gic_config)
 {
-	cpu_reg(host_ctxt, 1) = __vgic_v3_get_gic_config();
+	return __vgic_v3_get_gic_config();
 }
 
-static void handle___vgic_v3_init_lrs(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL0(void, __vgic_v3_init_lrs)
 {
 	__vgic_v3_init_lrs();
 }
 
-static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(void, __vgic_v3_save_aprs,
+	struct vgic_v3_cpu_if *, cpu_if)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	struct kvm_vcpu *host_vcpu;
 
-	host_vcpu = get_host_hyp_vcpus_from_vgic_v3_cpu_if(host_ctxt, 1,
-							   &hyp_vcpu);
+	host_vcpu = __get_host_hyp_vcpus_from_vgic_v3_cpu_if(cpu_if, &hyp_vcpu);
 	if (!host_vcpu)
 		return;
 
@@ -657,13 +653,13 @@ static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ctxt)
 	}
 }
 
-static void handle___vgic_v3_restore_vmcr_aprs(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(void, __vgic_v3_restore_vmcr_aprs,
+	struct vgic_v3_cpu_if *, cpu_if)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	struct kvm_vcpu *host_vcpu;
 
-	host_vcpu = get_host_hyp_vcpus_from_vgic_v3_cpu_if(host_ctxt, 1,
-							   &hyp_vcpu);
+	host_vcpu = __get_host_hyp_vcpus_from_vgic_v3_cpu_if(cpu_if, &hyp_vcpu);
 	if (!host_vcpu)
 		return;
 
@@ -690,48 +686,39 @@ static void handle___vgic_v3_restore_vmcr_aprs(struct kvm_cpu_context *host_ctxt
 	}
 }
 
-static void handle___pkvm_init(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_init,
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
+DEFINE_KVM_HOST_HCALL(int, __pkvm_cpu_set_vector,
+	enum arm64_hyp_spectre_vector, slot)
 {
-	DECLARE_REG(enum arm64_hyp_spectre_vector, slot, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = pkvm_cpu_set_vector(slot);
+	return pkvm_cpu_set_vector(slot);
 }
 
-static void handle___pkvm_host_share_hyp(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_share_hyp,
+	u64, pfn)
 {
-	DECLARE_REG(u64, pfn, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = __pkvm_host_share_hyp(pfn);
+	return __pkvm_host_share_hyp(pfn);
 }
 
-static void handle___pkvm_host_unshare_hyp(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_unshare_hyp,
+	u64, pfn)
 {
-	DECLARE_REG(u64, pfn, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = __pkvm_host_unshare_hyp(pfn);
+	return __pkvm_host_unshare_hyp(pfn);
 }
 
-static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(ulong, __pkvm_create_private_mapping,
+	phys_addr_t, phys, size_t, size, u64, prot)
 {
-	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
-	DECLARE_REG(size_t, size, host_ctxt, 2);
-	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 3);
-
 	/*
 	 * __pkvm_create_private_mapping() populates a pointer with the
 	 * hypervisor start address of the allocation.
@@ -742,160 +729,131 @@ static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ct
 	 * Instead pass the allocation address as the return value (or return
 	 * ERR_PTR() on failure).
 	 */
-	unsigned long haddr;
+	ulong haddr;
 	int err = __pkvm_create_private_mapping(phys, size, prot, &haddr);
 
 	if (err)
-		haddr = (unsigned long)ERR_PTR(err);
+		haddr = (ulong)ERR_PTR(err);
 
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
+DEFINE_KVM_HOST_HCALL(void, __pkvm_unreserve_vm,
+	pkvm_handle_t, handle)
 {
-	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
-
 	__pkvm_unreserve_vm(handle);
 }
 
-static void handle___pkvm_init_vm(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_init_vm,
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
+DEFINE_KVM_HOST_HCALL(int, __pkvm_init_vcpu,
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
+DEFINE_KVM_HOST_HCALL(int, __pkvm_force_reclaim_guest_page,
+	phys_addr_t, phys)
 {
-	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = __pkvm_host_force_reclaim_page_guest(phys);
+	return __pkvm_host_force_reclaim_page_guest(phys);
 }
 
-static void handle___pkvm_reclaim_dying_guest_page(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_reclaim_dying_guest_page,
+	pkvm_handle_t, handle, u64, gfn)
 {
-	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
-	DECLARE_REG(u64, gfn, host_ctxt, 2);
-
-	cpu_reg(host_ctxt, 1) = __pkvm_reclaim_dying_guest_page(handle, gfn);
+	return __pkvm_reclaim_dying_guest_page(handle, gfn);
 }
 
-static void handle___pkvm_start_teardown_vm(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_start_teardown_vm,
+	pkvm_handle_t, handle)
 {
-	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = __pkvm_start_teardown_vm(handle);
+	return __pkvm_start_teardown_vm(handle);
 }
 
-static void handle___pkvm_finalize_teardown_vm(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_finalize_teardown_vm,
+	pkvm_handle_t, handle)
 {
-	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = __pkvm_finalize_teardown_vm(handle);
+	return __pkvm_finalize_teardown_vm(handle);
 }
 
-static void handle___tracing_load(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __tracing_load,
+	void *, desc_hva, size_t, desc_size)
 {
-	DECLARE_REG(void *, desc_hva, host_ctxt, 1);
-	DECLARE_REG(size_t, desc_size, host_ctxt, 2);
-
-	cpu_reg(host_ctxt, 1) = __tracing_load(desc_hva, desc_size);
+	return __tracing_load(desc_hva, desc_size);
 }
 
-static void handle___tracing_unload(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL0(void, __tracing_unload)
 {
 	__tracing_unload();
 }
 
-static void handle___tracing_enable(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __tracing_enable,
+	bool, enable)
 {
-	DECLARE_REG(bool, enable, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = __tracing_enable(enable);
+	return __tracing_enable(enable);
 }
 
-static void handle___tracing_swap_reader(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __tracing_swap_reader,
+	unsigned int, cpu)
 {
-	DECLARE_REG(unsigned int, cpu, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = __tracing_swap_reader(cpu);
+	return __tracing_swap_reader(cpu);
 }
 
-static void handle___tracing_update_clock(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(void, __tracing_update_clock,
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
+DEFINE_KVM_HOST_HCALL(int, __tracing_reset,
+	unsigned int, cpu)
 {
-	DECLARE_REG(unsigned int, cpu, host_ctxt, 1);
-
-	cpu_reg(host_ctxt, 1) = __tracing_reset(cpu);
+	return __tracing_reset(cpu);
 }
 
-static void handle___tracing_enable_event(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(int, __tracing_enable_event,
+	unsigned short, id, bool, enable)
 {
-	DECLARE_REG(unsigned short, id, host_ctxt, 1);
-	DECLARE_REG(bool, enable, host_ctxt, 2);
-
-	cpu_reg(host_ctxt, 1) = __tracing_enable_event(id, enable);
+	return __tracing_enable_event(id, enable);
 }
 
-static void handle___tracing_write_event(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(void, __tracing_write_event,
+	u64, id)
 {
-	DECLARE_REG(u64, id, host_ctxt, 1);
-
 	trace_selftest(id);
 }
 
-static void handle___vgic_v5_save_apr(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(void, __vgic_v5_save_apr,
+	struct vgic_v5_cpu_if *, cpu_if)
 {
-	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
-
 	__vgic_v5_save_apr(kern_hyp_va(cpu_if));
 }
 
-static void handle___vgic_v5_restore_vmcr_apr(struct kvm_cpu_context *host_ctxt)
+DEFINE_KVM_HOST_HCALL(void, __vgic_v5_restore_vmcr_apr,
+	struct vgic_v5_cpu_if *, cpu_if)
 {
-	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
-
 	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
 }
 
-- 
2.39.5

