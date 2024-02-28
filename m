Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0692B9A7
	for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 22:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709160030; cv=none; b=qq/3+49e3Bhb3bA1GXiYKlUXDTbVDnVFJ0S2kiZgeIusxoS7R0V+fDPKdPGSNeCfnnbzCLARl5qy6cX2dKmeY0WqJF4upJpJ6Q9t8K7obb931mcL948sF2QH2bsf4u1doJcG+QIh/E4Y7fO/G1gOt2zZNjTATbR3RinMm7L+12M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709160030; c=relaxed/simple;
	bh=UI4N3O0p1OPV51s6ww8VE+iOxUsmCX0+oAuufGaCP2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jIK21neXITyLrtsVHicFwimE9D+4KRKTKU3vGovfLTaQoBO/v7DhU1B4IvwzufvW/Chr7H/d2ZXPZbYWY1I0w50RqkC6iL23/0ucwemwv0tx/QVJRI0dOIqxQevqWgj/lnHdX/lNzxY72JOHTSXRRCY1BQIWbs2CHg0bTwEZrl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kzf81D3c; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kzf81D3c"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60942936e31so4849277b3.1
        for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 14:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709160027; x=1709764827; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l+UTQgqjeTeuB4joWxs/sUGJ8L/gPUO2H1zeCMeGlUc=;
        b=Kzf81D3cefJwIT/SffujprSjJN+2ilp7PD56kvcVjZCd7NJp2cDYzYoDXn/qwMKbf0
         +WTwKIS9lfOjopuXcivDM8gebQ3+MRe1oZiYeoNE5MRbTcFNrBj4lQaR1zSN3XIQa64G
         KeEEJQ20qb9UxgNk5OEa7ar6iG4cjXmRefHjaDVCc1pHoEqDdCOjgBEd6nZ7MfiyV8aJ
         RZ0w9ZhrbfFhKR/VPH5FnDjPxNureoyPhSXPP0XGsIJR6tXqKtWLKpTfXzTWJ719qwWJ
         RMgwbZevj1Av7SSYZPaoDRPUsW/Q4Qn0OvrRN6zDqmKDr+j4OeIOd8p3F+9CAxJw2UgK
         YKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709160027; x=1709764827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l+UTQgqjeTeuB4joWxs/sUGJ8L/gPUO2H1zeCMeGlUc=;
        b=Str2Y9PPwOiuVGKYysTbW8Ja9g54smb/FcO2tydHktjlgH8DNMkhG3ui4UIvkK39QU
         95MXqqVT9izh8nzFgMjyw7waX2jZN0aRSpBSw+AyLni4wcAIdV2tAS407PWKWaL/exgJ
         aoFUInhx9eIvNMRWfW+iBRrWR2DeQU2QCRkZIVj6yiacbPeX4ddKOUEZdS9eHEyyeQhy
         9B0sM2Wst2GcX7lrvf2/KUok/+g2pVK3eb4j/YpkQtIoXZx1eWzOOWVG4+E8u9uoBbm0
         m2M7HFnNptStubh2tJBq+cxG3fHW+W/VjVdErbt9oSu/2MAPBnKRnJ9wUldl29+1PCxw
         ZYzQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3+2wIo8X2l+dmK7Rhd3jF1ZKOuzSNw9mqErgIqfE/rRc2yRxEbkggUQIHqCtmI5kvREAjUYcPSlyfbcZCM4hZBx4+BDZ2
X-Gm-Message-State: AOJu0Yyp6VJkD69jDdDGjOnky1u7yQNjkKA5f/vYiy4pQrIqGVbPcvcd
	hoWnz1Z1CvoRtXqBeOsESS4ZjwjsG1FBEGZKTUuXj7wgfyr0LA3YJ3MWAl9FCbjF+HLyJgfeXaB
	4Mg==
X-Google-Smtp-Source: AGHT+IFUPZtJnUkx4ZeqCTT90Ca+tWDsq48kFwktE+9CygIbxZw4LB/eimUqGjDzbeY7BpvlpduVfE/E17k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:abc2:0:b0:dc7:48ce:d17f with SMTP id
 v60-20020a25abc2000000b00dc748ced17fmr140494ybi.10.1709160027352; Wed, 28 Feb
 2024 14:40:27 -0800 (PST)
