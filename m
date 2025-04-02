Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD5F2F5A
	for <kvmarm@lists.linux.dev>; Wed,  2 Apr 2025 02:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743562738; cv=none; b=MJ5GWGjRBOKOx9nbjN7vDiZjwp3hsQ4x2/lO3LciKoARZjDzWyZcIqNrpP/VKJpwUjVMNEc3HOvk94+1pcJlHfjdtFnGow7BBiqB574qRaVZw/VRbUq5ceCBGI1sEomF40/4quC7RgB+XbTBiJa7ccyrW853tYeOSuSKslagcYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743562738; c=relaxed/simple;
	bh=qSsSqNI+e8H1dkfIdplQvE/uFu9vkRLyjCAZfche5WY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nixczXIT79wuBiPdN18vLiBdYe+7DygEzDyYcOA15Ujg+RgTyhodaXpmuN3JrZkFPyU3GNXX387usAopStpbh6T8SZuaYJJ+R3UpmwR4oKiuoHrxgHyK3MUwRGJAH+TEowmGaA7AJYlGjWfGMGeDfIh4Pw6vT9Va9v3LiQNm31c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N51uRR0P; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N51uRR0P"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-30572effb26so110230a91.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Apr 2025 19:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743562736; x=1744167536; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T6wuYXanYjAeKP3cuq4YxBDu/PUjGGMnnNxD1TxjUJY=;
        b=N51uRR0PtrlzjZhlocEW1SanVH8JntcKOg3yhElV+KZHz5LmyjQfWDHdZ/YsWY3BlF
         JT1a29k0NWAURQXIi/v0sWptVGvyWquvSm1hyTCHdOTe0kcCudl4fD36UpJxCgissEag
         1s/ErUvires5G9tzUokBQUtpmK7nhBvzVTPZ/VTyMvwiCrt8HjtzWoxoYTLDxrLS2oJm
         R8aj2EnigDZMHqQnxycayu89wxOT5uTSj7949fDr2D0XVmadznoJIbAENKuU004b97sP
         4F9DNJoehYuVphgBpxV1eLujpx2GXPr27pW6jLyTP7Rf9dfM7EbAwQwn3ubT0Hoe5Q57
         txcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743562736; x=1744167536;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T6wuYXanYjAeKP3cuq4YxBDu/PUjGGMnnNxD1TxjUJY=;
        b=aUWlDpBACgaoEnPnv21cfV75qmwcb2LXxXhzlb0EUhLLg1gldEf+P9FcXGumSHYDcs
         /zpWGHbeJErwP9vuZd+1jbYp0AQvN85LJw2QgoLfHwz/mK5nA61HoWMlDJjwSNjRjUaX
         bkVV/oyuMlhrUZaxyxGaqu3lz1zIcoSFieGWwc4wocSAxELamRgPXgJn+YgPd03QNFJF
         lwLxc07XwdSiCkKti/jmHrf31Eo2fhHUQ+P+LJy6rvHeujf65XzSXVpIkz8PISJO3dRZ
         si9zA3o8IvMRcBHTPgQoab35VNfjgQM+0lv19Oxu+bf5lMVLjrufeNTvWLH2dX6oW612
         0sQg==
X-Forwarded-Encrypted: i=1; AJvYcCWoAQ4lPh+b6ZZWiW11Swbnfn3vcya6mX9g4+kDIIx/x6xCxK+/E80pjd/WI1EXEe0bg1pfI3c=@lists.linux.dev
X-Gm-Message-State: AOJu0YwngmevXpDzyRbcbNYAXaqm3u7QctX6Jvzp07SvLMhfC79nUPIR
	4KpAsdAexPSOJDE7qbQvez2xINwdO2Eo1bwqCMJJBZ5tmEdWdl9Q
X-Gm-Gg: ASbGncu0TWJwF0LRsMhWsJ6IpuXavH8pQ4c9pkSZHQvy0KDAtPDJLXkC3pM1Ype5o17
	xeMjNUDWeik/W3oyca0J3yyH54SXjYCqs8rL2DJKCHpMyvhCmS8GLoyO/mctCLsNOBUnD7JdIhI
	cCPZxxM1oK0tjiXbNFA8q4NK6CW63NK7+Ekh9Rz6s919hWVH/CAVPtfvn3Fv74iTwF5On4GAzqO
	uw6oKSaTb4bLuCND75k/VogF2vbB9O9XUUkPFgK4ZTdVFJdKstxm25T2UwdxLSblLN3c6kIBmcM
	WGpJ3uRX7gvJhiOLGNH5fTeBLIvOM+Nms5pHtA==
X-Google-Smtp-Source: AGHT+IHFX1t+j4wZChxTIXjaH746s9fkrxGA5C6ltsvH8PRtH6x9yyt1Z6gB/nQ5xRbdSD25SBLMpA==
X-Received: by 2002:a05:6a21:4d8f:b0:1f5:882e:60f with SMTP id adf61e73a8af0-200d13a4633mr8293953637.17.1743562736139;
        Tue, 01 Apr 2025 19:58:56 -0700 (PDT)
