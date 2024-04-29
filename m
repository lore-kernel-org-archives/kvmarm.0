Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A8317995E
	for <kvmarm@lists.linux.dev>; Mon, 29 Apr 2024 21:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714424541; cv=none; b=s42myVQ78BE1M7WWIn3Mx8XBms0Czlfhbue0U0KfCe3O+v8UPWXzuopaMtd1/1edMD52lfgBQcR4MlFKtMRD3KC049CxkkHxCeBM6ageFOrxuxPRamYSWFUHbF7Hgh+pf1XA9bU2RXLHk6yGfNhfetKjYobPGmvg5Cgfd4+1N6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714424541; c=relaxed/simple;
	bh=AbBtsHCGar1oC19onEj9oM1dARfaM70Gs2h5fz5fNyM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HCwtnPAM3fgGEPjTv8HYTFelRoVADVmSK30TLbFa0BWWdK8dreY9T7bAl9UZi7lRg2IeZgKh6vx+AgL/e4ZjmwGdA4B9f0m1fdvherINUkCMQPMDqJ82Jb01zBeCnUIIr1CwckKgjmLpakTQ+Z92CdbOpSDiq3l3zRlCPKDZqgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=St5n+6KY; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="St5n+6KY"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5dbddee3694so3067126a12.1
        for <kvmarm@lists.linux.dev>; Mon, 29 Apr 2024 14:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714424538; x=1715029338; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2uDJDJTdqMi/qWILeG2gkRWiCPiQQS9JXQ1eVQSPrTY=;
        b=St5n+6KYou1zW9RGTCSi0wM85emsIp0UKbKCtuEf9WwEzzHTCpmXVvrkN2/d2b6JxE
         GLXG9O0mC5fbu7+cMlMrEbN4JdtaE84PYuthucF4Rt2kq0gibTUdQyecMig452cF7Hki
         LvS4CDbB9DvbLl0RK61ssoutotfzpoyGgU0++SU8opunHuXoZeqcEDmf2wn1TEpP0EG8
         zOM+cyzERKX9eoeexwi4eYvsO7egXZpvIQRi/KZ7PxT0X2GYHBx5tn1h16IKA2krsnTZ
         z8y0Mk1R4ip56lQWzBS6Smq633mLnVlUElSL7N16/cpaqksXPvf+CnXRD/Cz58XMDUAv
         o0oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714424538; x=1715029338;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2uDJDJTdqMi/qWILeG2gkRWiCPiQQS9JXQ1eVQSPrTY=;
        b=QmonYi8+W/mpsRbQWW4rDOaXDojhcZ/49e2jwTQg80XILvZ51vi+0gDppZhTz33fjp
         X13hmY21WjtYmMil1Ew9uh4KfPBwn0Zmj/FrHIFZhQn7iICl6S8i2DT6TQG218Lu6aYe
         xHJCEmH2aXzZJkAMQs2ipCGh6n2DgFwci761kVfU1+I9qML1Glr9WNiplVt/BNI2kuJE
         CWY2HaYVXbSTEF/toYIT94ZTsXww+EI5wf6fxKj1TBumLkljH5Kg92WH0mH3Ih9n2Mxb
         85YqVmkT7ySu3zp3OvqEj6wOg4Zxub/XIpg4QQlj5P4/DQvZ/LHUnt79pFpV9nyVMcpy
         U2Vw==
X-Forwarded-Encrypted: i=1; AJvYcCVqdLD6KmFuOq7A4CNT8tRaQBZt6elLZZw0jPCZtbpixjWbbKf3uPnVBjdkS0oPUp+zOE9NuCgrDqVE5lBnISmzJwEcg5xv
X-Gm-Message-State: AOJu0Yx6fIr10Sugq6nGBe+x3gXXLVpmtu9zwk5ZJSrcbDTWKyfDSLgN
	1xCF8H0QzEKrJAT1SVgcKBhQ9wfwTVEgze+Xo2cepVXpAnDqrf3Fw3JvP7aqNBxD1gJ4EKajwJ1
	ppw==
X-Google-Smtp-Source: AGHT+IHjxlO7BGwfLpJTaM2K2yepr+Df3RVVAMz1TW/z+nRfFSnOvH5P7k7vUxx/UM3fHPC+zECxCajQyZo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3d84:0:b0:5f4:246c:1406 with SMTP id
 k126-20020a633d84000000b005f4246c1406mr2059pga.3.1714424538307; Mon, 29 Apr
 2024 14:02:18 -0700 (PDT)
