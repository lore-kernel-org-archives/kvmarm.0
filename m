Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F553AA1A6
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721975; cv=none; b=N5JcqtmsekpQwj+tLfgrUcywdeNu52NHDH5LrrMh90CwpFWoUND89CwE9iu6lVVK1Ke2B2KrxGLA31vrZF9S9nYWDmC5WqMsS/WmyRZBiq3UtT72OtiI/gYf3FQnga+wLcOqE5XskGRmwNU480NxNlSp4MU9yOoH7rjcJCGp0Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721975; c=relaxed/simple;
	bh=oZcCfY/nioqPKTU9trBN+esVvAZhnr2RYRCLrfwP754=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9p2DUtOIfd7cvCQuWIm+Cv7KkjXlEpRGpU0vvKEb+CYupRIR2J3lkkSAUtOPmue8OmXCfHb0mGJ2l1xY+8NtEAB1nLIEMucL+yVmpSTSJJVbrU8TUCrEGknoimEa9Py+aLi7QNNxpjyoanlJuad+3aAgbtoumpRs2nGjGLjvdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nupp1a6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nupp1a6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D13C116C6;
	Thu,  5 Mar 2026 14:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721975;
	bh=oZcCfY/nioqPKTU9trBN+esVvAZhnr2RYRCLrfwP754=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nupp1a6D9V7Y7uajqJaNSL5oBJxrMqJWYyxJyXxRnRCKd01rf+liXMQJRjgjOb3Q7
	 0UDlrr43Ob7yq+XRRKwZPAU6Pz1RoF0Rwf6jfCEJHLAsy9BGu/3yVB/f7dQ/sJXosk
	 OukL7EtKxgLKi1O1eVT5BnyO4z69zYJSJiqj2huXpnzU5U5mMYh7kppGVQu23BKsRy
	 8LEz0T/gIoomgLrN4TL21A5R+ZakCQVAhEPTRCsQD+3PA4Tz5F6CSYP1ABR6wFXqwe
	 g9z/Wm93kK4SzRMNs6AXxtUuE/e8CQhtRkU8mPutTGmKzsmAk4r6L7YtjBYYKXE8+C
	 QHaVviOpkTuUQ==
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
Subject: [PATCH v3 36/36] KVM: arm64: Rename PKVM_PAGE_STATE_MASK
Date: Thu,  5 Mar 2026 14:43:49 +0000
Message-ID: <20260305144351.17071-37-will@kernel.org>
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

Rename PKVM_PAGE_STATE_MASK to PKVM_PAGE_STATE_VMEMMAP_MASK to make it
clear that the mask applies to the page state recorded in the entries
of the 'hyp_vmemmap', rather than page states stored elsewhere (e.g. in
the ptes).

Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
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
2.53.0.473.g4a7958ca14-goog

