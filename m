Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10E163F5BC4;
	Mon,  8 Jun 2026 14:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929813; cv=none; b=Qb5Ux2suBkngPm8FdOgPRJgECRLJxVOmXZ4sleb9i13bZXChKF0GWNCBSwEVGMBzk8xOl/aOKZPT9uwxcm3ltxs7P67+4zEQxfiTelB0nZM6jacnUZlMSjpte/8i2Gsu7k1nwZvQ7WdokAHR//DRvedgABG4G/vJYR1kRtBM3ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929813; c=relaxed/simple;
	bh=Whw3JGgkGggT2rG+xbclcMaz/4KUpmd0p9KAn+6WfPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOHyzafPV1gLux9P9UriQVtnmuFqEWGL41EKjHn4HfYDCCw0LPzYbZ3bBcHqMRij+8QRlWLo0/mELXwU1GSBqr4fyUHOIqEdrNNdhMrWQ0nMbSe00kyYWGNwMBJxA8a/A83KIl0GNe0tzMqoTdZgn2/SPvK3YLJ/I/hgKbE/vvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 1BB562028CD;
	Mon,  8 Jun 2026 16:43:14 +0200 (CEST)
From: =?UTF-8?q?J=C3=B6rg=20R=C3=B6del?= <joro@8bytes.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com,
	Melody Wang <huibo.wang@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	x86@kernel.org,
	coconut-svsm@lists.linux.dev,
	joerg.roedel@amd.com
Subject: [PATCH 42/60] kvm: x86: Make local APIC code aware of planes
Date: Mon,  8 Jun 2026 16:42:34 +0200
Message-ID: <20260608144252.351443-43-joro@8bytes.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608144252.351443-1-joro@8bytes.org>
References: <20260608144252.351443-1-joro@8bytes.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paolo Bonzini <pbonzini@redhat.com>

Make the local apic code aware of planes and only operate on APICs
within the same plane level.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Co-developed-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/hyperv.c |  2 +-
 arch/x86/kvm/ioapic.c |  8 +++----
 arch/x86/kvm/irq.c    |  8 ++++---
 arch/x86/kvm/lapic.c  | 50 +++++++++++++++++++++----------------------
 arch/x86/kvm/lapic.h  | 12 +++++------
 arch/x86/kvm/x86.c    |  6 +++---
 arch/x86/kvm/xen.c    |  2 +-
 7 files changed, 45 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 4438ecac9a89..0a5d8e302f32 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -492,7 +492,7 @@ static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
 	irq.vector = vector;
 	irq.level = 1;
 
-	ret = kvm_irq_delivery_to_apic(vcpu->kvm, vcpu->arch.apic, &irq);
+	ret = kvm_irq_delivery_to_apic(vcpu->plane, vcpu->arch.apic, &irq);
 	trace_kvm_hv_synic_set_irq(vcpu->vcpu_id, sint, irq.vector, ret);
 	return ret;
 }
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index eed96ff6e722..539edee73047 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -429,7 +429,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 			irq.dest_id = e->fields.dest_id;
 			irq.msi_redir_hint = false;
 			bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
-			kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
+			kvm_bitmap_or_dest_vcpus(ioapic->kvm->planes[0], &irq,
 						 vcpu_bitmap);
 			if (old_dest_mode != e->fields.dest_mode ||
 			    old_dest_id != e->fields.dest_id) {
@@ -442,7 +442,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 				irq.dest_mode =
 				    kvm_lapic_irq_dest_mode(
 					!!e->fields.dest_mode);
-				kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
+				kvm_bitmap_or_dest_vcpus(ioapic->kvm->planes[0], &irq,
 							 vcpu_bitmap);
 			}
 			kvm_make_scan_ioapic_request_mask(ioapic->kvm,
@@ -485,11 +485,11 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
 		 * if rtc_irq_check_coalesced returns false).
 		 */
 		BUG_ON(ioapic->rtc_status.pending_eoi != 0);
-		ret = __kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe,
+		ret = __kvm_irq_delivery_to_apic(ioapic->kvm->planes[0], NULL, &irqe,
 						 &ioapic->rtc_status);
 		ioapic->rtc_status.pending_eoi = (ret < 0 ? 0 : ret);
 	} else
