From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] kvm: arm: Enforce some NS-SVC initialisation
Date: Wed, 17 Aug 2016 13:17:51 +0200
Message-ID: <20160817111751.GG8808@cbox>
References: <5322cdb9cb397741d15b60c6693ad39dbf74b6d5.1469101945.git.robin.murphy@arm.com>
 <6d030bee2db08c2fe1b7569e692e8f66800b1e4c.1471369569.git.robin.murphy@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30F9E410B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 07:08:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LIEDqaQyUxue for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Aug 2016 07:08:24 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F45C40F90
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 07:08:23 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id i5so225220672wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 04:15:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <6d030bee2db08c2fe1b7569e692e8f66800b1e4c.1471369569.git.robin.murphy@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King <linux@arm.linux.org.uk>
Cc: marc.zyngier@arm.com, Robin Murphy <robin.murphy@arm.com>, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Russell,

On Tue, Aug 16, 2016 at 06:49:18PM +0100, Robin Murphy wrote:
> Since the non-secure copies of banked registers lack architecturally
> defined reset values, there is no actual guarantee when entering in Hyp
> from secure-only firmware that the Non-Secure PL1 state will look the
> way that kernel entry (in particular the decompressor stub) expects.
> So far, we've been getting away with it thanks to implementation details
> of ARMv7 cores and/or bootloader behaviour, but for the sake of forwards
> compatibility let's try to ensure that we have a minimally sane state
> before dropping down into it.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>

Can we have your acked-by on this patch to merge it via the KVM tree or
do you prefer merging this one directly yourself?

Thanks,
-Christoffer
