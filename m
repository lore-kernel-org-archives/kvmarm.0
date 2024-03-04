Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666CA8BE0
	for <kvmarm@lists.linux.dev>; Mon,  4 Mar 2024 20:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709584375; cv=none; b=Blq30aMHt9ZeYaxNmLaTgD+GF4EIZwZfWqrwKkKhDBoGYwoZwyoCqIVKipAovN5rH836sxL2qnqJCmlUMI1D6yn9VvHxEGUrIZuTaN7JGwPLy2j4WaFFkVoDe//U4BVpVhahkOPgfl6xAAxSNE32yk3KlOG3PC3ZVyKsL5N/fmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709584375; c=relaxed/simple;
	bh=aN7iBP0Fr7hMMlKq3I0xxEeo5y2nD9yxqABrzVhf8DU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KjlBYW49NDw+vzCVxMqLMGO60USE/QlCgQnzmRTHN8HvI+e0Rsj6L2N4HzG5SKqHc+/awbBTbrCaa68dNwyV2veWmYsWc8O+YDjnUhGgE6898RJbVtfk/WsZpkzhf9+yUTM+tCF8mEZsFQg+mmm5MtzhkjT8oHUlHxHfECQW5fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=atU4pDfD; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="atU4pDfD"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc693399655so9036808276.1
        for <kvmarm@lists.linux.dev>; Mon, 04 Mar 2024 12:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709584373; x=1710189173; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IGjbhidK9mIBRigo6mJIfMD0RxuUrgdaznMkQx4mOsU=;
        b=atU4pDfDszKGmyRKuvys2Rwn6wEjoug5FO1CMFTygzoZzZL0WhpCECzvIkIGVAaR4c
         MHfvnsend4hE3lLNVIDonlZoVjFDiRFSnlQ9/Pim6456LgBRuK3XlORq9NwTpy/fpkre
         AxDpdS51oTSOUk3nAfvvh+uwLzkywJs7AkRp7jUeMPbU9LXDSRn1e4DKJsmtoV55n07e
         9zekYiwFnKr47Vq4R2ItKem4+jzD49pETyaXn/3UBo8m4kD/FVIldoU+G7tDlkTj5vli
         rNHdFluyAZcclzmCtY/bEv27YM2T4I+UmF5N7WQfc2g8qHThh7ZApOxpp34D5pxUNkxI
         cg1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709584373; x=1710189173;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IGjbhidK9mIBRigo6mJIfMD0RxuUrgdaznMkQx4mOsU=;
        b=i6mKaRa0HuZz08oxr7Yqcq8xxLWTcnkm68FCDa6QPEC7PdcaOdRBbHD4OWbfTbPd+d
         hzoYYlaEtY6sw9mERPDmBADXaVOrQhvckwkqNaG2dDcuU0jIbRtW+a65E8aUf4W4fn8B
         p9czEod+pqujKJyjotnlFtXQH14bfokdwvGgh1/ON4zWlqCFUa3CjbxLNTr+QdvOY3bw
         9Zu8E5diFgukSIrv8raX5SIQU+w4CR831vMnpBKKTA5w1GvluxVnj0Pk/W5ljskkHBA5
         F0Qc/JAWf+w7VwChaw7VL1oyTD7L7Ovms9Hi1PkVuyrea4Q2wQNndiVOl5dyD7vixFzS
         ncuw==
X-Forwarded-Encrypted: i=1; AJvYcCUe3uevOXDK0Qzz0uk5qQ4L6oeYHxmm/VlxOjKC1k6NbzeP/9YyVhl0Ev3fsVi2FgwyXTVLtO66yne3ai/Nq8Wc16XX7/n1
X-Gm-Message-State: AOJu0Yz8OiwIc59wCatVpCHC87UklccWJcco/JBJm3rHAUXwFKQrTbOw
	LWOqDz/i7N2HWGxU6dwpMEnzHzONtmW1GaDLAkMWwSoEEzNaHzmt81jUn0D3qz0megFy5xplg5X
	M3g==
X-Google-Smtp-Source: AGHT+IEmRdAyXCmSUg6f9/OpeGnPuqGycjin7usqBi6tnzcnwZA/qldiy/+AtwEb+/ocbiyWAY5WKQraOik=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1004:b0:dc7:48ce:d17f with SMTP id
 w4-20020a056902100400b00dc748ced17fmr2609142ybt.10.1709584373516; Mon, 04 Mar
 2024 12:32:53 -0800 (PST)
Date: Mon, 4 Mar 2024 12:32:51 -0800
In-Reply-To: <ZeYqt86yVmCu5lKP@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-9-amoorthy@google.com>
 <ZeYoSSYtDxKma-gg@linux.dev> <ZeYqt86yVmCu5lKP@linux.dev>
Message-ID: <ZeYv86atkVpVMa2S@google.com>
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
> On Mon, Mar 04, 2024 at 08:00:15PM +0000, Oliver Upton wrote:
> > On Thu, Feb 15, 2024 at 11:53:59PM +0000, Anish Moorthy wrote:
> > 
> > [...]
> > 
> > > +	if (is_error_noslot_pfn(pfn)) {
> > > +		kvm_prepare_memory_fault_exit(vcpu, gfn * PAGE_SIZE, PAGE_SIZE,
> > > +					      write_fault, exec_fault, false);
> > 
> > Hmm... Reinterpreting the fault context into something that wants to be
> > arch-neutral might make this a bit difficult for userspace to
> > understand.
> > 
> > The CPU can take an instruction abort on an S1PTW due to missing write
> > permissions, i.e. hardware cannot write to the stage-1 descriptor for an
> > AF or DBM update. In this case HPFAR points to the IPA of the stage-1
> > descriptor that took the fault, not the target page.
> > 
> > It would seem this gets expressed to userspace as an intent to write and
> > execute on the stage-1 page tables, no?
> 
> Duh, kvm_vcpu_trap_is_exec_fault() (not to be confused with
> kvm_vcpu_trap_is_iabt()) filters for S1PTW, so this *should*
> shake out as a write fault on the stage-1 descriptor.
> 
> With that said, an architecture-neutral UAPI may not be able to capture
> the nuance of a fault. This UAPI will become much more load-bearing in
> the future, and the loss of granularity could become an issue.

What is the possible fallout from loss of granularity/nuance?  E.g. if the worst
case scenario is that KVM may exit to userspace multiple times in order to resolve
the problem, IMO that's an acceptable cost for having "dumb", common uAPI.

The intent/contract of the exit to userspace isn't for userspace to be able to
completely understand what fault occurred, but rather for KVM to communicate what
action userspace needs to take in order for KVM to make forward progress.

> Marc had some ideas about forwarding the register state to userspace
> directly, which should be the right level of information for _any_ fault
> taken to userspace.

I don't know enough about ARM to weigh in on that side of things, but for x86
this definitely doesn't hold true.  E.g. on the x86 side, KVM intentionally sets
reserved bits in SPTEs for "caching" emulated MMIO accesses, and the resulting
fault captures the "reserved bits set" information in register state.  But that's
purely an (optional) imlementation detail of KVM that should never be exposed to
userspace.

Ditto for things like access tracking on hardware without A/D bits, and shadow
paging, which again can generate fault state that is inscrutable/misleading
without context that only KVM knows (and shouldn't expose to userspace).
