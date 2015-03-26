From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 09/11] KVM: arm/arm64: merge GICv3 RD_base and
 SGI_base register frames
Date: Thu, 26 Mar 2015 21:53:08 +0000
Message-ID: <20150326215308.74b994ff@arm.com>
References: <1427380778-942-1-git-send-email-andre.przywara@arm.com>
	<1427380778-942-10-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427380778-942-10-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: christoffer.dall@linaro.org, pbonzini@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, n.nikolaev@virtualopensystems.com, eric.auger@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 26 Mar 2015 14:39:36 +0000
Andre Przywara <andre.przywara@arm.com> wrote:

> Currently we handle the redistributor registers in two separate MMIO
> regions, one for the overall behaviour and SPIs and one for the
> SGIs/PPIs. That latter forces the creation of _two_ KVM I/O bus
> devices for each redistributor.
> Since the spec mandates those two pages to be contigious, we could as
> well merge them and save the churn with the second KVM I/O bus device.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

I wonder why we didn't have it that way the first place...

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
