From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 09/10] KVM: arm/arm64: use vcpu requests for irq
 injection
Date: Mon, 8 May 2017 10:56:13 +0200
Message-ID: <20170508085613.GA21528@cbox>
References: <20170503160635.21669-1-drjones@redhat.com>
 <20170503160635.21669-10-drjones@redhat.com>
 <f5fbaba8-911e-7c2f-ba15-eca21b1f751a@redhat.com>
 <20170506184923.GE5923@cbox>
 <74607682-1da8-8299-900c-de5137e0b7f5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A872E408EB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 May 2017 04:53:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KxkRdvFnc7iI for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 May 2017 04:53:07 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E54A405DA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 May 2017 04:53:06 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id u65so76529215wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 May 2017 01:56:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <74607682-1da8-8299-900c-de5137e0b7f5@redhat.com>
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
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 08, 2017 at 10:48:57AM +0200, Paolo Bonzini wrote:
> 
> 
> On 06/05/2017 20:49, Christoffer Dall wrote:
> > On Thu, May 04, 2017 at 01:47:41PM +0200, Paolo Bonzini wrote:
> >>
> >>
> >> On 03/05/2017 18:06, Andrew Jones wrote:
> >>> Don't use request-less VCPU kicks when injecting IRQs, as a VCPU
> >>> kick meant to trigger the interrupt injection could be sent while
> >>> the VCPU is outside guest mode, which means no IPI is sent, and
> >>> after it has called kvm_vgic_flush_hwstate(), meaning it won't see
> >>> the updated GIC state until its next exit some time later for some
> >>> other reason.  The receiving VCPU only needs to check this request
> >>> in VCPU RUN to handle it.  By checking it, if it's pending, a
> >>> memory barrier will be issued that ensures all state is visible.
> >>> We still create a vcpu_req_irq_pending() function (which is a nop),
> >>> though, in order to allow us to use the standard request checking
> >>> pattern.
> >>
> >> I wonder if you aren't just papering over this race:
> >>
> >>         /*
> >>          * If there are no virtual interrupts active or pending for this
> >>          * VCPU, then there is no work to do and we can bail out without
> >>          * taking any lock.  There is a potential race with someone injecting
> >>          * interrupts to the VCPU, but it is a benign race as the VCPU will
> >>          * either observe the new interrupt before or after doing this check,
> >>          * and introducing additional synchronization mechanism doesn't change
> >>          * this.
> >>          */
> >>         if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
> >>                 return;
> >>
> >>         spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
> >>         vgic_flush_lr_state(vcpu);
> >>         spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
> >>
> >> not being so "benign" after all. :)  Maybe you can remove the if (list_empty()),
> >> and have kvm_arch_vcpu_ioctl_run do this instead:
> > 
> > I don't see how removing this shortcut improves anything.  You'd still
> > have the same window where you could loose an interrupt right after the
> > spin_unlock.
> 
> It's not removing it that matters; it's just unnecessary if you add
> KVM_REQ_IRQ_PENDING and you key the call to kvm_vgic_flush_hwstate on it.
> 

That doesn't work, because you can have active interrupts in flight long
after someone sent you that request which means you'll have interrupts
on the ap_list that you need to flush.

Thanks,
-Christoffer
