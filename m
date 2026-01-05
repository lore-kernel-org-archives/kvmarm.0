Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5410F33711E
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628278; cv=none; b=CdOFN5ZGSbgtdNgWAUFBoz2NqjodrU2D0MJrZW1Ba6d5nmUz/+Yk6Pfp3O+zEIY9PVSAKHAHmDdXn9hOYgcBERZYnTjRhTZ9qnkoTgJFv1S0/qwUUZYXJhxTO4XTIkBPSYcYUzJIcA3yjNd+aDOjjjkEXxcWeTkpfPLcZFkFytY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628278; c=relaxed/simple;
	bh=oae1gOD9h+bRUmiV4brKcILcJgRGoexLydgjOCkXoJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdhIV/ZxHHxrGy/aqeqT773XPYgH+X89Mj3lSr/ah8W+44XV8e65Wrer2J/fT65m7lGqrdYBsjMjR/gTAUgPe+I3iTOg9qKpu9ttCcr1VCmtSkMl1VOJOvsAc37mfvtD9ExYuwVpZEZbgYGIl+ei60koEQSl1faSbGnpLKBavs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AOBfkw8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AOBfkw8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C051C116D0;
	Mon,  5 Jan 2026 15:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628277;
	bh=oae1gOD9h+bRUmiV4brKcILcJgRGoexLydgjOCkXoJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOBfkw8ozR2r3AVQ627mXmaokduhCawUQbH0a+5bfAXrix8zLSjEpoEPE07HoeAFy
	 bNSIzPIQ5w+lcroBUXi5Bvy68OBFSblepuDaSLJbMOsabjM/pywS4shYfpnJ6vQ1de
	 xLPGPDoyIzLApT5gvRLZkhIyVB/QGU8RpZ/rp47rjct1bWRCKNq2MOhNhow0+Lipgi
	 d2UsBQW0fKMsN6/xEFjBwcxWID54GiaJT0VTMaMWfaeJ9IZcP/3nIsOpyc9lYNUg2v
	 ZTlgRhP5tD8Smj7iRTPYcMb6309hD0BSgpvsPDMN+3ambGhOZncTJQB3NcU3UfQCiG
	 cl4I6YbMLO0Bw==
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
Subject: [PATCH 28/30] KVM: arm64: Extend pKVM page ownership selftests to cover guest donation
Date: Mon,  5 Jan 2026 15:49:36 +0000
Message-ID: <20260105154939.11041-29-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260105154939.11041-1-will@kernel.org>
References: <20260105154939.11041-1-will@kernel.org>
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
index c1600b88c316..a586ca922258 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1712,6 +1712,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
 
 	selftest_state.host = PKVM_PAGE_OWNED;
 	selftest_state.hyp = PKVM_NOPAGE;
@@ -1731,6 +1732,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
 
 	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
 	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
@@ -1743,6 +1745,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
 
 	hyp_unpin_shared_mem(virt, virt + size);
 	assert_page_state();
@@ -1762,6 +1765,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 
 	selftest_state.host = PKVM_PAGE_OWNED;
@@ -1778,6 +1782,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
 	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 
 	selftest_state.guest[1] = PKVM_PAGE_SHARED_BORROWED;
@@ -1791,6 +1796,23 @@ void pkvm_ownership_selftest(void *base)
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
2.52.0.351.gbe84eed79e-goog

