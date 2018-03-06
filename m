From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm: reserve bit in KVM_REG_ARM encoding for
 secure/nonsecure
Date: Tue, 6 Mar 2018 17:16:43 +0000
Message-ID: <90ed4785-bf17-02b6-7941-d9524c4642f6@arm.com>
References: <20180306162646.7646-1-peter.maydell@linaro.org>
 <4dbad5e5-8e62-4729-16f3-59ce1cfdd550@arm.com>
 <CAFEAcA9KYxtUzH+DtUR-zVXeFYeVA1orh-Y7+FkufxNZ6o8ivw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FB0D402DB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Mar 2018 12:09:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BFB0SGGOVGfm for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Mar 2018 12:09:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3639B402B8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Mar 2018 12:09:34 -0500 (EST)
In-Reply-To: <CAFEAcA9KYxtUzH+DtUR-zVXeFYeVA1orh-Y7+FkufxNZ6o8ivw@mail.gmail.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/03/18 16:56, Peter Maydell wrote:
> On 6 March 2018 at 16:43, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 06/03/18 16:26, Peter Maydell wrote:
>>> +/* For KVM currently all guest registers are nonsecure, but we reserve a bit
>>> + * in the encoding to distinguish secure from nonsecure for banked registers.
>>> + */
>>
>> Nit:
>>
>> /*
>>  * This is the canonical comment style.
>>  */
>>
>> It might be worth pointing out in the comment that this only applies to
>> AArch32 system registers that are banked by security.
> 
> Sure. How about
> 
> /*
>  * For KVM currently all guest registers are nonsecure, but we reserve a bit
>  * in the encoding to distinguish secure from nonsecure for AArch32 system
>  * registers that are banked by security. This is 1 for the secure banked
>  * register, and 0 for the nonsecure banked register or if the register is
>  * not banked by security.
>  */
> 
> ?

Looks good to me.

> 
>>> +#define KVM_REG_ARM_SECURE_MASK      0x0000000010000000
>>> +#define KVM_REG_ARM_SECURE_SHIFT     28
>>>
>>>  #define ARM_CP15_REG_SHIFT_MASK(x,n) \
>>>       (((x) << KVM_REG_ARM_ ## n ## _SHIFT) & KVM_REG_ARM_ ## n ## _MASK)
>>>
>>
>> Don't you also need to define it on the arm64 side?
> 
> I don't think so, because AArch64 registers aren't security banked
> (except for some GICv3 ones, which aren't set via GET/SET_ONE_REG.)
> Or is there a case I'm missing?

There is still the case of AArch32 guests on arm64, for which you'd need
to replicate the change to arch/arm64/include/uapi/asm/kvm.h. The two
architectures have different userspace APIs.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
