From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/3] arm64: Kill ESR_LNX_EXEC
Date: Thu, 2 Jun 2016 19:21:47 +0100
Message-ID: <20160602182146.GG7697@arm.com>
References: <1464694383-31700-1-git-send-email-mark.rutland@arm.com>
 <20160531165311.GD11321@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD756409A2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2016 14:17:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n8ZxMyRgjnZb for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jun 2016 14:17:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE656407AD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2016 14:17:33 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20160531165311.GD11321@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: marc.zyngier@arm.com, dave.martin@arm.com, shijie.huang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 31, 2016 at 05:53:11PM +0100, Catalin Marinas wrote:
> On Tue, May 31, 2016 at 12:33:00PM +0100, Mark Rutland wrote:
> > Mark Rutland (3):
> >   arm64: add macro to extract ESR_ELx.EC
> >   arm64/kvm: use ESR_ELx_EC to extract EC
> >   arm64: kill ESR_LNX_EXEC
> 
> For the series:
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

You may as well queue this for 4.8 when you start picking up patches.
I don't think it warrants going in for 4.7, since it doesn't actually
fix anything.

Will
