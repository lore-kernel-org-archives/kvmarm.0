Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1467400DE1
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 17:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653691; cv=none; b=D1kMUFgCq7P+Cp8molZ/qzSgGI/Pgygrg7hkAYxJatGsYTxc3SO/5be0Z7Z7gEC2pzJlDfYu0jrAyBtr1DuXc0huddttQ7H5ztCnVczsFoFHWEzRgvEDjsKVQHqjzPYlTAhJEF/81iES/Iwym4pk4vcjMoICUETmv2XSQr4NzvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653691; c=relaxed/simple;
	bh=eYcIF21J+K5SbsOaXx1CrPyDv5Zop5SlLfsKYNv6pRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNryO4SnOp6nQAgVAqlBPJg/KomHlValpPVuFhYWgJ8fWVxxBIYuZ9xYH0QpUNUytIoG7RYOqy8KhvpXSPo7SajOe5+k6zE8rSdJXincn5IPHF/4T054Hi9OMCihKFppyAtLvih8ya6uLLaoi+M86PZPxeiUCAhx2F2M8FvafH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gfov7jph; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gfov7jph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549841F000E9;
	Tue, 21 Jul 2026 17:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784653686;
	bh=hQNMJbiWYGixZ4+KVfGNBt46fUl3S7AjtHgErLnAUdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gfov7jphQSMTyEW4va5COOjgylfKumt+RH1tOylrRBV5qsRJgoXscd12OByyU4myI
	 cUUyH5qQtmMKK+JBselUe7P5h8tqyh2jhCrxq9b6aEAsD9qHfWbl7e02doDFvX3Apa
	 e1go+4j4ki53R0iNCROZG41xNPW+Ln0A9uIdB2InzuY1F4/V2t+cjsclnqu1AkAO2o
	 DPmm1paGcVqBjdRiODAAOzY8pF1R8KRXnOf+UMg9ZhHzutZ0pLvZOhrJK6O1YLTIQy
	 v0sk/CAKiK3DP4VXlmcJ1Ym1jinX1CdYkCppUXXosuHGPRoBAhTTqD/L1TyWD3LvDj
	 P2hBGoVIMtnAg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmDwq-00000007J9p-1hbM;
	Tue, 21 Jul 2026 17:08:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 1/6] KVM: arm64: vgic-v3: Make vtr_to_* helpers use architectural field symbols
Date: Tue, 21 Jul 2026 18:07:49 +0100
Message-ID: <20260721170754.3150521-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260721170754.3150521-1-maz@kernel.org>
References: <20260721170754.3150521-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

vgic-v3-sr.c still contains some hardcoded constants for some of
the ICH)VTR_EL2 fields. Bring them into the modern world by using
the named symbols from the sysreg file.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index c4d2f1feea8b6..8da7a40ced58a 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -16,9 +16,9 @@
 
 #include "../../vgic/vgic.h"
 
-#define vtr_to_max_lr_idx(v)		((v) & 0xf)
-#define vtr_to_nr_pre_bits(v)		((((u32)(v) >> 26) & 7) + 1)
-#define vtr_to_nr_apr_regs(v)		(1 << (vtr_to_nr_pre_bits(v) - 5))
+#define vtr_to_max_lr_idx(v)		FIELD_GET(ICH_VTR_EL2_ListRegs, (v))
+#define vtr_to_nr_pre_bits(v)		(FIELD_GET(ICH_VTR_EL2_PREbits, (v)) + 1)
+#define vtr_to_nr_apr_regs(v)		BIT(vtr_to_nr_pre_bits(v) - 5)
 
 u64 __gic_v3_get_lr(unsigned int lr)
 {
-- 
2.47.3

