Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A52049F74
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 17:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Y5UGUq53"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a1915034144so142262766b.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 09:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701882168; x=1702486968; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HY3/IKmkz8hCxSR9XqKhZvr4gqtwY0S5JXo3M770QTA=;
        b=Y5UGUq53UUvfb8g3iLjO2Wl3poySVJHW5FMNWpP97BPrVBHKsp82y5j6X4rlchyTfc
         AI989cQh7oKGPWyFvYlU14nyxnJgueBoEdjNEIFhZveeVVt7snYThSyON4T4QRhMXP97
         uXrG0s/IJArmcLYhMLCXbvGhQlbU5G4Fp/K/h8Z0X6t9mNMWxv9srdaH2PhYyKY3mQOj
         6bnEY2il8352UKhPYjhXh7wieTROTIanTelaZfxy9aspmB/o3Re9G8dKVrBI5KWGgy0C
         nYQ7c7LVCKxONON/Q9DRHLUxMhwaG7B7iL4aOw0QZArltWDeGmEioNgaoLa1CiEcGmsa
         FS5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701882168; x=1702486968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HY3/IKmkz8hCxSR9XqKhZvr4gqtwY0S5JXo3M770QTA=;
        b=iTqa6QU2KsS+edsMzOY2WTc1zXX9Rg+5D6x2lXy2edkabZ6h48/y4osrBUpS9iJ1BH
         h1isF9GU5bS44oF79cpgL1M58vpvmQtaYHTgKl+0FFjNjFc8sPwBR3gLIs2UiWko//Rc
         3fLulJQwtjdzQPVGgn+lANazwxtxfiGcBDjdVjMVydP6rQw1oW3+IASjTnNBvxHsIyRe
         JLmYt/17dQZ20XiL+vwg3clT4VqnEbrqg7LhIYLpaV+y2qYIRNBEhzNym1SlcPIG2w82
         P0HCGB4/OzWVWo9FTlu66a+Qa9nwyRRhBUlpZVcnv4GdnPayAIwy7gUF18Ei1A7g4JvD
         ZUhw==
X-Gm-Message-State: AOJu0Yw1bURx7NUGNRSNZytIbT1t0Yl65dqN8GncGSoI8KcGzYN4OzAq
	6veKrPGDQEu5tTksSxBAi7NOkg==
X-Google-Smtp-Source: AGHT+IG+765FS5RSLiikFQUhOKhXe8bzsuZDyk5lz9HA+46hxIbzOTrUiczonQnHZ/+e4wuegS5r1Q==
X-Received: by 2002:a17:906:f2cf:b0:a1b:e80a:b68 with SMTP id gz15-20020a170906f2cf00b00a1be80a0b68mr703662ejb.143.1701882168538;
        Wed, 06 Dec 2023 09:02:48 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id n16-20020a17090625d000b00a1e081369a9sm177592ejb.23.2023.12.06.09.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 09:02:48 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	anup@brainfault.org,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com
Subject: [PATCH 4/5] KVM: selftests: s390x: Remove redundant newlines
Date: Wed,  6 Dec 2023 18:02:46 +0100
Message-ID: <20231206170241.82801-11-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231206170241.82801-7-ajones@ventanamicro.com>
References: <20231206170241.82801-7-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit

TEST_* functions append their own newline. Remove newlines from
TEST_* callsites to avoid extra newlines in output.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 .../selftests/kvm/lib/s390x/processor.c       |  2 +-
 tools/testing/selftests/kvm/s390x/resets.c    |  4 ++--
 .../selftests/kvm/s390x/sync_regs_test.c      | 20 +++++++++----------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index 15945121daf1..f6d227892cbc 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -198,7 +198,7 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
 	int i;
 
 	TEST_ASSERT(num >= 1 && num <= 5, "Unsupported number of args,\n"
-		    "  num: %u\n",
+		    "  num: %u",
 		    num);
 
 	va_start(ap, num);
diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index e41e2cb8ffa9..357943f2bea8 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -78,7 +78,7 @@ static void assert_noirq(struct kvm_vcpu *vcpu)
 	 * (notably, the emergency call interrupt we have injected) should
 	 * be cleared by the resets, so this should be 0.
 	 */
-	TEST_ASSERT(irqs >= 0, "Could not fetch IRQs: errno %d\n", errno);
+	TEST_ASSERT(irqs >= 0, "Could not fetch IRQs: errno %d", errno);
 	TEST_ASSERT(!irqs, "IRQ pending");
 }
 
@@ -199,7 +199,7 @@ static void inject_irq(struct kvm_vcpu *vcpu)
 	irq->type = KVM_S390_INT_EMERGENCY;
 	irq->u.emerg.code = vcpu->id;
 	irqs = __vcpu_ioctl(vcpu, KVM_S390_SET_IRQ_STATE, &irq_state);
