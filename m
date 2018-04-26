From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 08/12] KVM: arm/arm64: Check vcpu redist base before
 registering an iodev
Date: Thu, 26 Apr 2018 12:12:56 +0200
Message-ID: <20180426101256.GC19872@C02W217FHV2R.local>
References: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
 <1523607658-9166-9-git-send-email-eric.auger@redhat.com>
 <20180424210759.GI4533@C02W217FHV2R.local>
 <73b8e64b-3c14-b937-487a-78f3cc73fde5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <73b8e64b-3c14-b937-487a-78f3cc73fde5@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org, andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 26, 2018 at 11:25:06AM +0200, Auger Eric wrote:
> Hi Christoffer,
> 
> On 04/24/2018 11:07 PM, Christoffer Dall wrote:
> > On Fri, Apr 13, 2018 at 10:20:54AM +0200, Eric Auger wrote:
> >> As we are going to register several redist regions,
> >> vgic_register_all_redist_iodevs() may be called several times. We need
> >> to register a redist_iodev for a given vcpu only once. 
> > 
> > Wouldn't it be more natural to change that caller to only register the
> > iodevs for that region?
> 
> vgic_register_redist_iodev() is the place where we decide where we map a
> given vcpu redist into a given redist region.
> 
> Calling vgic_register_redist_iodev for only the vcpus mapping to the
> redist region would force to inverse the logic. I think it would bring
> more upheavals in the code than bringing benefit?
> 
> This new check somehow corresponds to what we had before:
> "
> if (IS_VGIC_ADDR_UNDEF(vgic->vgic_redist_base))
>                 return 0;
> "

Ah, this is because we don't enforce any ordering between creating the
redistributors and initializing the vcpus, this always confuses me.

Fine, let's leave it as you suggest here.

Thanks,
-Christoffer
