Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593A7288DF
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 02:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711592940; cv=none; b=bMhtNGC9wb0kvh650STjXmcveHGuU52TJW6rwgdwmVAHYf0cVJCWEeEHAmJJ17bxcFoQOVtwVfaB0J1bFWL7EMGXSPO1y+zhVbh3kjA8AQGm0/13EtehoqyJwbk5HpUq5VDpbFhlUbu/gbDLEj5EUXeGUKQcmfjmX5AE2on4sJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711592940; c=relaxed/simple;
	bh=qJqf+gspYBFRI2K5imH74xBgzF2f9aynWHZqrtIDj+k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UB7CClCt4o53HMZ/r0g2FbbbtVFTbesle0zsctguhRBeIGLaAHZ3biIfgptC+FTyRlBAtljwxQPF5/ErpRG+IkGJRypIPnFo2CbNWIOs/hTB1IjUURiaJN4Sn3RJa386bFf7tXGVD6loQSuTCy8pUQ822aAAt+UnJnUhueAxeH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cUzSKmnd; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cUzSKmnd"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc693399655so838019276.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 19:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711592938; x=1712197738; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/QmOyqM5X2MNASCMJ2dyKBKMwyn+XBPI/URXs6ak0lY=;
        b=cUzSKmnd1yQ8v18p2DoXWxRaYLuXQQSEDu7i8J/0lCAKp74LW9bmP4ofgzQDGlHC0P
         ENt7Vf3SnVj+GLSBenNmiRuDmnc7RUR/83oXwkbgU0r/uRFAAJMOTFkTPY9ejZegqiaO
         lISJDIsL7p8xBUZ1mlRaKEkAILx9MAI5UjnMfGQ1UnNMlaxBGLZhuEwtsiCkW+IKfFg2
         p0ceC6JIiPvtCGpAF79vMT46EPbzoKKeJr5ex+DSktfNYS9hoyAqVGQp8YYNhjf/XYK9
         1PU6Z1zo6V9kwCccjis58r/rZzwlmju4ErFrjuyqfEGKuAejWFT3wHCkOnA2r/kTesN5
         Ndvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711592938; x=1712197738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/QmOyqM5X2MNASCMJ2dyKBKMwyn+XBPI/URXs6ak0lY=;
        b=u7iv7OiYUAztKEzdtLPsjadX0tZUS7dgq1Dm0OP9b0ZnjqDxJ/jTt6S7R12pj0uX1e
         9mlCrbWDoF13k6doiscr5/ElxCYTHuF6JzDwhr0WGqBamw7pFUZ3iB02zS+Ivvj7iW2n
         XAJDZA2Hal1jHC5WLDfUkL9lo04wZZeADGt1HJvPnf3HCrkTbwbwkQO7yO0V9pBZfaCQ
         IvtL6zULvEtp4c9QZJDPj7eR3fIxD4oqKRvFhxIZgJnFPmgm6vOFNv0mfPqcxym0SplD
         I5B+cveML36JRkP2iPf+S4Zs+64YiBa1h6Om4NJ/DeEWPSoYXyBNr79qDyiVyzye+kHB
         yM3w==
X-Forwarded-Encrypted: i=1; AJvYcCW313ngEKAgcfceGzDryJXKM4ChaS1RSxBytnhpWcja/gX04AkcTQl0A2wYXtxmD1Ch0t5u6l/wTBB4rfLbyIs5FeTyehBc
X-Gm-Message-State: AOJu0YzqgGIO7/W7lhVR4s4Z/NdGGnM4g39t/WhOV/ICItGKAqzbWfEH
	r3csqgceS3mqaTRbSM/u2EdNEHzkakD87JIgyh3XwSgZ/evUmKWe3eYNQetBJxTGE93LYnwM1Cl
	WHhWm9uq3S46ISTkH2o3ERg==
X-Google-Smtp-Source: AGHT+IG3h7UFptSbhQThXKYXVUxHjXW9GcRNRwfD8DnNx4fzNFxp960mZTVoDNqHvfoMy5v3WIivsTHuarJXGtUe7A==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:2290:b0:dc7:48ce:d17f with
 SMTP id dn16-20020a056902229000b00dc748ced17fmr489931ybb.10.1711592938320;
 Wed, 27 Mar 2024 19:28:58 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:28:51 +0000
In-Reply-To: <20240314232637.2538648-14-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-14-seanjc@google.com>
Message-ID: <diqz7chnm6n0.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 13/18] KVM: selftests: Drop superfluous switch() on
 vm->mode in vcpu_init_sregs()
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Replace the switch statement on vm->mode in x86's vcpu_init_sregs()'s with
> a simple assert that the VM has a 48-bit virtual address space.  A switch
> statement is both overkill and misleading, as the existing code incorrectly
> implies that VMs with LA57 would need different to configuration for the
> LDT, TSS, and flat segments.  In all likelihood, the only difference that
> would be needed for selftests is CR4.LA57 itself.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/lib/x86_64/processor.c      | 25 ++++++++-----------
>  1 file changed, 10 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 8547833ffa26..561c0aa93608 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -555,6 +555,8 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_sregs sregs;
>  
> +	TEST_ASSERT_EQ(vm->mode, VM_MODE_PXXV48_4K);
> +
>  	/* Set mode specific system register values. */
>  	vcpu_sregs_get(vcpu, &sregs);
>  
> @@ -562,22 +564,15 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  
>  	kvm_setup_gdt(vm, &sregs.gdt);
>  
> -	switch (vm->mode) {
> -	case VM_MODE_PXXV48_4K:
> -		sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
> -		sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
> -		sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
> +	sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
> +	sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
> +	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
>  
> -		kvm_seg_set_unusable(&sregs.ldt);
> -		kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
> -		kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
> -		kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
> -		kvm_setup_tss_64bit(vm, &sregs.tr, 0x18);
> -		break;
> -
> -	default:
> -		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
> -	}
> +	kvm_seg_set_unusable(&sregs.ldt);
> +	kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
> +	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
> +	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
> +	kvm_setup_tss_64bit(vm, &sregs.tr, 0x18);
>  
>  	sregs.cr3 = vm->pgd;
>  	vcpu_sregs_set(vcpu, &sregs);
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
