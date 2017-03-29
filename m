From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 00/15] arm64/kvm: use common sysreg definitions
Date: Wed, 29 Mar 2017 10:55:32 +0100
Message-ID: <20170329095532.GA23442@leverpostej>
References: <1489079247-31092-1-git-send-email-mark.rutland@arm.com>
 <87a88tv94d.fsf@on-the-bus.cambridge.arm.com>
 <20170310183555.GB6271@arm.com>
 <20170322183512.GB27921@leverpostej>
 <20170328184828.GF8643@leverpostej> <20170328202931.GF20211@cbox>
 <20170329084146.GA15778@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AA3D40A69
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Mar 2017 05:53:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pQNWNlVJzgb5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Mar 2017 05:53:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB4E440966
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Mar 2017 05:53:55 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170329084146.GA15778@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 29, 2017 at 09:41:47AM +0100, Will Deacon wrote:
> On Tue, Mar 28, 2017 at 10:29:31PM +0200, Christoffer Dall wrote:
> > On Tue, Mar 28, 2017 at 07:48:28PM +0100, Mark Rutland wrote:
> > > On Wed, Mar 22, 2017 at 06:35:13PM +0000, Mark Rutland wrote:

> > > I think it would make sense for those to be in a common branch taken by
> > > both the arm64 and KVM trees, with the KVM-specific parts being taken by
> > > KVM alone atop of that.
> > > 
> > > Would everyone be happy with that?
> > 
> > I'm happy with that.
> > 
> > > For reference, I've updated my branches so that arm64/common-sysreg only
> > > contains the common parts, with the KVM parts atop of that in
> > > kvm/common-sysreg.
> > 
> > Will, Catalin:  Let me know if you're going to pull from common-sysreg
> > and I'll do the same and add the kvm patches above.
> 
> I think that's what we'll do, but Catalin's out this week (we're taking it
> in turns to go to work). I'd say go ahead and pull it into kvm if there
> aren't any conflicts. No need to wait for us.
> 
> Mark -- those branches are stable, right?

They are now. I will not touch either branch.

Thanks,
Mark.
