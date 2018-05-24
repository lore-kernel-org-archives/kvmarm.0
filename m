From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 00/14] ARM Spectre variant 2 fixes
Date: Thu, 24 May 2018 16:18:30 -0700
Message-ID: <6845807d-4838-53e4-91ad-a7c6ef081f58@gmail.com>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180521114238.GN17671@n2100.armlinux.org.uk>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, tony@atomide.com, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/21/2018 04:42 AM, Russell King - ARM Linux wrote:
> This is the second posting - the original cover note is below.  Comments
> from previous series addresesd:
> - Drop R7 and R8 changes.
> - Remove "PSCI" from the hypervisor version of the workaround.
> 
>  arch/arm/include/asm/bugs.h        |   6 +-
>  arch/arm/include/asm/cp15.h        |   3 +
>  arch/arm/include/asm/cputype.h     |   5 ++
>  arch/arm/include/asm/kvm_asm.h     |   2 -
>  arch/arm/include/asm/kvm_host.h    |  14 +++-
>  arch/arm/include/asm/kvm_mmu.h     |  23 +++++-
>  arch/arm/include/asm/proc-fns.h    |   4 +
>  arch/arm/include/asm/system_misc.h |   8 ++
>  arch/arm/kernel/Makefile           |   1 +
>  arch/arm/kernel/bugs.c             |  18 +++++
>  arch/arm/kernel/smp.c              |   4 +
>  arch/arm/kernel/suspend.c          |   2 +
>  arch/arm/kvm/hyp/hyp-entry.S       | 108 +++++++++++++++++++++++++-
>  arch/arm/mm/Kconfig                |  23 ++++++
>  arch/arm/mm/Makefile               |   2 +-
>  arch/arm/mm/fault.c                |   3 +
>  arch/arm/mm/proc-macros.S          |   3 +-
>  arch/arm/mm/proc-v7-2level.S       |   6 --
>  arch/arm/mm/proc-v7-bugs.c         | 130 +++++++++++++++++++++++++++++++
>  arch/arm/mm/proc-v7.S              | 154 +++++++++++++++++++++++++++++--------
>  20 files changed, 469 insertions(+), 50 deletions(-)
>  create mode 100644 arch/arm/kernel/bugs.c
>  create mode 100644 arch/arm/mm/proc-v7-bugs.c

Since there appears to be more work needed in the PSCI/KVM changes
(patches 9 through 14), how about we go with the "bare-metal" parts:
patches 1-8 first and try to get those included ASAP?

The rationale being that a lot of affected people have Linux running on
ARMv7-A Cortex-A, typically A9, A15, Brahma-B15, and are in need of
those patches but do not necessarily require KVM fixes right now, and
even less so PSCI infrastructure to mitigate ARMv8-A running in AArch32.

In terms of backporting to -stable, and because the spectre variant 1
patches have not been submitted yet, it is not like we can lump
everything in one go anyway, so we are not making the lives of the
-stable maintainers any worse than it currently is?

Yay or nay?

> 
> On Wed, May 16, 2018 at 11:59:49AM +0100, Russell King - ARM Linux wrote:
>> This series addresses the Spectre variant 2 issues on ARM Cortex and
>> Broadcom Brahma B15 CPUs.  Due to the complexity of the bug, it is not
>> possible to verify that this series fixes any of the bugs, since it
>> has not been able to reproduce these exact scenarios using test
>> programs.
>>
>> I believe that this covers the entire extent of the Spectre variant 2
>> issues, with the exception of Cortex A53 and Cortex A72 processors as
>> these require a substantially more complex solution (except where the
>> workaround is implemented in PSCI firmware.)
>>
>> Spectre variant 1 is not covered by this series.
>>
>> The patch series is based partly on Marc Zyngier's work from February -
>> two of the KVM patches are from Marc's work.
>>
>> The main differences are:
>> - Inclusion of more processors as per current ARM Ltd security update
>>   documentation.
>> - Extension of "bugs" infrastructure to detect Cortex A8 and Cortex A15
>>   CPUs missing out on the IBE bit being set on (re-)entry to the kernel
>>   through all paths.
>> - Handle all suspect userspace-touching-kernelspace aborts irrespective
>>   of mapping type.
>>
>> The first patch will trivially conflict with the Broadcom Brahma
>> updates already in arm-soc - it has been necessary to independently
>> add the ID definitions for the B15 CPU.
>>
>> Having worked through this series, I'm of the opinion that the
>> define_processor_functions macro in proc-v7 are probably  more hassle
>> than they're worth - here, we don't need the global equivalent symbols,
>> because we never refer to them from the kernel code for any V7
>> processor (MULTI_CPU is always defined.)
>>
>> This series is currently in my "spectre" branch (along with some
>> Spectre variant 1 patches.)
>>
>> Please carefully review.
>>
>>  arch/arm/include/asm/bugs.h        |   6 +-
>>  arch/arm/include/asm/cp15.h        |   3 +
>>  arch/arm/include/asm/cputype.h     |   5 ++
>>  arch/arm/include/asm/kvm_asm.h     |   2 -
>>  arch/arm/include/asm/kvm_host.h    |  14 +++-
>>  arch/arm/include/asm/kvm_mmu.h     |  23 +++++-
>>  arch/arm/include/asm/proc-fns.h    |   4 +
>>  arch/arm/include/asm/system_misc.h |   8 ++
>>  arch/arm/kernel/Makefile           |   1 +
>>  arch/arm/kernel/bugs.c             |  18 +++++
>>  arch/arm/kernel/smp.c              |   4 +
>>  arch/arm/kernel/suspend.c          |   2 +
>>  arch/arm/kvm/hyp/hyp-entry.S       | 108 ++++++++++++++++++++++++-
>>  arch/arm/mm/Kconfig                |  23 ++++++
>>  arch/arm/mm/Makefile               |   2 +-
>>  arch/arm/mm/fault.c                |   3 +
>>  arch/arm/mm/proc-macros.S          |   3 +-
>>  arch/arm/mm/proc-v7-2level.S       |   6 --
>>  arch/arm/mm/proc-v7-bugs.c         | 130 ++++++++++++++++++++++++++++++
>>  arch/arm/mm/proc-v7.S              | 158 +++++++++++++++++++++++++++++--------
>>  20 files changed, 471 insertions(+), 52 deletions(-)
>>
>> -- 
>> RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
>> FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
>> According to speedtest.net: 8.21Mbps down 510kbps up
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 


-- 
Florian
