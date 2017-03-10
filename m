From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 00/15] arm64/kvm: use common sysreg definitions
Date: Fri, 10 Mar 2017 18:42:24 +0000
Message-ID: <20170310184224.GE24571@leverpostej>
References: <1489079247-31092-1-git-send-email-mark.rutland@arm.com>
 <87a88tv94d.fsf@on-the-bus.cambridge.arm.com>
 <20170310183555.GB6271@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97B1C40A14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Mar 2017 13:41:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L+G-nUfcLF7H for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Mar 2017 13:41:10 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8F9640960
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Mar 2017 13:41:10 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170310183555.GB6271@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 10, 2017 at 06:35:55PM +0000, Will Deacon wrote:
> On Fri, Mar 10, 2017 at 08:17:22AM +0000, Marc Zyngier wrote:
> > On Thu, Mar 09 2017 at  5:07:12 pm GMT, Mark Rutland <mark.rutland@arm.com> wrote:
> > The next question is how do we merge this. Obviously, we can't split it
> > between trees, and this is very likely to clash with anything that we
> > will merge on the KVM side (the sysreg table is a popular place).
> > 
> > Will, Catalin: Would it make sense to create a stable branch with these
> > patches, and merge it into both the arm64 and KVM trees? That'd make
> > things easier...
> 
> I think the scope for conflict on our side is pretty high too, so a shared
> branch might be the best way to go. I don't want to branch just yet though,
> so I'll probably wait a week or so before setting something in stone.

Sure thing.

Let me know if you want me to rebase this, otherwise I'll leave my
current branch as-is.

Thanks,
Mark.
