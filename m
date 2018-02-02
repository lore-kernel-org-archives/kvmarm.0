From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 1/2] ARM: kvm: fix building with gcc-8
Date: Fri, 2 Feb 2018 16:30:49 +0000
Message-ID: <276d0fe2-c742-7c95-f549-f2e49f13baac@arm.com>
References: <20180202150756.420422-1-arnd@arndb.de>
 <2cff070a-357d-c5f5-9ec6-036d93112ce4@arm.com>
 <e5afa875-56a5-fca4-1fdd-2c0968b35790@arm.com>
 <CAK8P3a0s_muecNBYTn5EvOPrg11Kuc9NKn0Hiqu4PAE2mTQ+-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0s_muecNBYTn5EvOPrg11Kuc9NKn0Hiqu4PAE2mTQ+-A@mail.gmail.com>
Content-Language: en-GB
Sender: stable-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Russell King <linux@armlinux.org.uk>, Andi Kleen <ak@linux.intel.com>, Julien Thierry <julien.thierry@arm.com>, Nicolas Pitre <nico@linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "# 3.4.x" <stable@vger.kernel.org>, Richard Earnshaw <rearnsha@gcc.gnu.org>, Tamar Christina <tnfchris@gcc.gnu.org>, kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 02/02/18 16:29, Arnd Bergmann wrote:
> On Fri, Feb 2, 2018 at 5:23 PM, Robin Murphy <robin.murphy@arm.com> wrote:
>> On 02/02/18 15:55, Robin Murphy wrote:
>>>
>>> On 02/02/18 15:07, Arnd Bergmann wrote:
>>>>
>>>> In banked-sr.c, we use a top-level '__asm__(".arch_extension virt")'
>>>> statement to allow compilation of a multi-CPU kernel for ARMv6
>>>> and older ARMv7-A that don't normally support access to the banked
>>>> registers.
>>>>
>>>> This is considered to be a programming error by the gcc developers
>>>> and will no longer work in gcc-8, where we now get a build error:
>>>>
>>>> /tmp/cc4Qy7GR.s:34: Error: Banked registers are not available with this
>>>> architecture. -- `mrs r3,SP_usr'
>>>> /tmp/cc4Qy7GR.s:41: Error: Banked registers are not available with this
>>>> architecture. -- `mrs r3,ELR_hyp'
>>>> /tmp/cc4Qy7GR.s:55: Error: Banked registers are not available with this
>>>> architecture. -- `mrs r3,SP_svc'
>>>> /tmp/cc4Qy7GR.s:62: Error: Banked registers are not available with this
>>>> architecture. -- `mrs r3,LR_svc'
>>>> /tmp/cc4Qy7GR.s:69: Error: Banked registers are not available with this
>>>> architecture. -- `mrs r3,SPSR_svc'
>>>> /tmp/cc4Qy7GR.s:76: Error: Banked registers are not available with this
>>>> architecture. -- `mrs r3,SP_abt'
>>>>
>>>> Passign the '-march-armv7ve' flag to gcc works, and is ok here, because
>>>> we know the functions won't ever be called on pre-ARMv7VE machines.
>>>> Unfortunately, older compiler versions (4.8 and earlier) do not
>>>> understand
>>>> that flag, so we still need to keep the asm around.
>>>>
>>>> Backporting to stable kernels (4.6+) is needed to allow those to be built
>>>> with future compilers as well.
>>>
>>>
>>> Is "-Wa,arch=armv7-a+virt" (as we appear to do for a couple of files
>>> already) viable as a possibly cleaner alternative, or is GCC itself now
>>> policing the contents of inline asms?
>>
>>
>> In fact, looking at the binutils history, any version capable of assembling
>> this file should understand that (modulo my typo), so hopefully it ought to
>> be feasible to replace these global asms with assembler flags entirely.
> 
> No, this only works for .S files, not .c, since gcc starts the output with
> an explicit .arch setting that overrides the command line. I think this
> was done intentionally to prevent such a hack from working, and have
> more reliable checks on the validity of the assembler instruction in
> inline asm statements (which we try to circumvent here).

Ah, I see, that is unfortunate. Thanks for clarifying.

Robin.
