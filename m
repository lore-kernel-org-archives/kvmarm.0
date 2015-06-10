From: Radim <rkrcmar@redhat.com>
Subject: Re: should KVM or userspace be the one which decides what
 MIPIDR/affinity values to assign to vcpus?
Date: Wed, 10 Jun 2015 13:22:55 +0200
Message-ID: <20150610112255.GA27945@potion.brq.redhat.com>
References: <CAFEAcA-AY7rqcWmd13mpBuBWugbqwjzMdWfWt2N2rV0=7LT3KA@mail.gmail.com>
 <5576C559.2000902@arm.com>
 <CAFEAcA8x6BbHZPLj_U9HuZJs8i3n777vL=Gxs5V8pdmO+bsEcA@mail.gmail.com>
 <5576DBB5.3010100@arm.com>
 <CAFEAcA_y9DNLJTe+4kMBYObuKD82y0a05gsx6gOYZ8=Oo5LBGA@mail.gmail.com>
 <5576F177.3090903@arm.com>
 <CAFEAcA-GAsd7vWsmmZm6ikw+rRK2p7S3uNWBwYzTUGum12pyNA@mail.gmail.com>
 <5576F9A9.6010501@arm.com>
 <20150610115420.4319da55@nial.brq.redhat.com>
 <55781205.90303@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F28E5540EB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2015 07:12:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qsKkvsTEherl for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2015 07:12:42 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 98FFB540EA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2015 07:12:42 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <55781205.90303@arm.com>
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
Cc: Shlomo Pongratz <shlomo.pongratz@huawei.com>, Shlomo Pongratz <shlomopongratz@gmail.com>, Pavel Fedin <p.fedin@samsung.com>, QEMU Developers <qemu-devel@nongnu.org>, Shannon Zhao <shannon.zhao@linaro.org>, Ashok Kumar <ashoks@broadcom.com>, Igor Mammedov <imammedo@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

2015-06-10 11:31+0100, Marc Zyngier:
>On 10/06/15 10:54, Igor Mammedov wrote:
>> On Tue, 09 Jun 2015 15:35:21 +0100
>> Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> Indeed. I also missed the step that says "kernel is able to convert
>>> arbitrary MPIDR to vcpu_id in an efficient manner...". GICv3 is
>>> definitely going to require this.
>> x86 probably already has code that does this for APIC ID -> vcpu_id
> 
> Apparently not. kvm_irq_delivery_to_apic seems to iterate over the vcpus
> to find a match, and kvm_irq_delivery_to_apic_fast seems to rely on
> knowing some form of topology (and some more iteration).

kvm_irq_delivery_to_apic_fast optimizes APIC ID -> vcpu_id, by using
simple lookup arrays for various modes, with fallback to iteration for
broadcast and unlikely configurations.

Fast path only does iteration for multicast.  The APIC ID space is
sliced by 4(clustered xAPIC)/8(flat xAPIC)/16(x2APIC) APICs and any
number of APICs in a slice can be selected for delivery.
The guest can configure topology (xAPIC) or it is set by hardware
(x2APIC) and matches "real" topology only in rare cases.  ("Real"
topology is encoded in x2APIC ID by reserving bit ranges for "levels".)

> Overall, this looks awfully architecture specific, so it seems unlikely
> we can reuse that aspect.

Yes, the most that can be reused is an idea for a structure that gets
recomputed every time MPIDR -> vcpu_id mapping changes.

>                           I'm inclined to go for an rbtree mapping
> MPIDRs to vcpus. As this is likely to be on the fast path, I'd like this
> to me as lockless as possible though, which probably means that MPIDR
> would become RO as soon as any vcpu has started executing.

x86 KVM uses RCU protected structure for it, and even though APIC IDs
can be sparse, x86 prefers a single array.  (IDs usually aren't very
sparse, so a more complicated structure would be slower, harder to
handle, and take up more memory.)
