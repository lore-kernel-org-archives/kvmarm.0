Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3002E54B1D5;
	Tue, 22 Sep 2026 14:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790086758; cv=none; b=dWQpjKWoeoGdf45hcWIpXwiP4MZ2bw2e6lhrKY6o360JBDgFyllYprWB/6U2gM7mfV68xiLk7kyUe0oOEXwl4j7XYdsbtcfiqI6QbmbZp+tu46ZEud67ciI/zLvx5dvkbFUaOtHhNWUFuPY7y+q6MWWxoRn2l7ptOaN7OI1PuRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790086758; c=relaxed/simple;
	bh=lkxexzPngLsqd+EQaPhoozlo+FsjGZpuavKd+jIAQr0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rbu8Xz0Yyzk6Vy3t36tsmC89ANfMI7tTxAr0TRHE+MZf0M5xAWLFjy+BJbKD2ngWVHKVGwABWKDUEM1GVUGNslx8OIJiSBg8PeJ5wBC+i9V5CnjTHxZGNUdqc4IwG5alSfTQ96eGjcKAUSmURZhR74oK2pruJkLYgkrOuGAkj7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Luy/lgSZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Luy/lgSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E74E1F000FF;
	Tue, 22 Sep 2026 14:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790086756;
	bh=6bDdKzV4PTCmUIJrdqRM5Nl1Y8OEiNGan0uNBihjO6o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Luy/lgSZ9q2CaMpDarzoOiveUHU8OBnRmstN1HQDjaF4+pqUN8VhclP73xI6KSwfw
	 gv4d2/UDZf9FCXvwnymL5YIcv+y/b4cJq2SgcY8qy9KqapOeZFJLeslxTI1yNsnPCP
	 g9TNPgwRw860bA4/trvjEfYbrxZcZfj3srcEhdhekyrw8Z3zHPhnUBT+pqLCtvb1lA
	 ncob7mgB6ja8KzIPZNnMUlXZY4oox7qbPLd4I8Yv4pBMDKvqnARtHs5vg7fij2S+Qa
	 7uXma+wb1QdrsyzYTZlQU3Wfw8BPaOOuSPsBvpPhC976qQqUysKNJzTwxWfSdZCzn9
	 r+KF3M0J+2n0A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 15:18:04 +0100
Subject: [PATCH v3 10/14] KVM: arm64: Implement KVM_PRE_FAULT_MEMORY
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-kvm-arm-prefault-v3-10-787bd3bc7e3f@kernel.org>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
In-Reply-To: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Randy Dunlap <rdunlap@infradead.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8427; i=ljs@kernel.org;
 h=from:subject:message-id; bh=lkxexzPngLsqd+EQaPhoozlo+FsjGZpuavKd+jIAQr0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI29Uk6hiwOitgh/XwR04EY9XrlIrs5SlYS6qnc8xXCP
 BZ++FLcUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIlsyGD4K3XuZktb1ZIUtiXq
 C7ffWWHuy/Za4enljK5KjXSL7CnG/xkZLoQesdq+Vta3cr+Hju9k46YbGa+E5hRLx8Vr7FVSVpn
 EDgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Implement KVM stage 2 page table pre-faulting for the arm64 architecture,
with the core of the implementation in kvm_arch_vcpu_pre_fault_memory().

Pre-fault by first trying a page table walk under the MMU read lock then,
if it fails, injecting a synthetic data abort at the page table level
at which the page table walk failed.

This is necessarily racey as reclaim might happen at any time. Successfully
pre-faulting can therefore only guarantee that each GPA was observed to be
mapped at least once.

Protected KVM (pKVM) is not supported at all because pKVM creates VMs and
vCPUs when first run, meaning any attempt to pre-fault prior to this cannot
succeed.

Additionally, in pKVM mode, the stage 2 page tables are owned by the
hypervisor rather than the host - the host can neither walk them nor
populate them directly, so it's not clear that the pre-fault mechanism
correctly maps onto pKVM.

