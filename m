Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AB73ACF12
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 20:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782938627; cv=none; b=Jq1o8Kl+mPUJG11GMOt84D2rhHCjiVZ3MpUwyhKAfrHtLDhIJd5/hTlK+7RaV7mKMIPhznCwUbTNg/wmhH2gnQaq+IvgAXV5//6b0JZqAJiN6bbAfko7//2ZHegkOaPVHgwHmr2D2aX5kKIM6X71OG6szc895z8prKOjpJqAmM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782938627; c=relaxed/simple;
	bh=Qn218Vl/+isGAI3Z1DhmCzpq+tptNiE/Fo8jVmC6SRo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Edz97X8qwUsfGXTT+4BxjrKbKoP3jdiN0kJQwrP3oey5vtRNnDGegZtMX0QMelJbo32WvnqwFO5FFj+59QboIpd8iWmbOeABM3b1gXDfS1XaIxiVFiZdld4GRY7D0wfX+7Z7J9zvpPbftU+VKn25yBZMUE75j5z1f4CIGyV48XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H4D1VopJ; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H4D1VopJ"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-495f637105eso1715045b6e.2
        for <kvmarm@lists.linux.dev>; Wed, 01 Jul 2026 13:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782938625; x=1783543425; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tzU5geEAdlGdzp5rSJKP+9OB0IsgaotJw1U5Q6pxjvc=;
        b=H4D1VopJKFHLR/NFnU4YsBhLAkLzjRamP7def8QvRXs+T9hyYGfTCDmqob6LqdjknD
         EY6kx3MT4ddQ0VJ2jalAImSPwJQ7qx332CX82J0SG50Max1D8/jokrqoy6CuvSwpQ2ls
         Dsa0aGOWkXWpuo376aFzP0YysQ/XiILCJceaFU2mj9fJk00mfk27+nVJ8J0xoXX5pWCM
         NOJ8mOfp5kbjAk1NtlK56rNMsjvyrAoE5xxPR3INZgmpgHhXajp9oOTs76AYx0VyEWjq
         tCGOBJaGcQPcH9vZk6X2dktVfBzgX9Fk1Lp1TD0OyN+Lwj2z2s0OC6QDlg9Du1SWGtAv
         0mLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782938625; x=1783543425;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tzU5geEAdlGdzp5rSJKP+9OB0IsgaotJw1U5Q6pxjvc=;
        b=WvJ5Trr/vxY3B187If+CiGII667scD1tgNS3PlDVwFbhix57oc3gA188CUfqpgqUhX
         6i6dpNOzMk+zYTTNz0zWo6oBpPiI4Al86WKs1vM6ZoOh2yZK33CVLd4SdHqpul7phXNX
         okqLWEyM9rgYN3658HoHmwpe7RRscdR+li6dl7ak4tz9LaJe88ccKOQIat162qXZncLT
         FfIYa8Bii33TCP5XFcl63OZULx/f36JxpQS7SGyXMBGklaLQBahw5yJBFbKKVRF2mvPH
         dlIESpEi3xWzK9TwnO4riuCg7cac6mr+cC0QtbeHKe62vd1GjIQV8y5B2iYYkmiRrGFm
         5olw==
X-Forwarded-Encrypted: i=1; AFNElJ+eYPhmRI0WbY/Zwbo3ePxDHwxtL+ukbJnmnIibkQu/AF2oAMPbwl3P0s1eOs+wZxPi8ioE7HY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxIy6YOIz1DT6UKlFoFjr0HREfsT6UZHuU5UuJJSccuOPXUQKeJ
	jCYyVb1uLFWtEajhwMUeFtdFW6L/DB2qZMPsfUCJyiZUDuApBT/2Xg2JvZVnByjFgk7u9Vav14C
	PrHQyDDCrE6cFt4MqZxJVy5GNNg==
X-Received: from iodr16-n1.prod.google.com ([2002:a05:6602:6c90:10b0:993:783e:f2bb])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:5088:b0:487:6930:d50 with SMTP id 5614622812f47-4960efba909mr1932765b6e.35.1782938625160;
 Wed, 01 Jul 2026 13:43:45 -0700 (PDT)
Date: Wed,  1 Jul 2026 20:43:39 +0000
In-Reply-To: <20260701204342.2654385-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260701204342.2654385-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260701204342.2654385-3-coltonlewis@google.com>
Subject: [PATCH 2/5] arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0
 is negative
From: Colton Lewis <coltonlewis@google.com>
To: stable@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 3944382fa6f22b54bc3624c9657b98ec34b5ba59 ]

For CPUs that have ID_AA64MMFR4_EL1.E2H0 as negative, it is important
to avoid the boot path that sets HCR_EL2.E2H=0. Fortunately, we
already have this path to cope with fruity CPUs.

Tweak init_el2 to look at ID_AA64MMFR4_EL1.E2H0 first.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20240122181344.258974-8-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kernel/head.S | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 6517bf2644a08..e32c8dd0b17a7 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -589,25 +589,32 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
 	mov_q	x1, INIT_SCTLR_EL1_MMU_OFF
 
 	/*
-	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1,
-	 * making it impossible to start in nVHE mode. Is that
-	 * compliant with the architecture? Absolutely not!
+	 * Compliant CPUs advertise their VHE-onlyness with
+	 * ID_AA64MMFR4_EL1.E2H0 < 0. HCR_EL2.E2H can be
+	 * RES1 in that case.
+	 *
+	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1, but
+	 * don't advertise it (they predate this relaxation).
 	 */
+	mrs_s	x0, SYS_ID_AA64MMFR4_EL1
+	ubfx	x0, x0, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
+	tbnz	x0, #(ID_AA64MMFR4_EL1_E2H0_SHIFT + ID_AA64MMFR4_EL1_E2H0_WIDTH - 1), 1f
+
 	mrs	x0, hcr_el2
 	and	x0, x0, #HCR_E2H
-	cbz	x0, 1f
-
+	cbz	x0, 2f
+1:
 	/* Set a sane SCTLR_EL1, the VHE way */
 	pre_disable_mmu_workaround
 	msr_s	SYS_SCTLR_EL12, x1
 	mov	x2, #BOOT_CPU_FLAG_E2H
-	b	2f
+	b	3f
 
-1:
+2:
 	pre_disable_mmu_workaround
 	msr	sctlr_el1, x1
 	mov	x2, xzr
-2:
+3:
 	__init_el2_nvhe_prepare_eret
 
 	mov	w0, #BOOT_CPU_MODE_EL2
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

