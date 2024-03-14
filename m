Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18905535DC
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 23:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458827; cv=none; b=ZEKbAp2ky9lCkJtOcpABp8TWyKoOH3JS8QKVICI8QK2B2WvKRGGvJ0P0EFX4rtsMlEK+87ifPdOIKqzl7mZ/vN4ggFICIp4J/sXq6gqg4MA+vGQSHXeOLjO6ByyGxA2PXLTSgILGhOO25+vs5STHzQJ4Ppd6Au2o4IXIgUYooqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458827; c=relaxed/simple;
	bh=rKle47E4nZDDqOFkGZ++A7yOb91DTrGSOJRrZ2XcVV8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YxMOsoBGVfF0Zj1ZyxkSThqwbUoJAI2knR9bBB26Y1NlhFakNZf3jxO6eZTaaK+5HlDmoIzBdep6uOShJ3QCuyLJYgrFIVsfMsxf3GIQ7JEwNy83rkExbUa4LaMKZ55qZxgdTaF6zWEzmpSZmwNd+XhA89mNpq8vmvjgavR8z+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zVm8qQQ3; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zVm8qQQ3"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b269686aso2254488276.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 16:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458824; x=1711063624; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WoFzTDbs1SGZWiz/BWvPtXOQrZCNvORTtjaiRTPj8cA=;
        b=zVm8qQQ3pjUoavYEp/P1+v/3P7cZkPldHWJvUvjApol3x407TBlrzLnfXnixLg+Fws
         MlKfpwjeYkDompMOr6R+Gf2gDlDrjE3gq5lXnOUj7E9pc7ZcXX2VGvGvxFNrZIMUpQxO
         pEC1EmX0v+1/Q3kpLwE5RUia2MZGwPKaWrHNRwzdJmVhwuJdPxPKOx+UgBDFytHYAkoi
         O+LILLAv74bwvVbAyEW2x7FcLPMPS9u2SMtFn2pet5fvXeVKUC8Zmtpg+oHHP7T28CRG
         Ml+qwf0+rzeenSTpEafguvyLZ1kFZITrRVvKiJCf01a3hBm39uI92IeRLoWUxEotDnbp
         /r9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458824; x=1711063624;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WoFzTDbs1SGZWiz/BWvPtXOQrZCNvORTtjaiRTPj8cA=;
        b=izMbSmMNfacFPeYmARv7W1OCMyV233NfexzJcAcpIMVSKFPdXdq+WjGrm3DKcENO8x
         EZbD0tS+NQyUi1sY2wKQegJxsxXL8c0wdVZS6BCgN7nCOweORnvE7sb2bcQxOkD0xN8Z
         H4C2JHID9l4ohqTY6ZWpgKjpH4zWF9btOmMbtFCG4yyAWM4DhYWkviZdHatxLOMb1iMs
         MlaQyyhtU3CY1t3aahIJb8hY4CiC/COtaYZyHnfKMuo4S+IO+m2UDvFdGwdsdNoN1hOc
         /a17rwsVa+uJSbVKtABmtKFE2X+uGMYMjVXgbfKQU0ZKbBJoA+qsK17q/gAv8MwJ9zs4
         ciaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTpnt0eYBwv88F61qXrXKo/1mNC8C8uW88DCZExd6cMbjVccXRWm8vOUw2Aitm3PZxw/rZ7KYLh6ueBEjFy/gej9ghyTYC
X-Gm-Message-State: AOJu0YwLVDpiVePhp0BOUoE2RHS5siAPIAAyDUgXcBxvgWMgspPgP4is
	2z7kaTSB24mhLjBKDKAeNutcD8JIPhYShtZIEPBcqDewus/UjqRih0GYdEYM8w20dqOTJtzXTMQ
	AoA==
X-Google-Smtp-Source: AGHT+IHcMDu3QEHM/t3996zb5RxqsBHPTHwvDMlP8Tv3VDnGeL/s0WR7fo9rdGQ7MgRJw43RolfNSTpIRT8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2009:b0:dcd:c091:e86 with SMTP id
 dh9-20020a056902200900b00dcdc0910e86mr147737ybb.13.1710458824203; Thu, 14 Mar
 2024 16:27:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:32 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-14-seanjc@google.com>
Subject: [PATCH 13/18] KVM: selftests: Drop superfluous switch() on vm->mode
 in vcpu_init_sregs()
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

Replace the switch statement on vm->mode in x86's vcpu_init_sregs()'s with
a simple assert that the VM has a 48-bit virtual address space.  A switch
statement is both overkill and misleading, as the existing code incorrectly
implies that VMs with LA57 would need different to configuration for the
LDT, TSS, and flat segments.  In all likelihood, the only difference that
would be needed for selftests is CR4.LA57 itself.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 25 ++++++++-----------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 8547833ffa26..561c0aa93608 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -555,6 +555,8 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
 	struct kvm_sregs sregs;
 
+	TEST_ASSERT_EQ(vm->mode, VM_MODE_PXXV48_4K);
+
 	/* Set mode specific system register values. */
 	vcpu_sregs_get(vcpu, &sregs);
 
@@ -562,22 +564,15 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 
 	kvm_setup_gdt(vm, &sregs.gdt);
 
-	switch (vm->mode) {
-	case VM_MODE_PXXV48_4K:
-		sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
-		sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
-		sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
+	sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
+	sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
+	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
 
-		kvm_seg_set_unusable(&sregs.ldt);
-		kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
-		kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
-		kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
-		kvm_setup_tss_64bit(vm, &sregs.tr, 0x18);
-		break;
-
-	default:
-		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
-	}
+	kvm_seg_set_unusable(&sregs.ldt);
+	kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
+	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
+	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
+	kvm_setup_tss_64bit(vm, &sregs.tr, 0x18);
 
 	sregs.cr3 = vm->pgd;
 	vcpu_sregs_set(vcpu, &sregs);
-- 
2.44.0.291.gc1ea87d7ee-goog

