From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v10 7/8] arm/arm64: vgic: Implement
 KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl
Date: Mon, 23 Jan 2017 11:41:41 +0000
Message-ID: <CAFEAcA9Odatt_JUshMXnBiq0DyO7LEN=yCWnjwHPyO8uj2tJNw@mail.gmail.com>
References: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
 <1480576187-5012-8-git-send-email-vijay.kilari@gmail.com>
 <20170120195338.GH13531@cbox>
 <CAFEAcA8bZUPC2YTBYTVY3oB4MJFJcKOgT77PN3vkp5gPjVRPgA@mail.gmail.com>
 <20170123110639.GA15850@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E2C34096F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 06:41:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RM8cIWoX4MRu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Jan 2017 06:41:57 -0500 (EST)
Received: from mail-vk0-f45.google.com (mail-vk0-f45.google.com
 [209.85.213.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5774540190
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 06:41:57 -0500 (EST)
Received: by mail-vk0-f45.google.com with SMTP id k127so88403530vke.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 03:42:02 -0800 (PST)
In-Reply-To: <20170123110639.GA15850@cbox>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 23 January 2017 at 11:06, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> ok, I think you're right that it can be done this way, but it has the
> unfortunate consequence of having to change a lot of the implementation.
>
> The reason is that we store the latch state in two different variables,
> depening on whether it's an edge- or level-triggered interrupts.
>
> We use the irq->pending field for the computed result (using above
> calculaiton) for level interrupts based on irq->line_level and
> irq->soft_pending.  soft_pending is the latch state for level interrupts
> only.
>
> For edge triggered interrupts the computed result and the latch state
> are alway the same (right?) so we we only use the irq->pending field for
> that.
>
> But unless I didn't have enough coffee this morning, this only works if
> you have a-priori knowledge of which interrupts are level and which are
> edge.  When this is not the case, as in the case of order-free
> save/restore, then I think the only solution is to rework the logic so
> that the soft_pending field is used for the latch state for both edge
> and level interrupts, and the pending field is just the internal
> computed value.

I *think* you could fudge it by saying "when the config changes
from edge to level, copy the current irq->pending into irq->soft_pending".
Then you can always read the latch state (it's soft_pending
if level, otherwise pending), and writing it is "set both if
level, just irq->pending if edge". That in turn gives you enough
information I think to cope with restores of all of (config,
level, pending-latch) in any order. It feels a bit fragile, though.

thanks
-- PMM
