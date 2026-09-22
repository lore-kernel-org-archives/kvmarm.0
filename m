Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535BD2264A6
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 18:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790102787; cv=none; b=c/+4E6aF0oFRv2vi2bbZOld9BRsOzWRlEMZP8pWOLKtuFig5H2k45ivXhZMo2XWYG2cqfk7pygqGkSpt+NKo1AiITfz100Ov0LQ6O5es7SeuZTUKNkEqG7NqlKvp2pNSXovdluoh2BDcD7eqQo+ha8gUpmcC2c+gi12LwBSyFNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790102787; c=relaxed/simple;
	bh=P2oNbUgzNKbPC97q99tgXWb/Iok5vLJAaFSYPNe8o2w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ibj65+4AtwIP4OoTUmrPW0YfyCPtgCfYjnqwaKr/9d0a4U3a6rDLJbVxsAFZThzlT2JCXYdhQhNBwF1D7HvUWD0gbf4GQ7m3uA5NZ7oYF9ULHS93AgbVE32Rkndn5JkGTdU4lTs0vh/DGUN6kF7ZTpEUQuI7hAS7G2w5CiFqls0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aGtgGdiP; arc=none smtp.client-ip=209.85.215.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aGtgGdiP"
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc1b80835d5so227557a12.2
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 11:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790102779; x=1790707579; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wsMfNykkK/cvGUxGrrzkLoJGO5iJ1c5hJgEqfch5614=;
        b=aGtgGdiPd40aw1mPcvjiWYNuHBhSbOOZc0lkCyXfHWR5iLIRGmF2yj7Lm+m/yNdLaV
         SZXxwx2Zswx3JIZqMGzP3HUWEu/SnnOCiPg/nvrOwD+WE6fbg27tJMdcquhXnOCBvjKN
         arbSzUBYWO0jZWN4xAgyb/lwn7bX5uu47cWP2eNuxBKNdfhDCcEZ50stHG9n7qQHd76b
         R1iFk+muBluK0EzmRLTOQQzZA5NT5VtkZDckZaSmPVRJfnwmm1gO1kWh09LLpkjA5HDX
         hxyIOtml0PGEvGYPUdzFkLTbUxX3EP5U0/DI2v41GDm3NBH5bjT2CS/UJsyC9dIs96Yu
         C4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790102779; x=1790707579;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wsMfNykkK/cvGUxGrrzkLoJGO5iJ1c5hJgEqfch5614=;
        b=AaPnh30HXZZqFsBsDu/2FyIeQOunBCEybrr+2QtdEcETM8KYffUVTk5BqEFG0WR7d7
         +7qDRUs5lN5YDj5cObqWKXzilNCfWxO8OhBDCa8YA8cLnzCuDgzEiOynLE+jZNjWzlo/
         KcxYgCsTw1MuhnR8PyHUjHOnBcZICUvdaKXgbYMx2CuMYBZupy1DLVBNioLkTkTMKwq6
         rYDyxYwAJGb0huoMlgq1kSyCvZe0psuIm95dmob/ms32xnzl1Vl5esh1kbuI/PIBBygH
         8QMd9q4FxQscjKIoQs51ObV60tyxBfuDM/zwDhoKR0k9YDjJsXJgxTU94kOeS/pPOxmK
         lB0w==
X-Forwarded-Encrypted: i=1; AKwUvBxsuzwaEIGL7MgJ7jR4pK/jjfF+GuPMQmawFA14SBQBrIzs0HppiPRRC9DVKvbrilaAkremNpo=@lists.linux.dev
X-Gm-Message-State: AFuF++mJQTdi+Mz1+Rmix+eJMRfryjQ2RnofN+rJHLMdPYydAuVznLDd
	Z0cFsaWROSlsszoykw72ObIHWmofIyN27lmZ59p6Mb1eJpRZxQX/1cdhp9+sKIIdqAI8E6DKTFH
	ospOsSw==
