From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 0/2] KVM: arm/arm64: Restore host physical timer access
 on panic
Date: Mon, 15 May 2017 10:18:40 +0200
Message-ID: <20170515081840.GG9309@cbox>
References: <20170425170245.4294-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EB9C40BE3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 04:15:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 73EWPi5hbnef for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 May 2017 04:15:25 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6ECF40187
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 04:15:25 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id u65so72593360wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 01:18:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170425170245.4294-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On Tue, Apr 25, 2017 at 06:02:43PM +0100, James Morse wrote:
> Hi!
> 
> On arm64, with a single CPU when I trigger hyp_panic() with the guest
> registers loaded, I get two traces:
> 
> [ 8736.164022] Kernel panic - not syncing: HYP panic:

[...]

> 
> This is because the physical timer access is still trapped to EL2, causing
> a second __guest_exit(), this time without the host context on the stack.
> 
> Once I get 32bit hyp_panic() to restore the hosts banked registers, I get the
> same:
> [  164.799341] Kernel panic - not syncing:

[...]

Thanks for these.

Reviewed-by: Christoffer Dall <cdall@linaro.org>

And applied to kvmarm/queue.

-Christoffer
