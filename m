Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E09901624C5
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136539; cv=none; b=jRmJvgIOBIypd2dYOH6Oc+MlY328UHfc7aDTuNm7FZPvg77/uyfCM1yEmCp+Y0FUvu44js4ZVQ0cSzxHJTj2wKdQdyS3ViU0cUgwkPb05U/eFuQ5upefzn5XGVKuUO/dSIJpFdB0tXkv00tCSkrm8lKwALaGhM5KSsMqExWM8+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136539; c=relaxed/simple;
	bh=BhmNYhhtZA+OQIZwn8vK4NdovyIw7fHNNJUhomketfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJEEQVVkW3DZ6eiqIg9gkrE2P4KBzcI/4223A1ERh+Q3JfEPKx9+oHknpI/Ml/Nv30e1uZdP7ZVVBFzUbTgEkPAtQuwKR/KSh0jcpxfD4eb79Lx82axkmojMPMDEyCyAwhu4AkMF9tagvUtFA+rwMVlqqdlKxaWMfpr79MCrVHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E313C1AC1;
	Fri, 14 Nov 2025 08:08:49 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6512F3F5A1;
	Fri, 14 Nov 2025 08:08:55 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 33/35] KVM: arm64: Implement locked memory accounting for the SPE buffer
Date: Fri, 14 Nov 2025 16:07:14 +0000
Message-ID: <20251114160717.163230-34-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Teach KVM to count the memory pinned for the SPE buffer towards the
process' RLIMIT_MEMLOCK. It is up to userspace to make sure RLIMIT_MEMLOCK
is large enough to accommodate this memory.

The pinned memory is tracked in two places: when the maximum buffer size
for a VCPU is set by userspace during the configuration phase of a virtual
machine - in which case the memory accounted for is the maximum size, and
when the SPE buffer is enabled by the guest.

Doing locked memory accounting when the VCPU is running is necessary
because the memory that KVM pins for a buffer can exceed the maximum buffer
size set by userspace. This happens because KVM must also pin the
translation tables for the buffer.

KVM keeps track of the historical maximum for locked memory and the current
amount of pinned memory. The historical maximum is reflected in the VmLck
status field for the process and KVM will never decrease it, except when
the VM is being destroyed.

If the RLIMIT_MEMLOCK limit is exceeded when userspace sets the maximum
buffer size, the ioctl KVM_ARM_VCPU_SPE_CTRL(KVM_AR_VCPU_MAX_BUFFER_SIZE)
returns to userspace with the error -ENOMEM.

If the limit is exceeded when KVM attempts to pin the buffer, KVM_RUN will
return to userspace with the return value 0, run->exit_reason set to
KVM_EXIT_RLIMIT, and run->rlimit populated accordingly.

The expectation in both cases is that userspace will increase
RLIMIT_MEMLOCK, and the ioctl that failed will be retried.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst |  14 +++-
 arch/arm64/include/asm/kvm_host.h       |   1 +
 arch/arm64/include/asm/kvm_spe.h        |   8 ++
 arch/arm64/kvm/arm.c                    |   5 ++
 arch/arm64/kvm/spe.c                    | 106 +++++++++++++++++++++++-
 5 files changed, 131 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 29dd1f087d4a..b02ff6d6a9d2 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -365,6 +365,7 @@ have the specified SPU.
 	 -EFAULT  Error accessing the max buffer size identifier
 	 -EINVAL  A different maximum buffer size already set or the size is
                   not aligned to the host's page size
+	 -ENOMEM  RLIMIT_MEMLOCK exceeded
 	 -ENXIO   SPE not supported or not properly configured
 	 -ENODEV  KVM_ARM_VCPU_HAS_SPE VCPU feature or SPU instance not set
 	 -ERANGE  Buffer size larger than maximum supported by the SPU
@@ -397,8 +398,17 @@ slightly larger that the maximum buffer set with this ioctl.
 
 This memory that is pinned will count towards the process RLIMIT_MEMLOCK. To
 avoid the limit being exceeded, userspace must increase the RLIMIT_MEMLOCK limit
-prior to running the VCPU, otherwise KVM_RUN will return to userspace with an
-error.
+prior to running the VCPU. If the limit is exceeded when KVM pins the buffer,
+KVM_RUN will return to userspace with exit_reason set to KVM_EXIT_RLIMIT and
+struct run->rlimit populated: 'rlimit_id' set to RLIMIT_MEMLOCK and 'excess'
+equal to the amount of memory over RLIMIT_MEMLOCK.  Userspace then must increase
+RLIMIT_MEMLOCK by at least 'excess' amount and resume the VCPU. Userspace can
+increase RLIMIT_MEMLOCK with more than the 'excess' amount, to avoid repeated
+exits.
+
+Note that the process status field VmLck includes the historical maximum, not
+the amount of memory that is current consumed by KVM for pinning the SPE
+buffers, if any.
 
 5.2 ATTRIBUTE: KVM_ARM_VCPU_SPE_INIT
 -----------------------------------
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e79ec480d1d1..b730401717b5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -55,6 +55,7 @@
 #define KVM_REQ_NESTED_S2_UNMAP		KVM_ARCH_REQ(8)
 #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
 #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
