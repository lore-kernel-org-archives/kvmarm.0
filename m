From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [RFC v2 00/10] Provide the EL1 physical timer to the VM
Date: Mon, 30 Jan 2017 14:02:28 -0500
Message-ID: <CAHyh4xiErc288_bj=YmtADcZj5rUG8ryMrW+dP428gxDuOJCUQ@mail.gmail.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <86h94h97yn.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADCDD40905
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 14:02:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r3IhDyxWfdEA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Jan 2017 14:02:12 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6DFA40430
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 14:02:12 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0UIw57E004818
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 14:02:30 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id B82058E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 14:02:30 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id 6008181
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 14:02:30 -0500 (EST)
Received: from mail-ua0-f197.google.com (mail-ua0-f197.google.com
 [209.85.217.197])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0UJ2UGt000980
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 14:02:30 -0500
Received: by mail-ua0-f197.google.com with SMTP id i68so205648014uad.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 11:02:30 -0800 (PST)
Received: from mail-ua0-f169.google.com (mail-ua0-f169.google.com.
 [209.85.217.169])
 by smtp.gmail.com with ESMTPSA id s9sm5175395vke.11.2017.01.30.11.02.28
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 30 Jan 2017 11:02:29 -0800 (PST)
Received: by mail-ua0-f169.google.com with SMTP id 35so257007507uak.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 11:02:28 -0800 (PST)
In-Reply-To: <86h94h97yn.fsf@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: KVM General <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux@armlinux.org.uk, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Andre Przywara <andre.przywara@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On Sun, Jan 29, 2017 at 10:55 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> Hi Jintack,
>
> On Fri, Jan 27 2017 at 01:04:50 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
>> The ARM architecture defines the EL1 physical timer and the virtual timer,
>> and it is reasonable for an OS to expect to be able to access both.
>> However, the current KVM implementation does not provide the EL1 physical
>> timer to VMs but terminates VMs on access to the timer.
>>
>> This patch series enables VMs to use the EL1 physical timer through
>> trap-and-emulate.  The KVM host emulates each EL1 physical timer register
>> access and sets up the background timer accordingly.  When the background
>> timer expires, the KVM host injects EL1 physical timer interrupts to the
>> VM.  Alternatively, it's also possible to allow VMs to access the EL1
>> physical timer without trapping.  However, this requires somehow using the
>> EL2 physical timer for the Linux host while running the VM instead of the
>> EL1 physical timer.  Right now I just implemented trap-and-emulate because
>> this was straightforward to do, and I leave it to future work to determine
>> if transferring the EL1 physical timer state to the EL2 timer provides any
>> performance benefit.
>>
>> This feature will be useful for any OS that wishes to access the EL1
>> physical timer. Nested virtualization is one of those use cases. A nested
>> hypervisor running inside a VM would think it has full access to the
>> hardware and naturally tries to use the EL1 physical timer as Linux would
>> do. Other nested hypervisors may try to use the EL2 physical timer as Xen
>> would do, but supporting the EL2 physical timer to the VM is out of scope
>> of this patch series. This patch series will make it easy to add the EL2
>> timer support in the future, though.
>>
>> Note that Linux VMs booting in EL1 will be unaffected by this patch series
>> and will continue to use only the virtual timer and this patch series will
>> therefore not introduce any performance degredation as a result of
>> trap-and-emulate.
>
> Thanks for respining this series. Overall, this looks quite good, and
> the couple of comments I have should be easy to address.

Thanks for the review!

>
> My main concern is that we do expose a timer that doesn't hide
> CNTVOFF. I appreciate that that was already the case, since CNTPCT was
> always available (and this avoided trapping the counter), but maybe we
> should have a way for userspace to ask for a mode where CNTPCT=CNTVCT,
> byt trapping the physical counter and taking CNTVOFF in all physical
> timer calculations.

As discussed in the other thread, I think we can expose CNTVOFF to the
guest OS. I have a patch that lets the guest hypervisor observe CNTVCT
= CNTPCT - offset (virtual CNTVOFF_EL2) and I will include it in the
next nesting patch series.

Thanks,
Jintack

>
> I'm pretty sure you've addressed this one way or another in your nested
> virt series, so maybe extracting the relevant patches and adding them on
> top of this series could be an option?
>
> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny.
>
