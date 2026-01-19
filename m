Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF9735E555
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826917; cv=none; b=qc/1F3ENBJMDEspKEpyVQQ48ZXv5Tzhz5/gvFfx0wLRhrwD7vyjhQt9cd7qpNFpuRYquLZ65S7MqgsDJeIr+6sh6CXZU23Yy8p52EhcNdmBVaszHdtImYV6netzMnKaoDQP/BD13pH4Pl+Xhjgyka9CG19xlDojKnHy3UJGfyyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826917; c=relaxed/simple;
	bh=kQcy7tZbHLnHu83JmogDffTHHwCWfmsWUHO+FmDCzzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJy5huumRph1xC4ZMvwkTKL43lM1A0rIFr7vOJIXJ+DVC5bC0Y7eC0fpPVDYwpxm7pcD8ApcjQtEe0wP15Ocg7Mr+q9bY2IrlVvorYukaZkkgvrqPW2n5yY2sTXOlP8uxh8B809sP/IDvrHMmaH1txzTlDxbz8FrWWDvPmYJ+Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HMXFTSpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HMXFTSpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44187C116C6;
	Mon, 19 Jan 2026 12:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826917;
	bh=kQcy7tZbHLnHu83JmogDffTHHwCWfmsWUHO+FmDCzzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMXFTSprX7EZ9/BSDIk0pC4Bcr/3BG+tyJIXFYB1oOSidh4y8JnJwUlQjEpjRLGtu
	 yOlQuzGCntTVei76DuTyBba5NFp5z23b1PgbmKkPFdXDGm1B/Goj1xzwSJ34mL+VP9
	 8S1kiZ11+2pddF6G3oYeyjA76W5McY5m31bK/3WWzy0Xdx1ROdUkBGWzLGETT3vklG
	 vuGxHiKYUPmNlzOnJdx91/zG2sLLh4gFZs/1s1T/1+6w5Nu/DD53+rknaHhEQ2W0ct
	 flmytL71DDZYT2HD2fKzWO4indfWP9NXUs2rpbhkckLwOdNUjKKyU8TX1z+McHRJsG
	 Iliq52SXeTr7w==
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
Subject: [PATCH v2 34/35] KVM: arm64: Extend pKVM page ownership selftests to cover forced reclaim
Date: Mon, 19 Jan 2026 12:46:27 +0000
Message-ID: <20260119124629.2563-35-will@kernel.org>
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

Extend the pKVM page ownership selftests to forcefully reclaim a donated
page and check that it cannot be re-donated at the same IPA.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index f36f81f75fdf..a7d880701933 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1821,8 +1821,20 @@ void pkvm_ownership_selftest(void *base)
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
2.52.0.457.g6b5491de43-goog

