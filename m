From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 04/18] arm64: alternatives: Enforce alignment of struct
 alt_instr
Date: Wed, 6 Dec 2017 15:39:23 +0000
Message-ID: <280c1267-500c-fccd-bd33-50e27a01061b@arm.com>
References: <20171206143839.29223-1-marc.zyngier@arm.com>
 <20171206143839.29223-5-marc.zyngier@arm.com>
 <20171206144847.GA28074@char.us.oracle.com>
 <dd8995ce-3065-3aba-2d93-9ed91de5cd50@arm.com>
 <20171206151856.GH28074@char.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60C8349D4E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 10:36:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SeqWuGDZHfZ3 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Dec 2017 10:36:15 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E41F406D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 10:36:15 -0500 (EST)
In-Reply-To: <20171206151856.GH28074@char.us.oracle.com>
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
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 06/12/17 15:18, Konrad Rzeszutek Wilk wrote:
> On Wed, Dec 06, 2017 at 02:57:29PM +0000, Marc Zyngier wrote:
>> On 06/12/17 14:48, Konrad Rzeszutek Wilk wrote:
>>> On Wed, Dec 06, 2017 at 02:38:25PM +0000, Marc Zyngier wrote:
>>>> We're playing a dangerous game with struct alt_instr, as we produce
>>>> it using assembly tricks, but parse them using the C structure.
>>>> We just assume that the respective alignments of the two will
>>>> be the same.
>>>>
>>>> But as we add more fields to this structure, the alignment requirements
>>>> of the structure may change, and lead to all kind of funky bugs.
>>>>
>>>> TO solve this, let's move the definition of struct alt_instr to its
>>>> own file, and use this to generate the alignment constraint from
>>>> asm-offsets.c. The various macros are then patched to take the
>>>> alignment into account.
>>>
>>> Would it be better to use .p2align as on 32-bit ARM you must
>>> have it 4-byte aligned. Or at least have and BUILD_BUG_ON
>>> to make sure the size can be divided by four??
>>>
>>> Oh wait. You are not even touching ARM-32, how come? The alternative
>>> code can run on ARM-32 ...
>>
>> How? Given that I haven't written yet, I'd be grateful if you could
>> share your time machine...
> 
> Oh! I assumed it would be there as the Xen variant runs on ARM-32 and
> it borrowed a bunch of code from Linux. 

KVM definitely runs on 32bit, but doesn't have any alternative facility,
at least not in the way arm64 does.

> Please disregard my comment. I will go back to tweaking the time machine.

Let me know once you've debugged it, I have a couple of issues to
address in the past...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
