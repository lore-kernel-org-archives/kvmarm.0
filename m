From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 16/16] arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP
 hardening support
Date: Tue, 30 Jan 2018 12:10:38 +0000
Message-ID: <27fb84a6-d2a0-2d49-0e99-4a8bb8b32ac9@arm.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
 <20180129174559.1866-17-marc.zyngier@arm.com>
 <CAKv+Gu-8vjgq1ihfoTC5b1H4gsqAKzciyCXFDsW0e1dBcpZLdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-8vjgq1ihfoTC5b1H4gsqAKzciyCXFDsW0e1dBcpZLdQ@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 29/01/18 19:41, Ard Biesheuvel wrote:
> On 29 January 2018 at 17:45, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> Add the detection and runtime code for ARM_SMCCC_ARCH_WORKAROUND_1.
>> It is lovely. Really.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_psci.h | 63 ++++++++++++++++++++++++++++++++++++
>>  arch/arm64/kernel/bpi.S           | 20 ++++++++++++
>>  arch/arm64/kernel/cpu_errata.c    | 68 ++++++++++++++++++++++++++++++++++++++-
>>  3 files changed, 150 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/arm64/include/asm/kvm_psci.h
>>
>> diff --git a/arch/arm64/include/asm/kvm_psci.h b/arch/arm64/include/asm/kvm_psci.h
> 
> Did you mean to add this file? It is mostly identical to include/kvm/arm_psci.h

No, that's yet another patch splitting mistake. I'll drop it.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
