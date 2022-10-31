Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BC4FA3742
	for <kvmarm@archiver.kernel.org>; Mon, 31 Oct 2022 09:08:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 506974BAD4;
	Mon, 31 Oct 2022 05:08:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d1wC5eXSUn8B; Mon, 31 Oct 2022 05:08:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDAF14BAD1;
	Mon, 31 Oct 2022 05:08:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DC0F4BAD1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Oct 2022 05:08:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YiP9asQBxaCx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Oct 2022 05:08:32 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF4D84BAA8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Oct 2022 05:08:31 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 624C0CE12CA;
 Mon, 31 Oct 2022 09:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7249C433D6;
 Mon, 31 Oct 2022 09:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1667207304;
 bh=XyEyZaCaDS1iH/TW1RAmNRD0RiLTKVHIgX5Q3DeWWuU=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=j1Caxz5EOxkO32/byri0Ilor35vjDhbVjYAna7ij9xr2+J10VAJ+yqMHBO1aJx58O
 oBZQaNcICWP7tg6yk1sb2OKpN7OTq+NWQaa7HsEvJv+n5A6QOBhZ2bBMg2UErCaONI
 fYGnbMEnzq/MUX8bKr7o+lVc6bwm+pKfhECy+n4VvJjVWeRNkgDC3RpEtNmyHQX2rz
 AlsDwol0OLCC5nEkCz2UJU4biXxN/dE4bfyenbNGyjudTfT4g/2o1kBKrG/KTnQP8Q
 gudzXIskeXlVZ21LldUCjJVH7RBTik4AU20Z/tYOXw/NGO6vwXngswY9OiheYHSH/S
 F15Pdqq7PpzeA==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1opQmM-002h7u-A3;
 Mon, 31 Oct 2022 09:08:22 +0000
MIME-Version: 1.0
Date: Mon, 31 Oct 2022 09:08:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
In-Reply-To: <Y1wIj/sdJw7VMiY5@google.com>
References: <Y1LDRkrzPeQXUHTR@google.com> <87edv0gnb3.wl-maz@kernel.org>
 <Y1ckxYst3tc0LCqb@google.com> <Y1css8k0gtFkVwFQ@google.com>
 <878rl4gxzx.wl-maz@kernel.org> <Y1ghIKrAsRFwSFsO@google.com>
 <877d0lhdo9.wl-maz@kernel.org> <Y1rDkz6q8+ZgYFWW@google.com>
 <875yg5glvk.wl-maz@kernel.org>
 <36c97b96-1427-ce05-8fce-fd21c4711af9@redhat.com>
 <Y1wIj/sdJw7VMiY5@google.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <9e57cd7616974c783cce5026d61d310b@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: seanjc@google.com, gshan@redhat.com, oliver.upton@linux.dev,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 peterx@redhat.com, will@kernel.org, catalin.marinas@arm.com,
 bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev,
 dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 shan.gavin@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: shuah@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, dmatlack@google.com, shan.gavin@gmail.com,
 bgardon@google.com, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 zhenyzha@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2022-10-28 17:51, Sean Christopherson wrote:
> On Fri, Oct 28, 2022, Gavin Shan wrote:
>> Hi Sean and Marc,
>> 
>> On 10/28/22 2:30 AM, Marc Zyngier wrote:
>> > On Thu, 27 Oct 2022 18:44:51 +0100,
>> > Sean Christopherson <seanjc@google.com> wrote:
>> > >
>> > > On Thu, Oct 27, 2022, Marc Zyngier wrote:
>> > > > On Tue, 25 Oct 2022 18:47:12 +0100, Sean Christopherson <seanjc@google.com> wrote:
>> 
>> [...]
>> > >
>> > > > > And ideally such bugs would detected without relying on userspace to
>> > > > > enabling dirty logging, e.g. the Hyper-V bug lurked for quite some
>> > > > > time and was only found when mark_page_dirty_in_slot() started
>> > > > > WARNing.
>> > > > >
>> > > > > I'm ok if arm64 wants to let userspace shoot itself in the foot with
>> > > > > the ITS, but I'm not ok dropping the protections in the common
>> > > > > mark_page_dirty_in_slot().
>> > > > >
>> > > > > One somewhat gross idea would be to let architectures override the
>> > > > > "there must be a running vCPU" rule, e.g. arm64 could toggle a flag
>> > > > > in kvm->arch in its kvm_write_guest_lock() to note that an expected
>> > > > > write without a vCPU is in-progress:
>> > > > >
>> > > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> > > > > index 8c5c69ba47a7..d1da8914f749 100644
>> > > > > --- a/virt/kvm/kvm_main.c
>> > > > > +++ b/virt/kvm/kvm_main.c
>> > > > > @@ -3297,7 +3297,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>> > > > >          struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>> > > > >   #ifdef CONFIG_HAVE_KVM_DIRTY_RING
>> > > > > -       if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
>> > > > > +       if (!kvm_arch_allow_write_without_running_vcpu(kvm) && WARN_ON_ONCE(!vcpu))
>> > > > > +               return;
>> > > > > +
>> > > > > +       if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
>> > > > >                  return;
>> > > > >   #endif
>> > > > > @@ -3305,10 +3308,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>> > > > >                  unsigned long rel_gfn = gfn - memslot->base_gfn;
>> > > > >                  u32 slot = (memslot->as_id << 16) | memslot->id;
>> > > > > -               if (kvm->dirty_ring_size)
>> > > > > +               if (kvm->dirty_ring_size && vcpu)
>> > > > >                          kvm_dirty_ring_push(&vcpu->dirty_ring,
>> > > > >                                              slot, rel_gfn);
>> > > > > -               else
>> > > > > +               else if (memslot->dirty_bitmap)
>> > > > >                          set_bit_le(rel_gfn, memslot->dirty_bitmap);
>> > > > >          }
>> > > > >   }
> 
> ...
> 
>> > > A slightly different alternative would be have a completely separate
>> > > API for writing guest memory without an associated vCPU.  I.e. start
>> > > building up proper device emulation support.  Then the vCPU-based
>> > > APIs could yell if a vCPU isn't provided (or there is no running
>> > > vCPU in the current mess).  And the deviced-based API could be
>> > > provided if and only if the architecture actually supports emulating
>> > > writes from devices, i.e. x86 would not opt-in and so would even
>> > > have access to the API.
>> >
>> > Which is what I was putting under the "major surgery" label in my
>> > previous email.
>> >
>> > Anyhow, for the purpose of unblocking Gavin's series, I suggest to
>> > adopt your per-arch opt-out suggestion as a stop gap measure, and we
>> > will then be able to bike-shed for weeks on what the shape of the
>> > device-originated memory dirtying API should be.
>> >
>> 
>> It's really a 'major surgery' and I would like to make sure I fully 
>> understand
>> 'a completely separate API for writing guest memory without an 
>> associated vCPU",
>> before I'm going to working on v7 for this.
>> 
>> There are 7 functions and 2 macros involved as below. I assume Sean is 
>> suggesting
>> to add another argument, whose name can be 'has_vcpu', for these 
>> functions and macros?
> 
> No.
> 
> As March suggested, for your series just implement the hacky arch 
> opt-out, don't

Please call me April.

> try and do surgery at this time as that's likely going to be a
> months-long effort
> that touches a lot of cross-arch code.
> 
> E.g. I believe the ARM opt-out (opt-in?) for the above hack would be
> 
> bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
> {
> 	return vgic_has_its(kvm);
> }

Although that will probably lead to the expected effect,
this helper should only return true when the ITS is actively
dumped.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
