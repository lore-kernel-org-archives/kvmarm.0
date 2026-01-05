Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DBC13B293
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628249; cv=none; b=gZHzOifHH1fk5IVx+AQ2Om1xFqMSYNYjwcS/G7c5KlXlLTkrCjxFJ5YUP67U56zpq2UHG+ifteocMAC64+5gV0m6KV5MSUfRDQXzacSEv7WzsH8RasfhlYtsLYgvm8zWV9maJ5g5JUzAlQT8MP4IyLyl4vXFEoLCPQjiGbAkY9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628249; c=relaxed/simple;
	bh=s4+WSuCvYplaNUVX5guR216Cm3FmdjlvuYliNemWxzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIuyj96zL7+O19v9no8On/cUs2Ad4vPCsiO+DjPod2b56tsm/f/HqBtpwQAEsz87f3HVutNJsdlXH3WoNyYudQztMYd9XwxQs7Hp/dBntAx3hSoFHltbu4PDUa3y3b+UkXDIYDWQ8Y7gT+JeOix1uGycKYYJspuS5FhJ8zyMRpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yus9aiDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yus9aiDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C676C19421;
	Mon,  5 Jan 2026 15:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628249;
	bh=s4+WSuCvYplaNUVX5guR216Cm3FmdjlvuYliNemWxzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yus9aiDxosBrh2s7VoV5ser5y1E8q+nTR4OKnk+pbn2lhNkNbNea7Aq7iPcsI1J0i
	 JrHj4KBvAHIsvVyVKeY9V9taKvOlBddc6GZpWb6IdT7K1mouz9jqP4R0kCrJczoZVD
	 mydUavxCMbd0nT/huYYmPK7hSmluKY3RZMn+1gHEOqI3CIt9ZLyRKahjb/lbbw1P7f
	 j60HWn4RDcKT0kXDSm2ZQVnuSBrz7AR45z+C79fS7kZb2sELpX4qaT1G92iVjcJUYa
	 Y3PxDUCcbCYHXhOM/3s+nu/QxAIF31wDmc++p6U5hg2uRiljGM3sD0gGnncFsYC6/b
	 ZOdMiAwhiQMpg==
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
Subject: [PATCH 19/30] KVM: arm64: Annotate guest donations with handle and gfn in host stage-2
Date: Mon,  5 Jan 2026 15:49:27 +0000
Message-ID: <20260105154939.11041-20-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260105154939.11041-1-will@kernel.org>
References: <20260105154939.11041-1-will@kernel.org>
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
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 7d1844e2888d..1a341337b272 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1063,6 +1063,19 @@ static void hyp_poison_page(phys_addr_t phys)
 	hyp_fixmap_unmap();
 }
 
+#define KVM_HOST_INVALID_PTE_GUEST_HANDLE_MASK	GENMASK(15, 0)
+#define KVM_HOST_INVALID_PTE_GUEST_GFN_MASK	GENMASK(56, 16)
+static u64 host_stage2_encode_gfn_meta(struct pkvm_hyp_vm *vm, u64 gfn)
+{
+	pkvm_handle_t handle = vm->kvm.arch.pkvm.handle;
+
+	WARN_ON(!FIELD_FIT(KVM_HOST_INVALID_PTE_GUEST_HANDLE_MASK, handle));
+	WARN_ON(!FIELD_FIT(KVM_HOST_INVALID_PTE_GUEST_GFN_MASK, gfn));
+
+	return FIELD_PREP(KVM_HOST_INVALID_PTE_GUEST_HANDLE_MASK, handle) |
+	       FIELD_PREP(KVM_HOST_INVALID_PTE_GUEST_GFN_MASK, gfn);
+}
+
 int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
 {
 	u64 ipa = hyp_pfn_to_phys(gfn);
@@ -1105,6 +1118,7 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
 	u64 phys = hyp_pfn_to_phys(pfn);
 	u64 ipa = hyp_pfn_to_phys(gfn);
+	u64 meta;
 	int ret;
 
 	host_lock_component();
@@ -1118,7 +1132,9 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
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
2.52.0.351.gbe84eed79e-goog

