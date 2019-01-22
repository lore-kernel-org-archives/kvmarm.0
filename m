From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 0/2] KVM: arm/arm64: Add VCPU workarounds firmware register
Date: Tue, 22 Jan 2019 13:56:34 +0000
Message-ID: <20190122135632.GF3578@e103592.cambridge.arm.com>
References: <20190107120537.184252-1-andre.przywara@arm.com>
 <20190122101657.GE3578@e103592.cambridge.arm.com>
 <86a7jt9cc2.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <86a7jt9cc2.wl-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 22, 2019 at 11:11:09AM +0000, Marc Zyngier wrote:
> On Tue, 22 Jan 2019 10:17:00 +0000,
> Dave Martin <Dave.Martin@arm.com> wrote:
> > 
> > On Mon, Jan 07, 2019 at 12:05:35PM +0000, Andre Przywara wrote:
> > > Workarounds for Spectre variant 2 or 4 vulnerabilities require some help
> > > from the firmware, so KVM implements an interface to provide that for
> > > guests. When such a guest is migrated, we want to make sure we don't
> > > loose the protection the guest relies on.
> > > 
> > > This introduces two new firmware registers in KVM's GET/SET_ONE_REG
> > > interface, so userland can save the level of protection implemented by
> > > the hypervisor and used by the guest. Upon restoring these registers,
> > > we make sure we don't downgrade and reject any values that would mean
> > > weaker protection.
> > 
> > Just trolling here, but could we treat these as immutable, like the ID
> > registers?  
> > 
> > We don't support migration between nodes that are "too different" in any
> > case, so I wonder if adding complex logic to compare vulnerabilities and
> > workarounds is liable to create more problems than it solves...
> 
> And that's exactly the case we're trying to avoid. Two instances of
> the same HW. One with firmware mitigations, one without. Migrating in
> one direction is perfectly safe, migrating in the other isn't.
> 
> It is not about migrating to different HW at all.

So this is a realistic scenario when deploying a firmware update across
a cluter that has homogeneous hardware -- there will temporarly be
different firmware versions running on different nodes?

My concern is really "will the checking be too buggy / untested in
practice to be justified by the use case".

I'll take a closer look at the checking logic.

Cheers
---Dave