Date: Mon, 29 Apr 2024 13:45:21 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <171442343194.161918.3828509492626949358.b4-ty@google.com>
Subject: Re: [PATCH 00/18] KVM: selftests: Clean up x86's DT initialization
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 14 Mar 2024 16:26:19 -0700, Sean Christopherson wrote:
> The vast majority of this series is x86 specific, and aims to clean up the
> core library's handling of descriptor tables and segments.  Currently, the
> library (a) waits until vCPUs are created to allocate per-VM assets, and
> (b) forces tests to opt-in to allocate the structures needed to handler
> exceptions, which has result in some rather odd tests, and makes it
> unnecessarily difficult to debug unexpected exceptions.
> 
> [...]

Applied to kvm-x86 selftests_utils (I had already pushed stuff to "selftests",
so the name is less than awesome).

Other KVM maintainers, I also created tags/kvm-x86-selftests-utils if you want
to pull this into your tree to avoid later merge conflicts with the
kvm_util_base.h => kvm_util.h rename.  I don't expect to push anything else to
the branch, but never say never. 

Note, this branch+tag also has the _GNU_SOURCE change, and the global pseudo-RNG
series ("thank yous" incoming), i.e. it's hopefuly a one stop shop for all your
6.10 selftests needs!

[01/18] Revert "kvm: selftests: move base kvm_util.h declarations to kvm_util_base.h"
        https://github.com/kvm-x86/linux/commit/2b7deea3ec7c
[02/18] KVM: sefltests: Add kvm_util_types.h to hold common types, e.g. vm_vaddr_t
        https://github.com/kvm-x86/linux/commit/f54884f93898
[03/18] KVM: selftests: Move GDT, IDT, and TSS fields to x86's kvm_vm_arch
        https://github.com/kvm-x86/linux/commit/3a085fbf8228
[04/18] KVM: selftests: Fix off-by-one initialization of GDT limit
        https://github.com/kvm-x86/linux/commit/0d95817e0753
[05/18] KVM: selftests: Move platform_info_test's main assert into guest code
        https://github.com/kvm-x86/linux/commit/53635ec253c0
[06/18] KVM: selftests: Rework platform_info_test to actually verify #GP
        https://github.com/kvm-x86/linux/commit/dec79eab2b48
[07/18] KVM: selftests: Explicitly clobber the IDT in the "delete memslot" testcase
        https://github.com/kvm-x86/linux/commit/61c3cffd4cbf
[08/18] KVM: selftests: Move x86's descriptor table helpers "up" in processor.c
        https://github.com/kvm-x86/linux/commit/b62c32c532cd
[09/18] KVM: selftests: Rename x86's vcpu_setup() to vcpu_init_sregs()
        https://github.com/kvm-x86/linux/commit/d8c63805e4e5
[10/18] KVM: selftests: Init IDT and exception handlers for all VMs/vCPUs on x86
        https://github.com/kvm-x86/linux/commit/c1b9793b45d5
[11/18] KVM: selftests: Map x86's exception_handlers at VM creation, not vCPU setup
        https://github.com/kvm-x86/linux/commit/44c93b277269
[12/18] KVM: selftests: Allocate x86's GDT during VM creation
        https://github.com/kvm-x86/linux/commit/2a511ca99493
[13/18] KVM: selftests: Drop superfluous switch() on vm->mode in vcpu_init_sregs()
        https://github.com/kvm-x86/linux/commit/1051e29cb915
[14/18] KVM: selftests: Fold x86's descriptor tables helpers into vcpu_init_sregs()
        https://github.com/kvm-x86/linux/commit/23ef21f58cf8
[15/18] KVM: selftests: Allocate x86's TSS at VM creation
        https://github.com/kvm-x86/linux/commit/a2834e6e0b98
[16/18] KVM: selftests: Add macro for TSS selector, rename up code/data macros
        https://github.com/kvm-x86/linux/commit/f18ef97fc602
[17/18] KVM: selftests: Init x86's segments during VM creation
        https://github.com/kvm-x86/linux/commit/0f53a0245068
[18/18] KVM: selftests: Drop @selector from segment helpers
        https://github.com/kvm-x86/linux/commit/b093f87fd195

--
https://github.com/kvm-x86/linux/tree/next
