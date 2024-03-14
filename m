Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D6F73196
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 20:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447937; cv=none; b=Ww1Ucmh8hiK5QzwkMEpJRXg4U6Kn4zpKfFrUbFUlqKAy5ggzSIcAX1YiOrUFbH4blwh4iAPD0o7985QCa6iuspo/n3ho4CMaCjttGkQjjL0+qEG1Z6XsD5ulamSVBR7P6PCbaKuPOzT/JixKhUCiKQBWON/6+9lfT8QwUX1zoOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447937; c=relaxed/simple;
	bh=lkeAZpZwnGU6VpgChdZkLs5vz+1Qca88xONJCmcdPt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oXHTzczW++Yk1ZC/QnU6bXxqiLH6sRc7YQi538Y6koY13Y84frdeY3Ymm1hfAox8GBS5Ga/qDay4k3u/7qMaXF0VSkTtji2PADLpzY3x/3rTjZ6qGWj7oSXR5gi8mHfaHyCvWz71Y58i5Ya12/x6s/UEC77hlKFNXoW4jRdquok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xzG8MRrm; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xzG8MRrm"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a45606c8444so161463566b.3
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 13:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447933; x=1711052733; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NdkPYJlECk/ZyZUB9HYwKBtygG9TYfy3Je51QsbOPR4=;
        b=xzG8MRrmwkA3P7CVpKaHm0sNJLdlsruzpunNMSOXh/0jQM9QReNXG5z5due7GJweft
         V/ZjkDW13Gd69494icjSdCgKjHfsates4NhmIfqRcpTdNWqH8aMqHumo1uw1F3NOxdUI
         9L2sS4HfLrS0J37CqLsZf5u95FnD8LVbDHmdS9TeY32vYWZjb3vEi8Grv3ZiPbW4m9rH
         jvEbKXkUw0Sy04te/YOizyOpESlI72VDhFEjqXrSWsAqb21w1LMiUaXzIKg8Vi2vYUit
         xuvhOJuVcL+6X5NcaKp8xA/rIa1ErQ0Km9q69bQa0Tun9AYOkBPwp80OHSQOt+u2dNQF
         f8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447933; x=1711052733;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NdkPYJlECk/ZyZUB9HYwKBtygG9TYfy3Je51QsbOPR4=;
        b=qpSsKJk970fnWzgSpPxcYBZ8UFj3RTfP1b+EeSdBoxnLn49tOXe7axpV8exkVOdt3H
         IODFEDim6z5+iz2lQCc8KPlk6mNEYvrkVTdUBmld9vMg3AgEE3odOZehXAiK3awKG2hA
         4I2NSr8sbsa4A3Nihmdj2Tfw1fQYiRRbh7vZ1SJJGBbUkaLwehMixV7NONewE3Bu8OLo
         f1vhCqH50kAxonvstX3UeGodrZU1wMPtytakscaz3BMI7f2RF1J+ucf7UALEIcsZnx1A
         4BI5MKIckKujO3o3FViZ4UQUDRW8NI4OIJx19lKujWUSBIAd/I3oW3Q4+0xPSKTyuQG/
         qnmA==
X-Gm-Message-State: AOJu0YwH3MmgGtROOrIgU9VpAzrj1866BQA7DrAGpvJz9HmYXWpRNsDK
	AUDYgoT0itfjHwoKyaYLoXzltu1Z3JEP37Uk/lB1WNKoALQ+409WsGKEgdEBcjmCegPY+EyIxcO
	VfU5z
X-Google-Smtp-Source: AGHT+IEAguWOtI6oTSg0qIM4uQ4GgBItzXtzQUetPHeB42cik8WVSDP20zLH80zcpirES87Iw6GvQg==
X-Received: by 2002:a17:906:d798:b0:a46:7cb1:51da with SMTP id pj24-20020a170906d79800b00a467cb151damr653684ejb.52.1710447933392;
        Thu, 14 Mar 2024 13:25:33 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id l15-20020a1709065a8f00b00a3d2d81daafsm1024436ejq.172.2024.03.14.13.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:25:33 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:25:29 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: [PATCH 08/10] arm64: Move esr_comment() to <asm/esr.h>
Message-ID: <6374e3f9d15663e0ea55fa4261ac42f3348ad809.1710446682.git.ptosi@google.com>
References: <cover.1710446682.git.ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1710446682.git.ptosi@google.com>

As it is already defined twice and is about to be needed for CFI error
detection, move esr_comment() to a header so that it can be reused.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/esr.h       | 5 +++++
 arch/arm64/kernel/debug-monitors.c | 4 +---
 arch/arm64/kernel/traps.c          | 2 --
 arch/arm64/kvm/handle_exit.c       | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 353fe08546cf..b0c23e7d6595 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -385,6 +385,11 @@
 #ifndef __ASSEMBLY__
 #include <asm/types.h>
 
+static inline unsigned long esr_comment(unsigned long esr)
+{
+	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
+}
+
 static inline bool esr_is_data_abort(unsigned long esr)
 {
 	const unsigned long ec = ESR_ELx_EC(esr);
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 64f2ecbdfe5c..647134ffa9b9 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -312,9 +312,7 @@ static int call_break_hook(struct pt_regs *regs, unsigned long esr)
 	 * entirely not preemptible, and we can use rcu list safely here.
 	 */
 	list_for_each_entry_rcu(hook, list, node) {
-		unsigned long comment = esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
-
-		if ((comment & ~hook->mask) == hook->imm)
+		if ((esr_comment(esr) & ~hook->mask) == hook->imm)
 			fn = hook->fn;
 	}
 
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 215e6d7f2df8..56317ca48519 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -1105,8 +1105,6 @@ static struct break_hook ubsan_break_hook = {
 };
 #endif
 
-#define esr_comment(esr) ((esr) & ESR_ELx_BRK64_ISS_COMMENT_MASK)
-
 /*
  * Initial handler for AArch64 BRK exceptions
  * This handler only used until debug_traps_init().
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 617ae6dea5d5..ffa67ac6656c 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -395,7 +395,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 	if (mode != PSR_MODE_EL2t && mode != PSR_MODE_EL2h) {
 		kvm_err("Invalid host exception to nVHE hyp!\n");
 	} else if (ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
-		   (esr & ESR_ELx_BRK64_ISS_COMMENT_MASK) == BUG_BRK_IMM) {
+		   esr_comment(esr) == BUG_BRK_IMM) {
 		const char *file = NULL;
 		unsigned int line = 0;
 

-- 
Pierre
