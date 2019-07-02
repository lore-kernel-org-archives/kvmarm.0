Return-Path: <SRS0=KAXL=U7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15644C06513
	for <kvmarm@archiver.kernel.org>; Tue,  2 Jul 2019 12:54:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A653F208C4
	for <kvmarm@archiver.kernel.org>; Tue,  2 Jul 2019 12:54:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A653F208C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12B094A4EB;
	Tue,  2 Jul 2019 08:54:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DX8kdQvNPV7O; Tue,  2 Jul 2019 08:54:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0C4C4A389;
	Tue,  2 Jul 2019 08:54:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD23D4A389
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jul 2019 08:54:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3+fLYgUWS7Ps for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Jul 2019 08:54:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA4CA40A52
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jul 2019 08:54:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86BF2344;
 Tue,  2 Jul 2019 05:54:38 -0700 (PDT)
Received: from [10.1.31.185] (unknown [10.1.31.185])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5AB993F703;
 Tue,  2 Jul 2019 05:54:36 -0700 (PDT)
Subject: Re: [PATCH 23/59] KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
To: Julien Thierry <julien.thierry@arm.com>,
 Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-24-marc.zyngier@arm.com>
 <53793288-0d5d-4212-c1f4-ffa6a790d1c4@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <1ba3a46e-d8cd-d6c9-c1dc-2fe9ad309497@arm.com>
Date: Tue, 2 Jul 2019 13:54:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <53793288-0d5d-4212-c1f4-ffa6a790d1c4@arm.com>
Content-Language: en-US
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


On 6/25/19 3:19 PM, Julien Thierry wrote:
>
> On 06/21/2019 10:38 AM, Marc Zyngier wrote:
>> From: Jintack Lim <jintack.lim@linaro.org>
>>
>> Forward exceptions due to WFI or WFE instructions to the virtual EL2 if
>> they are not coming from the virtual EL2 and virtual HCR_EL2.TWX is set.
>>
>> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_nested.h |  2 ++
>>  arch/arm64/kvm/Makefile             |  1 +
>>  arch/arm64/kvm/handle_exit.c        | 13 +++++++++-
>>  arch/arm64/kvm/nested.c             | 39 +++++++++++++++++++++++++++++
>>  4 files changed, 54 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/arm64/kvm/nested.c
>>
>> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
>> index 8a3d121a0b42..645e5e11b749 100644
>> --- a/arch/arm64/include/asm/kvm_nested.h
>> +++ b/arch/arm64/include/asm/kvm_nested.h
>> @@ -10,4 +10,6 @@ static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
>>  		test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features);
>>  }
>>  
>> +int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
>> +
>>  #endif /* __ARM64_KVM_NESTED_H */
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 9e450aea7db6..f11bd8b0d837 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -36,4 +36,5 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
>>  
>> +kvm-$(CONFIG_KVM_ARM_HOST) += nested.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += emulate-nested.o
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> index e348c15c81bc..ddba212fd6ec 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -127,7 +127,18 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>   */
>>  static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  {
>> -	if (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
>> +	bool is_wfe = !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WFx_ISS_WFE);
>> +
>> +	if (nested_virt_in_use(vcpu)) {
>> +		int ret = handle_wfx_nested(vcpu, is_wfe);
>> +
>> +		if (ret < 0 && ret != -EINVAL)
>> +			return ret;
>> +		else if (ret >= 0)
>> +			return ret;
> I think you can simplify this:
>
> 	if (ret != -EINVAL)
> 		return ret;

And handle_wfx_nested can only return -EINVAL or 1 (from
kvm_inject_nested_sync), so the condition is not only complicated, but also
misleading.

Thanks,

Alex

>
> Cheers,
>
> Julien
>
>
>> +	}
>> +
>> +	if (is_wfe) {
>>  		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
>>  		vcpu->stat.wfe_exit_stat++;
>>  		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>> new file mode 100644
>> index 000000000000..3872e3cf1691
>> --- /dev/null
>> +++ b/arch/arm64/kvm/nested.c
>> @@ -0,0 +1,39 @@
>> +/*
>> + * Copyright (C) 2017 - Columbia University and Linaro Ltd.
>> + * Author: Jintack Lim <jintack.lim@linaro.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/kvm.h>
>> +#include <linux/kvm_host.h>
>> +
>> +#include <asm/kvm_emulate.h>
>> +
>> +/*
>> + * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
>> + * the virtual HCR_EL2.TWX is set. Otherwise, let the host hypervisor
>> + * handle this.
>> + */
>> +int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
>> +{
>> +	u64 hcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
>> +
>> +	if (vcpu_mode_el2(vcpu))
>> +		return -EINVAL;
>> +
>> +	if ((is_wfe && (hcr_el2 & HCR_TWE)) || (!is_wfe && (hcr_el2 & HCR_TWI)))
>> +		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
>> +
>> +	return -EINVAL;
>> +}
>>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
