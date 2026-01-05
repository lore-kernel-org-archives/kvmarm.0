Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C096C302CDE
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628283; cv=none; b=ZsCLxs+aEoL730ico7HSeK0wHEtcNARjsp+IiMuJ4aIKbZ8F5thHsch1kHZZ4cugJivQ2rt7O58SQoFz3GEAvdLoT0eBIrLuwYxEgtcf01iFdVvPEm7TOXKJGw/weYIwoPK4Yqt40VQymYhVSXqcTb94oQ7RHbO2AtzO3ysOuqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628283; c=relaxed/simple;
	bh=/V5dGEakqoFT9LVTg+cj6j+kFWdHnlUpnUyXyuEtntQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBuz4jCsLU/KwGeb0txVNWp9mmJR/kmFg5dr443DyEHCFcB0VkSFypd6XXJi98fLB5JvsUqdP8Lk4/u6Iwg3/EzsM3v766Uh2fXPyzdNxCziC9XnhuEP6JMGYh4OOq2p8wLgg68l0oH3kZaPiVaJIex+Dlu7Ka5xV6TcgjUdadQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dGk7c90z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dGk7c90z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4D5C116D0;
	Mon,  5 Jan 2026 15:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628283;
	bh=/V5dGEakqoFT9LVTg+cj6j+kFWdHnlUpnUyXyuEtntQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGk7c90z2HommBZ2GTtxwIiEvCqia1sAHQVDMnraEGn2/pVFpZkNVqvaDIS42nCa/
	 XkLb8DM/pfgjjTRIo3drvDOErvtMe+eK19kEiScMZuJM6iCYHRCy0rO5aTxkZVClkN
	 V7snS/mz9qTABKI2Rb3cwqDxxcKayNK1GA8OQa/5QtC5mS9OgZyC47qNJnr6RhnYP+
	 gciKe9O1gxvBJ7t5nV+AV0VTL2OPiUC2VZ2zdhx9TSEJ/FGDjhTXtYIGFgCqJp+0+e
	 yEUFDQ275AAzZG81tK2FWlYR4+vFtac7X58uv/eflfxd0kMRCW3k8Pbv7ssUwoEnAE
	 0QkaPJv6mlO8Q==
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
Subject: [PATCH 30/30] KVM: arm64: Extend pKVM page ownership selftests to cover forced reclaim
Date: Mon,  5 Jan 2026 15:49:38 +0000
Message-ID: <20260105154939.11041-31-will@kernel.org>
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

Extend the pKVM page ownership selftests to forcefully reclaim a donated
page and check that it cannot be re-donated at the same IPA.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index f59f5e24ddda..5a1bac31e253 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1776,8 +1776,20 @@ void pkvm_ownership_selftest(void *base)
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
2.52.0.351.gbe84eed79e-goog

