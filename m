Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67481416847
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 12:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785760993; cv=none; b=hPbhtvj2yddBGen3JShEgM9IVLozI6Ndqt45DOYgf1Iqk2vxl9azRdwESZJuLSmkQNMNh10gcvq51IzbAYR8Ra2b00GyKT5ZpgTftZIPhWxMbB2ihnJZae4jstMURYMaZCl05n4G9DmlvlapnuxQSGbdYjXZUAfjZ5TeBtXNB9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785760993; c=relaxed/simple;
	bh=bQ+/Qw3KeLIOai823DsWpPtAJXBCSSsvbk1lv3ttuZ8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XHBeS/p2NIBBqDLBjdupP3XJAxaW11lWtOj9FTmhog2Wjna+4eNtHhRCun3rMv8xRgzDwoEmRZVXV+5cNzpk3UXaFX8tMjjOwB/FCq8UAf0MlDrhQ5/U7usI2d5NS2rtF42jzTqxRgvyTsO0Gk02oaFGhDa5fWvhkvqSYjvBm+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uP0th6Yb; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uP0th6Yb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785760988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g4PpMNlGsTWFD0SxKNjrPtX+vudl8Lxy+1dKyA5gL04=;
	b=uP0th6Ybl/87b4WO3nVCyJ3/VT0+4W1vDpjHnYl4QDRRATFUyNMF/ChIbt++BLMdQ+ra3i
	Yg4Xf4yCC/DfUq3JuM6GOkDrYMlDhP/iLHYLCuKGXVcgauZdilAtqLDPHpZMqXC1zpz12N
	Nqh7hFfCpO4X8knMvMxoEN5Ap38zEvw=
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
Subject: [PATCH v2 07/11] KVM: arm64: nVHE: Pass host VA arguments as pointers
Date: Mon,  3 Aug 2026 13:42:16 +0100
Message-Id: <20260803124220.332248-8-fuad.tabba@linux.dev>
In-Reply-To: <20260803124220.332248-1-fuad.tabba@linux.dev>
References: <20260803124220.332248-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Four hypercalls take host VAs as unsigned long: the donated vm, pgd
and vcpu regions, and the tracing descriptor. Retype the arguments
and their EL2 consumers as void *, so that the typed hypercall
declarations introduced later in the series can attach a sparse
address space to them; an address space attaches only to pointers.

No functional change intended.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h  |  5 ++---
 arch/arm64/kvm/hyp/include/nvhe/trace.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  8 ++++----
 arch/arm64/kvm/hyp/nvhe/pkvm.c          | 11 +++++------
 arch/arm64/kvm/hyp/nvhe/trace.c         |  4 ++--
 5 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index c904647d2f760..2643a1a819668 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -69,10 +69,9 @@ void pkvm_hyp_vm_table_init(void *tbl);
 
 int __pkvm_reserve_vm(void);
 void __pkvm_unreserve_vm(pkvm_handle_t handle);
-int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
-		   unsigned long pgd_hva);
+int __pkvm_init_vm(struct kvm *host_kvm, void *vm_hva, void *pgd_hva);
 int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
-		     unsigned long vcpu_hva);
+		     void *vcpu_hva);
 
 int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn);
 int __pkvm_start_teardown_vm(pkvm_handle_t handle);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
index 8813ff250f8e0..4aa36fd76b9e2 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -46,7 +46,7 @@ static inline pid_t __tracing_get_vcpu_pid(struct kvm_cpu_context *host_ctxt)
 void *tracing_reserve_entry(unsigned long length);
 void tracing_commit_entry(void);
 
-int __tracing_load(unsigned long desc_va, size_t desc_size);
+int __tracing_load(void *desc_va, size_t desc_size);
 void __tracing_unload(void);
 int __tracing_enable(bool enable);
 int __tracing_swap_reader(unsigned int cpu);
@@ -59,7 +59,7 @@ static inline void tracing_commit_entry(void) { }
 #define HYP_EVENT(__name, __proto, __struct, __assign, __printk)      \
 	static inline void trace_##__name(__proto) {}
 
