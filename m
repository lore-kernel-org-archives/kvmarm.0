Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972E92417E0
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620169; cv=none; b=kUvt6FMPgTEo+yDlzaOnOcLPBxEtys50MhmznKg8NH+1lUGTlRdIpCzWyi6BDejr5tLuyEjLryoAbd77hp0BJSER5gLTTDBwutWGTHcliWo/QVQhOOJg04GEgXAvcXVuP7Z2WRPjN9TXJGSW5ZOG0O7ElFQT60K45ll/Cv93Pxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620169; c=relaxed/simple;
	bh=Lt5f4dcoCx+8QH+YtzLO7DvbDoIX+GF3jrrIPRh/lk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojItNtw06IFW1RkeOqFEk0l7E4PtltF35rPCeS9sKOzpw882nl2pv7JLYXIrqR7DJ7/BKyNdPiCA0OnqFZDL691mk3yTw/6WeZqkWsHr81E5FSa7pKI+r5gnbAyPRaVz+BzP+vyh6FcXOgwt8qzjkd9j+HvqYHNlQVjrQUwuGMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TybQmRMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TybQmRMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5122C19423;
	Fri, 27 Mar 2026 14:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620169;
	bh=Lt5f4dcoCx+8QH+YtzLO7DvbDoIX+GF3jrrIPRh/lk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TybQmRMghihEsVjuRnCaUj4SMLLRoPsxWCyHL4I8WvcneUizNAotgG1BYgUt4thj/
	 Cm4fi1HILYK9vULdPIkCsvE144v6JsVRxox6r/NyZl/gzeGDU7RSrrvHt0QxA/bq36
	 qehm/uKn7W2VN3FlzOTQVz+rqELrxxGMrnmQGi/h7EDaUc0pKycm2cwwUHQqOXmJj4
	 uG0DX7sh/Fe2XJWBwHCj7++1pe1mas3gTtZTvT938LCRMzQ19+xjq3Dtx2LmsWECns
	 slvP82aPFq5R/jtAn2hLVPCx38a1p5Tlm1JNF+75rACa7WLMx1nnP9tE1yFQK+RC5G
	 XggexcdUoFbdA==
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
Subject: [PATCH v4 36/38] KVM: arm64: Extend pKVM page ownership selftests to cover guest hvcs
Date: Fri, 27 Mar 2026 14:00:35 +0000
Message-ID: <20260327140039.21228-37-will@kernel.org>
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

Now that the guest can share and unshare memory with the host using
hypercalls, extend the pKVM page ownership selftest to exercise these
new transitions.

Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 30 +++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 05a5b145e303..0921efb8a16f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1812,11 +1812,41 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 
+	selftest_state.host = PKVM_PAGE_SHARED_BORROWED;
+	selftest_state.guest[0] = PKVM_PAGE_SHARED_OWNED;
+	assert_transition_res(0,	__pkvm_guest_share_host, vcpu, gfn);
+	assert_transition_res(-EPERM,	__pkvm_guest_share_host, vcpu, gfn);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + 1, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn + 1, 1, vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
+
+	selftest_state.host = PKVM_NOPAGE;
+	selftest_state.guest[0] = PKVM_PAGE_OWNED;
+	assert_transition_res(0,	__pkvm_guest_unshare_host, vcpu, gfn);
+	assert_transition_res(-EPERM,	__pkvm_guest_unshare_host, vcpu, gfn);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + 1, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn + 1, 1, vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
+
 	selftest_state.host = PKVM_PAGE_OWNED;
 	selftest_state.guest[0] = PKVM_POISON;
 	assert_transition_res(0,	__pkvm_host_force_reclaim_page_guest, phys);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
+	assert_transition_res(-EHWPOISON, __pkvm_guest_share_host, vcpu, gfn);
+	assert_transition_res(-EHWPOISON, __pkvm_guest_unshare_host, vcpu, gfn);
 
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.guest[1] = PKVM_PAGE_OWNED;
-- 
2.53.0.1018.g2bb0e51243-goog

