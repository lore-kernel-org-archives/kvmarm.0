Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194AA33993
	for <kvmarm@lists.linux.dev>; Wed, 22 May 2024 01:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716342029; cv=none; b=vB0UKg8ENSCFxoYxLh+WUORr7W1fqkIoDqouNRZutkuVFSDGSLlgEAtd0JfUp7hKTZ+AUzxZGxAekJW+kgS6CNvvI2TfFqD+4pYIEg51MgOeVxU0ZpR7kztaYyQ3KLq0z11geBIWjKfGvKvLDPQ8U/DEqWZ4MSJVKtG8nYEOEOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716342029; c=relaxed/simple;
	bh=FJaY5ZXsWt+iV/k6HY2WFFz74BTaJg/mMtL9qyrhSP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UxbrgjWIXe2lp9/1niz3662Bfc9VY7TXcY2cOgeZ8pX/H+Ep4jz+F5jDcncLqgiZUe4L5doSibPppzp7KEV+OEQCzrZ6Tpj5wA3dQ1s2BIRrJXO81g4dMFwi5Zd7gVCpZO964GXEXTwgzajKKD4RSK/aEk9gKCMTxbcqOSj9sTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4HURiaVR; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4HURiaVR"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61be4b79115so261182557b3.1
        for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 18:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716342027; x=1716946827; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=N3tcdNqgpk0g0Qawt6D2SIU8FL4Y9j5vsBcc8xUlRY4=;
        b=4HURiaVRwEFFSkZ05HhmnwfqImTUD652VFl5uIW9EdEY7qEhBuJy/uMNUP/Nh7oKyg
         6Kdj5SdaS0fMc+OVDnbBbeM3JGbj1+DkwXotdYjankZWYN8tvaGetHe6wTShuS32b0bV
         B65Orj6iCSzc4eUWrjkeKae70ulXwZMxTGy6kTtBvIW3o7VmnYeOo0P3j3BAtmcdaE/Q
         x1aaFXeku8YtCtydLflGHDuehF7Bk6bAhLLqlEaYybk3UVXNeYTMj3C3ZVUboTQnBuUN
         HfDE0VrxaWLLANREzhpJy9S/maANXp0Tgn1AG8VgBeVuiuJPgUGHxG4c7mRIFCqDrN6i
         RB1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716342027; x=1716946827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N3tcdNqgpk0g0Qawt6D2SIU8FL4Y9j5vsBcc8xUlRY4=;
        b=kRwaW/BBAQADLBL/2d9BJV8o92R2c5og2z8UMyvVFYHF+oPqAstN/1ndDf27mVGVnD
         mN26KUhpji7QKVG9cQkUdDUTxf0Xo5tcrpRIeUcATcFMneltt3RwuwSJhBnFUzYkH6FD
         XvafXmJtIcVoH7ICF2dQEdPXSG0EVTiGf7RW7s56lPJfFI4PNFW2+S72E75RgzWPc+yJ
         eKGt36Rg5FE/7g3CUdUOxA8LRaNMLMrDCZa2Fk2SYD0jGA2CsEO+8TVFWtUbO8XECuwd
         e7+3hyw7gNQ6n+vzDHoFpbpWFxYKr/j3Vrn2whgWVkLTtAKe5i7m2OCTCsOFoLYv0BW/
         IFLg==
X-Forwarded-Encrypted: i=1; AJvYcCVunObBv6fBpW84ZwXaKFDI2uJO5eT+1VvSoGflEf7+JqokwS5b5LOIJoVR5X219kqDqW55MuF6m46K5hG8LQth3nFg/ehD
X-Gm-Message-State: AOJu0YyqzXJB08bmm2zEE7VqQ5dWaSL/F72KVKW9CPbyEQwRSH6HocOp
	/bhtGkMpK/vIooE9qDIOFLoW8239wrhWBQ5MefbyUVqvlQK6aBPavMx7ncyYoLWuoWeBYHIFaK3
	gNA==
X-Google-Smtp-Source: AGHT+IFL81/qwy5rtkuJ10qcaRdu2JQbneM9E+pjVdbps1/0e/VA4O7XiaE6CliC0DQxJV6ImSRXVMyGgXw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4984:0:b0:61b:e6d8:1c01 with SMTP id
 00721157ae682-627e487fd2emr1914977b3.10.1716342027243; Tue, 21 May 2024
 18:40:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 21 May 2024 18:40:13 -0700
In-Reply-To: <20240522014013.1672962-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240522014013.1672962-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240522014013.1672962-7-seanjc@google.com>
Subject: [PATCH v2 6/6] KVM: x86: Drop now-superflous setting of
 l1tf_flush_l1d in vcpu_run()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Now that KVM unconditionally sets l1tf_flush_l1d in kvm_arch_vcpu_load(),
drop the redundant store from vcpu_run().  The flag is cleared only when
VM-Enter is imminent, deep below vcpu_run(), i.e. barring a KVM bug, it's
impossible for l1tf_flush_l1d to be cleared between loading the vCPU and
calling vcpu_run().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 ++++---
 arch/x86/kvm/x86.c     | 1 -
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index da2f95385a12..552b6a9887a5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6672,9 +6672,10 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 		bool flush_l1d;
 
 		/*
-		 * Clear the per-vcpu flush bit, it gets set again
-		 * either from vcpu_run() or from one of the unsafe
-		 * VMEXIT handlers.
+		 * Clear the per-vcpu flush bit, it gets set again if the vCPU
+		 * is reloaded, i.e. if the vCPU is scheduled out or if KVM
+		 * exits to userspace, or if KVM reaches one of the unsafe
+		 * VMEXIT handlers, e.g. if KVM calls into the emulator.
 		 */
 		flush_l1d = vcpu->arch.l1tf_flush_l1d;
 		vcpu->arch.l1tf_flush_l1d = false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 60fea297f91f..86ae7392cc59 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11264,7 +11264,6 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	int r;
 
 	vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
-	vcpu->arch.l1tf_flush_l1d = true;
 
 	for (;;) {
 		/*
-- 
2.45.0.215.g3402c0e53f-goog

