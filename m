Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677072907
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261458; cv=none; b=QHGygs/+m6XULSPS8jiVbsORucRYBdQ7fGzlER6UaV265y5P5B5wq7liwirymkBZ7peLhLohwKbcHvjjjcFt4noduLjJKoq0Z35ZGWx55J9ZYVocIwI6F+XqmvsDs91LooCV7cPImfSaNKnZiAyJUgDpVzu63Mk48+bx816g+Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261458; c=relaxed/simple;
	bh=QmWhKf5XcTylDN6PWQ0UFPx6vcLgRkGNtkd1Ft42dsw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QW+o4+iExqJr4TzZN+epUI3oKkyMBgUrJrI8+MwHWBfek4bq87kTtyu6iX7nHuGbpYlvhQwrX/4g0duqP7MsjO3KeRfVtonkpuGac+gLCf1ZYhruxteQiP5vTrareY3DkFlWJ5LAUwW1UBKCefPdhSDGdc/5/wnbTggNuqEx20c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3yhpQGaN; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3yhpQGaN"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-615372710c4so69451517b3.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261456; x=1713866256; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JQLQM5immu9aMrHNIy2rZVbmX0BvEd5fZ2fB4xGLMfA=;
        b=3yhpQGaNwpmoAN/gT3lyAY6pydYeOeIyuiPpldC8yR5LscGmbtXPCgDeHsUW24Ujom
         NJUhpWNMuP/lh1aOZgnlj1fKKdbn8EV7LNZBsd/1QCqtkH+RHNj1IeHQ3bemvcYxY7qv
         NPfa9hx08LrYQ3J6cEXEIdlvGi7Za+b2jFIJIRoK0Lx8O/UL8xXTpTBmi6NfWteceCR/
         +6QAZGZ70ZcbsDbOTSdikWJRwXtIhwhu4nt4lST083aFtj5rIY39X1JTeQIR2PWXQf/J
         Eu0VOuRvLIHyiH/nBPVgXByVn0o1UuzpRvEplTD/t3P9UH3o3ZsjhV1eDJ1KwPoQOw58
         pqmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261456; x=1713866256;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JQLQM5immu9aMrHNIy2rZVbmX0BvEd5fZ2fB4xGLMfA=;
        b=QyGaNbrhiFhSmxs4XXz2xHA4tUUmzNaSxSJX8qp9tw38F1V4vunSQvsKiBjX9YD3//
         WacILmvH8SYmsDjJe4TjanitE0YsxLuWKwdPlBqKyQedkmguKm82GUx4pjFtDfW4eQq9
         aQSRmik4lgAeMJeMS99VTy/PqnEoHYn3LRbj4k1xqwH0j/G/Lmb44u7qQOyWDqW1tgWB
         i9CqNgO2sCprH5pPhRG3p9Mm/XYB04dwEpCHzNarBa0yzD/FiM5UTU9dnP8xTvDfZROO
         nuHJGnEnhj7lNZp4oL5IXjd0B3NjeVsQrxOQAxIdJqbOk9YwXMasEntS9lmr2DGfFpVY
         C3FQ==
X-Gm-Message-State: AOJu0YxuWUz1w9/0lbk09qF2OBBCsNbnzLaZgyIPeD73qc5PvmNy/hgx
	OkLcNeyItiLOVvf22ke8NVnuVaNE/iafdelaxgXuk6DbnGfUw/7pFRNo/A7SjSsObH5+iHalq5Z
	6AQV/cwQK78x17xRvUCLlrA6T8qrau6AbS7fXV3peSj8poPxchiNjLfM4HYuYBCIpHZnvLVRxd4
	VeOeMLZX5hgsikRr37ib5MhvJNJuU=
X-Google-Smtp-Source: AGHT+IFgJc3hIVghjWq4UxbEnFauktSww+CXmRGzNTUtqsbLV3Rucdj9bSxXrZD/FoM1Q7cBGZszSvyWSg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1147:b0:de3:c617:b89e with SMTP id
 p7-20020a056902114700b00de3c617b89emr927933ybu.12.1713261455957; Tue, 16 Apr
 2024 02:57:35 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:15 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-25-tabba@google.com>
Subject: [PATCH v2 24/47] KVM: arm64: Add vcpu flag copy primitive
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

Contrary to vanilla KVM, pKVM not only deals with flags in a vcpu,
but also synchronises them across host and hypervisor views of the same
vcpu.

Most of the time, this is about copying flags from one vcpu structure
to another, so let's offer a primitive that does this.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e123bfbfeceb..e6ccae4f3252 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -777,9 +777,25 @@ struct kvm_vcpu_arch {
 		__vcpu_flags_preempt_enable();			\
 	} while (0)
 
+#define __vcpu_copy_flag(vt, vs, flagset, f, m)			\
+	do {							\
+		typeof(vs->arch.flagset) tmp, val;		\
+								\
+		__build_check_flag(vs, flagset, f, m);		\
+								\
+		val = READ_ONCE(vs->arch.flagset);		\
+		val &= (m);					\
+		tmp = READ_ONCE(vt->arch.flagset);		\
+		tmp &= ~(m);					\
+		tmp |= val;					\
+		WRITE_ONCE(vt->arch.flagset, tmp);		\
+	} while (0)
+
+
 #define vcpu_get_flag(v, ...)	__vcpu_get_flag((v), __VA_ARGS__)
 #define vcpu_set_flag(v, ...)	__vcpu_set_flag((v), __VA_ARGS__)
 #define vcpu_clear_flag(v, ...)	__vcpu_clear_flag((v), __VA_ARGS__)
+#define vcpu_copy_flag(vt, vs, ...) __vcpu_copy_flag((vt), (vs), __VA_ARGS__)
 
 /* SVE exposed to guest */
 #define GUEST_HAS_SVE		__vcpu_single_flag(cflags, BIT(0))
-- 
2.44.0.683.g7961c838ac-goog

