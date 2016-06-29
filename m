From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 0/5] arm/arm64: KVM: Tighten memory protection flags
Date: Wed, 29 Jun 2016 14:21:18 +0200
Message-ID: <20160629122118.GU26498@cbox>
References: <1465826449-14349-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72B6A49B1A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 08:15:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9lkzIRBY2MqO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jun 2016 08:15:17 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F72C49AF5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 08:15:16 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id a66so70989250wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 05:20:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1465826449-14349-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On Mon, Jun 13, 2016 at 03:00:44PM +0100, Marc Zyngier wrote:
> So far, the HYP mappings have been fairly relaxed: everything is
> RWX. Oddly enough, not everybody is fond of this kind of permissions
> at the highest exception level.
> 
> This small series tightens it a bit by making:
> - the text mapping read-only
> - the rodata mapping read-only + no-exec
> - everything else read-write + no-exec
> 
> Of course, that's only valid when VHE is not in action. Tested on
> Seattle and Cubietruck, based on 4.7-rc2.
> 

I have applied this to queue with a RB on all the patches.

It seems like this series applies on top of the merged page tables
stuff, but since I think you're going to repost that, I have just
applied this and fixed up the conflicts.

Could you have a look at kvmarm/queue and let me know if you think it
looks good?  (and possibly rebase the merge page tables stuff on top of
there when you rework that series?)

Thanks!
-Christoffer
