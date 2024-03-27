Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC79014D6EE
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560988; cv=none; b=a13CBrTUHhs95HDvnoGcoWqEv0QfvuQbTfXqvUQiVvfkN5dF+7rTeAKHcP1WeRHBBUf0v35c2i/2d4jAxntlMevikqT5ckC14a4DkFDuKT1zT4f9MXfOpZh3Ayv4WRS0GXNgWRw3UUY+bSLGWTZsugJVKLQltjINd0+Bw5NugeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560988; c=relaxed/simple;
	bh=rZRBKCgv056DXWMS3QIFJfh4k5iz9h8Qz1AILB9aRso=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lSt6iSxoIOTAi0jueHy7huJrmCoFCuR9S6WkoCU2j1gujwzJwPBC5wW4igGU5kOLen28GuX1FIlC2dQHYQ9CjPaOonWNHbMbTPvPKR+jfDI1kaEFVvjI6WP28arjebUt+FqkwJUNrlPtZjBYUUrmBQVebYaXuy4YIdMQA2FEI1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ECFFP8pv; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ECFFP8pv"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-41495e1c1e9so180065e9.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560985; x=1712165785; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gf27lyI8HZ1SSa6nC8AMOUxMXF7+J0R52t1GAGG5yk0=;
        b=ECFFP8pvzqN6in3mV7nKPRFmpfsvwxyXJ37xpdEad9axBoIxs9WPH/Re4StAbUmp5V
         ozWet01KXfir/jNtOT2FRUIBIrDkkUFytzKilR6DP3MfKs3bXWPKsMwjtg5zXP2IR2tW
         7Sk5bMPii1OZ9foZ3yV9mzcIVBWhJeRhjDM50CUYx55qZMsopLiVBsd73uPYqOfxQvXG
         2q/WTTT74WLgWEldQizfzREonWPbpy26djTDDoSUVdgy9yhOeBIrGRm0g6Emzcy6u3Wl
         P3tc9kj7L6xZSKS9A47ffctbKchUl35yUFX2B8vmxHJV5jnbF1r0hceJ5bn/cVdziwG1
         3yHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560985; x=1712165785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gf27lyI8HZ1SSa6nC8AMOUxMXF7+J0R52t1GAGG5yk0=;
        b=PxEqKSPu/SFC0yB/9v0yLD5iJwbiOdx4iqQfOd1q2zonODufh9XCMhymqhuyjUIHwe
         Fl6XsnuOD8VbZ5rnlZ+MWHJikJ14AexUi8wZlImKcYSXIR85w7tGNiwX4t1AnEO4BuMP
         lrIeyuK9XUka2WbNM1R2d3+7HEI1N6OqDbg4bcHJA6wOiGMJU79pmRIB8vD2hLFUcqeB
         e+JH60KBWiRDj9bqCZFs1+8GhZhulSfwioOG5nBu+VtSQHTwsdct2Oq7kTuwUuOejzci
         quxsxwzze9oSz5Sjb9dlweHzqcVQJqoa1xa8cEAqxJRGpaOgVJqFLqxrXFtxf+VCdryo
         3UsA==
X-Gm-Message-State: AOJu0YzOJ1W16NJXNM+Wap7q6kkji3TiWwz3oB2zS/IOPZExgmh3vjwV
	1/VL3hyceSfIAoD/bj9FPIeYkuLZiADIUoNclC83WSXJDfnb/vBK+Vfg+x1ULuFAGoCIMgDhKpA
	49bobNutYb6qTGmvAikhNWMKEZRjbSoo4c9CjXtHIkaTx4HjuilOpX9ryth6zzzd+VVu1sMBdr6
	LBSghQb4Cpq9hUmUUl9Ch2C/aMgm8=
X-Google-Smtp-Source: AGHT+IFbZDCQRopXCXJ51tMtcMkZq8f0Hxe5/Zjf7oZzmhskSMt//uSvVu1LA1EeA1UzOirQB8cKtYydxQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:19cc:b0:414:1181:3845 with SMTP id
 u12-20020a05600c19cc00b0041411813845mr73wmq.6.1711560984706; Wed, 27 Mar 2024
 10:36:24 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:09 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-23-tabba@google.com>
Subject: [PATCH v1 22/44] KVM: arm64: Add vcpu flag copy primitive
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
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
index 3c0fefb1dd73..da5fc300d691 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -764,9 +764,25 @@ struct kvm_vcpu_arch {
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
2.44.0.478.gd926399ef9-goog

