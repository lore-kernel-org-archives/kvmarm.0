Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98BE32571D
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882254; cv=none; b=HVP9F54FvxVHrM1NA2nz6GBK+c01xECTlNYMkddP1THrwOY2hpAdmXNGEkHTDv19erBcAWQ4t0QphDYgRvAMwn0smaAY8aBEdgEFeQDSjiF7201+XzFkUIzKxzWERwEnDYIXyjvlZ3PGU+/5O+ZbkRhXYacuWb/XFl85+3gmnuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882254; c=relaxed/simple;
	bh=4A/Kf/cSzi1Il6/q35e+0ZP6t+7/cxTLMzjHM29zqvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jo/wZwB456xiC2dbyZ+PglQYlM4BxXfNKf2tNBR7WUPwMKXjKK46NgvMGybYMsjWLkezuN1o1B7/fOH6uoKHoQN28mtlS+WpdHqHxcfTHHn2iQJv1Isdr7kbmAae1WcVWNo/8tUwYFAUwXAwsUEoNMJo2J4isx+r343C+ZFkYis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i9plNqAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9plNqAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD3EC4CEF7;
	Mon, 30 Mar 2026 14:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882253;
	bh=4A/Kf/cSzi1Il6/q35e+0ZP6t+7/cxTLMzjHM29zqvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9plNqAg1yBElsNrjsjEPXggKpFPx1Gjc9BGCTwjNG0RKOcruZqL8oY6AD9C0rJoG
	 YkArx0DFBg45DZPwPZXWFjbfMoLk8ZpcDsAggVg0mNiFiu6Lw/HtYzjJJg6xpDhCFN
	 qeX6houg8Dyg9dwT+dHhYxHN1gQJDysFa6GoLqeSZVnE/GIqbYBA39v8YzrVo7guNy
	 Y6MPeSws2QjJu0UpesQ7/D9dfcasz8hBwslQqslsWOU/Eyzis5kXyrYlvh84smvqFj
	 2tyyj/AJrZVZhGx8mRLENomv2qXRVJuqGpBgLuMB52RAULF9DPS9bj7ukOvfCdRw9a
	 Yaivu8SBz3fQg==
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
Subject: [PATCH v5 37/38] KVM: arm64: Rename PKVM_PAGE_STATE_MASK
Date: Mon, 30 Mar 2026 15:48:38 +0100
Message-ID: <20260330144841.26181-38-will@kernel.org>
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

