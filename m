Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E13B1BD035
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 20:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087357; cv=none; b=BTumgzMHNJ+LgU5pyTVx2P8HudVOM+5lyoOTaQRmJ942sDhgs0H17Q7rnkmsMrGTIgkXSy5JIfVt21M7OHxpYMvpCR7KZKQcc415bzA52kWTBUQwnrtgJGBQmn1gAvYcrOujjKzDhoWu9db+dKtnI778GDbjmzAOn56w2EzhKt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087357; c=relaxed/simple;
	bh=9BzyYeYR+XG9DqVDsSkYPxqvMFHUbhRYSHXP8tVaSKk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GrRf2c/Vj1yO49QsCFGpQObdexZWpVmuSqEhJcqSv7lhT+XvvUIeAXBqbBQv8QNPAhG+o2CNt3yzMHPqaz4s8Qj6wW4ABJV0AGLdCCFjiTPSI8a8i/uy2XSKrDTWbXZDAu6OXdMHlSoDIbYO3SQlFwuWqrvlb1XTbLOQRW9ZgrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ledQNfzS; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ledQNfzS"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1a91576564so1017095276.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 13:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087355; x=1726692155; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mDeUl+tBis0dtonBgnOqcF+rjd+/029ZvfofLpY6Be0=;
        b=ledQNfzSlVOj5X+fJJmAYiivB/oUKf8iZNYnO90Rn3V7OA8RFXQS8HUSgcLitPFARp
         U92zcdADzmpg24ZtYzKVE38vE0PCixP1amDritDkoIZR63xKomxfv2R1vJ/NNUtkez+U
         wh3tPDEW5266L+2EDWM6winXCE5rNjZuLvW4L8clTjqILtKMGa1waCOW2Q9FTfCFjCZ0
         Mr9vqOOVJ2nBXlZOXRAHOq9nPpgT9mHC39Wy5wZuBlzdCP32BROPxeFTUPkTKZk/c35/
         6DSkQcqdRujMe3MFamnAv91Os63NwutUaM8GnMDNyukFY37Lwx0hiTZbhYbXrATLAJZA
         ILiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087355; x=1726692155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mDeUl+tBis0dtonBgnOqcF+rjd+/029ZvfofLpY6Be0=;
        b=HpCv+4SubpiENfz1ASZMK5TmH2Il2zWHQwDcfas0K/AXOUSokFxynvCHAhP+jFI/IE
         Gw3dYVhbfU5Kx6kcts/9s4182FlGbMWVGI261XdwFvysbzxO5yxfRAlyZRWZTVSprocA
         vGyh3+TqeeRGehs3fAgxcnE6mAS20u7uP1KDPwcaA6Gu5icMjD+JgrIGA+39tdJKoUrJ
         H/ZarexlaSrwWEh164isoC8qfdA082ZlFNoDOhR24i3nK+N8VosHdUB1cxmSNES0fI5S
         gQuVoOB1QqlJSSuJ8YHrOkec6F8qJ9YSy1iTiaGTFhA0Mo5NtZZi+zQRQskzvZW+KnFX
         s4rg==
X-Forwarded-Encrypted: i=1; AJvYcCUNuJENviNXiWMddh8gv56pkLloLPCfH79hZyxVayP9HrJAZ/NQvjSIGdUhmKD7/+nPDngorro=@lists.linux.dev
X-Gm-Message-State: AOJu0YyotZvys0s4v1Dr1BQBgu73RkdIP2nlhRYRetpXTlaYcu9NhZhd
	g54dKIb7U8m4xLfQqj0Qikqm4MhM6J9SXUj4gLPgfig/jSb6hduUVr7OfATEdHcS2B26vXs13+j
	H7A==
X-Google-Smtp-Source: AGHT+IGxqix6H/PLMvvIcFrC3JMaLMXEJXlPHwcg40gW3P6CGrRnyhAhRYR7DkVEhB/fpO0WlA4G6vBj/5E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9108:0:b0:e16:4e62:8a17 with SMTP id
 3f1490d57ef6-e1d9db9ca04mr3916276.2.1726087355066; Wed, 11 Sep 2024 13:42:35
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:52 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-8-seanjc@google.com>
Subject: [PATCH v2 07/13] KVM: selftests: Only muck with SREGS on x86 in mmu_stress_test
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

Try to get/set SREGS in mmu_stress_test only when running on x86, as the
ioctls are supported only by x86 and PPC, and the latter doesn't yet
support KVM selftests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 0b9678858b6d..847da23ec1b1 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -59,10 +59,10 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
 
 static void *vcpu_worker(void *data)
 {
+	struct kvm_sregs __maybe_unused sregs;
 	struct vcpu_info *info = data;
 	struct kvm_vcpu *vcpu = info->vcpu;
 	struct kvm_vm *vm = vcpu->vm;
-	struct kvm_sregs sregs;
 
 	vcpu_args_set(vcpu, 3, info->start_gpa, info->end_gpa, vm->page_size);
 
@@ -70,12 +70,12 @@ static void *vcpu_worker(void *data)
 
 	run_vcpu(vcpu);
 	rendezvous_with_boss();
+#ifdef __x86_64__
 	vcpu_sregs_get(vcpu, &sregs);
-#ifdef __x86_64__
 	/* Toggle CR0.WP to trigger a MMU context reset. */
 	sregs.cr0 ^= X86_CR0_WP;
-#endif
 	vcpu_sregs_set(vcpu, &sregs);
+#endif
 	rendezvous_with_boss();
 
 	run_vcpu(vcpu);
-- 
2.46.0.598.g6f2099f65c-goog

