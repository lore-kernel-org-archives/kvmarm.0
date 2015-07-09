From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC v2 0/6] IRQ bypass manager and irqfd consumer
Date: Thu, 9 Jul 2015 14:28:05 +0200
Message-ID: <20150709122805.GW18569@8bytes.org>
References: <1436184692-20927-1-git-send-email-eric.auger@linaro.org>
 <1436289468.1391.89.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436289468.1391.89.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, b.reynal@virtualopensystems.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 07, 2015 at 11:17:48AM -0600, Alex Williamson wrote:
> Hosting the bypass manager in kernel/irq seemed appropriate, but really
> it could be anywhere.  Does anyone have a different preference or
> specifically want it under their scope?  We had originally thought of
> this as an IOMMU service, but I think we've generalized it beyond that.
> I expect we should also add the necessary hooks to turn it into a
> loadable module to keep the tinification folks happy, I'll incorporate
> the current working changes and post a version with that.

Yeah, this is only an IOMMU service on x86, afaik. So drivers/iommu is
probably the wrong place to host it.

Will there be any other producers than VFIO or any other consumers than
KVM? If not, it should live in one of these spaces. KVM is probably the
best choice, as any hardware feature that uses this targets
virtualization, so there will hardly ever be another consumer than KVM.


	Joerg
