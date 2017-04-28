From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] arm64: Add ASM modifier for xN register operands
Date: Fri, 28 Apr 2017 08:18:52 +0100
Message-ID: <CAKv+Gu9s2t+Nt7JCcTxkr5BYSN05f_zxYkKzfrD-4owWQLvF_Q@mail.gmail.com>
References: <20170426214616.142580-1-mka@chromium.org>
 <20170427110256.GC31337@leverpostej>
 <20170427225221.GS128305@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B055541050
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Apr 2017 03:16:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GFDPkDSPUvkI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Apr 2017 03:15:59 -0400 (EDT)
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com
 [209.85.223.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FFB340DDB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Apr 2017 03:15:58 -0400 (EDT)
Received: by mail-io0-f175.google.com with SMTP id k87so52717959ioi.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Apr 2017 00:18:53 -0700 (PDT)
In-Reply-To: <20170427225221.GS128305@google.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Matthias Kaehlcke <mka@chromium.org>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg Hackmann <ghackmann@google.com>, Michael Davidson <md@google.com>, Grant Grundler <grundler@chromium.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Lameter <cl@linux.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 27 April 2017 at 23:52, Matthias Kaehlcke <mka@chromium.org> wrote:
> Hi Mark,
>
> Thanks for your comments.
>
> El Thu, Apr 27, 2017 at 12:02:56PM +0100 Mark Rutland ha dit:
>
>> Hi,
>>
>> On Wed, Apr 26, 2017 at 02:46:16PM -0700, Matthias Kaehlcke wrote:
>> > Many inline assembly statements don't include the 'x' modifier when
>> > using xN registers as operands. This is perfectly valid, however it
>> > causes clang to raise warnings like this:
>> >
>> > warning: value size does not match register size specified by the
>> >   constraint and modifier [-Wasm-operand-widths]
>> > ...
>> > arch/arm64/include/asm/barrier.h:62:23: note: expanded from macro
>> >   '__smp_store_release'
>> >     asm volatile ("stlr %1, %0"
>> >
>> > Add the modifiers to keep clang happy.
>>
>> If we're going to make this consistent, it would make sense to similarly
>> annotate 'w' regs. That will make it easier going forward to enforce a
>> policy that registers are suitably annotated.
>
> Ok
>
>> Also, there's a risk that we silently mask a bug here, for which clang's
>> warning is legitimate, so we need to review this very carefully...
>>
>> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>> > ---
>> > Changes in v2:
>> > - also add modifiers to multiline ASM statements in include/asm/
>> >   {atomic_ll_sc.h,irqflags.h,pgtable.h,uaccess.h,word-at-a-time.h}
>> >   that were missed on v1
>> >
>> >  arch/arm64/include/asm/arch_gicv3.h     |  2 +-
>> >  arch/arm64/include/asm/atomic_ll_sc.h   | 36 ++++++++++++++++-----------------
>> >  arch/arm64/include/asm/barrier.h        |  4 ++--
>> >  arch/arm64/include/asm/io.h             | 24 +++++++++++-----------
>> >  arch/arm64/include/asm/irqflags.h       | 10 ++++-----
>> >  arch/arm64/include/asm/kvm_hyp.h        | 10 ++++-----
>> >  arch/arm64/include/asm/kvm_mmu.h        | 12 +++++------
>> >  arch/arm64/include/asm/percpu.h         |  4 ++--
>> >  arch/arm64/include/asm/pgtable.h        | 20 +++++++++---------
>> >  arch/arm64/include/asm/sysreg.h         |  4 ++--
>> >  arch/arm64/include/asm/uaccess.h        | 14 ++++++-------
>> >  arch/arm64/include/asm/word-at-a-time.h | 14 ++++++-------
>> >  arch/arm64/kernel/armv8_deprecated.c    |  4 ++--
>> >  arch/arm64/kernel/probes/kprobes.c      |  2 +-
>> >  arch/arm64/kvm/hyp/switch.c             |  4 ++--
>> >  15 files changed, 82 insertions(+), 82 deletions(-)
>>
>> ... to that end, could you split these into a few patches?
>>
>> That way, knowledgeable people can focus their review on the code they
>> understand.
>>
>> That doesn't need to be a patch per file; all the KVM bits can be
>> collated in one patch, for example. However, the atomics, kvm, and
>> uaccess+word-at-a-time bits should certainly be separate patches given
>> their (existing) complexity.
>
> I agree the patch is too large, I considered to split it up but wasn't
> sure where to draw the line(s). Will try to find halfway reasonable
> batches :)
>
>> Otherwise, I have a couple of comments below.
>>
>> > diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
>> > index f37e3a21f6e7..ba54e5bee885 100644
>> > --- a/arch/arm64/include/asm/arch_gicv3.h
>> > +++ b/arch/arm64/include/asm/arch_gicv3.h
>> > @@ -166,7 +166,7 @@ static inline void gic_write_sre(u32 val)
>> >
>> >  static inline void gic_write_bpr1(u32 val)
>> >  {
>> > -   asm volatile("msr_s " __stringify(ICC_BPR1_EL1) ", %0" : : "r" (val));
>> > +   asm volatile("msr_s " __stringify(ICC_BPR1_EL1) ", %x0" : : "r" (val));
>> >  }
>>
>> Please make this use write_sysreg_s() instead, i.e.
>>
>> static inline void gic_write_bpr1(u32 val)
>> {
>>       write_sysreg_s(var, ICC_BPR1_EL1);
>> }
>>
>> ... that uses the 'x' modifier internally, and it's what we do for the
>> other GIC sysreg accesors.
>>
>> This accessor was missed by commit:
>>
>>   d44ffa5ae70a15a1 ("irqchip/gic-v3: Convert arm64 GIC accessors to {read,write}_sysreg_s")
>>
>> ... because it was added concurrently by commitL
>>
>>   91ef84428a86b75a ("irqchip/gic-v3: Reset BPR during initialization")
>>
>> ... i.e. it was not deliberately omitted.
>
> Will do
>
>> [...]
>>
>> > -   asm volatile("strb %w0, [%1]" : : "rZ" (val), "r" (addr));
>> > +   asm volatile("strb %w0, [%x1]" : : "rZ" (val), "r" (addr));
>>
>> In general, the '[%xN]' pattern looks *very* suspicious to me. Any
>> address must be 64-bit, so this would mask a legitimate warning.
>>
>> Given the prototype of this function the code if fine either way, but
>> were we to refactor things (e.g. making this a macro), that might not be
>> true.
>>
>> ... so I'm not sure it make sense to alter instances used for addresses.
>
> Good point, I'll leave instances dealing with addresses untouched for now.
>

OK, I am confused now. We started this thread under the assumption
that all unqualified placeholders are warned about by Clang. Given
that this appears not to be the case, could we please first find out
what causes the warnings? Is it necessary at all to add the x
modifiers for 64-bit types?
