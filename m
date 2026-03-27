Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5150D227599
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620166; cv=none; b=DTcNVgsHXSg/VL6nOazQiGvNFl2Icv45t2neAeD26bAoBahRU56ojSvLFh6g2whCsfZcV2gdN+n9X0SJ+nBeVrbVhCqBXLuqT0l+opglXlbqVcuBslIcC7b6pyUrXpfnyxfLHMCcqT9ZZgUIUQmKWjl7MxCk+bir8lIa9nTAC4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620166; c=relaxed/simple;
	bh=v4sdbEpyuONuFqIpPjjub6r/ELYIQlt3BomGV+5iADE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=La+c5PifbG2H4YR8gE3ip07u6EtUIuACINUzA4c98u0AfDhhqXkB3A2gTfcUx2tBL2eQk+H+sclkoOp0nv7NAf4FeQlxBFeUIssOWUvh+v62IHPqRD/Et2t7WooRkBnaH5qJ554exkPvI5guID36IZTS9U4IvDLWiQxlOhRQxuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RALNcfxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RALNcfxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0E8C2BC9E;
	Fri, 27 Mar 2026 14:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620166;
	bh=v4sdbEpyuONuFqIpPjjub6r/ELYIQlt3BomGV+5iADE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RALNcfxTnSfal0Vp+l08UVtKtcFRQW6jn4NSRn7Rru9t5CoknS6a5MApZaobNPCJ8
	 tjsl4ITZNfROcrHd7jQckUhCNvrqE36xPj36Kdp1WYdcRlcY+1+3ZoW0ln73+oKLTr
	 yc09SPmOdLZN39a0aFv8MbMB5q2qu5zACGBlT4i31UxY5kC6WsCZ3Hp0gl2hcGlz7k
	 koOn2GhSzwG7a+oNEf20qYlalfuP7h9IbX3AGybY172IkvE4ZY493FTk98zc9ExwCg
	 bOWUU91AjFxEXA/fOiPAiawP8odSUvvrDOvpx2peT8q8nx6qW2U5bRQyQmB6vI0cHp
	 yRmxj+Na2CH2w==
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
Subject: [PATCH v4 35/38] KVM: arm64: Extend pKVM page ownership selftests to cover forced reclaim
Date: Fri, 27 Mar 2026 14:00:34 +0000
Message-ID: <20260327140039.21228-36-will@kernel.org>
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

Extend the pKVM page ownership selftests to forcefully reclaim a donated
page and check that it cannot be re-donated at the same IPA.

Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index b2c9ea105701..05a5b145e303 100644
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
2.53.0.1018.g2bb0e51243-goog

