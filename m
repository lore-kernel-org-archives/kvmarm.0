Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDC5126F3A
	for <kvmarm@lists.linux.dev>; Wed, 14 Feb 2024 18:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707934092; cv=none; b=WutndnAbmg3//1vN88PUFFS+hrCXG6aDN2wCWXwCninRN4Qc7gFhZU8xtqGFm7LuLT9YbGLNRP66ja180451yFUnhqmdUC2Ra+ugEpkO5+bWIWAb32taA4CIAgxw0+SMZPFwp7M1yp7LmcaIO90mIsLo/O5cugxitkilIsHHvOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707934092; c=relaxed/simple;
	bh=Sw6U28WSNWDx3JoUn8Rsu9va35+2BCWUIsT2yCm0FuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T39cZ6ChreQvF7W4hGfcyqA0OfTUj+ycypfhDWeCPHEAW6W1UffbIvaD/RE1JjpZ/QZvf4dhRUdxB115wzAA+EgNICNBtGRgRySjoV1aG/xjD2rkc4GxcVDDMtv0iUdZ5tzPb32zYDvlVE5OvhpheApJsGY1lpGOyygtRAbevGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ghig3vwl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ghig3vwl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707934089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eGS0X6bkbN/xumOM+se4NMMEDJGsND5iyrRmljtxnXU=;
	b=Ghig3vwlPonSNi3NALZlqcOyOJ+PgoId3voU1DlfPkC/3VgAAHXGVggk1X37afNVSI7MU7
	jjxmbK4fHgafYl4SRWL1sBJc7e8/5fK0GAKZgo9KvPgIogxtKOnrOe2kxaZme7x709nj4V
	ihggxZcR2iT0thztDgMD245guV4iPe0=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-QLjE4mrXOyahK_oGyWX6Xg-1; Wed, 14 Feb 2024 13:08:06 -0500
X-MC-Unique: QLjE4mrXOyahK_oGyWX6Xg-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1da2fdd492dso126115ad.0
        for <kvmarm@lists.linux.dev>; Wed, 14 Feb 2024 10:08:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707934085; x=1708538885;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eGS0X6bkbN/xumOM+se4NMMEDJGsND5iyrRmljtxnXU=;
        b=nmTICCXH9us0Li0YLdwnjqcW5knYpzlI5fAS43gjEqV244efv16Xj4ZXovmgk8SCZs
         nvyVd0lHfmJi+xjUMRIIfjRs4dNq5y8tMReFNRdcD4l+1qBBSs74bs4D19WypFKD782C
         q2JmQaifUlo8dffv+i6GD42UUdtgTLnAveJKhfYD/k3CiNnKa2Ex8OrmABCrXm7oI/FU
         LIGvLOmT5pKUk8uShX+VkrAcy1u4qFh9xLQAV+3mKynwhVepHWwR7N8mzz9N8u7gIuo8
         vj6b78733GGehbGLqMCQNyupvyTHqViEEWIJKBnLsAw+OviR+A5vXeg/vlbbSdebm/Ir
         mAZA==
X-Forwarded-Encrypted: i=1; AJvYcCXgtjAtlEEGmfnMIWSdzJDMucCxCpZfcp3V5YtuVRXPYPub06LVBmL2NGKaeIi5cnSGXNvjfm510IfynHzM9cmU93P+CHKb
X-Gm-Message-State: AOJu0Yz1A7tRspHf+Wo7LAwZI8lAHBg0E6o79lBiM4GZCJjYg1w7r3Yf
	ViF6l02dKCCytWGNnWDvSOM5FkRe81s66l/0sZqef6sxIqeI8VHgF5vB7xMRwisrN/3/1isZPXW
	e9lLwP5Ubcp52DBisYDUrPU9xYvrxiLzOqQtiTgYGtEGqitHiYCDBJQ==
X-Received: by 2002:a17:902:ecc5:b0:1d9:2cda:afe5 with SMTP id a5-20020a170902ecc500b001d92cdaafe5mr4162553plh.31.1707934085106;
        Wed, 14 Feb 2024 10:08:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEhaIjV7ZUezESowfQwibNrdQuAOOsZTTHebuhpUvFj0y9RxKwmQiZvg5joub8JBdYU9zL5XA==
X-Received: by 2002:a17:902:ecc5:b0:1d9:2cda:afe5 with SMTP id a5-20020a170902ecc500b001d92cdaafe5mr4162522plh.31.1707934084758;
        Wed, 14 Feb 2024 10:08:04 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUI1gUbuhqWn3+Vvpcw4i2cWuPYSFU2sixi9rnmjJKdIYuqtTB/3x5Gzd6jQNNMSig28HG1PCJ+NFCe2TAcUq5wxpnSVL39yU8+pNMGJfi4G3uoG0cvDIgXMs8Gt/25PPfWFAIZKiRxDiMiWCkCwICnnw4nF6WdK1GGldkYGuPAChVCEz5nD02VaQ493s4D1o5gOeuwfO+whXmqr6PTIEKWKbKwLz5efs2aNQKqK2gRRl6Vp3SJD+G/fpUg6nJBjB3bD/vBEOCqpcEfCUxWhYPCxp9fGYqocc6GuULnoiN/gp/ytZEpDcxS8eJo1ek8uy1WU5a1vVhltlPvjgTyTCDIjpJdCKgR78c8iSHtNvCes3vxyIDzyNTw3ZC8m6R2JxSMtzPFOgpT0F20V0LqR2C9qa+rFtYL4Bn7P3EAMUB526btM3QBWJ3D0dYshVHlQ63Si+UWYcYf+tsymYER9JRCZ+5xSe/70Q==
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id kj5-20020a17090306c500b001db6a4931e7sm713950plb.46.2024.02.14.10.08.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 10:08:04 -0800 (PST)
Message-ID: <25434f0e-d9c9-45dc-82a1-7466bc59a6e2@redhat.com>
Date: Wed, 14 Feb 2024 19:07:58 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/4] KVM: arm64: Document
 KVM_ARM_GET_REG_WRITABLE_MASKS
