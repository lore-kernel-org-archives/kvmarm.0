Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABA520459A
	for <kvmarm@lists.linux.dev>; Sat, 13 Jun 2026 00:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310044; cv=none; b=qZ8p04AU+moda1Jq94oQpRYrFsndsqq+MDVPe0bVIq0+Q6z4QnMDIS5THOeeD7G7lCBIa8xxhttG/jMiCaHG+CcHLn/e8h8jXcW0qFi/WdthtAUNZPwP+Xyk4C7sffB2l2axC0riWRepNiLH1ZzTkahKTiFHQ689nowiRYSUW9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310044; c=relaxed/simple;
	bh=BGbTT4pl8yUU48pWeQdBQ3HUUQ+YTavKqvYo/o9BJDo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fLLaqzK3Kr8+FhwP66Zqfh94+er9UZWAoC0w89fl2w+e7UUTFuwa8bqq/mGEKdI9njmLadlVugwLB6XmsCWbHlpca+TUQuGtk0wkUGdNf5T3V/Dl/q6hHsfjR5xW1jEvZQSv4/LTTOmshuJuczkklZu4pYQZG1dy2dA0IiJhCcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GBom9wSE; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GBom9wSE"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-36bc380fbf9so1479567a91.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 17:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781310040; x=1781914840; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5Gdhr42TK7HaiENwXEe169i/UA5JDaTAaZr1cyLBuko=;
        b=GBom9wSE1idslQg6CVolzuR+PNn1Enb4hoe5QrV5ZhFXSYnQ0/tkM5b0FbRP5Y/Wz9
         lU1nIhqUXX6rb0lKI/Vqcc+NQopdEhAKScMnKoEwdtY9YngtMfPtD+/AAo3Sq7UmIXEE
         V+eaMTulPLBTBSJD9J7Sdqjq6xVwFAGYLOVkZygWwH32pyh1zvoudb2bjLlb6Ly9XY11
         oTzhQ0TC0ppkVLl3+k9HenqJp8b5hmOMMNVwFJLEegoOSSJ5QYq5HRA9GL68/tSLKmqT
         nEKuHIiqAzq2BSJk+pUP8A5xWmZwTT+RTgV3SfRa8V9Q7KNNreBowMaJ4DRFPCziQOcX
         eCTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781310040; x=1781914840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Gdhr42TK7HaiENwXEe169i/UA5JDaTAaZr1cyLBuko=;
        b=WrVRRw5qout5Ot1lhvS1mqRGc097vwalouCYFElR8I1fUU62lXBQY93CQ3yEEDN4mu
         USl8Ib9EZyGWZr1z9H0gX0I/UZmuchWjkryaa6km4hqovddDvpTPH5NyA0KFaRul9LAW
         IUM58NAT0TUS8LJ7m4ccyjP8K5BBCxqbQxZYIm6/0RK1dEkwZe5c3mfS0tpubHIBj7GH
         tkwYdFq4G0ADa2bOO8MZXrGUloXYFhSQiczbk08F2ZOX0fu7DkYditL/4BbcwAYqvADi
         X8HPIHHfUByQGCZuLRhdjyAAewptZJmQfyMputPxX6hRPA2ABcpdl2ArfVmMB/DHMnci
         6A9w==
X-Forwarded-Encrypted: i=1; AFNElJ8itCk1G4gsCJZ5gcnO/aBYU7BP9us5GTm+inh3bm6s/VlpcOm5Gz4PQavbTRf2P03mFNxOSjg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVwETSahyvnJreBi/JxvwynHzuufUqkKKUXkuD6VQ4p+Hx/yOD
	hhwuwajJhpbGITXXPzpxPIlV0K2OpbmeJZABobZfGiewBwrIyuwZyHnH7JpgqG7VIMgEu8/6Bjz
	jJNcQRg==
X-Received: from pggg6.prod.google.com ([2002:a63:2006:0:b0:c82:798f:628b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfd0:b0:369:2e00:1ff0
 with SMTP id 98e67ed59e1d1-37a024176dbmr5248980a91.6.1781310039710; Fri, 12
 Jun 2026 17:20:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jun 2026 17:20:16 -0700
In-Reply-To: <20260613002031.745413-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260613002031.745413-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260613002031.745413-6-seanjc@google.com>
Subject: [PATCH v7 05/20] KVM: selftests: Seed libc's RNG before using it to
 generate a seed for KVM's pRNG
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"

Seed the RNG used by random() using the de facto standard method of
srand(time(0)), so that a different seed is actually used in each test run.
E.g. without seeding the RNG, literally every test on x86 will use
0x6b8b4567 to seed the KVM RNG.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1016865d3f7a..2e08d9fcefc7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2284,6 +2284,7 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	sigaction(SIGILL, &sig_sa, NULL);
 	sigaction(SIGFPE, &sig_sa, NULL);
 
+	srandom(time(0));
 	kvm_seed_rng(random());
 
 	kvm_selftest_arch_init();
-- 
2.54.0.1136.gdb2ca164c4-goog