Disallow pre-faulting of uninitialised vCPUs as they are not in a
safe state to do so, using the newly introduced
kvm_arch_vcpu_allow_pre_fault_memory() hook.

A retry mechanic is implemented when user_mem_abort() or gmem_abort() fail
to map memory due to a benign failure where a hardware abort would not
result in an error.

An invalid memslot (i.e. a memslot with the KVM_MEMSLOT_INVALID flag set)
results in the operation returning -EAGAIN without a retry mechanic,
because an invalid memslot means the pre-fault operation raced with memslot
reclaim, and since the SRCU lock is held, progress cannot be made, and the
user must retry.

This work is based with gratitude on Jack Thomson's original series, its
previous revisions and the feedback they received.

Link: https://patch.msgid.link/20260612162354.73378-1-jackabt.amazon@gmail.com/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/include/asm/kvm_pkvm.h |   2 +-
 arch/arm64/kvm/Kconfig            |   1 +
 arch/arm64/kvm/arm.c              |   1 +
 arch/arm64/kvm/mmu.c              | 147 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 150 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index cad60569f061..c1831c8e421d 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -44,9 +44,9 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		return true;
 	case KVM_CAP_ARM_MTE:
-		return false;
 	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
 	case KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES:
+	case KVM_CAP_PRE_FAULT_MEMORY:
 		return false;
 	default:
 		return !kvm || !kvm_vm_is_protected(kvm);
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 449154f9a485..71233068b7cb 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,7 @@ menuconfig KVM
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select KVM_GUEST_MEMFD
+	select KVM_GENERIC_PRE_FAULT_MEMORY
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 31f803010c57..367638e1e020 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -410,6 +410,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_COUNTER_OFFSET:
 	case KVM_CAP_ARM_WRITABLE_IMP_ID_REGS:
 	case KVM_CAP_ARM_SEA_TO_USER:
+	case KVM_CAP_PRE_FAULT_MEMORY:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6a85024eab69..98c8ca0faf79 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/cleanup.h>
 #include <linux/mman.h>
 #include <linux/kvm_host.h>
 #include <linux/interval_tree.h>
@@ -2933,3 +2934,149 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
 
 	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
 }
