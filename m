From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 00/21] SError rework + RAS&IESB for firmware first
 support
Date: Mon, 20 Nov 2017 09:53:19 +0100
Message-ID: <20171120085319.GC28855@cbox>
References: <20171019145807.23251-1-james.morse@arm.com>
 <5A049B20.6000501@arm.com> <20171113112946.GK14144@cbox>
 <CAFEAcA_yRT7829=reU=vnAiHWy-9oP1G84v0w_ST8C3VxpskNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73D0749D19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Nov 2017 03:50:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 30HOZQLy8VCC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Nov 2017 03:50:43 -0500 (EST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D146949D15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Nov 2017 03:50:42 -0500 (EST)
Received: by mail-wm0-f49.google.com with SMTP id 128so8439118wmo.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Nov 2017 00:53:12 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAFEAcA_yRT7829=reU=vnAiHWy-9oP1G84v0w_ST8C3VxpskNA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Jonathan.Zhang@cavium.com, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, wangxiongfeng2@huawei.com, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 13, 2017 at 01:05:19PM +0000, Peter Maydell wrote:
> On 13 November 2017 at 11:29, Christoffer Dall <cdall@linaro.org> wrote:
> > I'm thinking this is analogous to migrating a VM that uses an irqchip in
> > userspace and has set the IRQ or FIQ lines using KVM_IRQ_LINE.  My
> > feeling is that this is also not supported today.
> 
> Oops, yes, we completely forgot about migration when we added
> that feature... I think you're right that we won't get that right.

So I think it might actually work for the timer, because we migrate the
timer state, and I think QEMU migrates the timer-to-GIC line state, and
if we're licky the IRQ line from the userspace GIC to the KVM VCPU would
get updated after restore.

But in general, KVM_IRQ_LINE values don't get migrated, and I think
that's a problem we've probably had from the initial implementation, and
not introduced with userspace timers support.

IIRC, QEMU is really happy to continously call KVM_IRQ_LINE with the
same value (which could potentially be further optimized), and that
currently may hide this problem.

Still, it's something we should look at and ensure is correct,
especially when adding a new similar state that needs migration.

Thanks,
-Christoffer
