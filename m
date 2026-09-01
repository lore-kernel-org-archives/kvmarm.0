Received: from mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC5E3B0AD6
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 14:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271475; cv=none; b=p7aPVS5jHEIC+xPkhcjzri/eS1T6ca/ciIMMrVmgSR1anfBWw9AmB/D+kIy1+9yY/l2dg6zrYTC9fRwcM+kOtX4V73XfvkC0/pynzpqNjyYMQ28aGV85wZQmOvKhRJtJDYWrxezI5+CM7d3gaYAIbu/dGbEPprXNHlfSffi6mSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271475; c=relaxed/simple;
	bh=EmBrff3D5aKQ+1O826oGPmf6bhg6A6SYCKNGDvonFpY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pLE6R68DI5U4g+3xWC6ZAUwC3GqjRf5bowCg1eanYYHkep0Gbe7pEJN1ILcrh10h5LdfoPAYXFGu4nzDiJXMd9qHZBFa+4XR6vhJToVMS0bkmNTrPQuCuk0/Pz2nCYJvLyQNcttYCflfyhkaHbvT44/7by79LdpoEKmpOL+N8UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k77kAtkF; arc=none smtp.client-ip=91.218.175.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k77kAtkF"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=EmBrff3D5aKQ+1O826oGPmf6bhg6A6SYCKNGDvonFpY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788271469; v=1; x=1788876269;
 b=k77kAtkFx+2NY090Tn9bwq5g5klXmWySFyjf1peFcLNatcwDNreS6wFCOrInAFLk4PDw+V3D
 pmk70BUyFGc2d3IZGUoNrd8jYFSdPzrhR2YtRH1HV4MS+znkciti03w2r9SBEfjBeApIZin9xsi
 4D/Wq06ZiPc5sDxSx7cpEciw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4a82a460faf35186;
	Tue, 01 Sep 2026 14:04:29 +0000
X-Mizu-Trace-ID: 4a82a460faf35186
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
Subject: [PATCH v4 11/11] KVM: arm64: Tag host-VA hypercall parameters __kern
Date: Tue,  1 Sep 2026 15:03:26 +0100
Message-Id: <20260901140326.3812068-12-fuad.tabba@linux.dev>
In-Reply-To: <20260901140326.3812068-1-fuad.tabba@linux.dev>
References: <20260901140326.3812068-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nVHE hypervisor takes host virtual addresses as hypercall arguments
and translates each with kern_hyp_va() before use. Nothing marks them as
host-owned, so dereferencing one untranslated at EL2 - a recurring bug
class - is invisible to the compiler.

Add a __kern sparse address space, active only for EL2 code, and tag the
host-VA parameters in the hypercall declarations. kern_hyp_va_host() is
the only sanctioned unwrap: it translates the address, preserves the
pointee type (stripped of qualifiers, as with the percpu accessors) and
drops the tag with a __force cast, so an untranslated host VA fails
sparse. The tag flows from the shared declaration into the generated
handler and on into the donated-memory and tracing-descriptor helpers,
so a handler cannot extract a host VA without it. Host code sees plain
pointers, and the tag is checker-only: no code is generated.

container_of() casts through void * and drops the address space, so
__get_host_hyp_vcpus() now takes an already translated vCPU and its
callers unwrap. Translating a vgic_v3_cpu_if before taking its container
is equivalent, since va_mask spans every bit in which two linear-map
addresses differ.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_hcall.h      | 43 ++++++++++------
 arch/arm64/include/asm/kvm_mmu.h        | 10 ++++
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h  |  6 ++-
 arch/arm64/kvm/hyp/include/nvhe/trace.h |  5 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 65 +++++++++++++------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c          | 11 +++--
 arch/arm64/kvm/hyp/nvhe/trace.c         |  4 +-
 7 files changed, 86 insertions(+), 58 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hcall.h b/arch/arm64/include/asm/kvm_hcall.h
index c709991d10cda..9f06af58a4b00 100644
--- a/arch/arm64/include/asm/kvm_hcall.h
+++ b/arch/arm64/include/asm/kvm_hcall.h
@@ -28,6 +28,18 @@ struct kvm_vcpu;
 struct vgic_v3_cpu_if;
 struct vgic_v5_cpu_if;
 
