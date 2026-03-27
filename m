Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4EC227599
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620172; cv=none; b=Ntzn93Gz9r84z059zgM9UGv5LX25ZgUgakimBWtCqjtriFT5ChAifk4ighGglt40YocJAECmvqPwOfT+wiXxIyQ+q6OGAN8VfIrkhv07OznKxLdgaBfTPT/MaUFCpZ57GHtdx4oduKl8XNp6jD+BjDE4az0woolOjJxY6vACLdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620172; c=relaxed/simple;
	bh=4A/Kf/cSzi1Il6/q35e+0ZP6t+7/cxTLMzjHM29zqvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ev8uEjHejNoVtJZtHkQTyd/VwTUuzgeTKUyTgOQ/XKYWj1O0fty1iXA9VB+60Z/etJEjL+6TsZwYZ/bmPhJqHqAP2scQZ+7POgBNc9K7vS7XswrILQitXVYJzf2J2LOzoWaP76Lf/5SGPrSVVyTDiWRKLPL5FdH1E7ksultr9sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QlEsFZ2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QlEsFZ2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148BDC19423;
	Fri, 27 Mar 2026 14:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620172;
	bh=4A/Kf/cSzi1Il6/q35e+0ZP6t+7/cxTLMzjHM29zqvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QlEsFZ2FK+XFwFy/whdDO3Iojz1ZK1OPbRmQmdETj8Y4UNUI0eytzBBRwa2R8PcQo
	 kIhz+nik7DtxvgXOmK2s1eHSUW97wZMItAqfMd7I4ewdC7EyQMCuNIn3qOZvuHEX3b
	 p6yNYqvd0QyWuvWTlGLt8ngaIF9VrVip671sKyyXMc0JqfbgO6Xwx58fYAKFKIv7j/
	 m5SQtRiutPK7iG+0gzyqAB0SU4AxZk4ms0nz6pvSIUAsV9tuAraLkwVsgbqTfFRu1t
	 QjGdoOVFnjLy2/qCVTfra9gpGWn5NRtPnCd/JYeUYVT7TZPIZektVz6GOtfr+Mg8Vs
	 e5ggsGRmCgwcg==
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
Subject: [PATCH v4 37/38] KVM: arm64: Rename PKVM_PAGE_STATE_MASK
Date: Fri, 27 Mar 2026 14:00:36 +0000
Message-ID: <20260327140039.21228-38-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327140039.21228-1-will@kernel.org>
References: <20260327140039.21228-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename PKVM_PAGE_STATE_MASK to PKVM_PAGE_STATE_VMEMMAP_MASK to make it
clear that the mask applies to the page state recorded in the entries
of the 'hyp_vmemmap', rather than page states stored elsewhere (e.g. in
the ptes).

Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 4cedb720c75d..b50712d47f6d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -37,7 +37,7 @@ enum pkvm_page_state {
 	 */
 	PKVM_POISON			= BIT(2),
 };
-#define PKVM_PAGE_STATE_MASK		(BIT(0) | BIT(1))
+#define PKVM_PAGE_STATE_VMEMMAP_MASK	(BIT(0) | BIT(1))
 
 #define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
 static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
@@ -114,12 +114,12 @@ static inline void set_host_state(struct hyp_page *p, enum pkvm_page_state state
 
 static inline enum pkvm_page_state get_hyp_state(struct hyp_page *p)
 {
-	return p->__hyp_state_comp ^ PKVM_PAGE_STATE_MASK;
+	return p->__hyp_state_comp ^ PKVM_PAGE_STATE_VMEMMAP_MASK;
 }
 
 static inline void set_hyp_state(struct hyp_page *p, enum pkvm_page_state state)
 {
-	p->__hyp_state_comp = state ^ PKVM_PAGE_STATE_MASK;
+	p->__hyp_state_comp = state ^ PKVM_PAGE_STATE_VMEMMAP_MASK;
 }
 
 /*
-- 
2.53.0.1018.g2bb0e51243-goog

