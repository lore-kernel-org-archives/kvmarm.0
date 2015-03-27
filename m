From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 12/12] KVM: arm/arm64: remove now obsolete VGIC specific
 MMIO handling code
Date: Fri, 27 Mar 2015 09:33:14 +0000
Message-ID: <551523DA.9000705@arm.com>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com> <1427126309-11223-13-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427126309-11223-13-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "n.nikolaev@virtualopensystems.com" <n.nikolaev@virtualopensystems.com>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 23/03/15 15:58, Andre Przywara wrote:
> With all of the virtual GIC emulation code now being registered with
> the kvm_io_bus, we can remove all of the old MMIO handling code and
> its dispatching functionality.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/arm_vgic.h      |    2 --
>  virt/kvm/arm/vgic-v2-emul.c |   19 ------------
>  virt/kvm/arm/vgic-v3-emul.c |   39 ------------------------
>  virt/kvm/arm/vgic.c         |   71 -------------------------------------------
>  virt/kvm/arm/vgic.h         |    5 ---
>  5 files changed, 136 deletions(-)

Hi Andre,

I've given this some more thoughts, and one thing really worries me. Up
to now, we've only filled the vcpu->run structure when we were about to
give it to userspace, and would never use it ourselves.

Now, we seem to be using much more extensively at various points in the
code. What if userspace changes it under our feet? What guarantee do we
have that this is always safe?

That makes me feel very uncomfortable. I'd rather see an intermediate
structure being used to pass the parameters around, and only fill run at
the last moment. I'd probably sleep better... ;-)

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
