From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v2 1/3] arm64: mm: Support Common Not Private translations
Date: Wed, 13 Dec 2017 16:59:42 +0000
Message-ID: <e76e1b4f-e1df-928e-fece-4c8717d5aeab@arm.com>
References: <1507724395-13735-1-git-send-email-vladimir.murzin@arm.com>
 <1507724395-13735-2-git-send-email-vladimir.murzin@arm.com>
 <5A313704.1090503@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DC7349D4C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 11:56:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pmaZe-+d3jfK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Dec 2017 11:56:14 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 490BD49D40
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 11:56:14 -0500 (EST)
In-Reply-To: <5A313704.1090503@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, kbuild-all@01.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 13/12/17 14:19, James Morse wrote:
> Hi Vladimir,
> 
> On 11/10/17 13:19, Vladimir Murzin wrote:
>> Common Not Private (CNP) is a feature of ARMv8.2 extension which
>> allows translation table entries to be shared between different PEs in
>> the same inner shareable domain, so the hardware can use this fact to
>> optimise the caching of such entries in the TLB.
>>
>> CNP occupies one bit in TTBRx_ELy and VTTBR_EL2, which advertises to
>> the hardware that the translation table entries pointed to by this
>> TTBR are the same as every PE in the same inner shareable domain for
>> which the equivalent TTBR also has CNP bit set. In case CNP bit is set
>> but TTBR does not point at the same translation table entries or a
>> given ASID and VMID, then the system is mis-configured, so the results
>> of translations are UNPREDICTABLE.
>>
>> This patch adds support for Common Not Private translations on
>> different exceptions levels:
>>
>> (1) For EL0 there are a few cases we need to care of changes in
>>     TTBR0_EL1:
>>     - a switch to idmap
>>     - software emulated PAN
>>     we rule out latter via Kconfig options and for the former we make
>>     sure that CNP is set for non-zero ASIDs only.
>>
>> (2) For EL1 we postpone setting CNP till all cpus are up and rely on
>>     cpufeature framework to 1) patch the code which is sensitive to
>>     CNP and 2) update TTBR1_EL1 with CNP bit set. TTBR1_EL1 can be
>>     reprogrammed as result of hibernation or cpuidle (via __enable_mmu).
>>     cpuidle's path has been changed to restore CnP and for hibernation
>>     the code has been changed to save raw TTBR1_EL1 and blindly restore
>>     it on resume.
> 
> 
> While I remember:
> 
> This feature is going to be fun for kdump, we may leave secondary CPUs running
> if they don't take the IPI to crash-out of the kernel. Worse, if we don't have
> PSCI they just spin in a loop while the surviving CPU brings up the crash kernel
> and maybe-enables CNP...
> 
> I think the best fix for this is to refuse to enable CNP at all if we're a crash
> kernel. There is stuff in the DT to indicate this... we should know about the
> 'elfcorehdr' before cpufeature runs. (I don't think we should rely on the
> cmdline option).
> 
> kexec is unaffected because it always powers-off the secondary CPUs before
> leaving the old kernel. This behaves much more like a normal boot.

Thanks, I'll look into it.

Vladimir 

> 
> 
> Thanks,
> 
> James
> 
