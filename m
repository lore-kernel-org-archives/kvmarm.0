Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09ACE38388
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 02:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000502; cv=none; b=aALsQ36up8Ghec+h3tDncMeo460IO43T4tMz9jr2Vuvo3LSnZx/HVtiFe1x/Mvh6o9IKyLyxxkdz8BrHcSsITdskcoOWdl6eqpgSF4C3/VTGzbCedST3XQWOlExnHbX6sPL5S4c1QTFSSFjvGeFFiHG/KTdayzcorpfa9+9SiRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000502; c=relaxed/simple;
	bh=AJavhWKrBehCz7d+YW7b+29aWJ1wgMQjIIWm/3TmNUs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ei76+mVxLyLrF5fAypSpBhJp1QpffGoNV8Aw/+5Zt3z9wOtLu1m6+LgDW3VYU98SgNCyulKanW0d2HQwyklQAnx7hxf4Vjm/FzqHUUqayqfxOdl2jVCYsF4/izA9BiDkAlVADQwOgkDR8WSTv8yPmrQ3aMVoH+guhL2C9v0Aawo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AG+ryfHm; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AG+ryfHm"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcc05887ee9so5299365276.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 18:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709000500; x=1709605300; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ghn/tsXt4bBeTaeh+x2q+YtPRUVSTzvBJxsTub2q9Gk=;
        b=AG+ryfHmFB3KRirIXrtbAeFMX3E259y1DOwJYsc76FP+MaTPVGE4Xmh8YjXoijeTuZ
         YtOXxs2ZhU25W4xId7hjIi41nv63SKwZZ/3CThFdvWkQOt+FGuiZrgcUsIrhesruMCwj
         UmAsQ6NUUAzGfAI0+vHqTlnUGtexVp/Z+yiKE3t/15ZJbC9ILi+A1g82V+16NBY426NQ
         TTlxSsAYOxeHlPXrtRi18dvhVtgzh+OX99shLN3UGQU3SzI9UVR8+0lY2SEZOWhj0qWI
         jqjGqCxmQlEXO6p+CPAwYvzk5CZ+sClmfaPjbezfcf7OTnEdQyhSOIl8KN7QR+rT6Nzc
         nIhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709000500; x=1709605300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ghn/tsXt4bBeTaeh+x2q+YtPRUVSTzvBJxsTub2q9Gk=;
        b=djV9O5VpYEDcy4fLRXYmW0lG+07MMxC4zcZ+VLUy7MA0gUoIsoXe1emc67GqeFtmXN
         kWkl72+RskL4kAdtHg8XXJUpcnLT0yfg3n2+zfBNI8AmSUh9ieTWKUrUBZzBKJV2jjRl
         p2nUchFnUju7F6XriE2OXs3qpYKNvt66CxZvE0SELU8kRdrVG+aJBNxyrEV/4XuFnZky
         h45xCICXEwFr30lTAtVu6YcT5rhg//ygTMIwwjacn1WSg8kFmz3rwYNw3m0ygSq5AGPA
         ErUrFibW1ejRIH6hzjtuzOaIPW9yIIY9EksWKYZyXMqNNq53852hzxRA26wYO2e04vFO
         6saA==
X-Forwarded-Encrypted: i=1; AJvYcCVor2lWrtsGOuNhhG9iXuvF6k1pALNy6chl07bAdj9ntss2gQs1Y3R40cLMEDUSzugnpUsIrN24jpppo2Pb+cqMoTcrtQby
X-Gm-Message-State: AOJu0YwB1xDXU4R1jXSvuV/eUaXT6ipSvk8pgH9XxvoGnyKiFsN7efzd
	zO366e4hfKBoFSyX4Iqnj1f5UGQGBTaF7CsVswopBz4/ypLPVA+CwxTaHAwyve3qSlA3oq2BChY
	Rpw==
X-Google-Smtp-Source: AGHT+IFOi9/tmN8AF5ckfIwhjyqA6w0EovzljiE14qM4BRVcycQBgccSndGNhkATEmtZADwvG8qyMKYgWso=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:a89:b0:dcd:2f3e:4d18 with SMTP id
 cd9-20020a0569020a8900b00dcd2f3e4d18mr49885ybb.12.1709000499927; Mon, 26 Feb
 2024 18:21:39 -0800 (PST)
Date: Mon, 26 Feb 2024 18:21:10 -0800
In-Reply-To: <20240223004258.3104051-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <170900037528.3692126.18029642068469384283.b4-ty@google.com>
Subject: Re: [PATCH v9 00/11] KVM: selftests: Add SEV and SEV-ES smoke tests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 22 Feb 2024 16:42:47 -0800, Sean Christopherson wrote:
> Add basic SEV and SEV-ES smoke tests.  Unlike the intra-host migration tests,
> this one actually runs a small chunk of code in the guest.
> 
> Unless anyone strongly objects to the quick and dirty approach I've taken for
> SEV-ES, I'll get all of this queued for 6.9 soon-ish.
> 
> As for _why_ I added the quick-and-dirty SEV-ES testcase, I have a series to
> cleanup __svm_sev_es_vcpu_run(), and found out that apparently I have a version
> of OVMF that doesn't quite have to the right <something> for SEV-ES, and so I
> could even get a "real" VM to reach KVM_RUN.  I assumed (correctly, yay!) that
> hacking together a selftest would be faster than figuring out what firmware
> magic I am missing.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[01/11] KVM: selftests: Extend VM creation's @shape to allow control of VM subtype
        https://github.com/kvm-x86/linux/commit/309d1ad7b6ff
[02/11] KVM: selftests: Make sparsebit structs const where appropriate
        https://github.com/kvm-x86/linux/commit/6077c3ce4021
[03/11] KVM: selftests: Add a macro to iterate over a sparsebit range
        https://github.com/kvm-x86/linux/commit/8811565ff68e
[04/11] KVM: selftests: Add support for allocating/managing protected guest memory
        https://github.com/kvm-x86/linux/commit/29e749e8faff
[05/11] KVM: selftests: Add support for protected vm_vaddr_* allocations
        https://github.com/kvm-x86/linux/commit/1e3af7cf984a
[06/11] KVM: selftests: Explicitly ucall pool from shared memory
        https://github.com/kvm-x86/linux/commit/5ef7196273b6
[07/11] KVM: selftests: Allow tagging protected memory in guest page tables
        https://github.com/kvm-x86/linux/commit/a8446cd81de8
[08/11] KVM: selftests: Add library for creating and interacting with SEV guests
        https://github.com/kvm-x86/linux/commit/f3ff1e9b2f9c
[09/11] KVM: selftests: Use the SEV library APIs in the intra-host migration test
        https://github.com/kvm-x86/linux/commit/0837ddb51f9b
[10/11] KVM: selftests: Add a basic SEV smoke test
        https://github.com/kvm-x86/linux/commit/5101f1e27683
[11/11] KVM: selftests: Add a basic SEV-ES smoke test
        https://github.com/kvm-x86/linux/commit/f3750b0c7f6e

--
https://github.com/kvm-x86/linux/tree/next
