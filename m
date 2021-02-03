Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE753C433E0
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 10:32:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0182064F58
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 10:32:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0182064F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A4604B0CD;
	Wed,  3 Feb 2021 05:32:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5WYFqTZk41r4; Wed,  3 Feb 2021 05:32:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47E714B1D4;
	Wed,  3 Feb 2021 05:32:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C55EA4B132
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 05:32:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ybMv3Hr0z7OI for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 05:32:18 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B9794B0CD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 05:32:18 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2B55764E0A;
 Wed,  3 Feb 2021 10:32:17 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l7FSH-00Bj22-Up; Wed, 03 Feb 2021 10:32:14 +0000
MIME-Version: 1.0
Date: Wed, 03 Feb 2021 10:32:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2 6/7] KVM: arm64: Upgrade PMU support to ARMv8.4
In-Reply-To: <680c2e4f-cc9f-10c1-1158-7de32057fb0d@arm.com>
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-7-maz@kernel.org>
 <680c2e4f-cc9f-10c1-1158-7de32057fb0d@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <20c1d805997523ae04f45be90fb4dd1a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-01-27 17:41, Alexandru Elisei wrote:
> Hi Marc,
> 
> Had another look at the patch, comments below.
> 
> On 1/25/21 12:26 PM, Marc Zyngier wrote:
>> Upgrading the PMU code from ARMv8.1 to ARMv8.4 turns out to be
>> pretty easy. All that is required is support for PMMIR_EL1, which
>> is read-only, and for which returning 0 is a valid option as long
>> as we don't advertise STALL_SLOT as an implemented event.
>> 
>> Let's just do that and adjust what we return to the guest.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/include/asm/sysreg.h |  3 +++
>>  arch/arm64/kvm/pmu-emul.c       |  6 ++++++
>>  arch/arm64/kvm/sys_regs.c       | 11 +++++++----
>>  3 files changed, 16 insertions(+), 4 deletions(-)
>> 
>> diff --git a/arch/arm64/include/asm/sysreg.h 
>> b/arch/arm64/include/asm/sysreg.h
>> index 8b5e7e5c3cc8..2fb3f386588c 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -846,7 +846,10 @@
>> 
>>  #define ID_DFR0_PERFMON_SHIFT		24
>> 
>> +#define ID_DFR0_PERFMON_8_0		0x3
>>  #define ID_DFR0_PERFMON_8_1		0x4
>> +#define ID_DFR0_PERFMON_8_4		0x5
>> +#define ID_DFR0_PERFMON_8_5		0x6
>> 
>>  #define ID_ISAR4_SWP_FRAC_SHIFT		28
>>  #define ID_ISAR4_PSR_M_SHIFT		24
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index 398f6df1bbe4..72cd704a8368 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -795,6 +795,12 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, 
>> bool pmceid1)
>>  		base = 0;
>>  	} else {
>>  		val = read_sysreg(pmceid1_el0);
>> +		/*
>> +		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
>> +		 * as RAZ
>> +		 */
>> +		if (vcpu->kvm->arch.pmuver >= ID_AA64DFR0_PMUVER_8_4)
>> +			val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
> 
> This is confusing the me. We have kvm->arch.pmuver set to the hardware
> PMU version
> (as set by __armv8pmu_probe_pmu()), but we ignore it when reporting the 
> PMU
> version to the guest. Why do we do that? We limit the event number in
> kvm_pmu_event_mask() based on the hardware PMU version, so even if we 
> advertise
> Armv8.4 PMU, support for all those extra events added by Arm8.1 PMU is
> missing (I hope I understood the code correctly).

That's a bit of mess-up. We obtain ID_AA64DFR0_EL1 from the sanitised
regs, but do most of our handling based on kvm->arch.pmuver. They really
should be the same, because that's what the sanitised registers give
you.

As for the events themselves, I don't get your drift. We do support
all the ARMv8.1 PMU events as long as the HW supports it, and we
don't lie to the guest about it either (cpuid_feature_cap_perfmon_field
does *cap* the field to some value, it doesn't allow it to increase
past what the HW supports).

> I looked at commit c854188ea010 ("KVM: arm64: limit PMU version to 
> PMUv3 for
> ARMv8.1") which changed read_id_reg() to report PMUv3 for Armv8.1
> unconditionally,
> and there's no explanation why PMUv3 for Armv8.1 was chosen instead of
> plain PMUv3 (PMUVer = 0b0100).

We picked ARMv8.1 because this is the first PMU revision that gives
you events in the 0x4000 range, all of which are available on
common ARMv8.2 HW.


Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
