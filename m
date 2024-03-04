Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEAD7BAED
	for <kvmarm@lists.linux.dev>; Mon,  4 Mar 2024 22:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709592552; cv=none; b=nGG9BW+enF5dTOWdNrimbkVAB+KYBICJ/T4O3Pi7L8h3kPzbMNPlX17qbb+NhlOZFaUMqtJCR/qf3dNllZAgcREAnStrEIEM/0FbwGNNf5OW/a/BAidzFMjqBJ2JPa8VoQnlcgPFmMooRTQ36hlmRlvyuJYHEt/8pcn3DYpCl2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709592552; c=relaxed/simple;
	bh=qRH4NATDXZHzXulFgvyB391uAoJUEvNPINv4GFzk1Ek=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XbEyqr+1qW/hrNZiUTu37KnaNIOvAcB2B7YpppY1PK9HFvzkKz722uapt6P95CpLYUPh4NF3s2uXxD6i8fVpxVog6c9x3VunpSGqqli5caR/XIZ7luHt6L6QL+2UbQPCqxUX7qSHMtCtx9ltnK7Vr2YlO+RP0gNavPN4b+CXq3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XGhrA9sJ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XGhrA9sJ"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dccc49ef73eso8528947276.2
        for <kvmarm@lists.linux.dev>; Mon, 04 Mar 2024 14:49:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709592549; x=1710197349; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dTd2eKCQI+i5MVtReQTidk9Gtd8iiz9jK0yezNU39FU=;
        b=XGhrA9sJ6p6TrBtNiL8lxNoj/5umVExG0CSw7NhASjUplYK2ekfpJNhKYU5VBd1yh5
         teCx85lMHp+jSb4gg7BLgwYRJN/FFw0gR6irjAairddRkCIhAPyvfB1Z8DnOMa2Hnygv
         GPDRIqk/UNnzExrKDztmYogBvr+vQuFeeaa4qf44eWBuHVbCDIkwWgopTTLXmmmXI/8R
         5Dmcq6jCH8YVxRiRFJTlnlgKb396B7RK7GjCjmp1tNEdvk69C1nSMIDKDsoYMu2ZZWu4
         rvzQo5BdppD3+l8K+3u2tpZcwuVPAOOXF1AqotnVPXUmAOhmBHZQTOpxWcxmkHRoU9pC
         HW9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709592549; x=1710197349;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dTd2eKCQI+i5MVtReQTidk9Gtd8iiz9jK0yezNU39FU=;
        b=j0lHy94UaxZVJIcv6/5hy0fQBIDHdCzqrKtaWNF+R66/P/995M2IIDQKLdrbFT7kem
         oMa7Ht1sTnHvWG1wLNTABgZjxWoDQLxRnckNACbMaoGB7Fx3ZZHLL+4k8vycZSnHRygw
         Z6yzg1T9xXAWfECENsLgY48MN3K2/U20su6cMzFWllqVmw7ymHIQ8rSf6079+Ivr77iY
         tZTE4u9I2TfuqW95+He9scHsIWmwC9xiOkMYTIqGFY/Ggaw8ujQCAmXvj9fKE64ipKU8
         tTHQ8pcsHViWVjQFKaAUAtEta94wvt5gHDbopcQk8ZDNSyS6rhq3VlNPbOQyMGGmKbaq
         ryXw==
X-Forwarded-Encrypted: i=1; AJvYcCV1RrhRBNhuRFxD0x3eOOV21+w1War/6zKXoTXwJahCAeu/b8JVDbaKqujF4+C1nRaHFGT2kCJyb3pBZNyfwn2//a8nkMVa
X-Gm-Message-State: AOJu0YxFDQPfW6asMYcuDMQF8NjGsEwB3Bq2OdWblQAIzHxTTmyYnyQH
	Sfpj8IHasBrUsDErtwQ72IvMJy4T+VHvVf2KQKza/QqEOZUbsVHNf4hDJBsv0JV4JLB/afKoSIe
	/9Q==
X-Google-Smtp-Source: AGHT+IEQkCJ4+XMkrF1Iz1bhFLnJKc1aIh/mFBZ8g5b7STyfhkwNBpDtW5+n4hqYz6V6M8vwwrQxFZ9Y7bU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c1:b0:dcc:9f24:692b with SMTP id
 w1-20020a05690210c100b00dcc9f24692bmr382637ybu.13.1709592549354; Mon, 04 Mar
 2024 14:49:09 -0800 (PST)
Date: Mon, 4 Mar 2024 14:49:07 -0800
In-Reply-To: <ZeY3P8Za5Q6pkkQV@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-9-amoorthy@google.com>
 <ZeYoSSYtDxKma-gg@linux.dev> <ZeYqt86yVmCu5lKP@linux.dev> <ZeYv86atkVpVMa2S@google.com>
 <ZeY3P8Za5Q6pkkQV@linux.dev>
