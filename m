Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4F4205AD7
	for <kvmarm@lists.linux.dev>; Wed,  2 Apr 2025 11:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743592800; cv=none; b=FMKcumvt/TvyLLv6c5AHboiLpMUssFmMtOT8qs649+dzIhAckIH+O6oR9NadlrfIf1OpHiphhi9EXgFGmJsL7D4fqyt4M01ijxoaJnm1kknLk7fOCl8rRjkJ4WZJhwgpW9vn99sjU1N/3AngyrpvWlzBt/2LHIeaEv5TPl3KE18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743592800; c=relaxed/simple;
	bh=+XHLLwQIqniAShr/zDi4PIli6Pj9vsKmOjJJeTZdbYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ELF9ynvDpOSOTBBtcUZo9Piu1U6TSp9M9x3lNj9flmnz4u2hSlhSSGKigEAyEr0+R0J7WKPxnoNeCUbSEo5mWz0f79kCoRsqauR/JhoJlT8RiXw2H/LMCsDT7ADguhGVWkvBusCPnVTDX7t91IF7S0jkZOjisKK9L3iqBQHGyyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=knh+kCZ2; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="knh+kCZ2"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-736c3e7b390so6037b3a.2
        for <kvmarm@lists.linux.dev>; Wed, 02 Apr 2025 04:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743592798; x=1744197598; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TGYk4MN5JgZ/GTWR6xaYNWOcgddcbUz8F9N3UmxYMIM=;
        b=knh+kCZ2gK/sJpz25tMB9suQJ4hCvRN/wFJYBSoa8qUloaH8xq3/YIiCe4uAmX/epv
         uYRm26ygnYYnfq3ir7Hz1LfkHgULVKA5wY1hNNvYXn3VtnPQ/xejced2eQbs3Dv7QR95
         RvoSwIXTjrOv/6t3hNhLkRXkEFa5vKvpJu1pLx6dW0QZEwqCC2NBZ3JbE2YhkjTxuSC1
         R0iv2/q6RgPOA3z4pSjsdbhsiDs6B6WHHumxoIOOCe1XxG2eZ+f13gr97PD3kzz5f/wj
         9ZxDmP0QS8HqnGszYMe46X08STNfZzW3dKp8KAjahFYOLnDbVTlf0HHRHm5yjPFDHGhH
         OeyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743592798; x=1744197598;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TGYk4MN5JgZ/GTWR6xaYNWOcgddcbUz8F9N3UmxYMIM=;
        b=A+Xvae9WuMzQYJHYdrcHZqwh/IJuGEZo/oyUKh4DtQJffQtcefyYtPVZ1bIV7sQpJF
         hG3lMI0l8xcMOZrWMAhtBvXE12i28eH6W3pyrj303vt7y/mqpbMKUn98EQTGYGmu5Sxa
         WUq5/8sRj2d3PGFIKJWujVswtSoWQsv2X/q4IAIh9B17vVlE9BJ/Lvt9bP6/Ztg3XK/K
         trpNyrPJ9g+3Nh3UkhhrOhfOpxJWRsTlA3JGhQpekII8c5XEAXy1igOKdf0rkff26PpV
         WmnkEDaEJCLBTHT9fYWjl6+sMzump/sq3bPUi4OFEYPoRI4HX53pU5L/R65mDM7LwZv9
         gB/w==
X-Forwarded-Encrypted: i=1; AJvYcCU8SzkBbAp/BwtuYK98zg1drd4APZg5z7TNi3i9hL1LIiLIGoHwDG+HV9MgcCzo56R1PvTOVBs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWzwy2LppaSin2+xiSAveJKSOvjQloyDgJhSwGYe6ebflYHzuN
	I9/9hLk5vyLcPjPQMADW7/6ZvfAqlgakJjpsF2sR3fXYohK04OKx
