Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69CC146000
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 00:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755371; cv=none; b=fsq1hHJU/ptScvgC82acE69mU81xIzdJZt66Qe4+PjKDuTBfJE/Kb/uqQ67o4UgqL3wIJTkuNkNJvggk+djZJf90OtqBo8Z2iXM6IT6Qj8EA9s4KQK+FGouOlMF4cRENQ/wPSCX1M/P55w2uWxsjwfyfX0nOW2KKwHS+nI/pDlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755371; c=relaxed/simple;
	bh=tB5Y/jG/Ubvw+ASTUSDw04Dbo+k1MHeniGJPuaDceRY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JdM+RfJX0XeLFywF/P5m9eOQulJOHhBe5XO+PaglIcpfUOFsfQj6enBICFNrhkXNruJWhRIUHcVTdjiqKy4ACo7MBtYOfUsJs4seUCFJfYm1YzhUHuTVJfXiWX7neoT1+zVmLSTh9+YnMtgG7rB5Ag1ld6omJGD8GpvwiZWgo/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=09iNei2A; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="09iNei2A"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7fbcfe197d1so205311a12.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 16:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755369; x=1733360169; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/mFf9b1jkbcIPk1lRuUSamWoSedpUsq+XjDpJ8wT6fg=;
        b=09iNei2A8DGjxBcM0HsmEi237XkMtj4VEHjGT9CyJ7bprh7t7t7w1g7kWmCcgn3rJ5
         5Cwhcy59L5zzDjrWX589/G/vfwJzRRYVuiyt2UOjCYNEJyGSSP7wzaAdsNkmf8BNYuX0
         1G3kbwymSe05FTU8SZoc0bjGX6IXFwjEoXC8E+u4JtOz63rkNf/wGvKUJ4KMGDQldo3D
         TucRgh5m1+zDWrNsIDOThKTzMVeCfFhBzTsHPvDyDbHLQtKiGv903BkwJVh/qSU5sH3v
         xEnquPvJwzVAtk0sr1BQkfkslJoLjyMj6vRBaDVJafCcyjbixKLrMO3yKnqwuJ6xpYDm
         YTLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755369; x=1733360169;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/mFf9b1jkbcIPk1lRuUSamWoSedpUsq+XjDpJ8wT6fg=;
        b=MtnH+2Akq3J99rPdlUrUIacsKhVpAA8OJXMZegttaqWqOc1ExdLLwl6tcRyfydV4Yk
         N0TM8cV53GMQh3KzPALXPriICxaKeoB1MRGBOfiY8oOmdLjGDeUqszqjTMNizIhiocfD
         J7K0PaxwwiFxoePqdN6a7XpU5TkPJCPJav5+ivA2UCq0k2orufOMRxCNIi+A5IK7WnF5
         b1/6pgjgt83xTM7UzbtYKUCZVLF7UxFCNFni8n9o60PYovvFfXmAc0TINZbT1Q3Djm9L
         EMmNBP/++SwAcNRObF780rnfCYKx2FvTACU7OzaUrmDCcgQXc5QsOD0iajkO1d2V2IZE
         sGUg==
X-Forwarded-Encrypted: i=1; AJvYcCWlYFR4fTAFADv9nY+DwHADXeHxsa5i175+UaMVOlKbbrqsLi4o03o/RO55gTjrcZPitvNpLlw=@lists.linux.dev
X-Gm-Message-State: AOJu0YziHHYZBq1JIO4tQrAydGPDlAwpP4Qix2hLv/uNHDHiUos2gUMc
	5GM3mw9DAZxJWoqGnIONgtYgK1hCUIRUjSQFbY0kf5/7nwtUDX8PQ8x4jyGt9jv46imWnv9tSS0
	p+w==
X-Google-Smtp-Source: AGHT+IH5HVAxwH71e8ybYbHuEKxtEP3yXlkNICJu49WhynVenqzqkDMIejgXVsQlKc9eCbp1lS1lKkfrLgg=
X-Received: from pjbsc10.prod.google.com ([2002:a17:90b:510a:b0:2ea:d2de:f7ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a28:b0:1db:eecb:f7a1
 with SMTP id adf61e73a8af0-1e0e0b4f376mr8089233637.17.1732755368992; Wed, 27
 Nov 2024 16:56:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:42 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-12-seanjc@google.com>
Subject: [PATCH v4 11/16] KVM: selftests: Precisely limit the number of guest
 loops in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"

Run the exact number of guest loops required in mmu_stress_test instead
of looping indefinitely in anticipation of adding more stages that run
different code (e.g. reads instead of writes).

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 25 ++++++++++++++-----
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 656a837c7f49..c6bf18cb7c89 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -20,12 +20,15 @@
 static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 {
 	uint64_t gpa;
+	int i;
 
-	for (;;) {
+	for (i = 0; i < 2; i++) {
 		for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
 			vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
-		GUEST_SYNC(0);
+		GUEST_SYNC(i);
 	}
+
+	GUEST_ASSERT(0);
 }
 
 struct vcpu_info {
@@ -52,10 +55,18 @@ static void rendezvous_with_boss(void)
 	}
 }
 
-static void run_vcpu(struct kvm_vcpu *vcpu)
+static void assert_sync_stage(struct kvm_vcpu *vcpu, int stage)
+{
+	struct ucall uc;
+
+	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
+	TEST_ASSERT_EQ(uc.args[1], stage);
+}
+
+static void run_vcpu(struct kvm_vcpu *vcpu, int stage)
 {
 	vcpu_run(vcpu);
-	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_SYNC);
+	assert_sync_stage(vcpu, stage);
 }
 
 static void *vcpu_worker(void *data)
@@ -69,7 +80,8 @@ static void *vcpu_worker(void *data)
 
 	rendezvous_with_boss();
 
-	run_vcpu(vcpu);
+	/* Stage 0, write all of guest memory. */
+	run_vcpu(vcpu, 0);
 	rendezvous_with_boss();
 #ifdef __x86_64__
 	vcpu_sregs_get(vcpu, &sregs);
@@ -79,7 +91,8 @@ static void *vcpu_worker(void *data)
 #endif
 	rendezvous_with_boss();
 
-	run_vcpu(vcpu);
+	/* Stage 1, re-write all of guest memory. */
+	run_vcpu(vcpu, 1);
 	rendezvous_with_boss();
 
 	return NULL;
-- 
2.47.0.338.g60cca15819-goog

