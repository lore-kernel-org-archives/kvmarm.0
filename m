From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 14/28] arm64/sve: Backend logic for setting the vector
 length
Date: Thu, 5 Oct 2017 18:04:47 +0100
Message-ID: <20171005170446.GZ3611@e103592.cambridge.arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-15-git-send-email-Dave.Martin@arm.com>
 <20170913172911.3ca2h6cpju7etifi@localhost>
 <20170913190611.GC23415@e103592.cambridge.arm.com>
 <20170913221123.y4znytmxtplx24m4@localhost>
 <20171005164229.GX3611@e103592.cambridge.arm.com>
 <20171005165334.cstx6fszl7shaudg@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171005165334.cstx6fszl7shaudg@armageddon.cambridge.arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, gdb@sourceware.org, Yao Qi <Yao.Qi@arm.com>, Alan Hayward <alan.hayward@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 05, 2017 at 05:53:34PM +0100, Catalin Marinas wrote:
> On Thu, Oct 05, 2017 at 05:42:29PM +0100, Dave P Martin wrote:
> > On Wed, Sep 13, 2017 at 03:11:23PM -0700, Catalin Marinas wrote:
> > > On Wed, Sep 13, 2017 at 08:06:12PM +0100, Dave P Martin wrote:
> > > > On Wed, Sep 13, 2017 at 10:29:11AM -0700, Catalin Marinas wrote:

[...]

> > > > > Can this be merged with patch 20? It seems to add the PR_ definitions
> > > > > which get actually used later when the prctl interface is added.
> > > > 
> > > > This patch is used both by patch 19 and by patch 20, which I preferred
> > > > not to merge with each other: ptrace and prctl are significantly
> > > > different things.
> > > > 
> > > > The prctl bit definitions are added here because they are the canonical
> > > > definitions used by both interfaces.  The ptrace #defines are based on
> > > > them.
> > > > 
> > > > Does it make sense if I merge patch 20 into this one and apply patch 19
> > > > on top?  This avoide the appearance of prctl #defines with no prctl
> > > > implementation.
> > > 
> > > That's fine, you can bring patch 20 forward. If there are other
> > > non-trivial issues, feel free to ignore my comment.
> > 
> > I've had a go at this, but I think it's going to be more trouble than
> > it's worth -- there are other interdependencies between the patches
> > which make them tricky to reorder.
> > 
> > I could add a note in the commit message for this patch explaining why
> > the prctl flag #defines are being added here.  What do you think?
> 
> As I said, it's up to you. A line in the commit message would do.

OK, I think I'll stick with this then.

Cheers
---Dave
