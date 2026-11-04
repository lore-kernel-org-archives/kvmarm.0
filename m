Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793801187;
	b=RasJSc7ZhI4Awp+bAFBvfz/2hO7227tSmCSUAAjKRaxDhsJBEX9vFwHNHUtjrYd1Rk6z
	 SipPruFmzRbbSp6s7Our50ZSD0jOsNsVVvff3eD46aV3JtXGKA1nGZtsVoymvcL2SHvFl
	 dLKj4W3e5dVHWsk9ZHeGkoyZL6o/0PQeRYLT4EfuiyvjHVnGJhixgWHTgiITcHHKpQi4N
	 wl76Qaawpl81W7taJD3GzaOLm8nqixQv6kufwvXTpIfNKWT974vyw/NC+aSpgymxoFOcp
	 XhR0NtAhiuGpZ9Qr4Nvarxgbsk00lm8p8JZBl2FybCWi6b7hLRjOvR0BxCPeI541bFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793801187;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=0ZdKyKH+Ww5i9BiLpu8awrPqNj31X9LX5Wb4WFhtBGU=;
	b=sGvqCXobdhSwnV5MFf/zzvuyA+BK/dKOjFMefUrCiIwRY53gilJBl1uiSuQW4zEqbfvM
	 jr0iWmlCmYlimy8Ywg3qO98VESeHNGXoIRfsMa8ccycJG5/rEQQivpKWeKn8A8LQdiqIn
	 wMjBrBP1xdPANSWzwf+LZzdr3Rt/E6yMAvrHFIUYb5vu54m7Y58x5PvvYGSur0qRNUMCW
	 MWaQ6YiU7Lg1EXnNHNDi/VVKKC5MNk2QlqZWyrbxBfor5Fj//o8U2hc+Ou43c1Q+BqmwK
	 lMqmB9YjL+4JtwpN+lD3xhWmwSsHn1/qbkJo14I/aa+71kzTygG+Ffn7IFahdqSloMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="MdWGzIB/";
	arc=none smtp.remote-ip=209.85.208.69
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB2D606A31B
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 14:06:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EB2D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MdWGzIB/
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b3dc91781fso860231a12.0
        for <kvmarm@lists.linux.dev>; Wed, 04 Nov 2026 06:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793801186; x=1794405986; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0ZdKyKH+Ww5i9BiLpu8awrPqNj31X9LX5Wb4WFhtBGU=;
        b=MdWGzIB/0qi00W57fnxEJOEhUnwmUSDYTQW3lUywwgVp6/GkpdxzFyT+LjbehnZ8yn
         Kc+epT2ahzK1hDPPhSHpPgCyGKX0tsn/KFpYQD27bF+iHHGABKYJgk8QTOnrXIfIKGu6
         YH8yPgHF9+f4E7x1OBPMz07U0IMLHjXx4CParqfFkWI9G3AMlrd05t0SJYY9OkGc6PoP
         wN4UrQrLJmFBqM+V+zlkS46fhO+BflRN8b6IeSsxHfOpQfsa1mbq1nB/6K4titWZkD6W
         PHndUIsMJmBVAKJHwRasRF0kP3BHkuVNEGjEdmhqDza0psQgeLvgv19XCZhQkEFBDP8+
         NT+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793801186; x=1794405986;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0ZdKyKH+Ww5i9BiLpu8awrPqNj31X9LX5Wb4WFhtBGU=;
        b=JCkAAMbXbkIlhVSlhsCBWT3Y9n8M/TI+QGZoONdCAUmIxcO2lm3DNIYkG9JTyUmZ0c
         hdQogU0Yw2STGCkYjej1xHIARyPR/Co+hTxIXUO29OefXEHdFiXRWfQupd4BUQ9PrUBG
         M/JofXirZ9INsiIiCgN+8Qy9IMrliZGIeGe2Gr1upfXCzcnn757xgSqFA0SV+BnnVyhF
         hD4AlG83MvuVbUM2CWFARy8RkDFjjs3d5YnkaQnBXP3//MhG/MIVuonyupnxcaxRZYZY
         Q9s+uF4FaCoRhMuDXJ5cwpWpk7bJdiDFXqvDTVGfp/Y1j/upkO4JfJ6tTbBKf6o/cQTl
         JAfA==
