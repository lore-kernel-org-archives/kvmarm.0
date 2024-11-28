Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531E983CC1
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 00:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755362; cv=none; b=RdFNs8QebxnY+iXOHWXCemt5SGiMKbDJM0FV4ozIwGhI4pkF8knVJSykpop+iCZB4YyF7TJCeELDtDs5N7ZUoM2Y8Ov7QQF5vuL/ajW8M7T1cmooKURxy5dvFfl5jJNcnBT4GLMVJ1jYlCgPIXzAMftELsd6ailXr47/VQNVyxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755362; c=relaxed/simple;
	bh=/iq+5+KMMzm1j6WYTevg5oS1IBKtUjYGyIPBk5OQXL4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pMfsoCiw9Xb5tl8LPduD+FGQxqp4SxBwkvUwtepZQkyxBqjoRcy7c+f9PdQbdiwFHcBZJ+TdteSOTgViwQJVzJAfJjGcGv8z30ioO4/cTTzxBjcxpqCZkAcqseEAK9iveOvedmQVzghD1ar9XiMFcfv+iWL8ePK2w/485yJMXDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0WpYU3OL; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0WpYU3OL"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-71d5be4c6f9so155181a34.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 16:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755360; x=1733360160; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JyP1JUxR4wRqvaLFIbbuwXgM3uy7FspWl6pSel31SGs=;
        b=0WpYU3OL029suHN3Sl7x506rQdVFCnl9qokLxeEA6ChHObUf+DyKAieeBddWTPNe72
         un5xQhkDSXxHp7JMIUHUQDQcv38BFMvbfZjIBwFIvrVpgjE9ydcbyU/elq/F20w3w+Cu
         4emESZ4v2YWKuoehH1AdRgWsXM7vTodQHgxos/MMDJ432nObnKb00ANd1uhvg0Y1Jheb
         kKyaMMPZ0vSB+ZEQFJuFWP4lHk7vZslaben2R/qLumubZryZSLez0BUylMNuQ/pHPv3P
         4eOcPadgH0802TpsEPT4XJ7s5RJHW4/AxF9w94OJxqa2NV92evHhgf9iBP3frcNgItYC
         U+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755360; x=1733360160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JyP1JUxR4wRqvaLFIbbuwXgM3uy7FspWl6pSel31SGs=;
        b=nWOyRS6Y8UjHnvrpKITK9uxzBaimKmCHA53LIbnqHFCa6q6X1XFbCK+w+yM6HmGoLF
         v+7HGkCdfrLXGnGAZvIN2CkYixPvB8TXD++qttBX0vIPwoCCOYMo2oaH6ZO/BrpuNRJE
         zeaPNr8EiD+H52Yh2Q5fs9SRbTlHHnw+c4P4OuFawkUU5A9LRTDor8r+OVOW05PASLhN
         B4ov98AczNBWs70uaRWnMHOv5sTj4vLiz4dJYhpYvVAxlILzswCxxXocXbX6m4aKw9wQ
         UCkOHM2V5b5D1tkX34JC5fpvLdCLV3U7HL9fCnvfAx/Sg5dHufBoBd7OtS4+NXXcY9FF
         6Vww==
X-Forwarded-Encrypted: i=1; AJvYcCWhU6Niu+iGnZQ/WsMqhVcnNXSbKrKNK2RqQ0kJYd+SRJyIJz1sofjUjJcwJjM8LkdE5tfKtEU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6OLzw2jzNu8GveAqMqbm4u/DktOiU6a17hlSXVIvXWtuWrG4n
	S+YkrJxNQtInYl0gCsEYZpVSFjOrPFhSUxL6VRs9Q9FdcYcvnhWJ0GMYNWlGIlFlRAC98Isfa8b
	2Hg==
X-Google-Smtp-Source: AGHT+IH8OsD6EvK6kpKey4op5FA84HiW/8R3R+eIuJX0ly9wWTrNA0B30UgLwfP51sElrM78pAke6fhK31g=
X-Received: from pgah20.prod.google.com ([2002:a05:6a02:4e94:b0:7fc:1fef:7deb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6830:6c14:b0:717:fdb4:c207
 with SMTP id 46e09a7af769-71d65d00ddamr5604090a34.26.1732755360453; Wed, 27
 Nov 2024 16:56:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:37 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-7-seanjc@google.com>
Subject: [PATCH v4 06/16] KVM: selftests: Only muck with SREGS on x86 in mmu_stress_test
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

Try to get/set SREGS in mmu_stress_test only when running on x86, as the
ioctls are supported only by x86 and PPC, and the latter doesn't yet
support KVM selftests.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
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
2.47.0.338.g60cca15819-goog

