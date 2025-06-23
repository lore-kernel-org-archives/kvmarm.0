Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06452D29B7
	for <kvmarm@lists.linux.dev>; Mon, 23 Jun 2025 16:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750695529; cv=none; b=cEUx7O4Cs2x5/ao/zpXrZqUN9BKidevaAS0PEviDowGbIv/6Ei9nEBdGetFzhKeYfvmHOWI7G78Kby04oiOhQHOF0zlIVAh/7h0gkwl4HlVHD5xAQ/GDncWS4qwDEk/OnItuh5hDPf1pcnole4Tdsk9RcFEj0YYbB6ZDXwfqPoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750695529; c=relaxed/simple;
	bh=EDHaxySB1XyXigRSYjSRI7C2L41azpKZfXI/ttcEEo0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kf6DFmtonUY/KwiqnOmUMVtENyJllPhQw1ijnUc3+4YhFPcRqxsco06MxI/Ma2Ki7HIgQYlsumwu9ex7FWOlcR+1HvSZt+yK2QNcXVrERLNzloHXHfgTKZn+XmMYQ25NjdzVZ58FNI9uvGmMmu4FyQd+upCKWxDKXquTCEpryFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PkbOP9F4; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PkbOP9F4"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2fb347b3e6so4351979a12.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Jun 2025 09:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750695527; x=1751300327; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OOkpzMlhlXRiMCNdOIvauV/qFub0T/UowmpNSsYnBL4=;
        b=PkbOP9F44aaEFBpJA6zaDI6BJTOCHblVVeyKribH2t06HWG8TG32r0B31/RXz4B++A
         kQJ2H6ia4pRZvtHHzg79KWjpXmmDncCLkJdk43DLXRizXrxfZ7uXi3aT50Mjxsb2xxvt
         83FZ3urZhNAffm7O9efdVZH6vgXe51DeHrQVXs12Q9eDhSzBpQUfC+iUKy2Tec0vX6zO
         0JQMV62qDJ/ooyoU3H3LLJYrDr03rv2bdT1T+gFeG59Hoxef3MrgmtRTKprvsg5eVxhr
         dNHQ247BZt2N4dfHGawxlqy8c6AmbLnetMI1A0ikn6jmDM+YhqVbeWzAH93x0tQmbAoj
         61hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750695527; x=1751300327;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OOkpzMlhlXRiMCNdOIvauV/qFub0T/UowmpNSsYnBL4=;
        b=CCfTXlNBob+Oy56TEu89BKsU0UH0YUHF/NIc/IYFkmUROZdcNQ83x9gQtPnx8Ph9gl
         NeRipHXGEgR6tJdvt0SOfKwx1R37VuRJdBaD5EYmSX4tLnwpXQ5y5pd9mT5+RmujBuPm
         F6oaJhvYJa+hfz/bIVRW/K0XNVX48esSElrz2P7SEnfXTnjFsMaMjwyXuv6VBK3bPDf5
         eQeWywCvjltmzs1j2tPzB01l6bZibqWZwf5k3jihtIWJDfTJqlCHIyNfDL+sUEolIO87
         7r6H6VAa4KHAyl065B3Lvjlt/+QwED+Z1Bitb9F94Hjz0UvGIAMbbgFyfbG492SQzwNW
         9HvA==
X-Forwarded-Encrypted: i=1; AJvYcCVj/mcfzFaEcQa1JBZ361V5qDmNXHhIGkrYVwIgGq0/BkRuVZFSb4jLWemDpf98P5B6T0D5/Js=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyow3S60cyNeG7bNXVQXLB0Y45FkxF9yFYcIJMHX/UPzwV6p947
	Q1GfH5qtbpWdcwjk9b+4onyOQMH5yt74BDknhjtSewWOpG51oT5Zkfak4v1PLgBTrdVJpiGaDPZ
	hd6ayMQ==
