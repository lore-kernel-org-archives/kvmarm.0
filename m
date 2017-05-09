From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 00/31] arm64: KVM: Mediate access to GICv3 sysregs at EL2
Date: Tue, 9 May 2017 18:39:42 +0100
Message-ID: <be454720-190b-8730-4c04-b4098b33df45@arm.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <3f177b5e-e5c1-c681-1607-0a80c5aafba4@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 995AE408EB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 13:36:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lJY3JvW6Esd4 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 13:36:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05C0040430
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 13:36:30 -0400 (EDT)
In-Reply-To: <3f177b5e-e5c1-c681-1607-0a80c5aafba4@caviumnetworks.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: David Daney <ddaney@caviumnetworks.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 09/05/17 01:05, David Daney wrote:
> On 05/03/2017 03:45 AM, Marc Zyngier wrote:
>> [Apologies for posting this at the beginning of a merge window, but as
>>   this is a rather hot topic, I'd rather put it out as soon as possible]
>>
>> Some systems have less than perfect GICv3 implementations, leading to
>> all kind of ugly issues (guest hanging, host dying). In order to allow
>> some level of diagnostic, and in some cases implement workarounds,
>> this series enables the trapping of both Group-0, Group-1 and Common
>> sysregs. Mediating the access at EL2 allows some form of sanity
>> checking that the HW is sometimes sorely lacking.
>>
>> Instead of fully emulating a GICv3 CPU interface, we still use the
>> existing HW (list registers, AP registers, VMCR...), which allows the
>> code to be independent from the rest of the KVM code, and to cope with
>> partial trapping.
>>
>> Of course, trapping has a cost, which is why this must be either
>> enabled on the command line, or selected by another cpu capability
>> (see Cavium erratum 30115). A quick test on an A57-based platform
>> shows a 25% hit when repeatedly banging on the trapped registers,
>> while normal workloads do not seem to suffer noticeably from such
>> trapping (hackbench variance is in the usual noise, despite being very
>> IPI happy).
>>
>> This has been tested on a dual socket Thundex-X and a Freescale LS-2085a.
>>
>> The first 6 patches are fixes, and only here for reference as they
>> have already been posted separately. The rest of the patches implement
>> Group-1, Group-0 and Common sysreg handlers, with the corresponding
>> command line options. I've also taken the liberty to rebase David
>> Daney's initial Cavium erratum 30115 workaround on top of this series,
>> and included it here as a typical use case.
>>
> 
> 
> Thanks Marc for working on this.
> 
> I tested this series based on your git branch:
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/gicv3-cpuif-mediated-access
> 
> This does indeed fix the problems we were seeing, so feel free to add:
> 
> Tested-by: David Daney <david.daney@cavium.com>
> 
> to the entire series.

Thanks for having given it a go.

> 
> I would note that with these patches we see an occasional:
> 
> [ 3868.311491] Unexpected interrupt 4 on vcpu ffff801f57a6a020
> [ 4262.063419] Unexpected interrupt 4 on vcpu ffff801f5b3dc040
> [ 4262.063422] Unexpected interrupt 4 on vcpu ffff801f50972020
> 
> This is better than locking up the system, but I wonder if it indicates 
> that improvement to the code is still possible.

This warning occasionally shows up on the same platform even without
these patches (it is just harder to trigger). This is an artefact of the
way KVM treats the virtual timer, disabling it on exit and expecting it
to immediately retired from the CPU interface. This works just fine on
all systems, except for this platform where it seems to take a bit more
time.

Trapping things at EL2 introduces just enough additional latency that we
end-up exiting with a pending interrupt more often than without the
trapping, trigger this warning.

The good news is twofold: this is completely harmless (we just get an
extra interrupt on the host), and Christoffer is working on patches that
will change the way we handle this so that we actually make use of that
interrupt.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
