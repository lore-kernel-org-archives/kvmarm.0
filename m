From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH -next] KVM: arm: vgic: Make two functions static
Date: Wed, 20 Mar 2019 17:36:49 +0000
Message-ID: <20190320173649.32de4908@why.wild-wind.fr.eu.org>
References: <20190320141813.10380-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190320141813.10380-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>
Cc: christoffer.dall@arm.com, james.morse@arm.com, julien.thierry@arm.com, suzuki.poulose@arm.com, andre.przywara@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 20 Mar 2019 22:18:13 +0800
Yue Haibing <yuehaibing@huawei.com> wrote:

> From: YueHaibing <yuehaibing@huawei.com>
> 
> Fix sparse warnings:
> 
> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-its.c:1732:5: warning:
>  symbol 'vgic_its_has_attr_regs' was not declared. Should it be static?
> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-its.c:1753:5: warning:
>  symbol 'vgic_its_attr_regs_access' was not declared. Should it be static?
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied with a small tweak to the subject line.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
