Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D187C;
	Tue, 25 Jul 2023 01:13:48 +0000 (UTC)
Received: from loongson.cn (unknown [10.20.42.170])
	by gateway (Coremail) with SMTP id _____8CxtPDLIb9kAX8JAA--.24165S3;
	Tue, 25 Jul 2023 09:13:47 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxbSPGIb9kHvg5AA--.41852S3;
	Tue, 25 Jul 2023 09:13:42 +0800 (CST)
Message-ID: <5cb437f8-2e33-55b2-d5e4-2c5757af8b44@loongson.cn>
Date: Tue, 25 Jul 2023 09:13:42 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [Question - ARM CCA] vCPU Hotplug Support in ARM Realm world
 might require ARM spec change?
Content-Language: en-US
To: Salil Mehta <salil.mehta@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>,
 "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "mark.rutland@arm.com" <mark.rutland@arm.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 Salil Mehta <salil.mehta@opnsrc.net>,
 "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
 yuzenghui <yuzenghui@huawei.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "steven.price@arm.com" <steven.price@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
References: <9cb24131a09a48e9a622e92bf8346c9d@huawei.com>
 <2fa14ef5-b2f7-459d-8b84-114d36ba3cf7@loongson.cn>
 <d13c4cb44a2b4b42a8b534c38c402a1d@huawei.com>
From: bibo mao <maobibo@loongson.cn>
In-Reply-To: <d13c4cb44a2b4b42a8b534c38c402a1d@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxbSPGIb9kHvg5AA--.41852S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3JFyktw1rZFy5Gw4rKFW7trc_yoW7tryxpF
	WrGFs0grWkJr40kw4vvFy5uFWYvrW8Jay2qrn3try8ua4DAFn7Cr4S9a15uF9xZF1xCFyI
	vF1avr97ua45XFXCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_GFv_Wrylx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUcApnDUUUU



在 2023/7/25 08:56, Salil Mehta 写道:
> Hi Bibo,
> 
>> From: bibo mao <maobibo@loongson.cn>
>> Sent: Tuesday, July 25, 2023 1:29 AM
>> To: Salil Mehta <salil.mehta@huawei.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>; Marc Zyngier <maz@kernel.org>; Will Deacon
>> <will@kernel.org>; christoffer.dall@arm.com; oliver.upton@linux.dev;
>> mark.rutland@arm.com; pbonzini@redhat.com; Salil Mehta
>> <salil.mehta@opnsrc.net>; andrew.jones@linux.dev; yuzenghui
>> <yuzenghui@huawei.com>; kvmarm@lists.cs.columbia.edu; linux-arm-
>> kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
>> kvm@vger.kernel.org; qemu-devel@nongnu.org; james.morse@arm.com;
>> steven.price@arm.com; Suzuki K Poulose <suzuki.poulose@arm.com>; Jean-
>> Philippe Brucker <jean-philippe@linaro.org>; kvmarm@lists.linux.dev; linux-
>> coco@lists.linux.dev
>> Subject: Re: [Question - ARM CCA] vCPU Hotplug Support in ARM Realm world
>> might require ARM spec change?
>>
>> Is vcpu hotplug supported in arm virt-machine now?
> 
> Not yet. We are working on it. Please check the RFCs being tested.
> 
> 
> [1] Pre-RFC V2 Changes: Support of Virtual CPU Hotplug for ARMv8 Arch  (WIP)
>     https://github.com/salil-mehta/qemu.git virt-cpuhp-armv8/rfc-v1-port11052023.dev-1
> [2] [RFC PATCH 00/32] ACPI/arm64: add support for virtual cpuhotplug  
>     https://git.gitlab.arm.com/linux-arm/linux-jm.git virtual_cpu_hotplug/rfc/v2
>     
>     
>> There is arm64 vcpu hotplug patch in qemu mailing list, however it is not merged.
>> I do not know why it is not merged.
> 
> 
> I think you are referring to patches [3], [4]? Please follow the discussion
> for details. 
yeap, we reference the patch [3], [4] and benefit from them greatly -:)

The patch for LoongArch vcpu hotplug link is:
https://lore.kernel.org/qemu-devel/cover.1689837093.git.lixianglai@loongson.cn/T/#t


Regards
Bibo Mao

