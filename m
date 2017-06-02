From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 00/25] arm64: KVM: Mediate access to GICv3 sysregs at
 EL2
Date: Fri, 2 Jun 2017 10:11:56 +0100
Message-ID: <941a29e4-9652-ee40-1d46-a5f06288cc7b@arm.com>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <7dd609ce-6f7b-2a12-fa06-4ce1c6ba6ebe@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73CF840C4F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 05:08:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nbQaPsFblsta for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jun 2017 05:08:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BDCE40960
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 05:08:01 -0400 (EDT)
In-Reply-To: <7dd609ce-6f7b-2a12-fa06-4ce1c6ba6ebe@caviumnetworks.com>
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

On 01/06/17 22:00, David Daney wrote:
> On 06/01/2017 03:20 AM, Marc Zyngier wrote:
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
>> I've taken the liberty to rebase David Daney's initial Cavium erratum
>> 30115 workaround on top of this series, and included it here as a
>> typical use case.
> 
> I pulled this from:
> 
>  
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/gicv3-cpuif-mediated-access
> 
> this morning at commit	58c1763c5aa6223ab3d04e0c183a31eb0aef832e
> 
> Entire series tested by and
> 
> Acked-by: David Daney <david.daney@cavium.com>

Thanks David. May I ask what particular system this was tested on (just
so that I have a additional reference point)?

Cheers,

	M.
-- 
Jazz is not dead. It just smells funny...
