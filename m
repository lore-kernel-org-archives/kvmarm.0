From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v2 01/12] KVM: arm/arm64: Set dist->spis to NULL after kfree
Date: Tue, 27 Mar 2018 18:10:46 +0100
Message-ID: <26bb42a7-d946-e52c-68e6-eaeaae325983@arm.com>
References: <1522159456-10419-1-git-send-email-eric.auger@redhat.com>
 <1522159456-10419-2-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522159456-10419-2-git-send-email-eric.auger@redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 27/03/18 15:04, Eric Auger wrote:
> in case kvm_vgic_map_resources() fails, typically if the vgic
> distributor is not defined, __kvm_vgic_destroy will be called
> several times. Indeed kvm_vgic_map_resources() is called on
> first vcpu run. As a result dist->spis is freeed more than once
> and on the second time it causes a "kernel BUG at mm/slub.c:3912!"
> 
> Set dist->spis to NULL to avoid the crash.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Fixes: ad275b8bb1e6 ("KVM: arm/arm64: vgic-new: vgic_init: implement
vgic_init")

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
