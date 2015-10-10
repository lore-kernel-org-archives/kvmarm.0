From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: BUG FIX: Do not inject spurious
 interrupts
Date: Sat, 10 Oct 2015 17:00:36 +0200
Message-ID: <20151010150036.GC29128@cbox>
References: <1443189629-8744-1-git-send-email-p.fedin@samsung.com>
 <20150929072518.GC9002@cbox>
 <01b701d102a0$8b19c5c0$a14d5140$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53D8C411E2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Oct 2015 10:58:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id thIObzQQiO1H for <kvmarm@lists.cs.columbia.edu>;
 Sat, 10 Oct 2015 10:58:15 -0400 (EDT)
Received: from mail-lb0-f172.google.com (mail-lb0-f172.google.com
 [209.85.217.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 536A041022
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Oct 2015 10:58:14 -0400 (EDT)
Received: by lbbwt4 with SMTP id wt4so106932126lbb.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Oct 2015 08:00:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <01b701d102a0$8b19c5c0$a14d5140$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 09, 2015 at 05:41:11PM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > I reworked the commit message and applied this patch.
> 
>  During testing i discovered a problem with this patch and vITS series by Andre.
>  The problem is that compute_pending_for_cpu() does not know anything about LPIs. Therefore, we can
> reset this bit even if some LPIs (and only LPIs) are pending. This causes LPI loss.

I haven't looked at the ITS series in detail yet so I cannot commetn on
this.

>  This is the confirmation of that clearing irq_pending_on_cpu anywhere else than
> __kvm_vgic_flush_hwstate() is a bad idea. I would suggest to stick back to v1 of the patch (without
> clearing this bit). We can add a clarifying description to the commit message like this:
> 
> --- cut ---
> In some situations level-sensitive IRQ disappears before it has been
> processed. This is normal, and in this situation we lose this IRQ, the same
> as real HW does. The aim of this patch is to handle this situation more
> correctly. However, dist->irq_pending_on_cpu stays set until the vCPU
> itself rechecks its status. Therefore, this bit does not guarantee that
> something is pending at the given moment, it should be treated as attention
> flag, saying that something has happened on this vCPU, and it could have
> been even gone since that, but wakeup and status recheck is needed.
> --- cut ---

I really don't want to have an inconsistent state in our data
structures, this whole thing is plenty fragile as it is.

> 
>  Would you be happy with this? An alternative would be to add a check for pending LPIs, but wouldn't
> it just be too complex for a simple problem?
> 

My concern at this point is to try to keep this thing stable.

It is really up to whoever adds support for LPIs to make sure it's done
correctly.  So I think this is for Andre to work out in his ITS series.

This patch fixes an issue with the current code in the correct way as
far as I can tell.

Thanks,
-Christoffer
