Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D46F37BE8F
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 11:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776254183; cv=none; b=Y6FKCqqn92MWayUkWFBO/jJtCVzXZr95RdUjwqwZIWqLhGrqYzp8l4D4CxVvvcYRtFKfbMnZOFnWfWIvpekf/cyjLMTQPSWKA6i0hg0fLaq4CP+eMXXnfaFo5xLelIGZ0+FpUDVDFehBDCEakmLwZq3xcKn2YEHuFVaSKzO9lL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776254183; c=relaxed/simple;
	bh=Zp5PG6ea4JcntK4ndrBEZbSawNvwNwKG+2HfhGE8uL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSa/b4kP/OfiRCXriIp/iKyNzLKaHDgEBlpyJR5pgGdH6zGeNpJD874KpI5tfBFjs9uMnLlNdtVsl0JCQzpeHifvxkXKBqhTyzJmCPEGbpHw8kIN7Bd53hMIDu1+x3zYtKbW4qB9VomVF+pFoLZ6zSewiHVPTfqhJwE6j2AeCXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AWWirv+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AWWirv+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3F1C2BCB8;
	Wed, 15 Apr 2026 11:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776254182;
	bh=Zp5PG6ea4JcntK4ndrBEZbSawNvwNwKG+2HfhGE8uL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWWirv+1VMXuVhJhLxle6sNBMFAGIsDXWziy9rH6aIroDoRksQGsFKFi4tx4tBT/X
	 SrZHaxPEBxFB77bpZM6ysKp5j0Ya1QuVjfMcecYAGMPuRtFu3SVa0G99eT0suHvOQv
	 +JBg+8/XbWGETmmvJYErQcdecnVPirYXHIIWyPsDTyB7LgmH3pHlP/FsU07JeCJg6O
	 Migeprda5B7A/69xnOGMBT0LjJCPY9lAgH7fcj16cVKmCW0Xzfyph8o6HrvKvlTMjL
	 v9YRzPVnx8A9XEUMiwMaYFrwmvNZeO1gFN6B+sCjWAJa3KyuUL3ZeG4knZk5IwBxTg
	 e9gm7NrM8JwHw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wCyqz-0000000Bqsi-0XlD;
	Wed, 15 Apr 2026 11:56:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 10/18] KVM: arm64: vgic-v5: Add missing trap handing for NV triage
Date: Wed, 15 Apr 2026 12:55:51 +0100
Message-ID: <20260415115559.2227718-11-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415115559.2227718-1-maz@kernel.org>
References: <20260415115559.2227718-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Sascha Bischoff <sascha.bischoff@arm.com>

As things stand, there is no support for Nested Virt with GICv5 guests
yet. However, this is coming and therefore we need to be able to
correctly triage the traps when running with NV.

Add the missing fgtreg lookups required for that to
triage_sysreg_trap(). These are specific to the FGT regs added as part
of GICv5:
   * ICH_HFGRTR_EL2
   * ICH_HFGWTR_EL2
   * ICH_HFGITR_EL2

Fixes: 9d6d9514c08f "(KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index dba7ced74ca5e..a4eb36b4c4421 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2631,6 +2631,14 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 		fgtreg = HFGITR2_EL2;
 		break;
 
+	case ICH_HFGRTR_GROUP:
+		fgtreg = is_read ? ICH_HFGRTR_EL2 : ICH_HFGWTR_EL2;
+		break;
+
+	case ICH_HFGITR_GROUP:
+		fgtreg = ICH_HFGITR_EL2;
+		break;
+
 	default:
 		/* Something is really wrong, bail out */
 		WARN_ONCE(1, "Bad FGT group (encoding %08x, config %016llx)\n",
-- 
2.47.3

