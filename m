Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406E7325726
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882171; cv=none; b=sJBEvJ/02htJdHO9qclmPp6wTObD5v4izLUIKSV7LcD+GqrjqQezUihCC58JBOcxJGNvOizUpJa6/chGeaGtkLbfF4M2UqjEV4miCxQ3H6FDcSSvnjbMX641eqaSam9jgV/haIkyw/JgBguNXIiDdTc102smKIhbyoUullnOz3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882171; c=relaxed/simple;
	bh=3p+s6mSLzngeE4GeNqWVaT7bt4Pawk6N3abwHTMrSPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTwe5LUsfWLmqzmd7IJXUwps/QsCyHUCUXzHo3yUGrsfLyGiCIQvc0HyBj5a0AbMeEfdsAxbub6cqK1VVhkExKcT8EmLDd7ZbxU6mYnsApeMK2diwnkcmwGPZOrB1s8tM9fCRMvfr37VoBWPTGsBevFYU5YFYWTKkCqIqKNfokA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DxBFBOFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DxBFBOFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFBEC4CEF7;
	Mon, 30 Mar 2026 14:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882170;
	bh=3p+s6mSLzngeE4GeNqWVaT7bt4Pawk6N3abwHTMrSPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxBFBOFIworFTtDkVTaC5NchS1kPL0WG5LV95zauCuAWkYTN1+ceCQmQZzBi2PQiB
	 MhIZg8pc8QlBFa3J7VI3qMB78qxniCvwYbJe/AfFQbHOOA0IgOvInR0iDpC9dITMFf
	 I/dH3WK5szXFNKwO889XkjOIo7y6peqkExtXd3cJ0UUnbMvj838TO2PL9kje2gIltr
	 RoC8WjmJbyTK80Sq6vJjQR/SkggQYsuxHGjITpg9Fn2d5nUxjuWzAaHk7ySBN3mhmh
	 H6tR3tSxZLqDqLuwBhC/ye1fsMYEylYw/QLUCvdI5HBvrQc7V9TyFYvuWlIw9DRWKe
	 54nvKQoGhDwfw==
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
Subject: [PATCH v5 12/38] KVM: arm64: Introduce __pkvm_host_donate_guest()
Date: Mon, 30 Mar 2026 15:48:13 +0100
Message-ID: <20260330144841.26181-13-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330144841.26181-1-will@kernel.org>
References: <20260330144841.26181-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for supporting protected VMs, whose memory pages are
isolated from the host, introduce a new pKVM hypercall to allow the
donation of pages to a guest.

Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/include/asm/kvm_pgtable.h          |  2 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 21 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 30 +++++++++++++++++++
 5 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index df6b661701b6..dfc6625c8269 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -79,6 +79,7 @@ enum __kvm_host_smccc_func {
 	/* Hypercalls that are available only when pKVM has finalised. */
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_donate_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_relax_perms_guest,
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index c201168f2857..50caca311ef5 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -100,7 +100,7 @@ typedef u64 kvm_pte_t;
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
 #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
-#define KVM_MAX_OWNER_ID		1
+#define KVM_MAX_OWNER_ID		2
 
 /*
  * Used to indicate a pte for which a 'break-before-make' sequence is in
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 7f25f2bca90c..7061b0be340a 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -27,6 +27,7 @@ extern struct host_mmu host_mmu;
 enum pkvm_component_id {
 	PKVM_ID_HOST,
 	PKVM_ID_HYP,
+	PKVM_ID_GUEST,
 };
 
 extern unsigned long hyp_nr_cpus;
@@ -38,6 +39,7 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
+int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu);
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
 			    enum kvm_pgtable_prot prot);
 int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 634ea2766240..970656318cf2 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -241,6 +241,26 @@ static int pkvm_refill_memcache(struct pkvm_hyp_vcpu *hyp_vcpu)
 			       &host_vcpu->arch.pkvm_memcache);
 }
 
+static void handle___pkvm_host_donate_guest(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, pfn, host_ctxt, 1);
+	DECLARE_REG(u64, gfn, host_ctxt, 2);
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	int ret = -EINVAL;
+
+	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
+	if (!hyp_vcpu || !pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		goto out;
+
+	ret = pkvm_refill_memcache(hyp_vcpu);
+	if (ret)
+		goto out;
+
+	ret = __pkvm_host_donate_guest(pfn, gfn, hyp_vcpu);
+out:
+	cpu_reg(host_ctxt, 1) =  ret;
+}
+
 static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(u64, pfn, host_ctxt, 1);
@@ -595,6 +615,7 @@ static const hcall_t host_hcall[] = {
 
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
+	HANDLE_FUNC(__pkvm_host_donate_guest),
 	HANDLE_FUNC(__pkvm_host_share_guest),
 	HANDLE_FUNC(__pkvm_host_unshare_guest),
 	HANDLE_FUNC(__pkvm_host_relax_perms_guest),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 7d22893ab1dc..03e6fa124253 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -971,6 +971,36 @@ static int __guest_check_transition_size(u64 phys, u64 ipa, u64 nr_pages, u64 *s
 	return 0;
 }
 
+int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
+{
+	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
+	u64 phys = hyp_pfn_to_phys(pfn);
+	u64 ipa = hyp_pfn_to_phys(gfn);
+	int ret;
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = __host_check_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_OWNED);
+	if (ret)
+		goto unlock;
+
+	ret = __guest_check_page_state_range(vm, ipa, PAGE_SIZE, PKVM_NOPAGE);
+	if (ret)
+		goto unlock;
+
+	WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_GUEST));
+	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
+				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
+				       &vcpu->vcpu.arch.pkvm_memcache, 0));
+
+unlock:
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
+
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
 			    enum kvm_pgtable_prot prot)
 {
-- 
2.53.0.1018.g2bb0e51243-goog

