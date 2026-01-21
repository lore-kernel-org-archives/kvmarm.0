Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540DE354AD6
	for <kvmarm@lists.linux.dev>; Wed, 21 Jan 2026 18:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019239; cv=none; b=uuW/Id145ZI5FR9Yirtl+7zXRolUg9aPOx8PtErWiZuZlpxDE46yl8LvwQT5od2aPKjcBZHqok+6SHDMjYfNgNLbLetvtBBP4mnRRdcDqqhoTRXZcOo4ZPsWfv9uJuJ8uA8a1A3hcxjg4HvV7EptyZSTMC3OkPzOIUCyoViYDqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019239; c=relaxed/simple;
	bh=C28c/EW5CuQsoDdUsx8dGqG9K8fs0K81D2a2muNH+l8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=isAHXuWZRslDlFvSXJm1R3qsPt3O8e0dozJu/9FfWQwAfWtoLzDcTk5PtFtqo5HcmyD7OE4HQQyhtOl1Vsws3iB1XSCIZ2IrcRa2U3lklDTD9bgggKkpEUuE8MSQvYfvYWeMA3hjMy7ldcIdCvCMm8FRifjTw4/CFhYUYbBgfyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AB1YxHni; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AB1YxHni"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769019236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ynpg/cJ+vd3nqyV8BLe/SIqtaIrKy7cylnYrcUttxQg=;
	b=AB1YxHnihS+6P3zQQaO2zOtQY+jgEbeFhGjegrf6fvMtcEzfinB8fgXPzoTw+zAOWqIHtS
	K9cFs7Xrr1SWAUKMNK0xWQx1LVRUG/KCdd+QU7Gvtq8edYaRojrVjr428QyIwyPp0jIlw5
	BnmLfh64LsK9NAcFQaSf95/EBTl3rX0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-3GQbxqpyPcGWCFgZXDH-Jw-1; Wed, 21 Jan 2026 13:13:52 -0500
X-MC-Unique: 3GQbxqpyPcGWCFgZXDH-Jw-1
X-Mimecast-MFC-AGG-ID: 3GQbxqpyPcGWCFgZXDH-Jw_1769019231
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-434302283dcso84596f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 21 Jan 2026 10:13:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769019231; x=1769624031;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ynpg/cJ+vd3nqyV8BLe/SIqtaIrKy7cylnYrcUttxQg=;
        b=nWXHxh0lfdN7VN4Dd4ASe9/mwlVx1tKHtxRXNnovAIPcnHcl2EFAKI3SSuA3WRu5aO
         mxFRzI0qFBBKUXtqB1lB1FnW1o114wy7nxf5h338uqgewIn7zIXZBPgRdF3guB1sVHkc
         /V07mGbCL7E1PbzX5tEiKwrCfmtVYYyqlSqjA+MH5Gm3uEywz+TUxsVWgi0F9zCRSs5G
         2UgnD4RW9KEwT/ZucEQ2wj3+YLSCv1sGzw0mHQsngFC5MkCacPRCzNPALE7EjWi5Nswm
         GkpJ+Ji+odf8iDW8n3yNSGTzz5orMQ5ZZrVd1LY35zr7tuiXfc2sSHmtVJnbu/7qLDR+
         IujQ==
X-Forwarded-Encrypted: i=1; AJvYcCWebnhMs1qceQfCJOsHzNA7jGPHJTc0/JZqpL/mR1UiJy+MhpaPuHwuJUjhslyMbdTO3MSMsw4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDi0eF+maM9cP75zclSsmLdMQQgInoJ8Qt4Cl4T/pkXOegts+g
	spyyvT1PcnYY6Jw555IfFcOkgorUMjkb1rjvcElcDqp6JY+/E77tK/kAKZbaGAebYcpdH6RzlEX
	MKprg3E2yim+Xltv61a0tauWx6xCy1RPDm4Lz28UGP48nbBUefyQS9Rjsag==
X-Gm-Gg: AZuq6aLLoVmxNjU1UMmp7lL2N/aquRNQ12JyRG9EDidwT9wQIXHfniaoSyr8uJGI67t
	hsjnL+gce2A0iON/ayUFFrwVKdRqv02bhC/hpHAULIR4E0RWJz5dfIj0mjaNiM8O7uPiT1RzLDh
	uws24gSDOSve03WU/hf1sK+K2phQYnq1PICZukr9dm3TmpWra899pZtI6LJgAY8dfLzPeEHPEDW
	3jGVOgObtJACljLzUESrf02twu7DaR7CGjXxpKmJRkOtR2OcUz/daAKStDveDuOvtwBnAcvlk/L
	0EQ+lhp11al7Ey+dcDKp6G1G1GmbAsEjRS9IAS1Szyiq894bQ9aJiohsGVL1YxP+LKS94hO112O
	pZAHAlt2wHhM9f+kDUhD4sV7InZJI0/JyRfBpHItN3Rq/OvGYjObJwWz3OpBNoMfPIZ13EMJ61s
	VeMcKSJHs0pH1gVg==