Date: Wed, 28 Feb 2024 14:40:20 -0800
In-Reply-To: <170900037528.3692126.18029642068469384283.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com> <170900037528.3692126.18029642068469384283.b4-ty@google.com>
Message-ID: <Zd-2VK2kvMr_t1jx@google.com>
Subject: Re: [PATCH v9 00/11] KVM: selftests: Add SEV and SEV-ES smoke tests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 26, 2024, Sean Christopherson wrote:
> On Thu, 22 Feb 2024 16:42:47 -0800, Sean Christopherson wrote:
> > Add basic SEV and SEV-ES smoke tests.  Unlike the intra-host migration tests,
> > this one actually runs a small chunk of code in the guest.
> > 
> > Unless anyone strongly objects to the quick and dirty approach I've taken for
> > SEV-ES, I'll get all of this queued for 6.9 soon-ish.
> > 
> > As for _why_ I added the quick-and-dirty SEV-ES testcase, I have a series to
> > cleanup __svm_sev_es_vcpu_run(), and found out that apparently I have a version
> > of OVMF that doesn't quite have to the right <something> for SEV-ES, and so I
> > could even get a "real" VM to reach KVM_RUN.  I assumed (correctly, yay!) that
> > hacking together a selftest would be faster than figuring out what firmware
> > magic I am missing.
> > 
> > [...]
> 
> Applied to kvm-x86 selftests, thanks!
> 
> [01/11] KVM: selftests: Extend VM creation's @shape to allow control of VM subtype
>         https://github.com/kvm-x86/linux/commit/309d1ad7b6ff
> [02/11] KVM: selftests: Make sparsebit structs const where appropriate
>         https://github.com/kvm-x86/linux/commit/6077c3ce4021
> [03/11] KVM: selftests: Add a macro to iterate over a sparsebit range
>         https://github.com/kvm-x86/linux/commit/8811565ff68e
> [04/11] KVM: selftests: Add support for allocating/managing protected guest memory
>         https://github.com/kvm-x86/linux/commit/29e749e8faff
> [05/11] KVM: selftests: Add support for protected vm_vaddr_* allocations
>         https://github.com/kvm-x86/linux/commit/1e3af7cf984a
> [06/11] KVM: selftests: Explicitly ucall pool from shared memory
>         https://github.com/kvm-x86/linux/commit/5ef7196273b6
> [07/11] KVM: selftests: Allow tagging protected memory in guest page tables
>         https://github.com/kvm-x86/linux/commit/a8446cd81de8
> [08/11] KVM: selftests: Add library for creating and interacting with SEV guests
>         https://github.com/kvm-x86/linux/commit/f3ff1e9b2f9c
> [09/11] KVM: selftests: Use the SEV library APIs in the intra-host migration test
>         https://github.com/kvm-x86/linux/commit/0837ddb51f9b
> [10/11] KVM: selftests: Add a basic SEV smoke test
>         https://github.com/kvm-x86/linux/commit/5101f1e27683
> [11/11] KVM: selftests: Add a basic SEV-ES smoke test
>         https://github.com/kvm-x86/linux/commit/f3750b0c7f6e

FYI, the hashes changed due to a force push to squash a bug in a different
series.

[1/11] KVM: selftests: Extend VM creation's @shape to allow control of VM subtype
      https://github.com/kvm-x86/linux/commit/126190379c57
[2/11] KVM: selftests: Make sparsebit structs const where appropriate
      https://github.com/kvm-x86/linux/commit/35f50c91c43e
[3/11] KVM: selftests: Add a macro to iterate over a sparsebit range
      https://github.com/kvm-x86/linux/commit/57e19f057758
[4/11] KVM: selftests: Add support for allocating/managing protected guest memory
      https://github.com/kvm-x86/linux/commit/cd8eb2913205
[5/11] KVM: selftests: Add support for protected vm_vaddr_* allocations
      https://github.com/kvm-x86/linux/commit/d210eebb51a2
[6/11] KVM: selftests: Explicitly ucall pool from shared memory
      https://github.com/kvm-x86/linux/commit/31e00dae72fd
[7/11] KVM: selftests: Allow tagging protected memory in guest page tables
      https://github.com/kvm-x86/linux/commit/bf47e87c65be
[8/11] KVM: selftests: Add library for creating and interacting with SEV guests
      https://github.com/kvm-x86/linux/commit/bdceeebcddb8
[9/11] KVM: selftests: Use the SEV library APIs in the intra-host migration test
      https://github.com/kvm-x86/linux/commit/8b174eb9d289
[10/11] KVM: selftests: Add a basic SEV smoke test
      https://github.com/kvm-x86/linux/commit/faa0d7027de3
[11/11] KVM: selftests: Add a basic SEV-ES smoke test
      https://github.com/kvm-x86/linux/commit/974ba6f0e595