X-Google-Smtp-Source: AGHT+IENQipggL2SOcRyFklB3/6faa8uHHLu36CbWgSZEypv6kRSEUBRnwpSzpoNeCEIYgBhsThVyFLxqUA=
X-Received: from pfug19.prod.google.com ([2002:a05:6a00:793:b0:749:8f7:e14e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c992:b0:21f:5c9d:498e
 with SMTP id adf61e73a8af0-22026d32fe2mr19839452637.7.1750695527173; Mon, 23
 Jun 2025 09:18:47 -0700 (PDT)
Date: Mon, 23 Jun 2025 09:18:45 -0700
In-Reply-To: <pxtvegopzsyhn7lelksclxiiee7tumppu76553rax7octqpy7i@giclgo667htf>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com> <20250611224604.313496-22-seanjc@google.com>
 <pxtvegopzsyhn7lelksclxiiee7tumppu76553rax7octqpy7i@giclgo667htf>
Message-ID: <aFl-ZYyf9guxSkHE@google.com>
Subject: Re: [PATCH v3 20/62] KVM: SVM: Add a comment to explain why
 avic_vcpu_blocking() ignores IRQ blocking
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 23, 2025, Naveen N Rao wrote:
> On Wed, Jun 11, 2025 at 03:45:23PM -0700, Sean Christopherson wrote:
> > Add a comment to explain why KVM clears IsRunning when putting a vCPU,
> > even though leaving IsRunning=1 would be ok from a functional perspective.
> > Per Maxim's experiments, a misbehaving VM could spam the AVIC doorbell so
> > fast as to induce a 50%+ loss in performance.
> > 
> > Link: https://lore.kernel.org/all/8d7e0d0391df4efc7cb28557297eb2ec9904f1e5.camel@redhat.com
> > Cc: Maxim Levitsky <mlevitsk@redhat.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/svm/avic.c | 31 ++++++++++++++++++-------------
> >  1 file changed, 18 insertions(+), 13 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index bf8b59556373..3cf929ac117f 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -1121,19 +1121,24 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
> >  	if (!kvm_vcpu_apicv_active(vcpu))
> >  		return;
> >  
> > -       /*
> > -        * Unload the AVIC when the vCPU is about to block, _before_
> > -        * the vCPU actually blocks.
> > -        *
> > -        * Any IRQs that arrive before IsRunning=0 will not cause an
> > -        * incomplete IPI vmexit on the source, therefore vIRR will also
> > -        * be checked by kvm_vcpu_check_block() before blocking.  The
> > -        * memory barrier implicit in set_current_state orders writing
> > -        * IsRunning=0 before reading the vIRR.  The processor needs a
> > -        * matching memory barrier on interrupt delivery between writing
> > -        * IRR and reading IsRunning; the lack of this barrier might be
> > -        * the cause of errata #1235).
> > -        */
> > +	/*
> > +	 * Unload the AVIC when the vCPU is about to block, _before_ the vCPU
> > +	 * actually blocks.
> > +	 *
> > +	 * Note, any IRQs that arrive before IsRunning=0 will not cause an
> > +	 * incomplete IPI vmexit on the source; kvm_vcpu_check_block() handles
> > +	 * this by checking vIRR one last time before blocking.  The memory
> > +	 * barrier implicit in set_current_state orders writing IsRunning=0
> > +	 * before reading the vIRR.  The processor needs a matching memory
> > +	 * barrier on interrupt delivery between writing IRR and reading
> > +	 * IsRunning; the lack of this barrier might be the cause of errata #1235).
> > +	 *
> > +	 * Clear IsRunning=0 even if guest IRQs are disabled, i.e. even if KVM
> > +	 * doesn't need to detect events for scheduling purposes.  The doorbell
> 
> Nit: just IsRunning (you can drop the =0 part).

Hmm, not really.  It could be:

	/* Note, any IRQs that arrive while IsRunning is set will not cause an

or

	/* Note, any IRQs that arrive while IsRunning=1 will not cause an

but that's just regurgitating the spec.  The slightly more interesting scenario
that's being described here is what will happen if an IRQ arrives _just_ before
the below code toggle IsRunning from 1 => 0.

> Trying to understand the significance of IRQs being disabled here. Is 
> that a path KVM tries to optimize?

Yep.  KVM doesn't need a notification for the undelivered (virtual) IRQ, because
it won't be handled by the vCPU until the vCPU enables IRQs, and thus it's not a
valid wake event for the vCPU.

So, *if* spurious doorbells didn't affect performance or functionality, then
ideally KVM would leave IsRunning=1, e.g. so that the IOMMU doesn't need to
generate GA log events, and so that other vCPUs aren't forced to VM-Exit when
sending an IPI.  Unfortunately, spurious doorbells are quite intrusive, and so
KVM "needs" to clear IsRunning.

> Theoretically, it looks like we want to clear IsRunning regardless of whether
> the vCPU is blocked so as to prevent the guest from spamming the host with
> AVIC doorbells -- compared to always keeping IsRunning set so as to speed up
> VM entry/exit.

Yep, exactly.

> > +	 * used to signal running vCPUs cannot be blocked, i.e. will perturb the
> > +	 * CPU and cause noisy neighbor problems if the VM is sending interrupts
> > +	 * to the vCPU while it's scheduled out.
> > +	 */
> >  	avic_vcpu_put(vcpu);
> >  }
> 
> Otherwise, this LGTM.
> Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>
> 
> 
> Thanks,
> Naveen
> 