-		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe);
+		ret = kvm_irq_delivery_to_apic(ioapic->kvm->planes[0], NULL, &irqe);
 
 	if (ret && irqe.trig_mode == IOAPIC_LEVEL_TRIG)
 		entry->fields.remote_irr = 1;
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index bc748a4b7cbd..3bf2ecfd9cb4 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -226,6 +226,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 		struct kvm *kvm, int irq_source_id, int level, bool line_status)
 {
 	struct kvm_lapic_irq irq;
+	struct kvm_plane *plane;
 
 	if (kvm_msi_route_invalid(kvm, e))
 		return -EINVAL;
@@ -234,8 +235,9 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 		return -1;
 
 	kvm_msi_to_lapic_irq(kvm, e, &irq);
+	plane = kvm->planes[e->msi.plane_level];
 
-	return kvm_irq_delivery_to_apic(kvm, NULL, &irq);
+	return kvm_irq_delivery_to_apic(plane, NULL, &irq);
 }
 
 int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
@@ -258,7 +260,7 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 
 		kvm_msi_to_lapic_irq(kvm, e, &irq);
 
-		if (kvm_irq_delivery_to_apic_fast(kvm, NULL, &irq, &r))
+		if (kvm_irq_delivery_to_apic_fast(kvm->planes[e->msi.plane_level], NULL, &irq, &r))
 			return r;
 		break;
 
@@ -453,7 +455,7 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 		 * if they have a single CPU as the destination, e.g. only if
 		 * the guest has affined the interrupt to a single vCPU.
 		 */
-		if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
+		if (!kvm_intr_is_single_vcpu(kvm->planes[0], &irq, &vcpu) ||
 		    !kvm_irq_is_postable(&irq))
 			vcpu = NULL;
 	}
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 06a12b49fafa..cac076445472 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1153,7 +1153,7 @@ static int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
  * means that the interrupt should be dropped.  In this case, *bitmap would be
  * zero and *dst undefined.
  */
-static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
+static inline bool kvm_apic_map_get_dest_lapic(struct kvm_plane *plane,
 		struct kvm_lapic **src, struct kvm_lapic_irq *irq,
 		struct kvm_apic_map *map, struct kvm_lapic ***dst,
 		unsigned long *bitmap)
@@ -1167,7 +1167,7 @@ static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
 	} else if (irq->shorthand)
 		return false;
 
-	if (!map || kvm_apic_is_broadcast_dest(kvm, src, irq, map))
+	if (!map || kvm_apic_is_broadcast_dest(plane->kvm, src, irq, map))
 		return false;
 
 	if (irq->dest_mode == APIC_DEST_PHYSICAL) {
@@ -1208,7 +1208,7 @@ static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
 				bitmap, 16);
 
 		if (!(*dst)[lowest]) {
-			kvm_apic_disabled_lapic_found(kvm);
+			kvm_apic_disabled_lapic_found(plane->kvm);
 			*bitmap = 0;
 			return true;
 		}
@@ -1219,7 +1219,7 @@ static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
 	return true;
 }
 
