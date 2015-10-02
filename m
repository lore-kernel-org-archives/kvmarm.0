From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 01/15] KVM: arm/arm64: VGIC: don't track used LRs in
 the distributor
Date: Fri, 2 Oct 2015 11:32:15 +0100
Message-ID: <560E5D2F.1000401@arm.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-2-git-send-email-andre.przywara@arm.com>
 <00cb01d0fcf8$6a906000$3fb12000$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4019E41294
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 06:29:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5j-jwe+t4AHu for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2015 06:29:30 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBFF641278
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 06:29:29 -0400 (EDT)
In-Reply-To: <00cb01d0fcf8$6a906000$3fb12000$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,

On 02/10/15 10:55, Pavel Fedin wrote:
>  Hello! One more concern.
> 
>> Currently we track which IRQ has been mapped to which VGIC list
>> register and also have to synchronize both. We used to do this
>> to hold some extra state (for instance the active bit).
>> It turns out that this extra state in the LRs is no longer needed and
>> this extra tracking causes some pain later.
> 
>  Returning to the beginning, can you explain, what kind of pain exactly does it bring?
>  For some reasons here i had to keep all this tracking mechanism, and modified your patchset. I see
> no significant problems, except memory usage. I have to allocate vgic_irq_lr_map large enough to
> hold indexes up to 16384, and indexes from dist->nr_irqs to 8192 appear to be not used.

Yes, this was the main problem I was concerned about. Actually not so
much about memory usage really, but more about the idea of pushing the
concept of bitmaps beyond the point where it is a reasonable data
structure to use.
I briefly thought about extending the bitmaps, but that sounded like a
hack to me.
For instance how did you come up with that 16384? LPIs could actually be
much bigger (in fact the emulation currently support up to 64k).
In my opinion removing that tracking mechanism is actually a good idea.
Most implementations actually have only _four_ list registers and since
we keep them shadowed in our KVM data structure, iterating over all of
them is not really painful.

>  Since the map itself is actually used only for piggy-back optimization, it is possible to easily
> get rid of it using for_each_set_bit(lr, vgic_cpu->lr_used, vgic->nr_lr) iteration instead.

Can't you use the ELRSR bitmap instead? The idea of lr_used sounds like
a moot optimization to me.

Cheers,
Andre.

> The rest
> of mechanism will work as it is, there's no need to remove the state tracking bitmap and
> optimization itself.
>  I am currently testing this approach and preparing my alternative patch for upstreaming.
