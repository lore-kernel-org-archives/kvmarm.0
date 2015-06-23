From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC 0/6] KVM: arm/arm64: gsi routing support
Date: Tue, 23 Jun 2015 11:44:44 +0200
Message-ID: <55892A8C.6050600@linaro.org>
References: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
 <5587CA18.6050101@arm.com> <5587D398.8040002@linaro.org>
 <052d01d0ad87$8a2a90e0$9e7fb2a0$@samsung.com> <55890FB2.2090609@linaro.org>
 <001701d0ad91$ad985850$08c908f0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E94625644B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2015 05:34:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JPy6gMk3urYP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Jun 2015 05:34:11 -0400 (EDT)
Received: from mail-wi0-f176.google.com (mail-wi0-f176.google.com
 [209.85.212.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F7FE5639B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2015 05:34:11 -0400 (EDT)
Received: by wicgi11 with SMTP id gi11so10981773wic.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2015 02:45:04 -0700 (PDT)
In-Reply-To: <001701d0ad91$ad985850$08c908f0$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, 'Andre Przywara' <andre.przywara@arm.com>, eric.auger@st.com
Cc: 'Marc Zyngier' <Marc.Zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Favel,
On 06/23/2015 10:50 AM, Pavel Fedin wrote:
>  Hello!
> 
>> I was talking about what
>> is done without this "gsi direct mapping" feature. In that case the low
>> GSI numbers are used by irqchip routing entries. So kvm_irqchip_get_virq
>> returns a gsi beyond the irqchip routed gsi's.
> 
>  But aren't these low numbers just routed by the qemu too? I don't see qemu getting any predefined
> routing from the kernel. 

(some) iqrchip routing is set through kvm_irqchip_add_irq_route.
hw/i386/kvm/ioapic.c
hw/intc/openpic_kvm.c

kvm_irqchip_add_irq_route uses kvm_add_routing_entry and this is this
latter that uses set_gsis which books gsi's.

there is also a default gsi routing table set in kvm archi specific code.

Best Regards

Eric

kvm_init_irq_routing() allocates used_gsi_bitmap as all zeros, and
> kvm_irqchip_get_virq() just starts to give those free numbers, starting from zero. I believe during
> machine init we allocate virq's and route them to irqchip explicitly, don't we ?
>  Sorry for being perhaps ignorant, i haven't studied x86 qemu code too much.

> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
> 