-	TEST_ASSERT(irqs >= 0, "Error injecting EMERGENCY IRQ errno %d\n", errno);
+	TEST_ASSERT(irqs >= 0, "Error injecting EMERGENCY IRQ errno %d", errno);
 }
 
 static struct kvm_vm *create_vm(struct kvm_vcpu **vcpu)
diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
index 636a70ddac1e..43fb25ddc3ec 100644
--- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
@@ -39,13 +39,13 @@ static void guest_code(void)
 #define REG_COMPARE(reg) \
 	TEST_ASSERT(left->reg == right->reg, \
 		    "Register " #reg \
-		    " values did not match: 0x%llx, 0x%llx\n", \
+		    " values did not match: 0x%llx, 0x%llx", \
 		    left->reg, right->reg)
 
 #define REG_COMPARE32(reg) \
 	TEST_ASSERT(left->reg == right->reg, \
 		    "Register " #reg \
-		    " values did not match: 0x%x, 0x%x\n", \
+		    " values did not match: 0x%x, 0x%x", \
 		    left->reg, right->reg)
 
 
@@ -82,14 +82,14 @@ void test_read_invalid(struct kvm_vcpu *vcpu)
 	run->kvm_valid_regs = INVALID_SYNC_FIELD;
 	rv = _vcpu_run(vcpu);
 	TEST_ASSERT(rv < 0 && errno == EINVAL,
-		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d\n",
+		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d",
 		    rv);
 	run->kvm_valid_regs = 0;
 
 	run->kvm_valid_regs = INVALID_SYNC_FIELD | TEST_SYNC_FIELDS;
 	rv = _vcpu_run(vcpu);
 	TEST_ASSERT(rv < 0 && errno == EINVAL,
-		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d\n",
+		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d",
 		    rv);
 	run->kvm_valid_regs = 0;
 }
@@ -103,14 +103,14 @@ void test_set_invalid(struct kvm_vcpu *vcpu)
 	run->kvm_dirty_regs = INVALID_SYNC_FIELD;
 	rv = _vcpu_run(vcpu);
 	TEST_ASSERT(rv < 0 && errno == EINVAL,
-		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d\n",
+		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d",
 		    rv);
 	run->kvm_dirty_regs = 0;
 
 	run->kvm_dirty_regs = INVALID_SYNC_FIELD | TEST_SYNC_FIELDS;
 	rv = _vcpu_run(vcpu);
 	TEST_ASSERT(rv < 0 && errno == EINVAL,
-		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d\n",
+		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d",
 		    rv);
 	run->kvm_dirty_regs = 0;
 }
@@ -125,12 +125,12 @@ void test_req_and_verify_all_valid_regs(struct kvm_vcpu *vcpu)
 	/* Request and verify all valid register sets. */
 	run->kvm_valid_regs = TEST_SYNC_FIELDS;
 	rv = _vcpu_run(vcpu);
-	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
+	TEST_ASSERT(rv == 0, "vcpu_run failed: %d", rv);
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
 	TEST_ASSERT(run->s390_sieic.icptcode == 4 &&
 		    (run->s390_sieic.ipa >> 8) == 0x83 &&
 		    (run->s390_sieic.ipb >> 16) == 0x501,
-		    "Unexpected interception code: ic=%u, ipa=0x%x, ipb=0x%x\n",
+		    "Unexpected interception code: ic=%u, ipa=0x%x, ipb=0x%x",
 		    run->s390_sieic.icptcode, run->s390_sieic.ipa,
 		    run->s390_sieic.ipb);
 
@@ -161,7 +161,7 @@ void test_set_and_verify_various_reg_values(struct kvm_vcpu *vcpu)
 	}
 
 	rv = _vcpu_run(vcpu);
-	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
+	TEST_ASSERT(rv == 0, "vcpu_run failed: %d", rv);
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
 	TEST_ASSERT(run->s.regs.gprs[11] == 0xBAD1DEA + 1,
 		    "r11 sync regs value incorrect 0x%llx.",
@@ -193,7 +193,7 @@ void test_clear_kvm_dirty_regs_bits(struct kvm_vcpu *vcpu)
 	run->s.regs.gprs[11] = 0xDEADBEEF;
 	run->s.regs.diag318 = 0x4B1D;
 	rv = _vcpu_run(vcpu);
-	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
+	TEST_ASSERT(rv == 0, "vcpu_run failed: %d", rv);
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
 	TEST_ASSERT(run->s.regs.gprs[11] != 0xDEADBEEF,
 		    "r11 sync regs value incorrect 0x%llx.",
-- 
2.43.0

