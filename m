Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EF418A6DC
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 22:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728339522; cv=none; b=T2rNgHlH2ct4X8iaqWt8ozp8vFoIzTyV0b/zk5n4ok+NcF0arqq447KItb3aDX85ZHo3ByH+an0XnrwxDS8ynmyw6RKItxO0I/DeNpJ+LwyEjt06VrPGluQ1HStkmS4fz8A3pVxIZrzM6P290odGAvuKAg0KOuxRyay6i6ZDedk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728339522; c=relaxed/simple;
	bh=UoEvfxPv/9YHVRTMYfiNwLA7iNAasu6q01J3XudZh/4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BWyQGN2889FM+0iwd9rky4q/kHjiF6XVxDva8J8MEOW7Hnj3rHIdShe6+I5HlCBPJu5KTPhsXOCsuk63q+2YdQsVSJooPCU1LPCWi+d8J7c+Khjax3iw+5MmHe4mI3atWeJfQw0BG8Dg/ODHvIv/V6cX+sZ7Ex/yrPTM5AUL1U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k4UIIUfM; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k4UIIUfM"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e2364f45a4so63570137b3.2
        for <kvmarm@lists.linux.dev>; Mon, 07 Oct 2024 15:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728339520; x=1728944320; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DCJs1Xfk97FhwF9USymt/FHqSPGdwG1SuIlB9CEAQn8=;
        b=k4UIIUfMDh/IB+zMkn3qC76+/YaM7y0tGM/R/bqWkhu08uLZ4gd/Z6VNfsk1PR2hcs
         qG8FKP8AZ+KOYxnkTtvhS2CWxM5YzCyd9zEvvWgIefwfY4xWVxroYSKFqZ7Q7TGb/MuB
         Y+imEnmp6vxzsWZY9aWq02iiqJWVxMTp9Y1K4i/QxwvEyZeTV+Yw2KevEpSkW8cC69c6
         bIz4XwncetpxPKgMEjspYYRI5QTJFiuW5YMIvYAOycpK7C6+RKAVc/c8/NDXpqda+48K
         7DBKOtI1dq9KCMM/a1h2nXEwwxptrLcn6zJk7iy/6F3+QMAQKn9zRMEgpv+b13NnMSEF
         XsQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728339520; x=1728944320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DCJs1Xfk97FhwF9USymt/FHqSPGdwG1SuIlB9CEAQn8=;
        b=NcGuMpPSSknBCAxf1MlBFeZkqg5gSg9LX1uqo8ju4EqsPFmvIPCt/7bQfW7I3ZxODd
         cDrXcZG2HZm2KL7CsLOnH77e4qV4fyAcCqdrveMEOda9uneDyKDm2t/YCDynGxdnpc+S
         AT8lHslZErheANLk0RolE1pB7dmMDtItTweEETI6BqGzsJIpB8z6x+VAU8HqfIQXaI6l
         PHlCgWoEcAPimjuN+uKv5+5EXPEogfLihg1lSUMdIZFujI8YZTonsTmQFoMNPMa2PjBF
         NkOkN8Apc98tCw7HHN/OrbprvWm/9bXchIBsgQBHvtnO52P8t18LhaDpipeuaCGsHngf
         Oo7w==
X-Gm-Message-State: AOJu0YzbDWF1qvawhonXdXsgFzrZorlbEzW2oVWsDLWbh+dQ6/U1XKqm
	S9V73qAbU2ARWjl6hg64M8VbOzwxSVC923vPjPnBlmsrGl2Umx2OaPz2iAIdSct6i83H1vtpLRK
	mAg==
X-Google-Smtp-Source: AGHT+IFEuNWlsge45RayOIWan6HYcoWWHK/6Hez2fwcotTj5CQ6cm3iVzqFk2SMfyLwH7k8ff59U11oBAMY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:bc46:0:b0:e26:b34:342b with SMTP id
 3f1490d57ef6-e28936d6592mr9025276.4.1728339519823; Mon, 07 Oct 2024 15:18:39
 -0700 (PDT)
Date: Mon, 7 Oct 2024 15:18:38 -0700
In-Reply-To: <ZwRRKM5dMZ22KYKf@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241007164256.1795250-1-oliver.upton@linux.dev>
 <20241007164256.1795250-2-oliver.upton@linux.dev> <ZwQq6Vk5_7Or4hW1@google.com>
 <ZwQwCqR11wlADRUA@linux.dev> <ZwQ8EMcZYtUb6wk_@google.com> <ZwRRKM5dMZ22KYKf@linux.dev>
Message-ID: <ZwRePkoM4rUsuQrA@google.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: nv: Keep reference on stage-2 MMU when
 scheduled out
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 07, 2024, Oliver Upton wrote:
> On Mon, Oct 07, 2024 at 12:52:48PM -0700, Sean Christopherson wrote:
> > > That wouldn't be an optimization, it'd render the halt polling loop
> > > useless.
> 
> <snip>
> 
> > Hmm, but what happens if the wakeup event arrives before IN_WFI is set?  Ah, IIUC,
> > GICR_VPENDBASER_PendingLast tracks if there's a pending event, KVM makes sure to
> > read PendingLast after making vPE non-resident, and hardware is required to ensure
> > either PendingLast=1 or a doorbell is signaled.
> > 
> > Niave question time: why not query GICR_VPENDBASER_PendingLast directly in
> > kvm_vgic_vcpu_pending_irq() instead of putting the vGIC?
> 
> The GIC is only required to update GICR_VPENDBASER.PendingLast when
> software deschedules the loaded vPE, meaning GICR_VPENDBASER.Valid goes
> from 1 => 0.

Ugh, that sucks.  I wish we could magically combine Intel+AMD+ARM implementations
for direct injection.  They all do things just slightly differently, and each one
has some behaviors that I really like, and each one has at least one behavior that
makes me sad.

> > > The most recent view of the guest's CPU interface is sitting in
> > > hardware at this point, so we need to synchronize KVM's view of
> > > the CPUIF with it to determine if a pending interrupt exceeds the
> > > priority mask.
> 
> </paste>
> 
> The guest's enable bits and priority mask are in ICH_VMCR_EL2, and we
> need to read that out of the CPU in order for this loop to work:
> 
> int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
> {
> 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> 	struct vgic_irq *irq;
> 	bool pending = false;
> 	unsigned long flags;
> 	struct vgic_vmcr vmcr;
> 
> 	if (!vcpu->kvm->arch.vgic.enabled)
> 		return false;
> 
> 	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last)
> 		return true;
> 
> 	vgic_get_vmcr(vcpu, &vmcr);
> 
> 	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
> 
> 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
> 		raw_spin_lock(&irq->irq_lock);
> 		pending = irq_is_pending(irq) && irq->enabled &&
> 			  !irq->active &&
> 			  irq->priority < vmcr.pmr;		<====== Need latest PMR
> 		raw_spin_unlock(&irq->irq_lock);
> 
> 		if (pending)
> 			break;
> 	}
> 
> 	raw_spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
> 
> 	return pending;
> }
> 
> KVM's in-memory view of VMCR is updated in vgic_put().

Ah, vgic_get_vmcr() is just unpacking the software-cached VMCR.  I missed that
on the first few reads.

Thanks for being patient :-)

> So even w/o GICv4 direct injection, the seemingly premature GIC save/restore
> is essential for halt polling to actually do something useful.
