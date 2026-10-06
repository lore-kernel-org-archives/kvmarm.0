Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998BE2BE034
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 06:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791267414; cv=none; b=h1kpkaJ3zSTae8BTQUpHW49hzLMrX1nEki3oehBVD3a+gfdW+hxw1/QJwgzs7+XHdN3+BuPMNegLpz9sKebCSZeqeSmAEgpHs2anxu++xUnqOLg1Ye6y5BXmkAU0OiIKmrunDA0QziW6rKGriDjANWdTZN78M7CW/1mXkiZxJGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791267414; c=relaxed/simple;
	bh=9sfxC1+KgE1nDpW3pcZvcn/al45MEVpLjYPt9I1uPWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZRVLP+Dfvqp8K0vkbam9LRc/v51lcayXGUqORDZ5cOI0njzs7P5VKK+fjqnfjHEVY6sUci8m/0/nVtsVOn8ruOII747IkFztPZiC49prZqnrj5CWtJsscejJ3DKsH+GfVexFYOlp3WPOH2tXo7r3f1GQnsHWHpqxcZYTHy/YPPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cIuEGIxP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cIuEGIxP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791267410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ndLbXF3FabNtb+dQsv+BJtM4Aj2t7FSPtRaAHVuld68=;
	b=cIuEGIxPJGEZUDfQWJKooVBhH/RvDOVF+Lb+XvMi9KMN5HIDy3OWfR40ZTZAAGBs2NPGFr
	7NLQnJ1qV99Tzx2BNMknPSHI0y3TubEMRZ5EyAp8gaMahUcyX5TUbALG/J6Ok8aJwSvVa1
	xSxkOVgVbhHrj6Yw3zGbZp+kONRGY/E=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-iTzvolAjOSu72qEXhfTBCg-1; Tue, 06 Oct 2026 02:16:49 -0400
X-MC-Unique: iTzvolAjOSu72qEXhfTBCg-1
X-Mimecast-MFC-AGG-ID: iTzvolAjOSu72qEXhfTBCg_1791267408
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3a6d95d6e08so2007867a91.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 23:16:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791267408; x=1791872208;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ndLbXF3FabNtb+dQsv+BJtM4Aj2t7FSPtRaAHVuld68=;
        b=PIn/miPGVAl51b3aGX+W7DANVpkfnQqrUhaPwnpdO3cdSWfh0K3JMRHisPmjiylxPH
         zS6J1MlOQ6eVGJeaT05LucOJJCFi8VNvHfiMLNqYBs0AlDEQaBOJWDhhqMLpZdqJl1lW
         XArkN7MHDKnoozHgxoHvuog7phe8+AqI/gd6A67IxAolrgOLuVZFn6xA37ol7Iq7nfHF
         Ic3Z/70JcXlxYnh4rm7wcdQKtx834Dcjlcidr1mLXJcDS8yQBRNrMdmDKiCVPcucSsw4
         Lldfna5kJ7Wt72ZGC4DaK4QX/SVpz5DtXr/UTTK4SQi6W/hpGTs90YoJHAbtOJFb98yo
         tEOQ==
X-Forwarded-Encrypted: i=1; AKwUvBya93Ab4uAOIByLR0wEwJmoj4CV46pzVSADj+oy+uwuB1QdWUK060tZg4koZfFnjMYIkRHVjiE=@lists.linux.dev
X-Gm-Message-State: AFq9FYK/1IUZCOa/COM1LeIqzPG2UrtiWXPxdu89/3USn4XM/C+nLAOn
	F/h4a6GDKC8YErNY58MGSVy1YM3xjqs3jmKJvRq0Xl5WJLqv5xfEL+i+GkWGttKc5HAgiwOvQul
	Da/InreIzswb7GNS3sYglXtitiKWYEZXuSAXHLwcqEX+LDJ2vl7V6Cw77KA==
X-Gm-Gg: AYBFou1r7Snqh2B6hR9Hw7n5olzjZtugXbCQsIvXzsrawTlfukHJmxnJrGwbHVzBkAW
	H1Jkhe5yPjEMgZbcNKp6t/Z9P53mwtVqZLienq3j35vrdoo/paYgMkdpIkRA2mTCN5CZnioJ5L2
	e2AFlBAHESp3Jwz8sw4OnV9uMi0JyE83JLX3TJBKGib0VqA8iw9Z3Wbgy/VR/uWg0Fy+tNMl5qh
	QEhmkpOHB48AQPBp5qgCmonFlkgVQ3Go9cnLmbP57+UykJ3zG78kTwYE1YvOQJb4azadnC5c4za
	v7fEZEfoajVvTlO5qSOp1iBXmmyQidfmRfypshHsZ0kAUOa4KbqlAr0q0z4Hs9WmjXJ8a0deNgE
	4Abu5lGkYhw+YliH28hpU548D8MJGbZwy3Eb487GxkA==
X-Received: by 2002:a17:90b:28c6:b0:3a4:b30b:b50a with SMTP id 98e67ed59e1d1-3a873697b55mr247324a91.25.1791267408197;
        Mon, 05 Oct 2026 23:16:48 -0700 (PDT)
