Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE03463B9A
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 11:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785842696; cv=none; b=RDuEwi79g1flBPECsmXZEbMg/SpvwQV05Bz3vZF/4CiEztOEvPp+huLNryGcJn7CC4AU1GQSCYF3aCz2Z7nuvg3QoL3ApgQEb4LUewJKhCqfGqErPjCWRi+VXXJnzrbgIWI3v7jB5luqJ/SDW+wSjqH2u2v3LAvXXE1gRmqvqMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785842696; c=relaxed/simple;
	bh=5a9l6Sw6T0J0nBKyDXHAjIiM7aBvuVwEeXIjz+GjzV4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SotgVhQVxW5MPlEK2Q40y0sdBPDQ0ZPsOUbNv0dZmdbownwbCNi47Lk5zXf0u1RzUitEMkH8mkwS96+qBzIN358Il/2H5+Ephto/MsW8NzocQESTAKXwmFPt+MYxMdzTGLjOyg65fisfSU0Pv2iwDVxOt5S9nnBnyCANhMqrj/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QevjB7ql; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QevjB7ql"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785842690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jCN0ua4jPnxMt+MX9mcnwd7Rp1FLD6yfINBr+OmlU1M=;
	b=QevjB7ql5IZfPjZuw++82Ifm9du2Hts9rttzGm6dlrbKVHJh+t5rGHGkxmmkjJ5Et5j++g
	DZNuF13XB1lzUw3Eiof8HoF9kxYVrP1NK55Wu91ryt6m8TYa46FKLAKKbj0DsRdUPVyJuV
	u6cQWt36aZgvnX/wHIaG9IRZh3PVDP8=
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
Subject: [PATCH v3 09/11] KVM: arm64: Type-check hypercall arguments at the caller
Date: Tue,  4 Aug 2026 12:23:15 +0100
Message-Id: <20260804112317.1937387-10-fuad.tabba@linux.dev>
In-Reply-To: <20260804112317.1937387-1-fuad.tabba@linux.dev>
References: <20260804112317.1937387-1-fuad.tabba@linux.dev>
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
 arch/arm64/include/asm/kvm_hcall.h | 152 ++++++++++++++++++++++++++++-
 arch/arm64/kvm/hyp_trace.c         |   2 +-
 2 files changed, 152 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hcall.h b/arch/arm64/include/asm/kvm_hcall.h
index d925b2c28a3d8..541331a8d67e1 100644
--- a/arch/arm64/include/asm/kvm_hcall.h
+++ b/arch/arm64/include/asm/kvm_hcall.h
@@ -9,6 +9,7 @@
 #ifndef __ARM64_KVM_HCALL_H__
 #define __ARM64_KVM_HCALL_H__
 
+#include <linux/args.h>
 #include <linux/arm-smccc.h>
 #include <linux/bug.h>
 #include <linux/errno.h>
@@ -16,12 +17,37 @@
 
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
+ * in <linux/syscalls.h>. The ladder is indexed by list entries, two per
+ * argument; __KVM_HCALL_MAP_N() takes that count explicitly.
+ */
+#define __KVM_HCALL_MAP2(m, t, a, ...) m(t, a)
+#define __KVM_HCALL_MAP4(m, t, a, ...) m(t, a), __KVM_HCALL_MAP2(m, __VA_ARGS__)
+#define __KVM_HCALL_MAP6(m, t, a, ...) m(t, a), __KVM_HCALL_MAP4(m, __VA_ARGS__)
+#define __KVM_HCALL_MAP8(m, t, a, ...) m(t, a), __KVM_HCALL_MAP6(m, __VA_ARGS__)
+#define __KVM_HCALL_MAP10(m, t, a, ...) m(t, a), __KVM_HCALL_MAP8(m, __VA_ARGS__)
+#define __KVM_HCALL_MAP12(m, t, a, ...) m(t, a), __KVM_HCALL_MAP10(m, __VA_ARGS__)
+#define __KVM_HCALL_MAP_N(n, m, ...) CONCATENATE(__KVM_HCALL_MAP, n)(m, __VA_ARGS__)
+#define __KVM_HCALL_MAP(m, ...) __KVM_HCALL_MAP_N(COUNT_ARGS(__VA_ARGS__), m, __VA_ARGS__)
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
@@ -33,6 +59,29 @@ typedef u16 pkvm_handle_t;
 		res.a1;							\
 	})
 