> 
> 
> [3] [PATCH RFC 00/22] Support of Virtual CPU Hotplug for ARMv8 Arch
>     https://lore.kernel.org/all/20200613213629.21984-1-salil.mehta@huawei.com/
> [4] [PATCH RFC 0/4] Changes to Support *Virtual* CPU Hotplug for ARM64
>     https://lore.kernel.org/all/20200625133757.22332-1-salil.mehta@huawei.com/#r
> 
> 
> In summary, there were some ARM64 Architecture constraints which were being
> violated in the earlier patches of the kernel [4] so we had to re-think of the
> kernel changes. The Qemu part mostly remains same with some new introductions
> of Guest HVC/SMC hyper call exit handling in user space etc. for policy checks
> in VMM/Qemu. 
> 
> 
> You can follow the KVMForum conference presentations [5], [6] delivered in the
> year 2020 and 2023 to get hold of more details related to this.
> 
> 
> [5] KVMForum 2023: Challenges Revisited in Supporting Virt CPU Hotplug on architectures that don't Support CPU Hotplug (like ARM64)
>     https://kvm-forum.qemu.org/2023/talk/9SMPDQ/
> [6] KVMForum 2020: Challenges in Supporting Virtual CPU Hotplug on SoC Based Systems (like ARM64)
>     https://kvmforum2020.sched.com/event/eE4m
> 
> 
> 
>> I ask this question because we propose
>> similar patch about LoongArch system in qemu mailing list, and kernel need not be
>> modified for vcpu hotplug.
> 
> 
> Could you please share the link of your patches so that we can have a look and
> draw a comparison?
> 
> 
> Thanks
> Salil.
> 
>>
>> Regards
>> Bibo, mao
>>
>> 在 2023/7/19 10:35, Salil Mehta 写道:
>>> [Reposting it here from Linaro Open Discussion List for more eyes to look
>> at]
>>>
>>> Hello,
>>> I have recently started to dabble with ARM CCA stuff and check if our
>>> recent changes to support vCPU Hotplug in ARM64 can work in the realm
>>> world. I have realized that in the RMM specification[1] PSCI_CPU_ON
>>> command(B5.3.3) does not handles the PSCI_DENIED return code(B5.4.2),
>>> from the host. This might be required to support vCPU Hotplug feature
>>> in the realm world in future. vCPU Hotplug is an important feature to
>>> support kata-containers in realm world as it reduces the VM boot time
>>> and facilitates dynamic adjustment of vCPUs (which I think should be
>>> true even with Realm world as current implementation only makes use
>>> of the PSCI_ON/OFF to realize the Hotplug look-like effect?)
>>>
>>>
>>> As per our recent changes [2], [3] related to support vCPU Hotplug on
>>> ARM64, we handle the guest exits due to SMC/HVC Hypercall in the
>>> user-space i.e. VMM/Qemu. In realm world, REC Exits to host due to
>>> PSCI_CPU_ON should undergo similar policy checks and I think,
>>>
>>> 1. Host should *deny* to online the target vCPUs which are NOT plugged
>>> 2. This means target REC should be denied by host. Can host call
>>>    RMI_PSCI_COMPETE in such s case?
>>> 3. The *return* value (B5.3.3.1.3 Output values) should be PSCI_DENIED
>>> 4. Failure condition (B5.3.3.2) should be amended with
>>>    runnable pre: target_rec.flags.runnable == NOT_RUNNABLE (?)
>>>             post: result == PSCI_DENIED (?)
>>> 5. Change would also be required in the flow (D1.4 PSCI flows) depicting
>>>    PSCI_CPU_ON flow (D1.4.1)
>>>
>>>
>>> I do understand that ARM CCA support is in its infancy stage and
>>> discussing about vCPU Hotplug in realm world seem to be a far-fetched
>>> idea right now. But specification changes require lot of time and if
>>> this change is really required then it should be further discussed
>>> within ARM.
>>>
>>> Many thanks!
>>>
>>>
>>> Bes regards
>>> Salil
>>>
>>>
>>> References:
>>>
>>> [1] https://developer.arm.com/documentation/den0137/latest/
>>> [2] https://github.com/salil-mehta/qemu.git virt-cpuhp-armv8/rfc-v1-port11052023.dev-1
>>> [3] https://git.gitlab.arm.com/linux-arm/linux-jm.git virtual_cpu_hotplug/rfc/v2

