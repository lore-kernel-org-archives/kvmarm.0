Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C1C2942D
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 23:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458818; cv=none; b=d0xTaJUI6zNBOS3rbzq3wh6TKGny8dsNRPFyULnfwRDwXPm5p9pJDuIUKikACV/jKFcu+elfUPoCxBr933kd7UdK2xkpwy/pQndOPo1+Y6QlQFwMiPDIAfA+/iPHDRcdwpxmAYYn4DfL0UVkPX/oj66ByHws2g1kXeCHKfqPxbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458818; c=relaxed/simple;
	bh=o49cGQaFGV2lqCGlt41zmvUnsUxiYRWJVSbJwfYRFlM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V0t9lFs6AFXfPkwdMf680fYFr3rZtISm65jrlN91EFyt6q2z9gwcOnPqqVLjBCjhlVjZcrO8hMwuUqxA9lgwComyG4OOGUcf2rYCnoIuFh+ohBjajbvu1E3h9ZOyHeLheAeSRmlRv8L6Gg774zC0twkz4Rql5ZJjCAfNKldx8FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y6ODAIcR; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y6ODAIcR"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1dd8dc37495so16919645ad.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 16:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458816; x=1711063616; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pTVZRdXyCVTnuQGgLheWcCsaF7bim4F1PK5VbaXQ+t0=;
        b=y6ODAIcRVuAOHQRFWnS0HfJ2FSESlOo+Lnlqgv7x9Ee2j6ad25CtXifnsog2qSbMkq
         o0M3hMeQrTRb4hn2u+BGxoPBdH7Y9tgLI2vAXbPjo8v0DXJDJ1whZxD75rW6ekeD46bJ
         vAqI7FBZO9PUbSt/UjsSOSQ/c0N6Y3GGHriJQL7K1Qq8gYM42L1dmQLAinf+OQ86ZIWh
         NlECWhM8RyynDB5WAQzqhfI8ECC1afykHFHbMyXFVcEqNwSqhaGAsFzAAdCbNcpIzxaU
         xGptn8t9/yNbRMB4Rgk3MsscxIym5mePV1ZQtTDTKeX/60dw6Y/B62ZMR/ZwzlMjCrpj
         WVDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458816; x=1711063616;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pTVZRdXyCVTnuQGgLheWcCsaF7bim4F1PK5VbaXQ+t0=;
        b=VLeIJ5QJ5yBZuoJDUxMdtysXWfJ1Mjjq6tzQr4D6NbQS2G0b75/WC93eteLDSlJ7yz
         nqz7gxXsyggTbrNvdRbwS3PNNUp6vozuWPN+srur1UE5rC7v8RQGjnnCVe9HZI1N2Fbw
         g9RScn1YhE7IzApDyjaMQ7onIbLVQrE19oaqDoJ004Ej22mWBwMv6lmTW0ZJzGo+dGek
         6yoD+59iAuz12TjKnlBsEty75DS/FTCs+DIlHYVcRHFVNsr1tkga/aUjUNNVxxu66VOE
         PR/KaQO6I2oA5i4deWNYTkyQe031snuX4IJ4ZDDQQIGa7RZMQz31/16Bqk4sZ+HpeKcv
         N8Rg==
X-Forwarded-Encrypted: i=1; AJvYcCWodZ9At+e5DFt3lUimpoN6tnsuLOIPBfUVRVY+KmLNv4dIJ09fJBnads+jgxiSeIZXW8EJaZ0FimQDJ9Mqo1kjQXcKz/19
X-Gm-Message-State: AOJu0YzkeTPEP8sZRDPF5sDiN/y1k9QXPfow/CmoAB+a0vWSkXDqnm9q
	OcdqoLsmkUUZ+5vOPHkPUJs5RtdcabzxJ5ipuKEweGeag7f+oDzTvQtvgzRSnJt9QvwSo7KK+h+
	ZAg==
X-Google-Smtp-Source: AGHT+IH7S37OXvdlnB5BIBxBCKNBsO+Ay6MTHPEIT19iC3iZ0sD1f7oPcvL0HSDVvR5Ys+olPa2yoMgb6k0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4ca:b0:1dd:a324:30b5 with SMTP id
 o10-20020a170902d4ca00b001dda32430b5mr9294plg.9.1710458816466; Thu, 14 Mar
 2024 16:26:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:28 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-10-seanjc@google.com>
Subject: [PATCH 09/18] KVM: selftests: Rename x86's vcpu_setup() to vcpu_init_sregs()
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

Rename vcpu_setup() to be more descriptive and precise, there is a whole
lot of "setup" that is done for a vCPU that isn't in said helper.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 3640d3290f0a..d6bfe96a6a77 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -555,7 +555,7 @@ void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
 	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
 
-static void vcpu_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
 	struct kvm_sregs sregs;
 
@@ -716,7 +716,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
-	vcpu_setup(vm, vcpu);
+	vcpu_init_sregs(vm, vcpu);
 
 	/* Setup guest general purpose registers */
 	vcpu_regs_get(vcpu, &regs);
-- 
2.44.0.291.gc1ea87d7ee-goog

