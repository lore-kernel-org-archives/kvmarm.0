Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3E33093DD
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 16:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783959227; cv=none; b=a5GthqFgbxeSingztuXxFGQde17CIbLM0nc9ifzap2jX/gd9Z7yFjlY8fN9ln9TCUelp6bHuGutdG3gGxuuaOK/0hMZRQduzvKmfsnKKSaqoantDfoFp68YLEuV32eUehwgaNJuI/SHK1xmIgyPXeTBIecuNFPTTFl0wnhQJlrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783959227; c=relaxed/simple;
	bh=mfeGsIUssFD4BDa8yLNU+8MdWvaJJIrNglRzMtuFLbQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QHOThmy5kJ7uSr+c4BiHx9o1LejJKSo0MzPsw8DDfXcVmJ8W66lHuA2dwoHKzx0DQT+kOViL036zwnUl1DgXP3m5++X/z36EF5XqiEu4FvF8uWHUCSv9bZDSUJeo/QqVZnsBboswVtaR6O5vYetR6kYdn/+L/X8pcjCf7wNGSOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ca9QM4EN; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ca9QM4EN"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-84a3514f912so2302498b3a.3
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 09:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783959222; x=1784564022; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FaREvBP1gg2ufa+OsQJIcco6qjp0ITtDsYsM/CE0YBo=;
        b=Ca9QM4ENoFMK2/6bKrxBdbHb2PvgJQ/OgGXkTAQAnRzpi2Ks1fhQsT+F5ME6UTY81h
         2x/LJYMhV3fEQVF0XuGGx05Vjfo6So97TCGoyghBtfn7aEVJJfj6b5rWwqmWYPU6ptfJ
         URBVk7SVDMOGP787Kqaut+EJEGyFv1Wq633CnojFqMI67wEPRppYcBCVJnJkrooCi9Wq
         iHMkjStDJsHLEcSN9UOiMMTCuo2TOCwy8RfGUSLtglAmbYddObzGe5ELE/1MIoiyDwP2
         Ug2l2g6ulMdsAX0RKLNz4uqlQQNlt9fCHmmxLmJY2O2ZOfJy3Tcjd6eOKMnK8GYKEm3B
         hY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783959222; x=1784564022;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FaREvBP1gg2ufa+OsQJIcco6qjp0ITtDsYsM/CE0YBo=;
        b=aXI7VBhZjQMxhEK6d24w9LCk/aauccHqUlsnwXcrD2KycCL0jSSy86dnNVLaHzO3cq
         Nt7OoP5X2mvV7bX/2aiN39pcdMUhUWmI5tsYC3qEX7cFjZL3kq+IoBgXZdsQrMVxUhP3
         tzqdJcCJE44ZBceKu/Ol2bEXDKQuZCbbkakMHU6eq9YOjxbPc2TNPsu8a1IIsfeCDdpE
         3lOvMos59dRUrN4724AG3RyqA0M9u3Go6Kxs8wQSGRZ/hAvdxJKra/TMglMw+mTVvSxl
         zmMgsmz+MtgddbTSqoM57SwZEnr7CyaBBf5YDk8jg+hkXmZrS7zcertj6xTiP29RHPXm
         W39w==
X-Forwarded-Encrypted: i=1; AHgh+RonUwCohTLyAbsyMrSTjvCv2Khqj6vZZMFxqXnbk3e9B0MkdXcQjHJQO8dPBZ+ds9Y1o0XYHAI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7+UgnysLkY990cktKTdMpO6I00lN8nPCBrsNLccBMnAcPB8zY
	1hphalFC4yigzz36Mz1B4cuK6oRjQQcdS8G2p+kvckpPIJ+9XymmhYBJsUzeyLp2y8+uh5d2Msf
	pm2a2Mw==
