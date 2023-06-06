Received: from out-35.mta1.migadu.com (out-35.mta1.migadu.com [95.215.58.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5398319915
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 16:48:19 +0000 (UTC)
Date: Tue, 6 Jun 2023 16:48:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686070098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DogLaWfzYy1/V+VaCUUG3NCZlKwH3PQn/dBKrg24mDs=;
	b=qySYn1IIF+xLlPjgV/vBzMH2Wd4dyYoD+7O6Ulz78Cvz1DL/rfaAfnyq8IZduFBE3Y6zfW
	hfcQNbdETzlTmXPnC7kBxNkKZVrLJgVVl31Z2Ahwz5KQUEI5Eq7oWT3r2zCxtNNGEyippn
	Vp6u3pWNgfnZV0UJqAeGZmOijWc+UBk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Sebastian Ott <sebott@redhat.com>,
	Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] KVM: arm64: Fix smp_processor_id() call in preemptible
 context
Message-ID: <ZH9jTrR8cdkOdJKu@linux.dev>
References: <2f16f83e-ed60-fcb7-7f3d-0fa216c41cb9@redhat.com>
 <ZH8+ZG7DOX9TYcIY@linux.dev>
 <87pm68o99d.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pm68o99d.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 06, 2023 at 05:17:34PM +0100, Marc Zyngier wrote:
> On Tue, 06 Jun 2023 15:10:44 +0100, Oliver Upton <oliver.upton@linux.dev> wrote:
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index 491ca7eb2a4c..933a6331168b 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -700,7 +700,7 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
> >  
> >  	mutex_lock(&arm_pmus_lock);
> >  
> > -	cpu = smp_processor_id();
> > +	cpu = raw_smp_processor_id();
> >  	list_for_each_entry(entry, &arm_pmus, entry) {
> >  		tmp = entry->arm_pmu;
> >  
> > 
> 
> If preemption doesn't matter (and I really don't think it does), why
> are we looking for a the current CPU? I'd rather we pick the PMU that
> is associated with CPU0 (we're pretty sure it exists), and be done
> with it.

Getting the current CPU is still useful, we just don't care about that
cpu# being stale. Unconditionally using CPU0 could break existing usage
patterns.

A not-too-contrived example would be to taskset QEMU onto a cluster of
cores in a big.LITTLE system (I do this). The current behavior would
assign the right PMU to the guest. I've made my opinions about the 'old'
ABI quite clear, but I don't have too great of an appetite for breakage,
though fragile.

Can we proceed with the fix I had suggested along with a more complete
description of the baggage that we're carrying?

-- 
Thanks,
Oliver
