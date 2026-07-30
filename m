Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59962385D99;
	Thu, 30 Jul 2026 07:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395462; cv=none; b=rRGmbMDXPY1yvjJfI4luFtJYLO9ZiHVlPA9JrpWdd4IOGHRvazZRXhHNJaAwVc/d4binrJJvYR9EvLmgvKPh2BcRoTrx7a4WSiwmn3uOW03WYvMGsr68dmFS3MHLO44zkhMLE1m7MH8nsO15z2JWACOQIz60b6/ZF9N1cWb0tmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395462; c=relaxed/simple;
	bh=vk2r7//Zvke+PE+V0iLhh0SR465pXJccTMCi4PTNI7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7EyjqDN0Hz0Du/3QRuZq1E0iOJCATaxZUncqb4vN8hx8P8BII7G14Bm9bFFFQnoT1JjojaBllL6p5NfrarmK5cPZX+nnZLEX4nZy05d0+yLY3mMpCYUYWWXW5orNW4cwSaifv8D22cWMPzsJzh00v8EoPb9J1bNzc6XSwGiktU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JVdcIrX8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JVdcIrX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714611F01558;
	Thu, 30 Jul 2026 07:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395452;
	bh=6Wkw5ZKNMjRbwNS1o7cxYnLYMeMkPTyLGWptsJzKzSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JVdcIrX8Eh9DHVwN4ZrwthhwTorvNfqjACLChcsBSqXXhJ7hKqFRg2KVhVcN22v7n
	 hG3Dxs0ERoSaT5X3lnOWR7c8AK4ylautjUJGGkmTDr39YHh6FyYqv5s7rDnHexgrOU
	 7D7O3pJV++bvBJdYHwpdd1qJJjvg+hSNttnsqUNwlprnT6VEMCpOhxHmH9neKwWyUb
	 fslduP0k+Do47rVjnSQR0mFPzGI74oIlPzNJec8CKVToE2DQRvTdRDe9JETTFXyhbC
	 RQR+TbXBaMP0IHiNEUqo8lnwdrrh/KEAPNLck62uKvRPJ0ThC7S68RdNqt+xTZ3qbg
	 Hj4GXPwDd2TYA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKuo-0000000AOpW-3Ac4;
	Thu, 30 Jul 2026 07:10:50 +0000
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
Subject: [PATCH v4 11/29] KVM: arm64: Expose FEAT_NV2p1 to NV guests
Date: Thu, 30 Jul 2026 08:10:04 +0100
Message-ID: <20260730071022.296811-12-maz@kernel.org>
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

Since NV2p1 is reducing the number of traps, it is valuable to expose
it to NV guests. Do so.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index dfb96edbdc43c..35a1c42ad3f84 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1728,7 +1728,7 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		 * You get EITHER
 		 *
 		 * - FEAT_VHE without FEAT_E2H0
-		 * - FEAT_NV limited to FEAT_NV2
+		 * - FEAT_NV limited to FEAT_NV2(p1)
 		 * - HCR_EL2.NV1 being RES0
 		 *
 		 * OR
@@ -1740,7 +1740,11 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features)) {
 			val = 0;
 		} else {
-			val = SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);
+			val &= ID_AA64MMFR4_EL1_NV_frac;
+			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
+				val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV2P1);
+			else
+				val = SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);
 			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, E2H0, NI_NV1);
 		}
 		break;
-- 
2.47.3

