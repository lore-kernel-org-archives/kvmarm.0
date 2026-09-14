Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFB1420477
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 09:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789379429; cv=none; b=POKFyHiUhILaEmcYwWYNvsL5RG0LERYx5HJSifOrZWELEPiu7PIMq6dXFwioEP++ZutOHJuLagDpuVAEexh+cA9VVlHRywov3OF2uq1GCr8Cmu390ufU8f/w64d95sgGhBpS6IpHuMFEsCqznRX9syuJeF3ZAI9dCN6nGy38d6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789379429; c=relaxed/simple;
	bh=kylQFAzh35/Kr/cF4hIu5aA/58qReMn3tf26L0Lxe+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pFI61CqHnMASydc0uzq0zIVVNXVT7udrD9/vqrUqJkB3WO1x3kc/piLHqD4fFi5IlBPa214BkbTRKI1VdyLSuUdQOSeb6hI1x7bwPJcYKjoNrqEcKoiLb59SAuBc2e/GVZrrWE6h7i743/16yG/7GJ1WxjmqnNLWF88XPoMaIKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PLsdoI/Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PLsdoI/Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789379426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GS5txPMa8dcMMZaluUjmTNiCxS+esxKMHPUrHUieImQ=;
	b=PLsdoI/YgXMD5dGHJqM7+wtRxLegFBuBVOL2JiRgTgIGwi+48mGw/y3Hz6Hr46NuG7sUnC
	dfN4XxYUaC/Q8dSF+B8Ncb07ItrRNroWgBxYVQjFch7GrpyKxrSbvZXrpagfeRHqJgiXQt
	MhlJsmWA3UyvszjqrcjG46Kd66m4DiQ=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-emc0u5t-Pb-wiBEuE1OI6w-1; Mon, 14 Sep 2026 05:50:25 -0400
X-MC-Unique: emc0u5t-Pb-wiBEuE1OI6w-1
X-Mimecast-MFC-AGG-ID: emc0u5t-Pb-wiBEuE1OI6w_1789379424
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c89704da8c7so4377005a12.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 02:50:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789379424; x=1789984224;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GS5txPMa8dcMMZaluUjmTNiCxS+esxKMHPUrHUieImQ=;
        b=WyXLABnxtU0sUSO8jeNlXn7S/WZD6M3wO4EyYCVY5IjyeF8gs8ClZiai0dEQEw9aUz
         V0TZoW4i6Ovf9VrMCA2FdUwLJ/E4r5XqLuWKW6LakUHSJithLCEqQ1nMEAVEf8iwH/l8
         rK1z7JoAoWHbcxoxuRVUjb814yH4zwpp+wO8VozsRmnnM2lt5/XDwNegaLS826eMMwnl
         vorBsppSRnzDkH77kGheqjlGRynvOWEqFZrENhl2w6qc3iljgA1lCgVWDW0gO5PGv85f
         dHAHGk/SuhCFSAQ4wqHHCc6nzZ3dksWYyl8+g9gpIgD363NYuSe3s1clKKGoLsIxHZP0
         KT6Q==
X-Forwarded-Encrypted: i=1; AKwUvBxdbZAHDCAC05UbX8lgjakx0xs79bUTpYbIp24aeGTRMyFx7NKzvxs1PUxtEkGbuijWyfbak+Q=@lists.linux.dev
X-Gm-Message-State: AFuF++lhNecCQr3eEadCzhL9rvL4KFizSnr1u2yON6crPKmBZ+AnJRq9
	cWem2itR43y+R+Anq4lnnDRwmNB1C38MqyykhrGeax81XV9/Azfk1XyXpDJminhZTaXEJK/dOdC
	QdZQ+SELxggdC0ZZAythBGj/DRColBb/bo1YIoIXqhET2Vl3Lei2/Mv8ycQ==
X-Gm-Gg: AYBFou1ZiHg8a087TxBefdhBlIiHlDVYuKmchzb1TovQmv3IV2dNkEdzpuBDyr1TAfX
	D7QqL+UjnYwTmR2WvaG1cEJjSKC7+/NFJuZlbcTTRUpiFCCizpKsrrwOmYc60UAhqy+uifIQEKg
	jjbVMfeIwetvpMFIzY49uL3TDirxfJDkeqwaQYsQza850TUwbv/LmZh9buxIGZNGtjHYkD9t4yq
	AvOTUkyE6WgzFsaROqRbxT1/aizttQqSQL4IxubH2mf5kRM3tNKN2JpP9sDDc+jdgIcLxGZu4lq
	treXgjdicXnsV2WpJYi8m3YLnUK3UvOw/c0LSEFcikKBpNzjwVki31gwd4oEOFjaz+GEuL7JZG0
	jc4WelMDDOs8iaRqy/XQNoUbvmxop5mdxX+4zV32Q2w==
