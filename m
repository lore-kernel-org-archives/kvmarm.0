Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7A93C09F3
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 21:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509744; cv=none; b=q/+FtZn4Y3fbE4zPAcRwNdS6zBLOTjsMNRDQS3yqcxUhdBP3UTxdKigt+un1MYuyZOymwfuwhJk9P8CC/zSUKp0XfgicAWhTU6XW2Eec+h1Y7VnvnedbAuVduUhPz0lKtgWCx/IyV5KWkJr7hCPSj08Hq8m1fWon7NDZ4TwVEx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509744; c=relaxed/simple;
	bh=kuU5LM3fvlkSR21au3e2Xd4AVeUOwm5tX2qycnU7BXQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d0Veg2fSlh1brxx+jfTESjwTfLhb91rMb2X6speMEDXtucZAsViAfN+3aUZ80LCIvnXRmM4tUdbYE43dcXbnnG3dza76Xr2RgPT+YH+onCCSdQ5bBy4r3+05bYZ+UP+pvD9xYY6fN7Q1pbX5cN0qj8LRp0W20rnql/3uiAIpQqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wCTwx/cO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wCTwx/cO"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-37e16f658abso637716a91.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782509742; x=1783114542; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ht+2H0jf5K8WYzsVOZrAc6DiqyjXLSwmmI/Hl439zCU=;
        b=wCTwx/cOW5Lawla7OzX+4Jj16+lAJFfAjf3baw2K7DAUCb99a4O7KNM4dtXnMlzCeW
         Teq6GkiPSdTlEigjYt614cFyJSh7oln4k786mjylOHzvymfO+OxNbHSabABmV11LMkEn
         5teoeOu9Uk+EcY6d+p7FBCHIMSS3Krvb+0pb+TlqAurX68tmfRqNbQYanRSeUX32K14A
         vyWg0o6CCK1yiXl11HQQ7U6FCJBlNyLvrxvuFJiSVumR5/GIh0ZN5D1yBQ2gD/pYDxUx
         sNY8v62tfQvWk3ozl50Vk9dnkKZuSkQEI0Ji+5y/vZjQD15lmFl9KgVwioBiThR/j3Iq
         1qqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509742; x=1783114542;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ht+2H0jf5K8WYzsVOZrAc6DiqyjXLSwmmI/Hl439zCU=;
        b=KtU5IXVLrKUWgoUJG5TJP4xaGPbmShku9i9F7LzwfnKVIG87Qw1RcKDOI5PGmuCd2b
         4weRMDJuVlx+RW+IGOlFQgNsrA0Exst9axY6mN75wFRBWKIxoKdQTVXZKS1LXr4xw087
         wnfZ6Gf+RXCOnmc9yKTGb9N5IToEiG2ctflSR84lk6lGeYfdH08X4HaEfmcKK95Uh36p
         jfviFG0M0aPj94J/y56W+Ga33mEq6AxpOTvkQ1ca2niYphCBVFEsFNxe3VszwX2ACFkW
         rTFxDWbdeq0BWKyVDn99Qf1AbZ7bsdYy7qcIiuUTVGMTPxHIG6HidbV1uEomjgKfu+h6
         4p/Q==
X-Forwarded-Encrypted: i=1; AHgh+RpUO1a9XwQbpXWvia5X0cv6wz3sb0cwg2tKcDQan85tZRhTldlmrW1K0G2/e5stKG/9+UJjNi8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSJpbQK37qS0BejjNFb7TBalAk7Dl3daU/RNa5n7i/DB9eJSOq
	FCfGiKJ3yRaEJb9QrsYuUM4Qh2KRUYjOdLmnhU93yZlC/HwjbavpD9X/0jyih9H26hFyLKkYOsH
	ESlvFgg==
X-Received: from pjzp14.prod.google.com ([2002:a17:90b:10e:b0:37d:a52a:ff00])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4acd:b0:36b:93f7:a903
 with SMTP id 98e67ed59e1d1-37dfa25a0d4mr8609950a91.18.1782509741562; Fri, 26
 Jun 2026 14:35:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jun 2026 14:35:17 -0700
In-Reply-To: <20260626213534.3866178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626213534.3866178-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626213534.3866178-5-seanjc@google.com>
Subject: [PATCH v8 04/20] KVM: selftests: Initialize the default/global pRNG
 during kvm_selftest_init()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"

Initialize the default kvm_rng during selftest initialization so that the
pRNG can be used by tests before creating a VM.  As pointed out by Sashiko,
failure to actually initialize the generate makes it decidedly not random.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 875030c22d07..1016865d3f7a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -24,6 +24,13 @@ u32 kvm_random_seed;
 struct kvm_random_state kvm_rng;
 static u32 last_kvm_seed;
 
+static void kvm_seed_rng(u32 seed)
+{
+	kvm_random_seed = last_kvm_seed = seed;
+	pr_info("Random seed: 0x%x\n", kvm_random_seed);
+	kvm_rng = new_kvm_random_state(kvm_random_seed);
+}
+
 static size_t vcpu_mmap_sz(void);
 
 int __open_path_or_exit(const char *path, int flags, const char *enoent_help)
@@ -515,11 +522,9 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
 	slot0 = memslot2region(vm, 0);
 	ucall_init(vm, slot0->region.guest_phys_addr + slot0->region.memory_size);
 
-	if (kvm_random_seed != last_kvm_seed) {
-		pr_info("Random seed: 0x%x\n", kvm_random_seed);
-		last_kvm_seed = kvm_random_seed;
-	}
-	kvm_rng = new_kvm_random_state(kvm_random_seed);
+	if (kvm_random_seed != last_kvm_seed)
+		kvm_seed_rng(kvm_random_seed);
+
 	sync_global_to_guest(vm, kvm_rng);
 
 	kvm_arch_vm_post_create(vm, nr_runnable_vcpus);
@@ -2279,8 +2284,7 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	sigaction(SIGILL, &sig_sa, NULL);
 	sigaction(SIGFPE, &sig_sa, NULL);
 
-	kvm_random_seed = last_kvm_seed = random();
-	pr_info("Random seed: 0x%x\n", kvm_random_seed);
+	kvm_seed_rng(random());
 
 	kvm_selftest_arch_init();
 }
-- 
2.55.0.rc0.799.gd6f94ed593-goog

