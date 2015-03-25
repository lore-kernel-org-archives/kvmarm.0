From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 05/12] KVM: arm/arm64: rename struct kvm_mmio_range
 to vgic_io_range
Date: Wed, 25 Mar 2015 17:02:41 +0000
Message-ID: <5512EA31.8000502@arm.com>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com> <1427126309-11223-6-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427126309-11223-6-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "n.nikolaev@virtualopensystems.com" <n.nikolaev@virtualopensystems.com>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 23/03/15 15:58, Andre Przywara wrote:
> The name "kvm_mmio_range" is a bit bold, given that it only covers
> the VGIC's MMIO ranges. To avoid confusion with kvm_io_range, rename
> it to vgic_io_range.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
