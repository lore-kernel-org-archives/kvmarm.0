From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3a 11/11] KVM: arm/arm64: rework MMIO abort handling
 to use KVM MMIO bus
Date: Mon, 30 Mar 2015 11:47:44 +0100
Message-ID: <551929D0.8030608@arm.com>
References: <20150327160046.GB5121@cbox> <1427505193-32749-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427505193-32749-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, mtosatti@redhat.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 28/03/15 01:13, Andre Przywara wrote:
> Currently we have struct kvm_exit_mmio for encapsulating MMIO abort
> data to be passed on from syndrome decoding all the way down to the
> VGIC register handlers. Now as we switch the MMIO handling to be
> routed through the KVM MMIO bus, it does not make sense anymore to
> use that structure already from the beginning. So we keep the data in
> local variables until we put them into the kvm_io_bus framework.
> Then we fill kvm_exit_mmio in the VGIC only, making it a VGIC private
> structure. On that way we replace the data buffer in that structure
> with a pointer pointing to a single location in a local variable, so
> we get rid of some copying on the way.
> With all of the virtual GIC emulation code now being registered with
> the kvm_io_bus, we can remove all of the old MMIO handling code and
> its dispatching functionality.
> 
> I didn't bother to rename kvm_exit_mmio (to vgic_mmio or something),
> because that touches a lot of code lines without any good reason.
> 
> This is based on an original patch by Nikolay.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Cc: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
> ---
> Hi,
> 
> this is a new version of PATCH v3 11/11, which does not use kvm_run
> in the write case anymore. That should fix the problem that Marc and
> Christoffer mentioned. The trick is to not use a structure at all,
> but instead just pass on the needed values as parameters. By folding
> handle_kernel_mmio() into io_mem_abort() we save some code and avoid
> passing too many parameters.
> As this is the last patch and the only one changed, I just send out
> this one and rely on v3 for the other patches. If a complete respin
> on the list is preferred, let me know.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

I've put this into queue, together with Nikolay's (reworked) patch. I'm
currently taking the whole thing for a spin on a few boxesm and will
hopefully push it into -next by the end of the day.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
