Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD1143991E
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 16:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784564096; cv=none; b=GxQ0Xisk+62/DUOd6smjU+0EzZbfndrB7U/LXf72Z3sIcvA88U4xA938sSc6zEaVIOn6l/7W10u/YVTH668gYbhROd3t2zZF6Caa9RCpzlAK+H5cP8WIzLDOJh6QYHYoR0S+bc0BnxWLfxQhPK/4pauilOO3nkYbib+PEVNf/zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784564096; c=relaxed/simple;
	bh=NT2KNuiZ894yxQoWZ3QqEHvrOh/IyvFXjU0tD2wVCBo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lsWmce47BwKYQ7n7N89xxSJvdKenEIVx4GMOo/XCiNdG09Ahgi0u34GNWsBZUVgeHH2CXRlB4cuZOXJzQ0T8T7SvKh6x+tQwkNT35cvtEbqvicm61jgaZwBy9vuDCll2AyyzvNTUYDlEwF11VC0q9PVrtwW1oYy+moMlBMJOLOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bVAOoP4Z; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bVAOoP4Z"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784564061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TznzTFBke3DQV3uptFqVswkOT5sGWuwGTEl/xnF2tJ0=;
	b=bVAOoP4Zvjn5EtIaTGOrCaAQyRm9KoPg+KMDuXHzlTnLlJUIQOaamyFsk2KSsd2bgcTLih
	6e6tATpMA9/r4XwYzBCsRxuU0+QOngTiTjMmLloUcUexFfwx1ck4xQ+gnARWaF4reKn1du
	LdLeK3ymzsCNW8lLBkdbA3EWfIibNpU=
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
Subject: [PATCH v1 09/11] KVM: arm64: Type-check hypercall arguments at the caller
Date: Mon, 20 Jul 2026 17:13:41 +0100
Message-Id: <20260720161343.1367007-10-fuad.tabba@linux.dev>
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

kvm_call_hyp_nvhe() reduces its target to an SMCCC function number, so
the compiler never sees a callable: arguments that are wrong in number,
type or order are silently marshalled into registers. The kvm_call_hyp()
wrappers only catch this on the VHE branch, and the pKVM-only hypercalls
have no such branch.

Declare each hypercall's signature once in kvm_hcall.h and generate a
typed stub from it, in the mold of the syscall wrappers. Make
kvm_call_hyp_nvhe() resolve to the stub so every caller is checked
against the declared signature; a stale or mistyped call now fails to
compile. The stubs inline to the same SMCCC call the untyped macro used
to make: the compiled callers are unchanged, apart from hypercall
returns now being tested at their declared width.

The stage-2 protection arguments are declared u64 rather than
enum kvm_pgtable_prot, as kvm_pgtable.h includes linux/kvm_host.h and
the enum cannot be completed here.

Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_hcall.h | 165 ++++++++++++++++++++++++++++-
 arch/arm64/kvm/hyp_trace.c         |   2 +-
 2 files changed, 165 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hcall.h b/arch/arm64/include/asm/kvm_hcall.h
index d925b2c28a3d8..51bfd14748464 100644
--- a/arch/arm64/include/asm/kvm_hcall.h
+++ b/arch/arm64/include/asm/kvm_hcall.h
@@ -16,12 +16,35 @@
 
 #include <asm/barrier.h>
 #include <asm/kvm_asm.h>
+#include <asm/spectre.h>
 #include <asm/virt.h>
 
 typedef u16 pkvm_handle_t;
 
+struct kvm;
+struct kvm_s2_mmu;
+struct kvm_vcpu;
+struct vgic_v3_cpu_if;
+struct vgic_v5_cpu_if;
+
+/*
+ * Hypercall signatures are declared as (type, name) argument pairs.
+ * __KVM_HCALL_MAP() applies a macro to each pair, in the mold of __MAP()
+ * in <linux/syscalls.h>.
+ */
+#define __KVM_HCALL_MAP1(m, t, a, ...) m(t, a)
+#define __KVM_HCALL_MAP2(m, t, a, ...) m(t, a), __KVM_HCALL_MAP1(m, __VA_ARGS__)
+#define __KVM_HCALL_MAP3(m, t, a, ...) m(t, a), __KVM_HCALL_MAP2(m, __VA_ARGS__)
+#define __KVM_HCALL_MAP4(m, t, a, ...) m(t, a), __KVM_HCALL_MAP3(m, __VA_ARGS__)
+#define __KVM_HCALL_MAP5(m, t, a, ...) m(t, a), __KVM_HCALL_MAP4(m, __VA_ARGS__)
+#define __KVM_HCALL_MAP6(m, t, a, ...) m(t, a), __KVM_HCALL_MAP5(m, __VA_ARGS__)
+#define __KVM_HCALL_MAP(n, ...) __KVM_HCALL_MAP##n(__VA_ARGS__)
+
+#define __KVM_HCALL_DECL(t, a)	t a
+#define __KVM_HCALL_ARGS(t, a)	a
+
 #ifndef __KVM_NVHE_HYPERVISOR__
