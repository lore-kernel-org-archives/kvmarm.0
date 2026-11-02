Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793637053;
	b=Ot1FAvY+wRjZalgDgDQvim1XWkpIo/37QvuF53F7GNbisbtdUiSRpPqVbYbDN0I1nO5T
	 idRiFkPTDrjRT6eCP1wbkZ1/nD6FwfsruG8MDVWELEGhWsukTpYG5GJG+1rmxI7f3OIzn
	 j6EfxCDpSYlcmpZOsHwS6/7Ezu+K+iEOAwH430LcbGdfmix8+jb4nJGNqNWpu64S9M3la
	 8sfZRw+JNYm3+aH1iTGURwaEmWx5SJpEaWjz6/2uPwwoJ2UC6B9xiGFTcOYPwMxdmhNnv
	 eXYc5y0ykRrhvEd8m7a15R63wnxjEZTlR9dtogmlbv3O4U85GzXU7a7m5SF+m2yAO9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793637053;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=vszagCFvroPFMLIl+2ABLgqy3VgoUCB3AvNbWtA9TAY=;
	b=2fLERDUH3XMxMjWk89gM11KYk0KGBS0hXSHKSGBFggUTEVJ22F8bNZAyF4WbG1WsEfG+
	 ESSLyrgWYmuGZVovlvobW0XZgAd/wHr02HVXLohLHuGVloNwFkkxKhcpzHtuMUqikHhHM
	 zCaqzPlKRPppSOx8sScV/ORVLhEKpCVJp5sFgCgt0Relfs2G4UJvgm1c+pz/zOB1PzCPn
	 S+ErPU/zC9bnOrWtRRuvzM8kTr7yQlAUuONEDHcBMQLMbfqmPWlHirEuph/xhHBUqbFXX
	 90e7L15EgaAOSXnbGpCxqg5HWpuA8vHRo4uNWgfPs3Y3KTvwJ24w3kGtRW36pfhnRAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bVhYLBVG;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40C9C6072C5C;
	Mon,  2 Nov 2026 16:30:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40C9C6072C5C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bVhYLBVG
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E1301691;
	Mon,  2 Nov 2026 08:30:48 -0800 (PST)
Received: from [10.0.136.93] (M0PRX50XMG.cambridge.arm.com [10.0.136.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8E703F59E;
	Mon,  2 Nov 2026 08:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793637051; bh=quNqfZHic1kQ6BfsW5fPVu0AftbAMEX7Da64qYRILgE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bVhYLBVG58rqaq20trU4hYORM2raA+rWn/gXGxP4vMQ4+RFns0mxgSyx73if7Plku
	 VqKCXYWUm8knoc+F9diCjUBVoCTn60pyLG8ekitOwRXdVtuldZuWnwOyf9D3Ph11WM
	 UD7Emjevs2t0Hl012KDi4OU5/l7QayTDD1osQ/O8=
Message-ID: <8d3e0dec-0458-40d6-b966-6be220c41caf@arm.com>
Date: Mon, 2 Nov 2026 16:30:49 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/16] KVM: arm64: vgic: Split out common LPI allocation
To: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-2-sascha.bischoff@arm.com>
 <sashiko-outbox-174615@kernel.org>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <sashiko-outbox-174615@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/10/2026 17:14, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] kvm: data race on irq->group due to unlocked assignment after publication
> --
> 
> commit 0cabb3a5e012e80ff468a8654506c83304b15486
> Author: Sascha Bischoff <sascha.bischoff@arm.com>
> 
> KVM: arm64: vgic: Split out common LPI allocation
> 
> The GICv3 ITS code currently owns vgic_add_lpi(), even though the
> first half of the helper is not ITS specific. It allocates or finds
> the VM-wide vgic_irq object in lpi_xa and initializes the common LPI
> state before the GICv3 ITS code reads the property table and pending
> state.
> 
>> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
>> index e5657cb603567..8e7bee1bae95d 100644
>> --- a/arch/arm64/kvm/vgic/vgic-its.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its.c
>> @@ -66,77 +66,22 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
> [ ... ]
>> -	irq = kzalloc_obj(struct vgic_irq, GFP_KERNEL_ACCOUNT);
>> -	if (!irq)
>> -		return ERR_PTR(-ENOMEM);
> [ ... ]
>> +	irq = vgic_add_lpi(kvm, intid, vcpu);
>> +	if (IS_ERR(irq))
>> +		return irq;
>>   
>> -	irq->config = VGIC_CONFIG_EDGE;
>> -	refcount_set(&irq->refcount, 1);
>> -	irq->intid = intid;
>> -	irq->target_vcpu = vcpu;
>>   	irq->group = 1;
> 
> [Severity: High]
> Does this code introduce a data race on irq->group in vgic_its_add_lpi()?
> 
> Since vgic_add_lpi() now publishes the object to the globally visible
> lpi_xa xarray and drops the locks, a concurrent thread (e.g., another vCPU
> writing to GICR_INVLPIR or mapping the same LPI on another ITS) can
> retrieve the LPI and access irq->group under irq_lock before we set it here.
> 
> This can misroute or drop the LPI if it is evaluated by vgic_irq_cmp()
> as Group 0 instead of Group 1. Should we set the group before publishing,
> or hold irq->irq_lock when assigning it?

In the posted patch, vgic_add_lpi() publishes the new LPI before the 
GICv3 ITS sets its group to 1, so another vCPU can observe Group 0. I've 
moved the Group 1 initialisation into vgic_add_lpi(), before 
publication, and removed the later assignment. This does, however, leave 
the group as 1 in the GICv5 case too (although it is meaningless in that 
context).

> 
>> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
>> index c2726d4c06e6e..bc0171c479a95 100644
>> --- a/arch/arm64/kvm/vgic/vgic.c
>> +++ b/arch/arm64/kvm/vgic/vgic.c
>> @@ -79,6 +79,78 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
> [ ... ]
>> +/*
>> + * Creates a new (reference to a) struct vgic_irq for a given LPI.
>> + * If this LPI already exists, we increase its refcount and return it.
>> + * If this is a "new" LPI, we allocate and initialize a new struct vgic_irq.
>> + * This function returns a pointer to the _unlocked_ structure.
>> + */
>> +struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
>> +			      struct kvm_vcpu *vcpu)
>> +{
> [ ... ]
>> +		/*
>> +		 * The entry is either empty or contains a dead LPI (refcount=0)
>> +		 * from the deferred release path, pending cleanup by
>> +		 * vgic_release_deleted_lpis(). Evict and free it if present.
>> +		 */
>> +		oldirq = __xa_store(&dist->lpi_xa, intid, irq,
>> +				    GFP_NOWAIT | __GFP_ACCOUNT);
> 
> [Severity: High]
> Is it safe to publish the new LPI here while its group field is still
> uninitialized (0)?
> 
> As mentioned above, doing this in vgic_add_lpi() makes the LPI accessible to
> concurrent lookups in vgic_get_irq() before vgic_its_add_lpi() has finished
> setting up the group field.
> 

See my comment above.

Thanks,
Sascha

