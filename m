Received: from out-171.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0398E432BF4
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 11:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785842739; cv=none; b=epeRYJFtfiLj503RdoYoS5wkZ0L/pYJ6aIGaT4ag1P+5p4hHhkRDmp+1CpiS+vUNvdbXdrvY7Zxi+DjBLVRfym6Sx4bIBASwYbkv2XuK4C8A4q1Uq9V8RpC80pM4O6ixRCcAV7A3397BvViy46CIiktfto9GuGwlRGwouO8x9j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785842739; c=relaxed/simple;
	bh=W/f2MqPcKbNqTP609tDYx9BTt3Xvy1UxR6DzZonNuug=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DcRtEBm3AjAmA6902KpbQGIuqA0tnecpfH70ViOu6WYbvKih10BfZ1KUQXfFRuM161I2nGE556VXwG2Fl404IJHntme/M5h6XogNEW3LUhKopugMci6dNDfBMrccOCyOT4kRkIy8B0eJ0akDY56OXriKpqrVkXUuM8P8s9mD8sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UpOcNIjL; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UpOcNIjL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785842733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sXfFnsGcA6PeDyCYsmMIOqvu1VZ/vUQ3jHuHXmbJ4BA=;
	b=UpOcNIjLumy3l959VTsZ6Oau8gXCdNbXZZTOwifeBqmyMDKat0OnBHoCp/VV7XSb7w5Roy
	O3VSRmBKtN9/Z9hg2IwvxNSd/XXp4Az3dYjQeiZVjNNJQll0JRsvvRCS7BVMY125WVy3BS
	B0ClCKo+Pw3aPgKSCgcffBSSl7SkIyw=
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
Subject: [PATCH v3 11/11] KVM: arm64: Tag host-VA hypercall parameters __kern
Date: Tue,  4 Aug 2026 12:23:17 +0100
Message-Id: <20260804112317.1937387-12-fuad.tabba@linux.dev>
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

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_hcall.h      | 43 ++++++++++++-------
 arch/arm64/include/asm/kvm_mmu.h        | 10 +++++
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h  |  6 ++-
 arch/arm64/kvm/hyp/include/nvhe/trace.h |  5 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 57 +++++++++++++------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c          | 11 ++---
 arch/arm64/kvm/hyp/nvhe/trace.c         |  4 +-
 7 files changed, 82 insertions(+), 54 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hcall.h b/arch/arm64/include/asm/kvm_hcall.h
index 8688875fb4005..14ed463527e56 100644
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
index 675d607727929..96dbe18209577 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -255,7 +255,7 @@ DEFINE_KVM_HOST_HCALL0(void, __pkvm_vcpu_put)
 }
 
 DEFINE_KVM_HOST_HCALL(int, __kvm_vcpu_run,
-	struct kvm_vcpu *, host_vcpu)
+	struct kvm_vcpu __kern *, host_vcpu)
 {
 	int ret;
 
@@ -280,7 +280,7 @@ DEFINE_KVM_HOST_HCALL(int, __kvm_vcpu_run,
 
 		sync_hyp_vcpu(hyp_vcpu);
 	} else {
-		struct kvm_vcpu *vcpu = kern_hyp_va(host_vcpu);
+		struct kvm_vcpu *vcpu = kern_hyp_va_host(host_vcpu);
 
 		/* The host is fully trusted, run its vCPU directly. */
 		fpsimd_lazy_switch_to_guest(vcpu);
@@ -407,9 +407,9 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_host_mkyoung_guest,
 }
 
 DEFINE_KVM_HOST_HCALL(void, __kvm_adjust_pc,
-	struct kvm_vcpu *, vcpu)
+	struct kvm_vcpu __kern *, vcpu)
 {
-	__kvm_adjust_pc(kern_hyp_va(vcpu));
+	__kvm_adjust_pc(kern_hyp_va_host(vcpu));
 }
 
 DEFINE_KVM_HOST_HCALL0(void, __kvm_flush_vm_context)
