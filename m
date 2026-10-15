Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B67D4541E4E
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074410; cv=none; b=fvDWYb0QeP4NfOhX837c8UpH6xBexZN7rUSr5/xn0+B9Ek1KBt2xXwEGlG/pAIrgfoC1EI4TWv0xbf1ZgjmSpjrlBdxY0jIFlMmI2L/W4MM5lGjPrNMNP1zxyULYacx4zfNecIiV4zkL+5w/wQ4OW/EUoaHq1eDF125eqLJLBvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074410; c=relaxed/simple;
	bh=+nybeMNVzVEOKArJ/Q+m2Hi2eZ6pdWjemjV8TMS/baA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlV0OMTldPOmgCaVln3AEb6ZNCPjgp4SBbbGd6FvV5LOX6B3WiVx99O30UwmZ11C39ToOs4d3mw7DhJ9/rYe6RCOrTRPAuOMfRg6Wo/fGKjwreRGyzwXqrqH6GyynwUiaPeISnUNTirsOe9mPGM2Wlp3NXPyJFJdx4/zuFGALKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hYvSKo5A; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hYvSKo5A"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF83E1713;
	Thu, 15 Oct 2026 07:26:35 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.2.198.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E33603F871;
	Thu, 15 Oct 2026 07:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792074399; bh=+nybeMNVzVEOKArJ/Q+m2Hi2eZ6pdWjemjV8TMS/baA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYvSKo5AGCmdhUj81eXiaAZaYth85z7THjaAOcQDoMdWuET8YS30bD2EVziYTdF3f
	 H/7/AjvoXwWg49MbQ8RZz7WSuBMMaMVNWgoeIHEEjlWQWm8DxDF3ZasJI8tLUDP5lW
	 6Qq90kEjZXBMxd2uFCSMsFLphfsQ2poprLqGJ6Qk=
From: Ryan Roberts <ryan.roberts@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	Oded Gabbay <ogabbay@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [RFC PATCH v2 10/15] KVM: arm64: Introduce support to pin VMIDs
Date: Thu, 15 Oct 2026 15:25:44 +0100
Message-ID: <20261015142552.4128028-11-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015142552.4128028-1-ryan.roberts@arm.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Introduce kvm_arm_pinned_vmid_get() and kvm_arm_pinned_vmid_put(), to pin
a VMID associated with a KVM instance. This will guarantee that VMID
remains the same after a rollover.

This will allow some devices, such as ones behind an SMMUv3, to have
their TLB entries tagged with the KVM VMID. In some systems, TLB
maintenance instructions from the CPU to the Inner Shareable domain can
invalidate those entries.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/vmid.c             | 77 ++++++++++++++++++++++++++++---
 2 files changed, 73 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cd9b9d2462f9..30d0082b15ec 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -148,6 +148,7 @@ int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages);
 
 struct kvm_vmid {
 	atomic64_t id;
+	refcount_t pinned;
 };
 
 struct kvm_s2_mmu {
@@ -1359,6 +1360,8 @@ int __init kvm_arm_vmid_alloc_init(void);
 void __init kvm_arm_vmid_alloc_free(void);
 void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid);
 void kvm_arm_vmid_clear_active(void);
