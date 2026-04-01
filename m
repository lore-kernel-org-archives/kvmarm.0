Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C9D38B158;
	Wed,  1 Apr 2026 10:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039791; cv=none; b=L/gTdRYdzSPuqRFtOb7tJDsswfQCXV9cev06bLS64SfJ2i1c4WvIVfOpdqMUaKoK+lXXoe6C2IUucaDavqHarvSt/FGSovSAv2y3ByeMczxyQJjxsLj537EtHMr5W8xex25CXGEbdvv2y2759C0BJF+PsUe2tIV0IPfg7m1KUt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039791; c=relaxed/simple;
	bh=9SSNf2eTb88mADUo0OsqGQAQIhImdgzxoY2EMuClaX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phxM3+JJVDFKkbISW+YBGozFuMUXFOtxU2B6mMRajJ1tq3zNo+Wtlj/r7Vc3XVLjADwfkXvZw0ILMX68+Xlmw/dEI6E0G9NhPYDZIUShWUNbtA2SsXV71lE3w+ygvmlu8ebXeqAPo1Nr2bzOdzES0D3Vl5oxneep14cIVEeIcJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XYJitCaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XYJitCaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A202CC2BCB2;
	Wed,  1 Apr 2026 10:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775039791;
	bh=9SSNf2eTb88mADUo0OsqGQAQIhImdgzxoY2EMuClaX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYJitCajkUzG0xP5mvm+XDaqcV639Mxf5q85t9u5hKr8uC72VEtDCN/TNm1FqkmXp
	 Iq2PmMb7Yf6zRhiLD7s72nzFO6iO0imBr5quTOv2ggl51DrR34JgdJ20Z+34kigRkH
	 ILXZ2ZkrxoUv5lvOGuNIIQjix6datJaJmzEZQLF5P4856F+kL0thCtljj2ij5M2cpq
	 l5jFLfXtaMF2EfyO8fPLEuBiiMbCmOZJTkbhjmghH4S6WMfSBq1yybu7vOqTMWnVZu
	 JrarA1KjmB0L6jBqmlJDrUKdcDnyq9EVGY6EaqlFBmiR+J31vN8F+YLduWYP00PJ6m
	 pKaXi8oZP215Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7sw1-00000007oRQ-2jBx;
	Wed, 01 Apr 2026 10:36:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 02/16] KVM: arm64: Don't skip per-vcpu NV initialisation
Date: Wed,  1 Apr 2026 11:35:57 +0100
Message-ID: <20260401103611.357092-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103611.357092-1-maz@kernel.org>
References: <20260401103611.357092-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Some GICv5-related rework have resulted in the NV sanitisation of
registers being skipped for secondary vcpus, which is a pretty bad
idea.

Hoist the NV init early so that it is always executed.

Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Fixes: cbd8c958be54a ("KVM: arm64: Return early from kvm_finalize_sys_regs() if guest has run")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e1001544d4f40..18e2d2fccedb8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5772,6 +5772,12 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
 
 	guard(mutex)(&kvm->arch.config_lock);
 
+	if (vcpu_has_nv(vcpu)) {
+		int ret = kvm_init_nv_sysregs(vcpu);
+		if (ret)
+			return ret;
+	}
+
 	if (kvm_vm_has_ran_once(kvm))
 		return 0;
 
@@ -5820,12 +5826,6 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
 		kvm_vgic_finalize_idregs(kvm);
 	}
 
-	if (vcpu_has_nv(vcpu)) {
-		int ret = kvm_init_nv_sysregs(vcpu);
-		if (ret)
-			return ret;
-	}
-
 	return 0;
 }
 
-- 
2.47.3

