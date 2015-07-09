From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC v2 0/6] IRQ bypass manager and irqfd consumer
Date: Thu, 09 Jul 2015 08:13:43 -0600
Message-ID: <1436451223.1391.219.camel@redhat.com>
References: <1436184692-20927-1-git-send-email-eric.auger@linaro.org>
	 <1436289468.1391.89.camel@redhat.com> <20150709122805.GW18569@8bytes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150709122805.GW18569@8bytes.org>
Sender: kvm-owner@vger.kernel.org
To: Joerg Roedel <joro@8bytes.org>
Cc: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, b.reynal@virtualopensystems.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 2015-07-09 at 14:28 +0200, Joerg Roedel wrote:
> On Tue, Jul 07, 2015 at 11:17:48AM -0600, Alex Williamson wrote:
> > Hosting the bypass manager in kernel/irq seemed appropriate, but really
> > it could be anywhere.  Does anyone have a different preference or
> > specifically want it under their scope?  We had originally thought of
> > this as an IOMMU service, but I think we've generalized it beyond that.
> > I expect we should also add the necessary hooks to turn it into a
> > loadable module to keep the tinification folks happy, I'll incorporate
> > the current working changes and post a version with that.
> 
> Yeah, this is only an IOMMU service on x86, afaik. So drivers/iommu is
> probably the wrong place to host it.
> 
> Will there be any other producers than VFIO or any other consumers than
> KVM? If not, it should live in one of these spaces. KVM is probably the
> best choice, as any hardware feature that uses this targets
> virtualization, so there will hardly ever be another consumer than KVM.

If we think that it's *only* a kvm-vfio interaction then we could add it
to virt/kvm/vfio.c.  vfio could use symbol_get to avoid a module
dependency and effectively disable the code path when not used with kvm.
The reverse model of hosting it in vfio and using symbol_get from
kvm-vfio would also work.  Do we really want to declare it to be
kvm-vfio specific though?  Another option would be to simply host it
under virt/lib with module dependencies for both vfio and kvm.  Thanks,

Alex