X-Gm-Gg: ASbGnct5txk6RqSIC7ZyMeNzv4vUGMicf6zHnj0+kOuAqkE+eBHqeRWk88I/SSGWy10
	AOrzgxVhjsHHP5HdHw5rPaB1M5zLYy6zsNvjo6a08m994fK+2vhJymw04lOmnJkX1OnhwFQ0jhC
	V9/unE+e3vecGFI0P/kLGzuH9aC1ySWBcCVQzlwYg9ZULw4eqehiXHYjnnuc50ce7olgl+4g1co
	acdi4ZobAz/v6bqp6gfJIcCH+tOxrec/lbLRkmFGzR4XOyNSJFukjQWyvLMLUKXlPdbBSSX0oLb
	eJke62MoCTGUSD1uuxQ7m8sbjbXjIJ+0IY8CVg==
X-Google-Smtp-Source: AGHT+IED6RODE5t1fgpLzXAzt+WwoeH8VunMoBhibfk12A/H/jmVed7PJAwEBl7ILJ5RLoZMUek0/Q==
X-Received: by 2002:aa7:8890:0:b0:736:339b:8296 with SMTP id d2e1a72fcca58-7398042ff42mr24632593b3a.18.1743592798394;
        Wed, 02 Apr 2025 04:19:58 -0700 (PDT)
