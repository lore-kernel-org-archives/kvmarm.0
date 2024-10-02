Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6A210F7
	for <kvmarm@lists.linux.dev>; Wed,  2 Oct 2024 00:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727828625; cv=none; b=pLAgKncsGgftFCYfYq+PE9WYWEGTHoWRZfoL58GPMVKJVK3/nZgbp57uCVdBZIjQrG8ImWw9zCvfU0W+hkHDtNXxVdQKlatMbC9QjXkuZAxYlfTpfF2Ev02O+Qx/fFavQUxIasSN+cp1/8iTcMxiX+ZuoSDullfnGEQbcq3+d1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727828625; c=relaxed/simple;
	bh=5ALK4ZFSghxZpBhMnmS/kedlQC8XZ71Fu+PlACX/I48=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u+1rnXqrMnoo1Ro/voFb+GkmRwRO+ZuY9Z50Pd4IzK4mno4vYY0f1LDusW0kP6wb96/Px8R8PIvsTNkIaKxdTvSuF+aR5MVRIIb/wp+D0kOe7WFWRdp+w8zn65mXPvnty2tX4ALMUuyeIoQD1LXHvZMc7Dt31pcDL/gTfL+9wPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Aviw/TR6; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Aviw/TR6"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7cd849a6077so4947030a12.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Oct 2024 17:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727828624; x=1728433424; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=soG8wcODb3zWRYBsWkEypGWSPy9VoHMD1i4+H4JIGvs=;
        b=Aviw/TR6tHiph/71M8AV3Iieyna3Z4Lu7Hz2ZU5d7toLE9XY1t06Pxe+qxTzlUnQmR
         92wLTe7byin5awsdkflaT5uh7RuaKzNrnuKVbyKoXtstHOEASAtzY4f55spRuGw8n56o
         IcFPNQ5URDhJbsCtmT94ONnPBTyWt4hVWblTFnKgCn/ONLXwzH6F1/IRyE4lYhCKhrnt
         Zg6wNavK5B9sa9k/22XttVtXVntimRIOsDt2vb5T981+KVw05Yj38CXkCYwxY+62zkvD
         PDu4lTldIz2fZioAurcUaB74QVAiityMbq4AQMFNtEEyiLrCnOxFDifYEAu4oHmUitCn
         0TNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727828624; x=1728433424;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=soG8wcODb3zWRYBsWkEypGWSPy9VoHMD1i4+H4JIGvs=;
        b=jWdHhV8rq2uRYo59CKPW/tTAx+UR8T32VF5bJq2vTI8T21E/c9zj+QLbufISiMM5AY
         avGKR4hJ8uG/LaPntuMn7FwCQvaX4KhMscaL7xD+ZTbMPoKnf0JhAFxTcLpTHlJnm6uL
         qz6uGp2FRB4f1FGImFasMb2avFkgXUjz7HxifFsY1SFTeHKnMScqN/KOdx0juJoEFPqC
         9E7esizsmd5jNBFQfxdxMDGZCHyBEYEN99Lqrz9jXU9Xipad5rTLQEHS+PHJmS56rBxu
         O3vUMlWwqV8wu/diql2hxa/LNc6UuOOilLr+nDkbd272M+IUuKxvQZlofsvx4UnBHA6c
         Egow==
X-Forwarded-Encrypted: i=1; AJvYcCUjvr5AUD7sUCwD2CLy4z4LeWaSUZF+kcBUQHoDHVnW2h8uXI7m/BHSzJKpMPG5+b9aaVS5Bo8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxdQDDf33w+RoFHtw9M0FDRN/lOqjwcJYtxPcQCHUChOVmVpcs9
	1HESuVuGqSgSHIN66TQbP0o3VCuI18amVgMFgjOZtKs6mTsayxrbg/mzQ3+Hb8n5S7Gf0iU1qSY
	Dvw==
X-Google-Smtp-Source: AGHT+IE5qvWGfc49zsFfLjngsHIzoTXPM8CBFW+wURw8DnMlJynGQ2ksB/Qm0d3Y+jI8ckzSNnsja02kI3o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4f62:0:b0:7db:539:893c with SMTP id
 41be03b00d2f7-7e9aff9f7a1mr1357a12.9.1727828623460; Tue, 01 Oct 2024 17:23:43
 -0700 (PDT)
Date: Tue, 1 Oct 2024 17:23:41 -0700
In-Reply-To: <ZvyOcnZqNzfD7MZx@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241001001709.1303668-1-oliver.upton@linux.dev>
 <20241001001709.1303668-4-oliver.upton@linux.dev> <ZvxH3el9SNuNWwi8@google.com>
 <ZvxeeVn8LphHxWeS@linux.dev> <ZvyFkqsRFBAYwqP7@google.com>
 <86cykj75a0.wl-maz@kernel.org> <ZvyOcnZqNzfD7MZx@linux.dev>
