Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7972F41
	for <kvmarm@lists.linux.dev>; Fri,  9 Aug 2024 18:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723228699; cv=none; b=Y3acNQ7A/nhAp1ThiIi52tROAu4M63ghAE6E3+q6l9V0HeCRSyNj71sFx/WfwI53cc9InltsSa4j6Sh9ceYUNvDdWxnNtOMSdWrOcyIUbAJFvCLN+uSIZNaQ8FGycxNzOCX7yEkro+Jmzh7c+QKN8UbqlfaBsN6ogavKW5v14U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723228699; c=relaxed/simple;
	bh=z8cWETLfeelpsbjyY0RVg3S8QOFntzeUcxoFKGzI+5Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DrCbMV3wLXGhlsyNeCf5BQnQnAJ9/PAP+9oqMTsMHepDh4B2Y9enCIA0hTsc9/EunRX5gNQQev/7SVa628d7kmw1o2er8Hz5B5Nn26E9n6g0k/0rWnr0w7N4YY4WdSNSWolL0IozcbaDi4ouuKVOPVnjKWv9i/G6LLEyyGUIKHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hhi1LYzZ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hhi1LYzZ"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e05e9e4dfbeso4243638276.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Aug 2024 11:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723228697; x=1723833497; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eKGu5OXwE/hWG2bMxqy/PoB6z3BlOaKV4IBDRrUObAs=;
        b=hhi1LYzZydoYgdCjh+c6UTYG9pSZQHcITQZwC6F3A87qcInbn5XZI4CMVC2Hdm5bto
         TXq+6apmO3U7pCYVV7afrhMo56ymhhl97bt06NEZsjG5KmQVCNDtkRLnrLw8t9HvEjxZ
         heye2iZbkk1VcwVppJydrbnP01dIJF1/9n7yBL+UQkFFEBV+wf0iqBwxjEiYei/vIxuV
         GRqaPw5jsTLv9ZP7PrqLG+gPTtUR5zNu4gQS+DDNym8FOZ6oja8QgdBhH/rnsuQT/Dpp
         Xk5Xc413vOY2p2tOTSLgMrxe5Q3riuzm7tUFjnbq9DZlyTH6K1iloEGK7H2IzutnEiWN
         uxuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723228697; x=1723833497;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eKGu5OXwE/hWG2bMxqy/PoB6z3BlOaKV4IBDRrUObAs=;
        b=OpBTEjkwSNHRwfowr26mq2JtACbYrFkuvZyedYSHXPyIMVny3rXSj1TgEkBy1cI/cU
         EWOrWhS9QLx2FVmpVs871/r6QkpDkJi3bbl5uVuieBcV8yto5HafmOh18FecHfgcKu/I
         uNPmijqUWkm5JFkl0UboTe+mkU+NFlOhVQSvSuSuGYYVAGcCOgPWKzFzXaCd7uV8pI2c
         l9FthV6jLNKCCBrkl+y6hrWly9Mm2Pt+e+SSpLMSuw9gIclFDhG3su96gEcknCSkcG95
         HlCPe+XYByFK6n2jDt5bO1eOP3jwW25HDvymbpBOaE/V4uhbgKOhbOPaBNjHAVszsK/L
         rt9g==
X-Forwarded-Encrypted: i=1; AJvYcCWTCy4Q60CazKdVF7XtnSKBYlN9kzpSSreKDKi2lWNEp8MPeJyUCkHvZVQoy2y94xTRNvdHWZuPDOOwhpV4DNPxkDFEEZuN
X-Gm-Message-State: AOJu0Yys1HSyKROvavPeQEgFwdUl6Ai9t/xbDjCOrc3qORBIJwb7tF1/
	C/iOZDShsEHUcvAATlJRQf3DWW8SJ8DHzInIw0IEKK1KDJGtilICPbkYGqYQJxv2RadrVQ3OdqU
	gYFfxF669kkpb7UdQwReS/g==
X-Google-Smtp-Source: AGHT+IH6o1VN3yBM641/JDVgDhIluIEuwPASTzC6s9TvXRuzgn4u60dgcL8d5jJ+CKLoRta5OwQR2leUR2cDrWqLhQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:9a86:0:b0:e0e:4537:6e92 with SMTP
 id 3f1490d57ef6-e0eb993b146mr42483276.6.1723228696721; Fri, 09 Aug 2024
 11:38:16 -0700 (PDT)
Date: Fri,  9 Aug 2024 18:38:01 +0000
In-Reply-To: <20240809183802.3572177-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240809183802.3572177-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809183802.3572177-2-coltonlewis@google.com>
Subject: [PATCH v5 1/2] KVM: selftests: Ensure pending interrupts are handled
 in arch_timer test
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Break up the asm instructions poking daifclr and daifset to handle
interrupts. R_RBZYL specifies pending interrupts will be handle after
context synchronization events such as an ISB.

Introduce a function wrapper for the WFI instruction.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c        | 11 +++++------
 .../testing/selftests/kvm/include/aarch64/processor.h |  3 +++
 tools/testing/selftests/kvm/lib/aarch64/processor.c   |  6 ++++++
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index a51dbd2a5f84..f4ac28d53747 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -269,13 +269,12 @@ static void guest_inject(struct test_args *args,
 	KVM_INJECT_MULTI(cmd, first_intid, num);
 
 	while (irq_handled < num) {
-		asm volatile("wfi\n"
-			     "msr daifclr, #2\n"
-			     /* handle IRQ */
-			     "msr daifset, #2\n"
-			     : : : "memory");
+		wfi();
+		local_irq_enable();
+		isb(); /* handle IRQ */
+		local_irq_disable();
 	}
-	asm volatile("msr daifclr, #2" : : : "memory");
+	local_irq_enable();
 
 	GUEST_ASSERT_EQ(irq_handled, num);
 	for (i = first_intid; i < num + first_intid; i++)
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 9b20a355d81a..de977d131082 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -243,4 +243,7 @@ void smccc_smc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
 	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
 	       uint64_t arg6, struct arm_smccc_res *res);
 
+/* Execute a Wait For Interrupt instruction. */
+void wfi(void);
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 0ac7cc89f38c..fe4dc3693112 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -639,3 +639,9 @@ void vm_vaddr_populate_bitmap(struct kvm_vm *vm)
 	sparsebit_set_num(vm->vpages_valid, 0,
 			  (1ULL << vm->va_bits) >> vm->page_shift);
 }
+
+/* Helper to call wfi instruction. */
+void wfi(void)
+{
+	asm volatile("wfi");
+}
-- 
2.46.0.76.ge559c4bf1a-goog

