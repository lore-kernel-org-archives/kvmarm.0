Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C730D18C32A
	for <kvmarm@lists.linux.dev>; Fri, 23 Aug 2024 17:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724435928; cv=none; b=COcpH3huvv/oM5oZIvI/3LyYXmGvDGlNmg2jP8thxP/rnXmJCVNhaznOp1/FrbkP2XDk1bg34I5lnYXSA9EDKr0oej/Hcr5LGYdXWbzDLgsOvLD5+KqTQKRtRn2fTgcOrrwE/OB21c+WakucNRmzz1t6a07C8N+ko+ilqGYeq6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724435928; c=relaxed/simple;
	bh=TC8Ix36/fGXMyqHLZyB5PpiW2Dfl6b3geb+DTkbFUsA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=htWaf5KwMkLqgj5MqRw0Kj3XyXiY7k//fnDBVkqmQ6sIKHVxqIMSpstJKgB04yqUUlIIwvaWjjQWwhRI73C7XlFg8OF8d3gYd0ihkyCtLUn9sru1y9kSCp76qZKXmXaLNTfsZwXAL9r3NzWbJWwZkztPB85iE/FHExxRpycBVtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RpgSVxW8; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RpgSVxW8"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e163641feb9so4385370276.0
        for <kvmarm@lists.linux.dev>; Fri, 23 Aug 2024 10:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724435926; x=1725040726; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zLv13f/DBEqm51hY6VfaGMHBiQ0T7a5MTFlVVUYHQ7E=;
        b=RpgSVxW8vFFPjqfvJobFlUoEhbazSYgrEbtj0IsSKotxP69hu13eEcUK1PltjGROXb
         jPtlBdPouCRs2A8cjMEIylM/xbVpyhyM2u+ImM+/x0xv8ZYHJ6woCiGvy0zG3bN2gS7t
         IbtKFJ1fYkysPXftYCfwPQkXTQtbAgWD1kuNAsaatuXCgyNVJ4rLVE11kQt0Qtt/uY9O
         8ZTF2TXnr3Yc/8jQy+gtgB2JXhWvUJCwoJZQACqkkS53eXzgRwW4lkakGAnZVru+UHGt
         2A1HsgHLfQrATQGnlwvVM9KaDyDXDdcS5CIhib0t8d9oTOXNdXN3BKLmMZvLkCwzco4M
         mc1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724435926; x=1725040726;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zLv13f/DBEqm51hY6VfaGMHBiQ0T7a5MTFlVVUYHQ7E=;
        b=h9VHTSb86nyT9Isf86P/lFCsXRofhXDYC+9M+ktwZLK6Hm32kJXcBwgzT46VZ+y926
         ZoGCYWs2bYrMTuAx1/hBWaV77MV2sQxQhGHSsT/IkwqGanZ9rAdh6aVGhGUO4y3bc9+g
         rf9n8mnDGvQyny+x/82kkWRI8+rwoFzVJH8e0gK+fkaLBcBzfYcm8FSMBNqD1LPA52ww
         upLMgrfEF+4jZcfUK/SM2qIGPdjBwZ4yOXmn+GeDNQfRJFMsKuemYgjXSXCS4iDYd8n4
         M9eoqFMNCCqRaiqO9zwyXKLoURwj+UREwW+gQh6ILHB+K5ijfVb1G8uwo2CCkqwq6pxv
         FnjQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+uNV4OdHYm/Np8pD6bD8pRaO5Ydq0ja86P/w51fBKi1DSpbCo57AjFE5LrLsiuXPCYYP2VUA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzmdTvDwxxNxaGLP4Tka5dNm2zc+ACKy74j8qk5XwzICLc3ynYE
	w0tnTDJOINNlyAgCc77d9nUIZ6MZLiVlyXZhr4eRBifvDgYnGT48vB1nFcTbWPM2nYcH39mKiNA
	VmK7UiysrfZt7K2G8TifX8A==
X-Google-Smtp-Source: AGHT+IHgfE3XWfOJ0gaXcFJcDYaCkx3ejXevtjofbCecDoxYmblyUxbaaB4DAMf8FQgWwZ8JiJyOc45ebtxhMsItjw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:bf92:0:b0:e16:67b0:2de3 with SMTP
 id 3f1490d57ef6-e17a7aa7edfmr54278276.5.1724435925659; Fri, 23 Aug 2024
 10:58:45 -0700 (PDT)
Date: Fri, 23 Aug 2024 17:58:35 +0000
In-Reply-To: <20240823175836.2798235-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240823175836.2798235-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823175836.2798235-2-coltonlewis@google.com>
Subject: [PATCH v6 1/2] KVM: selftests: Ensure pending interrupts are handled
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
2.46.0.295.g3b9ea8a38a-goog