Message-ID: <ZvySjfDWOhl2O1IA@google.com>
Subject: Re: [PATCH 3/3] KVM: arm64: nv: Punt stage-2 recycling to a vCPU request
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 01, 2024, Oliver Upton wrote:
> On Wed, Oct 02, 2024 at 12:49:27AM +0100, Marc Zyngier wrote:
> > On Wed, 02 Oct 2024 00:28:18 +0100,
> > Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > On Tue, Oct 01, 2024, Oliver Upton wrote:
> > > > Hey,
> > > > 
> > > > sidebar: I was a bit confused by the diff for a second, since it looks
> > > > like your email client lowercased some stuff :)
> > > 
> > > Wasn't my mail client, it was PEBKAC.  I copy+pasted a large chunk in Vim because
> > > I wanted to pull in the changelog (which I had deleted from my response), but then
> > > I changed my mind, and in doing so I managed to fat-finger something that converted
> > > everything to lowercase.  And yeah, it confused me too.
> > > 
> > > > > >  out:
> > > > > > +	if (s2_mmu->pending_unmap)
> > > > > > +		kvm_make_request(kvm_req_nested_s2_unmap, vcpu);
> > > > > 
> > > > > If I followed everything correctly, I don't think a request is needed.  the
> > > > > request will never be cross-vCPU, and each vCPU holds a reference to the MMU, so
> > > > > the MMU can't be recycled, i.e. pending_unmap is guaranteed to be relevant to the
> > > > > vCPU's usage of the MMU.  More thoughts below in check_nested_vcpu_requests().
> > > > 
> > > > I'm (ab)using the request to prevent the vCPU thread from actually
> > > > entering the VM without first having done the laundry. We have other
> > > > examples of strictly per-vCPU tasks that are tracked with a request so
> > > > this doesn't stick out that much.
> > > > 
> > > > Otherwise we'd need an open-coded check in kvm_vcpu_exit_request() to
> > > > catch a 'dirty' MMU or take a pin on it from the point we check the
> > > > dirtiness to the point we disable preemption.
> > > 
> > > Ewww, because kvm_arch_vcpu_put() puts the nested stage-2 when the vCPU is
> > > scheduled out.  Mostly out of curiosity, why?  99.9% of the time, the vCPU will
> > > be scheduled back in.
> > 
> > Because s2 MMU structures are a scarce resource. and other vcpus could
> > have the opportunity to make use of an unused slot.

But that slot is less unused than other unused slots, in the sense that KVM _knows_
at least one vCPU intends to use that MMU in the near future, whereas KVM has no
tracking to know if an MMU with no references whatsoever is likely to be reused.

IIUC, KVM round-robins across 2*nr_vcpus MMUs, and when L1 switches to a different
VTTBR, it will first drop its reference to the previous MMU.  So at any given time,
there are nr_vcpus worth of unused MMUs, i.e. a vCPU is guaranteed to be able to
find an unused slot, even if vCPUs that are scheduled out hold onto their S2 MMU
reference.

At that point, choosing an MMU that no vCPU is using seems more likely to recycle
a cold/dead MMU than a soon-to-be-reused MMU.

And the round-robin approach makes it all heavily luck-based anyways.  E.g. if
a vCPU puts VTTBR A and then loads VTTBR B, B could recycle A's S2 MMU if that
MMU slot is next up for recycling.

> > > Now that vcpu->scheduled_out is a thing, retaining the nested s2 MMU should be
> > > quite straightforward.  kvm_arch_vcpu_destroy() would need to put the MMU, but
> > > that should also be straightforward.
> > 
> > This code long predates scheduled_out, and I don't think this brings
> > much to the table. If the vcpu comes back quickly, it will find its
> > toys where it left them. If not, someone else will have borrowed them,
> > and it will have to pick new ones. It isn't any different from TLBs,
> > which s2 MMUs model.
> 
> In line with what Sean is recommending, it might make sense to explore
> holding the reference while a vCPU is loaded and runnable, i.e. the vCPU
> isn't scheduling out due to an emulated WFI. While not perfect, it would
> increase the likelihood that we evict a 'cold' MMU.
> 
> But again, we should make sure we're actually happy with this allocation
> scheme first before bothering with optimizing it a lot.

Heh, yeah.  I wasn't coming at this from a performance angle, so much as an "avoid
footguns and weird edgecases" angle.  Allowing the nested S2 MMU to be blown away
at essentially any time is likely to be quite surprising to most folks.
