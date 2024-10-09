Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557E3204F7A
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 15:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489022; cv=none; b=LVjSVmZzvKvyFJ4Ynh4YcdfRNziwME8iEasVhmabFbunCYYqhlgRa2rjKrk32FvJzd7X1XyynBSX3b/89INwpaBuOxleh/IRaCAQ3eQv/muGXznU3nLjU2aFMyUjbCp0WhUJjrIZOxPy/l7scic+aovJnjGca9xOzlvsyr2PUE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489022; c=relaxed/simple;
	bh=itS1mlB5ofbsTPJgxID6BNl/jc/V5lwuHkPPw41X7OE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h+00rWo3UH91zgm0151k4AcTUQeAXErePjWmhVU5otsV1ANR1mB/Eb7BBgTCgIUVAkdeyxQFpXqBHx03Pc9YEHGZ8eXckdMfY7XeHbK+3Ct0Gt34TsGgzt/MixmoKNDNA0QWKuz2XfQgsH1kjX3z/Ad3TaydLjtroS8Zkw2AbK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0fID8NlO; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0fID8NlO"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e2270a147aso326187b3.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Oct 2024 08:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489020; x=1729093820; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HIeWF4AKDrrEZVf143SgWaofUVl00+qhbF3Z20PXTUE=;
        b=0fID8NlOItLl68oZvq5oADLZZ5Gg/DpN5ovOZUxcY8pl2ewfRTEb39OTiUui1kjBHA
         1c0hyy0vE+0uRzSaN6eO3pfbpk85a2VWTlPhO2/8/k0WCjhjjmOjmSvualwcGWUGeaON
         s0SceyK4+5+RTuqLj1ckPZIzq8n8eCAoknwSbiPlyHckWPpmkM3jICvCkRFxu5f1xDmC
         TMKx9nagyEVn47l6pMw5Sc3tyfX20Zj68j6cmKIxIMa2mmsWFblDe81PgS67/fyiT/TB
         PTV5WkSg0eXHefY20fgpDvy5bz9ty6FSjubRSnmHLmV55iqZLbXRTyaeDW0p4+G0x7g9
         Kr6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489020; x=1729093820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HIeWF4AKDrrEZVf143SgWaofUVl00+qhbF3Z20PXTUE=;
        b=QXIWgLnmnnuCV7wMN29z1eE363Raq9mbyvI2VXBQ0S6nh7kHK2VhN+YRhl75eqlFxv
         AtAeByWKnkx9lqtJ/+VMMZ6Xejs5J7gKu/22bytGdHkhC1bp9bJx34CkXgGuK+qd2xBu
         d1xsGZzqh2rvO79ddGyeCp8e87MSV5C7E6PM+2dqlzjEAqRNwLK702tD/Az1cuAUh5D1
         HQZ1HVyAUcvGbp9QVicEVB3bqXgQFlc3We99h/Lmv0cWHtE7iw8Pca/QmU2OjiZieI5T
         QfDr/KZC7X9gzSRrCmnfQ2uTMLJgq5DHGK87HjM47HHf+y3yDNItwGKD07Tm2LGAL76B
         Us2g==
X-Forwarded-Encrypted: i=1; AJvYcCXHFyTpOFnlKPGFH5WosFQlICvw0Bi+ibwF0pfLgquX2uffbS/HCYumYtUf8im3lE6fCZld74w=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrqrY2TjpLhYWJ7/u2OTtGU3YJoPv2KUYJqAU0/5yISkE2D/zV
	JhqCmuAqm3tLFP++lbWbkgQ1roJSVE3vIaoS52BnOq89wWDI6Y5ZYZAnVT4FwmHo1U5h6prC2hF
	mag==
X-Google-Smtp-Source: AGHT+IGckGzXTau4NGP/kAJ156CIPWl2QZt/eqMK5BUWyK8KyKg1g8Tc1FgMI3mqgA8yRsZ3clSiNLLsE+M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2093:b0:6d4:30f0:3a74 with SMTP id
 00721157ae682-6e322171640mr503647b3.6.1728489020502; Wed, 09 Oct 2024
 08:50:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:51 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-13-seanjc@google.com>
Subject: [PATCH v3 12/14] KVM: selftests: Precisely limit the number of guest
 loops in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Run the exact number of guest loops required in mmu_stress_test instead
of looping indefinitely in anticipation of adding more stages that run
different code (e.g. reads instead of writes).

Reviewed-by: James Houghton <jthoughton@google.com>
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
2.47.0.rc0.187.ge670bccf7e-goog

