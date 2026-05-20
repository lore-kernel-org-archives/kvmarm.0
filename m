Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84BB3BF66D
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 09:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268816; cv=none; b=k7cIGBMQTX8b6dDwT3Bctk6GxMq8LIstkDFzYbuigRn5fUHUDd661UxNbqbMR7JgFTydBlyHXzaRGlArG36MQWoZqVzbkoPxUWq0o8YJdIo35jtZ1VfkT4Ocy5BauBhtIn9Sj2M8kraKjfV2hhMI9nNIXXctlG85IFX/PNPvyMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268816; c=relaxed/simple;
	bh=Zp5PG6ea4JcntK4ndrBEZbSawNvwNwKG+2HfhGE8uL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqJ93lvWeQuh3HS6zS7j9o7vtllCgfV4yTOqIfW+syvzA/4xVEnNBVlYCtySUkVXH9eg641pZyC2OeTTzo6MvVTIRwPRBqbV+QzJ3jmRxo9Xz3Y5p2g7eGJ5x2+mtr/BPMLz2hUVDRXm+52Y4vRb0BtG3apRCFv0dtr8qZOrjPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNgcwIhr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNgcwIhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023C01F008A2;
	Wed, 20 May 2026 09:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268814;
	bh=pU56tLyF7UzXsTeACLNC09MWYPppBK+O1Bfll83A28E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNgcwIhrtAJxmSQDFXyYkJNK6w7IL/kyWQxmdplBXbCVN3mlKPdKQTKySsqvpPKWg
	 SoqeYvuDtbYXlTuvqG9x36UI/KRizlzr/CvToAX1hoarcl4t8C6i+5ya/DFMNqs27+
	 /K+FhqASGTOfF2526gVdLOL6XX6DUOPcQNzEE4Vp81Y2mBV2QveJXfpMjw8bLNSUbX
	 8Sael31E8YyYqXlVAmMOiWrBmEXnHMoLvDjPZnWY7S3UPjlbFZd5ttoHc95aOx35Wb
	 bilvop/qOaATG0lsCtmQftyX8Ar1RGl/FoTitWC/vSa0W4Sb2o2NzOKdYC3H5tvxLr
	 7gbu8mCM8Dwmg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPd64-00000004IaV-14Ue;
	Wed, 20 May 2026 09:20:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH v2 10/18] KVM: arm64: vgic-v5: Add missing trap handing for NV triage
Date: Wed, 20 May 2026 10:19:41 +0100
Message-ID: <20260520091949.542365-11-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520091949.542365-1-maz@kernel.org>
References: <20260520091949.542365-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
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

