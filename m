Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DDB47143C;
	Wed, 22 Jul 2026 07:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706180; cv=none; b=pae4w2rQ6+FCjNtcAf03ur9yhV4aF8q98U2jSRryebKUH0lLtogJ0sfDl3WGnpJna40yfvwL4KJ9LiFXXZzlc8ekfyolRzW9eGKqsmJrn0lhVbd/ylAS/56MlSwPGAn4wq9Ov4zYF8E5WcisLZ7rlNUPwO6/Wm+XUYZYQ31olcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706180; c=relaxed/simple;
	bh=9NbUIFOuQGhPmdmTQ518VoxJ7RJNQ2KTV36YNQscAVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uoz20NtCjzIOROabRKtwixUNcQ31pSEGWKMzF6yZfaS9B62y2ujPnPAuZccYsdpRxZj8w7GwcO1JQ4q70TvYmBzc3VfAOfwCpZ5pQKSFolaSoVSo+pXE6iPK/MR59aqgHMMGfbHByjcuqcZa4ible22LlGyH9hxRYtU3wFteNkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PAmcTda1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PAmcTda1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6068E1F000E9;
	Wed, 22 Jul 2026 07:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706178;
	bh=07dRYKXgRyU3x0X5on17tlJ7LESqf7TzRfpEcaCKSac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PAmcTda1WQ9W/sc+o91nL9LtHai/Dh4NdHfL4JRHGAXw5ZXq0eJtFXcjPRJUSPB3w
	 TztnxH7GzFJtyC+XRw3XAUCrpf/NRLaAYHnHN1jXFAjYuEHKp0vZ0C+5ejmiw55di2
	 OQY+t/E9hW+u5ARKb4wZsbzuOoFRPdA8e4OGfQaYEYyOvbkQWViI6M/vC+OGieXTMJ
	 2LAGhBvdDi5tmVlLLbbBxaiZ97A2IBBruX675/NO4T1TP3NcFgPl79Xyvdjt53Co6c
	 Y0rXEeNZLJWR4WU9ishl8/7IWpnTYfw/yZVOXwjOr2AiJoIGdg/GwNuK6l1W9i94eI
	 3uHGsjvxgXCwA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbU-00000007VfN-2pd7;
	Wed, 22 Jul 2026 07:42:56 +0000
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
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 11/28] KVM: arm64: Expose FEAT_NV2p1 to NV guests
Date: Wed, 22 Jul 2026 08:42:17 +0100
Message-ID: <20260722074234.3330999-12-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722074234.3330999-1-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since NV2p1 is reducing the number of traps, it is valuable to expose
it to NV guests. Do so.

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

