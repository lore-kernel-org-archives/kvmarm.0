Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D3037B03F
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 11:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776254181; cv=none; b=UKfdUQsQXWMhmFT4glJ8LpYJttGiUsfSvuHnp6JZDdcvyb4au4qrX+fVFE7kuuAr2UVG2VGVatY6b1zE2MF0nFK0LCskwMY8CGghD2s9fLrA0oYDUMhmndti28ZMBUBtn0P9Ch9JUU5URlu5Zyds+NJF6kteE/EoYwb95IcKZLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776254181; c=relaxed/simple;
	bh=5uepsjQHzt2SBVAjdXEaX2voIvkanpfVMA5y+kwwmag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAhLVZb/W46EMObKu5P9BQRr7tDIfcXjBy4oiwRPMMDEUXryNv8Fi/tpu8YkZ80R7EhDI0zOtfsX5OVSwR/4mtUTnSMr47h8AfyHRkegFpN3TEzjaboo3yk0m2eY1LGwfueYqqk8lOCkuQpDBTvpyEm6DUtPcyjJKt8B43vFzTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F9Wo106P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9Wo106P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997C7C4AF09;
	Wed, 15 Apr 2026 11:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776254181;
	bh=5uepsjQHzt2SBVAjdXEaX2voIvkanpfVMA5y+kwwmag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9Wo106PfKVgUvFy7csC1ipd85bVBtyzUSat0TQLb8XaTTsRUq6FojJ/9oa6cy5K2
	 tKTqdX0FaaY47SEFlAa7AcUuHjKgPSDjDsfUUXnosfwLEf7sZVuZRkyUHnoSsaIzEi
	 77P8nrTEyyicVHu6VuyFa6zJIGvgcfnRqyCHURvpELH4JuVj4TvaELnNcyeh6XO8mO
	 bueM5EMRa2NmX1fXbKjaLl8K9jWBeJZnIUbAk2BFhoZvEBFfTNpF5D+EErH+7gDJVh
	 WSAOReLgJsLOpqS25bh7BBSVf0xp935gx6sdMdM3n723FO6vI2SJzmEZqUCEAR05jU
	 AvhC/tANWnesw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wCyqx-0000000Bqsi-2NiD;
	Wed, 15 Apr 2026 11:56:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 02/18] KVM: arm64: vgic-v5: Move PPI caps into kvm_vgic_global_state
Date: Wed, 15 Apr 2026 12:55:43 +0100
Message-ID: <20260415115559.2227718-3-maz@kernel.org>
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

Constant vgic properties are usually kept in kvm_vgic_global_state,
but the vgic-v5 code does its own thing.

Move the ppi_caps data into the global structure, which has the
modest additional advantage of making it ro_after_init.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v5.c |  2 +-
 include/kvm/arm_vgic.h        | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index c0d36658ffe74..7c146fccc9689 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -10,7 +10,7 @@
 
 #include "vgic.h"
 
-static struct vgic_v5_ppi_caps ppi_caps;
+#define ppi_caps	kvm_vgic_global_state.vgic_v5_ppi_caps
 
 /*
  * Not all PPIs are guaranteed to be implemented for GICv5. Deterermine which
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 1388dc6028a9a..ea793479ab254 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -177,6 +177,11 @@ struct vgic_global {
 	bool			has_gcie_v3_compat;
 
 	u32			ich_vtr_el2;
+
+	/* GICv5 PPI capabilities */
+	struct {
+		DECLARE_BITMAP(impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+	} vgic_v5_ppi_caps;
 };
 
 extern struct vgic_global kvm_vgic_global_state;
@@ -492,11 +497,6 @@ struct vgic_v5_cpu_if {
 	struct gicv5_vpe gicv5_vpe;
 };
 
-/* What PPI capabilities does a GICv5 host have */
-struct vgic_v5_ppi_caps {
-	DECLARE_BITMAP(impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
-};
-
 struct vgic_cpu {
 	/* CPU vif control registers for world switch */
 	union {
-- 
2.47.3

