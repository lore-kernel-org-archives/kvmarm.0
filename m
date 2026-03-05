Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0620C3A7F6D
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721962; cv=none; b=ns2FpwrhRlGDyrtQ61H9QYInConVpEmZ5zLHgaD0qZxXypEsuMlpTkGxOZZGzcx8el90y3igQO6SD/cVWNP1Crhk1zf1vDa+/DAJz+ltQPslZt4l+Wb1k9msdOqpRCWePMPUUeZFMzuy7aoxpkSD+vdyP3zLV7IrGSy485EAxOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721962; c=relaxed/simple;
	bh=JMsADauVwoK+rhbXcdhmsfcGVmS4DV0WhUMrvOzFvmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pECk2GQaEiKTAdNcWX9D3an1kC4IQcQZiU+KqVWt4DHYo/d15+WWDhjkW9Rq2KTK/rHAlDSkJmTn2lk7woXggOBRYCrB+69avTCocYJXcxclEzfKJEWQTDFSOjZotIyKs40lndjvq5PObwuNJRalflJU8ISLRA7RLwPd7UwpsTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tn0cJn9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tn0cJn9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC736C2BCB0;
	Thu,  5 Mar 2026 14:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721961;
	bh=JMsADauVwoK+rhbXcdhmsfcGVmS4DV0WhUMrvOzFvmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tn0cJn9LzZ+mrl3/VCy4skw6dMAjgx/KyUN/x6wm+Id4OVhDU5IYwxi5DbV/1q4EV
	 MuOEMFK222ZyWewoaIJKSEm7RNDp2tODoGDuBBj65jptDgbADXmqe0Nma+v211f+ob
	 vCz3DQe9w3XlqkrpQfMjuqUp4ZxDraxhz5v+S61oK2+wfLAbnuJqzHPt8uu/EKx5Y+
	 g8daLEXAvgw6WmLLtOOiNBT+omsU7tRWHvoTnJ/NbAjl7p2Cwu/i6vqbjd7OX5RqNd
	 Y4ICTlwnIzJXluGXMQvT/zLquoP1JVJPtGQzkMQQdPgTGZHVadsMh6ALwZIeyju967
	 Vom6nAWy/cB3w==
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
Subject: [PATCH v3 32/36] KVM: arm64: Extend pKVM page ownership selftests to cover guest donation
Date: Thu,  5 Mar 2026 14:43:45 +0000
Message-ID: <20260305144351.17071-33-will@kernel.org>
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

Extend the pKVM page ownership selftests to donate and reclaim a page
to/from a guest.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 4451955ac767..d13ea7b7e878 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1749,6 +1749,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
 
 	selftest_state.host = PKVM_PAGE_OWNED;
 	selftest_state.hyp = PKVM_NOPAGE;
@@ -1768,6 +1769,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
 
 	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
 	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
@@ -1780,6 +1782,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
 
 	hyp_unpin_shared_mem(virt, virt + size);
 	assert_page_state();
@@ -1799,6 +1802,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 
 	selftest_state.host = PKVM_PAGE_OWNED;
@@ -1815,6 +1819,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
 	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 
 	selftest_state.guest[1] = PKVM_PAGE_SHARED_BORROWED;
@@ -1828,6 +1833,23 @@ void pkvm_ownership_selftest(void *base)
 	selftest_state.host = PKVM_PAGE_OWNED;
 	assert_transition_res(0,	__pkvm_host_unshare_guest, gfn + 1, 1, vm);
 
+	selftest_state.host = PKVM_NOPAGE;
+	selftest_state.guest[0] = PKVM_PAGE_OWNED;
+	assert_transition_res(0,	__pkvm_host_donate_guest, pfn, gfn, vcpu);
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
+	selftest_state.host = PKVM_PAGE_OWNED;
+	selftest_state.guest[0] = PKVM_NOPAGE;
+	assert_transition_res(0,	__pkvm_host_reclaim_page_guest, gfn, vm);
+
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.hyp = PKVM_PAGE_OWNED;
 	assert_transition_res(0,	__pkvm_host_donate_hyp, pfn, 1);
-- 
2.53.0.473.g4a7958ca14-goog

