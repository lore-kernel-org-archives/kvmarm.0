From: Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH v4 00/17] arm64: Add SMCCC v1.1 support and CVE-2017-5715
 (Spectre variant 2) mitigation
Date: Thu, 15 Feb 2018 15:59:29 -0500
Message-ID: <e9df17e7-86ee-2f7a-b8e2-d78ac0358fc3@redhat.com>
References: <20180206175621.929-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180206175621.929-1-marc.zyngier@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Jones <drjones@redhat.com>, Hanjun Guo <guohanjun@huawei.com>, Jayachandran C <jnair@caviumnetworks.com>, Jon Masters <jcm@redhat.com>, Russell King - ARM Linux <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc, all,

On 02/06/2018 12:56 PM, Marc Zyngier wrote:
> ARM has recently published a SMC Calling Convention (SMCCC)
> specification update[1] that provides an optimised calling convention
> and optional, discoverable support for mitigating CVE-2017-5715. ARM
> Trusted Firmware (ATF) has already gained such an implementation[2].

I'm probably just missing something, but does this end up reported
somewhere conveniently user visible? In particular, if the new SMC is
*not* provided, does the user end up easily seeing this?

Jon.

-- 
Computer Architect | Sent from my Fedora powered laptop
