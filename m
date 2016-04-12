From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 45/45] KVM: arm/arm64: vgic-new: enable build
Date: Tue, 12 Apr 2016 15:21:31 +0200
Message-ID: <20160412132131.GK3039@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-46-git-send-email-andre.przywara@arm.com>
 <20160331181850.GI4126@cbox>
 <570BB86E.2000208@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570BB86E.2000208@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 11, 2016 at 03:45:02PM +0100, Andre Przywara wrote:
> Hi,
> 
> On 31/03/16 19:18, Christoffer Dall wrote:
> > On Fri, Mar 25, 2016 at 02:05:08AM +0000, Andre Przywara wrote:
> >> Now that the new VGIC implementation has reached feature parity with
> >> the old one, add the new files to the build system and add a Kconfig
> >> option to switch between the two versions.
> >> We set the default to the new version to get maximum test coverage,
> >> in case people experience problems they can switch back to the old
> >> behaviour if needed.
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >>  arch/arm/kvm/Kconfig    |  7 +++++++
> >>  arch/arm/kvm/Makefile   | 10 ++++++++++
> >>  arch/arm64/kvm/Kconfig  |  7 +++++++
> >>  arch/arm64/kvm/Makefile | 10 ++++++++++
> >>  4 files changed, 34 insertions(+)
> >>
> >> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> >> index 95a0005..02abfff 100644
> >> --- a/arch/arm/kvm/Kconfig
> >> +++ b/arch/arm/kvm/Kconfig
> >> @@ -46,6 +46,13 @@ config KVM_ARM_HOST
> >>  	---help---
> >>  	  Provides host support for ARM processors.
> >>  
> >> +config KVM_NEW_VGIC
> >> +	bool "New VGIC implementation"
> >> +	depends on KVM
> >> +	default y
> >> +	---help---
> >> +	  uses the new VGIC implementation
> >> +
> > 
> > I had imagined we'd name it in the reverse, so the option would have
> > been CONFIG_KVM_VGIC_LEGACY, but I guess the net effect should be the
> > same, assuming most people just go with the default anyway.
> 
> I think originally the assumption was to make the old VGIC the default
> in the beginning, but that changed later. By that time I considered it
> too tedious to change all patches in this regard, so I just kept the old
> symbol and semantic in.
> Shouldn't matter, really, I guess there are arguments for both ways.
> 

Agreed, shouldn't matter.

-Christoffer