+/*
+ * A host VA carried by a hypercall argument. At EL2 such a pointer must not
+ * be dereferenced until it is translated with kern_hyp_va_host(); sparse
+ * flags any use that skips the translation. The tag describes the EL2 view
+ * only: the host dereferences its own VAs freely.
+ */
+#if defined(__KVM_NVHE_HYPERVISOR__) && defined(__CHECKER__)
+#define __kern	__attribute__((noderef, address_space(__kern)))
+#else
+#define __kern
+#endif
+
 /*
  * Hypercall signatures are declared as (type, name) argument pairs.
  * __KVM_HCALL_MAP() applies a macro to each pair, in the mold of __MAP()
@@ -142,24 +154,24 @@ DECLARE_KVM_HOST_HCALL0(int, __pkvm_prot_finalize)
 
 /* Hypercalls that are always available and common to [nh]VHE/pKVM. */
 DECLARE_KVM_HOST_HCALL(void, __kvm_adjust_pc,
-	struct kvm_vcpu *, vcpu)
+	struct kvm_vcpu __kern *, vcpu)
 DECLARE_KVM_HOST_HCALL(int, __kvm_vcpu_run,
-	struct kvm_vcpu *, vcpu)
+	struct kvm_vcpu __kern *, vcpu)
 DECLARE_KVM_HOST_HCALL0(void, __kvm_flush_vm_context)
 DECLARE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid_ipa,
-	struct kvm_s2_mmu *, mmu, phys_addr_t, ipa, int, level)
+	struct kvm_s2_mmu __kern *, mmu, phys_addr_t, ipa, int, level)
 DECLARE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid_ipa_nsh,
-	struct kvm_s2_mmu *, mmu, phys_addr_t, ipa, int, level)
+	struct kvm_s2_mmu __kern *, mmu, phys_addr_t, ipa, int, level)
 DECLARE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid,
-	struct kvm_s2_mmu *, mmu)
+	struct kvm_s2_mmu __kern *, mmu)
 DECLARE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid_range,
-	struct kvm_s2_mmu *, mmu, phys_addr_t, start, unsigned long, pages)
+	struct kvm_s2_mmu __kern *, mmu, phys_addr_t, start, unsigned long, pages)
 DECLARE_KVM_HOST_HCALL(void, __kvm_flush_cpu_context,
-	struct kvm_s2_mmu *, mmu)
+	struct kvm_s2_mmu __kern *, mmu)
 DECLARE_KVM_HOST_HCALL(void, __kvm_timer_set_cntvoff,
 	u64, cntvoff)
 DECLARE_KVM_HOST_HCALL(int, __tracing_load,
-	void *, desc_hva, size_t, desc_size)
+	void __kern *, desc_hva, size_t, desc_size)
 DECLARE_KVM_HOST_HCALL0(void, __tracing_unload)
 DECLARE_KVM_HOST_HCALL(int, __tracing_enable,
 	bool, enable)
