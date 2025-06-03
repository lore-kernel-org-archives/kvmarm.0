Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA8E268C51
	for <kvmarm@lists.linux.dev>; Tue,  3 Jun 2025 07:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748934524; cv=none; b=qgbwRRYtXUOJkEGgRzqfGG5tSK/qsKRfeKNcc0GQvEzPampH3D/oNvtzGl1+ezDBkWx2bqSOxDaj2a13WUDXc6eJttPCyZ1W5btJeeKlz66uuWij0QvPsHXJIiEGHlssksokolwd6/INT2NgaY3JbOYzqYPTzM8CWNnPkhRp4aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748934524; c=relaxed/simple;
	bh=XSlrAD6eyPaKQGafnPNm8VS+FmjidUjCnfXdHTIONEM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oUQqKsWwchLyrUxr6CrEMxPsaLyfMxGuYUK5gk/2V/dD7l74DwpqRIS4eobC7cVO6k4gqb0mQkV6Ff0GJzGg93LEtgnVRyKpLAWClt+FTPDHHf52rCkZ+niXARm6I+9B/gTMAQB8dU00/lHa6MYXZEZ9FfDk7MVxhGeBbM1Lwlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AG+D50/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AG+D50/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC85C4CEF2;
	Tue,  3 Jun 2025 07:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748934523;
	bh=XSlrAD6eyPaKQGafnPNm8VS+FmjidUjCnfXdHTIONEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AG+D50/e3WXsN6isYoc9HVo3lceMSpHFdH7bqwhbPokZqDOQXiXblLeUz0eIgixv1
	 zvUVvXo5ppBaZ/iTswyz4Kbse10q3HtnDLGYBjP0lHGuUSL5mEEqP+KuIbAUe65O69
	 rBk9mE5Vy/yxbvfsWXSIdbUqOHzHm5SmykCxMmhN05gRaIYgcHj1qCKwDvirAgVBRI
	 XZrZfu+KkLN0jJPgMRBkxhRjWwlmNcKEfsA0BSRwKoWl+baDlY2iSUWMafv+HTj/b9
	 j+kXdRAexgvYWtRk97Y8HWDHczKT4EjIOg7B+N2qlDcv2tqdhKfmeSsMniFmL7VXOr
	 g7FVvjrdvOOWQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uMLlJ-002isr-OB;
	Tue, 03 Jun 2025 08:08:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 3/4] KVM: arm64: Don't use __vcpu_sys_reg() to get the address of a sysreg
Date: Tue,  3 Jun 2025 08:08:23 +0100
Message-Id: <20250603070824.1192795-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250603070824.1192795-1-maz@kernel.org>
References: <20250603070824.1192795-1-maz@kernel.org>
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
 arch/arm64/kvm/arch_timer.c | 2 +-
 arch/arm64/kvm/fpsimd.c     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 5a67a6d4d95b7..c6b4fb4c8e08f 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1036,7 +1036,7 @@ void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	if (vcpu_has_nv(vcpu)) {
 		struct arch_timer_offset *offs = &vcpu_vtimer(vcpu)->offset;
 
-		offs->vcpu_offset = &__vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+		offs->vcpu_offset = __ctxt_sys_reg(&vcpu->arch.ctxt, CNTVOFF_EL2);
 		offs->vm_offset = &vcpu->kvm->arch.timer_data.poffset;
 	}
 
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 7f6e43d256915..8f6c8f57c6b9c 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -103,8 +103,8 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
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

