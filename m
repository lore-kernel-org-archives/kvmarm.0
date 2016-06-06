From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 0/3] arm64: Kill ESR_LNX_EXEC
Date: Mon, 6 Jun 2016 11:59:42 +0100
Message-ID: <20160606105942.GD6831@leverpostej>
References: <1464694383-31700-1-git-send-email-mark.rutland@arm.com>
 <20160531165311.GD11321@e104818-lin.cambridge.arm.com>
 <20160602182146.GG7697@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FFBD412ED
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2016 06:55:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dBfCEixKgoKL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jun 2016 06:55:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4FE2410EB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2016 06:55:53 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20160602182146.GG7697@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, dave.martin@arm.com, shijie.huang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 02, 2016 at 07:21:47PM +0100, Will Deacon wrote:
> On Tue, May 31, 2016 at 05:53:11PM +0100, Catalin Marinas wrote:
> > On Tue, May 31, 2016 at 12:33:00PM +0100, Mark Rutland wrote:
> > > Mark Rutland (3):
> > >   arm64: add macro to extract ESR_ELx.EC
> > >   arm64/kvm: use ESR_ELx_EC to extract EC
> > >   arm64: kill ESR_LNX_EXEC
> > 
> > For the series:
> > 
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> You may as well queue this for 4.8 when you start picking up patches.
> I don't think it warrants going in for 4.7, since it doesn't actually
> fix anything.

Makes sense to me.

Catalin, I've dropped this in my git repo for the moment [1], and can
rebase/repost as/when required. Please give me a poke if so.

Thanks,
Mark.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/kill-esr-lnx-exec
