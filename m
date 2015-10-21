From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PULL 3/6] KVM: arm: use GIC support unconditionally
Date: Wed, 21 Oct 2015 16:15:43 +0200
Message-ID: <3759605.BfhMCn7jyL@wuerfel>
References: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org> <9140096.cYCnE2rDUr@wuerfel> <20151021135844.GB13488@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151021135844.GB13488@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wednesday 21 October 2015 15:58:44 Christoffer Dall wrote:
> On Wed, Oct 21, 2015 at 03:45:20PM +0200, Arnd Bergmann wrote:
> > On Tuesday 20 October 2015 15:51:05 Paolo Bonzini wrote:
> > > Should this be "select" or "depends on"? Not a blocker, can always be fixed in 4.4.
> > 
> > We have lots of 'select ARM_GIC' in the tree for platforms that use one, using
> > 'depends on' will limit KVM support to being available only if at least one
> > of them is being used.
> > 
> > The only platform I can think of that uses ARMv7ve without actually having
> > a GIC is BCM2836 (Raspberry Pi 2). Can we actually run KVM on a platform
> > like that? If so, 'depends on' might be better, otherwise let's stay with
> > 'select'.
> 
> Yes you can, just without the VGIC and the timer - you have to emulate
> that in userspace.  Samsung also has a broken platform where they
> integrated things incorrectly, so you cannot use the VGIC, but that
> platform support is out of tree, so I can't see if it uses the GIC in
> general or not.

Ok, my patch should be fine then.
 
> I'm a bit confused why using 'depends on' in this case helps anythign?
> 
> (I know, I suck at dealing with the config system)

Generally speaking, 'select' causes more problems than 'depends on',
in particular when you get conflicting requirements (A selects B,
B depends on C, but A can be enabled without C).

However, symbols that only have 'select' and no 'depends on', and also
are not user-visible, are not problematic. This is the case here.

	Arnd
