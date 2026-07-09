Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6468242B316
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 15:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783612378; cv=none; b=PE//4mPZEizTNAhz6pjompYto1FZx7VOatyRA68U+BEB0EHeqV6EzroHCq3r98lNOqzkeWst/TWFuA4ilkdXYhGeBajbjVPxkUul6EHInHfIgAQMefMmvA7EABWxN3LKASA0kHZDFTwYWwZqIHzNDV8X14wx5mQsGs+Of2IGuTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783612378; c=relaxed/simple;
	bh=cKu4Ytkydn/JjdPFoHEBLzPZcvnA4Bk40RS/TjINZFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fFqWTSO9CAgFEKCJB9CVph6eGL2Xw0WlTE59J3yX6GpvirY4/JVwgCNSIexnkAZyOO0oEqwVsW/AcpAycMJQaF1P/g3rpVB44JV7NnEcRTXLH0O7ttglV+PlaiFLVXSz6UNYauk45LEnUU+/GiDZOrnramsjPZ6dia7efWkbOL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FH+342Jb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Y70LFOlS; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FH+342Jb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Y70LFOlS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FH+342Jb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Y70LFOlS";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FH+342Jb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Y70LFOlS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8B9A37629E;
	Thu,  9 Jul 2026 15:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783612374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8JEYJt05zpQhkVlZAL3o9x7vxcg0QOPkmR8Ew+/Mpjo=;
	b=FH+342Jbo9MDJbU/9fXNHcfSmWIAo0csN1G2/5B2UOU+CIu1ASw0qNKW6UKUPIeRQTPGLZ
	rw0/hKCprmWs9lxKiUPgmxLKClX4GvWOsvaA1xogrinU0/2crR7Wbo+0cVkYHAUpF2DfW+
	FGktTFiyuUbjdb26xQj8DggbUMxDkHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783612374;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8JEYJt05zpQhkVlZAL3o9x7vxcg0QOPkmR8Ew+/Mpjo=;
	b=Y70LFOlSTtdzjd7P5BwPzEHq15Y9i4oyJwsqKvKTJPtizyLnogWjU9MkPlGAe86F+B1tBH
	lcJbTLrmA01AiiAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783612374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8JEYJt05zpQhkVlZAL3o9x7vxcg0QOPkmR8Ew+/Mpjo=;
	b=FH+342Jbo9MDJbU/9fXNHcfSmWIAo0csN1G2/5B2UOU+CIu1ASw0qNKW6UKUPIeRQTPGLZ
	rw0/hKCprmWs9lxKiUPgmxLKClX4GvWOsvaA1xogrinU0/2crR7Wbo+0cVkYHAUpF2DfW+
	FGktTFiyuUbjdb26xQj8DggbUMxDkHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783612374;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8JEYJt05zpQhkVlZAL3o9x7vxcg0QOPkmR8Ew+/Mpjo=;
	b=Y70LFOlSTtdzjd7P5BwPzEHq15Y9i4oyJwsqKvKTJPtizyLnogWjU9MkPlGAe86F+B1tBH
	lcJbTLrmA01AiiAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5BC84779AA;
	Thu,  9 Jul 2026 15:52:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6kYrEdTDT2onPQAAD6G6ig
	(envelope-from <clopez@suse.de>); Thu, 09 Jul 2026 15:52:52 +0000
Message-ID: <bdcfcedd-4914-4fab-bede-a16357e2a7b3@suse.de>
Date: Thu, 9 Jul 2026 17:52:31 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] KVM: arm64: vgic: Mitigate potential LPI
 registration failure
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
 Marc Zyngier <maz@kernel.org>
References: <20260709144225.3433646-2-clopez@suse.de>
 <20260709144225.3433646-4-clopez@suse.de>
 <20260709150934.626561F000E9@smtp.kernel.org>
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
Content-Language: en-US
In-Reply-To: <20260709150934.626561F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.992];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 
X-Spam-Score: -4.30

On 7/9/26 5:09 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] The error path in `vgic_add_lpi()` calls `xa_release()`, which acquires the `lpi_xa` lock without disabling interrupts, leading to a potential deadlock.
> --
> 
> --- Patch [2]: [PATCH v5 2/2] KVM: arm64: vgic: Mitigate potential LPI registration failure ---
> commit c5f231166837f986fca0d6f0a35dc7e8c46a61d1
> Author: Carlos López <clopez@suse.de>
> Subject: KVM: arm64: vgic: Mitigate potential LPI registration failure
> 
> This commit mitigates a potential allocation failure when inserting a new LPI 
> into the VGIC LPI xarray. It updates vgic_add_lpi() to pass GFP_NOWAIT and 
> __GFP_ACCOUNT to __xa_store(), allowing allocation to occur under the lock if 
> the reserved entry was removed concurrently.
> 
>> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
>> --- a/arch/arm64/kvm/vgic/vgic-its.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its.c
>> @@ -124,7 +124,8 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
>>  		 * holds before freeing it, as otherwise someone else could still
>>  		 * hold a pointer to the evicted struct.
>>  		 */
>> -		oldirq = __xa_store(&dist->lpi_xa, intid, irq, 0);
>> +		oldirq = __xa_store(&dist->lpi_xa, intid, irq,
>> +				    GFP_NOWAIT | __GFP_ACCOUNT);
>>  		ret = xa_err(oldirq);
>>  		if (!ret && oldirq &&
>>  		    !WARN_ON_ONCE(refcount_read(&oldirq->refcount) ||
>>  				  !oldirq->pending_release))
>>  			kfree_rcu(oldirq, rcu);
>>  	}
>>  
>>  	xa_unlock_irqrestore(&dist->lpi_xa, flags);
>>  
>>  	if (ret) {
>>  		xa_release(&dist->lpi_xa, intid);
> 
> [Severity: High]
> This is a pre-existing issue, but does calling xa_release() here introduce a
> potential lock inversion deadlock with hardirqs?

I clearly did not read Oliver's diff carefully enough, this does not
happen with those changes.

> The xa_release() function internally uses xa_cmpxchg(), which acquires the 
> lpi_xa.xa_lock using spin_lock() without disabling local interrupts.
> 
> If a hardware interrupt fires on this CPU while the lock is held (for example,
> an eventfd signal triggering irqfd_wakeup() in hardirq context for fast-path 
> MSIs), it can inject an LPI and eventually call vgic_put_irq().
> 
> Because vgic_put_irq() acquires lpi_xa.xa_lock using spin_lock_irqsave(), the 
> interrupt handler would spin forever waiting for the lock held by the preempted
> vgic_add_lpi() thread.
> 
> Since this patch makes it more likely for the error path to be hit (if the 
> GFP_NOWAIT allocation fails), should this path be updated to manually erase 
> the entry while holding the xarray lock with interrupts disabled?
> 
>>  		kfree(irq);
>>  
>>  		return ERR_PTR(ret);
> 

