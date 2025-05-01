Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C361266B75
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 23:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746143981; cv=none; b=ZIZXzL279vO4s7oOsZnXjU5EK519IxeisWtx9DasKFBtNgQXZSyTi5zcOQhwESvhHfIALvhY17ADgUuEq57/x+WTHXAaHjgy39yCfXQSzeBBCNOHeGXtTISS638BQcaBfVhuBp8XnRm2sbvBPGVyDY34IS54K78kOagJ2Qxofxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746143981; c=relaxed/simple;
	bh=0dKoIngO2U3OwRkNoIpYh9lZw9hPMv1MG1wI2ft80KA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dqMZwqnideCPGnM4jRn0q5GWvLQabodlB/pAV80sM82f2F14e1OmK7HvsAg08dtQspfB/oHwwxfoPXiO1/XHkrN6Qd/XkH1MnRoOMtiYX+Gu+UIR9kSt05zv9yTRYL4gCvS2JpyQ/Go4wuLXwA+nbXTY29gg+osdCAhX2+IoJ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BQ+JrZzP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BQ+JrZzP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746143978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cBANZxuf9Ewcq9UHI1RdTA5tF6P0Odc/vpt5hBmkkMY=;
	b=BQ+JrZzP9Ox+l3GGV+j8yTb2wG+2GfF2G88BKl8UX4vduXLgYgApXNQfbbpMxt0GUmEJ7V
	T5TAQ9aF/AeGMt5PyL0bAM8BYqTt/rgFM5CY6X8zlxoRlvCb0G6e5I68OZHyfU6/uqGBiA
	JbB/oQzB7UJ6BMmzaD+3mFeGW7Rm2ts=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-DKDEohq6OO6vqKq5iDLi3Q-1; Thu, 01 May 2025 19:59:35 -0400
X-MC-Unique: DKDEohq6OO6vqKq5iDLi3Q-1
X-Mimecast-MFC-AGG-ID: DKDEohq6OO6vqKq5iDLi3Q_1746143974
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-736b22717f1so1411387b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 01 May 2025 16:59:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746143974; x=1746748774;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cBANZxuf9Ewcq9UHI1RdTA5tF6P0Odc/vpt5hBmkkMY=;
        b=ELw+3KtAS96qhZNbBYDa5pZHYP0WdKXub8szf/OalyJUPLwFaFu5vAP28YmV+4Dz7j
         yVQqm+QMhdnOgKCf4lNUaakGzphe6cVjiAVsZnMY6CPlnC6X9l6AmnLOC4LQvi5/onYz
         rT/ZGLtHbDCSSlhXeBSFhpG1cnwuYwF1CRpdwrv0YtFePLX4Ev1K8Qx+OgrwyrGR48kR
         b4piKd0z4dRxY1gnHiKCmSxcIClzCJNU4NeVBCU+RXV3xDTquLIVZPJjGBi2/4Q3vxI3
         QTU6DQPle61Gd0XkMhnC8a57f7suUkBXqPXSVjss9hLUThzABbxaD/SvTkApslV5ODRm
         qDHA==
X-Forwarded-Encrypted: i=1; AJvYcCXoFTcsUcA8ce2THHEYI07wpPtmpi2ocehKosgp/tJ/C3FWUFq1ZdtiQ445Ce+oabjr9lmvyl8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyIwDNmmCfw75mt0vAYu84ChgBzpr/so9SHqhT1wK6ERZNB2MrL
	a41cG5ol6FX6Ld9HJelDjQP30W2d4zJhzd3ZUZG+oP7LUtcS79KsulXJn2x2xJVNgJlQlCUtbf9
	hZ6lwrSRGNXZitgznkCbugIId9DGPVaYtqCHpev6dzeES9H5rB8zZSA==
X-Gm-Gg: ASbGncv9WfzzMLLFPS+CR3lPhjPUpZKlUtEFH+X99GRuaYGKAfh6Tf/rjZ4dwPlvhmx
	DFacvg8Zb4hBZQSUJ7TqLluUUM7r+l8gp/4WGOEyAZZcBzKt8x8y/yReFZ4/yFpgeDJPZG3CtbS
	zq9lc5iLwLA2Fuch560unY90cqRUkprygYmZOnaXLXDMnbmDLXBEyFZ7yQoNX/FS9uW6lY9TERB
	JWFTLYSWgammuEhGz3FnU1RM0kpuI4esGkFItiG3OhohMkcTosP8qxrlpbyLjQlX8N++kle3+ev
	f2/fgN5Z9UsN
X-Received: by 2002:a05:6a21:3a95:b0:1ee:a410:4aa5 with SMTP id adf61e73a8af0-20ccd77ed42mr1244488637.17.1746143973960;
        Thu, 01 May 2025 16:59:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMpgyoNeMNenmpM+HSomoVyyuNDLKcDkubN3MpNbx1DHID/acstvVT2f8CfagoMMSqLqN1+A==
X-Received: by 2002:a05:6a21:3a95:b0:1ee:a410:4aa5 with SMTP id adf61e73a8af0-20ccd77ed42mr1244475637.17.1746143973557;
        Thu, 01 May 2025 16:59:33 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058d7a497sm279346b3a.33.2025.05.01.16.59.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 16:59:32 -0700 (PDT)
