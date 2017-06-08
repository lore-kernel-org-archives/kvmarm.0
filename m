From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v2 00/25] arm64: KVM: Mediate access to GICv3 sysregs at
 EL2
Date: Thu, 8 Jun 2017 16:35:01 +0200
Message-ID: <615c301e-faa7-ab31-24f2-8000b6a6fc21@suse.de>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170601102117.17750-1-marc.zyngier@arm.com>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 01.06.17 12:20, Marc Zyngier wrote:
> Some systems have less than perfect GICv3 implementations, leading to
> all kind of ugly issues (guest hanging, host dying). In order to allow
> some level of diagnostic, and in some cases implement workarounds,
> this series enables the trapping of both Group-0, Group-1 and Common
> sysregs. Mediating the access at EL2 allows some form of sanity
> checking that the HW is sometimes sorely lacking.
> 
> Instead of fully emulating a GICv3 CPU interface, we still use the
> existing HW (list registers, AP registers, VMCR...), which allows the
> code to be independent from the rest of the KVM code, and to cope with
> partial trapping.
> 
> Of course, trapping has a cost, which is why this must be either
> enabled on the command line, or selected by another cpu capability
> (see Cavium erratum 30115). A quick test on an A57-based platform
> shows a 25% hit when repeatedly banging on the trapped registers,
> while normal workloads do not seem to suffer noticeably from such
> trapping (hackbench variance is in the usual noise, despite being very
> IPI happy).
> 
> This has been tested on a dual socket Thundex-X and a Freescale LS-2085a.
> 
> I've taken the liberty to rebase David Daney's initial Cavium erratum
> 30115 workaround on top of this series, and included it here as a
> typical use case.

I've run this patch set on an affected ThunderX system and indeed not 
seen any hangs. I have seen lost guest USB keyboard events which might 
point at interrupt problems or not, but let's assume it's a different 
issue for now.

Tested-by: Alexander Graf <agraf@suse.de>


Alex
