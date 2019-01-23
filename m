From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 1/4] KVM: arm64: Forbid kprobing of the VHE world-switch
 code
Date: Wed, 23 Jan 2019 12:10:04 +0000
Message-ID: <e5c7a678-a574-d518-c2b5-1adcb649ff7d@arm.com>
References: <20190121170404.142966-1-james.morse@arm.com>
 <20190121170404.142966-2-james.morse@arm.com>
 <20190122121120.b781ced513220436da1e6d09@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98FAD4A3DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Jan 2019 07:10:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cNtZL68YqInx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Jan 2019 07:10:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A0BF4A3C1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Jan 2019 07:10:09 -0500 (EST)
In-Reply-To: <20190122121120.b781ced513220436da1e6d09@kernel.org>
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
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hello,

On 22/01/2019 03:11, Masami Hiramatsu wrote:
> On Mon, 21 Jan 2019 17:04:01 +0000
> James Morse <james.morse@arm.com> wrote:
>> On systems with VHE the kernel and KVM's world-switch code run at the
>> same exception level. Code that is only used on a VHE system does not
>> need to be annotated as __hyp_text as it can reside anywhere in the
>> kernel text.
>>
>> __hyp_text was also used to prevent kprobes from patching breakpoint
>> instructions into this region, as this code runs at a different
>> exception level. While this is no longer true with VHE, KVM still
>> switches VBAR_EL1, meaning a kprobe's breakpoint executed in the
>> world-switch code will cause a hyp-panic.

>> Annotate the VHE world-switch functions that aren't marked
>> __hyp_text as __kprobes.

>> ---
>> This has been an issue since the VHE/non-VHE world-switch paths were
>> split. Before then the code was common, and covered by __hyp_text, which
>> is always blacklisted by a subsequent patch.
> 
> Thank you very much for fixing it!
> 
> BTW, would you mind if I ask you using NOKPROBE_SYMBOL() macro instead of
> __kprobes attribute? __kprobes moves the function into __kprobe_text
> forcibly, OTOH, NOKPROBE_SYMBOL() has no such side-effect.

Aha, yes. __kprobes moves the function to a special section, whereas the macro
spits out the address of the function into the blacklist section, which is
processed via init_kprobes().
I used __kprobes as its in keeping with __hyp_text, but this is clearly better
as it doesn't restrict the layout of the code. (and it solves the
hibernate/kexec problems as those would otherwise need to be in two sections!)

For my own education, when should __kprobes be used? Is it legacy?


Thanks!

James