X-Received: from pgdh8.prod.google.com ([2002:a05:6a02:5188:b0:cc5:1d7c:ddeb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1bc3:b0:3dd:a197:cf2a
 with SMTP id adf61e73a8af0-3ddf82c4849mr289558637.78.1790102779162; Tue, 22
 Sep 2026 11:46:19 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:46:18 -0700
In-Reply-To: <arLJ4AbNN9Y_IUna@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-1-787bd3bc7e3f@kernel.org> <arKxjsxuO1F5ExrY@kernel.org>
 <arK5n9HrbZMCOHOt@google.com> <arK5ynpRi7VbY7Ek@gremlin> <arK8seJVT9wYgVCP@google.com>
 <arLD-eZ6dRvfZ52q@kernel.org> <arLJ4AbNN9Y_IUna@gremlin>
Message-ID: <arLM-vJDoO7gQJXM@google.com>
Subject: Re: [PATCH v3 01/14] KVM: Allow architectures to disallow pre-fault
From: Sean Christopherson <seanjc@google.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 22, 2026, Lorenzo Stoakes (ARM) wrote:
> On Tue, Sep 22, 2026 at 11:07:53AM -0700, Oliver Upton wrote:
> > On Tue, Sep 22, 2026 at 10:36:49AM -0700, Sean Christopherson wrote:
> > > On Tue, Sep 22, 2026, Lorenzo Stoakes (ARM) wrote:
> > > > On Tue, Sep 22, 2026 at 10:23:43AM -0700, Sean Christopherson wrote:
> > > > > Rather than have kvm_arch_vcpu_allow_pre_fault_memory(), what if we add a more
> > > > > generic kvm_is_vcpu_loadable()?  That way we don't need to worry as much about
> > > > > the return value, the connection to vcpu_load() is obvious, and we don't need to
> > > > > add another pre-check if future (or cleaned-up existing?) ioctls want to do
> > > > > vcpu_load() in common code.
> > > >
> > > > ...this is exactly what I started out with.
> > > >
> > > > But then you are in a pickle, because _really_ you need to do that check in
> > > > vcpu_load(). Which is a void function. Which is called by every single
> > > > architecture all over the place.
> > > >
> > > > So you'd have actually no way of signalling the error back.
> > > >
> > > > Of course those places are arch code and you could say 'arches should know
> > > > better and if they call it it's fine not to call the arch 'can you load'
> > > > function.
> > >
> > > Yes, that's my vote.  It'd be easy enough to clarify that "rule" with a comment
> > > in linux/kvm_host.h.
> >
> > I feel like trying to make this generic will wind up under-documenting
> > the single example we have with the pre fault ioctl. Putting the comment
> > into a header practically guarantees that nobody will read it either.
> >
> > I'd favor doing something like below and sticking the comment inline in
> > the ioctl handler. Unless I'm missing something blatantly obvious, I
> > don't see why the x86 or s390 pre-conditions can't be tested early too.

Oh, they definitely can.  I'm a-ok with using kvm_arch_pre_fault_allowed() on
s390 and x86, the only option I am against is adding kvm_arch_pre_fault_allowed()
but then not using it on architectures that obviously perform that exact check.

> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3961,6 +3961,11 @@ bool __weak kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
> >  	return false;
> >  }
> >
> > +int __weak kvm_arch_pre_fault_allowed(struct kvm_vcpu *vcpu)
> > +{
> > +	return 0;
> > +}

There should be no need for a __weak placeholder since this code is guarded by
CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY=y.  I.e. force architectures to define the
API.  I don't think it's a coincidence that all of arm64, s390, and x86 ended up
with restrictions; pre-faulting is far from a simple operation.

Actually, that's an argument for a dedicated kvm_arch_pre_fault_allowed() versus
a generic kvm_is_vcpu_loadable(): it helps force future architectures to actually
think about when exactly pre-faulting is safe.
