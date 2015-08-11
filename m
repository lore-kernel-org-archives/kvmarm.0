From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 06/11] KVM: arm/arm64: vgic: Allow dynamic mapping of
 physical/virtual interrupts
Date: Tue, 11 Aug 2015 00:42:37 -0700
Message-ID: <20150811074221.GC5007@lvm>
References: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
 <1438962347-17541-7-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438962347-17541-7-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@linaro.org>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Aug 07, 2015 at 04:45:42PM +0100, Marc Zyngier wrote:
> In order to be able to feed physical interrupts to a guest, we need
> to be able to establish the virtual-physical mapping between the two
> worlds.
> 
> The mappings are kept in a set of RCU lists, indexed by virtual interrupts.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks for addressing all my concerns:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
