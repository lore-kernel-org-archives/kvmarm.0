Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795430610;
	b=uS+fzuAXiuiad9egHovR+pa3fjy1qzpq8ildKNbLya29tjC5EXVN8K/qV+M9+NqtT1wp
	 q3Q87Cof7xNu4J9epjSW5LNJ6o619ZZvBWXx8B9ZUzk+DTBjfPhYI/j5qKhn0kywHfQxK
	 2yPTREJvwIN6kAN60HoglNxRIQKjrtHULUp+zS8cDaeO7W5QqL6kNKbxzla2etRrRB2I8
	 LoRYtK0zLYm+GQXLvSyuLl/OqoaEWQARYTe2JgLu3lV8TARt3/7VxwCRfJGuBpdmSxtem
	 MY39Z+A27Q6B6oH+IV1rabEVwb7V2cbVHWr06vrFd44hFlHP3eJcPq5r5dGzVRD6nqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795430610;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=F8qHgosTivfubEojhD9h/g4AbrUIaCm94vrYMofZ18Q=;
	b=CvgBDw7ii5NsX5FISDf4rvMfmUbu+AmafIPrT8pE3hfcM/3rltYggzclYqBGiK+p/kU6
	 DwtrrfzgkFM0yIxa1Gv7ZQMKyVjfQUL/fMq+JqIEe+WB6gwFYu5+ePMk1NKFsx95vMVoa
	 BZAo1Wz9h6qQUIMXX9eBGnFz9HhO8Wg2z8StqJXWNhKh6ThGaelMgEPXHODrQPhOw+iZN
	 nRJsRzlHaO/KPl15tWSP+vdcSKytmGV8RY/Wwx143VUpqyouIkxiBzvfq0t6h8IZKbpwa
	 Eb/P7AosUzizyR/CLMzFJHIQe5L/H3I6Wz9Hy4SN5iHUFZO5d7/LY05H5r5NvCtYZcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=WtMPcweJ;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F04606A684;
	Mon, 23 Nov 2026 10:43:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31F04606A684
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=WtMPcweJ
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D44D719F6;
	Mon, 23 Nov 2026 02:43:26 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.63.212])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE50C3F9AB;
	Mon, 23 Nov 2026 02:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795430609; bh=GpnTkMmsNJrsBbQSV3YzUlyu+crXLKIz/ySS7mBnD+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtMPcweJKiumfvm11ci2Pif5apy4/M+un7rFjM4tdSighLl1mM+siXPnz+UpNSH0j
	 7cUmfuBWsTjpfoILV2zA8uz2BI9fGqIjBO2of0XKlEkeP3b92Mj4Phspor14tDYg8p
	 0w+JRxyVK4FvYxXps+WJPHlENuraEqCYtoGFK6dU=
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
Subject: [PATCH v4 09/11] KVM: arm64: CCA: Prevent memslot modifications after Realm creation
Date: Mon, 23 Nov 2026 10:42:29 +0000
Message-ID: <20261123104233.95710-10-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123104233.95710-1-steven.price@arm.com>
References: <20261123104233.95710-1-steven.price@arm.com>
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

Once the Realm is created, prevent changes to guest_memfd backed
memslots, which can provide private memory. Validate these changes
before KVM invalidates the old memslot, so a rejected deletion leaves
its stage-2 mappings intact. Realm stage-2 faults will also validate
the private memory backing in a later commit.

Require Realm memslots to lie in the lower half of the IPA space, as the
upper, shared half aliases the lower, protected half.

Define kvm_arch_has_private_mem() so generic KVM recognizes Realm VMs
as supporting private memory. Defining the macro also makes
gmem_in_place_conversion true for every arm64 VM, so guest_memfd
memslots are marked gmem-only even for non-Realm VMs. A well-formed
KVM_SET_MEMORY_ATTRIBUTES2 request on a non-Realm guest_memfd now
reaches the VM check and returns -EINVAL instead of -ENOTTY.

Additionally, similar to pKVM, do not support dirty logging or
read-only memslots.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v3:
- Explain the arm64-wide in-place conversion effect and keep the
  general IPA limit comment.

Changes since v1:
- Preserve private mappings if KVM invalidates a Realm guest_memfd
  slot before the prepare hook rejects its deletion.
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/mmu.c              | 37 ++++++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3ddeddfacd06..55673d08e3eb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1607,6 +1607,8 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define kvm_vm_is_realm(kvm)		((kvm)->arch.vm_flavor == VM_REALM)
 
+#define kvm_arch_has_private_mem(kvm) kvm_vm_is_realm(kvm)
+
 #define kvm_has_mte(kvm)					\
 	(system_supports_mte() &&				\
 	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 800333a345cd..9af5fe6d87f0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2861,17 +2861,32 @@ int kvm_arch_validate_memory_region(struct kvm *kvm,
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
@@ -2883,6 +2898,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   enum kvm_mr_change change)
 {
 	hva_t hva, reg_end;
+	gfn_t ipa_limit;
 	int ret = 0;
 
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
@@ -2891,9 +2907,14 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 	/*
 	 * Prevent userspace from creating a memory region outside of the IPA
-	 * space addressable by the KVM guest IPA space.
+	 * space addressable by the KVM guest IPA space. Realm shared IPAs alias
+	 * the corresponding private IPAs, so Realm memslots must reside entirely
+	 * in the lower half of that space.
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

