From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 08/12] KVM: arm/arm64: implement kvm_io_bus MMIO handling
 for the VGIC
Date: Wed, 25 Mar 2015 17:18:16 +0000
Message-ID: <5512EDD8.5060708@arm.com>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com> <1427126309-11223-9-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427126309-11223-9-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "n.nikolaev@virtualopensystems.com" <n.nikolaev@virtualopensystems.com>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 23/03/15 15:58, Andre Przywara wrote:
> Currently we use a lot of VGIC specific code to do the MMIO
> dispatching.
> Use the previous reworks to add kvm_io_bus style MMIO handlers.
> 
> Those are not yet called by the MMIO abort handler, also the actual
> VGIC emulator function do not make use of it yet, but will be enabled
> with the following patches.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
