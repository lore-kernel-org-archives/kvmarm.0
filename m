Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E1D37C0EB
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 11:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781782741; cv=none; b=eDk2wkv5Eg+w6C8YXyhsFl8wDq1kYoNoElJ3ptdpQpcVQymKa5OZz+Wfs5twn51Y7fbl20YoHzTpaSGl5KoPUVpr7u7q9+dQiYCkjVr6lF3CT3tpCsNB8g9hx2QFCEusoFmVWijTt5pR57Nnd8e3nn2Zde7YpouPjXnClt21A9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781782741; c=relaxed/simple;
	bh=jAOFsTcTmabZULevaiji0SmZ5BNAK+aF5FkDqsBuBhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M8SuCJRdCzDT6+J/VfTTzVl/4UcaFJ0AtIyfk1TvOcAYno6d0cp6NEVBPLngZNWA4/248SN98mLqGvVsUey7X6o0PL8PhgrE3lgZRgz6DuhMvVvdwqJ8gKWRLVlKqXN0A/UFzT310XjB8+rqzw57MmcHo6lxC2wmdRDo+aR2K/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nPJ4+0Ay; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nPJ4+0Ay"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-37cae9b7536so458311a91.3
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 04:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781782739; x=1782387539; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IkKXLMODQjJrjCqo090xsQbfSpnPIJwf7cUopEavvaM=;
        b=nPJ4+0AyMFJSQevgqFrlRr5AlM/fMcCDiM/zySkubpDPL/JigKkN+Sb/NiW+NAnH/f
         nyieYXNhNbQNug0VWjApzJoReGjNDEMQonmfuyey6FLw0VN+QD1HGndOItCYqEoBaOxl
         LrtwCNzpyP97OXx+bf5pKgezmyqYMiuaw5kJzINqWC/+8np2HWgLqqSodWAq6vf46ARp
         Yff3TtstpZXNOmP2OL190q3ZoWh8Azi0F6KaxfuOFxwvtDbvIhFBxwdiaRAd7UsZX0eV
         f4lYcySc1/kJjRXquJNHwG51Y3x8QjeZ2OZvmlE0Yl2dR3SS2cL56p0MzP02gl/iIYYH
         tfAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781782739; x=1782387539;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IkKXLMODQjJrjCqo090xsQbfSpnPIJwf7cUopEavvaM=;
        b=dsizUOZPOfILg5FtuxQOGKvnynZYeCm8QMtSrwR+jgND1pXf5qhDLhJTcQOdlOUg+g
         8q1RuUYTYuzuBYjW3eq9TgjIXW81LUd85Yu4CxBR09Fau1eXk9bts9gzBEsHKfYShYgd
         j2LoXuDQ8IIAXXxbRpYbqY29W9O0WyIO6J0yo9wR7xLDkGl6T9//YeWQPTBQNFX065cw
         p/2kKM/8vLoxbv2LaYGiesbPjVx0BkR6tDw+nPA2hYwpkdRsRq5UTqiGOgod4rEfp5mq
         dSzYJnpBI5CJ9gJ57nNICx+S2+bOXh4VEi7PspbSjhKmS6HTxSDsygSTnnkbJcr2mvMz
         Tt3A==
X-Forwarded-Encrypted: i=1; AFNElJ8k2m9bGKsXMtRyY61QLYw5rzAt4hjO/NywUTT/eBlsVUd7B3nNqFLtwrFr172sqefG6J7Ppd0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRlbflpOBF9NFKn6eGW1NE+RlAcUi/dsJgNJSgAZvqU5sV7z6g
	pNI16AbKFzz3Y4A/Qze0SRCbphxBR9wkZEOJ6ZdbSh9KNnhQqofqGe/AyXHxdZOX
