From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: Forbid kprobing of the VHE
 world-switch code
Date: Thu, 31 Jan 2019 18:53:06 +0000
Message-ID: <2711e333-bbe2-a207-604c-43c2c84cef38@arm.com>
References: <20190124163257.233929-1-james.morse@arm.com>
 <20190124163257.233929-2-james.morse@arm.com>
 <20190131080841.GK13482@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B45734A321
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 13:53:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hG6NQZXG37F4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Jan 2019 13:53:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23F474A319
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 13:53:11 -0500 (EST)
In-Reply-To: <20190131080841.GK13482@e113682-lin.lund.arm.com>
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
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Masami Hiramatsu <mhiramat@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hey Christoffer,

On 31/01/2019 08:08, Christoffer Dall wrote:
> On Thu, Jan 24, 2019 at 04:32:54PM +0000, James Morse wrote:
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
> 
> Forgive potentially very stupid questions here, but:
> 
>  (1) Would it make sense to move the save/restore VBAR_EL1 to the last
>      possible moment, and would that actually allow kprobes to work for
>      the world-switch code, or does that just result in other weird
>      problems?

This would work for taking the debug exception. But next kprobes wants to
single-step the probed instruction in an out-of-line slot. I don't think we can
do this if we've already configured the debug hardware for the guest.
(If could at least turn single-step off when we return to guest-EL0, which
guest-EL1 was single-stepping)


>  (2) Are we sure that this catches every call path of every non-inlined
>      function called after switchign VBAR_EL1?  Can kprobes only be
>      called on exported symbols, or can you (if you know the address
>      somehow) put a kprobe on a static function as well.  If there are
>      any concerns in this area, we might want to consider (1) more
>      closely.

Hmmm, good question. The blacklisting applies to whole symbols as seen by
kallsyms, the compiler has no idea what is going on.

If it chose not to inline something, it would be kprobe'able yes.

__kprobes uses a section function-attribute instead. The gcc manual[0] doesn't
say what happens when inline and the section attributes are used together. (or
at least I couldn't find it)

A quick experiment with gcc 8.2.0 shows adding __kprobes on the inlines gets
discarded when they are inlined. I'm not sure how to trick the compiler into
not-inlining it to see what happens, but adding 'noinline' to the header file
causes it to duplicate the function everywhere, but puts it in the __kprobes
section.

(For KVM we could use the 'flatten' attribute, but that does say 'if possible'.
Alternatively we can decorate all the inline helpers we know we use with
__kprobes as a safety net.)

I think this is a wider problem with kprobes.


Thanks,

James

[0]
https://gcc.gnu.org/onlinedocs/gcc-8.2.0/gcc/Common-Function-Attributes.html#Common-Function-Attributes
