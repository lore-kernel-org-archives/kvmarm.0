From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 06/11] KVM: arm/arm64: vgic: Allow dynamic mapping of
 physical/virtual interrupts
Date: Wed, 12 Aug 2015 10:56:38 +0100
Message-ID: <20150812105638.67de9423@arm.com>
References: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
	<1438962347-17541-7-git-send-email-marc.zyngier@arm.com>
	<20150811074221.GC5007@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150811074221.GC5007@lvm>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Eric Auger <eric.auger@linaro.org>, Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 11 Aug 2015 08:42:37 +0100
Christoffer Dall <christoffer.dall@linaro.org> wrote:

> On Fri, Aug 07, 2015 at 04:45:42PM +0100, Marc Zyngier wrote:
> > In order to be able to feed physical interrupts to a guest, we need
> > to be able to establish the virtual-physical mapping between the two
> > worlds.
> > 
> > The mappings are kept in a set of RCU lists, indexed by virtual interrupts.
> > 
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> Thanks for addressing all my concerns:
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks a lot for all the reviewing, much appreciated.

Unless someone has an objection, I'm going put this series (minus
the last patch) into -next so it gets a bit more exposure.

	M.
-- 
Jazz is not dead. It just smells funny.