+
+/*
+ * Try to walk to the specified GPA in canonical mmu - if unmapped returns 0, if
+ * mapped returns the granule size, otherwise returns an error.
+ */
+static long kvm_walk_s2(struct kvm_pgtable *pgt,
+			gpa_t gpa, s8 *level)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
+	kvm_pte_t pte;
+	long ret;
+
+	guard(read_lock)(&kvm->mmu_lock);
+
+	ret = kvm_pgtable_get_leaf(pgt, gpa, &pte, level,
+				   KVM_PGTABLE_WALK_SHARED);
+	if (ret)
+		return ret;
+	/* Unpopulated, must fault. */
+	if (!kvm_pte_valid(pte))
+		return 0;
+	return kvm_granule_size(*level);
+}
+
+/* Synthesised data abort at specified page table level. */
+#define PRE_FAULT_ESR(level)				\
+	 ((ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT) |	\
+	  ESR_ELx_IL | ESR_ELx_FSC_FAULT_L(level))
+
+/* Retrieve either a read-only or a read/write hva. */
+static hva_t gfn_to_hva_memslot_read(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	return gfn_to_hva_memslot_prot(slot, gfn, /*writable=*/NULL);
+}
+
+static long __pre_fault_s2(struct kvm_s2_mmu *mmu, struct kvm_vcpu *vcpu,
+			   gpa_t gpa, struct kvm_memory_slot *memslot, s8 level)
+{
+	const bool is_gmem = kvm_slot_has_gmem(memslot);
+	const gfn_t gfn = gpa_to_gfn(gpa);
+	const hva_t hva = is_gmem ? 0 : gfn_to_hva_memslot_read(memslot, gfn);
+	const struct kvm_s2_fault_desc s2fd = {
+		.vcpu		= vcpu,
+		.fault_ipa	= gpa,
+		.nested		= NULL,
+		.memslot	= memslot,
+		.hva		= hva,
+		.esr		= PRE_FAULT_ESR(level),
+		.mmu		= mmu,
+	};
+	struct kvm_s2_fault_result result = {};
+	long ret;
+
+	if (kvm_is_error_hva(hva))
+		return -EFAULT;
+
+	if (is_gmem)
+		ret = gmem_abort(&s2fd, &result);
+	else
+		ret = user_mem_abort(&s2fd, &result);
+	if (IS_ERR_VALUE(ret))
+		return ret;
+	return result.mapping_size;
+}
+
+static long pre_fault_s2(struct kvm_s2_mmu *mmu, struct kvm_vcpu *vcpu,
+			 gpa_t gpa, struct kvm_memory_slot *memslot)
+{
+	s8 level;
+	long ret;
+
+	/* Try a walk first. */
+	ret = kvm_walk_s2(mmu->pgt, gpa, &level);
+	if (ret)
+		return ret;
+	/* OK, have to fault page in. */
+	return __pre_fault_s2(mmu, vcpu, gpa, memslot, level);
+}
+
+static unsigned long
+pre_fault_bytes_consumed(gpa_t gpa, unsigned long granule_size,
+			 unsigned long bytes_remaining)
+{
+	/* Granules are always a power-of-2. */
+	const unsigned long granule_bytes_remaining =
+		granule_size - (gpa % granule_size);
+
+	return min(granule_bytes_remaining, bytes_remaining);
+}
+
+/* If you lose the race this many times, time to give up. */
+#define MAX_PRE_FAULT_RETRIES 3
+
+bool kvm_arch_vcpu_allow_pre_fault_memory(struct kvm_vcpu *vcpu)
+{
+	/* Only initialised vCPUs can pre-fault. */
+	return kvm_vcpu_initialized(vcpu);
+}
+
+/**
+ * kvm_arch_vcpu_pre_fault_memory - pre-fault stage-2 page tables for the
+ * specified GPA.
+ * @vcpu:	The VCPU pointer
+ * @range:	{gpa, size, flags} tuple
+ *
+ * The mapping performed is always best-effort - faulting in is necessarily
+ * racey. The ranges faulted in are canonical, nested page tables are ignored.
+ *
+ * @range->gpa specifies the GPA to pre-fault, @range->size specifies how many
+ * bytes remain to be pre-faulted and @range->flags is reserved and must be 0.
+ *
+ * Returns: the number of bytes the pre-fault consumed, or an error.
+ */
+long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
+				    struct kvm_pre_fault_memory *range)
+{
+	struct kvm *kvm = vcpu->kvm;
+	const u64 bytes_remaining = range->size;
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu; /* Canonical. */
+	struct kvm_memory_slot *memslot;
+	const gpa_t gpa = range->gpa;
+	int num_retries = 0;
+	long ret;
+
+	/*
+	 * pKVM is unsupported as their vCPUs are instantiated on first run and
+	 * pre-faulting only running vCPUs would be inconsistent and confusing.
+	 */
+	if (is_protected_kvm_enabled())
+		return -EOPNOTSUPP;
+
+	memslot = gfn_to_memslot(kvm, gpa_to_gfn(gpa));
+	if (!memslot)
+		return -ENOENT;
+	/* SRCU must be released for progress and only userland can do that. */
+	if (memslot->flags & KVM_MEMSLOT_INVALID)
+		return -EAGAIN;
+
+	do {
+		ret = pre_fault_s2(mmu, vcpu, gpa, memslot);
+	} while (ret == -EAGAIN && num_retries++ < MAX_PRE_FAULT_RETRIES);
+
+	if (IS_ERR_VALUE(ret))
+		return ret;
+	return pre_fault_bytes_consumed(gpa, ret, bytes_remaining);
+}

-- 
2.55.0

