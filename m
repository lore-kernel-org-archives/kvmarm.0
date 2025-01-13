Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331DB1B2199
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 18:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736794728; cv=none; b=S93jqFjHOkGt2YXp89gnb9HfGC27oDDg2CAPJvESPFUOkgsATJvYgbpEVvTuM/c832/FHoYuxzxCm34+fRAItq1fXOuNuCQPi4J88VEqKdk+8nRP5gvfuXjmy/3EHr9kuus/LmoNPavkG09NVHPWCYcbbFvdFuDKov+w80ogeWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736794728; c=relaxed/simple;
	bh=cvqdpY0wusf4SIdHjsPQoehAXIPoKihsb/Z9WgM5Ouk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TaQquOVtFR/67D2oLIkW++mW/00lW1IEka39HZ4SdVdugOa88p6tMjYKDuYm+Cfi+ChFfpYLrRXfSEpPSwZTmRr5zDoRr/k+Kb7QNBlncs5wTJ8aRpd/5m/Ddu6PVEVpnk3osA6HAFxVKA9dvJYMdpSYmia26XHa6rxhhjZpMAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WWhtUV3/; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WWhtUV3/"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef114d8346so7872539a91.0
        for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 10:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736794726; x=1737399526; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uwan4230Eb0GWwMOhozfXQlgkrr0Jk3ApSxALReE/p0=;
        b=WWhtUV3/gxAOtDApmrSpKYlP/awdA+0JUcHdya7WiF9iF+MENSAwherB6AWFVIJDMa
         HrCvGDft/aYJd0ci7i6GVBEZDGcBbvcZWlyMGx1IurqcDkyvTTNDgQQfDFYm9Kwp7DBD
         8JTn9KzHvxBWP5s8vTtyVwFd+2H0F2Ip61/6sbtI3TES/aMFSDMHNMgh7wi0Pind4i22
         e1B71bNcqC+ivWlEIvSwfcCzKec+pTghSi4vCTDcRrHv6Q2a1aarloeFDyouBaxUOPPL
         SWr+5LybmsM//JbFY20CzIAv/k8e0bn2Py9v0F76TEz/b1FT235/uANZfIcMrig1I4Dg
         UCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736794726; x=1737399526;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uwan4230Eb0GWwMOhozfXQlgkrr0Jk3ApSxALReE/p0=;
        b=VeAsKiaL7VuS1+b7xqojwvCX4RTTQr3bQna/Qwhi6b81VBeEg6MYC5AmWetnWd0UAI
         vtI6Z/YUrfTkV0pMzWy0nga322PSMQDCp9s4xaIlx8lp/XuyggXggmaRZM3tuBIysUBF
         4blVDz1ut/UhRNFKsN/ycsAjC+fhNZanyw9cmW2pHkMaOd7Fye2tSRvWtC4lpUQoZF9c
         yPbQZkHZ3aQxvpUGLwqlLl/iitII6b/HZ0SakbJFrK0Z+M+vUmBi2EWUF6grUdXT+kiY
         Z2GjMjJlJYQ9AsJhwwLP0EvhvKC9klcg4IpXrnu3BNneZdDlaCoOySRia/H/J1FizcSe
         9DSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRNmdlVMcAx5lZGU8mDSmnnWF0bwVJpcJBhIGZ8XgC0eXWFlJDzE5czQqax/7O3e6yeOgAXFs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyphrTlHWND2b2vSVXghLEsWqNOhXFMuPomJ1W/CuoSC7BjZAk8
	7b2w5Rjk7UKpti0FIW0gGT8qvPItU08q64KYoySvsUbATGqmvRlcHtc2p5sPFjqWnXU01xQ+ypn
	Ybw==
X-Google-Smtp-Source: AGHT+IH9c5/wT/tYnT2Ksuswivrz3/1NK3niqf+jjzVEmdiTAN7aTx3Xg3pUiP1uOtfflIlyc1vt7cYUYYg=
X-Received: from pfbfd28.prod.google.com ([2002:a05:6a00:2e9c:b0:727:3b66:ace])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2181:b0:725:ae5f:7f06
 with SMTP id d2e1a72fcca58-72d2201b86emr33470701b3a.23.1736794726627; Mon, 13
 Jan 2025 10:58:46 -0800 (PST)
