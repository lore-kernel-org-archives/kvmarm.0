Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4F215335AC;
	Wed,  9 Sep 2026 11:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954731; cv=none; b=Kf2j0UuckzaRMLTFQpWLCq8Gyav0BcGogPULTImwLhbUfjLacltPywQzW/igBOnC/SSG1T5J9gtxHM35dRmQLgMxD3BgokHDw2ar6CXbBGE2RJF7SAYL8mkVVIqKNvQmMLZ+7wwnaJ0XhVaTdeHaljzdXIbshbhNgva7QcHB23E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954731; c=relaxed/simple;
	bh=2vyi1ZM3AtA2rx0F5ICpxmrqDzaZPmSJCKlrDhxuxaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S1OUvsSzzbJgDiEFQ/NdL4kEVJEXCjrFlY2pAVSVkmz18Rn953dKooBkP8XF6vCcjPOWXEbGJoxZpjQ9J9XkN0JePGT0iOtK+3bl/dti+asPo55bvxmcuXHXsC78yMLSYqM6J2ugpUeYZMFEZEVflEkCUbbJSp0fgskOiDRh9Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LMahlmWr; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LMahlmWr"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43E221477;
	Wed,  9 Sep 2026 04:52:04 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D1C1B3F528;
	Wed,  9 Sep 2026 04:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788954727; bh=2vyi1ZM3AtA2rx0F5ICpxmrqDzaZPmSJCKlrDhxuxaI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LMahlmWr+Jeo63JcaLXAkkURJxGLjmJfNWrb8zwoRFFLoK/h5UsOWMaBdZU0SO25i
	 vpPIG/pGA4VOt4wjXeY1ZDuVeyB5w2+UPEOCPZU5uxNym4pNc8LwxX6LY5R1i/6rwx
	 i7iT7eFwrbeBj8Ohl7pAWkvgLDWOJAY9P/HsUp/o=
Message-ID: <6152fc41-65f0-460f-90b4-1454c11bcba6@arm.com>
Date: Wed, 9 Sep 2026 12:52:03 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 10/20] KVM: arm64: coco: Disable Steal time accounting
 for coco guests
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-11-suzuki.poulose@arm.com>
 <CA+EHjTw9ReyvsNT=y+-P6ng7VQ6Pvz9PFK9bO71qvTR1pOxx5Q@mail.gmail.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTw9ReyvsNT=y+-P6ng7VQ6Pvz9PFK9bO71qvTR1pOxx5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/09/2026 12:45, Fuad Tabba wrote:
> Hi Suzuki,
> 
> On Tue, 8 Sept 2026 at 17:23, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> PVTIME support is advertised by KVM_CAP_STEAL_TIME, which doesn't take into
>> account the kvm instance. Even with that, a VMM could skip the CAP check and
>> proceed to configure the PVTIME as we don't do further check on the DEVICE_CTRL.
>> Tighten this up by passing the KVM instance around wherever possible and
>> catch things early
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> ...
> 
>> -bool kvm_arm_pvtime_supported(void)
>> +bool kvm_arm_pvtime_supported(struct kvm *kvm)
>>   {
>> -       return !!sched_info_on();
>> +       return !!sched_info_on() && (!kvm || !kvm_vm_is_confidential(kvm));
>>   }
> 
> I think it would be better to leave KVM_CAP_STEAL_TIME reported and
> instead reject the configuration for these VMs, returning -EPERM from
> the KVM_ARM_VCPU_PVTIME_CTRL attr. A capability query should report
> what the kernel supports, not whether a given VM may use it; gating it
> per-VM here is also inconsistent, since the !kvm clause leaves the
> system-fd cap at 1 while the VM-fd cap reads 0. And -EPERM says that


But isn't that we want from a VMM perspective ? i.e., enable PVTIME if
it is supported for the given VM (type). Rather than PVTIME is supported
by the KVM, so I can go enable it by default. But, we endup getting a
failure while we enable it. I encountered this with kvmtool, where
CAP_STEAL_TIME is reported true and even the HAS_DEVICE_ATTR goes
through fine, but SET_DEVICE_ATTR seemed to fail.

Isn't it better to allow the VM to decide if the capability is supported
for the given VM type, like we are doing for other capabilities ?

> steal-time exists but isn't permitted for a confidential VM, whereas
> -ENXIO reads as "no such feature".

Cheers
Suzuki


> 
> Cheers,
> /fuad
> 
>>
>>   int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
>> @@ -81,7 +81,7 @@ int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
>>          int ret = 0;
>>          int idx;
>>
>> -       if (!kvm_arm_pvtime_supported() ||
>> +       if (!kvm_arm_pvtime_supported(kvm) ||
>>              attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
>>                  return -ENXIO;
>>
>> @@ -110,7 +110,7 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
>>          u64 __user *user = (u64 __user *)attr->addr;
>>          u64 ipa;
>>
>> -       if (!kvm_arm_pvtime_supported() ||
>> +       if (!kvm_arm_pvtime_supported(vcpu->kvm) ||
>>              attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
>>                  return -ENXIO;
>>
>> @@ -126,7 +126,7 @@ int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
>>   {
>>          switch (attr->attr) {
>>          case KVM_ARM_VCPU_PVTIME_IPA:
>> -               if (kvm_arm_pvtime_supported())
>> +               if (kvm_arm_pvtime_supported(vcpu->kvm))
>>                          return 0;
>>          }
>>          return -ENXIO;
>> --
>> 2.43.0
>>

