Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6993BAD92;
	Thu, 30 Jul 2026 07:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395472; cv=none; b=iYWo/JNQtDvv4Z9q3I4Q0JdIsYaHxGIgnzSQ+5ZM5fA1+yDgoWKxp6gebyFpPJXgXUyMG9t9qFO1VIjKBQNHaiqt0EUeWowAbNN+LFlLd87wdbl3/+8mTzh5YAHpPZWz6oqtkKoxw43zODVvdGoYsYek28FIXX5dmaazPdi5Rk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395472; c=relaxed/simple;
	bh=hXi+wHea7bpw5uwNfDtJwlx96Qo3FBx4PXLeYtECkNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVvXcpIeEs8/TO2TcSQa9WWlgo/V4Bu8JK0Ga3wjBTyqFcGqyD6hV419Qr1T580ppPgDVAjQDH1Um8eEXN9y9Gj3bhICLA7BgJNedI7mdrJOI1FEbkyssu1skANFkCtKkXkVV0EiwqizSNZc62MCIhUDf4s0I6JyaQNFA+stLAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h7LTurJq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h7LTurJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F9E1F01569;
	Thu, 30 Jul 2026 07:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395455;
	bh=FGvQNkP1l3TwbdM+M5kTh96uuQDjEKCciwByUmopZFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h7LTurJqv9b0ZPY7NJOaeijHK1lGlK0IAH3hfFk2Io964T313o5F52qcFMUKmdNIH
	 CPpAY5uSOkpjFmV/v5prCdvR5h1rf8xUcwMbEXdRMgoNY3WrJv+yjZmS4V8kkCSeEy
	 /XDh4OBNSj8ap4N4HlTgxkjxorQiy8Lz2ZZIrybHfrWFwT7MLcLF8bQh8jwIyLKL4E
	 3a3YHrGMbbckL/ZtkCbZdvk+sDKgVb324aIfc758Qul5kj22+WPiCBxekMnL7tTwxx
	 l4Xky7EgK73lhD0UjaWdo4vYLVMqg8kioid51tzvSnFx6WTyLSDA3AhEFKXYxlAWgP
	 4Nd3d6CsvVh/A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKus-0000000AOpW-12ip;
	Thu, 30 Jul 2026 07:10:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v4 27/29] KVM: arm64: Expose FEAT_NV3 to guests
Date: Thu, 30 Jul 2026 08:10:20 +0100
Message-ID: <20260730071022.296811-28-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730071022.296811-1-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com, vladimir.murzin@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Further enable FEAT_NV3 by making it visible to NV guests.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f646894fec9a9..70d605e60cfb3 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1728,7 +1728,7 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		 * You get EITHER
 		 *
 		 * - FEAT_VHE without FEAT_E2H0
-		 * - FEAT_NV limited to FEAT_NV2(p1)
+		 * - FEAT_NV limited to FEAT_NV2(p1)/NV3
 		 * - HCR_EL2.NV1 being RES0
 		 *
 		 * OR
@@ -1741,7 +1741,9 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 			val = 0;
 		} else {
 			val &= ID_AA64MMFR4_EL1_NV_frac;
-			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
+			if (cpus_have_final_cap(ARM64_HAS_NV3))
+				val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV3);
+			else if (cpus_have_final_cap(ARM64_HAS_NV2P1))
 				val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV2P1);
 			else
 				val = SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);
-- 
2.47.3

