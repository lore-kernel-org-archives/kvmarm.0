From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: Route vtimer events to user space
Date: Fri, 16 Sep 2016 11:44:33 +0200
Message-ID: <20160916094433.GA4794@cbox>
References: <1474002553-30079-1-git-send-email-agraf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EFDD41145
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 05:35:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8KBog6rN+v4h for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2016 05:35:44 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2BB540FA2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 05:35:44 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id b187so27317827wme.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 02:44:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1474002553-30079-1-git-send-email-agraf@suse.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Alex,

On Fri, Sep 16, 2016 at 07:09:13AM +0200, Alexander Graf wrote:
> We have 2 modes for dealing with interrupts in the ARM world. We can either
> handle them all using hardware acceleration through the vgic or we can emulate
> a gic in user space and only drive CPU IRQ pins from there.
> 
> Unfortunately, when driving IRQs from user space, we never tell user space
> about timer events that may result in interrupt line state changes, so we
> lose out on timer events if we run with user space gic emulation.
> 
> This patch set fixes that by routing vtimer expiration events to user space.
> With this patch I can successfully run edk2 and Linux with user space gic
> emulation.

I have two versions of v2.  Are there any differences or did it just go
out twice or got duplicated somehow on my end?

Thanks,
-Christoffer