Date: Mon, 13 Jan 2025 10:58:45 -0800
In-Reply-To: <86ikqiwq7y.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250111012450.1262638-1-seanjc@google.com> <20250111012450.1262638-4-seanjc@google.com>
 <87ikqlr4vo.wl-maz@kernel.org> <Z4U03KRYy2DVEgJR@google.com> <86ikqiwq7y.wl-maz@kernel.org>
Message-ID: <Z4ViZb7rruRiN-Oe@google.com>
Subject: Re: [PATCH 3/5] KVM: Add a common kvm_run flag to communicate an exit
 needs completion
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Michael Ellerman <mpe@ellerman.id.au>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 13, 2025, Marc Zyngier wrote:
> On Mon, 13 Jan 2025 15:44:28 +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Sat, Jan 11, 2025, Marc Zyngier wrote:
> > > On Sat, 11 Jan 2025 01:24:48 +0000,
> > > Sean Christopherson <seanjc@google.com> wrote:
> > > > 
> > > > Add a kvm_run flag, KVM_RUN_NEEDS_COMPLETION, to communicate to userspace
> > > > that KVM_RUN needs to be re-executed prior to save/restore in order to
> > > > complete the instruction/operation that triggered the userspace exit.
> > > > 
> > > > KVM's current approach of adding notes in the Documentation is beyond
> > > > brittle, e.g. there is at least one known case where a KVM developer added
> > > > a new userspace exit type, and then that same developer forgot to handle
> > > > completion when adding userspace support.
> > > 
> > > Is this going to fix anything? If they couldn't be bothered to read
> > > the documentation, let alone update it, how is that going to be
> > > improved by extra rules and regulations?
> > > 
> > > I don't see how someone ignoring the documented behaviour of a given
> > > exit reason is, all of a sudden, have an epiphany and take a *new*
> > > flag into account.
> > 
> > The idea is to reduce the probability of introducing bugs, in KVM or userspace,
> > every time KVM attaches a completion callback.  Yes, userspace would need to be
> > updated to handle KVM_RUN_NEEDS_COMPLETION, but once that flag is merged, neither
> > KVM's documentation nor userspace would never need to be updated again.  And if
> > all architectures took an approach of handling completion via function callback,
> > I'm pretty sure we'd never need to manually update KVM itself either.
> 
> You are assuming that we need this completion, and I dispute this
> assertion.

Ah, gotcha.

> > > > +The pending state of the operation for such exits is not preserved in state
> > > > +which is visible to userspace, thus userspace should ensure that the operation
> > > > +is completed before performing state save/restore, e.g. for live migration.
> > > > +Userspace can re-enter the guest with an unmasked signal pending or with the
> > > > +immediate_exit field set to complete pending operations without allowing any
> > > > +further instructions to be executed.
> > > > +
> > > > +Without KVM_CAP_NEEDS_COMPLETION, KVM_RUN_NEEDS_COMPLETION will never be set
> > > > +and userspace must assume that exits of type KVM_EXIT_IO, KVM_EXIT_MMIO,
> > > > +KVM_EXIT_OSI, KVM_EXIT_PAPR, KVM_EXIT_XEN, KVM_EXIT_EPR, KVM_EXIT_X86_RDMSR,
> > > > +KVM_EXIT_X86_WRMSR, and KVM_EXIT_HYPERCALL require completion.
> > > 
> > > So once you advertise KVM_CAP_NEEDS_COMPLETION, the completion flag
> > > must be present for all of these exits, right? And from what I can
> > > tell, this capability is unconditionally advertised.
> > > 
> > > Yet, you don't amend arm64 to publish that flag. Not that I think this
> > > causes any issue (even if you save the state at that point without
> > > reentering the guest, it will be still be consistent), but that
> > > directly contradicts the documentation (isn't that ironic? ;-).
> > 
> > It does cause issues, I missed this code in kvm_arch_vcpu_ioctl_run():
> > 
> > 	if (run->exit_reason == KVM_EXIT_MMIO) {
> > 		ret = kvm_handle_mmio_return(vcpu);
> > 		if (ret <= 0)
> > 			return ret;
> > 	}
> 
> That's satisfying a load from the guest forwarded to userspace.

And MMIO stores, no?  I.e. PC needs to be incremented on stores as well.

> If the VMM did a save of the guest at this stage, restored and resumed it,
> *nothing* bad would happen, as PC still points to the instruction that got
> forwarded. You'll see the same load again.

But replaying an MMIO store could cause all kinds of problems, and even MMIO
loads could theoretically be problematic, e.g. if there are side effects in the
device that trigger on access to a device register.
