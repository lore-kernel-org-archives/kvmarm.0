Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1839A3A9DB3
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721879; cv=none; b=K6v4ZWs3XRZ7uYjYBf9BKStyz+xycLFgAvty2pw99fAANErGDg7hpqAqae4C863EKbaa+PQ6mVcNdIREtATpQhYBtIyuEFzd63hRnFQG9HymE+YItKzQ/BKxwgQVVo5pKojBYNg17JB+ww049jmuo1KbRzeCrupsFkQK0bklppI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721879; c=relaxed/simple;
	bh=g/Zjk5jkRbl4Sru6ybglMk9XL7QaR20Q/om4UqiG45E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEpNoKvJ/uaYGK+eW23Rb23g17OZGYCbJIfKlaYpm2iPnMs9tAafamyYAwKOgHd/r8Vt/mfPP4o6pM2zpDqNsSLWjNalzJcoti6Zyt6HyDq+bSsp4ScS79aY98ENdMvWzQoqlPBgDMPw+3gSyP70NulFFRctxIQ7DfWnSHUVj0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FC4PWwro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FC4PWwro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56CEC19423;
	Thu,  5 Mar 2026 14:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721878;
	bh=g/Zjk5jkRbl4Sru6ybglMk9XL7QaR20Q/om4UqiG45E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FC4PWwroYFK09krMxS/0KwvZpeApYiaRGBBSKLDOusrbSEvExxom4WCxG9Cc+p8xm
	 2dgz3hReqd0jxyldbwAmSod/tx7oy47rS2SXfZm5YOp5LH+X9cs7J+fCOmLFfAduWp
	 zrrhRqjDZOvGLwhmIx8lPKdO/aBND+kD8zEvna/N1Gca3CWarRR8lnTRBSkAzXdBcR
	 MdaYacLyet65jC6OsF6SLgVfbzsnN4YxOIjmKH917ntjAUVBeMx0+dhpTYlT2B4O6l
	 fzJQJVn9DGJiq68vSxzvnuHaN6uA7wpfg4jCoxXmHAvHDVNFXeN36aJ9UDknrFA9Vn
	 CvpHdbtKurk5w==
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
Subject: [PATCH v3 08/36] KVM: arm64: Prevent unsupported memslot operations on protected VMs
Date: Thu,  5 Mar 2026 14:43:21 +0000
Message-ID: <20260305144351.17071-9-will@kernel.org>
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

Protected VMs do not support deleting or moving memslots after first
run nor do they support read-only or dirty logging.

Return -EPERM to userspace if such an operation is attempted.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 43632c69adaf..9d183df0b0ac 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2410,6 +2410,19 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	hva_t hva, reg_end;
 	int ret = 0;
 
+	if (kvm_vm_is_protected(kvm)) {
+		/* Cannot modify memslots once a pVM has run. */
+		if (pkvm_hyp_vm_is_created(kvm) &&
+		    (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
+			return -EPERM;
+		}
+
+		if (new &&
+		    new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)) {
+			return -EPERM;
+		}
+	}
+
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
 			change != KVM_MR_FLAGS_ONLY)
 		return 0;
-- 
2.53.0.473.g4a7958ca14-goog

