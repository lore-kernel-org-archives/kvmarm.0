From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 1/2] arm/arm64: KVM: rename function
 kvm_arch_dev_ioctl_check_extension()
Date: Fri, 12 Oct 2018 16:45:35 +0100
Message-ID: <5743b2ce-232f-f7e9-b5e7-3fd017575d78@arm.com>
References: <1539284855-4035-1-git-send-email-gengdongjiu@huawei.com>
 <1539284855-4035-2-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539284855-4035-2-git-send-email-gengdongjiu@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: christoffer.dall@arm.com, marc.zyngier@arm.com, suzuki.poulose@arm.com, peter.maydell@linaro.org, drjones@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dongjiu Geng,

On 11/10/2018 20:07, Dongjiu Geng wrote:
> Rename kvm_arch_dev_ioctl_check_extension() to
> kvm_arch_vm_ioctl_check_extension(), because it does
> not have any relationship with device.
> 
> Renaming this function can make code readable.

Lots of things in the kernel are misnamed, its not normally worth fixing them.

But it confused me, so:
Acked-by: James Morse <james.morse@arm.com>


Thanks,

James
