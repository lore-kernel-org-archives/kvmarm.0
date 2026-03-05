Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2183A8FE6
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721968; cv=none; b=UAinvLhWbnn7jEv8ZXTIC+sRQ3ktuZpgccAWXPydSvPtZzmG3hC8QThTv2GPGWcTWhY0dquJkZ48nmRu3f9peO/WmsaM5dp77/3ptj0HSlesp8LhdKApyFzqIINLcF6Ae2KszVQdHnPZ95RLxSF2UaXfZ+7IzfI8LWjtplgGL8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721968; c=relaxed/simple;
	bh=SYRALiYS850xWg3rAEJIWtzEkjEK13L1b+03ZuBiGOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+hQd49SEKPgBw1wqT7fWw2yMtPNVejjmQJgux5Xsi2RrOfSMLXkC5f7JYvz2nxu6lwxeGA+RxkcCWwaPGTNAb+clHZ0lN2XvOEBs8VaPilv/ExIcv2HzmKYCFazciTpWS8c7m8rLRuGT8zPEbgPwS+YHSj4KWiwPwvyLz4IwVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UpmF5Zy/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UpmF5Zy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28ACC2BC9E;
	Thu,  5 Mar 2026 14:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721968;
	bh=SYRALiYS850xWg3rAEJIWtzEkjEK13L1b+03ZuBiGOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpmF5Zy/daE6Nkfntxh7G+lAf6dZpU/vKMiAoDUmCu7QmcHumq/D/HXmz9JLy5oue
	 OnGSomm0TF5SEyLwx8fe+fx5GIwDNRBiLAhWcuDRorGNnpzgMk/Bej42JY05Vp7jii
	 6Miujf/FU1sCLs25UefzCrcdhXH7fB1W+1G8qrixwPWTcc2/4v9Dg3w+qZL+3QtOY+
	 igP/ijJA9om6WhOF1fklTKdRFGxfZKZOZKKMVTJsZKdV7vEypYPVkAOTdLy8oulI+G
	 vDTWeNT2kmnUjzZmABr0NK5iHzVC/I1sJBwbQQJuAdcS/fG8Bj/AObyO1HvbpbPzXi
	 NCZCP//3Lsr2Q==
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
Subject: [PATCH v3 34/36] KVM: arm64: Extend pKVM page ownership selftests to cover forced reclaim
Date: Thu,  5 Mar 2026 14:43:47 +0000
Message-ID: <20260305144351.17071-35-will@kernel.org>
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

Extend the pKVM page ownership selftests to forcefully reclaim a donated
page and check that it cannot be re-donated at the same IPA.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 1f461a0e9a77..de224e4ffeeb 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1813,8 +1813,20 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 
 	selftest_state.host = PKVM_PAGE_OWNED;
-	selftest_state.guest[0] = PKVM_NOPAGE;
-	assert_transition_res(0,	__pkvm_host_reclaim_page_guest, gfn, vm);
+	selftest_state.guest[0] = PKVM_POISON;
+	assert_transition_res(0,	__pkvm_host_force_reclaim_page_guest, phys);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
+
+	selftest_state.host = PKVM_NOPAGE;
+	selftest_state.guest[1] = PKVM_PAGE_OWNED;
+	assert_transition_res(0,	__pkvm_host_donate_guest, pfn, gfn + 1, vcpu);
+
+	selftest_state.host = PKVM_PAGE_OWNED;
+	selftest_state.guest[1] = PKVM_NOPAGE;
+	assert_transition_res(0,	__pkvm_host_reclaim_page_guest, gfn + 1, vm);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.hyp = PKVM_PAGE_OWNED;
-- 
2.53.0.473.g4a7958ca14-goog

