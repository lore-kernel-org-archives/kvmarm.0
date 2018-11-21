From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 4/4] arm64: KVM: Implement workaround for Cortex-A76
 erratum 1165522
Date: Wed, 21 Nov 2018 12:58:15 +0000
Message-ID: <dc5b3168-5832-c7ad-10a4-67cdab2921db@arm.com>
References: <20181105143617.120602-1-marc.zyngier@arm.com>
 <20181105143617.120602-5-marc.zyngier@arm.com>
 <06743f45-fd39-787d-0c59-12d28d8245bb@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBBB44A211
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Nov 2018 07:58:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5zKdEmpvJ1Ae for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Nov 2018 07:58:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A68504A1FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Nov 2018 07:58:18 -0500 (EST)
In-Reply-To: <06743f45-fd39-787d-0c59-12d28d8245bb@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 21/11/2018 12:23, Julien Grall wrote:
> Hi Marc,
> 
> On 05/11/2018 14:36, Marc Zyngier wrote:
>> Early versions of Cortex-A76 can end-up with corrupt TLBs if they
>> speculate an AT instruction in during a guest switch while the
>> S1/S2 system registers are in an inconsistent state.
>>
>> Work around it by:
>> - Mandating VHE
>> - Make sure that S1 and S2 system registers are consistent before
>>    clearing HCR_EL2.TGE, which allows AT to target the EL1 translation
>>    regime
>>
>> These two things together ensure that we cannot hit this erratum.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>   Documentation/arm64/silicon-errata.txt |  1 +
>>   arch/arm64/Kconfig                     | 12 ++++++++++++
>>   arch/arm64/include/asm/cpucaps.h       |  3 ++-
>>   arch/arm64/include/asm/kvm_host.h      |  3 +++
>>   arch/arm64/include/asm/kvm_hyp.h       |  6 ++++++
>>   arch/arm64/kernel/cpu_errata.c         |  8 ++++++++
>>   arch/arm64/kvm/hyp/switch.c            | 14 ++++++++++++++
>>   7 files changed, 46 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
>> index 76ccded8b74c..04f0bc4690c6 100644
>> --- a/Documentation/arm64/silicon-errata.txt
>> +++ b/Documentation/arm64/silicon-errata.txt
>> @@ -57,6 +57,7 @@ stable kernels.
>>   | ARM            | Cortex-A73      | #858921         | ARM64_ERRATUM_858921        |
>>   | ARM            | Cortex-A55      | #1024718        | ARM64_ERRATUM_1024718       |
>>   | ARM            | Cortex-A76      | #1188873        | ARM64_ERRATUM_1188873       |
>> +| ARM            | Cortex-A76      | #1165522        | ARM64_ERRATUM_1165522       |
>>   | ARM            | MMU-500         | #841119,#826419 | N/A                         |
>>   |                |                 |                 |                             |
>>   | Cavium         | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375        |
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 787d7850e064..a68bc6cc2167 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -497,6 +497,18 @@ config ARM64_ERRATUM_1188873
>>   
>>   	  If unsure, say Y.
>>   
>> +config ARM64_ERRATUM_1165522
>> +	bool "Cortex-A76: Speculative AT instruction using out-of-context translation regime could cause subsequent request to generate an incorrect translation"
>> +	default y
>> +	help
>> +	  This option adds work arounds for ARM Cortex-A76 erratum 1165522
>> +
>> +	  Affected Cortex-A76 cores (r0p0, r1p0, r2p0) could end-up with
>> +	  corrupted TLBs by speculating an AT instruction during a guest
>> +	  context switch.
>> +
>> +	  If unsure, say Y.
> 
> Most of the code in the patch is not guarded by #ifdef ARM64_*. So is there any 
> benefits to add a Kconfig for this option?

The detection code is guarded by this config option, which is the
important thing. In general, we try to compile everything, all the time,
unless this is too big to be the case. It drastically simplify the
maintenance.

See the VHE code for example, which is always compiled in, and is only
gated by the detection code that gets compiled out if the option isn't
selected.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
