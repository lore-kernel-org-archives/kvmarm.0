From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v3 7/8] ARM: Move system register accessors to asm/cp15.h
Date: Mon, 12 Sep 2016 10:44:51 +0100
Message-ID: <57D67913.807@arm.com>
References: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
 <1473350810-10857-8-git-send-email-vladimir.murzin@arm.com>
 <57D2EBE4.4060107@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A54540F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 05:36:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QHN9VCApNvXs for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Sep 2016 05:36:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F54240C9A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 05:36:13 -0400 (EDT)
In-Reply-To: <57D2EBE4.4060107@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Sorry, missed this part...

On 09/09/16 18:05, Marc Zyngier wrote:
>>  
>> > +#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	\
>> > +	"mrc", "mcr", __stringify(p15, Op1, %0, CRn, CRm, Op2), u32
>> > +#define __ACCESS_CP15_64(Op1, CRm)		\
>> > +	"mrrc", "mcrr", __stringify(p15, Op1, %Q0, %R0, CRm), u64
>> > +
>> > +#define __read_sysreg(r, w, c, t) ({				\
>> > +	t __val;						\
>> > +	asm volatile(r " " c : "=r" (__val));			\
>> > +	__val;							\
>> > +})
>> > +#define read_sysreg(...)		__read_sysreg(__VA_ARGS__)
>> > +
>> > +#define __write_sysreg(v, r, w, c, t)	asm volatile(w " " c : : "r" ((t)(v)))
>> > +#define write_sysreg(v, ...)		__write_sysreg(v, __VA_ARGS__)
>> > +
> Shouldn't that be placed after the #ifdef below?
> 

Yes, I'll move it under #ifdef.

Thanks
Vladimir
