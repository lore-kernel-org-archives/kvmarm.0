From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 00/17] arm64: Add SMCCC v1.1 support and CVE-2017-5715
 (Spectre variant 2) mitigation
Date: Tue, 6 Feb 2018 22:42:53 +0000
Message-ID: <20180206224253.5rsus3u3wt6eluxv@armageddon.cambridge.arm.com>
References: <20180206175621.929-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180206175621.929-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Andrew Jones <drjones@redhat.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Jon Masters <jcm@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, Russell King - ARM Linux <linux@armlinux.org.uk>, Jayachandran C <jnair@caviumnetworks.com>, Hanjun Guo <guohanjun@huawei.com>, Robin Murphy <robin.murphy@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 06, 2018 at 05:56:04PM +0000, Marc Zyngier wrote:
> ARM has recently published a SMC Calling Convention (SMCCC)
> specification update[1] that provides an optimised calling convention
> and optional, discoverable support for mitigating CVE-2017-5715. ARM
> Trusted Firmware (ATF) has already gained such an implementation[2].
> 
> This series addresses a few things:
> 
> - It provides a KVM implementation of PSCI v1.0, which is a
>   prerequisite for being able to discover SMCCC v1.1.
> 
> - It allows KVM to advertise SMCCC v1.1, which is de-facto supported
>   already (it never corrupts any of the guest registers).
> 
> - It implements KVM support for the ARCH_WORKAROUND_1 function that is
>   used to mitigate CVE-2017-5715 in a guest (if such mitigation is
>   available on the host).
> 
> - It implements SMCCC v1.1 and ARCH_WORKAROUND_1 discovery support in
>   the kernel itself.
> 
> - It finally provides firmware callbacks for CVE-2017-5715 for both
>   kernel and KVM and drop the initial PSCI_GET_VERSION based
>   mitigation.
> 
> Patch 1 is already merged, and included here for reference. Patches on
> top of arm64/for-next/core. Tested on Seattle and Juno, the latter
> with ATF implementing SMCCC v1.1.

Queued for 4.16. I merged the first patch as well since for-next/core is
based on -rc3 and the patch went in afterwards (I dropped cc stable
since there is a version with this tag already).

Thanks.

-- 
Catalin
