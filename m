From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm64: Implement branch predictor hardening for Falkor
Date: Mon, 8 Jan 2018 18:44:47 +0000
Message-ID: <20180108184446.GC13175@arm.com>
References: <1515184139-23743-1-git-send-email-shankerd@codeaurora.org>
 <20180108170933.GU25869@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 716BE49D6A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jan 2018 13:40:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aSMiDV8dlAxZ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jan 2018 13:40:05 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5041449D40
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jan 2018 13:40:05 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20180108170933.GU25869@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Sean Campbell <scampbel@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 08, 2018 at 05:09:33PM +0000, Will Deacon wrote:
> On Fri, Jan 05, 2018 at 02:28:59PM -0600, Shanker Donthineni wrote:
> > Falkor is susceptible to branch predictor aliasing and can
> > theoretically be attacked by malicious code. This patch
> > implements a mitigation for these attacks, preventing any
> > malicious entries from affecting other victim contexts.
> 
> Thanks, Shanker. I'll pick this up (fixing the typo pointed out by Drew).

Note that MIDR_FALKOR doesn't exist in mainline, so I had to drop those
changes too. See the kpti branch for details.

If you'd like anything else done here, please send additional patches to me
and Catalin that we can apply on top of what we currently have. Note that
I'm in the air tomorrow, so won't be picking up email.

Cheers,

Will