@@ -174,13 +186,13 @@ DECLARE_KVM_HOST_HCALL(int, __tracing_enable_event,
 DECLARE_KVM_HOST_HCALL(void, __tracing_write_event,
 	u64, id)
 DECLARE_KVM_HOST_HCALL(void, __vgic_v3_save_aprs,
-	struct vgic_v3_cpu_if *, cpu_if)
+	struct vgic_v3_cpu_if __kern *, cpu_if)
 DECLARE_KVM_HOST_HCALL(void, __vgic_v3_restore_vmcr_aprs,
-	struct vgic_v3_cpu_if *, cpu_if)
+	struct vgic_v3_cpu_if __kern *, cpu_if)
 DECLARE_KVM_HOST_HCALL(void, __vgic_v5_save_apr,
-	struct vgic_v5_cpu_if *, cpu_if)
+	struct vgic_v5_cpu_if __kern *, cpu_if)
 DECLARE_KVM_HOST_HCALL(void, __vgic_v5_restore_vmcr_apr,
-	struct vgic_v5_cpu_if *, cpu_if)
+	struct vgic_v5_cpu_if __kern *, cpu_if)
 
 /* Hypercalls that are available only when pKVM has finalised. */
 DECLARE_KVM_HOST_HCALL(int, __pkvm_host_share_hyp,
@@ -205,10 +217,11 @@ DECLARE_KVM_HOST_HCALL0(int, __pkvm_reserve_vm)
 DECLARE_KVM_HOST_HCALL(void, __pkvm_unreserve_vm,
 	pkvm_handle_t, handle)
 DECLARE_KVM_HOST_HCALL(int, __pkvm_init_vm,
-	struct kvm *, host_kvm, void *, vm_hva, void *, pgd_hva)
+	struct kvm __kern *, host_kvm, void __kern *, vm_hva,
+	void __kern *, pgd_hva)
 DECLARE_KVM_HOST_HCALL(int, __pkvm_init_vcpu,
-	pkvm_handle_t, handle, struct kvm_vcpu *, host_vcpu,
-	void *, vcpu_hva)
+	pkvm_handle_t, handle, struct kvm_vcpu __kern *, host_vcpu,
+	void __kern *, vcpu_hva)
 DECLARE_KVM_HOST_HCALL0(int, __pkvm_vcpu_in_poison_fault)
 DECLARE_KVM_HOST_HCALL(int, __pkvm_force_reclaim_guest_page,
 	phys_addr_t, phys)
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6eae7e7e2a684..57f65257bb56d 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -7,6 +7,8 @@
 #ifndef __ARM64_KVM_MMU_H__
 #define __ARM64_KVM_MMU_H__
 
+#include <linux/compiler.h>
+
 #include <asm/page.h>
 #include <asm/memory.h>
 #include <asm/mmu.h>
@@ -140,6 +142,14 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 
 #define kern_hyp_va(v) 	((typeof(v))(__kern_hyp_va((unsigned long)(v))))
 
