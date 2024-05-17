Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D334F887
	for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 13:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715951904; cv=none; b=eqQIyITUah/4IhxpJpoi+iviwd16bqhuMAWoGPNWyCKqsdXbTTX6R8T2kXpVWnHlEMiX9XDZIOTmxNHofnDdRyH3mU7w1qd1/J+VDIZdJyNR6Crv4bvnEdnzoo+sdn6oeK8ZIGnZoHiFzYGDinqE2c+5/QqgXi+BAN9K400roZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715951904; c=relaxed/simple;
	bh=b+m+ugr2NNc3dnDzd8ZI73JUUi6/mDtYwupaqwfdMtY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G992tQG0NVAm6KtPI8p0LxcxFJh+NarFXLKYw42G6FcHYnzQHT6PS7taD32kh1Lpwp8wkzBA7dye/fE8dQ/3QPeMBVy1hO1uwRs/0Mi5WowuIpA6EqZ9ZYR2CEhKscuVMKPxF3TToHJrto2nKEHGhBSJnN6uRo+d1w2oYhmNrXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PKxfgZZy; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PKxfgZZy"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-ddaf2f115f2so14312120276.3
        for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 06:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715951901; x=1716556701; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6lwF9WiyA4FWPt94OkN7FXWTtBTob75sC/aITN++qKk=;
        b=PKxfgZZyETQ99rxYEOs//Ujb8E4nDM4tpc1Xw3J4/dxvJ+EUXyWyy8ldOo9/vf6XXf
         XIQZRImi44UzV0MzPzt0Sza31V/Zu+4JugFS+zpe/D7u3t6O8NNBUENvkboiiucyQABO
         tsxQeRHhKw2Zb85o5Y99/HLy7ugnUpgUi9eplSkiMNIpgXtId1GlmxnQFxfY+MAvmn2A
         Elt85Dt9sxM54noOoPfNV5HwCqzlleeLNBiTa2Sf6W0Az0cVFFfBwk1/dTg9TUm33rlA
         sHMGhx9YVar6z0CkdQUUBGtsSyewvNBfawIP6hvjKtvfsYgo0wCs0FwcYZBOEW0qClZS
         +s/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715951901; x=1716556701;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6lwF9WiyA4FWPt94OkN7FXWTtBTob75sC/aITN++qKk=;
        b=qN3k/KY2BlonP71j57SKhcoCN3ICYgB0EQ/PSppIkNLX3ErXHL6zZp7nC05shDx0oP
         renLcJDS5o1kqGqfpGXsetaRpGAF/z9f1JvnAovN5cmnBilYbr6jED6R6fhddGqKAKFt
         wEqrWX7Az7e2bZHVtmOFPYL+87ZG5sjJj34UlVAiGXYzkVPqDb6MXwKWsmAjQmw/6IJb
         XeQwT4JKyWN986qtDHQUxJ2zoEC1Sg7U6JY1n0jdSTBTDEgQ+Y3SxYAfF+F3yPjnJjKr
         +UDYYSVhul1bhpDESpZugRQvJgwXuQLlMMBNvRPwprwNYa3QB3hSPanz51jWotcjZzKn
         1G5A==
X-Gm-Message-State: AOJu0Yz7niiIUXE2A7F28uqYk3nRLIjcGfBBUn6iZlIm2LTvO8w2bN1E
	IrpqfGDVrwP7ZETHYtT6t6xsv5Qcn3HsfnUVAPhDvXzr53cO5GAYMEECRcyDzMf5Cg8mpvgtDoR
	w15KS/XTeMr1SAPF7uWsqfQi4UBNaUBsEEwPn4mXDRsr1V8Y8VfvfbVoTK/+2NEgw6INk8ai9Jf
	sPYd7kStHCZxo4FQxouWuiJFweBMA=
X-Google-Smtp-Source: AGHT+IGTTqNEWDIciV6TBhmNxTXUhrZCJlowt58GdQn66KhhmRipYqpyW7XIWsV31GvymihlrnvTxJIEtQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:20ca:b0:dd9:2d94:cd8a with SMTP id
 3f1490d57ef6-dee4f4f51bamr2007079276.9.1715951901586; Fri, 17 May 2024
 06:18:21 -0700 (PDT)
Date: Fri, 17 May 2024 14:18:09 +0100
In-Reply-To: <20240517131814.719933-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240517131814.719933-1-tabba@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240517131814.719933-3-tabba@google.com>
Subject: [PATCH v1 2/7] KVM: arm64: Specialize deactivate fpsimd/sve traps on
 guest trap
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

The code for deactivating traps, to be able to update the
fpsimd/sve registers, is the only code in switch.h that is n/vhe
specific, i.e., behaves differently whether it's running in
vhe/nvhe. Move it to specialized functions in switch.c like other
mode-specific code.

This is needed for subsequent patches, since the logic for
deciding which traps to enable/disable will diverge between
n/vhe.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 18 +++---------------
 arch/arm64/kvm/hyp/nvhe/switch.c        | 21 +++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c         | 11 +++++++++++
 3 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a92566f36022..890388c17c3e 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -320,6 +320,8 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
 }
 
+static void __deactivate_fpsimd_sve_traps(struct kvm_vcpu *vcpu);
+
 /*
  * We trap the first access to the FP/SIMD to save the host context and
  * restore the guest context lazily.
@@ -330,7 +332,6 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	bool sve_guest;
 	u8 esr_ec;
-	u64 reg;
 
 	if (!system_supports_fpsimd())
 		return false;
@@ -353,20 +354,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	/* Valid trap.  Switch the context: */
 
 	/* First disable enough traps to allow us to update the registers */
-	if (has_vhe() || has_hvhe()) {
-		reg = CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN;
-		if (sve_guest)
-			reg |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
-
-		sysreg_clear_set(cpacr_el1, 0, reg);
-	} else {
-		reg = CPTR_EL2_TFP;
-		if (sve_guest)
-			reg |= CPTR_EL2_TZ;
-
-		sysreg_clear_set(cptr_el2, reg, 0);
-	}
-	isb();
+	__deactivate_fpsimd_sve_traps(vcpu);
 
 	/* Write out the host state if it's in the registers */
 	if (host_owns_fp_regs())
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6758cd905570..2b5af10cdf1d 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -112,6 +112,27 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(__kvm_hyp_host_vector, vbar_el2);
 }
 
+static void __deactivate_fpsimd_sve_traps(struct kvm_vcpu *vcpu)
+{
+	bool clear_sve_traps = vcpu_has_sve(vcpu);
+	u64 reg;
+
+	if (has_hvhe()) {
+		reg = CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN;
+		if (clear_sve_traps)
+			reg |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
+
+		sysreg_clear_set(cpacr_el1, 0, reg);
+	} else {
+		reg = CPTR_EL2_TFP;
+		if (clear_sve_traps)
+			reg |= CPTR_EL2_TZ;
+
+		sysreg_clear_set(cptr_el2, reg, 0);
+	}
+	isb();
+}
+
 /* Save VGICv3 state on non-VHE systems */
 static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index d7af5f46f22a..740360065d7d 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -209,6 +209,17 @@ void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
 	host_data_ptr(host_ctxt)->__hyp_running_vcpu = NULL;
 }
 
+static void __deactivate_fpsimd_sve_traps(struct kvm_vcpu *vcpu)
+{
+	u64 reg = CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN;
+
+	if (vcpu_has_sve(vcpu))
+		reg |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
+
+	sysreg_clear_set(cpacr_el1, 0, reg);
+	isb();
+}
+
 static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	u64 esr = kvm_vcpu_get_esr(vcpu);
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