-#define kvm_call_hyp_nvhe(f, ...)					\
+#define __kvm_call_hyp_nvhe(f, ...)					\
 	({								\
 		struct arm_smccc_res res;				\
 									\
@@ -33,6 +56,43 @@ typedef u16 pkvm_handle_t;
 		res.a1;							\
 	})
 
+/*
+ * Generate a typed stub for each declared hypercall. kvm_call_hyp_nvhe()
+ * resolves to the stub, so a call with the wrong argument count or types
+ * fails to compile instead of being silently truncated to an SMCCC function
+ * number and a pile of registers. The stub inlines to the same SMCCC call
+ * the untyped macro used to make.
+ */
+#define DECLARE_KVM_HOST_HCALL(ret, name, x, ...)			\
+	static __always_inline						\
+	ret nvhe_hvc_##name(__KVM_HCALL_MAP(x, __KVM_HCALL_DECL, __VA_ARGS__)) \
+	{								\
+		return (ret)__kvm_call_hyp_nvhe(name,			\
+			__KVM_HCALL_MAP(x, __KVM_HCALL_ARGS, __VA_ARGS__)); \
+	}
+
+#define DECLARE_KVM_HOST_HCALL_VOID(name, x, ...)			\
+	static __always_inline						\
+	void nvhe_hvc_##name(__KVM_HCALL_MAP(x, __KVM_HCALL_DECL, __VA_ARGS__)) \
+	{								\
+		__kvm_call_hyp_nvhe(name,				\
+			__KVM_HCALL_MAP(x, __KVM_HCALL_ARGS, __VA_ARGS__)); \
+	}
+
+#define DECLARE_KVM_HOST_HCALL0(ret, name)				\
+	static __always_inline ret nvhe_hvc_##name(void)		\
+	{								\
+		return (ret)__kvm_call_hyp_nvhe(name);			\
+	}
+
+#define DECLARE_KVM_HOST_HCALL0_VOID(name)				\
+	static __always_inline void nvhe_hvc_##name(void)		\
+	{								\
+		__kvm_call_hyp_nvhe(name);				\
+	}
+
+#define kvm_call_hyp_nvhe(f, ...)	nvhe_hvc_##f(__VA_ARGS__)
+
 /*
  * The isb() below is there to guarantee the same behaviour on VHE as on !VHE,
  * where the eret to EL1 acts as a context synchronization event.
@@ -63,6 +123,109 @@ typedef u16 pkvm_handle_t;
 #define kvm_call_hyp(f, ...) f(__VA_ARGS__)
 #define kvm_call_hyp_ret(f, ...) f(__VA_ARGS__)
 #define kvm_call_hyp_nvhe(f, ...) f(__VA_ARGS__)
+
+#define DECLARE_KVM_HOST_HCALL(ret, name, x, ...)
+#define DECLARE_KVM_HOST_HCALL_VOID(name, x, ...)
+#define DECLARE_KVM_HOST_HCALL0(ret, name)
+#define DECLARE_KVM_HOST_HCALL0_VOID(name)
 #endif /* __KVM_NVHE_HYPERVISOR__ */
 
