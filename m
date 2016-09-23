From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5] KVM: arm/arm64: Route vtimer events to user space
Date: Fri, 23 Sep 2016 11:19:40 +0200
Message-ID: <71706c4a-3182-2308-8273-12aba35fccc6@redhat.com>
References: <1474548769-195643-1-git-send-email-agraf@suse.de>
 <20160922212831.GD9101@cbox> <d90f04d4-b29f-f08e-df39-ec307af44225@suse.de>
 <63a1e3a2-f551-017f-b6be-593b53a0b407@redhat.com>
 <7afbc08e-0ba2-d6fd-c1ed-e5822e05c00b@suse.de>
 <e4c08096-03bd-3ec3-998d-41643992ab1a@redhat.com>
 <70fc788d-f99e-4ba5-67a2-da9c1a857dfe@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6285B49B59
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 05:10:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TZFaSBum64B2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Sep 2016 05:10:35 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB3FF49B46
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 05:10:35 -0400 (EDT)
In-Reply-To: <70fc788d-f99e-4ba5-67a2-da9c1a857dfe@suse.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 23/09/2016 11:17, Alexander Graf wrote:
>> > 
>> > On the other hand, what happens if you run new QEMU with old userspace?
>> > With user_timer_pending you'd get an infinite stream of vmexits the
>> > first time the timer fires, wouldn't you?  Whereas if you keep it in the
>> > kernel, userspace would simply not get the interrupt (because it doesn't
>> > know about kernel_timer_pending) and think it got a spurious vmexit.
>> > The kernel's IRQ would stay masked and everything would just (not) work
>> > like before your patch?
> Yes, we'd definitely stay more compatible by tracking it only in the
> kernel. I'm not fully convinced that it's the better interface, but
> since both Christoffer and you seem to choke on that part, I'll give it
> a stab ;).

Cool!  FWIW my suggestion for kernel_timer_pending's name would be
timer_irq_level (nicely matching timer->irq.level in the kernel).

Paolo
