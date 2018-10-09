From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v2 1/2] arm/arm64: KVM: rename function
 kvm_arch_dev_ioctl_check_extension()
Date: Tue, 9 Oct 2018 17:34:24 +0100
Message-ID: <e5e5f84b-4664-7ba0-9462-5b69a987fd9d@arm.com>
References: <1539002088-21215-1-git-send-email-gengdongjiu@huawei.com>
 <1539002088-21215-2-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539002088-21215-2-git-send-email-gengdongjiu@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>, christoffer.dall@arm.com, marc.zyngier@arm.com, peter.maydell@linaro.org, drjones@redhat.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 08/10/18 13:34, Dongjiu Geng wrote:
> Rename kvm_arch_dev_ioctl_check_extension() to
> kvm_arch_vm_ioctl_check_extension(), because it does
> not have any relationship with device.
> 
> Renaming this function can make code readable.

+1. The current name is not really intuitive.

> 
> Cc: James Morse <james.morse@arm.com>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
