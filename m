From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm: vgic: Drop build compatibility hack for older
 kernel versions
Date: Thu, 1 Sep 2016 12:27:48 +0200
Message-ID: <20160901102748.GB10162@cbox>
References: <1472579659-20772-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA0E840C9D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 06:17:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wq0MHcvn9GBl for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2016 06:17:17 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85D6540BDA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 06:17:17 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id 1so86474699wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Sep 2016 03:25:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1472579659-20772-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 30, 2016 at 06:54:19PM +0100, Marc Zyngier wrote:
> As kvm_set_routing_entry() was changing prototype between 4.7 and 4.8,
> an ugly hack was put in place in order to survive both building in
> -next and the merge window.
> 
> Now that everything has been merged, let's dump the compatibility
> hack for good.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Applied, thanks.

  -Christoffer
