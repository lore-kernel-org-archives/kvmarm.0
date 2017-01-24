From: Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH 2/2] arm64: kvm: upgrade csselr and ccsidr to 64-bit values
Date: Tue, 24 Jan 2017 10:55:24 +0000
Message-ID: <de64fbcb-8e0d-b2b9-38b4-59f033a6cf6b@arm.com>
References: <1484909410-11673-1-git-send-email-sudeep.holla@arm.com>
 <1484909410-11673-2-git-send-email-sudeep.holla@arm.com>
 <20170123210859.GJ15850@cbox> <fe2bde22-63dc-3abf-5870-21360b16bf6b@arm.com>
 <20170124103041.GK15850@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2E6840838
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Jan 2017 05:55:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VJLnXhJQRZXh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Jan 2017 05:55:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03A8840194
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Jan 2017 05:55:21 -0500 (EST)
In-Reply-To: <20170124103041.GK15850@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 24/01/17 10:30, Christoffer Dall wrote:
> On Tue, Jan 24, 2017 at 10:15:38AM +0000, Sudeep Holla wrote:
>>
>>
>> On 23/01/17 21:08, Christoffer Dall wrote:
>>> On Fri, Jan 20, 2017 at 10:50:10AM +0000, Sudeep Holla wrote:
>>>> csselr and ccsidr are treated as 64-bit values already elsewhere in the
>>>> kernel. It also aligns well with the architecture extensions that allow
>>>> 64-bit format for ccsidr.
>>>>
>>>> This patch upgrades the existing accesses to csselr and ccsidr from
>>>> 32-bit to 64-bit in preparation to add support to those extensions.
>>>>
>>>> Cc: Christoffer Dall <christoffer.dall@linaro.org>
>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>>>> ---
>>>>  arch/arm64/kvm/sys_regs.c | 18 +++++++++---------
>>>>  1 file changed, 9 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>> index 5dca1f10340f..a3559a8a2b0c 100644
>>>> --- a/arch/arm64/kvm/sys_regs.c
>>>> +++ b/arch/arm64/kvm/sys_regs.c
>>
>> [..]
>>
>>>> @@ -2004,8 +2004,8 @@ static int demux_c15_get(u64 id, void __user *uaddr)
>>>>  
>>>>  static int demux_c15_set(u64 id, void __user *uaddr)
>>>>  {
>>>> -	u32 val, newval;
>>>> -	u32 __user *uval = uaddr;
>>>> +	u64 val, newval;
>>>> +	u64 __user *uval = uaddr;
>>>
>>> Doesn't converting these uval pointers to u64 cause us to break the ABI
>>> as we'll now be reading/writing 64-bit values to userspace with the
>>> get_user and put_user following the declarations?
>>>
>>
>> Yes, I too have similar concern. IIUC it is always read via kvm_one_reg
>> structure. I could not find any specific user for this register to cross
>> check.
>>
> 
> Not sure it matters which interface we get the userspace pointer from?
> 

Agreed.

> This patch is definitely changing the write from a 32-bit write to a
> 64-bit write and there's a specific check prior to the put_user() call
> which checks that userspace intended a 32-bit value and presumably
> provided a 32-bit pointer.
> 

I see you point, I missed to see that check(just to be sure KVM_REG_SIZE
check right ?).

> So I think the only way to return 64-bit AArch32 system register values
> to userspace (if that is the intention) is to define a new ID for 64-bit
> CCSIDR registers and handle them separately.
> 

I will add KVM_REG_ARM_DEMUX_ID_CCSIDR_64B or something similar.
Thanks for the review.

-- 
Regards,
Sudeep