X-Received: by 2002:a5d:4688:0:b0:435:95c9:6891 with SMTP id ffacd0b85a97d-43595c96bcamr7351150f8f.42.1769019231266;
        Wed, 21 Jan 2026 10:13:51 -0800 (PST)
X-Received: by 2002:a5d:4688:0:b0:435:95c9:6891 with SMTP id ffacd0b85a97d-43595c96bcamr7351114f8f.42.1769019230831;
        Wed, 21 Jan 2026 10:13:50 -0800 (PST)
Received: from [192.168.10.48] ([151.61.26.160])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-43569921da2sm38550536f8f.1.2026.01.21.10.13.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 10:13:49 -0800 (PST)
Message-ID: <5bea843b-dec8-4f15-bb7c-1d0550542034@redhat.com>
Date: Wed, 21 Jan 2026 19:13:43 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: possible deadlock due to irq_set_thread_affinity() calling into
 the scheduler (was Re: [PATCH v3 38/62] KVM: SVM: Take and hold ir_list_lock
 across IRTE updates in IOMMU)
To: Thomas Gleixner <tglx@kernel.org>, Ankit Soni <Ankit.Soni@amd.com>,
 Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joerg Roedel <joro@8bytes.org>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Joao Martins <joao.m.martins@oracle.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>,
 David Matlack <dmatlack@google.com>, Naveen Rao <Naveen.Rao@amd.com>,
 Crystal Wood <crwood@redhat.com>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-40-seanjc@google.com>
 <njhjud3e6wbdftzr3ziyuh5bhyvc5ndt5qvmg7rlvh5isoop2l@f2uxctws2c7d>
 <42513cb3-3c2e-4aa8-b748-23b6656a5096@redhat.com> <874iovu742.ffs@tglx>
 <87pl7jsrdg.ffs@tglx>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87pl7jsrdg.ffs@tglx>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kDdYinHLnOoJgfGFr5RXnpwNkrmP7HjS19NyZsLd5lY_1769019231
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Sorry, not sure how the previous email ended up encrypted.

On 1/8/26 22:53, Thomas Gleixner wrote:
> On Thu, Jan 08 2026 at 22:28, Thomas Gleixner wrote:
>> On Mon, Dec 22 2025 at 15:09, Paolo Bonzini wrote:
>>> Of the three, the most sketchy is (a); notably, __setup_irq() calls
>>> wake_up_process outside desc->lock.  Therefore I'd like so much to treat
>>> it as a kernel/irq/ bug; and the simplest (perhaps too simple...) fix is
>>
>> It's not more sketchy than VIRT assuming that it can do what it wants
>> under rq->lock. 🙂
>
> And just for the record, that's not the only place in the irq core which
> has that lock chain.
>
> irq_set_affinity_locked()       // invoked with desc::lock held
>     if (desc->affinity_notify)
>        schedule_work()           // Ends up taking rq::lock
>
> and that's the case since cd7eab44e994 ("genirq: Add IRQ affinity
> notifiers"), which was added 15 years ago.
>
> Are you still claiming that this is a kernel/irq bug?

Not really, I did say I'd like to treat it as a kernel/irq bug...
but certainly didn't have hopes high enough to "claim" that.
I do think that it's ugly to have locks that are internal,
non-leaf and held around callbacks; but people smarter than
me have thought about it and you can't call it a bug anyway.

For x86/AMD we have a way to fix it, so that part is not a problem.

For the call(*) to irq_set_affinity() in arch/arm64/kvm/'s
vgic_v4_load() I think it can be solved as well.
kvm_make_request(KVM_REQ_RELOAD_GICv4) will delay vgic_v4_load()
to a safe spot, so just cache the previous smp_processor_id() and,
if it is different, do the kvm_make_request() and return instead
of calling irq_set_affinity().

vgic_v3_load() is the only place that calls it from the preempt
notifier, so this behavior can be tied to a "bool delay_set_affinity"
argument to vgic_v4_load() or placed in a different function.

Marc/Oliver, does that sound doable?

Paolo

(*) kvm_sched_in() preempt notifier -> kvm_arch_vcpu_load() ->
     kvm_vgic_load() -> vgic_v3_load() -> vgic_v4_load()

