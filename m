From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC v2 01/12] KVM: arm/arm64: Set dist->spis to NULL after kfree
Date: Wed, 28 Mar 2018 08:41:26 +0200
Message-ID: <969f4dcb-5f77-ddbe-7e72-322793065ccd@redhat.com>
References: <1522159456-10419-1-git-send-email-eric.auger@redhat.com>
 <1522159456-10419-2-git-send-email-eric.auger@redhat.com>
 <26bb42a7-d946-e52c-68e6-eaeaae325983@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <26bb42a7-d946-e52c-68e6-eaeaae325983@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,
On 27/03/18 19:10, Marc Zyngier wrote:
> On 27/03/18 15:04, Eric Auger wrote:
>> in case kvm_vgic_map_resources() fails, typically if the vgic
>> distributor is not defined, __kvm_vgic_destroy will be called
>> several times. Indeed kvm_vgic_map_resources() is called on
>> first vcpu run. As a result dist->spis is freeed more than once
>> and on the second time it causes a "kernel BUG at mm/slub.c:3912!"
>>
>> Set dist->spis to NULL to avoid the crash.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> Fixes: ad275b8bb1e6 ("KVM: arm/arm64: vgic-new: vgic_init: implement
> vgic_init")
Sorry for the oversight :-(
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Thanks

Eric
> 
> 	M.
> 
