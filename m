Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ACBA3C8733;
	Thu, 10 Sep 2026 10:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789036080; cv=none; b=Qpp/LNKwPAGHr1j4lBvWtIPNXOIX/AjBdHZfGonFbtZNuqr1MFhW+ZCXQ/jbarXZr5ginIXYe1FjlHroZn2d7ReMTJOK9woAaoRExtSqNjJekyMJhKhRevx2z5QopXnMCMtnnwvhuk+pdNmMTcydThhtUP1O9/mjlWQnd3X2aEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789036080; c=relaxed/simple;
	bh=aWQt/+Tvo/ggfRTd82k5+d6xlXw8sI7UgTyynHOeLvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HsjgUsh+IvACOco7ge83wrpyPh1AmVPbCHZjMHOn/LJFfDSZNi80Iy8O7hggkuGynibbGIGKBkIXtxaUs7Fh1HnRMDW18B2jjLIlzccSRK4H9n8bXXJB/CMmy90UGnxGt+/ZCbAMcDjQ3eQbiVx3HHqyLhIFB6xpsdu38HSD/Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KYlafta4; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KYlafta4"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4E8D143D;
	Thu, 10 Sep 2026 03:27:54 -0700 (PDT)
Received: from [10.0.129.245] (unknown [10.0.129.245])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7E7D23F7B4;
	Thu, 10 Sep 2026 03:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789036078; bh=aWQt/+Tvo/ggfRTd82k5+d6xlXw8sI7UgTyynHOeLvI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KYlafta4EkjMZWOAfvdk24/OlQIy6uIrL0Nvg71duaejrS5Ng65DY7mkcYqZLh0um
	 5Im0f/4WGHfB13DFvJ55+kmxVIWDjNT3YvQ4WS4QtFD4gpq3nRSLPdfuh5Aai2eUDj
	 Sizaon0gsCgqril8nrlevqCxDdy7//RcewiBGgl4=
Message-ID: <d22c863b-ea81-472c-b2a9-28f99e5b6f92@arm.com>
Date: Thu, 10 Sep 2026 11:27:54 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 10/20] KVM: arm64: coco: Disable Steal time accounting
 for coco guests
Content-Language: en-GB
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
 <6152fc41-65f0-460f-90b4-1454c11bcba6@arm.com>
 <CA+EHjTxjk1JLR7Tf5LEfB_xypbUWnw3G3H-FT7bTE=nWTTRgAA@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTxjk1JLR7Tf5LEfB_xypbUWnw3G3H-FT7bTE=nWTTRgAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad

On 09/09/2026 13:23, Fuad Tabba wrote:
> Hi Suzuki,
> 
> On Wed, 9 Sept 2026 at 12:52, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> ...
> 
>>> I think it would be better to leave KVM_CAP_STEAL_TIME reported and
>>> instead reject the configuration for these VMs, returning -EPERM from
>>> the KVM_ARM_VCPU_PVTIME_CTRL attr. A capability query should report
>>> what the kernel supports, not whether a given VM may use it; gating it
>>> per-VM here is also inconsistent, since the !kvm clause leaves the
>>> system-fd cap at 1 while the VM-fd cap reads 0. And -EPERM says that
>>
>>
>> But isn't that we want from a VMM perspective ? i.e., enable PVTIME if
>> it is supported for the given VM (type). Rather than PVTIME is supported
>> by the KVM, so I can go enable it by default. But, we endup getting a
>> failure while we enable it. I encountered this with kvmtool, where
>> CAP_STEAL_TIME is reported true and even the HAS_DEVICE_ATTR goes
>> through fine, but SET_DEVICE_ATTR seemed to fail.
>>
>> Isn't it better to allow the VM to decide if the capability is supported
>> for the given VM type, like we are doing for other capabilities ?
> 
> You're right, per-VM capability reporting. My wires got crossed from
> the pKVM series and the kvmtool fixes. However, I'd still return
> -EPERM rather than -ENXIO from the attribute. The capability exists,

Just to make sure I understand the picture:

For coco VMs:

  - check extension on coco KVM, KVM_CAP_STEAL_TIME => 0

And a follow up DEVICE_HAS_ATTR => -EPERM ?

But we tell the VMM, look you don't have the capabilit on this VM.
But if you try to set the attribute isn't it more appropriate to
say:
  -ENXIO - No you don't have that feature on this VM (-ENXIO)
rather than
  -EPERM - No, I won't let you do that.

Remember we are doing only in the "VM" context. It is a minor nit
but I wanted to make sure we understand what we are thinking.

Cheers
Suzuki

> it's just not permitted for a confidential VM, and -EPERM says exactly
> that, whereas -ENXIO reads as "no such feature".
> 
> Cheers,
> /fuad
> 
>>
>>> steal-time exists but isn't permitted for a confidential VM, whereas
>>> -ENXIO reads as "no such feature".
>>
>> Cheers
>> Suzuki
>>
>>
>>>
>>> Cheers,
>>> /fuad
>>>
>>>>
>>>>    int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
>>>> @@ -81,7 +81,7 @@ int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
>>>>           int ret = 0;
>>>>           int idx;
>>>>
>>>> -       if (!kvm_arm_pvtime_supported() ||
>>>> +       if (!kvm_arm_pvtime_supported(kvm) ||
>>>>               attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
>>>>                   return -ENXIO;
>>>>
>>>> @@ -110,7 +110,7 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
>>>>           u64 __user *user = (u64 __user *)attr->addr;
>>>>           u64 ipa;
>>>>
>>>> -       if (!kvm_arm_pvtime_supported() ||
>>>> +       if (!kvm_arm_pvtime_supported(vcpu->kvm) ||
>>>>               attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
>>>>                   return -ENXIO;
>>>>
>>>> @@ -126,7 +126,7 @@ int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
>>>>    {
>>>>           switch (attr->attr) {
>>>>           case KVM_ARM_VCPU_PVTIME_IPA:
>>>> -               if (kvm_arm_pvtime_supported())
>>>> +               if (kvm_arm_pvtime_supported(vcpu->kvm))
>>>>                           return 0;
>>>>           }
>>>>           return -ENXIO;
>>>> --
>>>> 2.43.0
>>>>
>>