-static inline int __tracing_load(unsigned long desc_va, size_t desc_size) { return -ENODEV; }
+static inline int __tracing_load(void *desc_va, size_t desc_size) { return -ENODEV; }
 static inline void __tracing_unload(void) { }
 static inline int __tracing_enable(bool enable) { return -ENODEV; }
 static inline int __tracing_swap_reader(unsigned int cpu) { return -ENODEV; }
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d3df96ed8ba42..23cb4313c60a2 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -577,8 +577,8 @@ static void handle___pkvm_unreserve_vm(struct kvm_cpu_context *host_ctxt)
 static void handle___pkvm_init_vm(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm *, host_kvm, host_ctxt, 1);
-	DECLARE_REG(unsigned long, vm_hva, host_ctxt, 2);
-	DECLARE_REG(unsigned long, pgd_hva, host_ctxt, 3);
+	DECLARE_REG(void *, vm_hva, host_ctxt, 2);
+	DECLARE_REG(void *, pgd_hva, host_ctxt, 3);
 
 	host_kvm = kern_hyp_va(host_kvm);
 	cpu_reg(host_ctxt, 1) = __pkvm_init_vm(host_kvm, vm_hva, pgd_hva);
@@ -588,7 +588,7 @@ static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
 	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 2);
-	DECLARE_REG(unsigned long, vcpu_hva, host_ctxt, 3);
+	DECLARE_REG(void *, vcpu_hva, host_ctxt, 3);
 
 	host_vcpu = kern_hyp_va(host_vcpu);
 	cpu_reg(host_ctxt, 1) = __pkvm_init_vcpu(handle, host_vcpu, vcpu_hva);
@@ -634,7 +634,7 @@ static void handle___pkvm_finalize_teardown_vm(struct kvm_cpu_context *host_ctxt
 
 static void handle___tracing_load(struct kvm_cpu_context *host_ctxt)
 {
-	DECLARE_REG(unsigned long, desc_hva, host_ctxt, 1);
+	DECLARE_REG(void *, desc_hva, host_ctxt, 1);
 	DECLARE_REG(size_t, desc_size, host_ctxt, 2);
 
 	cpu_reg(host_ctxt, 1) = __tracing_load(desc_hva, desc_size);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 24d6f164129ac..205c52535c887 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -644,9 +644,9 @@ static size_t pkvm_get_hyp_vm_size(unsigned int nr_vcpus)
 		size_mul(sizeof(struct pkvm_hyp_vcpu *), nr_vcpus));
 }
 
-static void *map_donated_memory_noclear(unsigned long host_va, size_t size)
+static void *map_donated_memory_noclear(void *host_va, size_t size)
 {
-	void *va = (void *)kern_hyp_va(host_va);
+	void *va = kern_hyp_va(host_va);
 
 	if (!PAGE_ALIGNED(va))
 		return NULL;
@@ -658,7 +658,7 @@ static void *map_donated_memory_noclear(unsigned long host_va, size_t size)
 	return va;
 }
 
-static void *map_donated_memory(unsigned long host_va, size_t size)
+static void *map_donated_memory(void *host_va, size_t size)
 {
 	void *va = map_donated_memory_noclear(host_va, size);
 
@@ -805,8 +805,7 @@ void teardown_selftest_vm(void)
  *
  * Return 0 success, negative error code on failure.
  */
-int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
-		   unsigned long pgd_hva)
+int __pkvm_init_vm(struct kvm *host_kvm, void *vm_hva, void *pgd_hva)
 {
 	struct pkvm_hyp_vm *hyp_vm = NULL;
 	size_t vm_size, pgd_size;
@@ -897,7 +896,7 @@ static int register_hyp_vcpu(struct pkvm_hyp_vm *hyp_vm,
 }
 
 int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
-		     unsigned long vcpu_hva)
+		     void *vcpu_hva)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	struct pkvm_hyp_vm *hyp_vm;
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index 177fe3d8fbb13..97203ddd3cf45 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -206,9 +206,9 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
 	return true;
 }
 
-int __tracing_load(unsigned long desc_hva, size_t desc_size)
+int __tracing_load(void *desc_hva, size_t desc_size)
 {
-	struct hyp_trace_desc *desc = (struct hyp_trace_desc *)kern_hyp_va(desc_hva);
+	struct hyp_trace_desc *desc = kern_hyp_va(desc_hva);
 	int ret;
 
 	ret = __admit_host_mem(desc, desc_size);
-- 
2.39.5

