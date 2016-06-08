From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 08/13] KVM: arm64: implement basic ITS register
 handlers
Date: Wed, 8 Jun 2016 13:49:20 +0100
Message-ID: <57581450.1000402@arm.com>
References: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
 <1464962572-3925-9-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464962572-3925-9-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/06/16 15:02, Andre Przywara wrote:
> Add emulation for some basic MMIO registers used in the ITS emulation.
> This includes:
> - GITS_{CTLR,TYPER,IIDR}
> - ID registers
> - GITS_{CBASER,CREADR,CWRITER}
>   (which implement the ITS command buffer handling)
> 
> Most of the handlers are pretty straight forward, but CWRITER goes
> some extra miles to allow fine grained locking. The idea here
> is to let only the first instance iterate through the command ring
> buffer, CWRITER accesses on other VCPUs meanwhile will be picked up
> by that first instance and handled as well. The ITS lock is thus only
> held for very small periods of time and is dropped before the actual
> command handler is called.

On top of the comment I've already given on this patch:

You've completely ignored the GITS_BASERn registers. While they are not
strictly necessary for your emulation, we need them for save/restore. I
expect the next version of this patch to at least expose:
- Device table
- Collection table

Also, consider advertising the Indirect bit in the GITS_BASERn
describing the Device table, the guest will thank you for it (if the
support it).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