+#define KVM_REQ_SPE_MEMLOCK		KVM_ARCH_REQ(11)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 59a0e825a226..7dcf03980019 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -17,11 +17,14 @@ struct kvm_spe {
 	struct arm_spe_pmu *arm_spu;
 	u64 max_buffer_size;	/* Maximum per VCPU buffer size */
 	u64 guest_pmscr_el2;
+	u64 locked_mem_watermark;
+	u64 locked_mem;
 	bool dirtying_pages;
 };
 
 struct kvm_vcpu_spe {
 	u64 hw_pmbsr_el1;	/* Updated on hardware management event */
+	u64 locked_mem_excess;
 	u64 host_pmscr_el2;	/* Host PMSCR_EL2 register, context switched. */
 	int irq_num;		/* Buffer management interrupt number */
 	bool initialized;	/* SPE initialized for the VCPU */
@@ -63,6 +66,8 @@ phys_addr_t kvm_spe_adjust_range_end(struct kvm *kvm, phys_addr_t start, phys_ad
 
 u8 kvm_spe_get_pmsver_limit(void);
 
+void kvm_spe_handle_req_memlock(struct kvm_vcpu *vcpu);
+
 int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
@@ -109,6 +114,9 @@ static inline u8 kvm_spe_get_pmsver_limit(void)
 {
 	return 0;
 }
+static inline void kvm_spe_handle_req_memlock(struct kvm_vcpu *vcpu)
+{
+}
 static inline int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	return -ENXIO;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d05dbb6d2d7a..039401c2d0b4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1097,6 +1097,11 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_dirty_ring_check_request(vcpu))
 			return 0;
 
+		if (kvm_check_request(KVM_REQ_SPE_MEMLOCK, vcpu)) {
+			kvm_spe_handle_req_memlock(vcpu);
+			return 0;
+		}
+
 		check_nested_vcpu_requests(vcpu);
 	}
 
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index f80ef8cdb1d8..2e2b97c3b861 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -84,7 +84,16 @@ void kvm_spe_init_vm(struct kvm *kvm)
 
 void kvm_spe_destroy_vm(struct kvm *kvm)
 {
-	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
+	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
+	struct xarray *pinned_pages = &kvm_spe->pinned_pages;
+
+	/*
+	 * All VCPUs destroyed, the MMU notifiers unregistered - locking not
+	 * needed.
+	 */
+	WARN_ON_ONCE(kvm_spe->locked_mem);
+	account_locked_vm(current->mm, PHYS_PFN(kvm_spe->locked_mem_watermark), false);
+	kvm_spe->locked_mem_watermark = 0;
 
 	WARN_ON_ONCE(!xa_empty(pinned_pages));
 	xa_destroy(pinned_pages);
@@ -399,10 +408,22 @@ static void kvm_spe_inject_data_abort(struct kvm_vcpu *vcpu, u8 fst, bool s2)
 	kvm_spe_update_irq_level(vcpu, true);
 }
 
+static void kvm_spe_remove_locked_mem(struct kvm *kvm, unsigned long size)
+{
+	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
+
+	lockdep_assert_held(&kvm_spe->pinned_pages.xa_lock);
+
+	WARN_ON_ONCE(kvm_spe->locked_mem < size);
+	kvm_spe->locked_mem -= size;
+}
+
 static void kvm_spe_unpin_page(struct kvm *kvm, struct pinned_page *pinned_page)
 {
 	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
 
+	kvm_spe_remove_locked_mem(kvm, PAGE_SIZE);
+
 	__xa_erase(pinned_pages, pinned_page->gfn);
 	unpin_user_pages_dirty_lock(&pinned_page->page, 1, pinned_page->writable);
 }
