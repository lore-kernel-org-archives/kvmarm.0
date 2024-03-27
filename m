Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6010C14D2A8
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561035; cv=none; b=ceU3tjj+FnTWG0R0Kqwj21amts1wF+taMTxRjRjeG2KlTNy/mYyHHTGPcykNSAR2pv2opXV9dJc/YILqgGc2C8BZiMXfX++l7sPauUafI6y+fgYAnM+YX5dPl6KqHw3WKeKD87O3op53foh1RMoTA8dEU0QLCOX9UohbdKgA5GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561035; c=relaxed/simple;
	bh=UM6N1NU7vlBvefzjMtrtrnVe+T5CJ9PgtnBUxZ7TyO0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gSKqaMYDlweZc20RcvTzRuic7q9nrghlNQc+RH3P/pRca5/oYr0lWjkod7N9nTHgw6KmJA03GVMZ7FhFZEupKYcE06W4+UMPifAetgJqG9PJl/ScZMm+0zEabHeM6eVw6xTKE920UmL6BeFJudIA31C55PLdYBfwaEI4yivsyYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R5u9MBaw; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R5u9MBaw"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26845cdso51456276.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711561033; x=1712165833; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wH3NX8CAnxhUlRTzj3SL1+tc0EFCzgtHNNa5TYuTM2Q=;
        b=R5u9MBawEzXJjm8rILNk/SuzQ86C/xajVGJWjFURQXjyc6lADVbT2rfB/0JGv5UPX1
         sCPWfwMX+JskBQpORIxZGaT4zlxMHvcnJT2IUTaMMyE+U7jHL94Kbb442Hoz1TOvMzdJ
         p8R8Vju5sdgg+gyNSky/IViH7nz9duMWIjh/fNAMd1pJdVuOUhKmcHpqxCJKtoAwVE4S
         UsYmDL9w7wfGRyyOsifTR5lTVvaoZcrz2cPkvA4CKpTO39vo+C3IztXRywfCvMAIi9cs
         vWEL9ZmU1A60hyYys2lAguiQ3nJ1ZtNxlXn6VoZBmLlMld9vxMxa8T+988GZg6cai71m
         9ZlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561033; x=1712165833;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wH3NX8CAnxhUlRTzj3SL1+tc0EFCzgtHNNa5TYuTM2Q=;
        b=N8/6QAQmqh9htkPNYTBR3er5qczWSal0buir9cI6yrRTjX/L5oTbZSsE/RZqC2mh/D
         Ubvz2L/eepgsHNRk/D4MZW6zCgSmMXlB2zJHNY/yjI0tEgwHxT7AljR3bVJ8CNxcdWma
         UdxB6JuLoukyrXM1xF4IH6FDLB+y4ID5gmRf+QEGWB0Lhk8gol703fZr7Sb8XVkMueRg
         ocOId0rztw2KB70xtj9ZHLUPWoRdT1rxQa2Uelp5VCGhkw2szgVCUzvFJ9yUOjSTwv9l
         2Ohp2Hyzi1ugV2AUGZZhEEkvuxIodq1FKDLR5VjYR5BpJWxpxDR1lL25SHhuD0vA2FXC
         NRHQ==
X-Gm-Message-State: AOJu0YwzwHuCk9MuI3TUPSm6CRYaLVu0r+dnldHofB+6v0SVZaAmAK6O
	HttZfgPX8gOd0MsNwcVT6Psc7nMyl0/OmCcICrT3ETf6OkL8m3OqRIhElm3xV1UWly4aDVuOhQl
	p8nCPKaycHTU12mGorBGTeQ28Par6VRmlaRFSTegdwQaIQDN6HWrnMpohqInfl47MnaIP6Xt1OP
	JCRpOjOIk4sPJkedAvDAawiisqy74=
X-Google-Smtp-Source: AGHT+IEsCvmgJrrUNWLZ7sKKZSpOS3PFYPU2RNGP7+TtD+HctL6AQ70V6b4UGj11qXHqm8EBPEsQolV6sw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:e10:b0:dcc:5a91:aee9 with SMTP id
 df16-20020a0569020e1000b00dcc5a91aee9mr128397ybb.7.1711561033251; Wed, 27 Mar
 2024 10:37:13 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:25 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-39-tabba@google.com>
Subject: [PATCH v1 38/44] KVM: arm64: Trap debug break and watch from guest
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Debug and trace are not currently supported for protected guests, so
trap accesses to the related registers and emulate them as RAZ/WI.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c     |  2 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 1167c2296b65..59c6b4317f29 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -111,7 +111,7 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
 
 	/* Trap Debug */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), feature_ids))
-		mdcr_set |= MDCR_EL2_TDRA | MDCR_EL2_TDA | MDCR_EL2_TDE;
+		mdcr_set |= MDCR_EL2_TDRA | MDCR_EL2_TDA;
 
 	/* Trap OS Double Lock */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DoubleLock), feature_ids))
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 18c1ca0a66b9..1604d170df53 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -345,6 +345,17 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	/* Cache maintenance by set/way operations are restricted. */
 
 	/* Debug and Trace Registers are restricted. */
+	RAZ_WI(SYS_DBGBVRn_EL1(0)),
+	RAZ_WI(SYS_DBGBCRn_EL1(0)),
+	RAZ_WI(SYS_DBGWVRn_EL1(0)),
+	RAZ_WI(SYS_DBGWCRn_EL1(0)),
+	RAZ_WI(SYS_MDSCR_EL1),
+	RAZ_WI(SYS_OSLAR_EL1),
+	RAZ_WI(SYS_OSLSR_EL1),
+	RAZ_WI(SYS_OSDLR_EL1),
+
+	/* Group 1 ID registers */
+	RAZ_WI(SYS_REVIDR_EL1),
 
 	/* AArch64 mappings of the AArch32 ID registers */
 	/* CRm=1 */
-- 
2.44.0.478.gd926399ef9-goog

