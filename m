From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: check IRQ number on userland injection
Date: Mon, 13 Apr 2015 12:02:45 +0200
Message-ID: <20150413100245.GI6186@cbox>
References: <1428679079-16499-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1428679079-16499-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 10, 2015 at 04:17:59PM +0100, Andre Przywara wrote:
> When userland injects a SPI via the KVM_IRQ_LINE ioctl we currently
> only check it against a fixed limit, which historically is set
> to 127. With the new dynamic IRQ allocation the effective limit may
> actually be smaller (64).
> So when now a malicious or buggy userland injects a SPI in that
> range, we spill over on our VGIC bitmaps and bytemaps memory.
> I could trigger a host kernel NULL pointer dereference with current
> mainline by injecting some bogus IRQ number from a hacked kvmtool:
> -----------------
> ....
> DEBUG: kvm_vgic_inject_irq(kvm, cpu=0, irq=114, level=1)
> DEBUG: vgic_update_irq_pending(kvm, cpu=0, irq=114, level=1)
> DEBUG: IRQ #114 still in the game, writing to bytemap now...
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> pgd = ffffffc07652e000
> [00000000] *pgd=00000000f658b003, *pud=00000000f658b003, *pmd=0000000000000000
> Internal error: Oops: 96000006 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 1 PID: 1053 Comm: lkvm-msi-irqinj Not tainted 4.0.0-rc7+ #3027
> Hardware name: FVP Base (DT)
> task: ffffffc0774e9680 ti: ffffffc0765a8000 task.ti: ffffffc0765a8000
> PC is at kvm_vgic_inject_irq+0x234/0x310
> LR is at kvm_vgic_inject_irq+0x30c/0x310
> pc : [<ffffffc0000ae0a8>] lr : [<ffffffc0000ae180>] pstate: 80000145
> .....
> 
> So this patch fixes this by checking the SPI number against the
> actual limit. Also we remove the former legacy hard limit of
> 127 in the ioctl code.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> CC: <stable@vger.kernel.org> # 4.0, 3.19, 3.18

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
