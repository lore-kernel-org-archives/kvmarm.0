From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH] arm64: KVM: VHE: save and restore some PSTATE bits
Date: Wed, 6 Sep 2017 13:30:43 +0100
Message-ID: <b7d8388d-d9df-9cc4-3d07-82e7f807017a@arm.com>
References: <0184EA26B2509940AA629AE1405DD7F2015DF717@DGGEMA503-MBX.china.huawei.com>
 <2a5d4299-2523-aef5-7db1-f351ca66b562@arm.com>
 <e47a9304-b429-b2bd-f151-d65f1c32044c@huawei.com>
 <981d7334-8841-d3e3-0833-1aa061bf97a2@arm.com>
 <62860a85-c29c-87bb-24b7-c6e5ac6065f9@huawei.com>
 <31b18967-c32a-1761-7e60-15c0de28203c@arm.com>
 <57ba125f-9c3c-3504-35a6-9800a47450cf@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <57ba125f-9c3c-3504-35a6-9800a47450cf@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, mark.rutland@arm.com, catalin.marinas@arm.com
Cc: James Morse <James.Morse@arm.com>, zhanghaibin7@huawei.com, Huangshaoyu <huangshaoyu@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/09/17 13:14, gengdongjiu wrote:
> 
> 
> On 2017/9/6 20:00, Vladimir Murzin wrote:
>> On 06/09/17 11:35, gengdongjiu wrote:
>>> Vladimir,
>>>
>>> On 2017/9/6 17:41, Vladimir Murzin wrote:
>>>> Can you please elaborate on cases where PAN is not enabled?
>>>
>>> I mean the informal private usage, For example, he disabled the PAN dynamically to let kernel space to access the user space.
>>> After he dynamic disabled the PAN, then switched to guest OS. after return to host. he found the PAN stage is modified.
>>> Of cause this is not a formal usage, in our host kernel, it is always enabled, no dynamic change, but I means it may exist such cases.
>>>
>>>
>>
>> So, in short, there is no real issue with PAN, right? What about UAO?
> For the PAN, if host OS dynamically enable/disable PAN should have issue.
> Do you think that is not a issue as above description?
> 
> "host OS dynamically disable the PAN, but after go back from the guest OS, The PAN is unexpectedly enabled"

Do you see effect of "PAN is unexpectedly enabled"?

Cheers
Vladimir

> 
>>
>> Cheers
>> Vladimir
>>
>> .
>>
> 
> 
