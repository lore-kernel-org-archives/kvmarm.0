From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 05/12] KVM: arm/arm64: rename struct kvm_mmio_range to
 vgic_io_range
Date: Sat, 14 Mar 2015 15:43:50 +0100
Message-ID: <20150314144350.GK10935@cbox>
References: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
 <1426263012-22935-6-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426263012-22935-6-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, n.nikolaev@virtualopensystems.com, eric.auger@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 13, 2015 at 04:10:05PM +0000, Andre Przywara wrote:
> The name "kvm_mmio_range" is a bit bold, given that it only covers
> the VGIC's MMIO ranges. To avoid confusion with kvm_io_range, rename
> it to vgic_io_range.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
