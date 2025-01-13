Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBF684A5B
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 15:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736783072; cv=none; b=skHZQ3IUzBApPqqwG08IA9v4WaSxSnO6PE6GUbm7V4yUcu673VGlAqc6E0OrRxTyqM+zpZDRdDpF95Ptw0LfuNY1HNDTWHAf/DFm1VcQvKqSBTfyrobagTsMa5ot+H5JVqDjMk17gWTQWw5AzW9d2aWr+AisPN3N6kBFqVNeZqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736783072; c=relaxed/simple;
	bh=84zIr5M6ISgHg97pFPOGD6Qiet1HFyiciIYEmNWPsFs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kk3cxm0SHQR+04g9eAdQaivfVmrux2Q7pH+hypkF43u5m0AdM7sM5h5bIVNs3P8FXpeOsYfy5RZAXnFUvMutsCc/vxUsQYYACcUx3vHbxzYRTibynwDoTAXBdYgC8x3eozxwmqde3/oSDLpUmx3KS9zRvFrhFN8Wdlma1UPToeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HE/zktw+; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HE/zktw+"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-218cf85639eso120394945ad.3
        for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 07:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736783070; x=1737387870; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f9GN/9Nt3vZP1g4PXg+O1YxepiT+zT9oJT9rhlVkhGw=;
        b=HE/zktw+cAz7MKfUMojOnN3nq43ZwvrKkhlYPDqkBDm//KhMiqmlKhN7Dt5hCIZo8s
         IeFFsxw9M+P7hXdXn1MumH9BCaRetwi0aj3rvcT8Bt/zO4UvRwNKmogW1EdU4o0IDW9e
         LiFNldckHQSgcIEpsfgqp8dOIP+Gl1jOCfwVX5X7U0HURITkeQBfdSYQew6Bs8moPK1Y
         JPl5HKNDxLmKXMp8XV+BnLwTIf+T2Ezexcc/3W1rQ5Emp1w1bYUFbUjT/q8SVaQ8e5Sz
         0sUGCbncxRqpeXnGSO2kPrk5S/reOLMBMBqryZxkSzRcbphD6hrlrkICOhT0G9XM1AW8
         hgVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736783070; x=1737387870;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f9GN/9Nt3vZP1g4PXg+O1YxepiT+zT9oJT9rhlVkhGw=;
        b=Xp5/KbJorm9O41Y5BNIwPu9fwxgjsA2lo9PRVQ7W8/tclMcQ5LBkwnEwyF5/O1nLjO
         uPcq+FnBqOyrb4lyryhd5UugAxV9TjpsbJVh/x+Dr/1wMPHsnKRXDeHewTsnmUvObD60
         bTsF88N92wbTq+MPMfTj5cWAwgTgx1urFHxlb1spsHpN/nCUuvvJ3h5OgkxuRxHfa8Xf
         c17CSs3CW4kke5JNGIHsum6O4ag8rJwQYOl6/RAi4ohiSnUzp8suIvZiFal5BFXxL8K1
         qkZmhCUm+MohEKmU5y9fH5SxSmGTd1PL5QUxaxcJUDn3wQZZhfV+m2ydKeR4THuqRiLy
         bXpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRx+EKGldTxgEpPCsbdyz6Yap5bpb3SBR5bl/DTJHMcu/9ZIW2FdSkTpzndvRwZJ1yfykeMbI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yws0ZINaCcXVJy+xuCPNiIP4u6O0qnl7ip0bLNyL++W1Q6npcQr
	t1DJ4mMe79K5dsJ4omH7hxB1hwvNJKOh+3Z+pXUjighUvoCrGdZ93mxcUPo6jC/RBy0txb+U+0K
	2fQ==
X-Google-Smtp-Source: AGHT+IHIQyazhiyyUpnFFe5650540BmH10WSCzq7nQUkxQTSPWj6gISntiQcqyGsVty8NrTJi6F4Z/IpKIc=
X-Received: from pfbfh41.prod.google.com ([2002:a05:6a00:3929:b0:72a:bc54:8507])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3993:b0:1e1:adb9:d1a6
 with SMTP id adf61e73a8af0-1e88d0f000fmr33694244637.41.1736783070268; Mon, 13
 Jan 2025 07:44:30 -0800 (PST)
