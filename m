Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658BB14374F
	for <kvmarm@lists.linux.dev>; Thu,  1 Aug 2024 18:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722535294; cv=none; b=Umq4cse8apMOAEUTGBy1NE9m0/ajY00mzHgNQJRvNvgJ/omF3E0YHoG28StF/72KSeKKDOrXPODSuhpxBWigiCnsLTd/S7S2WOPIlRzMg77+k6TNaqzlgmCTVwsp/V8/CLnroMK8rNVBreOHElv70Q3RCAtmApGdmGCc1rlMk2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722535294; c=relaxed/simple;
	bh=B4USJ3DcoEtC2grgJaNeehMjrX/R6yyLoOz0nwuEw9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sCYzOOq/lWYxSdUt5TRv0M2ysvO2DKO3vlqFQCM9iHpoJ5fPOivT+CTm38PM+dSmhYzQXhsQydlmc/ul9DM8haOAtVNov2q5DiSnnfFKzkUyrQk+SwK0n8L/xOnaGaz6fCuoOpS2IqKIojrzlzEur2c+hiXBzK6B+FLXpmJnlUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4moarI/e; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4moarI/e"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a28217cfecso7441116a12.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Aug 2024 11:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722535292; x=1723140092; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xl2Pju3NY9Fnm1xajnPNr4ZOFDET+sfv7XV8JXyIerc=;
        b=4moarI/efjsuhWG1RgrJl0p8ZHZ3T7DeYTEUR5q5CwH3okgTbbhOwjsdV5coFVbyCO
         wG6IAnlwtcJGVtJ5w0ag5f3AIsIapjuYNQsasHFHKp9eI+A9URbCb+O0LEdoa3/FCrxB
         EsDDugHkFSVWjXI/PjFZjaP9T2qUc6nItlLefNlWOoXtANyv1Z7PlWe/+cxWIhCr3CQ1
         Z5WmKHvDwOnyABHEiKAs7Uqh+IGS+EgH9Ew+DC3tl0zScVWwWL78x4F6Ovzp0K80GbTR
         2SZ4P1uH4UL6QYcHFgVo9SdjK0r+VnGb76SbExvYPT3bN/UXth16B/ceHH+LWkEZdcsF
         DwBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722535292; x=1723140092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xl2Pju3NY9Fnm1xajnPNr4ZOFDET+sfv7XV8JXyIerc=;
        b=Hbd+rsKFRlXkJtKyCX2IVVNjP5owe2bJUZMPmPORpuva1ZdpBUwHM3V9EgDyDrft7d
         qPjRm6xcmRyKr8xcM2SgRs+DH5xANowXa74kRcx1q9N4bUMX5FalB3QKGtPEU+GhkGO3
         TUMMg4d9RA4njX2SVCn+DIiroxpmFsdzk73cVyUeVRaPgcE9623Ony7uf5hL7wOZSN8R
         AOt3CEcx4+SOkzy102qcHOAcqlmyVZZqQzE1oG2E500JzFOxY829jA51hmyIGXH4Ojcc
         uYhRRu5wumw4+Q+2tAGmczieHjatXxX+yj368LnqF31AxJWZq6mdLyePRG8t9ZmEk/3S
         pNLg==
X-Forwarded-Encrypted: i=1; AJvYcCVluDStd2WqhJ604CfmC2wg+3RsbE3UfFkK1k2fA5f5IvfWb4m3DewRCtlrhx7Va7MDTOZF72OF+5XhXn6FiXZo0GemkHdb
X-Gm-Message-State: AOJu0Yy8LUWpXC5Lux+8yTTjXCm6IX+lnxTgdZnEZjxOvhz4LyNm0owD
	zODK+u+TaTor9zNpyz1flupBvnCbmnvg3yp+Dw6vDCCleMd3zIPnKg4Jx/R0Ik1lLXpK7/ZDgRg
	BIg==
X-Google-Smtp-Source: AGHT+IF64U8Ib+bNIe3iPxoSzJOvvilQGXPjPZq7Y/8acNPwlcg0hACHnvmYPGnFv3dx9aufX4l27GJDySU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6252:0:b0:75a:b299:85b6 with SMTP id
 41be03b00d2f7-7b74669c7b3mr1534a12.2.1722535291408; Thu, 01 Aug 2024 11:01:31
 -0700 (PDT)
Date: Thu, 1 Aug 2024 11:01:30 -0700
In-Reply-To: <yq5aikwku25o.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-3-seanjc@google.com>
 <yq5aikwku25o.fsf@kernel.org>
Message-ID: <ZqvNekQAjs-SN-se@google.com>
Subject: Re: [PATCH v12 02/84] KVM: arm64: Disallow copying MTE to guest
 memory while KVM is dirty logging
From: Sean Christopherson <seanjc@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 01, 2024, Aneesh Kumar K.V wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Disallow copying MTE tags to guest memory while KVM is dirty logging, as
> > writing guest memory without marking the gfn as dirty in the memslot could
> > result in userspace failing to migrate the updated page.  Ideally (maybe?),
> > KVM would simply mark the gfn as dirty, but there is no vCPU to work with,
> > and presumably the only use case for copy MTE tags _to_ the guest is when
> > restoring state on the target.
> >
> > Fixes: f0376edb1ddc ("KVM: arm64: Add ioctl to fetch/store tags in a guest")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/arm64/kvm/guest.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index e1f0ff08836a..962f985977c2 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -1045,6 +1045,11 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >  
> >  	mutex_lock(&kvm->slots_lock);
> >  
> > +	if (write && atomic_read(&kvm->nr_memslots_dirty_logging)) {
> > +		ret = -EBUSY;
> > +		goto out;
> > +	}
> > +
> >
> 
> is this equivalent to kvm_follow_pfn() with kfp->pin = 1 ?

No, gfn_to_pfn_prot() == FOLL_GET, kfp->pin == FOLL_PIN.  But that's not really
relevant.

> Should all those pin request fail if kvm->nr_memslots_dirty_logging != 0? 

No, the conflict with dirty logging is specifically that this code doesn't invoke
mark_page_dirty().  And it can't easily do that, because there's no loaded ("running")
vCPU, i.e. doing so would trip this WARN:

#ifdef CONFIG_HAVE_KVM_DIRTY_RING
	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
		return;

	WARN_ON_ONCE(!vcpu && !kvm_arch_allow_write_without_running_vcpu(kvm)); <====
#endif
