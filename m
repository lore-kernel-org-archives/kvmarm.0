From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 06/10] arm: simplify MMIO dispatching
Date: Wed, 24 Jun 2015 14:30:05 +0100
Message-ID: <558AB0DD.1070704@arm.com>
References: <1434540121-21283-1-git-send-email-andre.przywara@arm.com>
 <1434540121-21283-7-git-send-email-andre.przywara@arm.com>
 <55816C9F.1090500@arm.com> <55817B07.8010502@arm.com>
 <55817EEA.9060402@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 434D056DF1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 09:18:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HGkOP4sxgRE7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jun 2015 09:18:52 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCC2B56DF3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 09:18:51 -0400 (EDT)
In-Reply-To: <55817EEA.9060402@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <Will.Deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "penberg@kernel.org" <penberg@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Will,

do you want me to respin the whole series to address the remaining minor
comments in the last four patches or do you want to take patch 01-06
already (which I think Marc has already agreed upon)?
Then I would just send an updated version of the remaining patches.

Cheers,
Andre.


....

> No, that's fine.
> 
> I just wondered what was the rational behind having the
> arm_addr_in_pci_region() call there. It might have guarded something,
> but if you're absolutely positive that this doesn't cause a regression,
> that's OK with me.
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> 	M.
> 
