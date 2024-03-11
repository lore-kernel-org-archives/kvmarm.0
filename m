Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADB851C5A
	for <kvmarm@lists.linux.dev>; Mon, 11 Mar 2024 17:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710177270; cv=none; b=BXbxYkO2LqOJcEH37C8npFhgHAS4JcqywHqLsDleBq8BvN80GeoQi4uYGqVXxetldv4JzbYL2TlDUhxtWdO8D9j1Uddr/tkWRkoF30ZX1AEoPSos2Szo6/GZvycZBqhYHCyYzR/HB6ywtglfR94+EvK2EXlSQt9sYpm6qzxYjuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710177270; c=relaxed/simple;
	bh=YcXPJcyTFYDeB5IHFg7mdy5MhaqvIkCQDHuIHsmF8A0=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=HFInVygP3THNR5NOgM72/eamsOW20prIUZNwEX+aeZyqWfOJeI3zKfIAI7D2qA8eYR093QHI0Qmznl1MRdjvRXh2ZTBrq8oiSSOfPHu1yR2hyn56xfNNu0QiurIFN0MjNXUo/mpYiOQKZWJawyOQXqDZdX3wlkCC/G5Rqu/Hlbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I3rcFXA3; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I3rcFXA3"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a20c33f07so33195197b3.3
        for <kvmarm@lists.linux.dev>; Mon, 11 Mar 2024 10:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710177268; x=1710782068; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mxI402kfSmdHwvl7iNI+EypEnmQOFeIIPXsLUmkhg9o=;
        b=I3rcFXA3dGG+KjJJ/Iszk9DoACdhz6i/scHA8hf6SU1UAXyxGSsMWgkmh4ZhqX//U1
         NEbKJO0oz1wYQtyocuOZJ5vJYL56JZSvL13BQGikZGTzAli7+2ieLGHSA5CiQ2HSsL2u
         dPGGh6ETkGUeHvdQXjAax/UHrIIwDGo4s0xQ9+QWNlIVAFxRseLcwOD3Lbx7PQaJy06G
         1Kl3qRDBO/rv1AVYBUdU5n4IS20pFDubvRgcVf0AjmtvHcOJtZiGYFF+hY3WjmqsWo3p
         yESoxL2qbkvMd3nv7tjuvlGObJz6IL1rSAOFO2og3TmTjwRI+fgPvKSTIRtH28FC8Wgy
         lhNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710177268; x=1710782068;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mxI402kfSmdHwvl7iNI+EypEnmQOFeIIPXsLUmkhg9o=;
        b=tdkI6Xmd/CxqiGuX/fYNjuDuh0lOrNs7WWGJNaeiufmZZBsso+zqBQNKEK0B78AVTl
         D449tPATrdFp6geQtfsmhlbXTOkU6WQOwtQ3GgfDmwDofhUpKOtBScMe9lurU0pKR1lW
         asLrK+HcWPhmBZ5UkzS/PV4cZP5AIZDO8WS7//tOpI2eiXiSjnQaUTyf2t0JHnVYzWT6
         Uu7ZJZJ2mdcJO2GAWtjbSPS7+9ELp52NWqkN8cqYoRNoylVIFp9qKkh6SZqbNlzD5UWi
         R1buOoAcdjX8X8nDfPFwJb/PgG0Au+s4mx0bAA0gsthpMbUfSCBhpqIiUkfXsyi24BvK
         BYhw==
X-Forwarded-Encrypted: i=1; AJvYcCVzLHVXGOpsyAgyt/R6p0oxttm8ZGkIM4ciTOWJ/8YodsBacAN/WhVGNbyoyxJK5iFkM7zTuysXKep2wi3Ln16Q0QjT6T+V
X-Gm-Message-State: AOJu0YxKyfEFWPAr85UIkwYiugLCJVt6ymk0uyfc9hmKFPcRIlHHiUSL
	pQ5uAiudedtR9O2L+Hp7sf42k0RYQYSfPUCFQR6E9bjqY3CzKAQoXNAhy9u6Bt5ITjByNT5WgVW
	7PFjUDF4jdLkJCspJW6jcKw==
