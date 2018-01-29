From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 14/14] arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP hardening support
Date: Mon, 29 Jan 2018 09:42:50 +0000
Message-ID: <CAKv+Gu88To1dsV2Av2b5fsAZw9YOnyOMas5sZOXncdUSBSY2nw@mail.gmail.com>
References: <20180126142847.31240-1-marc.zyngier@arm.com> <20180126142847.31240-15-marc.zyngier@arm.com>
 <CAKv+Gu_1=Z=KaiW=Ltj4a31A5a-XFzPfc0SMk0E5PAwdGDAhMg@mail.gmail.com> <8c487a64-ec34-5fe8-cc78-5c280051675e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8c487a64-ec34-5fe8-cc78-5c280051675e@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Jon Masters <jcm@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 29 January 2018 at 09:36, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 28/01/18 23:08, Ard Biesheuvel wrote:
>> On 26 January 2018 at 14:28, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> Add the detection and runtime code for ARM_SMCCC_ARCH_WORKAROUND_1.
>>> It is lovely. Really.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  arch/arm64/kernel/bpi.S        | 20 ++++++++++++
>>>  arch/arm64/kernel/cpu_errata.c | 71 +++++++++++++++++++++++++++++++++++++++++-
>>>  2 files changed, 90 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
>>> index 76225c2611ea..add7e08a018d 100644
>>> --- a/arch/arm64/kernel/bpi.S
>>> +++ b/arch/arm64/kernel/bpi.S
>>> @@ -17,6 +17,7 @@
>>>   */
>>>
>>>  #include <linux/linkage.h>
>>> +#include <linux/arm-smccc.h>
>>>
>>>  .macro ventry target
>>>         .rept 31
>>> @@ -85,3 +86,22 @@ ENTRY(__qcom_hyp_sanitize_link_stack_start)
>>>         .endr
>>>         ldp     x29, x30, [sp], #16
>>>  ENTRY(__qcom_hyp_sanitize_link_stack_end)
>>> +
>>> +.macro smccc_workaround_1 inst
>>> +       sub     sp, sp, #(8 * 4)
>>> +       stp     x2, x3, [sp, #(16 * 0)]
>>> +       stp     x0, x1, [sp, #(16 * 1)]
>>> +       orr     w0, wzr, #ARM_SMCCC_ARCH_WORKAROUND_1
>>> +       \inst   #0
>>> +       ldp     x2, x3, [sp, #(16 * 0)]
>>> +       ldp     x0, x1, [sp, #(16 * 1)]
>>> +       add     sp, sp, #(8 * 4)
>>> +.endm
>>> +
>>> +ENTRY(__smccc_workaround_1_smc_start)
>>> +       smccc_workaround_1      smc
>>> +ENTRY(__smccc_workaround_1_smc_end)
>>> +
>>> +ENTRY(__smccc_workaround_1_hvc_start)
>>> +       smccc_workaround_1      hvc
>>> +ENTRY(__smccc_workaround_1_hvc_end)
>>> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
>>> index ed6881882231..f1501873f2e4 100644
>>> --- a/arch/arm64/kernel/cpu_errata.c
>>> +++ b/arch/arm64/kernel/cpu_errata.c
>>> @@ -70,6 +70,10 @@ DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
>>>  extern char __psci_hyp_bp_inval_start[], __psci_hyp_bp_inval_end[];
>>>  extern char __qcom_hyp_sanitize_link_stack_start[];
>>>  extern char __qcom_hyp_sanitize_link_stack_end[];
>>> +extern char __smccc_workaround_1_smc_start[];
>>> +extern char __smccc_workaround_1_smc_end[];
>>> +extern char __smccc_workaround_1_hvc_start[];
>>> +extern char __smccc_workaround_1_hvc_end[];
>>>
>>>  static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
>>>                                 const char *hyp_vecs_end)
>>> @@ -116,6 +120,10 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
>>>  #define __psci_hyp_bp_inval_end                        NULL
>>>  #define __qcom_hyp_sanitize_link_stack_start   NULL
>>>  #define __qcom_hyp_sanitize_link_stack_end     NULL
>>> +#define __smccc_workaround_1_smc_start         NULL
>>> +#define __smccc_workaround_1_smc_end           NULL
>>> +#define __smccc_workaround_1_hvc_start         NULL
>>> +#define __smccc_workaround_1_hvc_end           NULL
>>>
>>>  static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
>>>                                       const char *hyp_vecs_start,
>>> @@ -142,17 +150,78 @@ static void  install_bp_hardening_cb(const struct arm64_cpu_capabilities *entry,
>>>         __install_bp_hardening_cb(fn, hyp_vecs_start, hyp_vecs_end);
>>>  }
>>>
>>> +#include <uapi/linux/psci.h>
>>> +#include <linux/arm-smccc.h>
>>>  #include <linux/psci.h>
>>>
>>> +static void call_smc_arch_workaround_1(void)
>>> +{
>>> +       register int w0 asm("w0") = ARM_SMCCC_ARCH_WORKAROUND_1;
>>> +       asm volatile("smc       #0\n"
>>> +                    : "+r" (w0));
>>> +}
>>> +
>>> +static void call_hvc_arch_workaround_1(void)
>>> +{
>>> +       register int w0 asm("w0") = ARM_SMCCC_ARCH_WORKAROUND_1;
>>> +       asm volatile("hvc       #0\n"
>>> +                    : "+r" (w0));
>>> +}
>>> +
>>> +static bool check_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
>>> +{
>>> +       bp_hardening_cb_t cb;
>>> +       void *smccc_start, *smccc_end;
>>> +       struct arm_smccc_res res;
>>> +
>>> +       if (psci_ops.variant == SMCCC_VARIANT_1_0)
>>> +               return false;
>>> +
>>> +       switch (psci_ops.conduit) {
>>> +       case PSCI_CONDUIT_HVC:
>>> +               arm_smccc_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
>>> +                             ARM_SMCCC_ARCH_WORKAROUND_1, 0, 0, 0, 0, 0, 0,
>>> +                             &res);
>>> +               if (res.a0)
>>> +                       return false;
>>> +               cb = call_hvc_arch_workaround_1;
>>> +               smccc_start = __smccc_workaround_1_hvc_start;
>>> +               smccc_end = __smccc_workaround_1_hvc_end;
>>> +               break;
>>> +
>>> +       case PSCI_CONDUIT_SMC:
>>> +               arm_smccc_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
>>> +                             ARM_SMCCC_ARCH_WORKAROUND_1, 0, 0, 0, 0, 0, 0,
>>> +                             &res);
>>
>> This compiles to
>>
>>  4a8:   928fffe1        mov     x1, #0xffffffffffff8000         // #-32768
>>  4ac:   b26187e0        mov     x0, #0xffffffff80000001         // #-2147483647
>>  4b0:   d2800007        mov     x7, #0x0                        // #0
>>  4b4:   d2800006        mov     x6, #0x0                        // #0
>>  4b8:   d2800005        mov     x5, #0x0                        // #0
>>  4bc:   d2800004        mov     x4, #0x0                        // #0
>>  4c0:   d2800003        mov     x3, #0x0                        // #0
>>  4c4:   d2800002        mov     x2, #0x0                        // #0
>>  4c8:   f2b00001        movk    x1, #0x8000, lsl #16
>>  4cc:   94000000        bl      0 <__arm_smccc_smc>
>>
>> so it seems we're missing a UL suffix somewhere.
>
> Yeah, this seems to stem from ARM_SMCCC_FAST_CALL, which is bit 31 and
> isn't advertised as unsigned. It still works because both x0 and x1 are
> used as 32bit quantities in this particular SMC context, but that has
> the potential of triggering unexpected behaviours in broken implementations.
>

Are you sure about that? To me, it looks like this code

static int32_t smccc_arch_features(u_register_t arg)
{
    switch (arg) {
    case SMCCC_VERSION:
    case SMCCC_ARCH_FEATURES:
        return SMC_OK;
#if WORKAROUND_CVE_2017_5715
    case SMCCC_ARCH_WORKAROUND_1:
        return SMC_OK;
#endif
    default:
        return SMC_UNK;
    }
}

will end up comparing 0xffffffff80008000 to 0x80008000, and fail
(which is what it did when I tried it)



>> Also, adding some printks here reveals that this function is called 32
>> times in total, i.e., 4 times per CPU on my Overdrive. This is with
>> the patches applied onto v4.15-rc9, so perhaps the rework takes care
>> of this?
>
> There is some ugly explosion in the number of callbacks as all of the
> various implementations all share the same capability number. We can
> take a shortcut and do an MIDR check early instead of late though.
>
> But Suzuki is also reworking some of this, so I'll have a check with him.
>
> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny...
