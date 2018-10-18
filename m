From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 0/2] rename function name and enable 32bit vcpu events
Date: Thu, 18 Oct 2018 10:14:54 +0100
Message-ID: <c1cc827c-c1b7-1fa5-85be-54fc400febb1@arm.com>
References: <20181012161249.9236-1-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181012161249.9236-1-gengdongjiu@huawei.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>, christoffer.dall@arm.com, suzuki.poulose@arm.com, james.morse@arm.com, peter.maydell@linaro.org, drjones@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/10/18 17:12, Dongjiu Geng wrote:
> Rename the kvm_arch_dev_ioctl_check_extension() to 
> kvm_arch_vm_ioctl_check_extension, because the name
> is not readable;
> 
> Enable the 32 bit vcpu events support.
> 
> Change since v3:
> 1. Address James's comments to update the patch commit messages
> 
> Change since v2:
> 1. Address Suzuki's comments to update the patch commit messages
> 
> change since v1:
> 1. Update patch commit messages.
> 
> Dongjiu Geng (2):
>   arm/arm64: KVM: rename function kvm_arch_dev_ioctl_check_extension()
>   arm/arm64: KVM: enable 32 bits kvm vcpu events support
> 
>  arch/arm/include/asm/kvm_host.h   | 2 +-
>  arch/arm64/include/asm/kvm_host.h | 2 +-
>  arch/arm64/kvm/reset.c            | 5 ++---
>  virt/kvm/arm/arm.c                | 3 ++-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 

Applied, thanks.

	M.
-- 
Jazz is not dead. It just smells funny...