X-Gm-Gg: AfdE7cnq71SHO04a/TpDm/OF/PhUpU2UWBzAYDXPHMWnMjQ0U3X/WM39trShYZEbcml
	fT9ZNf3V+rH9YC2BQRLUPgqcygMqAz0poEXdKX/KsFeScPTeoE9EvVXJGpofVCrhqrbfdt+GbED
	V7pnk1U5G98lT06qM4Bb3kOPJCS5GTqBu3lCwlzJZJ90TY33ZrCSPB1NtsEgsG35FU16QGlplT3
	lZvmFAAjQ27aWu9NfMTqwel2pekLRxxvnAkmRM+R/4xIDGaWgbGiWb3EnuiTHPpIyJ8RO2R3Eag
	3b5NosLv/DeV2WrOid6J+b+u9ZyMfz28Fsltvc7boSPdVDnTagYDZSKuEKdmswD97Ki6je9mU7g
	wSmeMKSSJ61K5Q4dbMY91i5YgCfTaaGHC38hNcYnG+4h4Ab+ymwfd8AGAZs/Xq3oM1sOD4bHei9
	wsuPOglEJC6jI36RlXLZIdwWTCFjCfsaiA3SAKoNof6AampPJGQu9vl9cH6v1zpE2bMdjEdQ==
X-Received: by 2002:a17:90a:ec87:b0:36b:e8b9:46a4 with SMTP id 98e67ed59e1d1-37ce4743a2fmr3312995a91.14.1781782739152;
        Thu, 18 Jun 2026 04:38:59 -0700 (PDT)
