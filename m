Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A1C13C918
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 01:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783043393; cv=none; b=kgNTdgHVgkp9AvwPtypP4k++F9ju0ZEIsCtmaz1skoKQZ8eYNO7fE8RHTqY3BrGbdl2GPabiQbSV+L4OKMMlECEHz3lqQ5CBh7SZ5qQCUVKlC1/H7uRhvhYqDwxuAJqNsbb9z28EoLyoeVWrmz85fcvRJXiNRZLH8P9xYyh2y+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783043393; c=relaxed/simple;
	bh=RE+T9HoQIYW8PnX3RcVEgcqDNIvIKR1tDFci2EvzQuE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=syN09GpA/QJkuS364Yt8KFC9IJ9HRHkPcgHRJmcN+nTXlhzOFD6v+kKz0TlM3Xp+Yh29Nl8d/M24yHORSohVaU3XHSnpqUDtm1zvqT0obFf+AyGjIJ8Xox4RblklIhYwwAU8gyz4CN1g8Cob73BwOh2rMy5iLuwxAu3AX097bLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UFIPvQjz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IoErIr/o; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UFIPvQjz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IoErIr/o; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UFIPvQjz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IoErIr/o";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UFIPvQjz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IoErIr/o"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 995F17463C;
	Fri,  3 Jul 2026 01:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783043390; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8BUpttSYCshsKzovsvxRl3O8rpu+osik0JDB5cOl/Ts=;
	b=UFIPvQjz02a07wYcGMxKdK5QS/oo+tY4n2zQYQ0y391gfeZ1aKg/teBGKCRDwgDZBEuq51
	ebW6N0e0hczw7etE6CMo6aYnJxUhEc3RTpjP8NpklvPeWdYpAyDsu1US7iGrC6dGeKYUqy
	I/MLJ77yfNA4NqP2AW+Tc1yhabEQKuI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783043390;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8BUpttSYCshsKzovsvxRl3O8rpu+osik0JDB5cOl/Ts=;
	b=IoErIr/o38uowhO7C20+QR22hfLrvunVnUCzCylu4LOt5O4QJr9kwHaGFsKvtauqIUQmZb
	+QgboIOE6j1/u2BA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UFIPvQjz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="IoErIr/o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783043390; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8BUpttSYCshsKzovsvxRl3O8rpu+osik0JDB5cOl/Ts=;
	b=UFIPvQjz02a07wYcGMxKdK5QS/oo+tY4n2zQYQ0y391gfeZ1aKg/teBGKCRDwgDZBEuq51
	ebW6N0e0hczw7etE6CMo6aYnJxUhEc3RTpjP8NpklvPeWdYpAyDsu1US7iGrC6dGeKYUqy
	I/MLJ77yfNA4NqP2AW+Tc1yhabEQKuI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783043390;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8BUpttSYCshsKzovsvxRl3O8rpu+osik0JDB5cOl/Ts=;
	b=IoErIr/o38uowhO7C20+QR22hfLrvunVnUCzCylu4LOt5O4QJr9kwHaGFsKvtauqIUQmZb
	+QgboIOE6j1/u2BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D1D4779AA;
	Fri,  3 Jul 2026 01:49:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id S1ViDz4VR2pMQQAAD6G6ig
	(envelope-from <clopez@suse.de>); Fri, 03 Jul 2026 01:49:50 +0000
