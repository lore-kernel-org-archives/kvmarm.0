Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D245C6E2AC
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 20:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647548; cv=none; b=SCUAZ6HsOJNjDcqkzsalX4hgcirR2Uhrd9kqjpCBGzQE5PJzpDBwXRXyl//gLDDCtjZnAc80F+g5Y6zTfggPQAWFKBANHyzCMhW+T0tQR9quukGUfHR3axwh+q3LdphEZneRqqEYWppcWlT8f9DbChIvEOpWOBZkXolNwSk3Jd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647548; c=relaxed/simple;
	bh=e8O8ZVOLKTFpznJo1DX6Qs4uI6A5fN19r7dzF8iVEH8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=leHJQ2poJ6PQPRPf3lIW53dhiX3SUdCaOeVJFDmm+8cKNBPRRRfboP/F8e6vdBlg3RSOJ6aCN++VC624VUDiwM+aFkx9ohlQ+6eGBtEdRen76ZlTh1hGBqp+xzF7v4z5xyqQdAZI5Vvn/NjZQNn6KvKPJVFxBti6VX2ceg9ST6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qt1eKVmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qt1eKVmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45702C43609;
	Tue, 30 Jan 2024 20:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706647548;
	bh=e8O8ZVOLKTFpznJo1DX6Qs4uI6A5fN19r7dzF8iVEH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qt1eKVmWX4ftMgU39GgF6WlFeDe8z8IP8hotDYbYqxUs81gwPuK1btMfPnrBP+MD4
	 h5BG+nBTJtFzbenjzFF7F3MGvEQOPdEoxzwkYUujMqeHq0tRM10h0mEgwgU1FrjvFY
	 5mDJ1ASCeShblE5knBz/OiG8IjKnEjZEZ48TcIZSm1PTrNIff8Y6os1TVpkWBpuOpf
	 uPEmnFtCJXOn3vkgxaf553Dt/J0i4DcjSFHN1U786W4/RxLgvdW1NzwseFwO3J4+IJ
	 uvRnsUc1dGw0Uria29bmFRJ3z9iDYvxO8mPpUPCh1BapzIxvLLhgg6JMQkKFdaVaEX
	 VrJjNddN7mMTQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rUuzK-00GNsE-Cd;
	Tue, 30 Jan 2024 20:45:46 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 08/25] KVM: arm64: Unify HDFG[WR]TR_GROUP FGT identifiers
Date: Tue, 30 Jan 2024 20:45:15 +0000
Message-Id: <20240130204533.693853-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240130204533.693853-1-maz@kernel.org>
References: <20240130204533.693853-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

There is no reason to have separate FGT group identifiers for
the debug fine grain trapping. The sole requirement is to provide
the *names* so that the SR_FGF() macro can do its magic of picking
the correct bit definition.

So let's alias HDFGWTR_GROUP and HDFGRTR_GROUP.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 7a4a886adb9d..8a1cfcf553a2 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1010,7 +1010,7 @@ enum fgt_group_id {
 	__NO_FGT_GROUP__,
 	HFGxTR_GROUP,
 	HDFGRTR_GROUP,
-	HDFGWTR_GROUP,
+	HDFGWTR_GROUP = HDFGRTR_GROUP,
 	HFGITR_GROUP,
 	HAFGRTR_GROUP,
 
@@ -1938,7 +1938,6 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 		break;
 
 	case HDFGRTR_GROUP:
-	case HDFGWTR_GROUP:
 		if (is_read)
 			val = __vcpu_sys_reg(vcpu, HDFGRTR_EL2);
 		else
-- 
2.39.2

