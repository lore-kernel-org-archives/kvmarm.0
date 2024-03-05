Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58BE85944
	for <kvmarm@lists.linux.dev>; Tue,  5 Mar 2024 15:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709653189; cv=none; b=Zq8GoPvgwzGjLBlh6xBGqa8dpyaJyhVm0zkEA74vNVwZegUov9wZLPX/zFk8tCurYmOZv48+Be1Wj/qqR/qR65+14i/3LN0Uy9EPD80Zx0gXTlxl0fkXgvbNOme60r9ib8EsCd+isKtZn0CQiEdeSE9JYigZ4CO8xH0dzTKnAa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709653189; c=relaxed/simple;
	bh=SOPn+LGQ9aR4zkLvr2256Iz/ahqbcnZ+Gq/iOGSyy2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XandV7BqwD53TqUPv1fPjql9BaRL7mM9e9Yzpe7+o+MYsyn2Y7g7Q+WqLS0PnRo/k/Lg3lzKhb0QyMi7ab6FNUVJIruMAYxFK1HcG7M5Olp3NT539AdaHgNFVX8tiSgrI7NKrds8xQKS1pVPw2LRXSFU8KYU+eKSOI0Ae2QQDUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oa8QvU2M; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oa8QvU2M"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e4d0e28cd1so4540351b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 05 Mar 2024 07:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709653187; x=1710257987; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y2+QNZsGB7vBwDONJtQuDYHORz8pvCTwyrAobu/LpG4=;
        b=oa8QvU2MbaID2GDvZQfJyPfhH+mEY9Qh932Eyd5pl48bSy1LZF9B/sOXjO0MRUQs3U
         UaK4HFONtNKlYRUalfu7pykI+ioFSbn0TKeC8l+U+BGpbQi2nLBtnK6HheBcbipoAZLF
         BxRqLXXtajT+qHlDllWE3hRSh+ljcygDo/B33T1fzzx6jWAVHtY9kf2C8tDHOLJTREK4
         c8VAFTGDD9udb8+4XbgB1NeeO2WskKeR2zQDeTysku9Az747C6Auwue3YEyCC9+R3kP3
         6f0TN2AO4cinw+V2SHxvMM304O0thNSOOinKp1wUw5mdDShc8qEmsup5gj9TsoV54/rK
         /y/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709653187; x=1710257987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y2+QNZsGB7vBwDONJtQuDYHORz8pvCTwyrAobu/LpG4=;
        b=OzgPkomvTR4iNnI0o1ULdFTU0xRzYxWuxzZOuw90kndVFeQlRm3Bkm3gejosiBHa2e
         xfpZ01/wWoDF59HpQxbKJZcRf3SlOe7gsU8Z3PpbZ65ChXDsrvjmpevJL1+KY19XjMBN
         qJZyvMuCuO2w5hP7TQOlzyFfSO6rEW98PtLlZvEPFq+wzzSKgiSMcDAamrX/qbatAhp3
         ebKG8KcbWeZhtj78YyC656GwX1RnMNvlrVU6CyiZ6qz+3pdcSJssMcij9knGautCrxnA
         BZzS/domcAvuwbWTCigq7q9iGNuSy7Lf21AKhpAfEHeJ6phu+ggw9Dndt7rqieLszEqG
         Yepw==
X-Forwarded-Encrypted: i=1; AJvYcCVx1H9+bvQzYDLLzQncMx1TXHjcY5qQlHiTKDwU+4hQg6VCaKQtMYh5iN7CB4P9gzuqQnyuhfAOlbATfi9yj5AUXedv5+ll
X-Gm-Message-State: AOJu0YwEf/iMnwa6SpU+9md+ptYjOeDusJZOPPQ6tE44ueP2xYjU4Fq6
	IkUMCUGIHP9MMaiYMgWP7B8fmdn5f5ZuyIoMLmn4cuFCpRrzqKGrfzlV8rp3pJCXDx0yWm/XDu1
	gzA==
X-Google-Smtp-Source: AGHT+IEWf/wnSiieRPHpf8VMzJDEgUGq3r1WyDXmi+v8L/+r4DjFPQtsJOt6QRXW5vzBjW64rgvLCTl6NVQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8d1:b0:6e5:d02:6162 with SMTP id
 s17-20020a056a0008d100b006e50d026162mr95902pfu.0.1709653187173; Tue, 05 Mar
 2024 07:39:47 -0800 (PST)
Date: Tue, 5 Mar 2024 07:39:45 -0800
In-Reply-To: <ZeZu9D3Ic_1O5CIO@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-9-amoorthy@google.com>
 <ZeYoSSYtDxKma-gg@linux.dev> <ZeYqt86yVmCu5lKP@linux.dev> <ZeYv86atkVpVMa2S@google.com>
 <ZeY3P8Za5Q6pkkQV@linux.dev> <ZeZP4xOMk7LUnNt2@google.com> <ZeZu9D3Ic_1O5CIO@linux.dev>
