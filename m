Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9734715B98F
	for <kvmarm@lists.linux.dev>; Wed, 26 Jun 2024 07:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719387237; cv=none; b=Rf/ZQgRE4y8Eqlsl58KmVdt2fsOjb451vfrXxJjMPKsKs4PUhOvX44UyhWtvx2aIwdlE+JfpSRQQGvNWW3X8ZqkUsxYw23hrkjcGOhBGt1y8mS202XYBZ1Fm4TalB652SC7NakQCgzYdfEKHOdxucVUZ/gA03d2XL+Xhy2R8CK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719387237; c=relaxed/simple;
	bh=xLdCdQzBv/TiZ5lJtJptlSu/LpiIqAEcshJlabVSs64=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SrWrcYOEB9I749f0GDpsybbSNOvUi//HrnTFn8srIfQAtJGsRJSGvrZ4cwyyH/5dXFYAwPQGn+DoVthH0GqfSkkJYuScv70ez9bHRN/+eTvcmSNhYI/jSi8psBG+cRTJwDyLggMwAG/65mtjrlNFOKfer8rgVmG9cc5DGEMXlQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V4QazPnP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V4QazPnP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719387234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oIU/f8nuSSgd5Uibiu2hm7EU9SonvvDjpvellDh9LSA=;
	b=V4QazPnPTsymad1Ch++VeupQiSHOeozMyACdTkh3YPPJlONaxA7uaGAJY+DPnSQvpt0oiv
	uv4WC5maBVyJHedRBwVIcilkZHsr6BnoFxxmA4j12u83DsWPJWeKSEHPtCsbUsbcmZaqLz
	+Sj6v/7fpmcTk4OG7VadT4gIrsPoWpA=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-a-WTykgPOJa5JHTA7VTg3A-1; Wed, 26 Jun 2024 03:33:52 -0400
X-MC-Unique: a-WTykgPOJa5JHTA7VTg3A-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2c789d8ffbbso1784593a91.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Jun 2024 00:33:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719387231; x=1719992031;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oIU/f8nuSSgd5Uibiu2hm7EU9SonvvDjpvellDh9LSA=;
        b=NDS1FAMvrZ0gh/g79lMb7l91wtxyA+rWytaWGJVPBon9ZwB2IMzaQ+/GFzHZXzaRk8
         WFLaaU7w/4tjFVBWpv462Okpm+OGJkuwhiRzpyxpsVy57L8Gpz/CSKzWg7NqJM3iETpT
         07BlNyFqLq3CV2wEIQGJ5ZLVcOGsqMS5PQk2oAIpIGRUJO1P/rAqTlMJOcsObNaLUUVY
         jEdishC3C1oXHKbG6Qr+Bw51cUPs+NAMHEJtq5uFr1pLVeJDqPTVh2JX2QblOlsaRXTs
         1+l81VsFNBhJryOSnUch5kwSEkPNbM16oQiqeTK1Woc10rR0E6lAbIOkERXsHQ+ETkll
         92AQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3kOQeNE9bXoePq5Zn5j1dJv8Gb+J/jRreO159dOOrdoazeBv2B52nlyHcXZEeVeO3GipWEYuQv6dBTBjPV9cxRBAgMNrx
X-Gm-Message-State: AOJu0YxMRFFczbjiQahQUYMjSUVByBJKwDjm1hndkPstGe1w17C69PsE
	b4U439hwKmAMYTYRPLlGHk/1qlfmoeb2Ptw/KLIKiAy2864Slw29ALPK6+9xTd5zGDOv413fCaC
	/hIhdaecujntNQRA/vtUVX5aSB2tGHK0+CVIfCp7zIqsyt37f1LrqdQ==
X-Received: by 2002:a05:6a20:3c94:b0:1bd:289f:2ccb with SMTP id adf61e73a8af0-1bd289f63ecmr2588286637.6.1719387230917;
        Wed, 26 Jun 2024 00:33:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHO5xJhZiReur+T6vKl1uy4p88kloJYwrPnEyi/znCBEIkUR6Gm8PlFwhZvceKUizaIo52ITQ==
