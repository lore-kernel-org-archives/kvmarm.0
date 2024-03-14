Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5481B81A
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 23:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458813; cv=none; b=jp2+rIj47OnwSMHK9lIjogTro/FFtzXaRSRfpjcyRnDS3wpcRJ59dVGnbld8FL0e2ps1PLGBhCE5UZGFlNLAPMFP4Xv37iuT/64yb5H/gCfm9K/qLFsLEO1Wh9HKY6WjsGLJGzCibbu8pKHnFDAzrweBmyRam4+Vt+wGC/hGCD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458813; c=relaxed/simple;
	bh=meFKVgZcplsrdf4nThtnD2hQo2z4gltSGTp4DLCnmJ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b4idMfT6aSG4WdYv1qAN9otXAM1X/D0nJw+N7LfFP48irBefkxGilLKL5z0ikix2IYC8qi9Klbu5dYKEfTHGH50a6W7Y7iiaVof5dt2ijroiEEXUeELHH6Cv6aF8yaEjbBM5KYZaRM0nWuiJG8nrHDBBiYKyQ+HTfYuGinp8XA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mzCgcO+a; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mzCgcO+a"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a03635590so24311577b3.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 16:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458811; x=1711063611; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oB3ZfcSJ5G1gMIeNmqomMwFWPYu8/DXA5zj+kntGd24=;
        b=mzCgcO+apm2IrYTfEhbR215uWPgwjaAAXPrRjSISBNbQbTTusDC3UQnguqeFXABpUM
         M59my9XTImXR6w2yTHVJYjhiBZnyPQwVya3UNzePScvrjPk5BnZ7Jfly3U5hGap+x1yE
         sGHd4sFIx7jWMooRBM+1Bp5YtdnpK9ow1eKvgFGtxSuid/LYh25JksJTD2zS5xHRdXED
         jDiDNQKcnYXOXufjDN7SIDzlqvrj2q+TxHRhIf1Li5UmKGi7wDMPqas/KvO5qHY9PREe
         Ho2G5ievuYpfnEvRQ8rI6bmeizdLdfwClMw+qdXVKheB5XxZHFNO072prSgxrrYePwxH
         JhIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458811; x=1711063611;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oB3ZfcSJ5G1gMIeNmqomMwFWPYu8/DXA5zj+kntGd24=;
        b=d5eR9Lxt4FZ7IO+ohFw9U1Rago0wXFe9yV/CfcYO1MwTN1xSmvLkeFtfCtU1GFL4KC
         tPZrjUxOKlNsTQ1fbF200e4hPJVJ5ferGaLKp252y0Fl1nYTMG5RAD4VP/6hVttrYRdX
         EbXEzjIrdjxGM0OcIuZiDqRaI6WxNDob91mMaRY2zyCDy2LMtXFv/rrMS5XNBnjQNiUT
         5rcd12du/z1ZmqjDRWEn5i3EWOZp9xRh0MUNemqHcyqJ4TkHKHjqT5aQyeTIp4hin4Su
         01SirthXrD+SyPDPunS8ASpDpbHsdGZ+onCsWYmc4ORRxq9sGo/ry6wSfr7rPQvRWCnc
         yJAQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6pa51QpDyZUO/mbzO6IBuiVZw5OGaLKPorWnB0h4+d6gZvj2YZolXKMNBvNGnRq/86ceX1FIMpTpwZai1DdBu4lMYt95I
X-Gm-Message-State: AOJu0YzYCovWy2MJT9m/PHssqBgjzm1fienlc2a1J+3HZaoVgJl/DVFT
	UngF6JbPBVTWXes56QczxXVbwxxzNp6x90S3myfSZYtsfIoo2fwV5LnegUl3MPG2/TlXOslTdiC
	I+A==
