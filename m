From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 3/3] arm64/kvm: use alternative auto-nop
Date: Thu, 8 Sep 2016 12:33:39 +0100
Message-ID: <20160908113339.GB26570@leverpostej>
References: <1473242830-26246-1-git-send-email-mark.rutland@arm.com>
 <1473242830-26246-4-git-send-email-mark.rutland@arm.com>
 <20160908111648.GZ23592@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8AD149B2F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2016 07:25:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H7VUIQ81vfAq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Sep 2016 07:25:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B206149AF5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2016 07:25:25 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20160908111648.GZ23592@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, will.deacon@arm.com, dave.martin@arm.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Sep 08, 2016 at 01:16:48PM +0200, Christoffer Dall wrote:
> On Wed, Sep 07, 2016 at 11:07:10AM +0100, Mark Rutland wrote:
> > Make use of the new alternative_if and alternative_else_nop_endif and
> > get rid of our homebew NOP sleds, making the code simpler to read.
> 
> homebew?

Whoops. Should have been 'homebrew', though I'll change that to
'open-coded' to make this clearer.

> > Note that for __kvm_call_hyp the branch to __vhe_hyp_call has been moved
> > out of the alternative sequence, and in the default case there will be
> > four additional NOPs executed.
> > 
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > Cc: Christoffer Dall <christoffer.dall@linaro.org>
> > Cc: kvmarm@lists.cs.columbia.edu
> 
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Cheers!

Mark.