Message-ID: <ZeZP4xOMk7LUnNt2@google.com>
Subject: Re: [PATCH v7 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO and
 annotate fault in the stage-2 fault handler
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Anish Moorthy <amoorthy@google.com>, maz@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, jthoughton@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 04, 2024, Oliver Upton wrote:
> On Mon, Mar 04, 2024 at 12:32:51PM -0800, Sean Christopherson wrote:
> > On Mon, Mar 04, 2024, Oliver Upton wrote:
> > > On Mon, Mar 04, 2024 at 08:00:15PM +0000, Oliver Upton wrote:
> 
> [...]
> 
> > > Duh, kvm_vcpu_trap_is_exec_fault() (not to be confused with
> > > kvm_vcpu_trap_is_iabt()) filters for S1PTW, so this *should*
> > > shake out as a write fault on the stage-1 descriptor.
> > > 
> > > With that said, an architecture-neutral UAPI may not be able to capture
> > > the nuance of a fault. This UAPI will become much more load-bearing in
> > > the future, and the loss of granularity could become an issue.
> > 
> > What is the possible fallout from loss of granularity/nuance?  E.g. if the worst
> > case scenario is that KVM may exit to userspace multiple times in order to resolve
> > the problem, IMO that's an acceptable cost for having "dumb", common uAPI.
> > 
> > The intent/contract of the exit to userspace isn't for userspace to be able to
> > completely understand what fault occurred, but rather for KVM to communicate what
> > action userspace needs to take in order for KVM to make forward progress.
> 
> For one, the stage-2 page tables can describe permissions beyond RWX.
> MTE tag allocation can be controlled at stage-2, which (confusingly)
> desribes if the guest can insert tags in an opaque, physical space not
> described by HPFAR.
> 
> There is a corresponding bit in ESR_EL2 that describes this at the time
> of a fault, and R/W/X flags aren't enough to convey the right corrective
> action.
>
> > > Marc had some ideas about forwarding the register state to userspace
> > > directly, which should be the right level of information for _any_ fault
> > > taken to userspace.
> > 
> > I don't know enough about ARM to weigh in on that side of things, but for x86
> > this definitely doesn't hold true.
> 
> We tend to directly model the CPU architecture wherever possible, as it
> is the only way to create something intelligible. That same rationale
> applies to a huge portion of KVM UAPI; it is architecture-dependent by
> design.

Heh, "by design" :-)

I'm not saying "no arch-specific code in memory_fault", all I'm saying is that
stuff that can be arch-neutral, should be arch-neutral.  And AFAIK, basic RWX
information is common across all architectures.

E.g. if KVM needs to communicate MTE information on top of basic RWX info, why
not add a flag to memory_fault.flags that communicates that MTE is enabled and
relevant info can be found in an "extended" data field?

The presense of MTE stuff shouldn't affect the fundamental access information,
e.g. if the guest was attempting to write, then KVM should set KVM_MEMORY_EXIT_FLAG_WRITE
irrespective of whether or not MTE is in play.

The one thing we may want to squeak in before 6.8 is released is a placeholder
in memory_fault, though I don't think that's strictly necessary since the union
as a whole is padded to 256 bytes.  I suppose userspace could allocate based on
sizeof(kvm_run.memory_fault), but that's a bit of a stretch.

> > E.g. on the x86 side, KVM intentionally sets reserved bits in SPTEs for
> > "caching" emulated MMIO accesses, and the resulting fault captures the
> > "reserved bits set" information in register state.  But that's purely an
> > (optional) imlementation detail of KVM that should never be exposed to
> > userspace.
> 
> MMIO accesses would show up elsewhere though, right?

Yes, but I don't see how that's relevant.  Maybe I'm just misunderstanding what
you're saying/asking.

> If these magic SPTEs were causing -EFAULT exits then something must've gone
> sideways.

More or less.  This scenario can happen if the guest re-accesses a GFN that
doesn't have a memslot, but in the interim userspace made the GFN private.  It's
likely a misbehaving userspace, but that really doesn't matter.  KVM's contract
is to report that KVM exited to userspace because the guest was trying to access
GFN X as shared, but the GFN is configured as private by userspace.

My point was that dumping fault/register information straight to userspace in this
scenario, without massaging/filtering that information, is not a sane option on
x86.
 
> Either way, I have no issues whatsoever if the direction for x86 is to
> provide abstracted fault information.

I don't understand how ARM can get away with NOT providing a layer of abstraction.
Copying fault state verbatim to userspace will bleed KVM implementation details
into userspace, and risks breakage of KVM's ABI due to changes in hardware.
Abstracting gory hardware details from userspace is one of the main roles of the
kernel.

A concrete example of hardware throwing a wrench in things is AMD's upcoming
"encrypted" flag (in the stage-2 page fault error code), which is set by SNP-capable
CPUs for *any* VM that supports guest-controlled encrypted memory.  If KVM reported
the page fault error code directly to userspace, then running the same VM on
different hardware generations, e.g. after live migration, would generate different
error codes.
 
Are we talking past each other?  I'm genuinely confused by the pushback on
capturing RWX information.  Yes, the RWX info may be insufficient in some cases,
but its existence doesn't preclude KVM from providing more information as needed.