+/* Hypercalls that are unavailable once pKVM has finalised. */
+DECLARE_KVM_HOST_HCALL(int, __pkvm_init, 4,
+	phys_addr_t, phys, unsigned long, size,
+	unsigned long *, per_cpu_base, u32, hyp_va_bits)
+DECLARE_KVM_HOST_HCALL(unsigned long, __pkvm_create_private_mapping, 3,
+	phys_addr_t, phys, size_t, size, u64, prot)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_cpu_set_vector, 1,
+	enum arm64_hyp_spectre_vector, slot)
+DECLARE_KVM_HOST_HCALL0_VOID(__kvm_enable_ssbs)
+DECLARE_KVM_HOST_HCALL0_VOID(__vgic_v3_init_lrs)
+DECLARE_KVM_HOST_HCALL0(u64, __vgic_v3_get_gic_config)
+
+DECLARE_KVM_HOST_HCALL0(int, __pkvm_prot_finalize)
+
+/* Hypercalls that are always available and common to [nh]VHE/pKVM. */
+DECLARE_KVM_HOST_HCALL_VOID(__kvm_adjust_pc, 1,
+	struct kvm_vcpu *, vcpu)
+DECLARE_KVM_HOST_HCALL(int, __kvm_vcpu_run, 1,
+	struct kvm_vcpu *, vcpu)
+DECLARE_KVM_HOST_HCALL0_VOID(__kvm_flush_vm_context)
+DECLARE_KVM_HOST_HCALL_VOID(__kvm_tlb_flush_vmid_ipa, 3,
+	struct kvm_s2_mmu *, mmu, phys_addr_t, ipa, int, level)
+DECLARE_KVM_HOST_HCALL_VOID(__kvm_tlb_flush_vmid_ipa_nsh, 3,
+	struct kvm_s2_mmu *, mmu, phys_addr_t, ipa, int, level)
+DECLARE_KVM_HOST_HCALL_VOID(__kvm_tlb_flush_vmid, 1,
+	struct kvm_s2_mmu *, mmu)
+DECLARE_KVM_HOST_HCALL_VOID(__kvm_tlb_flush_vmid_range, 3,
+	struct kvm_s2_mmu *, mmu, phys_addr_t, start, unsigned long, pages)
+DECLARE_KVM_HOST_HCALL_VOID(__kvm_flush_cpu_context, 1,
+	struct kvm_s2_mmu *, mmu)
+DECLARE_KVM_HOST_HCALL_VOID(__kvm_timer_set_cntvoff, 1,
+	u64, cntvoff)
+DECLARE_KVM_HOST_HCALL(int, __tracing_load, 2,
+	void *, desc_hva, size_t, desc_size)
+DECLARE_KVM_HOST_HCALL0_VOID(__tracing_unload)
+DECLARE_KVM_HOST_HCALL(int, __tracing_enable, 1,
+	bool, enable)
+DECLARE_KVM_HOST_HCALL(int, __tracing_swap_reader, 1,
+	unsigned int, cpu)
+DECLARE_KVM_HOST_HCALL_VOID(__tracing_update_clock, 4,
+	u32, mult, u32, shift, u64, epoch_ns, u64, epoch_cyc)
+DECLARE_KVM_HOST_HCALL(int, __tracing_reset, 1,
+	unsigned int, cpu)
+DECLARE_KVM_HOST_HCALL(int, __tracing_enable_event, 2,
+	unsigned short, id, bool, enable)
+DECLARE_KVM_HOST_HCALL_VOID(__tracing_write_event, 1,
+	u64, id)
+DECLARE_KVM_HOST_HCALL_VOID(__vgic_v3_save_aprs, 1,
+	struct vgic_v3_cpu_if *, cpu_if)
+DECLARE_KVM_HOST_HCALL_VOID(__vgic_v3_restore_vmcr_aprs, 1,
+	struct vgic_v3_cpu_if *, cpu_if)
+DECLARE_KVM_HOST_HCALL_VOID(__vgic_v5_save_apr, 1,
+	struct vgic_v5_cpu_if *, cpu_if)
+DECLARE_KVM_HOST_HCALL_VOID(__vgic_v5_restore_vmcr_apr, 1,
+	struct vgic_v5_cpu_if *, cpu_if)
+
+/* Hypercalls that are available only when pKVM has finalised. */
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_share_hyp, 1,
+	u64, pfn)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_unshare_hyp, 1,
+	u64, pfn)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_donate_guest, 2,
+	u64, pfn, u64, gfn)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_share_guest, 4,
+	u64, pfn, u64, gfn, u64, nr_pages, u64, prot)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_unshare_guest, 3,
+	pkvm_handle_t, handle, u64, gfn, u64, nr_pages)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_relax_perms_guest, 2,
+	u64, gfn, u64, prot)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_wrprotect_guest, 3,
+	pkvm_handle_t, handle, u64, gfn, u64, nr_pages)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_test_clear_young_guest, 4,
+	pkvm_handle_t, handle, u64, gfn, u64, nr_pages, bool, mkold)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_mkyoung_guest, 1,
+	u64, gfn)
+DECLARE_KVM_HOST_HCALL0(int, __pkvm_reserve_vm)
+DECLARE_KVM_HOST_HCALL_VOID(__pkvm_unreserve_vm, 1,
+	pkvm_handle_t, handle)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_init_vm, 3,
+	struct kvm *, host_kvm, void *, vm_hva, void *, pgd_hva)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_init_vcpu, 3,
+	pkvm_handle_t, handle, struct kvm_vcpu *, host_vcpu,
+	void *, vcpu_hva)
+DECLARE_KVM_HOST_HCALL0(int, __pkvm_vcpu_in_poison_fault)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_force_reclaim_guest_page, 1,
+	phys_addr_t, phys)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_reclaim_dying_guest_page, 2,
+	pkvm_handle_t, handle, u64, gfn)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_start_teardown_vm, 1,
+	pkvm_handle_t, handle)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_finalize_teardown_vm, 1,
+	pkvm_handle_t, handle)
+DECLARE_KVM_HOST_HCALL_VOID(__pkvm_vcpu_load, 3,
+	pkvm_handle_t, handle, unsigned int, vcpu_idx, u64, hcr_el2)
+DECLARE_KVM_HOST_HCALL0_VOID(__pkvm_vcpu_put)
+DECLARE_KVM_HOST_HCALL_VOID(__pkvm_tlb_flush_vmid, 1,
+	pkvm_handle_t, handle)
+
 #endif /* __ARM64_KVM_HCALL_H__ */
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 2411b4c32932c..7fe0e8feb7d7c 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -264,7 +264,7 @@ static struct trace_buffer_desc *hyp_trace_load(unsigned long size, void *priv)
 	if (ret)
 		goto err_free_buffer;
 
-	ret = kvm_call_hyp_nvhe(__tracing_load, (unsigned long)desc, desc_size);
+	ret = kvm_call_hyp_nvhe(__tracing_load, desc, desc_size);
 	if (ret)
 		goto err_unload_pages;
 
-- 
2.39.5

