From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] arm/arm64: KVM: Properly account for guest CPU time
Date: Mon, 01 Jun 2015 13:52:18 +0200
Message-ID: <556C4772.1070506@redhat.com>
References: <1432838950-28774-1-git-send-email-christoffer.dall@linaro.org> <556C0E22.9090401@de.ibm.com> <556C435D.3050900@redhat.com> <556C4510.80704@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <556C4510.80704@de.ibm.com>
Sender: kvm-owner@vger.kernel.org
To: Christian Borntraeger <borntraeger@de.ibm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu



On 01/06/2015 13:42, Christian Borntraeger wrote:
> Am 01.06.2015 um 13:34 schrieb Paolo Bonzini:
>>
>>
>> On 01/06/2015 09:47, Christian Borntraeger wrote:
>>>
>>> 1: "disable", "guest", "disable again and save", "restore to disable", "enable"
>>> and now it is
>>> 2: "disable", "guest", "enable"
>>> and with your patch it is
>>> 3: "disable", "guest", "enable", "disable, "enable"
>>>
>>> I assume that 3 and 1 are similar in its costs, so this is probably ok.
>>
>> At least on x86, 3 and 2 are similar, but 3 is much more expensive than
>> 1!  See https://lkml.org/lkml/2015/5/5/835:
> 
> That does not make sense. If 3 and 2 are similar, then 2 must be much more
> expensive than 1 as well. As 2 is a strict subset of 1 it must be cheaper, no?

Yes, it must.  I meant 3 is much cheaper than 1.

Paolo

>> Cost of: CLI                         insn  same-IF :     0 cycles
>> Cost of: CLI                         insn  flip-IF :     0 cycles
>> Cost of: STI                         insn  same-IF :     0 cycles
>> Cost of: STI                         insn  flip-IF :     0 cycles
>> Cost of: PUSHF                       insn          :     0 cycles
>> Cost of: POPF                        insn  same-IF :    20 cycles
>> Cost of: POPF                        insn  flip-IF :    28 cycles
>> Cost of: local_irq_save()            fn            :    20 cycles
>> Cost of: local_irq_restore()         fn    same-IF :    24 cycles
>> Cost of: local_irq_restore()         fn    flip-IF :    28 cycles
>> Cost of: irq_save()+restore()        fn    same-IF :    48 cycles
>> Cost of: irq_save()+restore()        fn    flip-IF :    48 cycles
> 
> Yes its similar on s390. local_irq_save/restore is noticable in guest exit
> hot loops (thats what inspired my patch), but a simple irq disable is
> just single cycle pipelined. Given the design of aggressive out-out order
> designs with all the architectural ordering this makes sense.
> 
> Christian
> 