X-Received: by 2002:a05:6a20:7f9c:b0:3c3:7ac4:dac0 with SMTP id adf61e73a8af0-3db4052063emr3632220637.13.1789379424373;
        Mon, 14 Sep 2026 02:50:24 -0700 (PDT)
X-Received: by 2002:a05:6a20:7f9c:b0:3c3:7ac4:dac0 with SMTP id adf61e73a8af0-3db4052063emr3632178637.13.1789379423970;
        Mon, 14 Sep 2026 02:50:23 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4efc398sm30439434eec.19.2026.09.14.02.50.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 02:50:23 -0700 (PDT)
Message-ID: <25706923-8e9c-4785-a80d-b138478ad374@redhat.com>
Date: Mon, 14 Sep 2026 19:50:12 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 4/7] firmware: arm_rmm: Add support for SRO
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-5-suzuki.poulose@arm.com>
 <f00d01d1-8df0-4865-8e52-c85171cf4ca5@redhat.com>
 <4f18aa66-2296-4b63-87f5-6ab493faecbc@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <4f18aa66-2296-4b63-87f5-6ab493faecbc@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: w29fhJ9yiMF7UdEogJeuAUXDOGtHy8bDaiF_NhbPJQw_1789379424
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Suzuki,

On 9/14/26 4:22 PM, Suzuki K Poulose wrote: 
> On 14/09/2026 06:04, Gavin Shan wrote:
>> On 9/12/26 6:36 PM, Suzuki K Poulose wrote:
>>> RMM v2.0 introduces the concept of "Stateful RMI Operations" (SRO). This
>>> means that an SMC can return with an operation still in progress. The
>>> host is expected to continue the operation until it reaches a conclusion
>>> (either success or failure). During this process the RMM can request
>>> additional memory ('donate') or hand memory back to the host
>>> ('reclaim'). The host can request an in progress operation is cancelled,
>>> but still continue the operation until it has completed (otherwise the
>>> incomplete operation may cause future RMM operations to fail).
>>>
>>> The SRO is tracked using a struct rmi_sro_state object which keeps track
>>> of any memory which has been allocated but not yet consumed by the RMM
>>> or reclaimed from the RMM. This allows the memory to be reused in a
>>> future request within the same operation. It will also permit an
>>> operation to be done in a context where memory allocation may be
>>> difficult (e.g. atomic context) with the option to abort the operation
>>> and retry the memory allocation outside of the atomic context. The
>>> memory stored in the struct rmi_sro_state object can then be reused on
>>> the subsequent attempt.
>>>
>>> Wrappers for SRO RMI commands are also provided here because they depend
>>> on the rmi_sro_execute() implementation added by this patch.
>>> Delegate/undelegate handles are also added here because they now use the
>>> SRO/stateful command infrastructure and are also used for the memory
>>> DONATE/RECLAIM flows.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> Co-Developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

scripts/checkpatch.pl recommends s/Co-Developed-by/Co-developed-by, the same
format issue exists in other patches and please double check.

>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> 
> 
>>> ---
>>>   drivers/firmware/arm_rmm/rmi.c | 586 +++++++++++++++++++++++++++++++++
>>>   include/linux/arm-rmi-cmds.h   |  41 +++
>>>   2 files changed, 627 insertions(+)
>>>
>>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/ arm_rmm/rmi.c
>>> index 5b0e342ce3d58..4f9898ece7547 100644
>>> --- a/drivers/firmware/arm_rmm/rmi.c
>>> +++ b/drivers/firmware/arm_rmm/rmi.c

[...]

>>> +
>>> +static void rmi_op_continue(unsigned long sro_handle, unsigned long flags,
>>> +                struct arm_smccc_1_2_regs *out_regs)
>>> +{
>>> +    *out_regs = (struct arm_smccc_1_2_regs) {
>>> +        SMC_RMI_OP_CONTINUE, sro_handle, flags
>>> +    };
>>> +
>>> +    rmi_smccc_invoke(out_regs);
>>> +}
>>> +
>>
>> The pattern 'regs' is used in some of the 'struct arm_smccc_1_2_regs' arguments
>> or variables in this series, which is incosistent to the existing patterns which
>> is either 'args' or 'res' by searching the source files using 'git grep arm_smccc_1_2_regs'.
>> So I would suggest we have the fixed the pattern 'args' :-)
> 
> 
> I would prefer to keep it "regs" as, unlike the smccc_1_1 calls, we
> pass "arm_smccc_1_2_regs" for both arguments and results. In this case
> we are using a single structure, so, to avoid the confusion, I
> intentionally used regs
> 

It's fine to keep "regs" pattern, then the only place using "args" is
rmi_smccc_invoke(). I think the variable or argument names in rmi_smccc_invoke()
can be improved there to use "regs" pattern. With this, we have the unified
pattern "regs".

static inline void rmi_smccc_invoke(struct arm_smccc_1_2_regs *pregs)
{
         struct arm_smccc_1_2_regs regs = *pregs;
		:
}

Thanks,
Gavin

