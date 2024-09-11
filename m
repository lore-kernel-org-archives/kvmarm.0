Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2348A1BE23D
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 20:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087365; cv=none; b=RCxDaFrVQLFNbkB8eW94qPFEa14t5S9MQ6s8g1WZPWoEJ7aP+6aPU5Zr9u5jiIIJK7ZtRdsBX06+hpFDqQoxwVi+mhwZ8sRM7HkDkM6GKSuhuP4olcfhvKy24E7q7o6emzrwJzTP6h5cvf9nd5i0HgVSZH35wtZmQ/wFzRNfWWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087365; c=relaxed/simple;
	bh=RjIjbK/O7AOXgjJl4H0U8PhhFXmA3gdfj48wRxxggdY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gLMlAALbbiHqDZJApa1wN2G/15esHCHDiSGRr8bUAHfFCY3A2YCbf+lPzyCpv67y1PTKWucqBcuOa2I13AlAOVGYy1Zu3Mr1FGHNvWqXOLCpmXJ9nEZww/zLktNRhFXir9/Tw0uPKmxsE1/KNrGAbEMLoSuACj26zA6bLCh+NYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l1c1pnzr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l1c1pnzr"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2d8e59fcd4bso358649a91.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 13:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087363; x=1726692163; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bmoPUX+JXjpnDZGI5p6xMsNQ8aqKvxbSE8GAbeQD0ic=;
        b=l1c1pnzrtWarIFI8g8HWMgBP+R/ax8xqIczGIh6ChaAd9LLfWq3xYiNUhG87SHjQeN
         ejMXJeoOEVY/8iAIp3OFxu2Hk73fHGZrhfw7AdiINP38aOa0EZemCNRcIwnvizpwLU84
         ghmAMVS+kIRPtcv4Z4LjDm3ow5Zay+imJ6h1LcmG1j90a1nWCeTThKhwuV4nKmid9/b8
         9MNupNwaATdrCOslkZgjOWpkcp2rJN4/ghpk6mcTu1n/pMZRGOt0mMjwVXkuyl/+oLq2
         ho9grQ92+fZ5fOgGWgeMzvvF2qRRSKqKrTwZacePcJujm2e1sTd98qUDmHuyloc5Q5JY
         oMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087363; x=1726692163;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bmoPUX+JXjpnDZGI5p6xMsNQ8aqKvxbSE8GAbeQD0ic=;
        b=I0pLLXWpj0nV1wmkmHG8VWsTGRd6AV2bx73Gds3rTrFZR8iV3y/0FyG8NZdV1z3PyI
         DFMlHoVSOEQTn/lgoT0PMpQPUAH/1roHEshDF/WI6n/P7rjFpK67D3en2pQOi1BvtnIL
         HsKuQJy3eWLYVLWZmQPKZVBOrOMTeXQcWh6+Zvax+/ADbDPKYC9e2XmoW112NWxGkh+h
         rvEaTa+uz47YNRxRtflcooSz4Nhgezlm17HUJsLRkkPzIuUtAwHHYObrcJ8JbXBOxae9
         IDoRiO7iMox5AMOe8BQahGwv0yqiUXVjFm7JPqH7C1IaLNMXQqvv9oX1PIBkKk0n1V4Y
         GMOw==
X-Forwarded-Encrypted: i=1; AJvYcCWIebuv7/A0OzxINtBgLTu6vge1UGBaoBdZzD5AaTHfja1Cdds3hG6E5bxB8br/kTaEjgyeb9A=@lists.linux.dev
X-Gm-Message-State: AOJu0YzgjFteCLpM4u3jrT2du+2J4cYqG8SWxykCRphE5DF/tN1rIoMO
	VHEpMqcll5LcVesQPJ1AvvWQ1cxGL6JuWiwKeO5BkTsdhYGyCqt48FC5sCZn8xXPvFpVGde6RD9
	jcg==
X-Google-Smtp-Source: AGHT+IFejIMeELuVO8txo5UGwYsGrFXhMhJbdLyClaj2asDasqbAOd2Ag+P6eX01VQr2edSnhAi2+MXrYfY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:710:b0:2d8:a9a0:3615 with SMTP id
 98e67ed59e1d1-2dba005b566mr856a91.8.1726087363354; Wed, 11 Sep 2024 13:42:43
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:56 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-12-seanjc@google.com>
Subject: [PATCH v2 11/13] KVM: selftests: Precisely limit the number of guest
 loops in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Run the exact number of guest loops required in mmu_stress_test instead
of looping indefinitely in anticipation of adding more stages that run
different code (e.g. reads instead of writes).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 25 ++++++++++++++-----
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 80863e8290db..9573ed0e696d 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -19,12 +19,15 @@
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
@@ -51,10 +54,18 @@ static void rendezvous_with_boss(void)
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
@@ -68,7 +79,8 @@ static void *vcpu_worker(void *data)
 
 	rendezvous_with_boss();
 
-	run_vcpu(vcpu);
+	/* Stage 0, write all of guest memory. */
+	run_vcpu(vcpu, 0);
 	rendezvous_with_boss();
 #ifdef __x86_64__
 	vcpu_sregs_get(vcpu, &sregs);
@@ -78,7 +90,8 @@ static void *vcpu_worker(void *data)
 #endif
 	rendezvous_with_boss();
 
-	run_vcpu(vcpu);
+	/* Stage 1, re-write all of guest memory. */
+	run_vcpu(vcpu, 1);
 	rendezvous_with_boss();
 
 	return NULL;
-- 
2.46.0.598.g6f2099f65c-goog

