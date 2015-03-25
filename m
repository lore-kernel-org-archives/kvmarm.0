From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2 06/12] KVM: mark kvm->buses as empty once they were
 destroyed
Date: Wed, 25 Mar 2015 18:59:40 -0300
Message-ID: <20150325215940.GE3649@amt.cnet>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com>
 <1427126309-11223-7-git-send-email-andre.przywara@arm.com>
 <5512EBB9.2050304@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5512EBB9.2050304@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "n.nikolaev@virtualopensystems.com" <n.nikolaev@virtualopensystems.com>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 25, 2015 at 05:09:13PM +0000, Marc Zyngier wrote:
> On 23/03/15 15:58, Andre Przywara wrote:
> > In kvm_destroy_vm() we call kvm_io_bus_destroy() pretty early,
> > especially before calling kvm_arch_destroy_vm(). To avoid
> > unregistering devices from the already destroyed bus, let's mark
> > the bus with NULL to let other users know it has been destroyed
> > already.
> > This avoids a crash on a VM shutdown with the VGIC using the
> > kvm_io_bus later (the unregistering is in there to be able to roll
> > back a faulting init).
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 
> That seems sensible, but I don't see why nobody else hits that. What are
> we doing differently?

It should be valid to call kvm_io_bus_unregister_dev after
kvm_io_bus_destroy.

Are you patching it to handle NULL kvm->buses[bus_idx] ?

> Otherwise,
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> Paolo, Marcelo, can we have your Ack on this?
> 
> Thanks,

