Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DEB86250
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261438; cv=none; b=cPTQGYlEajVrJKZjOpOreBXl9bw17CIs5gqgyLJ9sZRovaxfd02CcaDI4vjVieyOCWRluatfG3/yYCY7g69dwXm3ovu8MjyuoIWQiYbafXkA8hl+epPRkwd2WzHewNkyyaZKaxKXEtWW4bX2yFTKDC/nH8P0xeohLkUDI1PesuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261438; c=relaxed/simple;
	bh=PkdC9TQwLpRGIsMlE/MTNGxW/Cit2WDL8VhMDoO92iY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uPd+vEWtHFYFA6hvPnZD77VbYXmGi7Tfv+ekkeaM1YKAQHYD8y9iFdUjs/wbeoBwJ7Q3ZWUtCd0o3LDkFDhrdYY0Poj6g5P4e3ei5zOKCaH440KR+iY+ZkFI3JtWObosVrRhHf1Ut1S9fZhm2JXzAjo420ChoRxr8CS2yVzfAVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LEA4sbIg; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LEA4sbIg"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-34954c03af1so209409f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261436; x=1713866236; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dS0bZn+zyu9UefDAwxzNTS7Suaymxjoc+UFbptSkPCc=;
        b=LEA4sbIgAcUmEalw7rdg5W8zbKSmz3KEIjeeenadGOwUd+w6LoanjsCKD8AAO29pcn
         QMGE6XCSQOhmNAUHC/285/QFGuuf4gbHP75seSj428BKvLtr3FJvPPyZBTHDy3FF1WDr
         meqAhP3I2PT41D7SdWcdwKNcuHGp4OeVUo4OQyZKPmLoEB45zxn/jTUcCx3PQCfPC98U
         TGrpbPh5h+s0Eu6cZfPTy7X8t45/JHOuH48vQYr8GuR2vaCq09+U46XQ0kytX/gcFcpF
         MeA0U/Q7BVZNXGlttSrcsPfrmzVB3vY4DlVVpmkOX/HHcIVMUKKsqqrage1kNfGjCuBW
         EJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261436; x=1713866236;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dS0bZn+zyu9UefDAwxzNTS7Suaymxjoc+UFbptSkPCc=;
        b=K3VNz+roBaGxjb/X4wP9d3T7QrYQZOrasQRHk9eax7R2YESjdCxgbhKvrnKke8o16d
         xLHpzYqsdxtHBOSgbhhmaxim0oFfHcKUZt6Ef1qvB+Q5u7WOFmnq0B/dHbwabuOTIcRQ
         j7BreFQvjbWrCNFchOdtkunRvwdkJEnvTcT0h2KiSBYPWTBx/0vVAv2zMAXziwvc/vSM
         m0KLQC5Bbun3l3JAflJ2XkXXxE0rhaJwGZQsedhGU1AYywQoLojwMhjSRuy3qrZW1qvd
         suwTScKc04lNQvYfhmwOv53jhDMgqFi1yCe2QH+l0/OxtYp+pxvIYthDfpo6jajEGzEv
         EUnA==
X-Gm-Message-State: AOJu0YwTcgeiQaCmJzpjvad0SjRHWqbiZidtxAyyPjQnwA7sxhr8WBi8
	oJN9NDSYmS6mkfIRIL3/WFFVUzczD2et0D6iohmojvc99hVZ7XYlWTYjJM8rjkE2dLlXCPTkVq4
	FHs7/YQHP2s9kBAGXQLYBakUc8XN5cQCjNiWxhz/7smJy+p30eClhnftHO5Na5xzSvQO+pwr7Wa
	KXklD0Es0XSTRMbv0tTznZ1j76uww=
X-Google-Smtp-Source: AGHT+IHrvtf3pGoj9kWD7J8uSn/GHY6eiek6IQ6n63hu3431jCQoHvLVREtgPCRkc4cn0tDNN6L4BCGM8g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:12c3:b0:343:7e0c:29e5 with SMTP id
 l3-20020a05600012c300b003437e0c29e5mr20470wrx.14.1713261435510; Tue, 16 Apr
 2024 02:57:15 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:06 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-16-tabba@google.com>
Subject: [PATCH v2 15/47] KVM: arm64: Move pstate reset value definitions to kvm_arm.h
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Move the macro defines of the pstate reset values to a shared
header to be used by hyp in future patches.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 12 ++++++++++++
 arch/arm64/kvm/reset.c           | 12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index e01bb5ca13b7..12a4b226690a 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -432,4 +432,16 @@
 	{ PSR_AA32_MODE_UND,	"32-bit UND" },	\
 	{ PSR_AA32_MODE_SYS,	"32-bit SYS" }
 
+/*
+ * ARMv8 Reset Values
+ */
+#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
+				 PSR_F_BIT | PSR_D_BIT)
+
+#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
+				 PSR_F_BIT | PSR_D_BIT)
+
+#define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
+				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
+
 #endif /* __ARM64_KVM_ARM_H__ */
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 68d1d05672bd..29ae68f60bef 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -33,18 +33,6 @@
 /* Maximum phys_shift supported for any VM on this host */
 static u32 __ro_after_init kvm_ipa_limit;
 
-/*
- * ARMv8 Reset Values
- */
-#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
-				 PSR_F_BIT | PSR_D_BIT)
-
-#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
-				 PSR_F_BIT | PSR_D_BIT)
-
-#define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
-				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
-
 unsigned int __ro_after_init kvm_sve_max_vl;
 
 int __init kvm_arm_init_sve(void)
-- 
2.44.0.683.g7961c838ac-goog

