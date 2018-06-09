From: Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH v2 00/16] arm64: Add SMCCC v1.1 support and CVE-2017-5715
 (Spectre variant 2) mitigation
Date: Sat, 9 Jun 2018 09:22:27 -0400
Message-ID: <f6da84f8-b01e-f8cd-521b-6f2348b963be@jonmasters.org>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180129174559.1866-1-marc.zyngier@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 01/29/2018 12:45 PM, Marc Zyngier wrote:

> ARM has recently published a SMC Calling Convention (SMCCC)
> specification update[1] that provides an optimised calling convention
> and optional, discoverable support for mitigating CVE-2017-5715. ARM
> Trusted Firmware (ATF) has already gained such an implementation[2].

Some questions:

1). What's the plan to implement the boot time on/off control for
spectre_v2 mitigations?

2). What's the plan to handle live migration of VMs?

Jon.
