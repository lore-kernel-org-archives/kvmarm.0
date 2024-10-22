Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49940129E93
	for <kvmarm@lists.linux.dev>; Tue, 22 Oct 2024 00:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729558041; cv=none; b=Jhi+PN+tFULBnsenpzeZjibYKNCX8Bvmr2TKKRu5M1Fk2fSoPdET5cWRHPmQwCG/CfXPq3MF6BrZQD+GWgUKe5EyGh/mxmkRpGhAleBhQVVbHjru1t8k7y9dngBl+lhcz6XKJV0mKYgPkJosoo3y1GW0Lv5zBPKes6X2ge+AUg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729558041; c=relaxed/simple;
	bh=/ZZM1+dJhOvu0mr/UtOV9hTqZs4pXxjwQKKx0hCIUpU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GLnc6tncoH2qL+DRqlIypu1yi8VSwnscLhdaCrfHou/15MlFjy1v3ce+W6KLFoQnLayvu8O9SkvDlgIn6B+EvUG7oeLXTPAZYj+EO+190Jzdq00PfcUyOWp6W50HR9NkaUnQq0JW7RYdpl74nDvvYpsssPegfdVhc/ATkE8TFIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bl/FLCqq; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bl/FLCqq"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e376aa4586so97128037b3.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Oct 2024 17:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729558039; x=1730162839; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=60wgcSLTXVxTzPUjoeX/E6FIWkDuwYegYI4IrChLCKo=;
        b=bl/FLCqqaaj7ip2X0AeLV51OOdprhvgCvW1G2EhzHqbFzTxMnKrkaqFGKlDVUbGTqE
         CEr5Uu/0/goyrraKSDnD1X86ZD9Moyfff2QMGDkUJ4GS0oOyU1XSPC5sXn5+1l7Eh5gm
         JC/vxoPqIVTP0yb+OElxs9HzP3Nx2+4w3TaxbXAjrNUPRIwfNg+V+u2IWTOdcVGF1FzB
         YAZLygXUPrZqLfR77sO5syvwbLNZIDuePUOInesiPIL5caDNI8zF3LBZcF/+0WxvpFCa
         yWEuJ802xAA1ztGgxVzns/WVFt52OCvmdSUvk0zmSxKG5MOTD5Eyj8ajyqzN2SIF+0fw
         7wjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729558039; x=1730162839;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=60wgcSLTXVxTzPUjoeX/E6FIWkDuwYegYI4IrChLCKo=;
        b=jxm7z+mtjaJ4ho+hPAIsan+hO8tprCwGSZnm1sRA+ysjm08ROpaRPhLRyQ3jMSnwVl
         GMY6VZ77i+QT+nAiFtjqTVn5gaZJpsYqXnbY0KGRfT87Z79UZY4Zh3zgKXuaufzFZuUa
         CvzTama0PeMBknJEFmLKiZ+s17ZU1IUWO02kifnTcluw7P0O3yUP7tIqXLKo5vFwXcZP
         7K+WPcy56d/i0OkflBrwDi5C8DET0lcyIh1xGaU7qZWGS4ZIr9aigRrKEVcBJxYfgWEs
         1DWdHWxJWZuYJUmNIyi9dCYP8DFC2owYLM57Uun8mAAntBllPqMRhp0l6zS9lI+r3RP8
         B2oA==
X-Forwarded-Encrypted: i=1; AJvYcCUeBTFlDJ6NzSTPSzksDK4xjATft7dSpL8Ynij7UV/zW0FYY2AqSwM+ftJzbwJVeBcObMq7YcM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeGjl3KnW6ySOIa+2lN7ScwgjK7rtKfiGZE/C5AvEr8CUZnfv+
	M0TwllD3gU3La/y4t36008oFP/PSWmuFx79+71Rg3CTLdY0e6d9ISEyPwffsFUTSoqBt9v+DpAw
	FPJE40g==
X-Google-Smtp-Source: AGHT+IFiyt/4iIInAWKLwhqunyPq9QHonJj64kutF9hny1NRpAVPZ5zeWGMGBu5qDtED4tv1AgjC9hWx+3+e
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a05:690c:3582:b0:6e3:2f0b:b595 with SMTP
 id 00721157ae682-6e5bfd58c16mr738297b3.5.1729558039164; Mon, 21 Oct 2024
 17:47:19 -0700 (PDT)
Date: Tue, 22 Oct 2024 00:47:10 +0000
In-Reply-To: <20241022004710.1888067-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241022004710.1888067-1-rananta@google.com>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241022004710.1888067-4-rananta@google.com>
Subject: [kvm-unit-tests PATCH 3/3] arm: fpu: Fix the input/output args for
 inline asm in fpu.c
From: Raghavendra Rao Ananta <rananta@google.com>
To: Subhasish Ghosh <subhasish.ghosh@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The macros fpu_reg_{read,write} post-increment the '__val'
pointer register as a part of 'stp' and 'ldp' instructions.
As a result, mark it with "+r" for the compiler to treat it
as read-write operand.

On the contrary, sve_reg_read() never updates the value of the
pointer/register. Hence, mark this as "r" for the compiler to
treat it as read-only operand.

Without these adjustments, the compiler can potentially perform
optimizations over the registers holding the pointers that could
lead to data aborts.

Fixes: d47d370c8f ("arm: Add test for FPU/SIMD context save/restore")
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arm/fpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arm/fpu.c b/arm/fpu.c
index 587b6ea3..6b0411d3 100644
--- a/arm/fpu.c
+++ b/arm/fpu.c
@@ -54,7 +54,7 @@ static inline bool arch_collect_entropy(uint64_t *random)
 		     "stp q26, q27, [%0], #32\n\t"	\
 		     "stp q28, q29, [%0], #32\n\t"	\
 		     "stp q30, q31, [%0], #32\n\t"	\
-		     : "=r" (__val)			\
+		     : "+r" (__val)			\
 		     :					\
 		     : "v0", "v1", "v2", "v3",		\
 			"v4", "v5", "v6", "v7",		\
@@ -87,8 +87,8 @@ do {							\
 		     "ldp q26, q27, [%0], #32\n\t"	\
 		     "ldp q28, q29, [%0], #32\n\t"	\
 		     "ldp q30, q31, [%0], #32\n\t"	\
+		     : "+r" (__val)			\
 		     :					\
-		     : "r" (__val)			\
 		     : "v0", "v1", "v2", "v3",		\
 			"v4", "v5", "v6", "v7",		\
 			"v8", "v9", "v10", "v11",	\
@@ -138,8 +138,8 @@ do {							\
 		     "str z29, [%0, #29, MUL VL]\n"	\
 		     "str z30, [%0, #30, MUL VL]\n"	\
 		     "str z31, [%0, #31, MUL VL]\n"	\
-		     : "=r" (__val)			\
 		     :					\
+		     : "r" (__val)			\
 		     : "z0", "z1", "z2", "z3",		\
 			"z4", "z5", "z6", "z7",		\
 			"z8", "z9", "z10", "z11",	\
-- 
2.47.0.105.g07ac214952-goog

