From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] ARM: kvm: fix building with gcc-8
Date: Sun, 4 Feb 2018 21:57:49 +0100
Message-ID: <CAK8P3a2EFdTcM6U4TU6EZz9vzGKK=hE=8yQ-1eTTxjGMRs5SKQ@mail.gmail.com>
References: <20180202150756.420422-1-arnd@arndb.de> <20180204184517.GQ21802@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180204184517.GQ21802@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Russell King <linux@armlinux.org.uk>, Nicolas Pitre <nico@linaro.org>, Andi Kleen <ak@linux.intel.com>, Richard Earnshaw <rearnsha@gcc.gnu.org>, Tamar Christina <tnfchris@gcc.gnu.org>, "# 3.4.x" <stable@vger.kernel.org>, Julien Thierry <julien.thierry@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Feb 4, 2018 at 7:45 PM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> Hi Arnd,
>
> On Fri, Feb 02, 2018 at 04:07:34PM +0100, Arnd Bergmann wrote:
>> In banked-sr.c, we use a top-level '__asm__(".arch_extension virt")'
>> statement to allow compilation of a multi-CPU kernel for ARMv6
>> and older ARMv7-A that don't normally support access to the banked
>> registers.
>>
>> This is considered to be a programming error by the gcc developers
>> and will no longer work in gcc-8, where we now get a build error:
>>
>> /tmp/cc4Qy7GR.s:34: Error: Banked registers are not available with this architecture. -- `mrs r3,SP_usr'
>> /tmp/cc4Qy7GR.s:41: Error: Banked registers are not available with this architecture. -- `mrs r3,ELR_hyp'
>> /tmp/cc4Qy7GR.s:55: Error: Banked registers are not available with this architecture. -- `mrs r3,SP_svc'
>> /tmp/cc4Qy7GR.s:62: Error: Banked registers are not available with this architecture. -- `mrs r3,LR_svc'
>> /tmp/cc4Qy7GR.s:69: Error: Banked registers are not available with this architecture. -- `mrs r3,SPSR_svc'
>> /tmp/cc4Qy7GR.s:76: Error: Banked registers are not available with this architecture. -- `mrs r3,SP_abt'
>>
>> Passign the '-march-armv7ve' flag to gcc works, and is ok here, because
>> we know the functions won't ever be called on pre-ARMv7VE machines.
>> Unfortunately, older compiler versions (4.8 and earlier) do not understand
>> that flag, so we still need to keep the asm around.
>
> Does "not understand" mean "ignores" or do we get an error?

We get an error, which is why I used the $(call cc-option) Makefile
helper to check if the compiler supports it.

>> Backporting to stable kernels (4.6+) is needed to allow those to be built
>> with future compilers as well.
>
> This builds on the toolchains I have on my machine, so:
>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
>
> Are you applying this via a tree with other fixes or would you like me
> to carry it in the kvmarm tree?

Please pick it up in your tree.

Thanks,

       Arnd
