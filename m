Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08D21DE88D
	for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 11:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732273595; cv=none; b=Fpj5Lgq0rAZ3KRcQ6wTfH2HI4sTObmob/tBzgqocRzBfCSpIPoA5rLskZBJSCKTa9ykI83KZV/XDUz2bNT+WcBVXRxZGH7rbv0vgVr+azjWHyQ6CzeXZhWMpq6FZ6/l36BadIu7PjhFggzrwrmK4uuvSa/O6GDOguF6dUndLi9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732273595; c=relaxed/simple;
	bh=yhKFffPk+pGxo+OQISI4zn8ixl3fU8jm1EU/E8+0zTA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FjTJ5O2V9AzanXfCzuQnLShHF/+J1JlqttLxCHeaoirfm8IuFVFJcEy7mzf+XQq0vr5+FzSqX/gg9r6MhXAmUddDGwYRmb0yJjQbEBMoacqHLH2Pi+iqJJi/GPYAVKhnjCyvAvHNaUqSZ1sB5HD+Pp5Hpz4ttiArPWgYa/oHgbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FZCCZX+Y; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FZCCZX+Y"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4315afcae6cso11298295e9.0
        for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 03:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732273592; x=1732878392; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gur2xynCjgcWp41HkQooTRKN+u+15be4XbuVrf1N/Og=;
        b=FZCCZX+Yc3I4yqs4OySXssreCx/VfuU1idBg0y1xU8MIq7u52G85z9Hg5pSC0H+60v
         ppyC9yFG1rn4vtbMGnQ2Ir1GJYtEKDA2HTcMTpxJsThWgYPI+AuqM0Z6zttvz8MipJ0Z
         IE6R7Ou0CXEf8bGM+wJMkblvAKjNCrbqqcEE86rIb81CYhHbVHxqPBwkt5cDAvkFpDta
         MtCniRBsyqZ0S4nX1x1EVDVAyzrCNaw9tvTJDB7dG1Tixl8Rzrww1jrwi9CLgsIKRiHt
         AYB2o89Bx7mU+FLRYdGPgkp2DzsJG+zuAtb2SDp4tmN9wBpI9KyUK13TrPbMid69emRB
         iYuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732273592; x=1732878392;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gur2xynCjgcWp41HkQooTRKN+u+15be4XbuVrf1N/Og=;
        b=p42H65ZS5IIGQeAyHKvM62lG9UmkRnultxb27Wf2LW7S4soqRq561BrBRmeh5ny0Ux
         OkKygd8XPsWdyrXcqSASfN5asaiId3tdnBmLUBo++O2F3+X6ngtmGwrDlz7FEAWwgKhD
         NavAvxwaJWRYkpuiSGWJ+eCubsdl92RQa1x7hrew5syIv3dG651CWVn7URSEsUgdLj8e
         7fsHU4nHE4NGI+ajAhQMuJPFstLEvbrM4tJ2yguP9gaCXyiaOtLa5hi9ICEfdaUnsKh9
         F2q9uAU3z4jmB8++Q5bnKxCtSsUUGVwS+2Xwz8fzrz2qK40BgJ8HAwLw7pwYRi5vxXaU
         JSuw==
X-Gm-Message-State: AOJu0Yw0s428MJ6loQgKJMeWXJjFM0g/SG6xAqV9t6DBX7aqvxYi1tUR
	LHIdlUWMhEJoXPcwniTBZFrsode65njsc1CeLwCBHbTllS52hi0MT64fiLSqiezrz01bCl3KlS2
	napnboM5/bvA6v6PE0HfUGsELWeRr6osW2w1qNWfeWGP/pFT/3YbtO575kcnBDly/SuQ9KfVy73
	fjA9bkGH54WC4G7cdzzSb/zAF2Pic=
X-Google-Smtp-Source: AGHT+IEGR5iaos9a96LoeCuq8AX/zU97pwwRDaEVQhWXXwWDVUaSc8yCOJEzvYtzi12QNeFZMM4NmTsDZg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4594:b0:42c:acd5:c641 with SMTP id
 5b1f17b1804b1-433cdb1836dmr141865e9.2.1732273591798; Fri, 22 Nov 2024
 03:06:31 -0800 (PST)
Date: Fri, 22 Nov 2024 11:06:13 +0000
In-Reply-To: <20241122110622.3010118-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241122110622.3010118-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241122110622.3010118-4-tabba@google.com>
Subject: [PATCH v2 03/12] KVM: arm64: Move checking protected vcpu features to
 a separate function
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

At the moment, checks for supported vcpu features for protected
VMs are build-time bugs. In the following patch, they will become
runtime checks based on the vcpu's features registers. Therefore,
consolidate them into one function that would return an error if
it encounters an unsupported feature.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 45 ++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 1744574e79b2..fb733b36c6c1 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -178,20 +178,11 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Initialize trap register values in protected mode.
+ * Check that cpu features that are neither trapped nor supported are not
+ * enabled for protected VMs.
  */
-static void pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
+static int pkvm_check_pvm_cpu_features(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
-
-	vcpu->arch.cptr_el2 = kvm_get_reset_cptr_el2(vcpu);
-	vcpu->arch.mdcr_el2 = 0;
-
-	pkvm_vcpu_reset_hcr(vcpu);
-
-	if ((!pkvm_hyp_vcpu_is_protected(hyp_vcpu)))
-		return;
-
 	/*
 	 * PAuth is allowed if supported by the system and the vcpu.
 	 * Properly checking for PAuth requires checking various fields in
@@ -218,9 +209,34 @@ static void pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
 	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AdvSIMD),
 				PVM_ID_AA64PFR0_ALLOW));
 
+	return 0;
+}
+
+/*
+ * Initialize trap register values in protected mode.
+ */
+static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+	int ret;
+
+	vcpu->arch.cptr_el2 = kvm_get_reset_cptr_el2(vcpu);
+	vcpu->arch.mdcr_el2 = 0;
+
+	pkvm_vcpu_reset_hcr(vcpu);
+
+	if ((!pkvm_hyp_vcpu_is_protected(hyp_vcpu)))
+		return 0;
+
+	ret = pkvm_check_pvm_cpu_features(vcpu);
+	if (ret)
+		return ret;
+
 	pvm_init_traps_hcr(vcpu);
 	pvm_init_traps_cptr(vcpu);
 	pvm_init_traps_mdcr(vcpu);
+
+	return 0;
 }
 
 /*
@@ -417,9 +433,12 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
 	hyp_vcpu->vcpu.arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 
+	ret = pkvm_vcpu_init_traps(hyp_vcpu);
+	if (ret)
+		goto done;
+
 	pkvm_vcpu_init_sve(hyp_vcpu, host_vcpu);
 	pkvm_vcpu_init_ptrauth(hyp_vcpu);
-	pkvm_vcpu_init_traps(hyp_vcpu);
 done:
 	if (ret)
 		unpin_host_vcpu(host_vcpu);
-- 
2.47.0.371.ga323438b13-goog