+/*
+ * Generate a typed stub for each declared hypercall. kvm_call_hyp_nvhe()
+ * resolves to the stub, so a call with the wrong argument count or types
+ * fails to compile instead of being silently truncated to an SMCCC function
+ * number and a pile of registers. The stub inlines to the same SMCCC call
+ * the untyped macro used to make.
+ */
+#define DECLARE_KVM_HOST_HCALL(ret, name, ...)				\
+	static __always_inline						\
+	ret nvhe_hvc_##name(__KVM_HCALL_MAP(__KVM_HCALL_DECL, __VA_ARGS__)) \
+	{								\
+		return (ret)__kvm_call_hyp_nvhe(name,			\
+			__KVM_HCALL_MAP(__KVM_HCALL_ARGS, __VA_ARGS__));\
+	}
+
+#define DECLARE_KVM_HOST_HCALL0(ret, name)				\
+	static __always_inline ret nvhe_hvc_##name(void)		\
+	{								\
+		return (ret)__kvm_call_hyp_nvhe(name);			\
+	}
+
+#define kvm_call_hyp_nvhe(f, ...)	nvhe_hvc_##f(__VA_ARGS__)
+
 /*
  * The isb() below is there to guarantee the same behaviour on VHE as on !VHE,
  * where the eret to EL1 acts as a context synchronization event.
@@ -63,6 +112,107 @@ typedef u16 pkvm_handle_t;
 #define kvm_call_hyp(f, ...) f(__VA_ARGS__)
 #define kvm_call_hyp_ret(f, ...) f(__VA_ARGS__)
 #define kvm_call_hyp_nvhe(f, ...) f(__VA_ARGS__)
+
+#define DECLARE_KVM_HOST_HCALL(ret, name, ...)
+#define DECLARE_KVM_HOST_HCALL0(ret, name)
 #endif /* __KVM_NVHE_HYPERVISOR__ */
 
