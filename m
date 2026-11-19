Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.216
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795074770;
	b=HxW9P2aHZv7YyoPNRm7xPBkEBW3ORtP6VDrRdmZZ2JWWuPpyWEn+JZxsucwnoV3so9O1
	 lx6VA6/g5u3fLL8KdJIhDv/PqlEt2QH2o4rk15y7lZJRxH9bO2PlsflE1ca/SwOv+SxTC
	 qPzkVoY8C1/ZYTeiK5T19mAje+QLb+rrAS7R1PMmHpoAXIckY2hGHJpWszc1yuc5nnd+m
	 ZmkBM2VnBR1Df7yIFLfpxCsbXTEr29rtpVoVjLk/p60K5CtBVeEsFqZytMFoSw3zSzg6o
	 Nc+jdazuqcf8222nYyFR6k4JcjKR6fD7Sm1n6krXEfXUTK+k4Souu7x+Ci1YcJVKnZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795074770;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=XDGSq+NYY9XzLBrI14hyUS/fB+/Exw2w2j7dzo+fazs=;
	b=J/hIG6dNw3qY7c8JmnM0rleo33zFZvf76lPh1I3mxQCF0MhvrshZDsxp7idfrUGRqjTz
	 lWIrQK0wfOdE7EL2ptJ+2RX5hdoQGMeAT+02/wYwy+jwNbzoRtrrLZR3R4tF+TQfhxkPY
	 eBk4YxqauG4Y8ojQkRQNwFdk+ZsiX3BI0K/g3UFoZg/KVpRtk23t+eF4tF1sYdWT/tz2J
	 JyMPAtrKxsPHv0GqTZu6jjsbSmx7dzJPWI9bzoW9Pwj6pkxNSiDBlSPf3xKwcWfYCqYez
	 4IpmpoQol22u7EIqKPC2rm13TQqEw6ofUjxc8+lregUkAIEQcF4X68A3RG/I9dgDQSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=LCSdGyGP;
	arc=none smtp.remote-ip=113.46.200.216
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E7A606A320
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 07:52:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6E7A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=LCSdGyGP
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XDGSq+NYY9XzLBrI14hyUS/fB+/Exw2w2j7dzo+fazs=;
	b=LCSdGyGPdamq0ZtVH+kQdHhms9IgZI22Kjo79DM7xUImrxVEK+DP8tfMlYQ5/G9pKXP//eJpt
	hiHyy9nA5IKmAKkHxPR9kSEkq3RilXY3DPsQUifasfgYSS15KqerDXrYYPbjxP+UQ9aehn1f8Gu
	fSS+3VMnGKoM25dNCsLD0so=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4jVVzd5Ky2z1T4Fr;
	Thu, 19 Nov 2026 15:51:57 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id C976C203AB;
	Thu, 19 Nov 2026 15:52:38 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 19 Nov 2026 15:52:37 +0800
Message-ID: <ceb91298-3d05-486e-a900-1291963dde24@huawei.com>
Date: Thu, 19 Nov 2026 15:52:37 +0800
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/15] KVM: arm64: Add support for FEAT_HDBSS
To: Leonardo Bras <leo.bras@arm.com>
CC: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <corbet@lwn.net>, <pbonzini@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yangjinqian1@huawei.com>,
	<caijian11@h-partners.com>, <liuyonglong@huawei.com>,
	<tangchengchang@huawei.com>, <yezhenyu2@huawei.com>, <yubihong@huawei.com>,
	<linuxarm@huawei.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <fuad.tabba@linux.dev>, <mark.rutland@arm.com>,
	<seanjc@google.com>, <rdunlap@infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <skhan@linuxfoundation.org>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-7-zhengtian10@huawei.com> <at-X_hFbsBU_Dsgr@LeoBrasDK>
 <a301e884-f6d1-4082-8551-8d8a17276dc3@huawei.com>
 <auSml6yTVYIQe7NZ@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <auSml6yTVYIQe7NZ@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 10/30/2026 10:15 PM, Leonardo Bras wrote:
> On Fri, Oct 30, 2026 at 10:53:57AM +0800, Tian Zheng wrote:
>>
>>
>> On 10/27/2026 2:12 AM, Leonardo Bras wrote:
>>> On Tue, Sep 29, 2026 at 06:36:46PM +0800, Tian Zheng wrote:
>>>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>>>> index 32102c3912fa..12fa37328dd2 100644
>>>> --- a/arch/arm64/kernel/cpufeature.c
>>>> +++ b/arch/arm64/kernel/cpufeature.c
>>>> @@ -2158,6 +2158,11 @@ static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
>>>>    	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
>>>>    }
>>>>
>>>> +static bool has_vhe_hdbss(const struct arm64_cpu_capabilities *entry, int scope)
>>>> +{
>>>> +	return is_kernel_in_hyp_mode() && has_cpuid_feature(entry, scope);
>>>> +}
>>>> +
>>>
>>
>> Hi leo,
>>
>>> IIUC you run this on every cpu in the system, to make sure it's matching
>>> the feature. Is there any chance the kernel is in EL2 only on some of the
>>> cpus here?
>>>
>>
>> It's impossible for the system to have only some CPUs in EL2 and others
>>   not.
>>
>>> If not, maybe we can run it on system_supports_hdbss() instead, which would
>>> be easier for the user to understand it only runs in EL2, on top of not
>>> needing the above.
>>>
>>
>> However, The question is whether a cap should mean "this system can use
>> the feature" or "this hardware supports the feature". If the cap only
>> tracks hardware support, users may be confused when the hardware
>> supports HDBSS but the system runs in nVHE mode — they would mistakenly
>> believe they can use the feature.
>>
>> So I think we should keep is_kernel_in_hyp_mode() in has_vhe_hdbss(),
>> and add a comment in system_supports_hdbss() explaining this.
>>
>> Does that work for you? Looking forward to your reply.
> 
> Well,
> That's just my personal view of this:
> 
> If we have a function called "has_hdbss" it should only report if the
> system has the feature available.
> 
> On the "system_supports_*" we have to figure out if the system itself
> supports the feature, which checks the feature bits itself and could mean
> checking for other features being there, such as hyp_mode.
> 
> What do you think?
> 
> Thx,
> Leo

Hi Leo,

Sorry for the slow reply. I've been looking into how other cpufeatures
are configured on arm64, on and off, and that's why it took a while.

My reading is that detected: HDBSS should mean "this system can use
HDBSS", not just "the silicon has it".

Several caps already add conditions beyond the ID bits. CNP returns
false for kdump and under ARM64_WORKAROUND_DISABLE_CNP, NV and pKVM
match on kvm_get_mode(), and can_trap_icv_dir_el1() starts with
is_hyp_mode_available(). So in practice a SYSTEM_FEATURE cap answers
"can this kernel use it on this system".

HDBSS is EL2-only (HDBSSBR_EL2/HDBSSPROD_EL2, VTCR_EL2.HDBSS),
implemented only under hyp/vhe, and used only by KVM, so "the hardware
is there" is not the same as "this kernel can use it". That is why I'd
keep the gate in has_vhe_hdbss() rather than moving it to the consumer.

I'd be interested to hear how you see it.

Thanks,
Tian
