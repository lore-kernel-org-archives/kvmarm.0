From: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH v2 00/25] arm64: KVM: Mediate access to GICv3 sysregs at
 EL2
Date: Fri, 2 Jun 2017 09:24:44 -0700
Message-ID: <c01045ac-10ce-811c-4c60-650db30ef3c8@caviumnetworks.com>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <7dd609ce-6f7b-2a12-fa06-4ce1c6ba6ebe@caviumnetworks.com>
 <941a29e4-9652-ee40-1d46-a5f06288cc7b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <941a29e4-9652-ee40-1d46-a5f06288cc7b@arm.com>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/02/2017 02:11 AM, Marc Zyngier wrote:
> On 01/06/17 22:00, David Daney wrote:
>> On 06/01/2017 03:20 AM, Marc Zyngier wrote:
>>> Some systems have less than perfect GICv3 implementations, leading to
>>> all kind of ugly issues (guest hanging, host dying). In order to allow
>>> some level of diagnostic, and in some cases implement workarounds,
>>> this series enables the trapping of both Group-0, Group-1 and Common
>>> sysregs. Mediating the access at EL2 allows some form of sanity
>>> checking that the HW is sometimes sorely lacking.
>>>
>>> Instead of fully emulating a GICv3 CPU interface, we still use the
>>> existing HW (list registers, AP registers, VMCR...), which allows the
>>> code to be independent from the rest of the KVM code, and to cope with
>>> partial trapping.
>>>
>>> Of course, trapping has a cost, which is why this must be either
>>> enabled on the command line, or selected by another cpu capability
>>> (see Cavium erratum 30115). A quick test on an A57-based platform
>>> shows a 25% hit when repeatedly banging on the trapped registers,
>>> while normal workloads do not seem to suffer noticeably from such
>>> trapping (hackbench variance is in the usual noise, despite being very
>>> IPI happy).
>>>
>>> This has been tested on a dual socket Thundex-X and a Freescale LS-2085a.
>>>
>>> I've taken the liberty to rebase David Daney's initial Cavium erratum
>>> 30115 workaround on top of this series, and included it here as a
>>> typical use case.
>>
>> I pulled this from:
>>
>>   
>> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/gicv3-cpuif-mediated-access
>>
>> this morning at commit	58c1763c5aa6223ab3d04e0c183a31eb0aef832e
>>
>> Entire series tested by and
>>
>> Acked-by: David Daney <david.daney@cavium.com>
> 
> Thanks David. May I ask what particular system this was tested on (just
> so that I have a additional reference point)?

Sure, Unfortunatly I think it doesn't really increase your testing coverage.

I tested on a 2-node NUMA Cavium cn8890 (ThunderX).  This chassis is 
known as CRB-2S.  Running Ubuntu 16.04.2 userspace.

First I verified that a kernel built from clean v4.12-rc3 would fail 
with symptoms of no interrupts being processed while running a heavy KVM 
start/stop workload.  It does, we get a failure in under 5 minutes.

Then I applied your 25 patch set, and retested.  With the patch set 
applied, no failures were observed after more than 4 hours.


> 
> Cheers,
> 
> 	M.
> 