+/*
+ * Translate a __kern-tagged host VA, dropping the tag: the only sanctioned
+ * unwrap. Translation only, no ownership or bounds validation; the result
+ * carries the pointee type stripped of the tag and of any cv-qualifiers.
+ */
+#define kern_hyp_va_host(v)						\
+	((TYPEOF_UNQUAL(*(v)) *)__kern_hyp_va((unsigned long)(__force void *)(v)))
+
 extern u32 __hyp_va_bits;
 
 /*
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 2643a1a819668..c1171451e1be7 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -7,6 +7,7 @@
 #ifndef __ARM64_KVM_NVHE_PKVM_H__
 #define __ARM64_KVM_NVHE_PKVM_H__
 
+#include <asm/kvm_hcall.h>
 #include <asm/kvm_pkvm.h>
 
 #include <nvhe/gfp.h>
@@ -69,9 +70,10 @@ void pkvm_hyp_vm_table_init(void *tbl);
 
 int __pkvm_reserve_vm(void);
 void __pkvm_unreserve_vm(pkvm_handle_t handle);
-int __pkvm_init_vm(struct kvm *host_kvm, void *vm_hva, void *pgd_hva);
+int __pkvm_init_vm(struct kvm *host_kvm, void __kern *vm_hva,
+		   void __kern *pgd_hva);
 int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
-		     void *vcpu_hva);
+		     void __kern *vcpu_hva);
 
 int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn);
 int __pkvm_start_teardown_vm(pkvm_handle_t handle);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
index 4aa36fd76b9e2..c2db9f70ea265 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -4,6 +4,7 @@
 
 #include <linux/trace_remote_event.h>
 
+#include <asm/kvm_hcall.h>
 #include <asm/kvm_hyptrace.h>
 
 static inline pid_t __tracing_get_vcpu_pid(struct kvm_cpu_context *host_ctxt)
@@ -46,7 +47,7 @@ static inline pid_t __tracing_get_vcpu_pid(struct kvm_cpu_context *host_ctxt)
 void *tracing_reserve_entry(unsigned long length);
 void tracing_commit_entry(void);
 
-int __tracing_load(void *desc_va, size_t desc_size);
+int __tracing_load(void __kern *desc_va, size_t desc_size);
 void __tracing_unload(void);
 int __tracing_enable(bool enable);
 int __tracing_swap_reader(unsigned int cpu);
@@ -59,7 +60,7 @@ static inline void tracing_commit_entry(void) { }
 #define HYP_EVENT(__name, __proto, __struct, __assign, __printk)      \
 	static inline void trace_##__name(__proto) {}
 
-static inline int __tracing_load(void *desc_va, size_t desc_size) { return -ENODEV; }
+static inline int __tracing_load(void __kern *desc_va, size_t desc_size) { return -ENODEV; }
 static inline void __tracing_unload(void) { }
 static inline int __tracing_enable(bool enable) { return -ENODEV; }
 static inline int __tracing_swap_reader(unsigned int cpu) { return -ENODEV; }
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9085f46c2880f..91e74a1a334f0 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -367,10 +367,9 @@ DEFINE_KVM_HOST_HCALL0(void, __pkvm_vcpu_sync_state)
 	sync_hyp_vcpu_state(hyp_vcpu);
 }
 
-static struct kvm_vcpu *__get_host_hyp_vcpus(struct kvm_vcpu *arg,
+static struct kvm_vcpu *__get_host_hyp_vcpus(struct kvm_vcpu *host_vcpu,
 					     struct pkvm_hyp_vcpu **hyp_vcpup)
 {
-	struct kvm_vcpu *host_vcpu = kern_hyp_va(arg);
 	struct pkvm_hyp_vcpu *hyp_vcpu = NULL;
 
 	if (unlikely(is_protected_kvm_enabled())) {
@@ -387,23 +386,24 @@ static struct kvm_vcpu *__get_host_hyp_vcpus(struct kvm_vcpu *arg,
 }
 
 static struct kvm_vcpu *
-__get_host_hyp_vcpus_from_vgic_v3_cpu_if(struct vgic_v3_cpu_if *cpu_if,
+__get_host_hyp_vcpus_from_vgic_v3_cpu_if(struct vgic_v3_cpu_if __kern *cpu_if,
 					 struct pkvm_hyp_vcpu **hyp_vcpup)
 {
-	struct kvm_vcpu *vcpu = container_of(cpu_if, struct kvm_vcpu,
-					     arch.vgic_cpu.vgic_v3);
+	struct vgic_v3_cpu_if *host_cpu_if = kern_hyp_va_host(cpu_if);
+	struct kvm_vcpu *host_vcpu = container_of(host_cpu_if, struct kvm_vcpu,
+						  arch.vgic_cpu.vgic_v3);
 
-	return __get_host_hyp_vcpus(vcpu, hyp_vcpup);
+	return __get_host_hyp_vcpus(host_vcpu, hyp_vcpup);
 }
 
 DEFINE_KVM_HOST_HCALL(int, __kvm_vcpu_run,
-	struct kvm_vcpu *, vcpu)
+	struct kvm_vcpu __kern *, vcpu)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	struct kvm_vcpu *host_vcpu;
 	int ret;
 
-	host_vcpu = __get_host_hyp_vcpus(vcpu, &hyp_vcpu);
+	host_vcpu = __get_host_hyp_vcpus(kern_hyp_va_host(vcpu), &hyp_vcpu);
 	if (!host_vcpu)
 		return -EINVAL;
 
@@ -548,9 +548,9 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_host_mkyoung_guest,
 }
 
 DEFINE_KVM_HOST_HCALL(void, __kvm_adjust_pc,
-	struct kvm_vcpu *, vcpu)
+	struct kvm_vcpu __kern *, vcpu)
 {
-	__kvm_adjust_pc(kern_hyp_va(vcpu));
+	__kvm_adjust_pc(kern_hyp_va_host(vcpu));
 }
 
 DEFINE_KVM_HOST_HCALL0(void, __kvm_flush_vm_context)
@@ -559,27 +559,27 @@ DEFINE_KVM_HOST_HCALL0(void, __kvm_flush_vm_context)
 }
 
 DEFINE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid_ipa,
-	struct kvm_s2_mmu *, mmu, phys_addr_t, ipa, int, level)
+	struct kvm_s2_mmu __kern *, mmu, phys_addr_t, ipa, int, level)
 {
-	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
+	__kvm_tlb_flush_vmid_ipa(kern_hyp_va_host(mmu), ipa, level);
 }
 
 DEFINE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid_ipa_nsh,
-	struct kvm_s2_mmu *, mmu, phys_addr_t, ipa, int, level)
+	struct kvm_s2_mmu __kern *, mmu, phys_addr_t, ipa, int, level)
 {
-	__kvm_tlb_flush_vmid_ipa_nsh(kern_hyp_va(mmu), ipa, level);
+	__kvm_tlb_flush_vmid_ipa_nsh(kern_hyp_va_host(mmu), ipa, level);
 }
 
 DEFINE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid_range,
-	struct kvm_s2_mmu *, mmu, phys_addr_t, start, unsigned long, pages)
+	struct kvm_s2_mmu __kern *, mmu, phys_addr_t, start, unsigned long, pages)
 {
-	__kvm_tlb_flush_vmid_range(kern_hyp_va(mmu), start, pages);
+	__kvm_tlb_flush_vmid_range(kern_hyp_va_host(mmu), start, pages);
 }
 
 DEFINE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid,
-	struct kvm_s2_mmu *, mmu)
+	struct kvm_s2_mmu __kern *, mmu)
 {
-	__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
+	__kvm_tlb_flush_vmid(kern_hyp_va_host(mmu));
 }
 
 DEFINE_KVM_HOST_HCALL(void, __pkvm_tlb_flush_vmid,
@@ -595,9 +595,9 @@ DEFINE_KVM_HOST_HCALL(void, __pkvm_tlb_flush_vmid,
 }
 
 DEFINE_KVM_HOST_HCALL(void, __kvm_flush_cpu_context,
-	struct kvm_s2_mmu *, mmu)
+	struct kvm_s2_mmu __kern *, mmu)
 {
-	__kvm_flush_cpu_context(kern_hyp_va(mmu));
+	__kvm_flush_cpu_context(kern_hyp_va_host(mmu));
 }
 
 DEFINE_KVM_HOST_HCALL(void, __kvm_timer_set_cntvoff,
@@ -626,7 +626,7 @@ DEFINE_KVM_HOST_HCALL0(void, __vgic_v3_init_lrs)
 }
 
 DEFINE_KVM_HOST_HCALL(void, __vgic_v3_save_aprs,
-	struct vgic_v3_cpu_if *, cpu_if)
+	struct vgic_v3_cpu_if __kern *, cpu_if)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	struct kvm_vcpu *host_vcpu;
@@ -654,7 +654,7 @@ DEFINE_KVM_HOST_HCALL(void, __vgic_v3_save_aprs,
 }
 
 DEFINE_KVM_HOST_HCALL(void, __vgic_v3_restore_vmcr_aprs,
-	struct vgic_v3_cpu_if *, cpu_if)
+	struct vgic_v3_cpu_if __kern *, cpu_if)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	struct kvm_vcpu *host_vcpu;
@@ -755,16 +755,17 @@ DEFINE_KVM_HOST_HCALL(void, __pkvm_unreserve_vm,
 }
 
 DEFINE_KVM_HOST_HCALL(int, __pkvm_init_vm,
-	struct kvm *, host_kvm, void *, vm_hva, void *, pgd_hva)
+	struct kvm __kern *, host_kvm, void __kern *, vm_hva,
+	void __kern *, pgd_hva)
 {
-	return __pkvm_init_vm(kern_hyp_va(host_kvm), vm_hva, pgd_hva);
+	return __pkvm_init_vm(kern_hyp_va_host(host_kvm), vm_hva, pgd_hva);
 }
 
 DEFINE_KVM_HOST_HCALL(int, __pkvm_init_vcpu,
-	pkvm_handle_t, handle, struct kvm_vcpu *, host_vcpu,
-	void *, vcpu_hva)
+	pkvm_handle_t, handle, struct kvm_vcpu __kern *, host_vcpu,
+	void __kern *, vcpu_hva)
 {
-	return __pkvm_init_vcpu(handle, kern_hyp_va(host_vcpu), vcpu_hva);
+	return __pkvm_init_vcpu(handle, kern_hyp_va_host(host_vcpu), vcpu_hva);
 }
 
 DEFINE_KVM_HOST_HCALL0(int, __pkvm_vcpu_in_poison_fault)
@@ -799,7 +800,7 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_finalize_teardown_vm,
 }
 
 DEFINE_KVM_HOST_HCALL(int, __tracing_load,
-	void *, desc_hva, size_t, desc_size)
+	void __kern *, desc_hva, size_t, desc_size)
 {
 	return __tracing_load(desc_hva, desc_size);
 }
@@ -846,15 +847,15 @@ DEFINE_KVM_HOST_HCALL(void, __tracing_write_event,
 }
 
 DEFINE_KVM_HOST_HCALL(void, __vgic_v5_save_apr,
-	struct vgic_v5_cpu_if *, cpu_if)
+	struct vgic_v5_cpu_if __kern *, cpu_if)
 {
-	__vgic_v5_save_apr(kern_hyp_va(cpu_if));
+	__vgic_v5_save_apr(kern_hyp_va_host(cpu_if));
 }
 
 DEFINE_KVM_HOST_HCALL(void, __vgic_v5_restore_vmcr_apr,
-	struct vgic_v5_cpu_if *, cpu_if)
+	struct vgic_v5_cpu_if __kern *, cpu_if)
 {
-	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
+	__vgic_v5_restore_vmcr_apr(kern_hyp_va_host(cpu_if));
 }
 
 typedef void (*hcall_t)(struct kvm_cpu_context *);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 6c8e33ebf8bb6..5cdb0318fa7ba 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -657,9 +657,9 @@ static size_t pkvm_get_hyp_vm_size(unsigned int nr_vcpus)
 		size_mul(sizeof(struct pkvm_hyp_vcpu *), nr_vcpus));
 }
 
-static void *map_donated_memory_noclear(void *host_va, size_t size)
+static void *map_donated_memory_noclear(void __kern *host_va, size_t size)
 {
-	void *va = kern_hyp_va(host_va);
+	void *va = kern_hyp_va_host(host_va);
 
 	if (!PAGE_ALIGNED(va))
 		return NULL;
@@ -671,7 +671,7 @@ static void *map_donated_memory_noclear(void *host_va, size_t size)
 	return va;
 }
 
-static void *map_donated_memory(void *host_va, size_t size)
+static void *map_donated_memory(void __kern *host_va, size_t size)
 {
 	void *va = map_donated_memory_noclear(host_va, size);
 
@@ -818,7 +818,8 @@ void teardown_selftest_vm(void)
  *
  * Return 0 success, negative error code on failure.
  */
-int __pkvm_init_vm(struct kvm *host_kvm, void *vm_hva, void *pgd_hva)
+int __pkvm_init_vm(struct kvm *host_kvm, void __kern *vm_hva,
+		   void __kern *pgd_hva)
 {
 	struct pkvm_hyp_vm *hyp_vm = NULL;
 	size_t vm_size, pgd_size;
@@ -909,7 +910,7 @@ static int register_hyp_vcpu(struct pkvm_hyp_vm *hyp_vm,
 }
 
 int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
-		     void *vcpu_hva)
+		     void __kern *vcpu_hva)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	struct pkvm_hyp_vm *hyp_vm;
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index eaa63b06a286c..47680a949f61f 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -206,9 +206,9 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
 	return true;
 }
 
-int __tracing_load(void *desc_hva, size_t desc_size)
+int __tracing_load(void __kern *desc_hva, size_t desc_size)
 {
-	struct hyp_trace_desc *desc = kern_hyp_va(desc_hva);
+	struct hyp_trace_desc *desc = kern_hyp_va_host(desc_hva);
 	int ret;
 
 	ret = __admit_host_mem(desc, desc_size);
-- 
2.39.5

