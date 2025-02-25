Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB26280A31
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 14:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740494146; cv=none; b=iR5KEkHc85Nv8SKZ2R7cEPwT5iRkt0QwX6pzFunp5w1Ix50kJhx1iTTzxeSYtrcjFDTHiqq+qX/PhXbdlDJoPXPDhn7ckwn6VOFtURQvTZahMk/jhOEDBgCUsrCMIlWN4CErciASFR3p/Y9ECbEglj+FK2QqKNQqYOFPNlaNvh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740494146; c=relaxed/simple;
	bh=9hyuXWtcrt6qYFRuvHO0bnjXrHF/CkXG7yP6ynsJrjs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wl4eTqBaZO9jivNwzAFxduDUCfbAGw6c7lx2GtezBE0eN4zMXKir6VnlZqHmLYW8f/BatPgCxEimP9OwLCVDpsm82JPm8p1w/VN3LMBHJ5837tEP/zAa+SbIC+11otbYvzNHCd7zvG0qRaPBVotl6LpKXtS86dv09ul/ev5u130=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ImWW0go4; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ImWW0go4"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fbff6426f5so11862435a91.3
        for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 06:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740494142; x=1741098942; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u3OyWMfMyDgx+55Ind0kZ2lpQA8/mHOXTjN2aQVmO4M=;
        b=ImWW0go4TVyEeKkEKttwrx21bw/Ea3fX/27yW6yLqshxquoqMqY2YQuF3DrDqay+Jf
         lSybz76gSG4SUATFMdSbOizbvKLM1BuOO+V0ZtmTzhc2/FYpT4PssZ6fpB7GXhjPQlnl
         VeI/o1lKKwx7oFXXDduQ0ZlJKC62265/busPlOOV+8lnajeuPyVIOSAHQ1+6+pLWAAKE
         m0Qb/Wr+tqnGUJEGftHa4grnfSY0fIOfMxDJwhvUm86LzDpXhmCPSi/wf4qUBSK6lwSy
         8RG68soYVwC7EOphY+qrzIwuLQIvWxYgHZL1/MG0690iVMkV54Q27dp2fr4kV6nEnAL0
         sVkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740494142; x=1741098942;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u3OyWMfMyDgx+55Ind0kZ2lpQA8/mHOXTjN2aQVmO4M=;
        b=mDt1xzx74RiS9bshFGVYEGNC4jkG4L6SDwe++g3/JH+Wsbx1DcN970r7T93o32CBWk
         IL6uYHC9EkWQsJ30cvL4MgiKU7EVsYD0f2rfymxlW+SgAQfkL0CahM57qNaCgtTpZfYC
         qXkyR4pu2tqFTczpiqulpIIn0XFd1sMNwjdZZx/XTg8JbG9Ir2r9z0mZs4nR4sxfmNkX
         iSomL9ntSwg0QPGX2SUCfIHsj+fyEceSyQMKrju2n6e3vhw/AqZyhw+XqKkucFHSNdeI
         Hri3axTmy1U/Xg8eOcDzL36cbM9KdtD24KJmsnVr+WCFModG4k9WvcogTtNVyWs0Vw+M
         YKHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgLjAmTMGKKfn8G0+ED1wI+Dg4zpa8k1GsEFoHjx8KgEgQ1Sz+xRBDnzZOoas/GH01KUkHqGI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxGFno3eDaOLlRO1VF3E5WJNa4lN9kcGDs6pXoE+pcFSZjfjmq/
	/gROi6xuJydzdm8/R0CdiUP9bo9Gk8/0BKDDMrl4vOZ+luc3kujwOzncuRt4OOdqSOKu+MkR8bT
	YqQ==
X-Google-Smtp-Source: AGHT+IFXh/XOoHWCgjyYmqDQFrw6VQ+lwV1XpaGwsHvB9OE+S78BXcvOxN0p4LNeKFLBgsLwKA4Y+N0kitA=
X-Received: from pjbdj6.prod.google.com ([2002:a17:90a:d2c6:b0:2fa:1fac:269c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8e:b0:2ee:c9b6:c26a
 with SMTP id 98e67ed59e1d1-2fe68ada3bemr5889698a91.11.1740494141828; Tue, 25
 Feb 2025 06:35:41 -0800 (PST)
Date: Tue, 25 Feb 2025 06:35:40 -0800
In-Reply-To: <Z71sOEu7/ewnWZU2@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224235542.2562848-1-seanjc@google.com> <20250224235542.2562848-4-seanjc@google.com>
 <Z71sOEu7/ewnWZU2@yzhao56-desk.sh.intel.com>
Message-ID: <Z73U38mSuk_tOpqT@google.com>
Subject: Re: [PATCH 3/7] KVM: Assert that a destroyed/freed vCPU is no longer visible
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Aaron Lewis <aaronlewis@google.com>, Jim Mattson <jmattson@google.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 25, 2025, Yan Zhao wrote:
> On Mon, Feb 24, 2025 at 03:55:38PM -0800, Sean Christopherson wrote:
> > After freeing a vCPU, assert that it is no longer reachable, and that
> > kvm_get_vcpu() doesn't return garbage or a pointer to some other vCPU.
> > While KVM obviously shouldn't be attempting to access a freed vCPU, it's
> > all too easy for KVM to make a VM-wide request, e.g. via KVM_BUG_ON() or
> > kvm_flush_remote_tlbs().
> > 
> > Alternatively, KVM could short-circuit problematic paths if the VM's
> > refcount has gone to zero, e.g. in kvm_make_all_cpus_request(), or KVM
> > could try disallow making global requests during teardown.  But given that
> > deleting the vCPU from the array Just Works, adding logic to the requests
> > path is unnecessary, and trying to make requests illegal during teardown
> > would be a fool's errand.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 201c14ff476f..991e8111e88b 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -489,6 +489,14 @@ void kvm_destroy_vcpus(struct kvm *kvm)
> >  	kvm_for_each_vcpu(i, vcpu, kvm) {
> >  		kvm_vcpu_destroy(vcpu);
> >  		xa_erase(&kvm->vcpu_array, i);
> > +
> > +		/*
> > +		 * Assert that the vCPU isn't visible in any way, to ensure KVM
> > +		 * doesn't trigger a use-after-free if destroying vCPUs results
> > +		 * in VM-wide request, e.g. to flush remote TLBs when tearing
> > +		 * down MMUs, or to mark the VM dead if a KVM_BUG_ON() fires.
> > +		 */
> > +		WARN_ON_ONCE(xa_load(&kvm->vcpu_array, i) || kvm_get_vcpu(kvm, i));
> As xa_erase() says "After this function returns, loading from @index will return
> %NULL", is this checking of xa_load() necessary?

None of this is "necessary".  My goal with the assert is to (a) document that KVM
relies the vCPU to be NULL/unreachable and (b) to help ensure that doesn't change
in the future.  Checking xa_load() is mostly about (a).

That said, I agree checking xa_load() is more than a bit gratuitous.  I have no
objection to checking only kvm_get_vcpu().
