From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [RFC v2 06/10] KVM: arm/arm64: Update the physical timer
 interrupt level
Date: Wed, 1 Feb 2017 03:40:10 -0500
Message-ID: <CAHyh4xjTWK0HeQhX9X6+6Ez706Sh4+=3wMq0b9rmvGTbD8q80g@mail.gmail.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-7-git-send-email-jintack@cs.columbia.edu>
 <86sho199jx.fsf@arm.com> <20170201080440.GB6226@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB0DF40783
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 03:39:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VFEDyA-ophre for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Feb 2017 03:39:54 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F93640666
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 03:39:53 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v118d65n053142
 for <kvmarm@lists.cs.columbia.edu>; Wed, 1 Feb 2017 03:40:14 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id BAF8C87
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 03:40:14 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id 280E48B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 03:40:13 -0500 (EST)
Received: from mail-ua0-f197.google.com (mail-ua0-f197.google.com
 [209.85.217.197])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v118eCGd016501
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Wed, 1 Feb 2017 03:40:13 -0500
Received: by mail-ua0-f197.google.com with SMTP id i68so231034127uad.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Feb 2017 00:40:12 -0800 (PST)
Received: from mail-ua0-f171.google.com (mail-ua0-f171.google.com.
 [209.85.217.171])
 by smtp.gmail.com with ESMTPSA id q78sm7047965vkb.17.2017.02.01.00.40.11
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Wed, 01 Feb 2017 00:40:11 -0800 (PST)
Received: by mail-ua0-f171.google.com with SMTP id 35so291342117uak.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Feb 2017 00:40:11 -0800 (PST)
In-Reply-To: <20170201080440.GB6226@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: KVM General <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux@armlinux.org.uk, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Andre Przywara <andre.przywara@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 1, 2017 at 3:04 AM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Sun, Jan 29, 2017 at 03:21:06PM +0000, Marc Zyngier wrote:
>> On Fri, Jan 27 2017 at 01:04:56 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
>> > Now that we maintain the EL1 physical timer register states of VMs,
>> > update the physical timer interrupt level along with the virtual one.
>> >
>> > Note that the emulated EL1 physical timer is not mapped to any hardware
>> > timer, so we call a proper vgic function.
>> >
>> > Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>> > ---
>> >  virt/kvm/arm/arch_timer.c | 20 ++++++++++++++++++++
>> >  1 file changed, 20 insertions(+)
>> >
>> > diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>> > index 0f6e935..3b6bd50 100644
>> > --- a/virt/kvm/arm/arch_timer.c
>> > +++ b/virt/kvm/arm/arch_timer.c
>> > @@ -180,6 +180,21 @@ static void kvm_timer_update_mapped_irq(struct kvm_vcpu *vcpu, bool new_level,
>> >     WARN_ON(ret);
>> >  }
>> >
>> > +static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>> > +                            struct arch_timer_context *timer)
>> > +{
>> > +   int ret;
>> > +
>> > +   BUG_ON(!vgic_initialized(vcpu->kvm));
>>
>> Although I've added my fair share of BUG_ON() in the code base, I've
>> since reconsidered my position. If we get in a situation where the vgic
>> is not initialized, maybe it would be better to just WARN_ON and return
>> early rather than killing the whole box. Thoughts?
>>
>
> Could we help this series along by saying that since this BUG_ON already
> exists in the kvm_timer_update_mapped_irq function, then it just
> preserves functionality and it's up to someone else (me) to remove the
> BUG_ON from both functions later in life?
>

Sounds good to me :) Thanks!

> Thanks,
> -Christoffer
>
