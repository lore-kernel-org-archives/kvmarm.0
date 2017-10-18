From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 5/5] KVM: arm/arm64: kvm_arch_vcpu_runnable: don't miss
 injected irqs
Date: Wed, 18 Oct 2017 16:14:47 +0200
Message-ID: <CAMJs5B_EKrwjNKi3PSd=kNWZSogo1aQy06HC+_jHBpRYQ=zvrw@mail.gmail.com>
References: <20170929113041.24371-1-drjones@redhat.com>
 <20170929113041.24371-6-drjones@redhat.com>
 <20171014191335.GD1929@lvm>
 <20171018121305.imlyjg7tssfjqc53@kamzik.brq.redhat.com>
 <20171018131843.GD8900@cbox>
 <20171018135557.zk25nurghtejt7xv@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61A6A40D25
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 10:13:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zIZAdTQFOo2i for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Oct 2017 10:13:47 -0400 (EDT)
Received: from mail-pf0-f196.google.com (mail-pf0-f196.google.com
 [209.85.192.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B10F40795
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 10:13:47 -0400 (EDT)
Received: by mail-pf0-f196.google.com with SMTP id i5so4057962pfe.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 07:14:48 -0700 (PDT)
In-Reply-To: <20171018135557.zk25nurghtejt7xv@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 18, 2017 at 3:55 PM, Andrew Jones <drjones@redhat.com> wrote:
> On Wed, Oct 18, 2017 at 03:18:43PM +0200, Christoffer Dall wrote:
>> On Wed, Oct 18, 2017 at 02:13:05PM +0200, Andrew Jones wrote:
>> > On Sat, Oct 14, 2017 at 09:13:35PM +0200, Christoffer Dall wrote:
>> > > On Fri, Sep 29, 2017 at 01:30:41PM +0200, Andrew Jones wrote:
>> > > > When the vPMU is in use if a VCPU's perf event overflow handler
>> > > > were to fire after the VCPU started waiting, then the wake up
>> > > > done by the kvm_vcpu_kick() call in the handler would do nothing,
>> > > > as no "pmu overflow" state is checked in kvm_arch_vcpu_runnable().
>> > > > Fix this by checking the IRQ_PENDING VCPU request in runnable().
>> > > > Checking the request also sufficiently covers all the cases that
>> > > > kvm_vgic_vcpu_pending_irq() cover, so we can just replace that.
>> > > >
>> > > > Signed-off-by: Andrew Jones <drjones@redhat.com>
>> > > > ---
>> > > >  virt/kvm/arm/arm.c | 2 +-
>> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
>> > > >
>> > > > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> > > > index 5bc9b0d2fd0f..725527f491e4 100644
>> > > > --- a/virt/kvm/arm/arm.c
>> > > > +++ b/virt/kvm/arm/arm.c
>> > > > @@ -423,7 +423,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>> > > >         return !vcpu_should_sleep(vcpu) &&
>> > > >                (vcpu->arch.mp_state != KVM_MP_STATE_HALTED ||
>> > > >                 (!!vcpu->arch.irq_lines ||
>> > > > -                kvm_vgic_vcpu_pending_irq(vcpu)));
>> > > > +                kvm_test_request(KVM_REQ_IRQ_PENDING, vcpu)));
>> > >
>> > > So what if a VCPU blocks, a device raises an IRQ, the VCPU loops around,
>> > > clears the KVM_REQ_IRQ_PENDING flag, enters the VM again, which does
>> > > another WFI (for fun), and you end up here again with a pending IRQ but
>> > > no KVM_REQ_IRQ_PENDING flag anymore.  Doesn't this end up incorrectly
>> > > stalling the VCPU?
>> >
>> > Hmm, I see what you mean. I'm sorry I missed that.
>> >
>> > >
>> > > I don't think that a transient flag will work for a persistent binary
>> > > state here.
>> >
>> > I think we can fix it by adding
>> >
>> >  if (kvm_vgic_vcpu_pending_irq(vcpu))
>> >      kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>> >
>> > to kvm_vgic_sync_hwstate(), if the additional overhead would be
>> > acceptable. Otherwise we need to find some other way to ensure
>> > vPMU irqs unblock the VCPU.
>> >
>>
>> I think you just need to check
>>   kvm_vgic_vcpu_pending_irq() ||
>>   kvm_test_request(KVM_REQ_IRQ_PENDING, vcpu)
>>
>> Wouldn't that fix it?
>
> It would. I was just hoping to eliminate the lock-taking
> kvm_vgic_vcpu_pending_irq() call from kvm_arch_vcpu_runnable()
> though, as kvm_arch_vcpu_runnable() may be called repeatedly
> during halt polling.
>

Could we make it so that the KVM_REQ_IRQ_PENDING request only gets
cleared when there are really no more pending IRQs for the VCPU then?

Getting rid of the lock would be potentially good from a latency point
of view, but then again, it's slow to wake up from WFI, and the lock
is per-VCPU so not likely to be contended is it?

Thanks,
-Christoffer
