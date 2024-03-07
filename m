Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A1B134CFC
	for <kvmarm@lists.linux.dev>; Thu,  7 Mar 2024 18:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709836799; cv=none; b=vB/x3KjZ/VeSeKFBcMPK4B6JqNAhVlimSIk0tkBXFsjN0MJEOLhO1iryqcJbXXPKcf4cWbJNL1NUVgy0YjIXIcgjhPgTjiL70WvByIyeOKBGtV3Y2XqitDhdT+CAmTQv2pPxFfZ3tg1BHtHdSZaOvnqD1IA70tm5U4QUtM7D8iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709836799; c=relaxed/simple;
	bh=EqSTDy+4GtYjv80AJs+xWqwKelAcMKDMphBZFDji5Kg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mHfXZK0emUyc6RWSO4An0CSQQbARtMRLB8g7GJuvR/EXGtjJxOkCmnhHkAqb4JNYXGc0sLcYTlKQYbqtRAg/3hjxGGxq6P0kaLeeMVHqOom+UmU92YRs1gtA6Bm3L9TTNbKqv7P6L594Q/qVn/wA2DydR+UroZuzuKNjx1wCBPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dz2qxWtQ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dz2qxWtQ"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-609fb4fc058so1454747b3.3
        for <kvmarm@lists.linux.dev>; Thu, 07 Mar 2024 10:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709836796; x=1710441596; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qO5rBnHmkbmFXn5DB+2jWajFJFNZw3APSCtVJIvKtAM=;
        b=dz2qxWtQAtwP3KGR0w6O9U9Plx+3J6ln6aT125cq8Lixu6AkyHzw9ht6kzHRf/3EPX
         7NKrCNACFIRCzH5fqAqBkf8zXxoYjhkFzdHV/fdSA+5KFbM/UB+Zqi0zDyAyiw655r52
         C2ffq8AR7ORSHzCHbNCm2ymuVvAQSLB4YtyTA4hY448glWOkarhqq4WbRhQ0xCWW5biL
         AUSsMjOoMnhgBEwIqztsOWTlN3PbqugYye9M1X6UpDDraeLSNCJasshPNZjzomTBk6OI
         wwq+0Taz9XVmBeHkAaRHnZd3xMoO1g8fJpHEM3AM2xwaoIBN++StFig10IIC3MIT07eq
         xixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709836796; x=1710441596;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qO5rBnHmkbmFXn5DB+2jWajFJFNZw3APSCtVJIvKtAM=;
        b=An6HlLGxufY72isuyqUKeJobE/1yMgifTyEQqtZAuwTpo1k6pZJCQndC8TWvCsZnH4
         tBUbv9ATAzTa2jsxzffPfmTOpe558UHIJTrI5ATnVe0begdzbtVW6Ag9pw5I9cUIVBg9
         ssa5CyizoVboHh6DJIqdvccLW7MCsw06W53PvVRuUpLzSofRCRZadZoiCrD2XZCEjRTd
         VL+Frp1IxTR+xV4CBX0X/jETFxWeA/Uc5wstAO+xcRkXvFsM/ZkJJTV4mQzqgyJXIFgz
         nidMxZct7AQdA2bdvNQJVN5RFogLisOYyguatuWan2oVrm7QAOZ1ZpQOl3w0oO5Dnm9f
         ubrw==
X-Forwarded-Encrypted: i=1; AJvYcCUBrlNpwO/nJIHDjhw2qfO23OWSdU1azfCdjIdFWkToMwPnVhLogA3Ao3Lku9bxgbO/j/LhzVI0kCK7x+rnQRFtTYm0uFpk
X-Gm-Message-State: AOJu0Yy7nsyt4CPUimwCJ3Y/q62QHiAb/Vo7vIEGhs+9Qc4p8y8KJxqA
	P/Dx5m8O0KD1DSknSQzNffUDHfqx/giYVWGTP5pVP7Bm/u1KrSOTT0G781GBANIYbq0aiK12Y5I
	wvdL+3pGq8B0nnxYB+VtCDA==
X-Google-Smtp-Source: AGHT+IGJ9B5u301uhgzy+sZi7ffHqK5cobYQX0gYbfhhvAdIdHlxdpWdV6WN7fdpt0Z4CuJeZP5348K2Ldb0pTRGUg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:5758:0:b0:609:1fd9:f76 with SMTP
 id l85-20020a815758000000b006091fd90f76mr4226573ywb.0.1709836796578; Thu, 07
 Mar 2024 10:39:56 -0800 (PST)
Date: Thu,  7 Mar 2024 18:39:06 +0000
In-Reply-To: <20240307183907.1184775-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240307183907.1184775-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240307183907.1184775-3-coltonlewis@google.com>
Subject: [PATCH v4 2/3] KVM: arm64: selftests: Guarantee interrupts are handled
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Break up the asm instructions poking daifclr and daifset to handle
interrupts. R_RBZYL specifies pending interrupts will be handle after
context synchronization events such as an ISB.

Introduce a function wrapper for the WFI instruction.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c    | 12 ++++++------
 tools/testing/selftests/kvm/include/aarch64/gic.h |  3 +++
 tools/testing/selftests/kvm/lib/aarch64/gic.c     |  5 +++++
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index d3bf584d2cc1..85f182704d79 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -269,13 +269,13 @@ static void guest_inject(struct test_args *args,
 	KVM_INJECT_MULTI(cmd, first_intid, num);
 
 	while (irq_handled < num) {
-		asm volatile("wfi\n"
-			     "msr daifclr, #2\n"
-			     /* handle IRQ */
-			     "msr daifset, #2\n"
-			     : : : "memory");
+		gic_wfi();
+		local_irq_enable();
+		isb();
+		/* handle IRQ */
+		local_irq_disable();
 	}
-	asm volatile("msr daifclr, #2" : : : "memory");
+	local_irq_enable();
 
 	GUEST_ASSERT_EQ(irq_handled, num);
 	for (i = first_intid; i < num + first_intid; i++)
diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
index 9043eaef1076..f474714e4cb2 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
@@ -47,4 +47,7 @@ void gic_irq_clear_pending(unsigned int intid);
 bool gic_irq_get_pending(unsigned int intid);
 void gic_irq_set_config(unsigned int intid, bool is_edge);
 
+/* Execute a Wait For Interrupt instruction. */
+void gic_wfi(void);
+
 #endif /* SELFTEST_KVM_GIC_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic.c b/tools/testing/selftests/kvm/lib/aarch64/gic.c
index 9d15598d4e34..392e3f581ae0 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic.c
@@ -164,3 +164,8 @@ void gic_irq_set_config(unsigned int intid, bool is_edge)
 	GUEST_ASSERT(gic_common_ops);
 	gic_common_ops->gic_irq_set_config(intid, is_edge);
 }
+
+void gic_wfi(void)
+{
+	asm volatile("wfi");
+}
-- 
2.44.0.278.ge034bb2e1d-goog

