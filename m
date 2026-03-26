Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11864035CD;
	Thu, 26 Mar 2026 15:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539336; cv=none; b=LnedolcOdHm7yuDYVRb3sz/KVrTS/n2GhtBBoaCXEVHsgOAJWw5pONEsdImuxwbDgaCA8dzN31NwxO+2HzZrFCfhWriywvB9FftrdAwFFdRpTU8dadPg7MKNy+u+pzTcEMAykCaTdT1wMQFKGZnVgrgygASvfPhkBvC89Fuxx0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539336; c=relaxed/simple;
	bh=CRKbEfZ640ydmcu//sv1gFU5INDkhE46iAfYl1MgcF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2BzJIh37SMvphiBmXCpKm4a14utX+P+KELICoMYmBJ6PEOJ4ehSe7jeMPpW9Jt08wMZeH3oeZyyMZ1bNp2HWLY5L5H5lYAY4uM5s9Mildpr5DR6pf+54aDcFv01gYRrgGnIYfbS1MQ/vpZwUho5chIkepNFktQiIArkSULavUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8rVpchG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8rVpchG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88DEC116C6;
	Thu, 26 Mar 2026 15:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539336;
	bh=CRKbEfZ640ydmcu//sv1gFU5INDkhE46iAfYl1MgcF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8rVpchGwIjTieyIvgQKJFxHWnjEq2rvcxYSk/P9V9UVjiIa3op5jPp7AM13iiW+l
	 bJKtP1xOJ6CVBha9ulfypthUY2nxniMXP4CYW4G3Tm+++epYoRXtpw4s/m/PU951gf
	 Rf7lveLssaKTRaohN1sHnhjTt7ASgkSv1rxwk2unDvF+nkMbLmmh4WGhkKufKmvfXc
	 4y08cglxTUjeXnIgWODPDn4bXq0XstfEh9lIkRxkBUbLU7KvitUY5ZJkApxO8e7Njt
	 BDxtb69eBxH/wdqYUVfrBwunX8AbLsiuptuAa1Xb3CxzqKkWZQMnukwzaAmSLaJ8K2
	 lp8zR+qOITR9g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w5mkA-000000060II-2hXR;
	Thu, 26 Mar 2026 15:35:34 +0000
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
Subject: [PATCH 02/15] KVM: arm64: Don't skip per-vcpu NV initialisation
Date: Thu, 26 Mar 2026 15:35:17 +0000
Message-ID: <20260326153530.3981879-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326153530.3981879-1-maz@kernel.org>
References: <20260326153530.3981879-1-maz@kernel.org>
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

