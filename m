Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50657324B33
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882247; cv=none; b=nfNyAJHrvlFsbiysrp0+SyErNBzE+64YqKuEFuSJ2nDo9ga997lSC1RGmlQJztpSpQ4pvvkFGX/SSmv9cqO2aiq6Ml+k9YRkBJzOYEbG743P2jnALCB7mpvvoC+p1cVr83H49e5JLhX8oNWXB82l+1tPtUeDpLd5VrQ5MheOG7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882247; c=relaxed/simple;
	bh=AQTCIMB9v84Q8tCnDop59lw8DExK5gGe2dtCnLlLy+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPTlCEjfaYjqBFO9H1UC+KZ8GlERvCYEPgfyAPr7HBhRAKB0M9nJSpHxlmPZUHnv/wAbNar1qRQskR3426Dw3swk8g3tXSrxtDKx6f8itLBwrCWGrDrEstqXH/xDTfebNDwzqIOTLJZcS+sKWnJYFpZ/S3Vi1LfYpOv+Ko+l2Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZbBkBsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZbBkBsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F1CC4CEF7;
	Mon, 30 Mar 2026 14:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882247;
	bh=AQTCIMB9v84Q8tCnDop59lw8DExK5gGe2dtCnLlLy+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZbBkBsUJKCF/Nr0StZnLHmstvf8g0Vd3W1JMPW0n1g3hP8CYlbiDxBn4Xj7GH3xS
	 DTKeTWmJ2XAdTbTt2FnrE/WFLTVXFUP2m7HmVL86L81rQHYW4ZQA8HmhSIclSjj3dq
	 8QCcGo/aCemgEncw+DOnTc04GhLtck6zsjiMxTPPXfS1ZdLVmwM5VsXduegtTS85x2
	 ti+h0TG0QZTMKE4aksoJzlasWm/8eXXUYFs2Ts55A2fy/B/ukRtTAT9MNFegDo74jX
	 edP+VpXpX3f3Pt/KL6EYFv1gXyuURSZ2X8566S9RIYiR1NNFHIUgQwAjb5zNysW+U/
	 FtJbzAFKKltgQ==
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
Subject: [PATCH v5 35/38] KVM: arm64: Extend pKVM page ownership selftests to cover forced reclaim
Date: Mon, 30 Mar 2026 15:48:36 +0100
Message-ID: <20260330144841.26181-36-will@kernel.org>
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

Extend the pKVM page ownership selftests to forcefully reclaim a donated
page and check that it cannot be re-donated at the same IPA.

Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d8f8ebe59129..0775a82ee4fe 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1815,8 +1815,20 @@ void pkvm_ownership_selftest(void *base)
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

