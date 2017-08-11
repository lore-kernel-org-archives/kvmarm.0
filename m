From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2 06/16] arm64: entry.S: convert elX_sync
Date: Fri, 11 Aug 2017 18:24:59 +0100
Message-ID: <598DE86B.4030106@arm.com>
References: <20170728141019.9084-1-james.morse@arm.com>
 <20170728141019.9084-7-james.morse@arm.com>
 <20170809172527.yrkpthrrtqoxi4d7@armageddon.cambridge.arm.com>
 <598C908C.9030506@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3189349C1C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Aug 2017 13:24:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y5cQydGGfJ1Q for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Aug 2017 13:24:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0956C40A86
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Aug 2017 13:24:36 -0400 (EDT)
In-Reply-To: <598C908C.9030506@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Wang Xiongfeng <wangxiongfeng2@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Catalin,

On 10/08/17 17:57, James Morse wrote:
> On 09/08/17 18:25, Catalin Marinas wrote:
>> On Fri, Jul 28, 2017 at 03:10:09PM +0100, James Morse wrote:
>>> @@ -520,9 +514,16 @@ el1_preempt:
>>>  el0_sync:
>>>  	kernel_entry 0
>>>  	mrs	x25, esr_el1			// read the syndrome register
>>> +	mrs	x26, far_el1
>>
>> Just checking, since we are going to access far_el1 even when we get a
>> syscall, have you noticed any overhead?

(I can get rid of the extra far_el1 reads by doing a better job of this patch.)


> Good point, I haven't checked because I've been doing all this with the software
> model.
> 
> I will set this running on Seattle overnight, results in v3's cover letter.

So the series does make microbenchmarks like calling getpid() in a loop slower,
but its not the far_el1 read causing this, its the unconditional masking of
exceptions in kernel_exit. This doesn't show up once I start doing real work
(like fork or exec).

I may be able to get rid of this but keep SError unmasked in the kernel and
masked over eret by merging EL0-returns disable_daif with its existing
irq-masked ret-to-user loop.



Thanks,

James
