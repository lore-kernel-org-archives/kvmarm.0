From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] KVM: arm64: add workaround for Cortex-A57 erratum #852523
Date: Mon, 14 Sep 2015 18:01:11 +0100
Message-ID: <20150914170111.GH23878@arm.com>
References: <1442243163-2675-1-git-send-email-will.deacon@arm.com>
 <55F6EBD4.30809@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55F6EBD4.30809@arm.com>
Sender: stable-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 14, 2015 at 04:46:28PM +0100, Marc Zyngier wrote:
> On 14/09/15 16:06, Will Deacon wrote:
> > When restoring the system register state for an AArch32 guest at EL2,
> > writes to DACR32_EL2 may not be correctly synchronised by Cortex-A57,
> > which can lead to the guest effectively running with junk in the DACR
> > and running into unexpected domain faults.
> > 
> > This patch works around the issue by re-ordering our restoration of the
> > AArch32 register aliases so that they happen before the AArch64 system
> > registers. Ensuring that the registers are restored in this order
> > guarantees that they will be correctly synchronised by the core.
> > 
> > Cc: <stable@vger.kernel.org>
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> I'll queue that together with the next batch of fixes.

Great, thanks Marc.

Will
