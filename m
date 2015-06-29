From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/3] arm/arm64: speed up spinlocks and atomic ops
Date: Mon, 29 Jun 2015 14:53:21 +0200
Message-ID: <20150629125321.GL11332@cbox>
References: <1435248739-25425-1-git-send-email-drjones@redhat.com>
 <1435248739-25425-3-git-send-email-drjones@redhat.com>
 <20150629102832.GJ11332@cbox>
 <20150629104427.GB2948@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150629104427.GB2948@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 29, 2015 at 12:44:27PM +0200, Andrew Jones wrote:
> On Mon, Jun 29, 2015 at 12:28:32PM +0200, Christoffer Dall wrote:
> > On Thu, Jun 25, 2015 at 06:12:18PM +0200, Andrew Jones wrote:
> > > spinlock torture tests made it clear that checking mmu_enabled()
> > > every time we call spin_lock is a bad idea.
> > 
> > why a bad idea?  Does it break, is it slow?
> 
> Just slow, but really slow. After porting vos' spinlock test
> over, there were three implementations to compare, this one,
> gcc-builtin, and none. none doesn't really matter as it's not
> "real". gcc-builtin took about 6 seconds to complete on my
> machine (an x86 notebook, recall it's a tcg test), and this one
> took 20 seconds.
> 
> > 
> > > As most tests will
> > > want the MMU enabled the entire time, then just hard code
> > > mmu_enabled() to true. Tests that want to play with the MMU can
> > > be compiled with CONFIG_MAY_DISABLE_MMU to get the actual check
> > > back.
> > 
> > If we don't care about performance, why this added complexity?
> 
> I think the series I sent that allows us to optimize mmu_enabled()
> has about the same level of complexity, not much, but now we also
> only take 6 seconds with the test. So, IMO, the extra _count
> variable is worth it.
> 
ok, sounds good.  I didn't see the other series before I glanced at this
one, and the other one didn't look that complicated.

-Christoffer
