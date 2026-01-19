Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8930435FF63
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826884; cv=none; b=fSqrnqAWNjZBeNkPQ3WDsX8ANwgsJP4My8hXMhS0kkHP7Ichd0REZbKMH3dNprvJq8rRvAg2USoCaG3Cp3st5wY5wITSZB5h7LA/fE0ykaGSIkqx2BHZdckTEOnuw65ZuZS/VYKifmWU89773qFE3+iJ7MqgoWA/tCOhA2M4V1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826884; c=relaxed/simple;
	bh=HLObyQ2C3OlpbbWkKCbgPGiNTWrLBOjOTaVyF6Dy9uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaawC48j7yHepTgTlQPBY5llkESknot8h4n+Ohb6YobDIRFWKy1ezfaGuhLJ5DE3Uv+xifnGNrOo+kP2kwkWHSPISaExHGKl+SAtyMZFjgBNDn+M5wnOZBIWQRWS1Fqe4Hefnp7hbwoCnbEITnyueZDVTKSzouqSR9Olg78+yF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7I9tTbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7I9tTbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83460C19423;
	Mon, 19 Jan 2026 12:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826884;
	bh=HLObyQ2C3OlpbbWkKCbgPGiNTWrLBOjOTaVyF6Dy9uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7I9tTbicvpoiNF+5T1bpB9W0zJOJ5C/TtKCfAOkEmwcaB+vxmzyxYwkBUhY2T6UM
	 YAw19gSDdip7pS5sa4cLK8QDNQ6AYLmAbu7XcUNfzMKmfgoYrkYw9CwjYkB/arlLYk
	 yaoZMWR8yVLQzunFkJgzk48GavVMeFEuQUxkNUTgliFj332osQYKuLkC9R0UPCHYYs
	 uLcIsJjq/GZKOMqswJdDzRM5T2XXOIuksSU96Li2LF5bPeV+vmRlE/bNkeg9iLiQU4
	 Y8VaCbKwF8n1TVPNzrYDQrN11ys4RXbJq3sGjvKHI0apnoLtV/xfqUbyPENgAdTyif
	 55KCo54v3bn1w==
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
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 23/35] KVM: arm64: Annotate guest donations with handle and gfn in host stage-2
Date: Mon, 19 Jan 2026 12:46:16 +0000
Message-ID: <20260119124629.2563-24-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
References: <20260119124629.2563-1-will@kernel.org>
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

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index e090252d38a8..f4638fe9d77a 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -590,7 +590,6 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
 		if (!ret)
 			__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
 		break;
-	case PKVM_ID_GUEST:
 	case PKVM_ID_HYP:
 		ret = host_stage2_set_owner_metadata_locked(addr, size,
 							    owner_id, 0);
@@ -600,6 +599,20 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
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
@@ -1133,6 +1146,7 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
 	u64 phys = hyp_pfn_to_phys(pfn);
 	u64 ipa = hyp_pfn_to_phys(gfn);
+	u64 meta;
 	int ret;
 
 	host_lock_component();
@@ -1146,7 +1160,9 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
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
2.52.0.457.g6b5491de43-goog

