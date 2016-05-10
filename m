From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 09/55] KVM: arm/arm64: Fix MMIO emulation data handling
Date: Tue, 10 May 2016 09:57:03 +0100
Message-ID: <5731A25F.4020203@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-10-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462531568-9799-10-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/05/16 11:45, Andre Przywara wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> When the kernel was handling a guest MMIO read access internally, we
> need to copy the emulation result into the run->mmio structure in order
> for the kvm_handle_mmio_return() function to pick it up and inject the
> 	result back into the guest.
> 
> Currently the only user of kvm_io_bus for ARM is the VGIC, which did
> this copying itself, so this was not causing issues so far.
> 
> But with the upcoming new vgic implementation we need this done
> properly.
> 
> Update the kvm_handle_mmio_return description and cleanup the code to
> only perform a single copying when needed.
> 
> Code and commit message inspired by Andre Przywara.
> 
> Reported-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
