Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E25E387570
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721931; cv=none; b=rM4thGvPbydqUhXOIPeUnUgAIz/68hty9qVxd7IaYandlIjUltDlz9jeCdz57xXm4sHOe3LizUefFiPy66t1AUogB8G2IlsSTObkhhx1gmaf3KUYnhLHqaXHVcrZ0RlD8uzxG6SqqE7DJBKACNWkTnu8fPcyOuwp867g0GG79cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721931; c=relaxed/simple;
	bh=vdgsxQ+KX14BSB3ns8FdNXFw052PhZg+HzhbARyR850=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQPZjV1OBuy7oI26465MxQ41HC0u4VxiJC0HrADxEN2EZWItL7p3w5n+BcNXWogPiVL/kF8tl/zCToDCxzfZJkzht5AyjuevpD7OQphaul4swj5eyOfQgPZVzVvfNauDIMLGz2asUZPAcZw957ESHxvP99ymVtnsU88k04Q4bdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMkWR+d5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMkWR+d5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8516C2BC87;
	Thu,  5 Mar 2026 14:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721930;
	bh=vdgsxQ+KX14BSB3ns8FdNXFw052PhZg+HzhbARyR850=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMkWR+d5g25gaJINS9iLGI1+6hKljYjYVqhz0IWpxlJwKqSCRuwRCxesqn/CXUZE0
	 gZqegnvruU5rM2+LnBlrY4SE3hbS6oKt9axbLuOMRpaQiYw7LCj9F6Zq70qGpZ7Zqr
	 KfK2SbTA/qbTA1JFxDGUAn8R7YsWAePomRBBQKlE/QSwR0VVvei4l4AAGvlfaZRUEX
	 RmOdTb6EH1mOEgFxaa7DzTHTSvPSRQN3cwq/og0ucYV6vd3/1voQfxjkt8U92fAEdK
	 /Y87FMvJpYXJcTHSw11iTOVOJ3b1JT8KuM3IGbXAcPYarcDsgYV1kglLy8c+oMmXZL
	 pRTeEE47AsJ1w==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v3 23/36] KVM: arm64: Annotate guest donations with handle and gfn in host stage-2
Date: Thu,  5 Mar 2026 14:43:36 +0000
Message-ID: <20260305144351.17071-24-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305144351.17071-1-will@kernel.org>
References: <20260305144351.17071-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Handling host kernel faults arising from accesses to donated guest
memory will require an rmap-like mechanism to identify the guest mapping
of the faulting page.

Extend the page donation logic to encode the guest handle and gfn
alongside the owner information in the host stage-2 pte.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index ed540ccd1595..3b2f7d4c4936 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -593,7 +593,6 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
 		if (!ret)
 			__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
 		break;
-	case PKVM_ID_GUEST:
 	case PKVM_ID_HYP:
 		ret = host_stage2_set_owner_metadata_locked(addr, size,
 							    owner_id, 0);
@@ -603,6 +602,20 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
 	return ret;
 }
 
+#define KVM_HOST_PTE_OWNER_GUEST_HANDLE_MASK	GENMASK(15, 0)
+/* We need 40 bits for the GFN to cover a 52-bit IPA with 4k pages and LPA2 */
+#define KVM_HOST_PTE_OWNER_GUEST_GFN_MASK	GENMASK(55, 16)
+static u64 host_stage2_encode_gfn_meta(struct pkvm_hyp_vm *vm, u64 gfn)
+{
+	pkvm_handle_t handle = vm->kvm.arch.pkvm.handle;
+
+	BUILD_BUG_ON((pkvm_handle_t)-1 > KVM_HOST_PTE_OWNER_GUEST_HANDLE_MASK);
+	WARN_ON(!FIELD_FIT(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, gfn));
+
+	return FIELD_PREP(KVM_HOST_PTE_OWNER_GUEST_HANDLE_MASK, handle) |
+	       FIELD_PREP(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, gfn);
+}
+
 static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
 {
 	/*
@@ -1125,6 +1138,7 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
 	u64 phys = hyp_pfn_to_phys(pfn);
 	u64 ipa = hyp_pfn_to_phys(gfn);
+	u64 meta;
 	int ret;
 
 	host_lock_component();
@@ -1138,7 +1152,9 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 	if (ret)
 		goto unlock;
 
-	WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_GUEST));
+	meta = host_stage2_encode_gfn_meta(vm, gfn);
+	WARN_ON(host_stage2_set_owner_metadata_locked(phys, PAGE_SIZE,
+						      PKVM_ID_GUEST, meta));
 	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
 				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
 				       &vcpu->vcpu.arch.pkvm_memcache, 0));
-- 
2.53.0.473.g4a7958ca14-goog

