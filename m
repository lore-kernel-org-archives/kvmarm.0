From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm64: remove all traces of the ThumbEE registers
Date: Wed, 16 Sep 2015 18:34:25 +0100
Message-ID: <55F9A821.1000707@arm.com>
References: <1442333733-16347-1-git-send-email-will.deacon@arm.com> <CAFEAcA94VNogBEGh9ohB3M8fEqfLRPWVj8yaCK-3HGa-ht2fLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA94VNogBEGh9ohB3M8fEqfLRPWVj8yaCK-3HGa-ht2fLg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>, Will Deacon <will.deacon@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 15/09/15 17:23, Peter Maydell wrote:
> On 15 September 2015 at 17:15, Will Deacon <will.deacon@arm.com> wrote:
>> Although the ThumbEE registers and traps were present in earlier
>> versions of the v8 architecture, it was retrospectively removed and so
>> we can do the same.
>>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Will Deacon <will.deacon@arm.com>
> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index b41607d270ac..6c35e49757d8 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -539,13 +539,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>>         { Op0(0b10), Op1(0b000), CRn(0b0111), CRm(0b1110), Op2(0b110),
>>           trap_dbgauthstatus_el1 },
>>
>> -       /* TEECR32_EL1 */
>> -       { Op0(0b10), Op1(0b010), CRn(0b0000), CRm(0b0000), Op2(0b000),
>> -         NULL, reset_val, TEECR32_EL1, 0 },
>> -       /* TEEHBR32_EL1 */
>> -       { Op0(0b10), Op1(0b010), CRn(0b0001), CRm(0b0000), Op2(0b000),
>> -         NULL, reset_val, TEEHBR32_EL1, 0 },
>> -
> 
> I guess this is a VM migration compatibility break between kernels
> without this patch and kernels with it? I think that's OK at this
> point, but it would be nice to mention it in the commit message.

I'll add comment to that effect.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
