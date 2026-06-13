Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536A01DDC1B
	for <kvmarm@lists.linux.dev>; Sat, 13 Jun 2026 00:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310042; cv=none; b=gVlESsctmvAXbuJ5pCndMx6M1Wc7LVOFZ+vmpYJB0b1ahSQMPOtz2y2XY9eD2wEe4LN4+tGVQhD1b6TFfE79qAxehlrndyrgxRuxIfYl1A0VlPHH5abRTnXbyZK+9ewRq24sYpDH5VYY2mtBXZaMn3MaCtHZAdLASH3mCUGLnO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310042; c=relaxed/simple;
	bh=JV1d9mTxVyznuvXEHzHbiL6DP5o6g8Jk2shnAwWUw40=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RT/eE7yUiK7hbVp3/cUov2qTUuz04SU0DYVRTcPVFo9pIxIP0scrawDMFhUiDCNLdoOvhTR63a6OE7dLALvdRc5rNEQloG90+7DdZEypG+L4rdjWfwkTfaLTgYNP24+Xl8tBBcuPXoIsDc7CaxMPF0jg7ZafylRY8VlPND49Zfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lzq2WEdS; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lzq2WEdS"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2c2da7fa311so14601225ad.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 17:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781310039; x=1781914839; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=O+I565ELukpP/rjfHIhv+TORYO3S6R2jcA7ns197jWA=;
        b=lzq2WEdShUmj6C72Opx6JTTVrlEIL3G9kz+up8Fjk0G1o+GQzyr77in9VbobPDz3bd
         hJBpt3YwWY7+hOkdK3HXHbmEX1+6m/QG0oeFMcnxDnXbZiKxKtrjTN7xV/WfDZ++3nZ0
         H7tuijiNNykvjTmVHhJfv4gGcCaNeeU2eloW0/LV4VxJBqLORGOiWVIaAnI9CXTDB9YA
         DGtGP73hFp4adzZJQ9exJwcp3mnpqpaUR6HgSHGGfTPhgeg6SMrVKD5SV8TZ6KJk0sGy
         nN4vBhFUYqsAtU14BOjzrBRxGxkDeCZ0XNwBR2MVw6IyyoSybkQuROe95IzBF7IRD4OT
         CL/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781310039; x=1781914839;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O+I565ELukpP/rjfHIhv+TORYO3S6R2jcA7ns197jWA=;
        b=Sj1Kku/etCl6u7sXoBs74h2KSPJkpQ+ttlAmWGIBYGxTTOTGHhnnt7CJ6KUMR6ksa1
         xfSWI3xTbi2P58kOAcL1DebuK2ut3YAvQaA2WWZCLPNSHvsy4bJ1kXGXRVqvmwYuZpMm
         CVcB9pms21ikcujiipa2nR/zLZncUWy5oBU/LMDBEw902PKKi/D6wBGYHc2zWeiy/5Jz
         2Ko/qpymQ0W7HBlNl4YZvSemEYKlLP7vxasbP3Dylm1HhjewH0hUW655hYAQXoWwMJiZ
         Dk+AY/OxBzqbPvM4v0SsPgvlR4C1tTbMFtL/MTnJKD3HtwQhp+aMbSYM2sE4hRqoJKCc
         6IVQ==
X-Forwarded-Encrypted: i=1; AFNElJ9C+ycVAHCtCINcoJIwlVnFRfzGIJwmB2gZ6XW4zcB/q8yI/mvJoYR6AKJd3EkvK555xa3uR6o=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywzg9RWBrkMXZslVhGHKB9R3rCCeV7tBf/vlqr5mVybzeBarxUp
	yrvZo7GUdtO3V2lvDYNRd98/n8StM0QoDI90zKeZT8qmbMlIs95T+IsXbCEHwd/lIxxOpoEsQji
	JGxCmaQ==
X-Received: from plbjb12.prod.google.com ([2002:a17:903:258c:b0:2b2:425f:b4f1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1248:b0:2c1:69cb:4423
 with SMTP id d9443c01a7336-2c4111b8e7cmr56455115ad.14.1781310038540; Fri, 12
 Jun 2026 17:20:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jun 2026 17:20:15 -0700
In-Reply-To: <20260613002031.745413-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260613002031.745413-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260613002031.745413-5-seanjc@google.com>
Subject: [PATCH v7 04/20] KVM: selftests: Initialize the default/global pRNG
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
2.54.0.1136.gdb2ca164c4-goog