+int kvm_arm_pinned_vmid_get(struct kvm *kvm);
+void kvm_arm_pinned_vmid_put(struct kvm *kvm);
 
 static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
 {
diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
index 7fe8ba1a2851..322279f59e88 100644
--- a/arch/arm64/kvm/vmid.c
+++ b/arch/arm64/kvm/vmid.c
@@ -25,6 +25,10 @@ static unsigned long *vmid_map;
 static DEFINE_PER_CPU(atomic64_t, active_vmids);
 static DEFINE_PER_CPU(u64, reserved_vmids);
 
+static unsigned long max_pinned_vmids;
+static unsigned long nr_pinned_vmids;
+static unsigned long *pinned_vmid_map;
+
 #define VMID_MASK		(~GENMASK(kvm_arm_vmid_bits - 1, 0))
 #define VMID_FIRST_VERSION	(1UL << kvm_arm_vmid_bits)
 
@@ -47,7 +51,7 @@ static void flush_context(void)
 	int cpu;
 	u64 vmid;
 
-	bitmap_zero(vmid_map, NUM_USER_VMIDS);
+	bitmap_copy(vmid_map, pinned_vmid_map, NUM_USER_VMIDS);
 
 	for_each_possible_cpu(cpu) {
 		vmid = atomic64_xchg_relaxed(&per_cpu(active_vmids, cpu), 0);
@@ -98,12 +102,14 @@ static u64 new_vmid(struct kvm_vmid *kvm_vmid)
 	if (vmid != 0) {
 		u64 newvmid = generation | (vmid & ~VMID_MASK);
 
-		if (check_update_reserved_vmid(vmid, newvmid)) {
-			atomic64_set(&kvm_vmid->id, newvmid);
-			return newvmid;
-		}
-
-		if (!__test_and_set_bit(vmid2idx(vmid), vmid_map)) {
+		/*
+		 * If it is pinned, we can keep using it. Note that reserved
+		 * takes priority, because even if it is also pinned, we need to
+		 * update the generation into the reserved_vmids.
+		 */
+		if (check_update_reserved_vmid(vmid, newvmid) ||
+		    refcount_read(&kvm_vmid->pinned) ||
+		    !__test_and_set_bit(vmid2idx(vmid), vmid_map)) {
 			atomic64_set(&kvm_vmid->id, newvmid);
 			return newvmid;
 		}
@@ -169,6 +175,49 @@ void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid)
 	raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
 }
 
+int kvm_arm_pinned_vmid_get(struct kvm *kvm)
+{
+	struct kvm_vmid *kvm_vmid;
+	u64 vmid;
+
+	kvm_vmid = &kvm->arch.mmu.vmid;
+
+	guard(raw_spinlock_irqsave)(&cpu_vmid_lock);
+	vmid = atomic64_read(&kvm_vmid->id);
+
+	if (refcount_inc_not_zero(&kvm_vmid->pinned))
+		return (vmid & ~VMID_MASK);
+
+	if (nr_pinned_vmids >= max_pinned_vmids)
+		return -EINVAL;
+
+	/*
+	 * If we went through one or more rollover since that VMID was
+	 * used, make sure it is still valid, or generate a new one.
+	 */
+	if (!vmid_gen_match(vmid))
+		vmid = new_vmid(kvm_vmid);
+
+	nr_pinned_vmids++;
+	__set_bit(vmid2idx(vmid), pinned_vmid_map);
+	refcount_set(&kvm_vmid->pinned, 1);
+	return (vmid & ~VMID_MASK);
+}
+
+void kvm_arm_pinned_vmid_put(struct kvm *kvm)
+{
+	struct kvm_vmid *kvm_vmid;
+	u64 vmid;
+
+	kvm_vmid = &kvm->arch.mmu.vmid;
+	vmid = atomic64_read(&kvm_vmid->id);
+	guard(raw_spinlock_irqsave)(&cpu_vmid_lock);
+	if (refcount_dec_and_test(&kvm_vmid->pinned)) {
+		__clear_bit(vmid2idx(vmid), pinned_vmid_map);
+		nr_pinned_vmids--;
+	}
+}
+
 /*
  * Initialize the VMID allocator
  */
@@ -186,10 +235,24 @@ int __init kvm_arm_vmid_alloc_init(void)
 	if (!vmid_map)
 		return -ENOMEM;
 
+	pinned_vmid_map = bitmap_zalloc(NUM_USER_VMIDS, GFP_KERNEL);
+	if (!pinned_vmid_map) {
+		bitmap_free(vmid_map);
+		return -ENOMEM;
+	}
+	nr_pinned_vmids = 0;
+
+	/*
+	 * Ensure we have at least one empty slot available after rollover when
+	 * the maximum number of VMIDs are pinned. VMID#0 is reserved.
+	 */
+	max_pinned_vmids = NUM_USER_VMIDS - num_possible_cpus() - 2;
+
 	return 0;
 }
 
 void __init kvm_arm_vmid_alloc_free(void)
 {
+	bitmap_free(pinned_vmid_map);
 	bitmap_free(vmid_map);
 }
-- 
2.43.0

