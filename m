From: Will Deacon <will.deacon@arm.com>
Subject: Re: stand-alone kvmtool
Date: Wed, 25 Feb 2015 12:16:11 +0000
Message-ID: <20150225121610.GA12377@arm.com>
References: <54DDD465.3050300@arm.com>
 <20150218155042.GF22017@arm.com>
 <54EB622E.3020700@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54EB622E.3020700@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Pekka Enberg <penberg@iki.fi>
Cc: Andre Przywara <Andre.Przywara@arm.com>, Pekka Enberg <penberg@kernel.org>, Sasha Levin <sasha.levin@oracle.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Ronald Minnich <rminnich@google.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 23, 2015 at 05:23:58PM +0000, Pekka Enberg wrote:
> Hi,

Hi Pekka,

Sorry for the delay, I've been away from email for a few days.

> On 2/18/15 5:50 PM, Will Deacon wrote:
> > Thanks for doing this. Since it looks unlikely that kvmtool will ever be
> > merged back into the kernel tree, it makes sense to cut the dependency
> > in my opinion.
> 
> I am certainly OK with a standalone repository which preserves the 
> history. Will, would you like to take over the proposed new repository 
> and put it somewhere on git.kernel.org, perhaps?

Sure thing. I'll sync-up with Andre and reply back here when we've got
something sensible.

One extra point that I don't think has been mentioned in this thread so
far is that separating kvmtool from the kernel sources is likely a
prerequisite for distribution packaging. Once we've got something sorted
out, I'll poke some friendly local debian developers and see if they can't
package it up for us.

Will
