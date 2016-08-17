From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] kvm: arm: Enforce some NS-SVC initialisation
Date: Wed, 17 Aug 2016 11:05:29 +0100
Message-ID: <57B436E9.5050607@arm.com>
References: <5322cdb9cb397741d15b60c6693ad39dbf74b6d5.1469101945.git.robin.murphy@arm.com>
 <6d030bee2db08c2fe1b7569e692e8f66800b1e4c.1471369569.git.robin.murphy@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF923410B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 05:58:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gky72YFFqYr6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Aug 2016 05:58:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD36640F90
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 05:58:03 -0400 (EDT)
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
To: Robin Murphy <robin.murphy@arm.com>, christoffer.dall@linaro.org, linux@armlinux.org.uk
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 16/08/16 18:49, Robin Murphy wrote:
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

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