Received: from raj ([103.48.69.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739710ad970sm10081768b3a.148.2025.04.01.19.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 19:58:55 -0700 (PDT)
Date: Wed, 2 Apr 2025 08:28:48 +0530
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
Message-ID: <Z-yn6BdPcuM_aDBX@raj>
References: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
 <87ldsjzr5l.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ldsjzr5l.wl-maz@kernel.org>

On Tue, Apr 01, 2025 at 07:13:26PM +0100, Marc Zyngier wrote:
> On Tue, 01 Apr 2025 18:05:20 +0100,
> Yuvraj Sakshith <yuvraj.kernel@gmail.com> wrote:
> > 
> > A KVM guest running on an arm64 machine will not be able to interact with a trusted execution environment
> > (which supports non-secure guests) like OP-TEE in the secure world. This is because, instructions provided
> > by the architecture (such as, SMC)  which switch control to the firmware, are trapped in EL2 when the guest
> > is executes them.
> > 
> > This series adds a feature into the kernel called the TEE mediator abstraction layer, which lets
> > a guest interact with the secure world. Additionally, a OP-TEE specific mediator is also implemented, which
> > hooks itself to the TEE mediator layer and intercepts guest SMCs targetted at OP-TEE.
> > 
> > Overview
> > =========
> > 
> > Essentially, if the kernel wants to interact with OP-TEE, it makes an "smc - secure monitor call instruction",
> > after loading in arguments into CPU registers. What these arguments consists of and how both these entities 
> > communicate can vary. If a guest wants to establish a connection with the secure world, its not possible. 
> > This is because of the fact that "smc" by the guest are trapped by the hypervisor in EL2. This is done by setting
> > the HCR_EL2.TSC bit before entering the guest.
> > 
> > Hence, this feature which I we may call TEE mediator, acts as an intermediary between the guest and OP-TEE.
> > Instead of denying the guest SMC and jumping back into the guest, the mediator forwards the request to
> > OP-TEE.
> > 
> > OP-TEE supports virtualization in the normal world and expects 6 things from the NS-hypervisor:
> > 
> > 1. Notify OP-TEE when a VM is created.
> > 2. Notify OP-TEE when a VM is destroyed.
> > 3. Any SMC to OP-TEE has to contain the VMID in x7. If its the hypervisor sending, then VMID is 0.
> > 4. Hypervisor has to perform IPA->PA translations of the memory addresses sent by guest.
> > 5. Memory shared by the VM to OP-TEE has to remain pinned.
> > 6. The hypervisor has to follow the OP-TEE protocol, so the guest thinks it is directly speaking to OP-TEE.
> > 
> > Its important to note that, if OP-TEE is built with NS-virtualization support, it can only function if there is 
> > a hypervisor with a mediator in normal world.
> > 
> > This implementation has been heavily inspired by Xen's OP-TEE
> > mediator.
> 
> [...]
> 
> And I think this inspiration is the source of most of the problems in
> this series.
> 
> Routing Secure Calls from the guest to whatever is on the secure side
> should not be the kernel's job at all. It should be the VMM's job. All
> you need to do is to route the SMCs from the guest to userspace, and
> we already have all the required infrastructure for that.
>
Yes, this was an argument at the time of designing this solution.

> It is the VMM that should:
> 
> - signal the TEE of VM creation/teardown
> 
> - translate between IPAs and host VAs without involving KVM
> 
> - let the host TEE driver translate between VAs and PAs and deal with
>   the pinning as required, just like it would do for any userspace
>   (without ever using the KVM memslot interface)
> 
> - proxy requests from the guest to the TEE
> 
> - in general, bear the complexity of anything related to the TEE
>

Major reason why I went with placing the implementation inside the kernel is,
	- OP-TEE userspace lib (client) does not support sending SMCs for VM events
	  and needs modification.
	- QEMU (or every other VMM)  will have to be modified.
	- OP-TEE driver is anyways in the kernel. A mediator will just be an addition
		and not a completely new entity.
	- (Potential) issues if we would want to mediate requests from VM which has
	  private mem.
	- Heavy VM exits if guest makes frequent TOS calls.

Hence, the thought of making changes to too many entities (libteec, VMM, etc.) was a
strong reason, although arguable.

> In short, the VMM is just another piece of userspace using the TEE to
> do whatever it wants. The TEE driver on the host must obviously know
> about VMs, but that's about it.
> 
> Crucially, KVM should:
> 
> - be completely TEE agnostic and never call into something that is
>   TEE-specific
> 
> - allow a TEE implementation entirely in userspace, specially for the
>   machines that do not have EL3
>

Yes, you're right. Although I believe there still are some changes that need to be made
to KVM for facilitating this. For example, kvm_smccc_get_action() would deny TOS call.

So, having an implementation completely in VMM without any change in KVM might be challenging,
any potential solutions are welcome.
 
> As it stands, your design looks completely upside-down. Most of this
> code should be userspace code and live in (or close to) the VMM, with
> the host kernel only providing the basic primitives, most of which
> should already be there.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Jazz isn't dead. It just smells funny.
