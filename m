From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Warn when PARange is less than 40 bits
Date: Wed, 6 Apr 2016 13:32:13 +0200
Message-ID: <20160406113213.GB16355@cbox>
References: <1459869107-6367-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAD4040BDA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 07:30:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4LrRlXtPYpQH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2016 07:30:44 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A40F640402
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 07:30:43 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id u206so41248090wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2016 04:32:04 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1459869107-6367-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 05, 2016 at 04:11:47PM +0100, Marc Zyngier wrote:
> We always thought that 40bits of PA range would be the minimum people
> would actually build. Anything less is terrifyingly small.
> 
> Turns out that we were both right and wrong. Nobody has ever built
> such a system, but the ARM Foundation Model has a PARange set to 36bits.
> Just because we can. Oh well. Now, the KVM API explicitely says that
> we offer a 40bit PA space to the VM, so we shouldn't run KVM on
> the Foundation Model at all.
> 
> That being said, this patch offers a less agressive alternative, and
> loudly warns about the configuration being unsupported. You'll still
> be able to run VMs (at your own risks, though).
> 
> This is just a workaround until we have a proper userspace API where
> we report the PARange to userspace.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
