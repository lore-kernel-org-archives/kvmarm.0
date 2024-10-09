Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BF2202F8F
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 15:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489013; cv=none; b=Vh7i2Yrc8cGMUCgua4tIQg4HhLOZ23e6X1HZ30zs+PKBpwolVZOtjSJVp5j0+1ALNTax7zYCJJXTwh8afE5POwa8ZJqoazX9QZxW05JYcospkqIlloE5goj2bjrOY8MtanoGTq55MPEwFfUasWT418wtBs9UIv82K/Kf/2P4bJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489013; c=relaxed/simple;
	bh=iJgiAVVkswthc5+5Sg734uhrpe9cCqrlEjv/8yEej0c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sFGpg5PLETlKn0coADy8mg+5Gq0v7sViu2XDO8qHpgwhZjXMj/+DRMP/qmkB6J0CHfwxotaah4yzIXxV5PHIOeNrqBBfdmfBtrIK3fnfF7EEDwucgCSBqxg9enqFN3c4S03hwtxDxnOFAoduQy7bx/X5iYBd/nb85Y+8FuZO930=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yNmpMC1Z; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yNmpMC1Z"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e000d68bb1so13383407b3.1
        for <kvmarm@lists.linux.dev>; Wed, 09 Oct 2024 08:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489009; x=1729093809; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mkSNDDdTvmOytZei+cHiV7cpe/wxQK6hsvQ24y9wIjk=;
        b=yNmpMC1Zkgt/QC0a0yCY0uZ+iMyELB86oHXw4NPlersEGoeuRuXJXdQNFDH2en1TUv
         QmnD4iTP41kAGRoWNu9L5JcgUBQX9m5MRPTJuyRby1+8y/QrsUdkHt9R2I0mekZAfgGB
         Qr4cavYzrCX8RtYl75GRU6mRgQdZYfawIvqQHj15lq1LAHTR7cVeYLnBzWsYE8OeM7lX
         VtZzN/CrOYkW4gFZzQXB4/VK/8lo7GnzzPbf7lMcai/796QvJzWxZu9VLoNP8k5Enorv
         M139+sMcoE9gdWpW0BywnPYZvLxwgOjoAUzm43refGdL7SdUClCDvPJ4EpWjC+fAb5+G
         QijQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489009; x=1729093809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mkSNDDdTvmOytZei+cHiV7cpe/wxQK6hsvQ24y9wIjk=;
        b=nza8Ag6EXLxRZCgADOkmPnybsn9ABYqeBCwN/fwbJfzYGc3wbjvPqn1u3p8hjg6NdN
         EIkZLcb0B1G8o4Arl1rZRDaYokH5NrYwXsEbUz9ptyxt3VrPKHpFQcu+i5JbKbvHWYXq
         rUbfRQbZzRgyUesqsHWAIM/+qOzi9uT81iyZHa2C1SRetm7LRX7VWjgqfQ207WFzeXIL
         XAYqwdCEG2GsHHKSPPWKjwRPz5mrBfQeV8vbAV62oACtypHVrlNdjRmbGxCiBEwyc0wA
         5Sl2ebn4BOCr7O/QquLRcZHmbZGDZwy/gz3YUNlQz5H0kusaBB+ZgxQ+uLtGLHwxLnTW
         Bokw==
X-Forwarded-Encrypted: i=1; AJvYcCUbpLEXWXYGRThbu+5JvWCHxCscudyHPPMMTsz4Az7VCBsBWd0Xk8wu+eJa7wSTyDP2NePbJIc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqUPR1DpMS0MW+t4dNpbDi8HeTNbdmqoL/BDEgyZgha6Wy2nWr
	OZ4WV2/LSxXrsoJ9P2jYVNOAoNmo9fN+1KqVuNjRL31WlJtArEnIuuJrm0gcxTTu4FFW8ZV8hqN
	NYA==
X-Google-Smtp-Source: AGHT+IE+D7P5FL0ahoVlcq9P7kEER6bVqpKARxPS0zk7xyFxuVv8bFBUXfQ/Ook8UnSyIIw/scGTO80UaRk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4706:b0:6e2:a355:7b5c with SMTP id
 00721157ae682-6e32f33bf7emr177b3.5.1728489009508; Wed, 09 Oct 2024 08:50:09
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:46 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-8-seanjc@google.com>
Subject: [PATCH v3 07/14] KVM: selftests: Only muck with SREGS on x86 in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Try to get/set SREGS in mmu_stress_test only when running on x86, as the
ioctls are supported only by x86 and PPC, and the latter doesn't yet
support KVM selftests.

Reviewed-by: James Houghton <jthoughton@google.com>
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
2.47.0.rc0.187.ge670bccf7e-goog