X-Received: by 2002:a05:6a20:3c94:b0:1bd:289f:2ccb with SMTP id adf61e73a8af0-1bd289f63ecmr2588265637.6.1719387230446;
        Wed, 26 Jun 2024 00:33:50 -0700 (PDT)
Received: from [10.72.116.72] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70696a49ff9sm2854783b3a.164.2024.06.26.00.33.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jun 2024 00:33:50 -0700 (PDT)
Message-ID: <6935be08-f29e-4dd1-9fe7-3d51d3f97509@redhat.com>
Date: Wed, 26 Jun 2024 15:33:43 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: arm64: Allow userspace to change
 ID_AA64PFR1_EL1
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20240618063808.1040085-1-shahuang@redhat.com>
 <20240618063808.1040085-2-shahuang@redhat.com> <86ed8uk8cr.wl-maz@kernel.org>
 <f73cabc6-8c48-4c12-9d60-269e50df41f3@redhat.com>
 <861q4qk9z7.wl-maz@kernel.org>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <861q4qk9z7.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 6/21/24 15:53, Marc Zyngier wrote:
> On Fri, 21 Jun 2024 07:17:57 +0100,
> Shaoqin Huang <shahuang@redhat.com> wrote:
>>
>> Hi Marc,
>>
>> On 6/18/24 15:39, Marc Zyngier wrote:
>>> On Tue, 18 Jun 2024 07:38:06 +0100,
>>> Shaoqin Huang <shahuang@redhat.com> wrote:
>>>>
>>>> Allow userspace to change the guest-visible value of the register with
>>>> some severe limitation:
>>>>
>>>>     - No changes to features not virtualized by KVM (MPAM_frac, RAS_frac)
>>>> ---
>>>>    arch/arm64/kvm/sys_regs.c | 3 ++-
>>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>> index 22b45a15d068..bead81867bce 100644
>>>> --- a/arch/arm64/kvm/sys_regs.c
>>>> +++ b/arch/arm64/kvm/sys_regs.c
>>>> @@ -2306,7 +2306,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>>>>    		   ID_AA64PFR0_EL1_GIC |
>>>>    		   ID_AA64PFR0_EL1_AdvSIMD |
>>>>    		   ID_AA64PFR0_EL1_FP), },
>>>> -	ID_SANITISED(ID_AA64PFR1_EL1),
>>>> +	ID_WRITABLE(ID_AA64PFR1_EL1, ~(ID_AA64PFR1_EL1_RAS_frac |
>>>> +				       ID_AA64PFR1_EL1_MPAM_frac)),
>>>>    	ID_UNALLOCATED(4,2),
>>>>    	ID_UNALLOCATED(4,3),
>>>>    	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
>>>
>>> This isn't a valid patch.
>>>
>>> Furthermore, how about all the other features that may or may not be
>>> currently handled by KVM? Please see [1] and make sure that all
>>> existing fields have a known behaviour (a combination of masked,
>>> preserved, capped, writable or read-only).
>>>
>>> I can at least see problems with MTE_frac and MTEX, plus all the other
>>> things that KVM doesn't know how to save/restore (THE, GCS, NMI...).
>>>
>>> What I asked you to handle the whole register, I really meant it.
>>
>> I currently only found the BT and SSBS fields can be written without
>> any unknown behavior.
> 
> I can only assume you haven't looked hard enough.
> 
>>
>> All other fields in the ID_AA64PFR1_EL1 are either not supported by
>> KVM or the field involved with other register and KVM don't know how
>> to handle them.
> 
> Why can't CSV2_frac be writable? Why can't most of the other fields be
> hidden depending on the VM configuration, as pointed out above?

I looked at the "struct arm64_ftr_bits ftr_id_aa64pfr1[]" in the 
kernel/cpufeature.c, I don't see the CSV2_frac has been supported on ARM 
bare-mental. In this situation, can we first support it in KVM? If so, 
how can we do that, I don't understand that, could you give me some 
hints about that.

Other fields are same with CSV2_frac I think. The KVM don't know the 
configuration about them. Why we should allow them writable and hidden 
them right now? Instead of just make them still unwrittable?

Thanks,
Shaoqin

> 
> 	M.
> 

-- 
Shaoqin

