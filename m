From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: VHE: reset PSTATE.UAO when switch to host
Date: Thu, 7 Sep 2017 11:13:46 +0100
Message-ID: <ec27c833-c9f7-d144-3c6f-a87a3bf3d97f@arm.com>
References: <1504763684-30128-1-git-send-email-gengdongjiu@huawei.com>
 <59B10F52.9010400@arm.com> <f710f68a-1e89-85a6-41a6-afc7588114db@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f710f68a-1e89-85a6-41a6-afc7588114db@huawei.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>, James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, vladimir.murzin@arm.com, rkrcmar@redhat.com, catalin.marinas@arm.com, shankerd@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zhanghaibin7@huawei.com, huangshaoyu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 07/09/17 11:05, gengdongjiu wrote:
> Hi James,
> 
> On 2017/9/7 17:20, James Morse wrote:
>> Hi Dongjiu Geng,
>>
>> On 07/09/17 06:54, Dongjiu Geng wrote:
>>> In VHE mode, host kernel runs in the EL2 and can enable
>>> 'User Access Override' when fs==KERNEL_DS so that it can
>>> access kernel memory. However, PSTATE.UAO is set to 0 on
>>> an exception taken from EL1 to EL2. Thus when VHE is used
>>> and exception taken from a guest UAO will be disabled and
>>> host will use the incorrect PSTATE.UAO. So check and reset
>>> the PSTATE.UAO when switching to host.
>>
>> This would only be a problem if KVM were calling into world-switch with
>> fs==KERNEL_DS. I can't see where this happens.
>  Not only KVM, may also kernel sets the fs == KERNEL_DS before calling into world-switch

How? Please describe the exact sequence of event that lead to this
situation with the current code base.

	M.
-- 
Jazz is not dead. It just smells funny...
