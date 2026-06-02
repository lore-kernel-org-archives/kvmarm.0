Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09A93F1AD9;
	Tue,  2 Jun 2026 15:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780415683; cv=none; b=FFMKJsiapW8DRnsTdyFEINZDYcTc9WFRoY97m7SN5FuXcm3jTWI2R34KX/pgYTHi0hg7wsdQJhxtHtNl6xWIrH4n6bCyLrnFuC/pnLKg8gEXhVwsp36wqnTgH3ZFwcps9axLfwJY4wWchDCOLBlI5PGDH5BOAhP/t3Ykps3NQKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780415683; c=relaxed/simple;
	bh=Hse4vyEKhmKwlzo9QKW2YumWtafAR4OKwvf/MHle4ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfPf+BbjqSfpkTMO+6blJIfI0Vqyx2spTzes6LYIxRvRS7XLjUwD+bF2wbLqoWmjnMJqvXAvXXkJ/E3jzZ/7C6xQVvIyxTE8yW6+CHUdz2N3hxEKiClpwH05cZ0E7oRDf4SYApuhvBufs4zdp93L2tnHHx3ccc4NeFB3zETCk4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jq98lp5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jq98lp5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDE51F00898;
	Tue,  2 Jun 2026 15:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780415681;
	bh=g6F5AltN2PaZJFgZ1Qy/IqUyWkgsBB7MOGVwDpftwzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jq98lp5R4Wne4GQFBsJlJ9/JUnApw+k8nJ5cFtNGtTsPRL5DdWkYymrDAAmKgzv63
	 6Z3klmZvuNuNoJ3o3S1t49kslZJ6OaX7iL8rnZ1kxR2LZAEc6MtAJ6KuWwJ6THjnsY
	 cVSEHvCnMFnyCciT8gUC+pVEtBF7gGVzkgWUD4+tMZfabg79fa5CIurvaTRBTDIJNP
	 FWQPdbquM/GIReZwwmePZsJHW1zpkFHnyQrYTIk8D+qEy28h06XjmeRAur3kjHZpgl
	 CCnrZFhNTDusRgdosMnvbMaVYqPgFAJmuLrCUznx7Rd8u1WHI7VNmQk2bAZd1hWRm+
	 pH6rCPjOdMvhg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wURRw-00000008fVv-0EHR;
	Tue, 02 Jun 2026 15:54:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/3] KVM: arm64: Key CPTR_EL2.E0POE propagation on FEAT_S1POE
Date: Tue,  2 Jun 2026 16:54:27 +0100
Message-ID: <20260602155430.2088142-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260602155430.2088142-1-maz@kernel.org>
References: <20260602155430.2088142-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We propagate CPTR_EL2.E0POE from a L1 into the L0 configuration, but
we key this on the L1 guest supporting FEAT_S2POE. This is obviously
wrong, as this bit is solely concerned with Stage-1 translation.

Fix this by making the update depend on FEAT_S1POE.

Fixes: cd931bd6093cb ("KVM: arm64: nv: Add additional trap setup for CPTR_EL2")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index bf0eb5e434274..161bb2a3e1d90 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -141,7 +141,7 @@ static inline void __activate_cptr_traps_vhe(struct kvm_vcpu *vcpu)
 	if (!(SYS_FIELD_GET(CPACR_EL1, ZEN, cptr) & BIT(0)))
 		val &= ~CPACR_EL1_ZEN;
 
-	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S2POE, IMP))
+	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1POE, IMP))
 		val |= cptr & CPACR_EL1_E0POE;
 
 	val |= cptr & CPTR_EL2_TCPAC;
-- 
2.47.3