To: Marc Zyngier <maz@kernel.org>
Cc: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.linux.dev>,
 ARMLinux <linux-arm-kernel@lists.infradead.org>,
 Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>,
 Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck
 <cohuck@redhat.com>, Shaoqin Huang <shahuang@redhat.com>,
 Sebastian Ott <sebott@redhat.com>
References: <20230919175017.538312-1-jingzhangos@google.com>
 <20230919175017.538312-3-jingzhangos@google.com>
 <82b72bd2-c079-40c3-90b8-30174f2a8fe0@redhat.com>
 <86a5o45sb8.wl-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <86a5o45sb8.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 2/13/24 15:53, Marc Zyngier wrote:
> Hey Eric,
> 
> On Tue, 13 Feb 2024 13:59:31 +0000,
> Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi,
>>
>> On 9/19/23 19:50, Jing Zhang wrote:
>>> Add some basic documentation on how to get feature ID register writable
>>> masks from userspace.
>>>
>>> Signed-off-by: Jing Zhang <jingzhangos@google.com>
>>> ---
>>>  Documentation/virt/kvm/api.rst | 42 ++++++++++++++++++++++++++++++++++
>>>  1 file changed, 42 insertions(+)
>>>
>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>> index 21a7578142a1..2defb5e198ce 100644
>>> --- a/Documentation/virt/kvm/api.rst
>>> +++ b/Documentation/virt/kvm/api.rst
>>> @@ -6070,6 +6070,48 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
>>>  interface. No error will be returned, but the resulting offset will not be
>>>  applied.
>>>  
>>> +4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
>>> +-------------------------------------------
>>> +
>>> +:Capability: KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES
>>> +:Architectures: arm64
>>> +:Type: vm ioctl
>>> +:Parameters: struct reg_mask_range (in/out)
>>> +:Returns: 0 on success, < 0 on error
>>> +
>>> +
>>> +::
>>> +
>>> +        #define ARM64_FEATURE_ID_SPACE_SIZE	(3 * 8 * 8)
>>> +        #define ARM64_FEATURE_ID_RANGE_IDREGS	BIT(0)
>>> +
>>> +        struct reg_mask_range {
>>> +                __u64 addr;             /* Pointer to mask array */
>>> +                __u32 range;            /* Requested range */
>>> +                __u32 reserved[13];
>>> +        };
>>> +
>>> +This ioctl copies the writable masks for Feature ID registers to userspace.
>>> +The Feature ID space is defined as the AArch64 System register space with
>>> +op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
>> when attempting a migration between Ampere Altra and ThunderXv2 the
>> first hurdle is to handle a failure when writing ICC_CTLR_EL1
>> (3.0.12.12.4) on dest. This reg is outside of the scope of the above
>> single range (BIT(0)).
> 
> Indeed. But more importantly, this isn't really an ID register. Plenty
> of variable bits in there.
> 
>> This may be questionable if we want to migrate between those types of
>> machines but the goal is to exercise different scenarios to have a
>> gloval view of the problems.
> 
> I think this is a valuable experiment, and we should definitely
> explore this sort of things (as I cannot see the diversity of ARM
> system slowing down any time soon).
> 
>>
>> This reg exposes some RO capabilities such as ExtRange, A3V, SEIS,hyp/nvhe/hyp-main.c
>> IDBits, ...
>> So to get the migration going further I would need to tweek this on the
>> source - for instance I guess SEIS could be reset despite the host HW
>> cap - without making too much trouble.
> 
> I'm not sure SEIS is such an easy one: if you promised the guest that
> it would never get an SError doing the most stupid things (SEIS=0), it
> really shouldn't get one after migration. If you advertised it on the
> source HW (Altra), a migration to TX2 would be fine.
I see. Indeed for sure we must make sure KVM cannot inject SEIs in the
guest if SEIS is not advertised on guest side.

In this case SEIS is 0 on src Altra. On dst TX2 ich_vtr_el2 advertises
it and host seis =1 causing set_gic_ctlr to fail (vgic-sys-reg-v3.c).

> 
> The other bits are possible to change depending on the requirements of
> the VM (aff3, IDBits), and ExtRange should always be set to 0 (because
> our GIC implementation doesn't support EPPI/ESPI).
> 
> The really ugly part here is that if you want to affect these bits,
> you will need to trap and emulate the access. Not a big deal, but in
> the absence of FGT, you will need to handle the full Common trap
> group, which is going to slow things down (you will have to trap
> ICV_PMR_EL1, for example).
Would it be sensible to simplify things and only support the new range
if FGT is supported?
> 
>> What would you recommend, adding a new range? But I guess we need to
>> design ranges carefully otherwise we may be quickly limited by the
>> number of flag bits.
> 
> I can see a need to adding a range that would cover non-ID registers
> that have RO fields. But we also need to consider the case of EL2
> registers that take part in this.
Yes I need to better understand the consistency with ICH_VTR_EL2
> 
> For example, ICV_CTLR_EL1 and ICH_VTR_EL2 and deeply linked, and share
> some fields. Without NV, no need to expose HCR_VTR_EL2. With NV, this
> register actually drives ICV_CTLR_EL1.
understood.
> 
> So careful planning is required here, and the impact of this measured.

Understood. More time needed to study the code ;-)

Thanks!

Eric
> 
> Thanks,
> 
> 	M.
> 