Message-ID: <bd6897ba-0dab-4093-87bc-128d2e786310@suse.de>
Date: Fri, 3 Jul 2026 03:49:49 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: vgic: Fix race between LPI release and
 re-registration
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Oliver Upton <oupton@kernel.org>
References: <20260702233514.2581921-1-clopez@suse.de>
 <20260702235224.EB21C1F000E9@smtp.kernel.org>
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
Content-Language: en-US
In-Reply-To: <20260702235224.EB21C1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 995F17463C
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On 7/3/26 1:52 AM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> New issues:
> - [Critical] The patch introduces a Use-After-Free (UAF) and ABA vulnerability by allowing `vgic_add_lpi()` to free an LPI via `kfree_rcu()` while a concurrent `vgic_put_irq()` could still be processing the same LPI's release without RCU protection.
> 
> Pre-existing issues:
> - [High] `vgic_add_lpi()` can spuriously fail with `-ENOMEM` when racing with an LPI release due to a lost XArray node reservation.
> --
> 
> commit 3cbf900c0e9154b2814ac964d591008312ad60be
> Author: Carlos López <clopez@suse.de>
> 
> KVM: arm64: vgic: Fix race between LPI release and re-registration
> 
> Fix a potential race between decrementing an LPI's reference count and
> evicting that structure from the LPI xarray.
> 
>> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
>> --- a/arch/arm64/kvm/vgic/vgic-its.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its.c
>> @@ -116,7 +116,15 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
>>  		kfree(irq);
>>  		irq = oldirq;
>>  	} else {
>> -		ret = xa_err(__xa_store(&dist->lpi_xa, intid, irq, 0));
>> +		/*
>> +		 * The entry is either empty or contains an IRQ whose refcount is 0
>> +		 * but has not yet been freed by vgic_release_lpi_locked(). Evict the
>> +		 * IRQ and free it, if there is one.
>> +		 */
>> +		oldirq = __xa_store(&dist->lpi_xa, intid, irq, 0);
> 
> [Severity: High]
> This is a pre-existing issue, but can this __xa_store() fail with -ENOMEM
> when racing with an LPI release?
> 
> Looking earlier in vgic_add_lpi(), xa_reserve_irq() allocates an XArray
> node, but the lock is released immediately after. If a concurrent
> vgic_release_lpi_locked() replaces the entry with NULL (or erases it before
> this patch), the underlying XArray node might be freed.
> 
> When this thread resumes and calls __xa_store() here with gfp=0, could it
> fail due to the missing node and cause the guest ITS command to be dropped?
> 
>> +		ret = xa_err(oldirq);
>> +		if (!ret && oldirq)
>> +			kfree_rcu(oldirq, rcu);
>>  	}
>>  
>>  	xa_unlock_irqrestore(&dist->lpi_xa, flags);
> 
> [ ... ]
> 
>> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
>> --- a/arch/arm64/kvm/vgic/vgic.c
>> +++ b/arch/arm64/kvm/vgic/vgic.c
>> @@ -131,9 +131,19 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid)
>>  
>>  static void vgic_release_lpi_locked(struct vgic_dist *dist, struct vgic_irq *irq)
>>  {
>> +	struct vgic_irq *old;
>>  
>>  	lockdep_assert_held(&dist->lpi_xa.xa_lock);
>> -	__xa_erase(&dist->lpi_xa, irq->intid);
>> -	kfree_rcu(irq, rcu);
>> +
>> +	/*
>> +	 * Free the IRQ if it is still present in the xarray, as its entry could have
>> +	 * been overwritten after the refcount was dropped, but before the xarray lock
>> +	 * was acquired. If the cmpxchg fails, vgic_add_lpi() grabbed the lock first
>> +	 * and freed the old IRQ along the way.
>> +	 */
>> +	old = __xa_cmpxchg(&dist->lpi_xa, irq->intid, irq, NULL, 0);
> 
> [Severity: Critical]
> Does this introduce a use-after-free and ABA issue if the RCU grace period
> completes before this thread acquires the xarray lock?
> 
> When vgic_put_irq() drops the refcount to 0, the thread does not hold an RCU
> read lock while waiting to acquire the xarray lock. A concurrent
> vgic_add_lpi() could replace the old LPI and call kfree_rcu(oldirq, rcu).
> 
> Because the releasing thread isn't in an RCU critical section, the grace
> period can elapse. The memory backing this irq can then be freed and
> reallocated to a new LPI with the same intid.

kzalloc_obj() is called before kfree_rcu() in the winning CPU (running
vgic_add_lpi()), so the allocator cannot return back the same pointer
for the ABA issue to happen. This would need another DISCARD + MAPTI
cycle in parallel it to happen, which I guess is not impossible.

> When this thread eventually resumes and calls __xa_cmpxchg(), wouldn't it
> dereference the freed irq pointer to read irq->intid, and then incorrectly
> match the reallocated LPI, causing a double-free?

Ugh, yes. On the vgic_put_irq() path the reference count needs to be
decremented under the xarray lock, that way there is no window where the
irq is in the xarray with refcount=0, so vgic_add_lpi() cannot free it
while we still hold the pointer to it.

For the deferred path I think it's okay though. Once
vgic_release_deleted_lpis() grabs the xarray lock, if the entry was
evicted by vgic_add_lpi() we will simply not find it via xa_for_each().

>> +	if (old == irq)
>> +		kfree_rcu(irq, rcu);
>>  }
> 

