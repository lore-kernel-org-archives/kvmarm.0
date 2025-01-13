Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B478F1FF7B6
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 18:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736793332; cv=none; b=LRrgqkOKCBeP5Yy88TEagLeYzse6GIqk1Q3WgbyTH3l6Q0sglWdj6Yd3cSw1cSNsxmVr1BfGtAjQa0JRlbfdLaCEbM2rSwU1sg3+7kBxEbfdAZSngm+kNNnxWdAFrjx5r1BT81an4LVbNArkL8vpzS5oEgeVkGcrBF+UvTS5y3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736793332; c=relaxed/simple;
	bh=FxSEF13doFBA5tcFBO38sDSI4idMSRIXn0Z6Kg1HPZA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YkaEjoOwCro0EZk8PuDevM14ND+w95JnV97d6GH/ctGwYrftfP3eoy7uOGDuaUHFy+oCr5pB+u7DlKyaEiWkB7hMsfYaAGCNMw0hbKDVx6bTTVU2QI1Fl5GsjY6XDcE0K3MpTSSpOwVrlqM9PRE+O9deICBHhPImhi54TvuYJSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nTgnG9QD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nTgnG9QD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9694BC4CEE7;
	Mon, 13 Jan 2025 18:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736793332;
	bh=FxSEF13doFBA5tcFBO38sDSI4idMSRIXn0Z6Kg1HPZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTgnG9QD5vnDKxODxCoH7fbFNQeLf0nb3kMJ8hz+5cNtS8XIB9gQizK+GgU9E1nSU
	 jYSc7vKxma5FnzO4uSqb7scNlsDiiog2iHA2jkmy1LyHAvAd9sJ/HdFWKqZI/1qHBN
	 3tOEsGv9MUh1bZmN8jn14lh6Ioj/ZjN2gy2lO+C/HhB+87Rnjb3L44qzqIOmqGfnh0
	 1vn8hTMuaRtZ2dbBQWuRJoXbtit0DHZ2y7XX4516IZky+hncBirh2iAUhVfwF5QGAj
	 2I7aLRLVYq5ZONszt6SqPeYwORq+eR+Qjc7vM3+eJg/BcqmOjenE+qxDl1qsypu2bC
	 +A00iNnAxbvFw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tXPHe-00BjrF-M5;
	Mon, 13 Jan 2025 18:35:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [RFC PATCH 3/4] KVM: arm64: Don't use __vcpu_sys_reg() to get the address of a sysreg
Date: Mon, 13 Jan 2025 18:35:23 +0000
Message-Id: <20250113183524.1378778-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250113183524.1378778-1-maz@kernel.org>
References: <20250113183524.1378778-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We are about to prevent the use of __vcpu_sys_reg() as a lvalue,
and getting the address of a rvalue is not a thing.

Update the couple of places where we do this to use the __ctxt_sys_reg()
accessor, which return the address of a register.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 4 ++--
 arch/arm64/kvm/fpsimd.c     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index f404690a3ab4f..0e29958e20187 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -774,7 +774,7 @@ static void kvm_timer_vcpu_load_nested_switch(struct kvm_vcpu *vcpu,
 			if (vcpu_el2_e2h_is_set(vcpu))
 				offs->vcpu_offset = NULL;
 			else
-				offs->vcpu_offset = &__vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+				offs->vcpu_offset = __ctxt_sys_reg(&vcpu->arch.ctxt, CNTVOFF_EL2);
 		}
 	}
 }
@@ -1065,7 +1065,7 @@ void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	if (vcpu_has_nv(vcpu)) {
 		struct arch_timer_offset *offs = &vcpu_vtimer(vcpu)->offset;
 
-		offs->vcpu_offset = &__vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+		offs->vcpu_offset = __ctxt_sys_reg(&vcpu->arch.ctxt, CNTVOFF_EL2);
 		offs->vm_offset = &vcpu->kvm->arch.timer_data.poffset;
 	}
 
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 76bde6f489fbc..686ea04cc3497 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -135,8 +135,8 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 		fp_state.sve_state = vcpu->arch.sve_state;
 		fp_state.sve_vl = vcpu->arch.sve_max_vl;
 		fp_state.sme_state = NULL;
-		fp_state.svcr = &__vcpu_sys_reg(vcpu, SVCR);
-		fp_state.fpmr = &__vcpu_sys_reg(vcpu, FPMR);
+		fp_state.svcr = __ctxt_sys_reg(&vcpu->arch.ctxt, SVCR);
+		fp_state.fpmr = __ctxt_sys_reg(&vcpu->arch.ctxt, FPMR);
 		fp_state.fp_type = &vcpu->arch.fp_type;
 
 		if (vcpu_has_sve(vcpu))
-- 
2.39.2

