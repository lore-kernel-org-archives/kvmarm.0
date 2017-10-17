From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 10/13] firmware: arm_sdei: Add support for CPU and
 system power states
Date: Tue, 17 Oct 2017 17:34:38 +0100
Message-ID: <59E6311E.7030406@arm.com>
References: <20170922182614.27885-1-james.morse@arm.com>
 <20170922182614.27885-11-james.morse@arm.com>
 <20171016135204.ncz6fzw5gh3gv57c@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E82449D28
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 12:35:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GN+NXsbJN-ua for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 12:35:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0331406BB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 12:35:19 -0400 (EDT)
In-Reply-To: <20171016135204.ncz6fzw5gh3gv57c@armageddon.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: devicetree@vger.kernel.org, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, Loc Ho <lho@apm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Catalin,

On 16/10/17 14:52, Catalin Marinas wrote:
> On Fri, Sep 22, 2017 at 07:26:11PM +0100, James Morse wrote:
>> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
>> index f24bfb2b9a2d..466b949474df 100644
>> --- a/include/linux/cpuhotplug.h
>> +++ b/include/linux/cpuhotplug.h
>> @@ -88,6 +88,7 @@ enum cpuhp_state {
>>  	CPUHP_AP_PERF_XTENSA_STARTING,
>>  	CPUHP_AP_PERF_METAG_STARTING,
>>  	CPUHP_AP_MIPS_OP_LOONGSON3_STARTING,
>> +	CPUHP_AP_SDEI_STARTING,
> 
> Nitpick: how generic is this as to apply to other architectures?
> Probably not, so shall we prefix this with ARM_?

This may get used on 32bit ARM. I blindly copied PSCI, which doesn't have a
prefix. But it makes sense to have one.


> Not actually a strong preferences but similar question for the
> definitions in the sdei.h files (and maybe the filenames themselves).


Thanks,

James
