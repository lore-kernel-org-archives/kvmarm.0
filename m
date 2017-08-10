From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2 06/16] arm64: entry.S: convert elX_sync
Date: Thu, 10 Aug 2017 17:57:48 +0100
Message-ID: <598C908C.9030506@arm.com>
References: <20170728141019.9084-1-james.morse@arm.com>
 <20170728141019.9084-7-james.morse@arm.com>
 <20170809172527.yrkpthrrtqoxi4d7@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8719A40FA7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Aug 2017 12:57:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u0jZ0HYybhTq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Aug 2017 12:57:28 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EFDF40C5A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Aug 2017 12:57:28 -0400 (EDT)
In-Reply-To: <20170809172527.yrkpthrrtqoxi4d7@armageddon.cambridge.arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Wang Xiongfeng <wangxiongfeng2@huawei.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Catalin,

On 09/08/17 18:25, Catalin Marinas wrote:
> On Fri, Jul 28, 2017 at 03:10:09PM +0100, James Morse wrote:
>> @@ -520,9 +514,16 @@ el1_preempt:
>>  el0_sync:
>>  	kernel_entry 0
>>  	mrs	x25, esr_el1			// read the syndrome register
>> +	mrs	x26, far_el1
> 
> Just checking, since we are going to access far_el1 even when we get a
> syscall, have you noticed any overhead?

Good point, I haven't checked because I've been doing all this with the software
model.

I will set this running on Seattle overnight, results in v3's cover letter.


Thanks!

James
