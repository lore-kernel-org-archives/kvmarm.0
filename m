From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] kvm: arm: Enforce some NS-SVC initialisation
Date: Tue, 6 Sep 2016 18:41:45 +0200
Message-ID: <20160906164145.GD23592@cbox>
References: <5322cdb9cb397741d15b60c6693ad39dbf74b6d5.1469101945.git.robin.murphy@arm.com>
 <6d030bee2db08c2fe1b7569e692e8f66800b1e4c.1471369569.git.robin.murphy@arm.com>
 <20160817113249.GA5909@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EF9249B3F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 12:30:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yeCLSwVebCXT for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 12:30:53 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA1B440B58
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 12:30:52 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id 1so200511254wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2016 09:39:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160817113249.GA5909@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King <linux@armlinux.org.uk>
Cc: marc.zyngier@arm.com, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 17, 2016 at 01:32:49PM +0200, Christoffer Dall wrote:
> Hi Russell,
> 
> On Tue, Aug 16, 2016 at 06:49:18PM +0100, Robin Murphy wrote:
> > Since the non-secure copies of banked registers lack architecturally
> > defined reset values, there is no actual guarantee when entering in Hyp
> > from secure-only firmware that the Non-Secure PL1 state will look the
> > way that kernel entry (in particular the decompressor stub) expects.
> > So far, we've been getting away with it thanks to implementation details
> > of ARMv7 cores and/or bootloader behaviour, but for the sake of forwards
> > compatibility let's try to ensure that we have a minimally sane state
> > before dropping down into it.
> > 
> > Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> 
> Can we have your acked-by on this patch to merge it via the KVM tree or
> do you prefer merging this one directly yourself?
> 
I have queued this via the KVM/ARM tree.  If you have any objections,
please let me know asap.

Thanks,
-Christoffer
