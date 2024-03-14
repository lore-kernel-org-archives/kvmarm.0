Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4D117C9B
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 23:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458809; cv=none; b=ksjToo+tKujwc2gsl1yPfX9J/73+ZzHzbdmw1amFz/RSTqeP/RvWqRRvalaPyushK/tXlQLsZsZaKOR7S1pk4PdsYFULsnWBBjS6XQDkZitSeuiNFrnCLKApCpqQ9DXrAvHEj7cbNr7mBm/Fu703rty0o4D4Sr4wbYphhJ/bf5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458809; c=relaxed/simple;
	bh=hVROtGdDjNDokjJTyibuSKcjvmcYXHYDj2oTedDMiks=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z0rMFq9NAWtPfci5MBJ0uQN1eMT0XibBK3M1zPng9juHGGXGHjf2lRgYPw3NqTaCTZ/JPEG+7xm5hEq7BMU+KSweNR2vrJhh6QoxIOtfaWfe4T2ZYIqkwNAy9/MT/pQxXBRbnKpbKTkvXBXcL6BK8dHKmh0HbgIZF0l1lPgA6ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UfA1i5KF; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UfA1i5KF"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e6edde53cfso625834b3a.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 16:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458807; x=1711063607; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=f7mdClvgIXUuf9+yuKM3CelLdMACw57Fq4PBdMk33ZU=;
        b=UfA1i5KFN8j+oDfRjtI6YitAkF1h2iG2KMlkIEuYUqQpc1Ci2DxuRMYi1cvXAjgGnm
         BAYUp8y4deJme6P2dzpyjFSjYVsA58D9zCr3qiANIW60HaF5rxoc/0eSsb84VvvBaZrP
         UrOFDJp67MwGiHWT+KlIn5Vmzqj4ma5NYaihOrxKfhuzG0mEdOtQbwfHvG+gJpVOeay8
         bTM8oxIad/M4/ah/n6dVbF+r3oTjJUsF8zzbhtyLCAX509VTfUBemRgJBGV6ckoezrLe
         u1I2Wu4HbMMAh8xOXDJJ3s3GnM7xiML3NWjkVfXvRuLaEGr25nvY8W7PD3myJUhU8bnf
         u08A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458807; x=1711063607;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f7mdClvgIXUuf9+yuKM3CelLdMACw57Fq4PBdMk33ZU=;
        b=KaqHot3KBRavU9bcRCh1WA+uRhej3JBmrXrBc+PMgKVVRW0vbElOj0d5XLPXJGAkFi
         SzvNzCZ8g63XKKLinISw/09Xucbq8gqyr4sFZFGv11A/2t5VfccnkB0hPo3FdyEIdjtN
         Pj+PwMkavJI6/WJaH8n39wcSW2EJBr2/aE2BHJXMgB2XkWrI4OVQWOfaLvfdtUyqVWVI
         XcxtOxw/HqY/4uMVYseSyvNvrzA86tUSSs2g3i7FOHXSUqaGcePd5mB/WjMFwL/8KHd2
         e8GIdhBAxuTRsDrjJW5mv9uqdcAJr2KJgJk1k7Ty6lkS1LgaL4KVHR6mYsX3UjoKDQR6
         J84g==
X-Forwarded-Encrypted: i=1; AJvYcCWTL0yGULM3W1MAZUDhBMpBvp2+El1RQdTUwE2wPlKENlSA+dlLFCt6E+uSmTqrZcn4FQPBM9evohymhOqYXt/jEgz2LXe8
X-Gm-Message-State: AOJu0Yz1sYqVTjs1THu7lJFU5cASbLRE7+2e9jiiiFMjGsQHrYF/7YLP
	Z3qgcjA21wrdbkyyzEJgjVRMhhfwPIv/mD0MUOrsibl4T82Kt8HoBAzNp4IaPoMbTUdIAOkirPr
	fww==
X-Google-Smtp-Source: AGHT+IHP+9uB+bS3/lKcsyk7/8c0Ce59jwpM+G35vfnwrWKSRS2+iNaQrX8dqel6o4dt3H0Nsgf9UIQa3fs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a:b0:6e6:eefe:945d with SMTP id
 h26-20020a056a00001a00b006e6eefe945dmr9863pfk.0.1710458807233; Thu, 14 Mar
 2024 16:26:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:23 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-5-seanjc@google.com>
Subject: [PATCH 04/18] KVM: selftests: Fix off-by-one initialization of GDT limit
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

From: Ackerley Tng <ackerleytng@google.com>

Fix an off-by-one bug in the initialization of the GDT limit, which as
defined in the SDM is inclusive, not exclusive.

Note, vcpu_init_descriptor_tables() gets the limit correct, it's only
vcpu_setup() that is broken, i.e. only tests that _don't_ invoke
vcpu_init_descriptor_tables() can have problems.  And the fact that KVM
effectively initializes the GDT twice will be cleaned up in the near
future.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
[sean: rewrite changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 45f965c052a1..eaeba907bb53 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -522,7 +522,7 @@ static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
 		vm->arch.gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
 
 	dt->base = vm->arch.gdt;
-	dt->limit = getpagesize();
+	dt->limit = getpagesize() - 1;
 }
 
 static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
-- 
2.44.0.291.gc1ea87d7ee-goog

