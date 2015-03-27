From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 09/11] KVM: arm/arm64: merge GICv3 RD_base and
 SGI_base register frames
Date: Fri, 27 Mar 2015 17:01:10 +0100
Message-ID: <20150327160110.GE5121@cbox>
References: <1427380778-942-1-git-send-email-andre.przywara@arm.com>
 <1427380778-942-10-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427380778-942-10-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>, kvmarm@lists.cs.columbia.edu, n.nikolaev@virtualopensystems.com, eric.auger@linaro.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 26, 2015 at 02:39:36PM +0000, Andre Przywara wrote:
> Currently we handle the redistributor registers in two separate MMIO
> regions, one for the overall behaviour and SPIs and one for the
> SGIs/PPIs. That latter forces the creation of _two_ KVM I/O bus
> devices for each redistributor.
> Since the spec mandates those two pages to be contigious, we could as
> well merge them and save the churn with the second KVM I/O bus device.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
