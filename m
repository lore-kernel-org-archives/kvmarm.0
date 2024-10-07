Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37AF15B97D
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 19:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728330772; cv=none; b=gC9kzLZTnpTv6zhVvyUUUfAPEmQNm7CaDugNKrpmuS8tOoF5NJ2DzUA/zDRowjgUXzHWVK+Jt7LPUrx0oG5s9M5pBLlxs3uRMdt+LqZDq3j6MXrpCCjM7F/4fxFDxCzo2yxE9Syt0YsueVLg/D7JYIXRJUXRrE14E83arg28wYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728330772; c=relaxed/simple;
	bh=jom7jAYtOcZm2oPCxmYGIlVAqmtGts3ikdw2ttcRc4o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ITyhjqV/+A+b+z6F2ciF4D2ZBm//Qwz2F0zcGgpr8jWwFHSh/EHVuz2NhDX4RsTeNvt2dTuKbSKZqGQQyyZ/T67/j9GCOK53gAaXCV9kM6XyGKk0w/Y4/cVDSF3i32pHoxmSmVpjEMpjGW3LWoH7wVC8NXuEU5XJ6qNzVt4EiUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HGLurXMi; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HGLurXMi"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20b6d60eaa1so40793085ad.2
        for <kvmarm@lists.linux.dev>; Mon, 07 Oct 2024 12:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728330770; x=1728935570; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jtayPWPTjYG1MklKw84wmI16VA4uxG01Pb1I76fYIyw=;
        b=HGLurXMitEB8ktnoDEC5vJgCKNT9PuSkLEinCjKRBnyhBlGYFQa8Ag638BLGWcvehB
         XFQmSJnZdCP1RlmXr3xp3RbWXVCWDcd9iul84UWpqh/LSg1JJmofRzJbvIrRlRw4uby7
         0WRu5hFdzzg5AVmsO3AZQA59bLwAH8iW31EyNciFYIcLNblpD3J99Uay6jHCwxWYN/rZ
         2EeOPwSgL0uQ3fsqQ3y2rzeEI57PKzSknMA7tsC3e7A6J8JuPpJVwnsH/xidwKnGOkbU
         MVeAmYcmNZPSwbnevFleKyy5r/0uInJZW4wztCMS1aRNmIDHb1Q4GCqe+oW8SFdOyYls
         OWvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728330770; x=1728935570;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jtayPWPTjYG1MklKw84wmI16VA4uxG01Pb1I76fYIyw=;
        b=Wq3ws2Gl8aSVHJG+Y90iICYqFuct8/DAx1j0GPLRbMvzOE0eV62OLsKWPrFDvGq0uU
         QsSy2mT/mViFz07PTTJl+21cPvbR9LEsHPzCeEeD7MA6FwDSA12tyX0HYXoR9+6Xfu2Q
         wUlj0hodV3iVV90ExEGsA5TytIgRoXFqscCSNwGJMVRj36owHgqQcZpc919JfYrhA+N5
         n0zthQvZdg+FiAHuGs/DvVS7Pv6EEO6S5P2Ha9NBxRE+/YbY3Fh0SuqB6CWUXdb7USbc
         f1XfyvGAR+AqZy15roNhOwIiTFH/fUf909215XFPWal/r+77sI0YOf2MT4G7vGaLOz8W
         Y2Yg==
X-Gm-Message-State: AOJu0YzQw4ZytlfhewQzp27nASeoFklC7A/LHW7tEpJE8meZMZ/OXNSJ
	1oyumVSuTJ/ORWF5hM9m/V3+K5Okc43WJ+zlDNTyHal62XfaU7pF6QTvPsa6Dh6ZzzlxhkWGSQG
	R1w==
X-Google-Smtp-Source: AGHT+IG2D7EMl1sUI718mP81FPN5GSUI95pDS8xyxrYKd7IPg10dBelaFE8OaDBwd5IxdbIlyv70oCbEWbY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:ecc6:b0:20b:5c85:8e25 with SMTP id
 d9443c01a7336-20bfd9b05ecmr1307155ad.0.1728330769959; Mon, 07 Oct 2024
 12:52:49 -0700 (PDT)
Date: Mon, 7 Oct 2024 12:52:48 -0700
In-Reply-To: <ZwQwCqR11wlADRUA@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241007164256.1795250-1-oliver.upton@linux.dev>
 <20241007164256.1795250-2-oliver.upton@linux.dev> <ZwQq6Vk5_7Or4hW1@google.com>
 <ZwQwCqR11wlADRUA@linux.dev>
Message-ID: <ZwQ8EMcZYtUb6wk_@google.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: nv: Keep reference on stage-2 MMU when
 scheduled out
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 07, 2024, Oliver Upton wrote:
> On Mon, Oct 07, 2024 at 11:39:37AM -0700, Sean Christopherson wrote:
> > > @@ -674,10 +681,18 @@ void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
> > >  
> > >  void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
> > >  {
> > > -	if (kvm_is_nested_s2_mmu(vcpu->kvm, vcpu->arch.hw_mmu)) {
> > > +	/*
> > > +	 * Keep a reference on the associated stage-2 MMU if the vCPU is
> > > +	 * scheduling out and not in WFI emulation, suggesting it is likely to
> > > +	 * reuse the MMU sometime soon.
> > > +	 */
> > > +	if (vcpu->scheduled_out && !vcpu_get_flag(vcpu, IN_WFI))
> > > +		return;
> > 
> > Assuming KVM arm64 supports halt-polling, I think it makes more sense to check
> > kvm_vcpu_is_blocking() instead of IN_WFI.  That way, KVM will keep the MMU resident
> > if the vCPU happens to be preempted and halt-polling is successful.
> > 
> > And somewhat of a side topic, calling kvm_vgic_put() from kvm_arch_vcpu_blocking()
> > instead of kvm_vcpu_wfi() would provide the same optimization for the GIC, as KVM
> > would only need to put/reload the vGIC if the vCPU is actually scheduled out.
> 
> That wouldn't be an optimization, it'd render the halt polling loop
> useless.
> 
> The most recent view of the guest's CPU interface is sitting in
> hardware at this point, so we need to synchronize KVM's view of
> the CPUIF with it to determine if a pending interrupt exceeds the
> priority mask.

Hmm, but what happens if the wakeup event arrives before IN_WFI is set?  Ah, IIUC,
GICR_VPENDBASER_PendingLast tracks if there's a pending event, KVM makes sure to
read PendingLast after making vPE non-resident, and hardware is required to ensure
either PendingLast=1 or a doorbell is signaled.

Niave question time: why not query GICR_VPENDBASER_PendingLast directly in
kvm_vgic_vcpu_pending_irq() instead of putting the vGIC?  E.g. if safely querying
PendingLast is "heavy", wouldn't it still make sense to do a slow check of
PendingLast in kvm_vgic_vcpu_pending_irq() if IN_WFI=1?  Or is putting the vGIC
as lightweight as things get when it comes to checking PendingLast?

> On top of that, we need to activate the doorbell IRQ for GICv4 to give
> KVM a kick when something arrives for the vPE.

Right, but KVM needs to "manually" detect pending events to account for events
that arrive before the doorbell is activated, so from a functional perspective,
it shouldn't matter when KVM activates the doorbell (with respect to halt-polling).
