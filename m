From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2] arm/arm64: KVM: Properly account for guest CPU time
Date: Mon, 01 Jun 2015 13:42:08 +0200
Message-ID: <556C4510.80704@de.ibm.com>
References: <1432838950-28774-1-git-send-email-christoffer.dall@linaro.org>
 <556C0E22.9090401@de.ibm.com> <556C435D.3050900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AD0F52A5C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jun 2015 07:32:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RjqUD1nJCvM3 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Jun 2015 07:32:19 -0400 (EDT)
Received: from e06smtp15.uk.ibm.com (e06smtp15.uk.ibm.com [195.75.94.111])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF75E52A56
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jun 2015 07:32:17 -0400 (EDT)
Received: from /spool/local
 by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <kvmarm@lists.cs.columbia.edu> from <borntraeger@de.ibm.com>;
 Mon, 1 Jun 2015 12:42:12 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com
 (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
 by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 06DA1219005E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jun 2015 12:41:49 +0100 (BST)
Received: from d06av06.portsmouth.uk.ibm.com (d06av06.portsmouth.uk.ibm.com
 [9.149.37.217])
 by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 t51Bg9fj23658572
 for <kvmarm@lists.cs.columbia.edu>; Mon, 1 Jun 2015 11:42:09 GMT
Received: from d06av06.portsmouth.uk.ibm.com (localhost [127.0.0.1])
 by d06av06.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 t516ZiAt029048
 for <kvmarm@lists.cs.columbia.edu>; Mon, 1 Jun 2015 02:35:44 -0400
In-Reply-To: <556C435D.3050900@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Am 01.06.2015 um 13:34 schrieb Paolo Bonzini:
> 
> 
> On 01/06/2015 09:47, Christian Borntraeger wrote:
>>
>> 1: "disable", "guest", "disable again and save", "restore to disable", "enable"
>> and now it is
>> 2: "disable", "guest", "enable"
>> and with your patch it is
>> 3: "disable", "guest", "enable", "disable, "enable"
>>
>> I assume that 3 and 1 are similar in its costs, so this is probably ok.
> 
> At least on x86, 3 and 2 are similar, but 3 is much more expensive than
> 1!  See https://lkml.org/lkml/2015/5/5/835:

That does not make sense. If 3 and 2 are similar, then 2 must be much more
expensive than 1 as well. As 2 is a strict subset of 1 it must be cheaper, no?


> 
> Cost of: CLI                         insn  same-IF :     0 cycles
> Cost of: CLI                         insn  flip-IF :     0 cycles
> Cost of: STI                         insn  same-IF :     0 cycles
> Cost of: STI                         insn  flip-IF :     0 cycles
> Cost of: PUSHF                       insn          :     0 cycles
> Cost of: POPF                        insn  same-IF :    20 cycles
> Cost of: POPF                        insn  flip-IF :    28 cycles
> Cost of: local_irq_save()            fn            :    20 cycles
> Cost of: local_irq_restore()         fn    same-IF :    24 cycles
> Cost of: local_irq_restore()         fn    flip-IF :    28 cycles
> Cost of: irq_save()+restore()        fn    same-IF :    48 cycles
> Cost of: irq_save()+restore()        fn    flip-IF :    48 cycles

Yes its similar on s390. local_irq_save/restore is noticable in guest exit
hot loops (thats what inspired my patch), but a simple irq disable is
just single cycle pipelined. Given the design of aggressive out-out order
designs with all the architectural ordering this makes sense.

Christian