+/* Hypercalls that are unavailable once pKVM has finalised. */
+DECLARE_KVM_HOST_HCALL(int, __pkvm_init,
+	phys_addr_t, phys, unsigned long, size,
+	unsigned long *, per_cpu_base, u32, hyp_va_bits)
+DECLARE_KVM_HOST_HCALL(ulong, __pkvm_create_private_mapping,
+	phys_addr_t, phys, size_t, size, u64, prot)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_cpu_set_vector,
+	enum arm64_hyp_spectre_vector, slot)
+DECLARE_KVM_HOST_HCALL0(void, __kvm_enable_ssbs)
+DECLARE_KVM_HOST_HCALL0(void, __vgic_v3_init_lrs)
+DECLARE_KVM_HOST_HCALL0(u64, __vgic_v3_get_gic_config)
+
+DECLARE_KVM_HOST_HCALL0(int, __pkvm_prot_finalize)
+
+/* Hypercalls that are always available and common to [nh]VHE/pKVM. */
+DECLARE_KVM_HOST_HCALL(void, __kvm_adjust_pc,
+	struct kvm_vcpu *, vcpu)
+DECLARE_KVM_HOST_HCALL(int, __kvm_vcpu_run,
+	struct kvm_vcpu *, vcpu)
+DECLARE_KVM_HOST_HCALL0(void, __kvm_flush_vm_context)
+DECLARE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid_ipa,
+	struct kvm_s2_mmu *, mmu, phys_addr_t, ipa, int, level)
+DECLARE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid_ipa_nsh,
+	struct kvm_s2_mmu *, mmu, phys_addr_t, ipa, int, level)
+DECLARE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid,
+	struct kvm_s2_mmu *, mmu)
+DECLARE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid_range,
+	struct kvm_s2_mmu *, mmu, phys_addr_t, start, unsigned long, pages)
+DECLARE_KVM_HOST_HCALL(void, __kvm_flush_cpu_context,
+	struct kvm_s2_mmu *, mmu)
+DECLARE_KVM_HOST_HCALL(void, __kvm_timer_set_cntvoff,
+	u64, cntvoff)
+DECLARE_KVM_HOST_HCALL(int, __tracing_load,
+	void *, desc_hva, size_t, desc_size)
+DECLARE_KVM_HOST_HCALL0(void, __tracing_unload)
+DECLARE_KVM_HOST_HCALL(int, __tracing_enable,
+	bool, enable)
+DECLARE_KVM_HOST_HCALL(int, __tracing_swap_reader,
+	unsigned int, cpu)
+DECLARE_KVM_HOST_HCALL(void, __tracing_update_clock,
+	u32, mult, u32, shift, u64, epoch_ns, u64, epoch_cyc)
+DECLARE_KVM_HOST_HCALL(int, __tracing_reset,
+	unsigned int, cpu)
+DECLARE_KVM_HOST_HCALL(int, __tracing_enable_event,
+	unsigned short, id, bool, enable)
+DECLARE_KVM_HOST_HCALL(void, __tracing_write_event,
+	u64, id)
+DECLARE_KVM_HOST_HCALL(void, __vgic_v3_save_aprs,
+	struct vgic_v3_cpu_if *, cpu_if)
+DECLARE_KVM_HOST_HCALL(void, __vgic_v3_restore_vmcr_aprs,
+	struct vgic_v3_cpu_if *, cpu_if)
+DECLARE_KVM_HOST_HCALL(void, __vgic_v5_save_apr,
+	struct vgic_v5_cpu_if *, cpu_if)
+DECLARE_KVM_HOST_HCALL(void, __vgic_v5_restore_vmcr_apr,
+	struct vgic_v5_cpu_if *, cpu_if)
+
+/* Hypercalls that are available only when pKVM has finalised. */
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_share_hyp,
+	u64, pfn)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_unshare_hyp,
+	u64, pfn)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_donate_guest,
+	u64, pfn, u64, gfn)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_share_guest,
+	u64, pfn, u64, gfn, u64, nr_pages, u64, prot)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_unshare_guest,
+	pkvm_handle_t, handle, u64, gfn, u64, nr_pages)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_relax_perms_guest,
+	u64, gfn, u64, prot)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_wrprotect_guest,
+	pkvm_handle_t, handle, u64, gfn, u64, nr_pages)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_test_clear_young_guest,
+	pkvm_handle_t, handle, u64, gfn, u64, nr_pages, bool, mkold)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_mkyoung_guest,
+	u64, gfn)
+DECLARE_KVM_HOST_HCALL0(int, __pkvm_reserve_vm)
+DECLARE_KVM_HOST_HCALL(void, __pkvm_unreserve_vm,
+	pkvm_handle_t, handle)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_init_vm,
+	struct kvm *, host_kvm, void *, vm_hva, void *, pgd_hva)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_init_vcpu,
+	pkvm_handle_t, handle, struct kvm_vcpu *, host_vcpu,
+	void *, vcpu_hva)
+DECLARE_KVM_HOST_HCALL0(int, __pkvm_vcpu_in_poison_fault)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_force_reclaim_guest_page,
+	phys_addr_t, phys)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_reclaim_dying_guest_page,
+	pkvm_handle_t, handle, u64, gfn)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_start_teardown_vm,
+	pkvm_handle_t, handle)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_finalize_teardown_vm,
+	pkvm_handle_t, handle)
+DECLARE_KVM_HOST_HCALL(void, __pkvm_vcpu_load,
+	pkvm_handle_t, handle, unsigned int, vcpu_idx, u64, hcr_el2)
+DECLARE_KVM_HOST_HCALL0(void, __pkvm_vcpu_put)
+DECLARE_KVM_HOST_HCALL(void, __pkvm_tlb_flush_vmid,
+	pkvm_handle_t, handle)
+
 #endif /* __ARM64_KVM_HCALL_H__ */
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 9644c424819b7..44937e257375a 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -269,7 +269,7 @@ static struct trace_buffer_desc *hyp_trace_load(unsigned long size, void *priv)
 	if (ret)
 		goto err_free_buffer;
 
-	ret = kvm_call_hyp_nvhe(__tracing_load, (unsigned long)desc, desc_size);
+	ret = kvm_call_hyp_nvhe(__tracing_load, desc, desc_size);
 	if (ret)
 		goto err_unload_pages;
 
-- 
2.39.5

