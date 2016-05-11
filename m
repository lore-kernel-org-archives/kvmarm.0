From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PULL 00/29] KVM/ARM Changes for v4.7
Date: Wed, 11 May 2016 17:42:52 +0200
Message-ID: <20160511154252.GX27623@cbox>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
 <57334E72.9010109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5729049B35
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 11:39:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ML7XGRkNc3zB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 11:39:18 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E55F49B34
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 11:39:18 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id e201so224444747wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 08:42:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <57334E72.9010109@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 11, 2016 at 05:23:30PM +0200, Paolo Bonzini wrote:
> 
> 
> On 11/05/2016 15:29, Christoffer Dall wrote:
> > Hi Paolo and Radim,
> > 
> > Here is the initial set of changes for KVM/ARM for v4.7.
> > 
> > Sorry I'm a bit late with these, but we were trying to get the new vgic
> > implementation in as part of this, but I have decided to send this pull
> > request now, and we can follow up with another for the new VGIC,
> > assuming we feel like we have that in place in a few days.
> 
> Don't worry, you're not late at all.  I've pulled this to kvm/queue.
> 
> > There are a few changes in this pull request touching things outside
> > KVM, but they should all carry the necessary acks and it made the
> > merge process much easier to do it this way.
> 
> The following are properly acked:
> 
>     arm64: Reuse TCR field definitions for EL1 and EL2
>     arm64: Introduce pmd_thp_or_huge
> 
> I wouldn't have minded more explicit Acked-bys for the following:
> 
>     irqchip/gic-v2: Gather ACPI specific data in a single structure
>     irqchip/gic-v2: Parse and export virtual GIC information
>     irqchip/gic-v3: Prefix all pr_* messages by "GICv3: "
>     irqchip/gic-v3: Gather all ACPI specific data in a single structure
>     irqchip/gic-v3: Parse and export virtual GIC information
> 
> I guess it's fine since Marc Zyngier is maintainer for both KVM and
> irqchip, still it's never wrong to get more acks. :)
> 
Jason Cooper also acked them all; I swear I intended to add his acks to
all of these specifically, but I must've forgotten.

I have forwarded you his ack for reference.  Let me know if you need me
to do anything else.

Thanks,
-Christoffer
