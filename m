From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] ARM: KVM: Fix idmap stub entry when running Thumb-2 code
Date: Thu, 20 Apr 2017 21:02:23 +0200
Message-ID: <20170420190223.GF4104@cbox>
References: <20170420150221.15796-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93FE641010
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Apr 2017 14:59:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9+d0L8LdCgLB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Apr 2017 14:59:40 -0400 (EDT)
Received: from mail-wr0-f179.google.com (mail-wr0-f179.google.com
 [209.85.128.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1934240DFF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Apr 2017 14:59:39 -0400 (EDT)
Received: by mail-wr0-f179.google.com with SMTP id z52so231115wrc.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Apr 2017 12:02:20 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170420150221.15796-1-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 20, 2017 at 04:02:21PM +0100, Marc Zyngier wrote:
> When entering the hyp stub implemented in the idmap, we try to
> be mindful of the fact that we could be running a Thumb-2 kernel
> by adding 1 to the address we compute. Unfortunately, the assembler
> also knows about this trick, and has already generated an address
> that has bit 0 set in the litteral pool.
> 
> Our superfluous correction ends up confusing the CPU entierely,
> as we now branch to the stub in ARM mode instead of Thumb, and on
> a possibly unaligned address for good measure. From that point,
> nothing really good happens.
> 
> The obvious fix in to remove this stupid target PC correction.
> 
> Fixes: 6bebcecb6c5b ("ARM: KVM: Allow the main HYP code to use the init hyp stub implementation")
> Reported-by: Christoffer Dall <cdall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

This works, thanks.

Applied to kvmarm/next.
-Christoffer
