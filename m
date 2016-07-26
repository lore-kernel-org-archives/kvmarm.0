From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: remove kvm_vgic_*early_init() functions
Date: Tue, 26 Jul 2016 14:43:24 +0200
Message-ID: <20160726124324.GB26002@cbox>
References: <20160705135043.13780-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160705135043.13780-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 05, 2016 at 02:50:43PM +0100, Andre Przywara wrote:
> kvm_vgic_early_init() and kvm_vgic_vcpu_early_init() were only used
> with the old VGIC, on the new VGIC these functions do nothing.
> Follow the comment in vgic-init.c and remove those functions and
> their calls.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
