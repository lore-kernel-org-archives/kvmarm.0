Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0643242BD
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882250; cv=none; b=eoX8AvhQV2iys8+JgxHVvPsOAbWAX8c65ntRoDUC7pCovHxM3IoLTsP71GEduCK5AsNFna5F9kurTUBQohYr9K9aExyV3FaJ8qB3OGWkKBcAfKR10TQzDjR50fcI8rWpl7IOrsB5g1nhYsXHfg2gk0hYMpjeyBeXk+VwGtoMyMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882250; c=relaxed/simple;
	bh=GiSskl8OLA12RfOjYegapiMD5zVMQpADJ6x/WJGQmpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pxb5mXb+CSV9YKWLOgpRwSZtrxHKUKjkV8fBGy961MzLXie9AhkCfp0iq0cpCyJOSV1TrckfVooq97zyLBwcQt0tqTnehmmwcyVUlruZ+7AKiMDZZDfdVojEsRrjQdOepx9LFC2+S1OPH7dic6eibKlF0OuabJgW43DcR8yHA/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rBYb6CSv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rBYb6CSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DDCC4CEF7;
	Mon, 30 Mar 2026 14:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882250;
	bh=GiSskl8OLA12RfOjYegapiMD5zVMQpADJ6x/WJGQmpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBYb6CSvb0qq4VRZK4TH0YhGUUtgPYKfm5g69OM1x1bCv5Zp8f1tJguRkM3LNoMdj
	 m4hZt6LKkNPVTjLToBmw3lWE2Cn3It40yvLporQU496rEDTJzRTLugOT5cOHdz8XjJ
	 Dzu8OIiuwd69ReU7x/G3UDRYsQIs+VGlbu0FfP0f1e/2S1qKeRpQ5OB89Rtn4LtAsK
	 TB+rakES9BH2rPwhBH3yZlxbHE76E+RaiZgfqTc8LDEbljuDzlrQakY7MU4r0beW7A
	 5lk6bu+SDAlZ9LR1eSFm3Bdar/J51PPN1nR/0bd/jnLdFMWJlGM7ER4X7GS6fYCfhe
	 2+ZOoo9J+muTw==
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
Subject: [PATCH v5 36/38] KVM: arm64: Extend pKVM page ownership selftests to cover guest hvcs
Date: Mon, 30 Mar 2026 15:48:37 +0100
Message-ID: <20260330144841.26181-37-will@kernel.org>
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
index 0775a82ee4fe..28a471d1927c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1814,11 +1814,41 @@ void pkvm_ownership_selftest(void *base)
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