X-Forwarded-Encrypted: i=1; AKwUvByUQxoGVdAirE1w6pJU+8JdD0ialrnLXUc8zta1yJR5qA5P8AtvFT+QVmuEN7w/M5ney6jn38U=@lists.linux.dev
X-Gm-Message-State: APuU4Z9UR4VU4kbQSguyYFu5waIjgbkGtEzvxIwefQuhFW11vcLhlW5c
	Rn3GoEzoN6aeIZyatmtx3WvdMzZVklQfps+4MU37zj5Fa7ZIqXD+y4lrohBSW4gHT0cgCtdruCH
	rCE7XK8bL9nHu4kJy/uY+yQ==
X-Received: from edsk22.prod.google.com ([2002:aa7:d8d6:0:b0:6b5:677a:3c36])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:a303:b0:6b4:329:109c with SMTP id 4fb4d7f45d1cf-6b4d3392457mr8652022a12.4.1793801185529;
 Wed, 04 Nov 2026 06:06:25 -0800 (PST)
Date: Wed,  4 Nov 2026 14:06:08 +0000
In-Reply-To: <20261104140612.137869-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261104140612.137869-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261104140612.137869-2-vdonnefort@google.com>
Subject: [PATCH v2 1/5] KVM: arm64: Add missing exception classes to kvm_arm_exception_class
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

kvm_arm_exception_class is missing several exception classes defined in
esr.h, causing the event kvm_exit and hyp event hyp_enter to log an
unknown ESR. Add the missing entries and while at it, order them by
their value.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index ba0062849be9..91ef5d27b491 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -244,14 +244,15 @@
 
 #define kvm_arm_exception_class \
 	ECN(UNKNOWN), ECN(WFx), ECN(CP15_32), ECN(CP15_64), ECN(CP14_MR), \
-	ECN(CP14_LS), ECN(FP_ASIMD), ECN(CP10_ID), ECN(PAC), ECN(CP14_64), \
-	ECN(SVC64), ECN(HVC64), ECN(SMC64), ECN(SYS64), ECN(SVE), \
-	ECN(IMP_DEF), ECN(IABT_LOW), ECN(IABT_CUR), \
-	ECN(PC_ALIGN), ECN(DABT_LOW), ECN(DABT_CUR), \
-	ECN(SP_ALIGN), ECN(FP_EXC32), ECN(FP_EXC64), ECN(SERROR), \
+	ECN(CP14_LS), ECN(FP_ASIMD), ECN(CP10_ID), ECN(PAC), ECN(OTHER), \
+	ECN(CP14_64), ECN(BTI), ECN(ILL), ECN(SVC32), ECN(HVC32), ECN(SMC32), \
+	ECN(SVC64), ECN(HVC64), ECN(SMC64), ECN(SYS64), ECN(SVE), ECN(ERET), \
+	ECN(FPAC), ECN(SME), ECN(IMP_DEF), ECN(IABT_LOW), ECN(IABT_CUR), \
+	ECN(PC_ALIGN), ECN(DABT_LOW), ECN(DABT_CUR), ECN(SP_ALIGN), ECN(MOPS), \
+	ECN(FP_EXC32), ECN(FP_EXC64), ECN(GCS), ECN(SERROR), \
 	ECN(BREAKPT_LOW), ECN(BREAKPT_CUR), ECN(SOFTSTP_LOW), \
 	ECN(SOFTSTP_CUR), ECN(WATCHPT_LOW), ECN(WATCHPT_CUR), \
-	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64), ECN(ERET)
+	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64)
 
 #define kvm_mode_names				\
 	{ PSR_MODE_EL0t,	"EL0t" },	\
-- 
2.56.0.455.g6c5a503b38-goog

