From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v5 04/13] arm64: kernel: Survive corrected RAS errors
 notified by SError
Date: Fri, 05 Jan 2018 18:28:29 +0000
Message-ID: <5A4FC3CD.3030809@arm.com>
References: <20171215155101.23505-1-james.morse@arm.com>
 <20171215155101.23505-5-james.morse@arm.com>
 <43942acd-f6ff-ec58-aafb-a6f3ba40fab9@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E4EE49DAC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jan 2018 13:26:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AfNmd78K-X-b for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Jan 2018 13:26:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3A8E49D2B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jan 2018 13:26:12 -0500 (EST)
In-Reply-To: <43942acd-f6ff-ec58-aafb-a6f3ba40fab9@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>, linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 16/12/17 02:53, gengdongjiu wrote:
> 
> On 2017/12/15 23:50, James Morse wrote:
>> +asmlinkage void do_serror(struct pt_regs *regs, unsigned int esr)
>> +{
>> +	nmi_enter();
> 
>         How about firstly let APEI kernel driver to handle it by adding patch[1]? if the handling is successful, do_serror() direct return;
>         Otherwise continue check the ESR value, for example:
> 	if (!ghes_notify_sei())
> 		return;

This is where I think we will end up. Adding that could should be part of a
future firmware-first series.
We can't do it until APEI can share its in_nmi() path with multiple users. (what
happens if we take an SError while handling an NOTIFY_SEA).

I still haven't managed to get the RFC of what I think is required out.
(I need this for SDEI too),


>> +
>> +	/* non-RAS errors are not containable */
>> +	if (!arm64_is_ras_serror(esr) || arm64_is_fatal_ras_serror(regs, esr))
>> +		arm64_serror_panic(regs, esr);
>>  
>> -	panic("Asynchronous SError Interrupt");
>> +	nmi_exit();
>>  }


Thanks,

James
