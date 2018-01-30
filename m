From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 15/16] arm/arm64: smccc: Implement SMCCC v1.1 inline
 primitive
Date: Tue, 30 Jan 2018 12:29:30 +0000
Message-ID: <CAKv+Gu-3FUTE+=j6KG=zvALYPcFzW+tk6Rgi7ss7bsuNMkpFrQ@mail.gmail.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
 <20180129174559.1866-16-marc.zyngier@arm.com>
 <CAKv+Gu_aXX70tLL+kyHDy-=4+ZiTEmOtMbfzt5oqs41B6ag1kg@mail.gmail.com>
 <03484caa-2e18-7126-7d99-8d0b1e0a83c6@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <03484caa-2e18-7126-7d99-8d0b1e0a83c6@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoffer Dall <christoffer.dall@linaro.org>, Jon Masters <jcm@redhat.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 30 January 2018 at 12:27, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 29/01/18 21:45, Ard Biesheuvel wrote:
>> On 29 January 2018 at 17:45, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> One of the major improvement of SMCCC v1.1 is that it only clobbers
>>> the first 4 registers, both on 32 and 64bit. This means that it
>>> becomes very easy to provide an inline version of the SMC call
>>> primitive, and avoid performing a function call to stash the
>>> registers that would otherwise be clobbered by SMCCC v1.0.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  include/linux/arm-smccc.h | 157 ++++++++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 157 insertions(+)
>>>
>>> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
>>> index dd44d8458c04..bc5843728909 100644
>>> --- a/include/linux/arm-smccc.h
>>> +++ b/include/linux/arm-smccc.h
>>> @@ -150,5 +150,162 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
>>>
>>>  #define arm_smccc_hvc_quirk(...) __arm_smccc_hvc(__VA_ARGS__)
>>>
>>> +/* SMCCC v1.1 implementation madness follows */
>>> +#ifdef CONFIG_ARM64
>>> +
>>> +#define SMCCC_SMC_INST "smc    #0"
>>> +#define SMCCC_HVC_INST "hvc    #0"
>>> +
>>> +#define __arm_smccc_1_1_prologue(inst)                                 \
>>> +       inst "\n"                                                       \
>>> +       "cbz    %[ptr], 1f\n"                                           \
>>> +       "stp    %x[r0], %x[r1], %[ra0]\n"                               \
>>> +       "stp    %x[r2], %x[r3], %[ra2]\n"                               \
>>> +       "1:\n"                                                          \
>>> +       : [ra0] "=Ump" (*(&___res->a0)),                                \
>>> +         [ra2] "=Ump" (*(&___res->a2)),
>>> +
>>> +#define __arm_smccc_1_1_epilogue       : "memory"
>>> +
>>> +#endif
>>> +
>>> +#ifdef CONFIG_ARM
>>> +#include <asm/opcodes-sec.h>
>>> +#include <asm/opcodes-virt.h>
>>> +
>>> +#define SMCCC_SMC_INST __SMC(0)
>>> +#define SMCCC_HVC_INST __HVC(0)
>>> +
>>> +#define __arm_smccc_1_1_prologue(inst)                                 \
>>> +       inst "\n"                                                       \
>>> +       "cmp    %[ptr], #0\n"                                           \
>>> +       "stmne  %[ptr], {%[r0], %[r1], %[r2], %[r3]}\n"                 \
>>> +       : "=m" (*___res),
>>> +
>>> +#define __arm_smccc_1_1_epilogue       : "memory", "cc"
>>> +
>>> +#endif
>>> +
>>> +#define __constraint_write_0                                           \
>>> +       [r0] "+r" (r0), [r1] "=r" (r1), [r2] "=r" (r2), [r3] "=r" (r3)
>>> +#define __constraint_write_1                                           \
>>> +       [r0] "+r" (r0), [r1] "+r" (r1), [r2] "=r" (r2), [r3] "=r" (r3)
>>> +#define __constraint_write_2                                           \
>>> +       [r0] "+r" (r0), [r1] "+r" (r1), [r2] "+r" (r2), [r3] "=r" (r3)
>>> +#define __constraint_write_3                                           \
>>> +       [r0] "+r" (r0), [r1] "+r" (r1), [r2] "+r" (r2), [r3] "+r" (r3)
>>
>> It seems you need +r for all arguments, otherwise the compiler will
>> notice that the value is never used, and may assign the register to
>> 'res' instead, i.e.,
>>
>>  3e4:   320107e0        mov     w0, #0x80000001                 // #-2147483647
>>  3e8:   320183e1        mov     w1, #0x80008000                 // #-2147450880
>>  3ec:   910123a2        add     x2, x29, #0x48
>>  3f0:   d4000002        hvc     #0x0
>>  3f4:   b4000062        cbz     x2, 400 <enable_psci_bp_hardening+0x88>
>>  3f8:   a90487a0        stp     x0, x1, [x29, #72]
>>  3fc:   a9058fa2        stp     x2, x3, [x29, #88]
>>
>> (for the code generated in the next patch)
>
> Well spotted.
>
> I think this is because of the lack of early-clobber for the unassigned
> registers. The compiler assumes the whole sequence is a single
> instruction, with the output registers being affected at the end. If we
> mark those with '=&r', we will prevent GCC from emitting this kind of
> horror.
>

Tried that, actually, but it still doesn't help. It simply notices
that r2 (in this case) is not referenced after the asm () [nor before]
and so it simply seems to forget all about it, and reassigns it to
something else.

> Note that with Robin's trick of moving the assignment back to C code,
> this is a bit moot as this is really a single instruction (smc/hvc), and
> there is no intermediate register evaluation.
>

Yeah, that does look much better.