Received: from raj ([103.48.69.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73970e2233asm10673144b3a.43.2025.04.02.04.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 04:19:58 -0700 (PDT)
Date: Wed, 2 Apr 2025 16:49:50 +0530
From: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	jens.wiklander@linaro.org, sumit.garg@kernel.org,
	mark.rutland@arm.com, lpieralisi@kernel.org, sudeep.holla@arm.com,
	pbonzini@redhat.com, kvmarm@lists.linux.dev,
	op-tee@lists.trustedfirmware.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] KVM: optee: Introduce OP-TEE Mediator for
 exposing secure world to KVM guests
Message-ID: <Z-0dVi1_XMmmVZsL@raj>
References: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
 <87ldsjzr5l.wl-maz@kernel.org>
 <Z-yn6BdPcuM_aDBX@raj>
 <87jz83ymww.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jz83ymww.wl-maz@kernel.org>

On Wed, Apr 02, 2025 at 09:42:39AM +0100, Marc Zyngier wrote:
> On Wed, 02 Apr 2025 03:58:48 +0100,
> Yuvraj Sakshith <yuvraj.kernel@gmail.com> wrote:
> > 
> > On Tue, Apr 01, 2025 at 07:13:26PM +0100, Marc Zyngier wrote:
> > > On Tue, 01 Apr 2025 18:05:20 +0100,
> > > Yuvraj Sakshith <yuvraj.kernel@gmail.com> wrote:
> > > >
> 
> [...]
> 
> > > > This implementation has been heavily inspired by Xen's OP-TEE
> > > > mediator.
> > > 
> > > [...]
> > > 
> > > And I think this inspiration is the source of most of the problems in
> > > this series.
> > > 
> > > Routing Secure Calls from the guest to whatever is on the secure side
> > > should not be the kernel's job at all. It should be the VMM's job. All
> > > you need to do is to route the SMCs from the guest to userspace, and
> > > we already have all the required infrastructure for that.
> > >
> > Yes, this was an argument at the time of designing this solution.
> >
> > > It is the VMM that should:
> > > 
> > > - signal the TEE of VM creation/teardown
> > > 
> > > - translate between IPAs and host VAs without involving KVM
> > > 
> > > - let the host TEE driver translate between VAs and PAs and deal with
> > >   the pinning as required, just like it would do for any userspace
> > >   (without ever using the KVM memslot interface)
> > > 
> > > - proxy requests from the guest to the TEE
> > > 
> > > - in general, bear the complexity of anything related to the TEE
> > >
> > 
> > Major reason why I went with placing the implementation inside the kernel is,
> > 	- OP-TEE userspace lib (client) does not support sending SMCs for VM events
> > 	  and needs modification.
> > 	- QEMU (or every other VMM)  will have to be modified.
> 
> Sure. And what? New feature, new API, new code. And what will happen
> once someone wants to use something other than OP-TEE? Or one of the
> many forks of OP-TEE that have a completely different ABI (cue the
> Android forks -- yes, plural)?

If something other than OP-TEE has to be supported, a specific mediator
(such as drivers/tee/optee/optee_mediator.c) has to be constructed
with handlers hooked via tee_mediator_register_ops().

But yes, the ABI might change and the implementor has the freedom to
mediate it as required.

> > 	- OP-TEE driver is anyways in the kernel. A mediator will just be an addition
> > 		and not a completely new entity.
> 
> Of course not. The TEE can be anywhere I want. On another machine if I
> decide so. Just because OP-TEE has a very simplistic model doesn't
> mean we have to be constrained by it.
> 
> > 	- (Potential) issues if we would want to mediate requests from VM which has
> > 	  private mem.
> 
> Private memory means that not even the host has access to it, as it is
> the case with pKVM. How would that be an issue?
>

Guest shares memory to OP-TEE through a buffer filled with pointers, which
the mediator has to read for IPA->PA translations of all these pointers.
VMM wont be able to read these if memory is private.

But, this is a "potential" solution and if at all the mediator is moved to VMM,
this is completely ruled out.
 
> > 	- Heavy VM exits if guest makes frequent TOS calls.
> 
> Sorry, I have to completely dismiss the argument here. I'm not even
> remotely considering performance for something that is essentially a
> full context switch of the whole machine. By definition, calling into
> EL3, and then S-EL1/S-EL2 is going to be as fast as a dying snail, and
> an additional exit to userspace will hardly register for anything
> other than a pointless latency benchmark.
> 
Okay, makes sense.
> > 
> > Hence, the thought of making changes to too many entities (libteec,
> > VMM, etc.) was a strong reason, although arguable.
> 
> It is a *terrible* reason. By this reasoning, we would have subsumed
> the whole VMM into the kernel (just like Xen), because "we don't want
> to change userspace".
> 
> Furthermore, you are not even considering basic things such as
> permissions. Your approach completely circumvents any form of access
> control, meaning that if any user that can create a VM can talk to the
> TEE, even if they don't have access to the TEE driver.

Well, this is a good point. OP-TEE built for NS-Virt supports handles calls
from different VMs under different MMU partitions (will need to go off track
to explain this). But, each VM's state and data remains isolated internally
in S-EL1.

> Yes, you could replicate access permission, SE-Linux, seccomp (and the
> rest of the security theater) at the KVM/TEE boundary, making the
> whole thing even more of a twisted mess.
> 
> Or you could simply do the right thing and let the kernel do its job
> the way it was intended by using the syscall interface from userspace.
> 
> > 
> > > In short, the VMM is just another piece of userspace using the TEE to
> > > do whatever it wants. The TEE driver on the host must obviously know
> > > about VMs, but that's about it.
> > > 
> > > Crucially, KVM should:
> > > 
> > > - be completely TEE agnostic and never call into something that is
> > >   TEE-specific
> > > 
> > > - allow a TEE implementation entirely in userspace, specially for the
> > >   machines that do not have EL3
> > >
> > 
> > Yes, you're right. Although I believe there still are some changes
> > that need to be made to KVM for facilitating this. For example,
> > kvm_smccc_get_action() would deny TOS call.
> 
> If something is missing in KVM to allow routing of SMCs to userspace,
> I'm more than happy to entertain the change.

Okay.

> > So, having an implementation completely in VMM without any change in
> > KVM might be challenging, any potential solutions are welcome.
> 
> I've said what I have to say already, and pointed you in a direction
> that I see as both correct and maintainable.
> 

Yes, I get your point on placing mediator in VMM. And now that I think of it,
I believe I can make an improvement.

But yes, since too many entities are involved, the design of this solution has been
a nightmare. Good to have been pushed this way.

> Thanks,
> 
> 	M.
> 
> -- 
> Jazz isn't dead. It just smells funny.

Thanks,
Yuvraj Sakshith
