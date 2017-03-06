From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [PATCH v2] arm64: kvm: Use has_vhe() instead of
 hyp_alternate_select()
Date: Mon, 6 Mar 2017 07:45:38 -0600
Message-ID: <06920fd1-8efc-5ee3-b57f-6fa495199e43@codeaurora.org>
References: <1488767598-2055-1-git-send-email-shankerd@codeaurora.org>
 <87bmte3itj.fsf@on-the-bus.cambridge.arm.com>
Reply-To: shankerd@codeaurora.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 276A440A7B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 08:44:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h2zpWHYf4SDP for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 08:44:28 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2FBB640AF5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 08:44:27 -0500 (EST)
In-Reply-To: <87bmte3itj.fsf@on-the-bus.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,


On 03/06/2017 02:34 AM, Marc Zyngier wrote:
> Hi Shanker,
>
> On Mon, Mar 06 2017 at  2:33:18 am GMT, Shanker Donthineni <shankerd@codeaurora.org> wrote:
>> Now all the cpu_hwcaps features have their own static keys. We don't
>> need a separate function hyp_alternate_select() to patch the vhe/nvhe
>> code. We can achieve the same functionality by using has_vhe(). It
>> improves the code readability, uses the jump label instructions, and
>> also compiler generates the better code with a fewer instructions.
> How do you define "better"? Which compiler? Do you have any benchmarking data?
I'm using gcc version 5.2.0. With has_vhe() it shows the smaller code 
size as shown below. I tried to benchmark
the code changes using Cristiffer's microbench tool, but not seeing a 
noticeable difference on QDF2400 platform.

hyp_alternate_select() uses BR/BLR instructions to patch vhe/mvhe code, 
which is not good for branch prediction purpose.
compiler treats patched code as a function call, so the contents of the 
registers x0-x18 are not reusable after vhe/nvhe call.

Current code:
arch/arm64/kvm/hyp/switch.o:     file format elf64-littleaarch64

Sections:
Idx Name          Size      VMA               LMA               File 
off  Algn
   0 .text         00000000  0000000000000000  0000000000000000 
00000040  2**0
                   CONTENTS, ALLOC, LOAD, READONLY, CODE
   1 .data         00000000  0000000000000000  0000000000000000 
00000040  2**0
                   CONTENTS, ALLOC, LOAD, DATA
   2 .bss          00000000  0000000000000000  0000000000000000 
00000040  2**0
                   ALLOC
   3 .hyp.text     00000550  0000000000000000  0000000000000000 
00000040  2**3
                   CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE

New code:
arch/arm64/kvm/hyp/switch.o:     file format elf64-littleaarch64

Sections:
Idx Name          Size      VMA               LMA               File 
off  Algn
   0 .text         00000000  0000000000000000  0000000000000000 
00000040  2**0
                   CONTENTS, ALLOC, LOAD, READONLY, CODE
   1 .data         00000000  0000000000000000  0000000000000000 
00000040  2**0
                   CONTENTS, ALLOC, LOAD, DATA
   2 .bss          00000000  0000000000000000  0000000000000000 
00000040  2**0
                   ALLOC
   3 .hyp.text     00000488  0000000000000000  0000000000000000 
00000040  2**3
                   CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE


>> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
>> ---
>> v2: removed 'Change-Id: Ia8084189833f2081ff13c392deb5070c46a64038' from commit
>>
>>   arch/arm64/kvm/hyp/debug-sr.c  | 12 ++++++----
>>   arch/arm64/kvm/hyp/switch.c    | 50 +++++++++++++++++++-----------------------
>>   arch/arm64/kvm/hyp/sysreg-sr.c | 23 +++++++++----------
>>   3 files changed, 43 insertions(+), 42 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
>> index f5154ed..e5642c2 100644
>> --- a/arch/arm64/kvm/hyp/debug-sr.c
>> +++ b/arch/arm64/kvm/hyp/debug-sr.c
>> @@ -109,9 +109,13 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
>>   	dsb(nsh);
>>   }
>>   
>> -static hyp_alternate_select(__debug_save_spe,
>> -			    __debug_save_spe_nvhe, __debug_save_spe_vhe,
>> -			    ARM64_HAS_VIRT_HOST_EXTN);
>> +static void __hyp_text __debug_save_spe(u64 *pmscr_el1)
>> +{
>> +	if (has_vhe())
>> +		__debug_save_spe_vhe(pmscr_el1);
>> +	else
>> +		__debug_save_spe_nvhe(pmscr_el1);
>> +}
> I have two worries about this kind of thing:
> - Not all compilers do support jump labels, leading to a memory access
> on each static key (GCC 4.8, for example). This would immediately
> introduce a pretty big regression
> - The hyp_alternate_select() method doesn't introduce a fast/slow path
> duality. Each path has the exact same cost. I'm not keen on choosing
> what is supposed to be the fast path, really.
Yes, it'll require a runtime check if the compiler doesn't support ASM 
GOTO labels.
Agree, hyp_alternate_select() has a constant branch over head but it 
might cause a branch prediction penality.

> Thanks,
>
> 	M.

-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
