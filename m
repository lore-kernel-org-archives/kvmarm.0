Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409142;
	b=v/E1fXnzdLusA+hbsIF1FJnHCqjvnz40TyOBPJ0D62kdbKL+iyC5HMnUqn6YUqrII31n
	 oOscSFaezhUmu92qGhPEUtFQDgaT5tRwfqq/Q+eUAVAYnxk5c525g+7+2YRjisJX0ty4d
	 EiwutlWRdYPpWTU8obGb0yIPiCxtL6wy+7T7l2AEx17HiJq3fE4v6BYqQX8KaESyCU7j3
	 43NX30mKRach401lG8oWUhGliQip9CmunlOEIhd4iGE+6ERl3raZagLjNN9ef67IUYPeF
	 FSzuPW9sYIO5IJoKhKkEG2xMM5Pup/SPKOImRhw13lwodFf4wkYSVfqM1NVDtq0/fHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409142;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rrNjKzhy2EVfF3Cyo1JsbQOpZSytrdClVTSrpPuu3y8=;
	b=yBYWfhKNSOr3Gi4I2nDrYWgPbTWGuHFsyBuv0K36qFtwNdzx4uaP2N7EkFyB3XwV4kVy
	 JcKrGDGld/xI14ErVtN1oohFxlczcY1AQ5tjN12LBw9OsIY04eQUCWqx1a4S3dhT/Ftiy
	 lQhE3XE/2HGY+IJTVMz6DJPSZYM6eqBJsKY/sG1SfTPVVNEALbLyYqYyklUeE2gSs1rxY
	 d+bT3hAJCFROQ0D5na781x858t5HmSSyeAzJgd+W++KijpBNc8yvca9Xhd3JEwbtEDNxr
	 sSRzY6kPwSp4ZJPddqGtDpfnBPsI+EEanADvcZQx+Bzu6zZPvDa70k9Rtcuoe0ZWidQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="vb2JgBn/";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95083606A8AB;
	Wed, 11 Nov 2026 14:59:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95083606A8AB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vb2JgBn/
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 212021682;
	Wed, 11 Nov 2026 06:58:58 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.58.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 267723F632;
	Wed, 11 Nov 2026 06:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794409141; bh=+gQy6nR+I6R0Q9XQy/yu3MadO/aVM6MhKdAGZ+AVYAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vb2JgBn/6do7KCYHs8KMSpJ/soKdgrIDe/5QfMOi5mU77Tk+KfFQ3vcoEC+B5RQNM
	 VGAO1XQazHOObCQ4ENZqvuKJ9ib3dw7V2PF7sMHYRWZ9FmdJF9rgo/fGYIK6wwHmXK
	 +iNPEP4Vlu8tF0YFqQ2HiN8zAfCtkSr6ChDMwwbo=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Kohei Enju <enju.kohei@fujitsu.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v2 10/12] KVM: arm64: CCA: Prevent memslot modifications after Realm creation
Date: Wed, 11 Nov 2026 14:57:54 +0000
Message-ID: <20261111145758.217946-11-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261111145758.217946-1-steven.price@arm.com>
References: <20261111145758.217946-1-steven.price@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Once the Realm is created, prevent any changes to guest_memfd backed
memslots, as the private memory is provided by slots backed by gmem.
This will also be validated when we handle a fault for Realm Stage2 (in
a later commit).

Require Realm memslots to lie in the lower half of the IPA space, as the
upper, shared half aliases the lower, protected half.

A rejected deletion can already have invalidated the memslot before
the prepare hook rejects it. Keep private mappings intact in this
case.

Additionally, similar to pKVM, we do not support dirty logging or
read-only memslots.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v1:
- Preserve private mappings if KVM invalidates a Realm guest_memfd
  slot before the prepare hook rejects its deletion.
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/mmu.c              | 37 +++++++++++++++++++++++--------
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d672d87ffe62..a82b18a3e4e5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1612,6 +1612,8 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define kvm_vm_hyp_is_distrusting(kvm)	((kvm)->arch.vm_flavor >= __VM_DISTRUSTING_HYP)
 
+#define kvm_arch_has_private_mem(kvm) kvm_vm_is_realm(kvm)
+
 #define kvm_has_mte(kvm)					\
 	(system_supports_mte() &&				\
 	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8c29ed204d61..e550360fc94d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2858,17 +2858,32 @@ int kvm_arch_validate_memory_region(struct kvm *kvm,
 {
 	lockdep_assert_held(&kvm->slots_lock);
 
-	if (kvm_vm_is_protected(kvm)) {
+	if (kvm_vm_is_protected(kvm) && new &&
+	    (new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)))
+		return -EPERM;
+
+	switch (kvm->arch.vm_flavor) {
+	case VM_PROTECTED_PKVM:
 		/* Cannot modify memslots once a pVM has run. */
 		if (pkvm_hyp_vm_is_created(kvm) &&
-		    (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
+		    (change == KVM_MR_DELETE || change == KVM_MR_MOVE))
 			return -EPERM;
-		}
+		break;
+	case VM_REALM:
+		/*
+		 * Once the Realm is created, we cannot modify any slots that
+		 * could be providing private memory. i.e., guest_memfd backed
+		 * slots.
+		 * TODO: Handle trusted device private memory slots
+		 */
+		if (!kvm_realm_is_created(kvm))
+			break;
 
-		if (new &&
-		    new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)) {
+		if (kvm_slot_has_gmem(old) || kvm_slot_has_gmem(new))
 			return -EPERM;
-		}
+		break;
+	default:
+		break;
 	}
 
 	return 0;
@@ -2880,6 +2895,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   enum kvm_mr_change change)
 {
 	hva_t hva, reg_end;
+	gfn_t ipa_limit;
 	int ret = 0;
 
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
@@ -2887,10 +2903,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		return 0;
 
 	/*
-	 * Prevent userspace from creating a memory region outside of the IPA
-	 * space addressable by the KVM guest IPA space.
+	 * Realm shared IPAs alias the corresponding private IPAs, so memslots
+	 * must reside entirely in the canonical lower half of the IPA space.
 	 */
-	if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
+	ipa_limit = kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT;
+	if (kvm_vm_is_realm(kvm))
+		ipa_limit >>= 1;
+	if (new->base_gfn + new->npages > ipa_limit)
 		return -EFAULT;
 
 	/*
-- 
2.43.0