-static bool __kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
+static bool __kvm_irq_delivery_to_apic_fast(struct kvm_plane *plane, struct kvm_lapic *src,
 					    struct kvm_lapic_irq *irq, int *r,
 					    struct rtc_status *rtc_status)
 {
@@ -1232,7 +1232,7 @@ static bool __kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *s
 	*r = -1;
 
 	if (irq->shorthand == APIC_DEST_SELF) {
-		if (KVM_BUG_ON(!src, kvm)) {
+		if (KVM_BUG_ON(!src, plane->kvm)) {
 			*r = 0;
 			return true;
 		}
@@ -1241,9 +1241,9 @@ static bool __kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *s
 	}
 
 	rcu_read_lock();
-	map = rcu_dereference(kvm->planes[0]->arch.apic_map);
+	map = rcu_dereference(plane->arch.apic_map);
 
-	ret = kvm_apic_map_get_dest_lapic(kvm, &src, irq, map, &dst, &bitmap);
+	ret = kvm_apic_map_get_dest_lapic(plane, &src, irq, map, &dst, &bitmap);
 	if (ret) {
 		*r = 0;
 		for_each_set_bit(i, &bitmap, 16) {
@@ -1258,10 +1258,10 @@ static bool __kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *s
 }
 
 
-bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
+bool kvm_irq_delivery_to_apic_fast(struct kvm_plane *plane, struct kvm_lapic *src,
 				   struct kvm_lapic_irq *irq, int *r)
 {
-	return __kvm_irq_delivery_to_apic_fast(kvm, src, irq, r, NULL);
+	return __kvm_irq_delivery_to_apic_fast(plane, src, irq, r, NULL);
 }
 
 /*
@@ -1278,7 +1278,7 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
  *	   interrupt.
  * - Otherwise, use remapped mode to inject the interrupt.
  */
-static bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm,
+static bool kvm_intr_is_single_vcpu_fast(struct kvm_plane *plane,
 					 struct kvm_lapic_irq *irq,
 					 struct kvm_vcpu **dest_vcpu)
 {
@@ -1291,9 +1291,9 @@ static bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm,
 		return false;
 
 	rcu_read_lock();
-	map = rcu_dereference(kvm->planes[0]->arch.apic_map);
+	map = rcu_dereference(plane->arch.apic_map);
 
-	if (kvm_apic_map_get_dest_lapic(kvm, NULL, irq, map, &dst, &bitmap) &&
+	if (kvm_apic_map_get_dest_lapic(plane, NULL, irq, map, &dst, &bitmap) &&
 			hweight16(bitmap) == 1) {
 		unsigned long i = find_first_bit(&bitmap, 16);
 
@@ -1307,17 +1307,17 @@ static bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm,
 	return ret;
 }
 
-bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
+bool kvm_intr_is_single_vcpu(struct kvm_plane *plane, struct kvm_lapic_irq *irq,
 			     struct kvm_vcpu **dest_vcpu)
 {
 	int r = 0;
 	unsigned long i;
 	struct kvm_vcpu *vcpu;
 
-	if (kvm_intr_is_single_vcpu_fast(kvm, irq, dest_vcpu))
+	if (kvm_intr_is_single_vcpu_fast(plane, irq, dest_vcpu))
 		return true;
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
+	plane_for_each_vcpu(i, vcpu, plane) {
 		if (!kvm_apic_present(vcpu))
 			continue;
 
@@ -1335,7 +1335,7 @@ bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_intr_is_single_vcpu);
 
-int __kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
+int __kvm_irq_delivery_to_apic(struct kvm_plane *plane, struct kvm_lapic *src,
 			       struct kvm_lapic_irq *irq,
 			       struct rtc_status *rtc_status)
 {
@@ -1344,7 +1344,7 @@ int __kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 	unsigned long i, dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
 	unsigned int dest_vcpus = 0;
 
-	if (__kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, rtc_status))
+	if (__kvm_irq_delivery_to_apic_fast(plane, src, irq, &r, rtc_status))
 		return r;
 
 	if (irq->dest_mode == APIC_DEST_PHYSICAL &&
@@ -1355,7 +1355,7 @@ int __kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 
 	memset(dest_vcpu_bitmap, 0, sizeof(dest_vcpu_bitmap));
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
+	plane_for_each_vcpu(i, vcpu, plane) {
 		if (!kvm_apic_present(vcpu))
 			continue;
 
@@ -1384,7 +1384,7 @@ int __kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		int idx = kvm_vector_to_index(irq->vector, dest_vcpus,
 					dest_vcpu_bitmap, KVM_MAX_VCPUS);
 
-		lowest = kvm_get_vcpu(kvm, idx);
+		lowest = plane_get_vcpu(plane, idx);
 	}
 
 	if (lowest)
@@ -1500,7 +1500,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
  * out the destination vcpus array and set the bitmap or it traverses to
  * each available vcpu to identify the same.
  */
-void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
+void kvm_bitmap_or_dest_vcpus(struct kvm_plane *plane, struct kvm_lapic_irq *irq,
 			      unsigned long *vcpu_bitmap)
 {
 	struct kvm_lapic **dest_vcpu = NULL;
@@ -1512,9 +1512,9 @@ void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
 	bool ret;
 
 	rcu_read_lock();
-	map = rcu_dereference(kvm->planes[0]->arch.apic_map);
+	map = rcu_dereference(plane->arch.apic_map);
 
-	ret = kvm_apic_map_get_dest_lapic(kvm, &src, irq, map, &dest_vcpu,
+	ret = kvm_apic_map_get_dest_lapic(plane, &src, irq, map, &dest_vcpu,
 					  &bitmap);
 	if (ret) {
 		for_each_set_bit(i, &bitmap, 16) {
@@ -1524,7 +1524,7 @@ void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			__set_bit(vcpu_idx, vcpu_bitmap);
 		}
 	} else {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
+		plane_for_each_vcpu(i, vcpu, plane) {
 			if (!kvm_apic_present(vcpu))
 				continue;
 			if (!kvm_apic_match_dest(vcpu, NULL,
@@ -1651,7 +1651,7 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 
 	trace_kvm_apic_ipi(icr_low, irq.dest_id);
 
-	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq);
+	kvm_irq_delivery_to_apic(apic->vcpu->plane, apic, &irq);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_apic_send_ipi);
 
@@ -2619,7 +2619,7 @@ static int __kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data, bool fast)
 
 		kvm_icr_to_lapic_irq(apic, (u32)data, (u32)(data >> 32), &irq);
 
-		if (!kvm_irq_delivery_to_apic_fast(apic->vcpu->kvm, apic, &irq,
+		if (!kvm_irq_delivery_to_apic_fast(apic->vcpu->plane, apic, &irq,
 						   &ignored))
 			return -EWOULDBLOCK;
 
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index afd440c88981..a9ede0e145d9 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -116,17 +116,17 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu);
 int kvm_alloc_apic_access_page(struct kvm *kvm);
 void kvm_inhibit_apic_access_page(struct kvm_vcpu *vcpu);
 
-bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
+bool kvm_irq_delivery_to_apic_fast(struct kvm_plane *plane, struct kvm_lapic *src,
 				   struct kvm_lapic_irq *irq, int *r);
-int __kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
+int __kvm_irq_delivery_to_apic(struct kvm_plane *plane, struct kvm_lapic *src,
 			       struct kvm_lapic_irq *irq,
 			       struct rtc_status *rtc_status);
 
-static inline int kvm_irq_delivery_to_apic(struct kvm *kvm,
+static inline int kvm_irq_delivery_to_apic(struct kvm_plane *plane,
 					   struct kvm_lapic *src,
 					   struct kvm_lapic_irq *irq)
 {
-	return __kvm_irq_delivery_to_apic(kvm, src, irq, NULL);
+	return __kvm_irq_delivery_to_apic(plane, src, irq, NULL);
 }
 
 void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
@@ -244,10 +244,10 @@ bool kvm_lapic_suppress_eoi_broadcast(struct kvm_lapic *apic);
 
 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
 
-void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
+void kvm_bitmap_or_dest_vcpus(struct kvm_plane *plane, struct kvm_lapic_irq *irq,
 			      unsigned long *vcpu_bitmap);
 
-bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
+bool kvm_intr_is_single_vcpu(struct kvm_plane *plane, struct kvm_lapic_irq *irq,
 			     struct kvm_vcpu **dest_vcpu);
 void kvm_lapic_switch_to_sw_timer(struct kvm_vcpu *vcpu);
 void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 070f87ae23eb..7fc08df245bd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10373,7 +10373,7 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
  *
  * @apicid - apicid of vcpu to be kicked.
  */
-static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
+static void kvm_pv_kick_cpu_op(struct kvm_plane *plane, int apicid)
 {
 	/*
 	 * All other fields are unused for APIC_DM_REMRD, but may be consumed by
@@ -10386,7 +10386,7 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
 		.dest_id = apicid,
 	};
 
-	kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq);
+	kvm_irq_delivery_to_apic(plane, NULL, &lapic_irq);
 }
 
 bool kvm_apicv_activated(struct kvm *kvm)
@@ -10515,7 +10515,7 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, int cpl,
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_UNHALT))
 			break;
 
-		kvm_pv_kick_cpu_op(vcpu->kvm, a1);
+		kvm_pv_kick_cpu_op(vcpu->plane, a1);
 		kvm_sched_yield(vcpu, a1);
 		ret = 0;
 		break;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 91fd3673c09a..06c5789f406b 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -626,7 +626,7 @@ void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
 	irq.delivery_mode = APIC_DM_FIXED;
 	irq.level = 1;
 
-	kvm_irq_delivery_to_apic(v->kvm, NULL, &irq);
+	kvm_irq_delivery_to_apic(v->plane, NULL, &irq);
 }
 
 /*
-- 
2.53.0

