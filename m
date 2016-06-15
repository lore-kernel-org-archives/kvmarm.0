From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/5] arm/arm64: KVM: Tighten memory protection flags
Date: Wed, 15 Jun 2016 15:51:18 +0100
Message-ID: <20160615145118.GP24029@arm.com>
References: <1465826449-14349-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2609D41145
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2016 10:46:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A+mDZNmo4pJu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jun 2016 10:46:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2641410D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2016 10:46:47 -0400 (EDT)
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

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

Looks good to me. For the series:

Reviewed-by: Will Deacon <will.deacon@arm.com>

Will