@@ -474,6 +495,49 @@ static void kvm_spe_unpin_buffer(struct kvm_vcpu *vcpu)
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
+static int kvm_spe_account_locked_mem(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
+	struct kvm_spe *kvm_spe = &vcpu->kvm->arch.kvm_spe;
+	struct xarray *pinned_pages = &kvm_spe->pinned_pages;
+	u64 excess = vcpu_spe->locked_mem_excess;
+	int ret;
+
+	if (!excess)
+		return 0;
+
+	ret = account_locked_vm(current->mm, PHYS_PFN(excess), true);
+	if (ret)
+		return ret;
+
+	xa_lock(pinned_pages);
+	kvm_spe->locked_mem_watermark += excess;
+	vcpu_spe->locked_mem_excess = 0;
+	xa_unlock(pinned_pages);
+
+	return 0;
+}
+
+static void kvm_spe_add_locked_mem(struct kvm_vcpu *vcpu, unsigned long size)
+{
+	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
+	struct kvm_spe *kvm_spe = &vcpu->kvm->arch.kvm_spe;
+	struct xarray *pinned_pages = &kvm_spe->pinned_pages;
+
+	lockdep_assert_held(&pinned_pages->xa_lock);
+
+	/* Another VCPU is already over the watermark. */
+	if (kvm_spe->locked_mem >= kvm_spe->locked_mem_watermark) {
+		kvm_spe->locked_mem += size;
+		vcpu_spe->locked_mem_excess = size;
+		return;
+	}
+
+	kvm_spe->locked_mem += size;
+	if (kvm_spe->locked_mem > kvm_spe->locked_mem_watermark)
+		vcpu_spe->locked_mem_excess = kvm_spe->locked_mem - kvm_spe->locked_mem_watermark;
+}
+
 #define MAP_GPA_RET_NOTIFIER_RETRY	1
 #define MAP_GPA_RET_PAGE_EXIST		2
 
@@ -615,6 +679,7 @@ static int kvm_spe_map_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t hfn, stru
 			goto pages_unlock;
 		}
 
+		kvm_spe_add_locked_mem(vcpu, PAGE_SIZE);
 		ret = 0;
 	}
 
@@ -721,6 +786,8 @@ static bool kvm_spe_test_gpa_pinned(struct kvm_vcpu *vcpu, gpa_t gpa, bool make_
 	return false;
 }
 
+#define PIN_GPA_RET_MEMLOCK	1
+
 static int kvm_spe_pin_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, bool make_writable)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -837,6 +904,14 @@ static int kvm_spe_pin_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, bool make_writable)
 
 	switch (ret) {
 	case 0:
+		if (kvm_spe_account_locked_mem(vcpu)) {
+			/*
+			 * Do not go through the error handling path, the page
+			 * is at this point stored in pinned_pages and it will
+			 * be properly removed when the buffer is unpinned.
+			 */
+			return PIN_GPA_RET_MEMLOCK;
+		}
 		break;
 	case MAP_GPA_RET_PAGE_EXIST:
 		kfree(pinned_page);
@@ -930,6 +1005,10 @@ static bool kvm_spe_pin_buffer(struct kvm_vcpu *vcpu, u64 ptr, u64 limit)
 		return true;
 
 	switch (ret) {
+	case PIN_GPA_RET_MEMLOCK:
+		kvm_make_request(KVM_REQ_SPE_MEMLOCK, vcpu);
+		commit_write = false;
+		break;
 	case -EAGAIN:
 		commit_write = false;
 		break;
@@ -1326,6 +1405,21 @@ void kvm_vcpu_spe_put(struct kvm_vcpu *vcpu)
 		isb();
 }
 
+static void kvm_spe_set_exit_rlimit(struct kvm_run *run, u64 excess)
+{
+	run->exit_reason = KVM_EXIT_RLIMIT;
+	run->rlimit.excess = excess;
+	run->rlimit.rlimit_id = RLIMIT_MEMLOCK;
+}
+
+void kvm_spe_handle_req_memlock(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
+
+	kvm_spe_set_exit_rlimit(vcpu->run, vcpu_spe->locked_mem_excess);
+	vcpu_spe->locked_mem_excess = 0;
+}
+
 static u64 max_buffer_size_to_pmbidr_el1(u64 size)
 {
 	u64 msb_idx, num_bits;
@@ -1379,7 +1473,9 @@ static int kvm_spe_set_max_buffer_size(struct kvm_vcpu *vcpu, u64 size)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
+	struct xarray *pinned_pages = &kvm_spe->pinned_pages;
 	u64 decoded_size, spu_size;
+	int ret;
 
 	if (kvm_vm_has_ran_once(kvm))
 		return -EBUSY;
@@ -1401,6 +1497,14 @@ static int kvm_spe_set_max_buffer_size(struct kvm_vcpu *vcpu, u64 size)
 	if (spu_size != 0 && (size == 0 || size > spu_size))
 		return -ERANGE;
 
+	ret = account_locked_vm(current->mm, PHYS_PFN(size), true);
+	if (ret)
+		return -ENOMEM;
+
+	xa_lock(pinned_pages);
+	kvm_spe->locked_mem_watermark += size;
+	xa_unlock(pinned_pages);
+
 	kvm_spe->max_buffer_size = size;
 
 	return 0;
-- 
2.51.2

