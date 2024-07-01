Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FE31362
	for <kvmarm@lists.linux.dev>; Mon,  1 Jul 2024 03:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719805022; cv=none; b=sHla3R0MCbhDlBulN3n8hPwU4QKmq3UXp10RTCX9whcjCU4DghIPNwjQJ7UOzPtSXm6MH2dL/f6ae1dZhzFw8hWY9Kp/xJRdbcMjN2pVZPZ8QvhveE0yLLF5pQ8P0nkmqgz8tMQ+cRgwUvjiXnZM7Fw1yUt/kkd6+P4JF058FVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719805022; c=relaxed/simple;
	bh=at1A5+YWeYMOhvVofGCFADul2rvOM7S2sSRxEsoaTj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oUYYDSblOhFjg1ziq7qGMnn1qnVDN0M0MNttmOqasR3OIXODS3WXOhi6kUu4/W1pQtRHi0YVicbZ6quOKuNW2DEsv77ywj5vq8uNA+HybIv5q/LLunGo0JmiHBvWyZmRDZ9Mj5VfbUR/C5FLlw8TtUkHg0zgr4MoZq5qDQK+X4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CN5YpqZh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CN5YpqZh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719805019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E34DB2zEm7Oia8ljvreedRM8LqG+yocNPRRykEpv0Bk=;
	b=CN5YpqZh+PcjkxeJV2dE4SZdh1RNnqtsQSqkIqnjKyUDg65qfjHxVYNTn5pZNHKU7Slrx+
	71U6mhMCoY9iTdYdr5juQ101f3vDFW3A2Ll2jclRFLh1gsYjwlWDSNO+mfYoYd7La8tP+3
	ifIm4H2JMTnno3mdTBA9uvt3hwSxjcM=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-oX8x6xhxPB6vpc4D55y4og-1; Sun, 30 Jun 2024 23:36:58 -0400
X-MC-Unique: oX8x6xhxPB6vpc4D55y4og-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3d5668f8e8fso297406b6e.3
        for <kvmarm@lists.linux.dev>; Sun, 30 Jun 2024 20:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719805017; x=1720409817;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E34DB2zEm7Oia8ljvreedRM8LqG+yocNPRRykEpv0Bk=;
        b=liG4XXXqvNnCoElQmnS+m1o2PZsZUdBXakULa8PXR/Vf062p6zY8SYDjDB/ghh4VGT
         x7btVb1NZOq3YkVKovOGEXzW5dOhFQj6veMM11azfbLj5J6LMWLEGDCcSAwFHQPp7y6o
         iHy+q3dqCumJknN0nhjRciV+snqwcQicS0ucLaHSkwlisVqVYdRiljbwlZ3SX4isrXIu
         06BVWRoGAayFwmCz+xkQ8A84BqVdY4Slf+Rkz8L/1CWNLIvEJ1yP4liF4xzLR1O9wvZK
         ApiEpCrB/OpJfhfTKlqoijlyTy5ZB9+SqOV/3TU1R+xf2T12z+/frGtkyFcTX56ktauC
         lJTA==
X-Forwarded-Encrypted: i=1; AJvYcCVskm/vYtigIP2UF94DlX/VcOUDHNjMBbxONHxgqZSCqaxQbZrHUwbgscI86R3KTpW7ot2xFXiTp8JRsoOTLsHAnyQttFd6
X-Gm-Message-State: AOJu0YwZ/EgPQoeDgshCTUIDH8KS5yded8MlwhR0M+5Udyx5O7HUfI7N
	fZt8ku7hzNCqRkVY1As8eGnlO3zq4f5kTNmpchjNWGEHHueXO2Ivann+9HBAuLWdv6ipdeYBi5W
	J8TVBNoMs1ZQJ679Vm1sKE6WoKK0vCWz+ofMFYeG92VgZn3E9tu14ew==
X-Received: by 2002:a05:6870:2892:b0:255:1fea:340d with SMTP id 586e51a60fabf-25db3049d93mr4612699fac.0.1719805017305;
        Sun, 30 Jun 2024 20:36:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEXOs6rla2ab474nKNYbhR3SIhFvESraI3zUBiRk7IngdPt1fZIAJV8txrf/krz0WIlx0kRCg==
X-Received: by 2002:a05:6870:2892:b0:255:1fea:340d with SMTP id 586e51a60fabf-25db3049d93mr4612688fac.0.1719805016971;
        Sun, 30 Jun 2024 20:36:56 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70803ecfbdesm5375414b3a.105.2024.06.30.20.36.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Jun 2024 20:36:56 -0700 (PDT)