Received: from ?IPV6:240f:c0ff:0:4:f139:1acf:f610:fa8f? ([2408:80e0:41fc:0:ef67:1acf:f610:fa8f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c522a019csm9497619a91.14.2026.06.18.04.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 04:38:58 -0700 (PDT)
Message-ID: <ef4bd4eb-f67a-4a44-a548-08240c2eba30@gmail.com>
Date: Thu, 18 Jun 2026 19:38:54 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: arm64: Skip unreset vCPUs in MPIDR lookup
 table
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, dongxu zhang <xu910121@sina.com>,
 wangfuqiang49 <wangfuqiang49@jd.com>, "diaojiaqing.1" <diaojiaqing.1@jd.com>
References: <20260611144042.97981-1-fuqiang.wng@gmail.com>
 <20260611144042.97981-3-fuqiang.wng@gmail.com> <87o6hd8oc7.wl-maz@kernel.org>
 <ai99kwiaJq-VIAUk@kernel.org> <87cxxs86bg.wl-maz@kernel.org>
From: fuqiang wang <fuqiang.wng@gmail.com>
In-Reply-To: <87cxxs86bg.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/15/26 6:08 PM, Marc Zyngier wrote:

Hi Oliver, Marc

Thank you very much for your replies and guidance. I'm sorry for the
late reply.(I took some time to brush up on ARM CPU hotplug.)

> On Mon, 15 Jun 2026 05:20:35 +0100,
> Oliver Upton <oupton@kernel.org> wrote:
>>
>> On Sun, Jun 14, 2026 at 10:26:32AM +0100, Marc Zyngier wrote:
>>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>>> index 3732ee9eb0d4..fccfa97370df 100644
>>>> --- a/arch/arm64/kvm/arm.c
>>>> +++ b/arch/arm64/kvm/arm.c
>>>> @@ -887,8 +887,18 @@ static void kvm_init_mpidr_data(struct kvm *kvm)
>>>>   	data->mpidr_mask = mask;
>>>>   
>>>>   	kvm_for_each_vcpu(c, vcpu, kvm) {
>>>> -		u64 aff = kvm_vcpu_get_mpidr_aff(vcpu);
>>>> -		u16 index = kvm_mpidr_index(data, aff);
>>>> +		u64 aff;
>>>> +		u16 index;
>>>> +
>>>> +		/*
>>>> +		 * Skip vCPUs that haven't been reset yet; their MPIDR_EL1 is
>>>> +		 * zero.
>>>> +		 */
>>>> +		if (!kvm_vcpu_mpidr_is_reset(vcpu))
>>>> +			continue;
>>>
>>> But what about the initial loop that computes the significant bits
>>> amongst the vcpus?

Yes, this is indeed missed here, possibly making the following nr_entries
calculation too large.

>>>
>>>> +
>>>> +		aff = kvm_vcpu_get_mpidr_aff(vcpu);
>>>> +		index = kvm_mpidr_index(data, aff);
>>>
>>> In all honesty, I think this is a userspace bug more than anything
>>> else, and checking for random bits in MPDR_EL1 to verify whether the
>>> value is plausible is gross.
>>
>> +1. Checking the MPIDR value is also broken because userspace can write
>> whatever it wants to the register, which could even clear the RES1 bit
>> that's getting tested here.

Yes, the change here is quite ugly — it looks like temporary debug code.
It would be better to change it to !kvm_vcpu_initialized().

>>
>>> Yhis isn't different from setting MPIDR_EL1 to the same value on all
>>> vcpus, which we don't try to mitigate. Late setting of MPIDR_EL1 also
>>> defeats the whole point of having a cache for the affinity to index
>>> conversion, making SGIs pretty slow for late CPUs.
>>>
>>> I really think that by not finalising your vcpus and start running the
>>> guest, you have cornered yourself pretty badly, and we shouldn't try
>>> to paper over it.
>>
>> I generally agree, although I wouldn't be against a change that nuked
>> any of the cached routings in case of userspace doing stupid things like
>> collisions and whatnot.

I once thought about sending patch [1] again, because I found that Oliver
had done something similar[2]... but then I gave up.

For restless userspace programs, KVM cannot foresee their behavior. For
example, when a VCPU is running, there may be cases like:

+ some vcpus not create, later create
+ some vcpus created but not reset, later reset
+ some vcpu not create, later create BUT never run. This may prevent other
   vCPU threads from using the mpidr_data, because they rely on the vCPU that
   destroys the mpidr_data to trigger a rebuild. (Although we can rebuild
   mpidr_data when resetting the vCPU(just for later-created vcpu), it is
   preferable to defer the rebuild until after all destruction actions have
   been completed).

even, as mentioned above, userspace write MPIDR_EL1 to cause collisions. It
seems somewhat not worth the effort.

[1]: https://github.com/cai-fuqiang/armkvm/commit/eeda9309e0a6c700449e90cf27127a7e4e0238ed
[2]: https://lore.kernel.org/all/20240508071952.2035422-1-oliver.upton@linux.dev/#r

> 
> Detecting collisions is difficult, as we have no idea of the overall
> guest topology. All we can do is work out whether the computed mask
> has enough bits to represent the number of online vcpus, but that's
> not necessarily good enough.
> 
> One possibility would be to invalidate the cache on each update to any
> MPIDR_EL1, including reset. People doing silly things by initialising
> vcpus post first start will still suffer, but should we care?

However, could we detect collisions within the init function and, upon
detection, notify userspace without taking any corrective or fallback
action? This would serve as a stronger reminder to userspace of its
non-compliant behavior.

e.g.

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3732ee9eb0d4..7563feab1a11 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -893,6 +893,17 @@ static void kvm_init_mpidr_data(struct kvm *kvm)
                 data->cmpidr_to_idx[index] = c;
         }

+       kvm_for_each_vcpu(c, vcpu, kvm) {
+               u64 aff = kvm_vcpu_get_mpidr_aff(vcpu);
+               u16 index = kvm_mpidr_index(data, aff);
+
+               if (data->cmpidr_to_idx[index] != c) {
+                       pr_warn("Multiple vCPUs share the same MPIDR value, "
+                               "it may cause the guest to hang or run slower\n");
+                       break;
+               }
+       }
+
         rcu_assign_pointer(kvm->arch.mpidr_data, data);
  out:
         mutex_unlock(&kvm->arch.config_lock);


Thanks
fuqiang

> 
> Thanks,
> 
> 	M.
> 