X-Google-Smtp-Source: AGHT+IG2N8cV0iCT1a4n7m3pkLJ3zouBgC9e+45Gm77ZrHMqRbbS1wEXl9E6jo6FuMZO96tK24fy68HfVkAScpo4lw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:4917:0:b0:60a:1201:9e67 with SMTP
 id w23-20020a814917000000b0060a12019e67mr1982263ywa.6.1710177268311; Mon, 11
 Mar 2024 10:14:28 -0700 (PDT)
Date: Mon, 11 Mar 2024 17:14:27 +0000
In-Reply-To: <Ze6PMRMfIK8z0q4F@thinky-boi> (message from Oliver Upton on Sun,
 10 Mar 2024 21:57:21 -0700)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt34swu1vw.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v4 2/3] KVM: arm64: selftests: Guarantee interrupts are handled
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, ricarkol@google.com, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> nitpick: Shortlog should read

>    KVM: selftests: Ensure pending interrupts are handled in arch_timer test

> The fact that we're dealing with pending interrupts is critical here;
> the ISB has no interaction with the GIC in terms of interrupt timing as
> it gets to the PE.

I'll change that.

> On Thu, Mar 07, 2024 at 06:39:06PM +0000, Colton Lewis wrote:
>> Break up the asm instructions poking daifclr and daifset to handle
>> interrupts. R_RBZYL specifies pending interrupts will be handle after
>> context synchronization events such as an ISB.

>> Introduce a function wrapper for the WFI instruction.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   tools/testing/selftests/kvm/aarch64/vgic_irq.c    | 12 ++++++------
>>   tools/testing/selftests/kvm/include/aarch64/gic.h |  3 +++
>>   tools/testing/selftests/kvm/lib/aarch64/gic.c     |  5 +++++
>>   3 files changed, 14 insertions(+), 6 deletions(-)

>> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c  
>> b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
>> index d3bf584d2cc1..85f182704d79 100644
>> --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
>> +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
>> @@ -269,13 +269,13 @@ static void guest_inject(struct test_args *args,
>>   	KVM_INJECT_MULTI(cmd, first_intid, num);

>>   	while (irq_handled < num) {
>> -		asm volatile("wfi\n"
>> -			     "msr daifclr, #2\n"
>> -			     /* handle IRQ */
>> -			     "msr daifset, #2\n"
>> -			     : : : "memory");
>> +		gic_wfi();
>> +		local_irq_enable();
>> +		isb();
>> +		/* handle IRQ */
>> +		local_irq_disable();

> Sorry, this *still* annoys me. Please move the comment above the ISB,
> you're documenting a behavior that is implied by the instruction, not
> anything else.

>>   	}
>> -	asm volatile("msr daifclr, #2" : : : "memory");
>> +	local_irq_enable();

>>   	GUEST_ASSERT_EQ(irq_handled, num);
>>   	for (i = first_intid; i < num + first_intid; i++)
>> diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h  
>> b/tools/testing/selftests/kvm/include/aarch64/gic.h
>> index 9043eaef1076..f474714e4cb2 100644
>> --- a/tools/testing/selftests/kvm/include/aarch64/gic.h
>> +++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
>> @@ -47,4 +47,7 @@ void gic_irq_clear_pending(unsigned int intid);
>>   bool gic_irq_get_pending(unsigned int intid);
>>   void gic_irq_set_config(unsigned int intid, bool is_edge);

>> +/* Execute a Wait For Interrupt instruction. */
>> +void gic_wfi(void);
>> +
>>   #endif /* SELFTEST_KVM_GIC_H */
>> diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic.c  
>> b/tools/testing/selftests/kvm/lib/aarch64/gic.c
>> index 9d15598d4e34..392e3f581ae0 100644
>> --- a/tools/testing/selftests/kvm/lib/aarch64/gic.c
>> +++ b/tools/testing/selftests/kvm/lib/aarch64/gic.c
>> @@ -164,3 +164,8 @@ void gic_irq_set_config(unsigned int intid, bool  
>> is_edge)
>>   	GUEST_ASSERT(gic_common_ops);
>>   	gic_common_ops->gic_irq_set_config(intid, is_edge);
>>   }
>> +
>> +void gic_wfi(void)
>> +{
>> +	asm volatile("wfi");
>> +}

> Ok, I left a comment about this last time...

> WFI instructions are only relevant in the context of a PE, so it would
> be natural to add such a helper to aarch64/processor.h. There are
> definitely implementations out there that do not use a GIC and still
> have WFI instructions.

Apologies if I missed it. I'll remove gic_from the name.
