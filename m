Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BEBBC433DB
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 10:37:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 70CEC64F5C
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 10:37:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70CEC64F5C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A60B04B237;
	Wed,  3 Feb 2021 05:37:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3ITdSfGYcc4W; Wed,  3 Feb 2021 05:37:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCFD64B228;
	Wed,  3 Feb 2021 05:37:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D700C4B225
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 05:37:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r78+tEgmG2uf for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 05:37:02 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3FF34B224
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 05:37:02 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6732264E0A;
 Wed,  3 Feb 2021 10:37:01 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l7FWt-00Bj62-28; Wed, 03 Feb 2021 10:36:59 +0000
MIME-Version: 1.0
Date: Wed, 03 Feb 2021 10:36:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v2 6/7] KVM: arm64: Upgrade PMU support to ARMv8.4
In-Reply-To: <56041147-0bd8-dbb2-d1ca-550f3db7f05d@redhat.com>
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-7-maz@kernel.org>
 <56041147-0bd8-dbb2-d1ca-550f3db7f05d@redhat.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <adbdbfbcecb65a1eca21afa622679836@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

Hi Eric,

On 2021-01-27 17:53, Auger Eric wrote:
> Hi Marc,
> 
> On 1/25/21 1:26 PM, Marc Zyngier wrote:
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
> what about the STALL_SLOT_BACKEND and FRONTEND events then?

Aren't these a mandatory ARMv8.1 feature? I don't see a reason to
drop them.

>>  		base = 32;
>>  	}
>> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 8f79ec1fffa7..5da536ab738d 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1051,16 +1051,16 @@ static u64 read_id_reg(const struct kvm_vcpu 
>> *vcpu,
>>  		/* Limit debug to ARMv8.0 */
>>  		val &= ~FEATURE(ID_AA64DFR0_DEBUGVER);
>>  		val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 6);
>> -		/* Limit guests to PMUv3 for ARMv8.1 */
>> +		/* Limit guests to PMUv3 for ARMv8.4 */
>>  		val = cpuid_feature_cap_perfmon_field(val,
>>  						      ID_AA64DFR0_PMUVER_SHIFT,
>> -						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_1 : 0);
>> +						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_4 : 0);
>>  		break;
>>  	case SYS_ID_DFR0_EL1:
>> -		/* Limit guests to PMUv3 for ARMv8.1 */
>> +		/* Limit guests to PMUv3 for ARMv8.4 */
>>  		val = cpuid_feature_cap_perfmon_field(val,
>>  						      ID_DFR0_PERFMON_SHIFT,
>> -						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_1 : 0);
>> +						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
>>  		break;
>>  	}
>> 
>> @@ -1496,6 +1496,7 @@ static const struct sys_reg_desc sys_reg_descs[] 
>> = {
>> 
>>  	{ SYS_DESC(SYS_PMINTENSET_EL1), access_pminten, reset_unknown, 
>> PMINTENSET_EL1 },
>>  	{ SYS_DESC(SYS_PMINTENCLR_EL1), access_pminten, reset_unknown, 
>> PMINTENSET_EL1 },
> "KVM: arm64: Hide PMU registers from userspace when not available"
> changed the above, doesn't it?

Yes, that's because the fix didn't make it in mainline before
5.11-rc5, and I based this on -rc4. I'll fix it at merge time.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
