Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164484F1F8
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 23:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458822; cv=none; b=inyvQdzH9oph9yEzDz78bkjbHRwv08yHxadrD7H4nIkWAYE9QKToB1psniCvWQXYtIfFIgoTNMqgkdIy3CCCdQ/w7rgqoLNjP5t+JuvTXPF5+5lT8Z2wK3ziuxXTPtkY3aoLZdQl+KH+n+yxHB7TBL3nhQiCbYTzddXHpMGCTWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458822; c=relaxed/simple;
	bh=AqTYa7MHtMGSvPyMPSqX9mCVN3CkOd0u5L3U2bv1DqM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xo2guBwpgIkDKS7Fec9bYKmROZpiAbzpVNSWiAZUaLiF2/1ezZCdH8IEuP2TNrPO0ABG9EIcRwfd5z7hhYJc2u53bvvSB+WGK5nfD5lY1isXqj1glbUmK1n5YChPefhwnRVpUapr0iBnpjKLhmHWE5aGmWefPWD1amDhUmu7SA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I6j8AwR6; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I6j8AwR6"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbf618042daso2233784276.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 16:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458820; x=1711063620; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=j/j/mb3JtyoyPDhLhkSAITq95aQFSMlle8Dlg66amAk=;
        b=I6j8AwR63q+WIajXOH3QqRrQDUg9xXpn5vwDdBma3fv1iwigLRzKs1HZurWBvZ5MPW
         LRWOHmNz9f0hlaZ5fELM3Vx2qIhsgdPzz8/ko5NYietft2jn3XDPscaoc0l64NgLdLZc
         FLQn8+lY2vRQXnK+pFEKOjPsYjwR+S7XTomL5/B5MttmG+TXSIXTxsqCSlSWK/+ewlFT
         i96Awqi1YQzwNh8ApGlO29GNQotbm+Ouvyz5CeYC+8d0l9tNISCgRN0YDMw/RjJRAuew
         yauKT+6FFuanMc1xjvWfIRUuTIJ6NXfadu5YolLABeM/iUhl8P1zagJ1J/bjWce4vnru
         fmoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458820; x=1711063620;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j/j/mb3JtyoyPDhLhkSAITq95aQFSMlle8Dlg66amAk=;
        b=LldzvJGWMr8FhCz9TecTIDr9xfJ9jMw4A1QHPnIJ7bYoqI/2itxt5kuAxxm/y9Hi2x
         uZRlp+ErpaFhYgH89PbvO17OBOFFtZm5IQXSrhxUkMLAwT2aKxeaR0SYxm7+L8F6CZ+w
         l2iP7OqCQOki0KL3FknwSiTni0lAW4sbvJiap/namLMxojBH3MTTFcZXpEhIMzyJY0BE
         GXFEV9A5EheLpqRY3YBM6cZ1qJwlDEo4Z73VbzC9bBuaD97q7PuRK9reyBI91lNu6bko
         fT1J+DMeihVaE+2Kg8cUO5ATHTAsjvTuTSC47FeOPO9luUfG1qDDu6xlfKCu2+yPZ2aP
         Jl+w==
X-Forwarded-Encrypted: i=1; AJvYcCX7TvebwzuCE9qofAi5izhbIEcyJoEDA3EUmGrrMeLIrh3T/rpdKYOUGsitsh87yEC/yvI17tQ0rJfEqZT0XdBKE66vOant
X-Gm-Message-State: AOJu0YwOaeYn92AcLCmSuHPng00KAlnl0RDOGbqnfWQR0zx4+jU4mal5
	6ZBboEnlQ1qmY06Lc7VKfXF5SiVul83JuagPkB4rcPPrg8lQ9U46CpSmaPSoVrzU2JWVQ5XccK7
	28g==
X-Google-Smtp-Source: AGHT+IEgFldUzAavXJ42YJM5+Q6BHlgBbuisK5vIFOhA5ma+0WFPVDRLg0oxmN/Zi21+BucUmJd5KHT651s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:72e:b0:dcc:94b7:a7a3 with SMTP id
 l14-20020a056902072e00b00dcc94b7a7a3mr183110ybt.12.1710458820208; Thu, 14 Mar
 2024 16:27:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:30 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-12-seanjc@google.com>
Subject: [PATCH 11/18] KVM: selftests: Map x86's exception_handlers at VM
 creation, not vCPU setup
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

Map x86's exception handlers at VM creation, not vCPU setup, as the
mapping is per-VM, i.e. doesn't need to be (re)done for every vCPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 5813d93b2e7c..f4046029f168 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -552,7 +552,6 @@ static void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
 	sregs.gdt.limit = getpagesize() - 1;
 	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
 	vcpu_sregs_set(vcpu, &sregs);
-	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
 
 static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
@@ -651,6 +650,8 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
 	for (i = 0; i < NUM_INTERRUPTS; i++)
 		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
 			DEFAULT_CODE_SELECTOR);
+
+	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
 
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
-- 
2.44.0.291.gc1ea87d7ee-goog