@@ -418,27 +418,27 @@ DEFINE_KVM_HOST_HCALL0(void, __kvm_flush_vm_context)
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
@@ -454,9 +454,9 @@ DEFINE_KVM_HOST_HCALL(void, __pkvm_tlb_flush_vmid,
 }
 
 DEFINE_KVM_HOST_HCALL(void, __kvm_flush_cpu_context,
-	struct kvm_s2_mmu *, mmu)
+	struct kvm_s2_mmu __kern *, mmu)
 {
-	__kvm_flush_cpu_context(kern_hyp_va(mmu));
+	__kvm_flush_cpu_context(kern_hyp_va_host(mmu));
 }
 
 DEFINE_KVM_HOST_HCALL(void, __kvm_timer_set_cntvoff,
@@ -485,15 +485,15 @@ DEFINE_KVM_HOST_HCALL0(void, __vgic_v3_init_lrs)
 }
 
 DEFINE_KVM_HOST_HCALL(void, __vgic_v3_save_aprs,
-	struct vgic_v3_cpu_if *, cpu_if)
+	struct vgic_v3_cpu_if __kern *, cpu_if)
 {
-	__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
+	__vgic_v3_save_aprs(kern_hyp_va_host(cpu_if));
 }
 
 DEFINE_KVM_HOST_HCALL(void, __vgic_v3_restore_vmcr_aprs,
-	struct vgic_v3_cpu_if *, cpu_if)
+	struct vgic_v3_cpu_if __kern *, cpu_if)
 {
-	__vgic_v3_restore_vmcr_aprs(kern_hyp_va(cpu_if));
+	__vgic_v3_restore_vmcr_aprs(kern_hyp_va_host(cpu_if));
 }
 
 DEFINE_KVM_HOST_HCALL(int, __pkvm_init,
@@ -565,16 +565,17 @@ DEFINE_KVM_HOST_HCALL(void, __pkvm_unreserve_vm,
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
@@ -609,7 +610,7 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_finalize_teardown_vm,
 }
 
 DEFINE_KVM_HOST_HCALL(int, __tracing_load,
-	void *, desc_hva, size_t, desc_size)
+	void __kern *, desc_hva, size_t, desc_size)
 {
 	return __tracing_load(desc_hva, desc_size);
 }
@@ -656,15 +657,15 @@ DEFINE_KVM_HOST_HCALL(void, __tracing_write_event,
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
index 205c52535c887..9c33d983058a3 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -644,9 +644,9 @@ static size_t pkvm_get_hyp_vm_size(unsigned int nr_vcpus)
 		size_mul(sizeof(struct pkvm_hyp_vcpu *), nr_vcpus));
 }
 
-static void *map_donated_memory_noclear(void *host_va, size_t size)
+static void *map_donated_memory_noclear(void __kern *host_va, size_t size)
 {
-	void *va = kern_hyp_va(host_va);
+	void *va = kern_hyp_va_host(host_va);
 
 	if (!PAGE_ALIGNED(va))
 		return NULL;
@@ -658,7 +658,7 @@ static void *map_donated_memory_noclear(void *host_va, size_t size)
 	return va;
 }
 
-static void *map_donated_memory(void *host_va, size_t size)
+static void *map_donated_memory(void __kern *host_va, size_t size)
 {
 	void *va = map_donated_memory_noclear(host_va, size);
 
@@ -805,7 +805,8 @@ void teardown_selftest_vm(void)
  *
  * Return 0 success, negative error code on failure.
  */
-int __pkvm_init_vm(struct kvm *host_kvm, void *vm_hva, void *pgd_hva)
+int __pkvm_init_vm(struct kvm *host_kvm, void __kern *vm_hva,
+		   void __kern *pgd_hva)
 {
 	struct pkvm_hyp_vm *hyp_vm = NULL;
 	size_t vm_size, pgd_size;
@@ -896,7 +897,7 @@ static int register_hyp_vcpu(struct pkvm_hyp_vm *hyp_vm,
 }
 
 int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
-		     void *vcpu_hva)
+		     void __kern *vcpu_hva)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	struct pkvm_hyp_vm *hyp_vm;
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index 97203ddd3cf45..4410006321a99 100644
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

