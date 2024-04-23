Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39F312EBE7
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884782; cv=none; b=TcJtkDRibxGKfz/b5k37VLz7ZmizmEAtV4EHJnfG4mBE1PC82c0jUGezSWYJYUCWMykAA5iTf4nnWc5CusxBe1BmFfHyK/qwTE7xw78SAeOzay93RelOWPgPNIHOhLKfnjhDUe+ZJJy1QYIFe75/unM6QGsp71gNAHu724oVP/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884782; c=relaxed/simple;
	bh=Gxr8b/0ifmxOOLSmLMlwN+FmH3Wa6cC5DT0CyrUoERM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q173O0026UCo06ay79sy36PRM+95RMN4c8H29qzpDDtv0uTrlzo+fFD1HEoBPZaSQcVL4VIq1P/f0otJtR+cifW3wd+SnNtkqf3izZc6kNWIKlQaWd0InECxQRIqKVowAl9VKWI5UdlVUNPZHwkdfzPT3ts1SSNHB/mP1ZPHQ6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F6VQA2FR; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F6VQA2FR"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6ceade361so11111512276.0
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884780; x=1714489580; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=spVyBK1DenNowX84dGQKXXu4QL2Afz95gZfImVRze/s=;
        b=F6VQA2FR5qRiiG0C5SutzirAPfzXDLOMkOKbNthZ/gTFom9xj5MCLzyW1DjhH7pkOF
         3XaPXysqg9kvQavEg1o/OwWZgCtW4PQV2xdG+mFOmaYgMlwgTztqGrFIFYK9hhLZj1+9
         SOd5pufccN9vQJmc0U9jEwPSHE6ow/8WXNcCGseFvOkg0hhzRp2etiL66SDOFugWX8As
         TQraOB4pJ4EhWzYuRL9XCgRKwRrDF+AQ+c4EJdLtnYshK0gObb3jAr3p5Vm/APvNh54b
         1MJuuvoW9uszEwtxMpE9ZneUIF/Wj2f86jIbgor6Hhstyws4nixBtrVYPkZEhE4CxCax
         WLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884780; x=1714489580;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=spVyBK1DenNowX84dGQKXXu4QL2Afz95gZfImVRze/s=;
        b=da8RVOPZ0RUagNn0z/4JWbgdcFYf/Jzms5GAqG47qvvkamPkW8IA8ri6bPEZgZ0Q9J
         jmZqJEWUJx9e6RJBblreSvldkl+nQHODn43ugP6i4O3obC4utNJ9fSXsZZ71qkxl5orl
         j6P5rGjsjKjOs+fHKq1Q8iGkR7e4iOpznbIkF/A8aEF5wAfmY1j46FXucKJCtga2H6HV
         WhG6r0cpjtRr5P9DNm1TzYcXxN/i3Rp8o9QcaIGVKdV9A4pNju8myXU0jWO6tpUBkQaR
         22nfZuDOxcaMP5fuMPb2DpGahFU+HO2Gjxkhzgz2ETwVRFa40g7Wq2eIBuOTab2I4tJO
         AqPA==
X-Gm-Message-State: AOJu0YyrWBOkjTdElB3A+b2CUNjVbPBYgU2IKFvmeUO39bP0+1C60+QQ
	McmRCl241+DUWknvhe37yph0leE40l6lTRuQ6h+2zdolBGDfctEa3hbpcbOtmzkQdG32XGCq0+g
	TT9M2tVqIRVRuuax/xxC7ki9MR0RUZHSrnKmzw9GIbhG4c4JjnMQhxcAmjRwAGUm7rnQO3aEkQo
	D/KSMkbRXafyrI26ON7jZLjosHjJ4=
X-Google-Smtp-Source: AGHT+IHDkKAXraljmo4zHjf+W0cwPdp8MGBqkzSRizzuyFHo+Oh4W4rBD/pAgsy+ouwsnoV4gEuydv3UuA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1083:b0:de5:1b63:9ede with SMTP id
 v3-20020a056902108300b00de51b639edemr2313416ybu.5.1713884779832; Tue, 23 Apr
 2024 08:06:19 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:25 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-18-tabba@google.com>
Subject: [PATCH v4 17/30] KVM: arm64: Add is_pkvm_initialized() helper
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
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
2.44.0.769.g3c40516874-goog

