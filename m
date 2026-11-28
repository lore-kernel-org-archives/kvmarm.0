Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795828529;
	b=4MnSgxoSPlri240w67GdilTl7y86kSh1hRJ+ZKlni+sZjphjjZiy3cNVAzNpSllnr+qL
	 205faKIi/oAxXowzTLCVAXyG6u1bfR00wY0Ru5dlmVbO9srC0fXTPlpj8ONMMgZYX+QjE
	 gReBHL+KOIm518LJDJwaKMwYrEZQyuwtgbFMG0pYRDnJlJlVLcg/yEoqIgm19WtQEnftW
	 /aYFatAeFmu1ifdudd8N72/u1FiyqpSWAUXv0uAE28piOGUrYy0V5eDBEJrhUZchCSnqY
	 a7mPyAd+RnDrEp5oa8kBFrcSRMYmN7BjiFzbZNpKJWjV7b/MjuJ7nNH+xjAwHOHdZ6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795828529;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QpckFqMkRFSZ4FA0EQPPlblmNixRZLOna6QhU0iEGtw=;
	b=rfjsx6UUwSy67NBteLGYDr8xxB+8IYIRboScX8Y4IHv8JjRsu1eIWnpdMZUJQMSMaomx
	 FfxRAd45IC4YkB4OmsuTiSuKrjq8qrdJtCH6ZPYPIYvaKulVVmIuzCLMpp0G5xfM60Jb0
	 onxsNNGpk2vsUdCDSMs0KRHtki0NneEaJulWW9eUzJY4qYRsj8Hs/hrH9XpC8xYjRRoh4
	 x3jV3Ad6+662Jf5ZBIySALmSGsxTFN5oNBdOgur+xgvblTUceOjSzTo6tq54BqvnGRD0o
	 ou9qmVYz7pNWPNdXinvgfg+gRJYfpY8DFWcXBUfCvcuXMt3l7W1cVFsM1LJqYzDI0qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=k2M4PesN;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD36606A31E
	for <kvmarm@lists.linux.dev>; Sat, 28 Nov 2026 01:15:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AD36606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=k2M4PesN
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E90CE169E;
	Fri, 27 Nov 2026 17:15:24 -0800 (PST)
Received: from entos-yitian-01.Arm.com (unknown [10.168.196.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 301DA3F632;
	Fri, 27 Nov 2026 17:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795828527; bh=G9WkR2YnyZNppiCZFAcWm+Tv7qha2bxaFXORsoSTkkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2M4PesNhhu8SO9eD/UsWjDUhFC6w8zJn2wCWZYHLuMh7iABb/2BBThhMZ7IltyJ8
	 Pe33j1yngon+7hHiHCHN5UY05Q4HYUgIZ3ZozJmTb2YODJB97HNuiC6cDqYe7qQHoh
	 boF/QRsBo5C+gPI3WjTz63DVrNMVy2pEsxKCckys=
From: Jia He <justin.he@arm.com>
To: maz@kernel.org,
	oupton@kernel.org
Cc: fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	shuah@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia He <justin.he@arm.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 1/4] KVM: arm64: nv: Locate the VNCR page in the host page from its PA
Date: Sat, 28 Nov 2026 01:14:44 +0000
Message-Id: <20261128011447.3588988-2-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261128011447.3588988-1-justin.he@arm.com>
References: <20261128011447.3588988-1-justin.he@arm.com>
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

VNCR_EL2 only needs to be 4K aligned. On a host with 16K or 64K pages,
kvm_translate_vncr() records the host page that contains the guest
hypervisor's VNCR page, and that host page is mapped at the VNCR fixmap.
__compute_hcr() then takes the offset of the VNCR page in the host page
from bits [PAGE_SHIFT-1:12] of the guest's VNCR_EL2, which is a VA.

If the guest hypervisor uses a stage-1 granule smaller than the host
page, these bits of the VA and of the PA can differ. The nested context
then accesses another 4K page of the guest instead of the VNCR page.

Take the offset from the PA that the walk returns, and keep it in
vt->hpa. Use it only while the VNCR page is mapped. Otherwise the
fixmap is clear, the access faults and KVM translates VNCR_EL2 again,
so the offset does not matter.

Tested on a Neoverse-N2 host running 16K and 64K page kernels, with the
selftest added later in this series. The test maps the VNCR page at a VA
whose bits [15:12] differ from those of its PA. With the offset taken
from the VA, the nested context reads 0 instead of the value in the VNCR
page. With this patch, it reads the expected value.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-232440@kernel.org/
Fixes: 73e1b621b25d ("KVM: arm64: nv: Program host's VNCR_EL2 to the fixmap address")
Signed-off-by: Jia He <justin.he@arm.com>
---
 arch/arm64/include/asm/kvm_nested.h | 1 +
 arch/arm64/kvm/hyp/vhe/switch.c     | 9 +++++++--
 arch/arm64/kvm/nested.c             | 8 +++++++-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 0f899addafa8..bc54a4b2e863 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -432,6 +432,7 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa,
 /* VNCR management */
 int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu);
 int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu);
+unsigned long kvm_vncr_page_offset(struct kvm_vcpu *vcpu);
 void kvm_handle_s1e2_tlbi(struct kvm_vcpu *vcpu, u32 inst, u64 val);
 
 u16 get_asid_by_regime(struct kvm_vcpu *vcpu, enum trans_regime regime);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 3f2390a13173..0d15beea418c 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -94,8 +94,13 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
 		if (guest_hcr & HCR_EL2_NV) {
 			u64 va = __fix_to_virt(vncr_fixmap(smp_processor_id()));
 
-			/* Inherit the low bits from the actual register */
-			va |= __vcpu_sys_reg(vcpu, VNCR_EL2) & GENMASK(PAGE_SHIFT - 1, 0);
+			/*
+			 * The fixmap maps the host page that contains the VNCR
+			 * page. Locate the VNCR page in it from its PA: with a
+			 * smaller guest granule, the VA may have another offset.
+			 */
+			if (host_data_test_flag(L1_VNCR_MAPPED))
+				va |= kvm_vncr_page_offset(vcpu);
 			write_sysreg_s(va, SYS_VNCR_EL2);
 
 			/* Force NV2 in case the guest is forgetful... */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4d83281a7a28..08582fbc09d5 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1643,7 +1643,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 		}
 
 		vt->gva = va;
-		vt->hpa = pfn << PAGE_SHIFT;
+		vt->hpa = (pfn << PAGE_SHIFT) | offset_in_page(vt->wr.pa);
 		vt->hpa_writable = writable;
 		vt->valid = true;
 		atomic_set(&vt->cpu, -1);
@@ -1683,6 +1683,12 @@ static void handle_vncr_perm(struct kvm_vcpu *vcpu)
 	kvm_inject_nested_sync(vcpu, esr);
 }
 
+/* Offset of the VNCR page in the host page mapped at the VNCR fixmap */
+unsigned long kvm_vncr_page_offset(struct kvm_vcpu *vcpu)
+{
+	return offset_in_page(vcpu->arch.vncr_tlb->hpa);
+}
+
 int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 {
 	struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
-- 
2.34.1