X-Received: by 2002:a17:90b:28c6:b0:3a4:b30b:b50a with SMTP id 98e67ed59e1d1-3a873697b55mr247306a91.25.1791267407661;
        Mon, 05 Oct 2026 23:16:47 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8211b74c8sm3504720a91.0.2026.10.05.23.16.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 23:16:47 -0700 (PDT)
Message-ID: <6bd785aa-4693-407d-b70a-39b1d0eda63e@redhat.com>
Date: Tue, 6 Oct 2026 16:16:37 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 23/23] KVM: arm64: CCA: Control user register access
 for Realms
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-24-suzuki.poulose@arm.com>
 <52e3e45a-751e-40b2-8dd3-3db589ddebee@redhat.com>
 <7b6ed626-eca4-41f2-ae56-0af59a931b29@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <7b6ed626-eca4-41f2-ae56-0af59a931b29@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sgF7CIXMSq_QhcTSj1uWd-ZS66VdUzTh2JO_d83X4gk_1791267408
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/6/26 4:01 PM, Suzuki K Poulose wrote:
> On 06/10/2026 06:47, Gavin Shan wrote:
>> On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
>>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>>
>>> The RMM restricts the access to the register states that the host can
>>> read/modify for a given Realm.
>>>
>>> e.g., At VCPU creation, can modify GPRS (x0-x30) and PC.
>>>        While servicing SMCCC calls via RSI_HOST_CALL or servicing PSCI
>>>        requests.
>>>        MMIO emulation in the unprotected space.
>>>
>>> Additionally we use the sysreg configuration to advertise/configure the
>>> following Realm parameters, which are required before the Realm Descriptor
>>> is created:
>>>   - SVE Vector Length
>>>   - Number of HW Breakpoints/Watchpoints
>>>   - PMU Counters.
>>>
>>> Thus KVM also additionally allows access to ID_AA64DFR0_EL1 and SVE_VLS for
>>> the configuration of Realm creation parameters. We don't support PMUs for
>>> the Realm VMs yet, so PMCR is not exposed.
>>>
>>> The RMM makes similar restrictions for reading of the guest's registers
>>> (this is *confidential* compute after all), however we don't impose the
>>> restriction here. This allows the VMM to read (stale) values from the
>>> registers which might be useful to read back the initial values even if
>>> the RMM doesn't provide the latest version. For migration of a realm VM,
>>> a new interface will be needed so that the VMM can receive an
>>> (encrypted) blob of the VM's state.
>>>
>>> Reflect the above in KVM_GET_REG_LIST, KVM_SET_ONE_REG calls.
> 
>>>   static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
>>>   {
>>>       int size;
>>> @@ -553,6 +572,9 @@ static int copy_core_reg_indices(const struct kvm_vcpu *vcpu,
>>>           u64 reg = KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
>>>           int size = core_reg_size_from_offset(vcpu, i);
>>> +        if (vcpu_is_rec(vcpu) && !kvm_realm_validate_core_reg(i))
>>> +            continue;
>>> +
>>>           if (size < 0)
>>>               continue;
>>> @@ -598,6 +620,9 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
>>>       if (!vcpu_has_sve(vcpu))
>>>           return 0;
>>> +    if (kvm_vm_is_realm(vcpu->kvm))
>>> +        return 1; /* KVM_REG_ARM64_SVE_VLS */
>>> +
>>>       if (!kvm_arm_vcpu_sve_finalized(vcpu))
>>>           return 1; /* KVM_REG_ARM64_SVE_VLS */
>>>
>>
>> Aren't above two checks conflicting to each other?
> 
> Do they? We allow SVE_VLS only for the Realms and we allow that
> before the vCPUs are finalized. For normal VMs, depending on
> whether the vcpus are finalized, we either send 1 or the full list.
> 

num_sve_regs() can be called for 3 cases: (a) non-finalized RECs; (b) finalized
RECs; (c) Other finalized vCPUs, correct? "if (kvm_vm_is_realm(vcpu->kvm))", which
would be "if (vcpu_is_rec(vcpu))", covers (a) and (b). We needn't the excessive
check "if (!kvm_arm_vcpu_sve_finalized(vcpu))". So the check would be something
as below after this series is applied:

	/*
	 * KVM_REG_ARM64_SVE_VLS is visible on realm vCPU no matter if it
	 * has been finalized.
	 */
	if (vcpu_is_rec(vcpu))
		return 1;

This check "if (vcpu_is_rec(vcpu))" belongs to PATCH[22]. Hope I make myself
clear this time :)

>>
>>> @@ -625,6 +650,10 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
>>>           return -EFAULT;
>>>       ++num_regs;
>>> +    /* For Realms only support SVE_VLS */
>>> +    if (kvm_vm_is_realm(vcpu->kvm))
>>> +        return num_regs;
>>> +
>>>       if (!kvm_arm_vcpu_sve_finalized(vcpu))
>>>           return num_regs;
>>
>> Same question here.
> 
> As above.
> 
> Suzuki

Thanks,
Gavin

