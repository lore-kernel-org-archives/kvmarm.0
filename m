Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431E0372071
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 09:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783070224; cv=none; b=eY4J/sXRP5pJU9mG+90rO0p8CEf9ur357d7OLpCuIClwY3rZ+LtiGfpv5xyFUlxba8s9i22BH5UXMUjrSQxlYGKZ/e8d+FHbwzzRz+V9JK0/CBvlxrmI3q0LIxPnl+/X2JyfmeR5d5ltN0NsmRoTnwyAqdsWDRhvLbuSWIJ7vRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783070224; c=relaxed/simple;
	bh=SLFXPrxiJfg7tJC8G18GrqveLjUgN4td18VXYbFjpgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aGJoHT1g2KXYLxHk4cCPdf6lpE1dhRMgC99WUhyQXYigOjDj+tWN3bP7JseXQi+UoH/H8W9gNyNzAYITk/FYrMbKpV60945EO0RenWiBPmfG7Flz3S5a2J24n/fnHKtjSlV4ArGY5R7RkB451G/ouHzqe2dzRmaW1499of/CryU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mlKpMPbi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AGudZeBw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mlKpMPbi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AGudZeBw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mlKpMPbi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AGudZeBw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mlKpMPbi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AGudZeBw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2307F747EE;
	Fri,  3 Jul 2026 09:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783070216; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mAezMl69/jk21RdHCEfjclRydgwu4wxQMhbKzS+ud3A=;
	b=mlKpMPbiM0yXciTDxxmTTFw1H66a4/mmg/fDFs0MjSVG3Y/trtaiU3JZXYoL/f6VCxsI5e
	09D5hm4a8sQP2CDWPqGhNk0GfmrSDCddI0LtYYTV1m8YTxW1rsD3Sb/OMf50O2yzz+vYNw
	wyojzgfWapFlamJi+517GpdPWjBH6sg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783070216;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mAezMl69/jk21RdHCEfjclRydgwu4wxQMhbKzS+ud3A=;
	b=AGudZeBwK8mHf7ExjrttfUYKL7R+b0/aVig5fa9yU6554kj7I2qAOi7QPAr55K6tMz9uu4
	Gzc8mtFksHOyzpBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783070216; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mAezMl69/jk21RdHCEfjclRydgwu4wxQMhbKzS+ud3A=;
	b=mlKpMPbiM0yXciTDxxmTTFw1H66a4/mmg/fDFs0MjSVG3Y/trtaiU3JZXYoL/f6VCxsI5e
	09D5hm4a8sQP2CDWPqGhNk0GfmrSDCddI0LtYYTV1m8YTxW1rsD3Sb/OMf50O2yzz+vYNw
	wyojzgfWapFlamJi+517GpdPWjBH6sg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783070216;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mAezMl69/jk21RdHCEfjclRydgwu4wxQMhbKzS+ud3A=;
	b=AGudZeBwK8mHf7ExjrttfUYKL7R+b0/aVig5fa9yU6554kj7I2qAOi7QPAr55K6tMz9uu4
	Gzc8mtFksHOyzpBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 83AE9779AA;
	Fri,  3 Jul 2026 09:16:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Bz2BHAd+R2qwZQAAD6G6ig
	(envelope-from <clopez@suse.de>); Fri, 03 Jul 2026 09:16:55 +0000
Message-ID: <3ee3840a-d14c-48b9-9e0e-829f0fab530d@suse.de>
Date: Fri, 3 Jul 2026 11:16:50 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: arm64: vgic: Fix race between LPI release and
 re-registration
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)"
 <linux-arm-kernel@lists.infradead.org>
References: <20260703021508.2593100-2-clopez@suse.de>
 <akd2bIjF34e3m6TQ@kernel.org>
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
Content-Language: en-US
In-Reply-To: <akd2bIjF34e3m6TQ@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 
X-Spam-Score: -4.30

Hi,

I was about to reply to Sashiko, I'd rather talk to a human :)

On 7/3/26 10:44 AM, Oliver Upton wrote:
> Hi Carlos,
> 
> Thanks for reporting this ugly bug.
> 
> On Fri, Jul 03, 2026 at 04:15:08AM +0200, Carlos López wrote:
>> To fix the direct release path, move the reference count drop inside
>> the xarray lock, making sure that vgic_add_lpi() never encounters the
>> to-be-released LPI.
> 
> As Sashiko pointed out, this is going to massively regress performance
> of LPI injection. I don't think this is going to be a viable option.

I think we can just use refcount_dec_and_lock_irqsave(), no? Then we
grab the lock only if the refcount drops to 0.

As for the other issue (spurious -ENOMEM on __xa_store()), it's a
preexisting issue, but should be fixed by just passing GFP_NOWAIT to
__xa_store(). I can add another patch in v3 for this.

>> To fix the deferred release path, since the refcount drop must happen
>> under a raw spinlock, the same solution does not work. Instead, update
>> vgic_add_lpi(), so that if it evicts a non-NULL refcount=0 LPI from the
>> xarray, it takes on the responsibility of releasing it. If this happens,
>> vgic_release_deleted_lpis() will iterate the xarray normally and will
>> simply not find the already released structure.
>>
>> Reported-by: Claude:claude-opus-4-6
>> Fixes: 3a08a6ca7c37 ("KVM: arm64: vgic-v3: Use bare refcount for VGIC LPIs")
>> Fixes: d54594accf73 ("KVM: arm64: vgic-v3: Erase LPIs from xarray outside of raw spinlocks")
>> Signed-off-by: Carlos López <clopez@suse.de>
>> ---
>> v2:
>> * Address Sashiko's review. Fix the direct release path by decrementing the
>>   refcount under the xarray spinlock, preventing a UAF that would have been
>>   introduced in v1.
> 
> So I actually agree with your approach in v1, vgic_release_lpi_locked()
> should do an __xa_cmpxchg() to only erase if the to-be-deleted IRQ that
> it owns remains in the xarray.
> 
> I believe the UAF could've been avoided by unconditionally calling
> kfree_rcu() in vgic_release_lpi_locked() and not attempting to cleanup
> dead LPIs in vgic_add_lpi(). IOW, whoever takes the refcount of an LPI
> to 0 always has the responsibility of freeing it.


I think this would solve the direct release path, but not the deferred
path. If vgic_add_lpi() does not perform any cleanup, and encounters an
IRQ that was vgic_put_irq_norelease()-ed before
vgic_release_deleted_lpis() grabs the xarray lock then the struct is
overwritten without being released.

> Maybe below would be enough?
> 
> Thanks,
> Oliver
> 
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 5a4768d8cd4f..4c79e1096af4 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -132,7 +132,14 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid)
>  static void vgic_release_lpi_locked(struct vgic_dist *dist, struct vgic_irq *irq)
>  {
>  	lockdep_assert_held(&dist->lpi_xa.xa_lock);
> -	__xa_erase(&dist->lpi_xa, irq->intid);
> +
> +	/*
> +	 * Another LPI could've been inserted prior to taking the xa_lock, as
> +	 * vgic_add_lpi() can only take a reference on a pre-existing LPI if
> +	 * the refcount is nonzero. While freeing the object is always done here,
> +	 * only delete the entry @INTID if it is this IRQ.
> +	 */
> +	__xa_cmpxchg(&dist->lpi_xa, irq->intid, irq, NULL, 0);
>  	kfree_rcu(irq, rcu);
>  }
>  