Message-ID: <Zec8stHiFS3KOOPt@google.com>
Subject: Re: [PATCH v7 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO and
 annotate fault in the stage-2 fault handler
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Anish Moorthy <amoorthy@google.com>, maz@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, jthoughton@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 05, 2024, Oliver Upton wrote:
> On Mon, Mar 04, 2024 at 02:49:07PM -0800, Sean Christopherson wrote:
> 
> [...]
> 
> > The presense of MTE stuff shouldn't affect the fundamental access information,
> 
>   "When FEAT_MTE is implemented, for a synchronous Data Abort on an
>   instruction that directly accesses Allocation Tags, ISV is 0."
> 
> If there is no instruction syndrome, there's insufficient fault context
> to determine if the guest was doing a read or a write.
> 
> > e.g. if the guest was attempting to write, then KVM should set KVM_MEMORY_EXIT_FLAG_WRITE
> > irrespective of whether or not MTE is in play.
> 
> When the MMU generates such an abort, it *is not* read, write, or execute.
> It is a NoTagAccess fault. There is no sane way to describe this in
> terms of RWX.

RWX=0, with KVM_MEMORY_EXIT_FLAG_MTE seems like a reasonable way to communicate
that, no?

> > > > E.g. on the x86 side, KVM intentionally sets reserved bits in SPTEs for
> > > > "caching" emulated MMIO accesses, and the resulting fault captures the
> > > > "reserved bits set" information in register state.  But that's purely an
> > > > (optional) imlementation detail of KVM that should never be exposed to
> > > > userspace.
> > > 
> > > MMIO accesses would show up elsewhere though, right?
> > 
> > Yes, but I don't see how that's relevant.  Maybe I'm just misunderstanding what
> > you're saying/asking.
> 
> If "reserved" EPT violations found their way to userspace via the
> "memory fault" exit structure then that'd likely be due to a KVM bug.

Heh, sadly no.  Userspace can convert a GFN to private at any time, and the
TDX and SNP specs allow for implicit converstion "requests" from the guest, i.e.
KVM isn't allowed to kill the guest if the guest accesses a GFN with the "wrong"
private/shared attribute.

This particular case would likely be hit only if there's a userspace and/or guest
bug, but whether the setup is broken or just unique isn't KVM's call to make.

> The only expected flows in the near term are this and CoCo crap.
> 
> > > Either way, I have no issues whatsoever if the direction for x86 is to
> > > provide abstracted fault information.
> > 
> > I don't understand how ARM can get away with NOT providing a layer of abstraction.
> > Copying fault state verbatim to userspace will bleed KVM implementation details
> > into userspace,
> 
> The memslot flag already bleeds KVM implementation detail into userspace
> to a degree. The event we're trying to let userspace handle is at the
> intersection of a specific hardware/software state.

Yes, but IMO there's a huge difference between userspace knowing that KVM uses gup()
and memslots to translate gfn=>hva=>pfn, or even knowing that KVM plays games with
reserved stage-2 PTE bits, and userspace knowing exactly how KVM configures stage-2
PTEs.

Another example would be dirty logging on Intel CPUs.  The *admin* can decide
whether to use a write-protection scheme or page-modification logging, but KVM's
ABI with userspace provides a layer of abstraction (dirty ring or bitmap) so that
the userspace VMM doesn't need to do X for write-protection and Y for PML.

> > Abstracting gory hardware details from userspace is one of the main roles of the
> > kernel.
> 
> Where it can be accomplished without a loss (or misrepresentation) of
> information, agreed. But KVM UAPI is so architecture-specific that it
> seems arbitrary to draw the line here.

I don't think it's arbitrary.  KVM's existing uAPI for mapping memory into the
guest is almost entirely arch-neutral, and I want to preserve that for related
functionality unless it's literally impossible to do so.

> > A concrete example of hardware throwing a wrench in things is AMD's upcoming
> > "encrypted" flag (in the stage-2 page fault error code), which is set by SNP-capable
> > CPUs for *any* VM that supports guest-controlled encrypted memory.  If KVM reported
> > the page fault error code directly to userspace, then running the same VM on
> > different hardware generations, e.g. after live migration, would generate different
> > error codes.
> >  
> > Are we talking past each other?  I'm genuinely confused by the pushback on
> > capturing RWX information.  Yes, the RWX info may be insufficient in some cases,
> > but its existence doesn't preclude KVM from providing more information as needed.
> 
> My pushback isn't exactly on RWX (even though I noted the MTE quirk
> above). What I'm poking at here is the general infrastructure for
> reflecting faults into userspace, which is aggressively becoming more
> relevant.

But the purpose of memory_fault isn't to reflect faults into userspace, it's to
alert userspace that KVM has encountered a memory fault that requires userspace
action to resolve.

That distinction matters because there are and will be MMU features that KVM
supports, and that can generate novel faults, but such faults won't be punted to
userspace unless KVM provides a way for userspace to explicitly control the MMU
feature.

And if KVM lets userspace control a feature, then KVM needs new uAPI to expose
the controls.  Which means that we should always have an opportunity to expand
memory_fault, e.g. with new flags, to support such features.