Date: Mon, 13 Jan 2025 07:44:28 -0800
In-Reply-To: <87ikqlr4vo.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250111012450.1262638-1-seanjc@google.com> <20250111012450.1262638-4-seanjc@google.com>
 <87ikqlr4vo.wl-maz@kernel.org>
Message-ID: <Z4U03KRYy2DVEgJR@google.com>
Subject: Re: [PATCH 3/5] KVM: Add a common kvm_run flag to communicate an exit
 needs completion
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Michael Ellerman <mpe@ellerman.id.au>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Jan 11, 2025, Marc Zyngier wrote:
> On Sat, 11 Jan 2025 01:24:48 +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > Add a kvm_run flag, KVM_RUN_NEEDS_COMPLETION, to communicate to userspace
> > that KVM_RUN needs to be re-executed prior to save/restore in order to
> > complete the instruction/operation that triggered the userspace exit.
> > 
> > KVM's current approach of adding notes in the Documentation is beyond
> > brittle, e.g. there is at least one known case where a KVM developer added
> > a new userspace exit type, and then that same developer forgot to handle
> > completion when adding userspace support.
> 
> Is this going to fix anything? If they couldn't be bothered to read
> the documentation, let alone update it, how is that going to be
> improved by extra rules and regulations?
> 
> I don't see how someone ignoring the documented behaviour of a given
> exit reason is, all of a sudden, have an epiphany and take a *new*
> flag into account.

The idea is to reduce the probability of introducing bugs, in KVM or userspace,
every time KVM attaches a completion callback.  Yes, userspace would need to be
updated to handle KVM_RUN_NEEDS_COMPLETION, but once that flag is merged, neither
KVM's documentation nor userspace would never need to be updated again.  And if
all architectures took an approach of handling completion via function callback,
I'm pretty sure we'd never need to manually update KVM itself either.

> > +7.37 KVM_CAP_NEEDS_COMPLETION
> > +-----------------------------
> > +
> > +:Architectures: all
> > +:Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
> > +
> > +The presence of this capability indicates that KVM_RUN will set
> > +KVM_RUN_NEEDS_COMPLETION in kvm_run.flags if KVM requires userspace to re-enter
> > +the kernel KVM_RUN to complete the exit.
> > +
> > +For select exits, userspace must re-enter the kernel with KVM_RUN to complete
> > +the corresponding operation, only after which is guest state guaranteed to be
> > +consistent.  On such a KVM_RUN, the kernel side will first finish incomplete
> > +operations and then check for pending signals.
> > +
> > +The pending state of the operation for such exits is not preserved in state
> > +which is visible to userspace, thus userspace should ensure that the operation
> > +is completed before performing state save/restore, e.g. for live migration.
> > +Userspace can re-enter the guest with an unmasked signal pending or with the
> > +immediate_exit field set to complete pending operations without allowing any
> > +further instructions to be executed.
> > +
> > +Without KVM_CAP_NEEDS_COMPLETION, KVM_RUN_NEEDS_COMPLETION will never be set
> > +and userspace must assume that exits of type KVM_EXIT_IO, KVM_EXIT_MMIO,
> > +KVM_EXIT_OSI, KVM_EXIT_PAPR, KVM_EXIT_XEN, KVM_EXIT_EPR, KVM_EXIT_X86_RDMSR,
> > +KVM_EXIT_X86_WRMSR, and KVM_EXIT_HYPERCALL require completion.
> 
> So once you advertise KVM_CAP_NEEDS_COMPLETION, the completion flag
> must be present for all of these exits, right? And from what I can
> tell, this capability is unconditionally advertised.
> 
> Yet, you don't amend arm64 to publish that flag. Not that I think this
> causes any issue (even if you save the state at that point without
> reentering the guest, it will be still be consistent), but that
> directly contradicts the documentation (isn't that ironic? ;-).

It does cause issues, I missed this code in kvm_arch_vcpu_ioctl_run():

	if (run->exit_reason == KVM_EXIT_MMIO) {
		ret = kvm_handle_mmio_return(vcpu);
		if (ret <= 0)
			return ret;
	}

> Or is your intent to *relax* the requirements on arm64 (and anything
> else but x86 and POWER)?
