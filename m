From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 08/20] arm64: entry.S: convert elX_irq
Date: Thu, 12 Oct 2017 13:26:29 +0100
Message-ID: <59DF5F75.1050009@arm.com>
References: <20171005191812.5678-1-james.morse@arm.com>
 <20171005191812.5678-9-james.morse@arm.com>
 <ae8a4e66-0a07-3e1a-9ac9-adf8b6b60b06@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9819F49D37
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 08:27:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id khq0ixg8Ia93 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 08:27:23 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 772DF49D31
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 08:27:23 -0400 (EDT)
In-Reply-To: <ae8a4e66-0a07-3e1a-9ac9-adf8b6b60b06@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Julien,

On 11/10/17 18:13, Julien Thierry wrote:
> On 05/10/17 20:18, James Morse wrote:
>> Following our 'dai' order, irqs should be processed with debug and
>> serror exceptions unmasked.
>>  > Add a helper to unmask these two, (and fiq for good measure).
>>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> ---
>>   arch/arm64/include/asm/assembler.h | 4 ++++
>>   arch/arm64/kernel/entry.S          | 4 ++--
>>   2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/assembler.h
>> b/arch/arm64/include/asm/assembler.h
>> index c2a37e2f733c..7ffb2a629dc9 100644
>> --- a/arch/arm64/include/asm/assembler.h
>> +++ b/arch/arm64/include/asm/assembler.h
>> @@ -54,6 +54,10 @@
>>       msr    daif, \tmp
>>       .endm
>>   +    .macro enable_da_f
>> +    msr    daifclr, #(8 | 4 | 1)
>> +    .endm
>> +
> 
> We use this in irq entries because we are inheriting daif + we want to disable
> irqs while we process irqs right?

In this case not inheriting, we only do that for synchronous exceptions because
we can't mask them, keeping the flags 'the same' lets us ignore them.

Here we are unconditionally unmasking things for handling interrupts. If we
stick with this dai order we know its safe to unmask SError and enable Debug.


> I don't know if it's worth adding a comment but I find it easier to think about
> it like this.

If its not-obvious, there should be a comment:
/* IRQ is the lowest priority flag, unconditionally unmask the rest. */


(I was expecting flames for the hangman style naming!)

> Otherwise, for patches 3 to 8 (I don't have any comment on 3 to 7):
> Reviewed-by: Julien Thierry <julien.thierry@arm.com>

Thanks!

I'll post a v4 ~tomorrow with this and the renaming changes.



James
