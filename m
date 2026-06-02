Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA933B9952
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 23:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780444497; cv=none; b=fYNLP8bGINtKIAqlsVHnLzPL0VX77ut5WNHhwE7EnL6dBqF1ELuOB+hByp6Toj+y572aExnRTlAXGlS9Vomj7AY5t++SkMHrf4SLr6hInshMVuULaxXehCRE2XECDQyFSZrvhOnElguj2V3VzwSv81m0oFqlNvj50jJk1qo4nA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780444497; c=relaxed/simple;
	bh=WWhn+pmFnmA5yPerDm8Ryn6rnmfbCWaXJymFsYlcMUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crH1G2zW/BEvz6PEF1vzipRimm6XcPs0gA3/WVV3B3a5VDOTcxWiAIBl5JUWZxWNGsdYechF9vaqW0YV6D+QuSd0Lz9UBE5z9ngv2z59xgIH6h0fO53PWpW/Q4a2UjnUx1Uro7V9KB7il0FWNhxnkfAUY8393OQsb2t3Ils2Ueg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VtKISApO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VtKISApO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD211F0089E;
	Tue,  2 Jun 2026 23:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780444496;
	bh=A3df6SR+WioVdJCJs9s1b+4iaevzTMKXRYjCZ41Lg0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VtKISApONllKzzfE//uzCZlHUFXge49yl1XP9TUD8KKNBHQLgIJ9cyT7OfY/xugd5
	 AvCS2LjIFcVVhDKuuF2QFTDgYh4Np8I31sdhP8XN2BkwDq4ntW0muJY97NGGkA18Z9
	 l8qFQ32fXwBCLtAXdDVRolg7huy5ETtdILJcmXgVnAuJ8pqwBeIEyDXBFwonffpSId
	 Bvp9rK8R98n8Fx/0Wv3DZ3DM+yZsKT6Cb9j5NQkWdhP03SmltA6JBgDCEsTfK1OCy1
	 Zse9pHw0QQx04Fi0WjjGYCDBCp3G2T1HiZT6Npl8yPqtje706T4H/Icu4r05mDMZF3
	 HPblPZeJjDrJw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 4/5] KVM: arm64: Restart instruction upon race in __kvm_at_s12()
Date: Tue,  2 Jun 2026 16:54:49 -0700
Message-ID: <20260602235450.103057-5-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260602235450.103057-1-oupton@kernel.org>
References: <20260602235450.103057-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__kvm_at_s*() are expected to return -EAGAIN if the page table walk
raced with a concurrent update to a page table descriptor, which is
interpreted as a signal to restart the trapping instruction.

While this mostly works, __kvm_at_s12() silently eats the return from
__kvm_at_s1e01() and consumes an uninitialized PAR value. Propagate the
nonzero return instead.

Fixes: 92c6443222ca ("KVM: arm64: Propagate PTW errors up to AT emulation")
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/at.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 119a603e636e..6cc5892023dd 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1557,7 +1557,10 @@ int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		return 0;
 	}
 
-	__kvm_at_s1e01(vcpu, op, vaddr);
+	ret = __kvm_at_s1e01(vcpu, op, vaddr);
+	if (ret)
+		return ret;
+
 	par = vcpu_read_sys_reg(vcpu, PAR_EL1);
 	if (par & SYS_PAR_EL1_F)
 		return 0;
-- 
2.47.3