Message-ID: <15b37ee8-2aeb-442e-b683-705e30f3b0ca@redhat.com>
Date: Fri, 2 May 2025 09:59:24 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 15/43] arm64: RME: Allow VMM to set RIPAS
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-16-steven.price@arm.com>
 <cc2c5834-c942-4454-903d-11b53f8f5451@redhat.com>
 <d2caa472-01da-4dc2-8c38-bf0cd4524bcd@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <d2caa472-01da-4dc2-8c38-bf0cd4524bcd@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8wdyFMa-s3k33SZcwHxQQyiB5nRAKd_9t2P5qkckJeA_1746143974
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/2/25 2:00 AM, Steven Price wrote:
> On 30/04/2025 12:38, Gavin Shan wrote:
>> On 4/16/25 11:41 PM, Steven Price wrote:
>>> Each page within the protected region of the realm guest can be marked
>>> as either RAM or EMPTY. Allow the VMM to control this before the guest
>>> has started and provide the equivalent functions to change this (with
>>> the guest's approval) at runtime.
>>>
>>> When transitioning from RIPAS RAM (1) to RIPAS EMPTY (0) the memory is
>>> unmapped from the guest and undelegated allowing the memory to be reused
>>> by the host. When transitioning to RIPAS RAM the actual population of
>>> the leaf RTTs is done later on stage 2 fault, however it may be
>>> necessary to allocate additional RTTs to allow the RMM track the RIPAS
>>> for the requested range.
>>>
>>> When freeing a block mapping it is necessary to temporarily unfold the
>>> RTT which requires delegating an extra page to the RMM, this page can
>>> then be recovered once the contents of the block mapping have been
>>> freed.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes from v7:
>>>    * Replace use of "only_shared" with the upstream "attr_filter" field
>>>      of struct kvm_gfn_range.
>>>    * Clean up the logic in alloc_delegated_granule() for when to call
>>>      kvm_account_pgtable_pages().
>>>    * Rename realm_destroy_protected_granule() to
>>>      realm_destroy_private_granule() to match the naming elsewhere. Also
>>>      fix the return codes in the function to be descriptive.
>>>    * Several other minor changes to names/return codes.
>>> Changes from v6:
>>>    * Split the code dealing with the guest triggering a RIPAS change into
>>>      a separate patch, so this patch is purely for the VMM setting up the
>>>      RIPAS before the guest first runs.
>>>    * Drop the useless flags argument from alloc_delegated_granule().
>>>    * Account RTTs allocated for a guest using kvm_account_pgtable_pages().
>>>    * Deal with the RMM granule size potentially being smaller than the
>>>      host's PAGE_SIZE. Although note alloc_delegated_granule() currently
>>>      still allocates an entire host page for every RMM granule (so wasting
>>>      memory when PAGE_SIZE>4k).
>>> Changes from v5:
>>>    * Adapt to rebasing.
>>>    * Introduce find_map_level()
>>>    * Rename some functions to be clearer.
>>>    * Drop the "spare page" functionality.
>>> Changes from v2:
>>>    * {alloc,free}_delegated_page() moved from previous patch to this one.
>>>    * alloc_delegated_page() now takes a gfp_t flags parameter.
>>>    * Fix the reference counting of guestmem pages to avoid leaking memory.
>>>    * Several misc code improvements and extra comments.
>>> ---
>>>    arch/arm64/include/asm/kvm_rme.h |   5 +
>>>    arch/arm64/kvm/mmu.c             |   8 +-
>>>    arch/arm64/kvm/rme.c             | 384 +++++++++++++++++++++++++++++++
>>>    3 files changed, 394 insertions(+), 3 deletions(-)
>>>

.../...

>>> +static int kvm_init_ipa_range_realm(struct kvm *kvm,
>>> +                    struct arm_rme_init_ripas *args)
>>> +{
>>> +    gpa_t addr, end;
>>> +    struct realm *realm = &kvm->arch.realm;
>>> +
>>> +    addr = args->base;
>>> +    end = addr + args->size;
>>> +
>>> +    if (end < addr)
>>> +        return -EINVAL;
>>
>> The check needs to cover 'end <= addr'. RMI_ERROR_INPUT is returned from
>> RMM::smc_rtt_init_ripas()
>> if 'end' is equal to 'addr', but we're returning 0, inconsistent to that.
> 
> I agree we're different to smc_rtt_init_ripas(), but I don't really see
> why we should prevent args->size==0. Calling the low level SMC in that
> case would clearly be wrong (the kernel should be validating and that
> would show a lack of validation), but we handle that with the while loop
> in realm_init_ipa_state().
> 
> Do you think it's important to define this uAPI to disallow size==0?
> 

No, it's not a big deal since it's just a nitpick. The current implementation
isn't wrong because 0 will be returned when size is 0, meaning it succeeds
but no work to do there. Please leave the code as of being :)

>>      if (end <= addr)
>>          return -EINVAL;
>>
>>> +
>>> +    if (kvm_realm_state(kvm) != REALM_STATE_NEW)
>>> +        return -EPERM;
>>
>> To keep the consistency, kvm_realm_is_created() can be used here.
>>
>>      if (kvm_realm_is_created(kvm))
>>          return -EPERM;
> 
> This isn't the same - kvm_realm_is_create() is checking for
> REALM_STATE_NONE, but we want to check for REALM_STATE_NEW.
> 

Hmm, sorry for the noise. The current code is good enough then :)

Thanks,
Gavin

