From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] arm64: KVM: Use SMCCC_ARCH_WORKAROUND_1 for Falkor BP
 hardening
Date: Mon, 19 Mar 2018 18:30:16 +0000
Message-ID: <fed53181-db58-9f48-0c5b-7eebe9eb9b10@arm.com>
References: <1520269603-2900-1-git-send-email-shankerd@codeaurora.org>
 <861sgx5wb6.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD2E2402C7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Mar 2018 14:22:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bp2pC6pl8HkC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Mar 2018 14:22:33 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 656834030D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Mar 2018 14:22:33 -0400 (EDT)
In-Reply-To: <861sgx5wb6.wl-marc.zyngier@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Thomas Speier <tspeier@codeaurora.org>, Sean Campbell <scampbel@codeaurora.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/03/18 10:32, Marc Zyngier wrote:
> On Mon, 05 Mar 2018 17:06:43 +0000,
> Shanker Donthineni wrote:
>>
>> The function SMCCC_ARCH_WORKAROUND_1 was introduced as part of SMC
>> V1.1 Calling Convention to mitigate CVE-2017-5715. This patch uses
>> the standard call SMCCC_ARCH_WORKAROUND_1 for Falkor chips instead
>> of Silicon provider service ID 0xC2001700.
>>
>> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
>> ---
>> Chnages since v1:
>>   - Trivial change in cpucaps.h (refresh after removing ARM64_HARDEN_BP_POST_GUEST_EXIT)
>>
>>  arch/arm64/include/asm/cpucaps.h |  5 ++--
>>  arch/arm64/include/asm/kvm_asm.h |  2 --
>>  arch/arm64/kernel/bpi.S          |  8 ------
>>  arch/arm64/kernel/cpu_errata.c   | 55 ++++++++++++++--------------------------
>>  arch/arm64/kvm/hyp/entry.S       | 12 ---------
>>  arch/arm64/kvm/hyp/switch.c      | 10 --------
>>  6 files changed, 21 insertions(+), 71 deletions(-)
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> Will/Catalin, if you want to take it via the arm64 tree, that's fine
> by me.

Please allow me to change my mind. This is going to conflict horribly
with the VHE rework and the HYP randomization patches.

I'll take it via the KVM tree, which will make everyone's life a lot easier.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