Message-ID: <bb5c3dc1-8100-4d50-843a-3755c873362e@redhat.com>
Date: Mon, 1 Jul 2024 11:36:52 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] KVM: arm64: Allow userspace to change
 ID_AA64PFR1_EL1
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20240628060454.1936886-1-shahuang@redhat.com>
 <20240628060454.1936886-2-shahuang@redhat.com> <87ikxsi0v9.wl-maz@kernel.org>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <87ikxsi0v9.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 6/29/24 16:55, Marc Zyngier wrote:
> On Fri, 28 Jun 2024 07:04:51 +0100,
> Shaoqin Huang <shahuang@redhat.com> wrote:
>>
>> Allow userspace to change the guest-visible value of the register with
>> some severe limitation:
>>
>>    - No changes to features not virtualized by KVM (MPAM_frac, RAS_frac,
>>      SME, RNDP_trap).
>>
>>    - No changes to features (CSV2_frac, NMI, MTE_frac, GCS, THE, MTEX,
>>      DF2, PFAR) which haven't been added into the ftr_id_aa64pfr1[].
>>      Because the struct arm64_ftr_bits definition for each feature in the
>>      ftr_id_aa64pfr1[] is used by arm64_check_features. If they're not
>>      existing in the ftr_id_aa64pfr1[], the for loop won't check the if
>>      the new_val is safe for those features.
>> ---
>>   arch/arm64/kvm/sys_regs.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> This is getting very tiring:
> 
> - this isn't a valid patch, as it doesn't carry a proper SoB. You did
>    it last time, I pointed it out, and you ignored me.
> 
> - this is *wrong*. The moment the kernel publishes any of the fields
>    you have decided to ignore, the restoring of a VM on a new kernel
>    will fail if the host and the VM have different values.
> 

Thanks for giving me the detail about why it's wrong, and thanks to your 
patience to tolerate my mistakes.

This time I understand what you mean and it's a good opportunity for me 
to learn professional knowledge from you.

>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 22b45a15d068..159cded22357 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -2306,7 +2306,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>>   		   ID_AA64PFR0_EL1_GIC |
>>   		   ID_AA64PFR0_EL1_AdvSIMD |
>>   		   ID_AA64PFR0_EL1_FP), },
>> -	ID_SANITISED(ID_AA64PFR1_EL1),
>> +	ID_WRITABLE(ID_AA64PFR1_EL1, ID_AA64PFR1_EL1_MTE |
> 
> Why? If the VM has been created with MTE support, this must be obeyed.

I misunderstood the MTE support in KVM, and thanks your explanation 
below. This is absolutely wrong.

> 
>> +				     ID_AA64PFR1_EL1_SSBS |
>> +				     ID_AA64PFR1_EL1_BT),
>>   	ID_UNALLOCATED(4,2),
>>   	ID_UNALLOCATED(4,3),
>>   	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
> 
> So let me be very blunt:
> 
> - you *must* handle *all* the fields described in that register. There
>    are 15 valid fields there, and I want to see all 15 fields being
>    explicitly dealt with.

Yes, I totally understand that.

> 
> - fields that can be changed without ill effect must be enabled for
>    write, irrespective of what the cpufeature code does (CSV2_frac, for
>    example).

Ok, I remember that.

> 
> - fields that have a fixed value because KVM doesn't handle the
>    corresponding feature must be explicitly disabled in the register
>    accessor (MPAM, RNDR, MTEX, THE...). Just like we do for SME.

Ok, I think this is the point I misunderstood. Thus cause some unhappy 
to you. I want to say sorry to you and I really appreciate your 
expertise and patience to explain this to me.

> 
> - fields that correspond to a feature that is controlled by an
>    internal flag (MTE) must not be writable. Just like we do for PAuth
>    in ID_AA64ISAR1_EL1.

Got that.

> 
> - you *must* handle *all* the fields described in that register.
> 
> Until I see all of the above, I will not take this patch. If you don't
> want to do this, that's absolutely fine by me. Just don't post another
> patch. But if you do, this is the deal.

Thanks a lot you provided so much useful information about the writable 
register. With those standard, I won't post the invalid patch like this.

Thanks,
Shaoqin

> 
> 	M.
> 

-- 
Shaoqin

