Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFDA35EDA5
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826921; cv=none; b=hgDKnA/pk3pDd3pB8k2Gj2QB5+QhIxgNThL9gWsM2fdCcZyx8wrTP1teInarVQPjg/U9zEhHJqmCki5PJCuxbgtvrHkQ04JaMTnz0RsnEV/XUhCTrvFbc1w6XajGLWlQv+P2iOHDaOjxpOG6zlBgZrm5DYHACXBh+odwXxgr8Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826921; c=relaxed/simple;
	bh=XtjaNjYBSzXtUDXYEYlzOYWEqBLFkdzbmK8msawMA4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbHn6FsfMgcOX1yFzg45RxGgyzG4XARlwUYIZfLjL3IaU1PkcgkuAD+4A9vtUtcJjnUjJg2AvI4Kot8pZN/U0fJj+hkpVpWf22uwhQDdB9IaLDRyWfjKaFb0PaCEhr1l3aAIUi2zY1JCvDyuBbrXGZABujwDwF8hj8XcfL80li0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tD57yHSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tD57yHSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E28C116C6;
	Mon, 19 Jan 2026 12:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826920;
	bh=XtjaNjYBSzXtUDXYEYlzOYWEqBLFkdzbmK8msawMA4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tD57yHSrjT61I+3b+qGXsz4c8cbH3DbsLVC7YK/crkzPjska1HS6+EUNnoN6+cXxr
	 TCqkuAyIcHLBSbYHdMbj7WfTzLpliVOR04Glf6ZmNY0Gz1I2jmI1kL0aa76gQXisyj
	 PlE4lS1rL74EFed3ncy2433lx2noj3Y75eynUq55TzqFgtUYBRVviSa1E7HJeo/c1A
	 BWngPFnoKYCk3GBRdBZdCz+P+gl89rlpvDqIOIadc8QKDAJVhP4PBtF51OUur7sVpZ
	 9o8UTWtmKbcK6QRl/JjWEIWTHvMZbIHCO8W7M/F8OirtkL1MnOjGKcHqF9OuDF9czs
	 3pk/U6/OvM8NA==
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
Subject: [PATCH v2 35/35] KVM: arm64: Extend pKVM page ownership selftests to cover guest hvcs
Date: Mon, 19 Jan 2026 12:46:28 +0000
Message-ID: <20260119124629.2563-36-will@kernel.org>
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

Now that the guest can share and unshare memory with the host using
hypercalls, extend the pKVM page ownership selftest to exercise these
new transitions.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 30 +++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index a7d880701933..2a75b5649289 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1820,11 +1820,41 @@ void pkvm_ownership_selftest(void *base)
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
2.52.0.457.g6b5491de43-goog

