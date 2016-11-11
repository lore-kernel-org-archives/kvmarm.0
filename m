From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH v5 03/11] arm/arm64: smp: support more than
 8 cpus
Date: Fri, 11 Nov 2016 15:27:38 +0000
Message-ID: <caf9e57a-a8f7-8595-2004-3be0d3224ce6@arm.com>
References: <1478798481-25030-1-git-send-email-drjones@redhat.com>
 <1478798481-25030-4-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1478798481-25030-4-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: pbonzini@redhat.com, peter.maydell@linaro.org, alex.bennee@linaro.org, marc.zyngier@arm.com, eric.auger@redhat.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 10/11/16 17:21, Andrew Jones wrote:
> By adding support for launching with gicv3 we can break the 8 vcpu
> limit. This patch adds support to smp code and also selects the
> vgic model corresponding to the host. The vgic model may also be
> manually selected by adding e.g. -machine gic-version=3 to
> extra_params.
> 
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> ---
> v5: left cpus a u32 for now. Changing to u64 requires a change to
>     devicetree. Will do it later. [Andre]

Given that we address this in the future:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>


