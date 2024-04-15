Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD3B156977
	for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 19:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713210028; cv=none; b=WefdIcrqq5gcQ1pz15x1TjBRw95prRuZb3PlyQII24nQABvg/cFxG2sMdnbXS802B4N/2kMBHNalUCQJpXEgeKS1uQMO48/t1vnVzkmNe7kidPbiEliDtwve5mKwaAKKHqkWxq1BGUkliIFJ1qvUBWJmCr7wyt6g+0qcTR0yYz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713210028; c=relaxed/simple;
	bh=HnQrke53HbieJQg1K+HmxDC5DcgHzycPVXayX92Uel0=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=tWrMiVpENnRDtIGtdE6r9UCA6v5aYKqcjj7DNVVm5Tl9Zb1Xu5WksEbjz4lTDrMxKdq9pApeVnq5dxznnsOxyqIFWCxJKyH5oB9SCSVyw4v7uOrSrz6lyTL7VdSgPnoSSP5QCeK1FDXIELSjijrqjkXwtYjuQfkJEugrUN/6I+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yH2kkseZ; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yH2kkseZ"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-7cc7a6a04d9so453032739f.3
        for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 12:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713210026; x=1713814826; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=taYfEAMhWxZKhDVEpiZhlMgSXjBrsWj8geaLNIGWoBE=;
        b=yH2kkseZONZ7catgmv07Zif4L5dD2MVtKW+O7gsb6df3qQnIBHZJfJKFQ2wB0e7kGa
         bRLoobbC9NHOczpmjXwJ8eR2hgYsl09NqXu4JKH5qFrJalqVtsfJ6MubGTnhP7ClUVay
         7iwXc3L/9R++csjmYQIZcI3NrsuW6m5OhRsBwZBYN9JrA1bg2BlQnoLTfU7X81AowJqV
         w6uA7fSo1mpBxWSzGK+K9PEXg16dmiGBNNKW8VsL96axaUOzLCpfC5xqczNXbUsWdfO9
         RQ4Z/ZHs54pVFutoUb6Fk9txjYb4dyI2kLPMuqtmnKTts+l0wZidIc5dia9NjxwqocUJ
         Zslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713210026; x=1713814826;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=taYfEAMhWxZKhDVEpiZhlMgSXjBrsWj8geaLNIGWoBE=;
        b=WXZm9IBnH8tCY7YX473pqnZWpefKogprZdPIZx6nM7RrVpwWDWUdeCbPoyVHC7btJl
         eHv5g/+Wi8VQ+igKI0IxYU5nPiRj/fCOZgO0XoY45cnX/XcuK72YgRNOnqf2QHB/r5Uk
         jTjB/aAWbPUB1YrUs5LlKm/4nL1j+0Vz+ElWaUr/hGF5Ye/ceC5KD0BmHZoivpAr9WJG
         eNzyK2HPUU4UvHx4Bu8sfZpXfG97gYeoTDuVs7Sq4+SZ1jiO92kZyhiFdHuPP8lNBk9p
         ptF6ofBAcpAtPYiO/H3zdq9fw/dCwgXpraiognpZI4F8Y78QMZAkUhfrJmHhzwKnGkgJ
         TP0g==
X-Forwarded-Encrypted: i=1; AJvYcCUmTJL2ia2ledtKUMzVnWdzsUxaY3xFCktIGty9L4640zRv0kOTZjqHERSakoftwsIuOmMWVTr6adcWqckOg5OEbxcwDi/m
X-Gm-Message-State: AOJu0YyMMeRU6inC9xYAiS3wniyaqbgIIPtjC+9A2jmaClNQJtUXtXRb
	z66o923Kp8mQYHA1H2pFkllG3p4bPncabFJXQq/HET02MbjeQ6cnFaepTliRtqBtXA16HQArW7R
	tEI92XPy1z+j7x86G/SvTPw==
X-Google-Smtp-Source: AGHT+IGUqapQXFj2hPWnTQ4fKWHkr8XUX4Eacrb1Di5Og6Xvq8008PLajdkB1V4vRSdttFUHw7IRCbM2YDH38IdHzw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:34ab:b0:482:fc24:b74c with
 SMTP id t43-20020a05663834ab00b00482fc24b74cmr472110jal.0.1713210026131; Mon,
 15 Apr 2024 12:40:26 -0700 (PDT)
