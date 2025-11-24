Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25CA2D2493
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 19:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010920; cv=none; b=NKkc0/64Myar/Fa5bwgG4C+fm8YWHTfVlO9JUR1GUhjVAV4+z4m7pq6CfaWu4wt3FRhbsiIPuY6n3UwvVSobvY27HTIHH3EP2dKpKRSI5St8rDdPJCPv5M16H+O9k1Lz2OhnlrUN3WA0OKXz59vobE00gks3b8TzyMHVmptT+6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010920; c=relaxed/simple;
	bh=FRqgu+EFqz02ePtaknEcKDASxY5EBt03ZV5dBoVUqX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcOtST9LWrgTaxEWvcuwQJarp108Y4dHgCabwO8uuetY1lFVRHGr5DoddX8XXSmU24VRU3p48fDS5kDiYd5+WrKxJV2M1s1T32S9uHTJgpm9Z9Sq3P8PDZevuqd34p3mAhoTgQpMAZ/jcXqZ7vHy2dwaNpe4FG1fTokXxBSkyOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TlYnQQjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TlYnQQjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCB3C19424;
	Mon, 24 Nov 2025 19:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764010920;
	bh=FRqgu+EFqz02ePtaknEcKDASxY5EBt03ZV5dBoVUqX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlYnQQjKtJ/1lAjEvcd0oB/U0vdaD0BPHgZEBnasgEh+Tqfi50XjgU+HXTcln0CE9
	 fCuhcmSJgKtzvssGJsN/9waCucsjc6QH5qlzRdx2Gev5XUQcOrkqvFAqg7vQchagEv
	 6bEXWnn5/bbI+Zf4GhYYNINrzzGn6nVUG+f4IKcpUoGVLuTuZLQH3/y0BFr352oavj
	 vx1a5reoSmIZ1SlAM/xdUyf83kkWGXUQOYnJHqwjQ+Tn01CwnYdrJG+phvlGtAQmG4
	 x0iLzs7z8ITI+lX1PuYgnwCsouZd2pBPbkIh1IMcn+8Wyf6H72QYUV4aSdS58vE61p
	 +5L6eGjYovfnw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 05/15] KVM: arm64: nv: Advertise support for FEAT_XNX
Date: Mon, 24 Nov 2025 11:01:47 -0800
Message-ID: <20251124190158.177318-6-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251124190158.177318-1-oupton@kernel.org>
References: <20251124190158.177318-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Everything is in place to support FEAT_XNX, advertise support.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 92b2a69f0b89..08839a320a45 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1559,7 +1559,6 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		val &= ~(ID_AA64MMFR1_EL1_CMOW		|
 			 ID_AA64MMFR1_EL1_nTLBPA	|
 			 ID_AA64MMFR1_EL1_ETS		|
-			 ID_AA64MMFR1_EL1_XNX		|
 			 ID_AA64MMFR1_EL1_HAFDBS);
 		/* FEAT_E2H0 implies no VHE */
 		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features))
-- 
2.47.3

