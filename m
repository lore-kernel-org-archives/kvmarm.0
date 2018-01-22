From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 03/13] arm64: cpufeature: Detect CPU RAS Extentions
Date: Mon, 22 Jan 2018 19:32:41 +0000
Message-ID: <5A663C59.6030205@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
 <20180115193906.30053-4-james.morse@arm.com>
 <78d4374a-f75c-6860-38ab-6373ffae3eee@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 002F749D62
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jan 2018 14:29:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AoJmCpQNQjmR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jan 2018 14:29:44 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D54CE49D2B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jan 2018 14:29:44 -0500 (EST)
In-Reply-To: <78d4374a-f75c-6860-38ab-6373ffae3eee@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 16/01/18 11:17, gengdongjiu wrote:
> Hi James,
> 
> On 2018/1/16 3:38, James Morse wrote:
>> From: Xie XiuQi <xiexiuqi@huawei.com>
>>
>> ARM's v8.2 Extentions add support for Reliability, Availability and
>> Serviceability (RAS). On CPUs with these extensions system software
>> can use additional barriers to isolate errors and determine if faults
>> are pending. Add cpufeature detection.
>>
>> Platform level RAS support may require additional firmware support.

>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 664fadc2aa2e..1d51c8edf34b 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -1062,6 +1062,22 @@ config ARM64_PMEM
>>  	  operations if DC CVAP is not supported (following the behaviour of
>>  	  DC CVAP itself if the system does not define a point of persistence).
>>  
>> +config ARM64_RAS_EXTN
>> +	bool "Enable support for RAS CPU Extensions"
>> +	default y
>> +	help
>> +	  CPUs that support the Reliability, Availability and Serviceability
>> +	  (RAS) Extensions, part of ARMv8.2 are able to track faults and
>> +	  errors, classify them and report them to software.
>> +
>> +	  On CPUs with these extensions system software can use additional
>> +	  barriers to determine if faults are pending and read the
>> +	  classification from a new set of registers.
>> +
>> +	  Selecting this feature will allow the kernel to use these barriers
>> +	  and access the new registers if the system supports the extension.
>> +	  Platform RAS features may additionally depend on firmware support.
>> +
>>  endmenu
>>  
> it seems this "CONFIG_ARM64_RAS_EXTN" is not enabled in the "arch/arm64/configs/defconfig",
> if not, I want to enable this config to enable RAS feature in the defconfig. do you agree?

Sure. This series doesn't do a lot on its own, it expects firmware-first or
kernel-first support, which may in turn depend-on this feature. It means we
don't panic() when notified of corrected errors, until we get the
{firmware,kernel}-first support.

Don't defconfig changes get collected by arm-soc? (I'm not sure how these get
picked up...)


James
