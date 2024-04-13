Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF39E1CFA8
	for <kvmarm@lists.linux.dev>; Sat, 13 Apr 2024 13:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713013541; cv=none; b=fVXtLa48it4s/Q03VkvLQ0eeyd08aVasDXgnwpVspddneWSuIU6pgcKimVIR4D1AAMqN0EJwhlJK437hlKPuk8SO8bccJ6m2TL2Y6iLf62TlYlY/njvPwGrDXzes63QrlEDigcAPEQ9L6n8sZPnWQTIDY/V/bGVlUQWNXZU4Yns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713013541; c=relaxed/simple;
	bh=9mQps6gBriAa691971K8dp+F7qu3ElBTZlsuuOPGNuY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=kK+E+BA8507TvA1w3Lc1Y7etvZY83tY7Xt3GSYr9FiKAmv33tLE0mgbevKRz5/ovszS0ErI8ltI0iIEvVflVZfOpQidPKLZ0VoAto7zknw7yB8Hww1xFxtidXKHc1pMFvM6V0rc9Uflt9/rwPLI6s4hUH0m9y7U9RQlETBt764I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E9SUDrHg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E9SUDrHg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713013538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LjC/r8afP2Rq17fs73k7VkcEwW9IeRku59pv+b0GDdk=;
	b=E9SUDrHgjujbIK6V4uLxulC/qGN2i7ZI2x+VISFPUaqzzgaQX0jWr1ZZUbBbT2ygsytljd
	J6Ol9WW5RA8T8FQLlZbjDMUZU0eqthQ8Y1AxXh/Y5vVs6pE59ojvfeezH0QygVjKsnCvQW
	oWGRn3e3SbPxBul9uRz9bimVdqeZtmQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-ggUm5z2sPk20bWqAqm0XKw-1; Sat, 13 Apr 2024 09:05:33 -0400
X-MC-Unique: ggUm5z2sPk20bWqAqm0XKw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4147de378b9so9423335e9.3
        for <kvmarm@lists.linux.dev>; Sat, 13 Apr 2024 06:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713013532; x=1713618332;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LjC/r8afP2Rq17fs73k7VkcEwW9IeRku59pv+b0GDdk=;
        b=pD7rp33rDuqYIVhAcF7q/QKDBtCnFYj5EHrQfOoEdb8zF3CLC6+9AloJOfv2P4DJCI
         I9p/COPdlOw4vjrh335zFRXny0cN2VJFuYLQl8iaBeS222fUgE9QwLP//PpA1oUcgF2g
         3RAaOfmLAIBR2/wHYrx+1RIaZvxDphq0YvUsuNS6xqznm8KNFmLK+aTGQ0fcJ1D8vZ80
         ZSizaYdQKczQW03YnufkJNSX8dQ+fhPrmTd1Ga2FADia0utRv/u5mC95W0VyEzHtv4Kn
         HSFOpmyRxNWV97dp48Sxcm9GEmh6ZYLNjbQf8oh6cwvxgOqVzmbz8Jv9OkilmKIrjqv5
         hp+A==
X-Forwarded-Encrypted: i=1; AJvYcCWkj1lBGZAQUq6ea1l1xtQWGh84h4pvgbZzkotfe4mbzRAqPwGWHSEIK+5PtVCNoOYSZLI6/FSgi7GJ5etLPbax9Z0qE4/I
X-Gm-Message-State: AOJu0YwdyM3aED5YaEe87NPPljIe10OXbg/Cw3aDV7uLhO2i6cpfERHm
	+/EuQaKOfWp4ccAEI88Dp2I1jBJiWYeS7BqQ22Y3joFFa1hZYJbcqM84xpFmE6w8zqejKdiqfSy
	bHIr510VJ+eThGp1l+0mgH0Cuv0CUtodofNyXVdwNBCFP9Dch5cBzvg==
X-Received: by 2002:a05:600c:5818:b0:414:60fe:8f2b with SMTP id jz24-20020a05600c581800b0041460fe8f2bmr4636647wmb.18.1713013532597;
        Sat, 13 Apr 2024 06:05:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMW4dxiTvS7n2eWbssZJ0Xn/PGf10S4HVEPbaYyCkOe5omKF1qw+lfUNoMszIeJDG2JRMtxQ==
X-Received: by 2002:a05:600c:5818:b0:414:60fe:8f2b with SMTP id jz24-20020a05600c581800b0041460fe8f2bmr4636624wmb.18.1713013532067;
        Sat, 13 Apr 2024 06:05:32 -0700 (PDT)
Received: from rh (p200300c93f06ef00707ff2f902cfda41.dip0.t-ipconnect.de. [2003:c9:3f06:ef00:707f:f2f9:2cf:da41])
        by smtp.gmail.com with ESMTPSA id z17-20020a05600c0a1100b00416b8da335esm8914249wmp.48.2024.04.13.06.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Apr 2024 06:05:31 -0700 (PDT)
Date: Sat, 13 Apr 2024 15:05:30 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH 2/4] KVM: arm64: maintain per VM value for CTR_EL0
In-Reply-To: <86frvpshno.wl-maz@kernel.org>
Message-ID: <7e9c8367-6e9e-e36b-934e-170c90522134@redhat.com>
References: <20240405120108.11844-1-sebott@redhat.com> <20240405120108.11844-3-sebott@redhat.com> <86frvpshno.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Sat, 13 Apr 2024, Marc Zyngier wrote:
> On Fri, 05 Apr 2024 13:01:06 +0100,
> Sebastian Ott <sebott@redhat.com> wrote:
>>
>> In preparation for CTR_EL0 emulation maintain a per VM for this
>> register and use it where appropriate.
>>
>> Signed-off-by: Sebastian Ott <sebott@redhat.com>
>> ---
>>  arch/arm64/include/asm/kvm_host.h |  1 +
>>  arch/arm64/kvm/sys_regs.c         | 22 +++++++++++++++-------
>>  2 files changed, 16 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 9e8a496fb284..481216febb46 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -318,6 +318,7 @@ struct kvm_arch {
>>
>>  	/* PMCR_EL0.N value for the guest */
>>  	u8 pmcr_n;
>> +	u64 ctr_el0;
>>
>>  	/* Iterator for idreg debugfs */
>>  	u8	idreg_debugfs_iter;
>
> Please consider the alignment of the fields. This leaves a 7 byte hole
> that could be avoided (yes, I'm on a mission to reduce the size of the
> various structures, because they are absolute pigs).

OK.

>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 131f5b0ca2b9..4d29b1a0842d 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -215,13 +215,21 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
>>  /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
>>  #define CSSELR_MAX 14
>>
>> +static u64 kvm_get_ctr_el0(struct kvm *kvm)
>> +{
>> +	if (kvm->arch.ctr_el0)
>> +		return kvm->arch.ctr_el0;
>
> Is this relying on some bits not being 0?
>
>> +
>> +	return read_sanitised_ftr_reg(SYS_CTR_EL0);
>
> Why isn't the shadow value always populated?

The idea was for kvm->arch.ctr_el0 being non zero only if userspace
set it up to differ from the host value. So it can be used to decide
if we need to set up a trap for the reg access (without comparing it
to the host value again).

Thanks,
Sebastian