X-Google-Smtp-Source: AGHT+IHtBiTnO989+qzsWd/+jqel2tzrmASDdXlpQSt9dAnbWaw8Q3AQpPaqLMF1m7pFqRCnpY9R0RVtBJU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e288:0:b0:60a:56c2:a61f with SMTP id
 l130-20020a0de288000000b0060a56c2a61fmr797989ywe.8.1710458810918; Thu, 14 Mar
 2024 16:26:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:25 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-7-seanjc@google.com>
Subject: [PATCH 06/18] KVM: selftests: Rework platform_info_test to actually
 verify #GP
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Rework platform_info_test to actually handle and verify the expected #GP
on RDMSR when the associated KVM capability is disabled.  Currently, the
test _deliberately_ doesn't handle the #GP, and instead lets it escalated
to a triple fault shutdown.

In addition to verifying that KVM generates the correct fault, handling
the #GP will be necessary (without even more shenanigans) when a future
change to the core KVM selftests library configures the IDT and exception
handlers by default (the test subtly relies on the IDT limit being '0').

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/platform_info_test.c | 66 +++++++++----------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
index cdad7e2124c8..6300bb70f028 100644
--- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
+++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
@@ -26,40 +26,18 @@
 static void guest_code(void)
 {
 	uint64_t msr_platform_info;
+	uint8_t vector;
 
-	for (;;) {
-		msr_platform_info = rdmsr(MSR_PLATFORM_INFO);
-		GUEST_ASSERT_EQ(msr_platform_info & MSR_PLATFORM_INFO_MAX_TURBO_RATIO,
-				MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
-		GUEST_SYNC(0);
-		asm volatile ("inc %r11");
-	}
-}
+	GUEST_SYNC(true);
+	msr_platform_info = rdmsr(MSR_PLATFORM_INFO);
+	GUEST_ASSERT_EQ(msr_platform_info & MSR_PLATFORM_INFO_MAX_TURBO_RATIO,
+			MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
 
-static void test_msr_platform_info_enabled(struct kvm_vcpu *vcpu)
-{
-	struct ucall uc;
+	GUEST_SYNC(false);
+	vector = rdmsr_safe(MSR_PLATFORM_INFO, &msr_platform_info);
+	GUEST_ASSERT_EQ(vector, GP_VECTOR);
 
-	vm_enable_cap(vcpu->vm, KVM_CAP_MSR_PLATFORM_INFO, true);
-	vcpu_run(vcpu);
-	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
-
-	switch (get_ucall(vcpu, &uc)) {
-	case UCALL_SYNC:
-		break;
-	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT(uc);
-	default:
-		TEST_FAIL("Unexpected ucall %lu", uc.cmd);
-		break;
-	}
-}
-
-static void test_msr_platform_info_disabled(struct kvm_vcpu *vcpu)
-{
-	vm_enable_cap(vcpu->vm, KVM_CAP_MSR_PLATFORM_INFO, false);
-	vcpu_run(vcpu);
-	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_SHUTDOWN);
+	GUEST_DONE();
 }
 
 int main(int argc, char *argv[])
@@ -67,16 +45,38 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	uint64_t msr_platform_info;
+	struct ucall uc;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_MSR_PLATFORM_INFO));
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
 	msr_platform_info = vcpu_get_msr(vcpu, MSR_PLATFORM_INFO);
 	vcpu_set_msr(vcpu, MSR_PLATFORM_INFO,
 		     msr_platform_info | MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
-	test_msr_platform_info_enabled(vcpu);
-	test_msr_platform_info_disabled(vcpu);
+
+	for (;;) {
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			vm_enable_cap(vm, KVM_CAP_MSR_PLATFORM_INFO, uc.args[1]);
+			break;
+		case UCALL_DONE:
+			goto done;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+		default:
+			TEST_FAIL("Unexpected ucall %lu", uc.cmd);
+			break;
+		}
+	}
+
+done:
 	vcpu_set_msr(vcpu, MSR_PLATFORM_INFO, msr_platform_info);
 
 	kvm_vm_free(vm);
-- 
2.44.0.291.gc1ea87d7ee-goog

