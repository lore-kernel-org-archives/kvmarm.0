From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Thu, 8 Oct 2015 13:55:08 +0100
Message-ID: <CAFEAcA8RWqipM7LRXc-Se6xJ9FkbVm=2Mr=pe1pB_NnS2wfsvw@mail.gmail.com>
References: <1444247430-14808-1-git-send-email-christoffer.dall@linaro.org>
 <003a01d10199$58e96590$0abc30b0$@samsung.com> <20151008082302.GE14315@cbox>
 <005e01d101a9$31ee80f0$95cb82d0$@samsung.com> <20151008092858.GA16100@cbox>
 <561641F5.4060202@arm.com> <009501d101c4$dde8e2e0$99baa8a0$@samsung.com>
 <20151008123630.GC20936@cbox> <009901d101c7$3331b3b0$99951b10$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B426E413DC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 08:53:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fBJJ+UIhPHkb for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Oct 2015 08:53:28 -0400 (EDT)
Received: from mail-vk0-f44.google.com (mail-vk0-f44.google.com
 [209.85.213.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6CFEB412FA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 08:53:28 -0400 (EDT)
Received: by vkfp126 with SMTP id p126so31065747vkf.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Oct 2015 05:55:28 -0700 (PDT)
In-Reply-To: <009901d101c7$3331b3b0$99951b10$@samsung.com>
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
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 8 October 2015 at 13:45, Pavel Fedin <p.fedin@samsung.com> wrote:

>> Speaking of which, does the QEMU side of this patch set require first
>> adding the GICv3 emulation for the data structures or is there a
>> stand-alone migration patch set somewhere?
>
>  I rolled it out a week ago: https://www.mail-archive.com/qemu-devel@nongnu.org/msg325331.html. I
> tried to get reviewed/accepted/whatever at least data structure part, but Peter replied that he
> isn't interested before we have the kernel.

More specifically, I wanted us to agree on the kernel API for
migration, because that significantly affects how the QEMU
code looks.

A quick look at your patch suggests you still have data
structures like

+struct gicv3_irq_state {
+    /* The enable bits are only banked for per-cpu interrupts.  */
+    unsigned long *enabled;
+    unsigned long *pending;
+    unsigned long *active;
+    unsigned long *level;
+    unsigned long *group;
+    bool edge_trigger; /* true: edge-triggered, false: level-triggered  */
+    uint32_t mask_size; /* Size of bitfields in long's, for migration */
+};

I think it's probably going to be better to have an array
of redistributor structures (one per CPU), and then keep
the state that in hardware is in each redistributor inside
those sub-structures. Similarly for state that in hardware
is inside the distributor, and inside each cpu interface.

thanks
-- PMM
