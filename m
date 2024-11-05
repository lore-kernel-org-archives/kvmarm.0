Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0891FCC61
	for <kvmarm@lists.linux.dev>; Tue,  5 Nov 2024 05:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730786033; cv=none; b=IWsVA0otpICtXwhbX6Cm8Voq+CgY7HY/plgHV3DFFrTxdSB5BVwDDKrGIwfBfpZ/GgwIhtcFobwb3Hl6TOVin/sOTmy0kO8dYsZReVhhc934i7uAHvNSRH/yOBvWhT8WlRES3SngZ9ZoAojPMoRMEqbxm0XZJ2uEQoeEsykWevM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730786033; c=relaxed/simple;
	bh=eJlzUMcpOmWHJiSJMWY8rp4QK+XoHVpYEtzFQswiFbk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tB/R4Tv4ZXTX+CaAszfEofd9tZOfTvItZqm8qSpGdhuCI/uWxLWdul8DyovX4VetZ3aOBW9XuEmbIE/tMzoT+NS2WXnvwdsh7pk69tA17KGkh94Hvdnde+PYLBji4Jztc5h8CzclMMtc1lb4NgHtCU4NwiwE3F8PCEwVP9cfzsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HX3h0XvD; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HX3h0XvD"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ea8a238068so41630827b3.1
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 21:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730786030; x=1731390830; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o6I0lsXsH1rGJHzKMzLgK+XDkNKkWp36WmP2kFDs1jI=;
        b=HX3h0XvD0nLCRN4Ta1MfBMJ9JGFAx85xwNArJWxcPyAz2Ev+qMEUtz6CG85oeVpvNn
         u2J6HKz9poCr+cGEcPteA8K0haTm3vmjXVIMwg/PrZXBb0mP50v51nlizjOilHr1XsZ1
         v0Y22luLOJez5a9wf68hxGMT2CPTJvJc3IK+CtqPaRN3BILnZKq5GbFvBsrTZOUytgjn
         1Dl0LWRC85N9mxDGE3D7biAr8dVTQCTYN9zwcRXUlmt8BlZYpc9qrvfbrVTqaN+YajcQ
         b5D+IfM2zOzuhAzUH3/a4QyQ/5QhTJd1uYWEsAKWaqH9d0JKv1l+G+s/HOeKHXOden+1
         oWqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730786030; x=1731390830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o6I0lsXsH1rGJHzKMzLgK+XDkNKkWp36WmP2kFDs1jI=;
        b=RTB/9soyxl29WSRstHhMKBPhA4mzvvG6qYNu3jUeU2b9s3FbN4I3eyVyP+U3tVwpRo
         GOkAEjR4q01TeuZWNLSYOEKanqzNHb7D0HqCW+p23O16VchyTBOWDKYFx5Xv9V7HiKXh
         u6TK96nKc+dRxsxVpatUnbyuOtGqgcs/8sMYi0JeB3C0/Ajif0lMbVHUa0XAhQqGidAj
         55EYa0Bs8ZXj2dDmowDzuuF+Z771bUUiZsSpyZga01ItD+/WlbjVkg1av2Npikupn7/b
         5VKUZU9gGZB54e5u9vo9B6PSEF22lRm+JTaY9IY5MiYZihMamMfaikIXymTZAcvjMOXx
         BpjQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/+Bl9eEe2cWd38Xz5a/lkbGnmdblRLMHMl6g7YyLwJkWomJmD7blOCUM07XwdY2yhso9kXEU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwxH8dCbhjF9zHh0IShXCW/vQWgoghhSZuLJrL/sDNgAiFDNTO8
	g+pEtMKuwHUevZrxAoqm0RKbw08sqgUkZHrfk/W7iyPSRwbfSjOlXxbgpMLBwL5iTzMxx3mjfVZ
	xUw==
X-Google-Smtp-Source: AGHT+IHmt5sO/CGCgduHfJxMGbReWDqaMZI7StkG46sJTWcczU8fUEuPHD4g/HJnJzDHoYjdX9OGGAkVpzc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4489:b0:6db:c6eb:bae9 with SMTP id
 00721157ae682-6e9d898f08bmr16943867b3.2.1730786030202; Mon, 04 Nov 2024
 21:53:50 -0800 (PST)
Date: Mon, 4 Nov 2024 21:53:48 -0800
In-Reply-To: <173039503553.1508387.3074658713815866060.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com> <173039503553.1508387.3074658713815866060.b4-ty@google.com>
Message-ID: <Zymy7M5dHs6dWUmu@google.com>
Subject: Re: [PATCH v3 00/14] KVM: selftests: Morph max_guest_mem to mmu_stress
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 31, 2024, Sean Christopherson wrote:
> On Wed, 09 Oct 2024 08:49:39 -0700, Sean Christopherson wrote:
> > The main purpose of this series is to convert the max_guest_memory_test
> > into a more generic mmu_stress_test.  The basic gist of the "conversion"
> > is to have the test do mprotect() on guest memory while vCPUs are
> > accessing said memory, e.g. to verify KVM and mmu_notifiers are working
> > as intended.
> > 
> > Patches 1-4 are a somewhat unexpected side quest.  The original plan was
> > that patch 3 would be a single patch, but things snowballed.
> > 
> > [...]
> 
> Applied to kvm-x86 selftests, with the typo fixup pointed out by James.  Thanks!
> 
> [01/14] KVM: Move KVM_REG_SIZE() definition to common uAPI header
>         https://github.com/kvm-x86/linux/commit/5e07fd0bf516
> [02/14] KVM: selftests: Disable strict aliasing
>         https://github.com/kvm-x86/linux/commit/d1ce2bcd8d2e
> [03/14] KVM: selftests: Return a value from vcpu_get_reg() instead of using an out-param
>         https://github.com/kvm-x86/linux/commit/5c6c7b71a45c
> [04/14] KVM: selftests: Assert that vcpu_{g,s}et_reg() won't truncate
>         https://github.com/kvm-x86/linux/commit/6aa2df3eb90b
> [05/14] KVM: selftests: Check for a potential unhandled exception iff KVM_RUN succeeded
>         https://github.com/kvm-x86/linux/commit/be9f2746d20b
> [06/14] KVM: selftests: Rename max_guest_memory_test to mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/06694f27cfcc
> [07/14] KVM: selftests: Only muck with SREGS on x86 in mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/8556ce365a07
> [08/14] KVM: selftests: Compute number of extra pages needed in mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/c7b7876ac5d4
> [09/14] KVM: sefltests: Explicitly include ucall_common.h in mmu_stress_test.c
>         https://github.com/kvm-x86/linux/commit/a657856469e1
> [10/14] KVM: selftests: Enable mmu_stress_test on arm64
>         https://github.com/kvm-x86/linux/commit/1e53cde06102
> [11/14] KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/8630563012b9
> [12/14] KVM: selftests: Precisely limit the number of guest loops in mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/3d4585c220dc
> [13/14] KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/eaafeebca75a
> [14/14] KVM: selftests: Verify KVM correctly handles mprotect(PROT_READ)
>         https://github.com/kvm-x86/linux/commit/a3cd5c187742

As mentioned later in the thread[*], I dropped this series from the 6.13 queue
and will instead target 6.14.

I did however grab the no-strict-aliasing fix for 6.12, and tagged it for stable.
There's no reason to wait to land that commit, and I definitely have no desire to
ever debug that mess again.

[02/14] KVM: selftests: Disable strict aliasing
      https://github.com/kvm-x86/linux/commit/5b188cc4866a

[*] https://lore.kernel.org/all/ZyT61FF0-g8gKZfc@google.com
