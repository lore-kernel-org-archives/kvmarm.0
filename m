Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DF4137772
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560956; cv=none; b=bj/dAj2gra0yN3MqcmvJ/+fRZxfY5kzhSQXVgeqBX+p/LWwPFG9y/ko55ubKvOnCex9yX4VGZlG1bZ5IRhG9vsh+tSEGdiXmWg1JYrbggPTuTbk1xZlPu4COeZjjaH3Of7MShHt9FTgOPNnPm0tP+MNUZNlRv2ifu9akdrd4g+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560956; c=relaxed/simple;
	bh=WNJdLH/t/jsv/FTrbUy6gwFtWaIdEpvDCRX9/tM33Js=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pd25RzT5QXbjUV7tc4JJdhm1EeYMHS4J/JzHM1Bghf6rhv3TJMsXoXMnCnpaWJPGlAMVF9BsfCofoEnnxUkeHn0lcyIR6s+J41B7aj5Z6iSm5KBSylfjlSUDX+mP56cwteOiQikS55gbrmgWznPNaCcoq7A1XS8lzlX0Nu7BNNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=difzi4zs; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="difzi4zs"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6dbdcfd39so37652276.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560954; x=1712165754; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=991k38cENSSgHzwSHwwZ6dQsnDF5mUKmOIxgwohorl8=;
        b=difzi4zs2rOPU7KX9tPvgToSo6IFsp60o5D68Jq5JwEvR3M0I6YGF5uas89wmEL0oe
         oqZ2ztMb/QO4iltVAUXrScwF9O+gsic5XPaG+uxa+aEe+DncI6/yAuKL6+xNglZAcXRQ
         JPcUJ/Ke3ZJ2SrZyQZ1v6z5HjGS1D2yoLejFw4/kIqUxrsI6pDotSDqwQfA2Voh9Z6Sd
         2LpIOwT0PTMrrY0ixMi9GG/nIAfY/9U6uPiHQOdcIMl7DOR4Kym+Sktuu5ArROei2Cpr
         TA83VfCWCsB49bvGg+Jr7f6PA+3wIDdET+mKZcF9RF0Vi5yIGcR1IrP4SldSoJSod5MP
         8l3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560954; x=1712165754;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=991k38cENSSgHzwSHwwZ6dQsnDF5mUKmOIxgwohorl8=;
        b=Oag0pCvxao0HWRwxZJJ0howX2Nby8ClGLu4bJbe3QAYOHDvHXUSD13Pco5OF6jTzUk
         bbMc1Hyi8CoRluWk31bAnMKMcs8E9085GrhSCVMbX9120B0WRGJMYbViToxGb83GwBPW
         1mYvgV1dUVHIaCSN3ZoCyyISY8FMzdLRE/0im31Yt1rwveWHajxxgi08AEDBfr9CWjM+
         kUl5FAi1EtTM6muSR2gDRMLU7NKdhEOHJSnuRAT2WwssTfkJ68aRNQzlSh30E/wrksTZ
         9zGLuxFpeD1KC3UbZQgt/lcQs2gL+Jg6tJ611nTtdfWBBVNa/d93pTWnHoldwaZs9SwO
         DR2Q==
X-Gm-Message-State: AOJu0YxMJDHPc30I9qlOjlN6HySBd3cumur2recmo8eHbFva1VWsEVg9
	WdVEJ01r6X1gBwPEmte3G9PS7imZTnP8Oa9iGNfOY4xVDX4urO455YLDqldNqgctZxBsteUmtVv
	iEjPBI5urqp07goDDHt1U5rjTnZ9w++L0WuC+Un2Xt1Itm/HLPgwEaXZ8jJcht/jJNp9ufxq/5G
	ShgQU5xC67dooLrWHZNeE0g5gOp9M=
X-Google-Smtp-Source: AGHT+IH8CkRxDkzDmmMLAAQW6NRft0xGxY4Q2uQpsR1aUXlFEI7rXyaNJa8jOaeJKd+M1DbaZZbVlHXL+A==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1007:b0:dcd:ad52:6932 with SMTP id
 w7-20020a056902100700b00dcdad526932mr150906ybt.5.1711560954295; Wed, 27 Mar
 2024 10:35:54 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:34:56 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-10-tabba@google.com>
Subject: [PATCH v1 09/44] KVM: arm64: Add is_pkvm_initialized() helper
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

Add a helper allowing to check when the pkvm static key is enabled to
ease the introduction of pkvm hooks in other parts of the code.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/virt.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 261d6e9df2e1..ebf4a9f943ed 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -82,6 +82,12 @@ bool is_kvm_arm_initialised(void);
 
 DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
+static inline bool is_pkvm_initialized(void)
+{
+	return IS_ENABLED(CONFIG_KVM) &&
+	       static_branch_likely(&kvm_protected_mode_initialized);
+}
+
 /* Reports the availability of HYP mode */
 static inline bool is_hyp_mode_available(void)
 {
@@ -89,8 +95,7 @@ static inline bool is_hyp_mode_available(void)
 	 * If KVM protected mode is initialized, all CPUs must have been booted
 	 * in EL2. Avoid checking __boot_cpu_mode as CPUs now come up in EL1.
 	 */
-	if (IS_ENABLED(CONFIG_KVM) &&
-	    static_branch_likely(&kvm_protected_mode_initialized))
+	if (is_pkvm_initialized())
 		return true;
 
 	return (__boot_cpu_mode[0] == BOOT_CPU_MODE_EL2 &&
@@ -104,8 +109,7 @@ static inline bool is_hyp_mode_mismatched(void)
 	 * If KVM protected mode is initialized, all CPUs must have been booted
 	 * in EL2. Avoid checking __boot_cpu_mode as CPUs now come up in EL1.
 	 */
-	if (IS_ENABLED(CONFIG_KVM) &&
-	    static_branch_likely(&kvm_protected_mode_initialized))
+	if (is_pkvm_initialized())
 		return false;
 
 	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
-- 
2.44.0.478.gd926399ef9-goog