Date: Mon, 15 Apr 2024 19:40:24 +0000
In-Reply-To: <86sezss5cm.wl-maz@kernel.org> (message from Marc Zyngier on Thu,
 11 Apr 2024 08:53:13 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnth6g2qus7.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3] KVM: arm64: Add early_param to control WFx trapping
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Thanks for the review Marc.

Marc Zyngier <maz@kernel.org> writes:

> On Wed, 10 Apr 2024 18:54:37 +0100,
> Colton Lewis <coltonlewis@google.com> wrote:
>> +
>> +enum kvm_interrupt_passthrough {
>> +	KVM_INTERRUPT_PASSTHROUGH_DEFAULT,
>> +	KVM_INTERRUPT_PASSTHROUGH_ALWAYS,
>> +	KVM_INTERRUPT_PASSTHROUGH_NEVER,

> What does this mean? This is not dealing with interrupts, this is
> supposed to deal with the behaviour of specific instructions
> (WFI/WFE). The notion of "passthrough" is really odd as well. Finally,
> both ALWAYS and NEVER are wrong -- the architecture makes no such
> guarantee.

Looking at this, I did let the language get away from me by mixing up
interrupts and the instructions dealing with them.

"Passthrough" is not a technical term but has pervaded some of my
internal conversations about this and I've just been using it to mean
the opposite of trapping. That can be easily swapped.

I understand always and never are not what the architecture guarantees,
but was trying to capture what KVM code is attempting to do. I could
just drop it entirely.

So the enum values could be named something like:

KVM_WFX_TRAP
KVM_WFX_NOTRAP
KVM_WFX_NOTRAP_SINGLE_TASK (default option)

>> -	if (single_task_running())
>> +	if ((kvm_interrupt_passthrough == KVM_INTERRUPT_PASSTHROUGH_ALWAYS
>> +	     && kvm_vgic_global_state.has_gicv4) ||
>> +	    (kvm_interrupt_passthrough == KVM_INTERRUPT_PASSTHROUGH_DEFAULT
>> +	     && single_task_running()))

> Why is this affecting both WFI and WFE? They are very different and
> lumping them together makes little sense.

It's true they are different, but I couldn't think of any cases where
you would want trapping for one to be different than for the other. The
current behavior also assumes trapping should be the same for both.

Are you suggesting separate controls for the two?

>> @@ -2654,6 +2658,30 @@ static int __init early_kvm_mode_cfg(char *arg)
>>   }
>>   early_param("kvm-arm.mode", early_kvm_mode_cfg);

>> +static int __init early_kvm_interrupt_passthrough_cfg(char *arg)
>> +{
>> +	if (!arg)
>> +		return -EINVAL;
>> +
>> +	if (strcmp(arg, "always") == 0) {
>> +		kvm_interrupt_passthrough = KVM_INTERRUPT_PASSTHROUGH_ALWAYS;
>> +		return 0;
>> +	}
>> +
>> +	if (strcmp(arg, "never") == 0) {
>> +		kvm_interrupt_passthrough = KVM_INTERRUPT_PASSTHROUGH_NEVER;
>> +		return 0;
>> +	}
>> +
>> +	if (strcmp(arg, "default") == 0) {
>> +		kvm_interrupt_passthrough = KVM_INTERRUPT_PASSTHROUGH_DEFAULT;
>> +		return 0;
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +early_param("kvm-arm.interrupt-passthrough",  
>> early_kvm_interrupt_passthrough_cfg);
>> +

> Again, this is not dealing with interrupts. This is dealing with the
> *potential* trapping of instructions in certain circumstances.

Understood. Should be something like "kvm-arm.wfx-instruction-trapping".

>>   enum kvm_mode kvm_get_mode(void)
>>   {
>>   	return kvm_mode;

> Finally, this needs to be documented.

Right, in Documentation/admin-guide/kernel-parameters.txt