X-Received: from pfbkq19.prod.google.com ([2002:a05:6a00:4b13:b0:849:145f:7ff1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3021:b0:842:4b88:20ee
 with SMTP id d2e1a72fcca58-84889721d40mr9009472b3a.44.1783959221968; Mon, 13
 Jul 2026 09:13:41 -0700 (PDT)
Date: Mon, 13 Jul 2026 09:13:41 -0700
In-Reply-To: <8c0c099d-47aa-4bf0-ab7a-c682b0dccdf5@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <20260702142912.6395-2-alexandru.elisei@arm.com> <akwhexqW66RK5Gru@google.com>
 <ak0x0QIWWw6lFUiy@raptor> <8c0c099d-47aa-4bf0-ab7a-c682b0dccdf5@arm.com>
Message-ID: <alUOtUEe3EW1NlqI@google.com>
Subject: Re: [RFC PATCH 1/3] KVM: guest_memfd: Use memslot id to keep track of
 associated memslots
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david.hildenbrand@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	fuad.tabba@linux.dev, mark.rutland@arm.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 13, 2026, David Hildenbrand wrote:
> On 7/7/26 19:05, Alexandru Elisei wrote:
> > Hi Sean,
> > 
> > On Mon, Jul 06, 2026 at 02:43:23PM -0700, Sean Christopherson wrote:
> >> On Thu, Jul 02, 2026, Alexandru Elisei wrote:
> >>> To enable memslot operations, KVM maintains two arrays of memslots, and an
> >>> RCU pointer to the active (in use) array. Changes are made first to the
> >>> inactive array, and the RCU pointer is updated to point to the inactive
> >>> array, which becomes active.
> >>>
> >>> The guest_memfd file maintains an xarray of pointers to memslots that use
> >>> it as the memory provider. After the RCU pointer to the active memslots is
> >>> updated and until SRCU is synchronized, readers can observe the old or the
> >>> new value for the active array, and therefore the old or the new pointer
> >>> for a given memslot.  For memslot creation or deletion that is not an issue
> >>> for guest_memfd, as readers will either read the same memslot pointer saved
> >>> by the guest_memfd file, or a non-existing memslot.
> >>>
> >>> But when changing the flags for a memslot, readers can read two different
> >>> and non-NULL memslot pointers. 
> >>
> >> And?  Why does that matter?  KVM memslot updates aren't atomic.  Practically
> >> speaking, they _can't_ be made atomic. Userspace is required to quiesce all
> >> activity that must not observe inconsistent state, i.e. userspace must pause
> >> (stop running) vCPUs when performing a memslot update.
> > 
> > Is that true when KVM_MEM_LOG_DIRTY_PAGES is toggled for a memslot?
> 
> Good point.

Oh, right, that's "fine" because there's never an intermediate state where there's
an INVALID_SLOT.

> > As far as I can tell, KVM today tolerates VCPUs running while the
> > KVM_MEM_LOG_DIRTY_PAGES flags is being changed for a memslot. And by
> > tolarate I mean that VCPUs that are running when the flag is changed don't
> > return an error from KVM_RUN. If changing a memslot while VCPUs are running
> > were fatal, I would think that KVM would want to take vcpu->mutex for all
> > VCPUs to keep them from running. Or is it a case of KVM allowing userspace
> > to shoot themselves in the foot if they really want it?
> > 
> > When the KVM_MEM_LOG_DIRTY_PAGES flags is being changed, VCPUs handling a
> > guest fault can observe either the old memslot, with the old flags, or the
> > new memslot, with the flag changed, but they still continue running without
> > returning an error.
> 
> Staring at QEMU, kvm_log_start()+kvm_log_stop() do not call
> accel_ioctl_inhibit_begin() etc.
> 
> So at least QEMU does not force VCPUs out of KVM when only updating flags.

Yeah, as above, that should work, and KVM needs to maintain that support.

> One option would be to require user space to do that also when starting+stopping
> dirty page logging. (I'd assume that should work, but it might be tricky
> depending on in which context it is called from QEMU migration code -- whether
> we hold the BQL)
