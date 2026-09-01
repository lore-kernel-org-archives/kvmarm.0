Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E173439478C;
	Tue,  1 Sep 2026 08:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788252381; cv=none; b=CpDBI//BQSnMZh8fkchLijaXa9n4vT4jRzOp2qh837lyjETLEh9QPEJp/Yzrp5AXoWqsKffKHcz/n3TF323IVat+ycN48cGu0yxfxaF+pCNbcObTrdveV7XtGrAcd6cThYAGSbBknHCkCVfLXJDkCgfNQVX6qIfmPrnI/amrTLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788252381; c=relaxed/simple;
	bh=nOYr2/5KGhcoHzBT8RYwc4mrQKvfZhsOsi6k5J/+YeQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=T4JMR2SRwCtXIYw7FjJK31Nn1bJXDbT7MkAw4MeO2YYRheS5pLcBTCpw/EL4+cg55uGlFPy/sey+eEbgYMYKaBqwLvaOwfA6zIs/vHxwW2OeybpQ2SEPRQF4jFdIgnF8urjmw8uzL0S+agT1AtKF+LAY43rfTX19HG9Tm6csXww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kghze7x3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kghze7x3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3216B1F000E9;
	Tue,  1 Sep 2026 08:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788252379;
	bh=sSZ+W+gpyvva9DOkNjE72UDAxg//MujBrcnUpMW/QcY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=kghze7x3MwDDqCvHjx3ZgTrJRLG41aro+Xm0FE6b6M6N87BFrqfJiFQjdaNbyLjei
	 /a0OGIdZv30zvjAUQNX00VUKHQKXCR2agw7Z3sq1Iz3YSvNGyKEtzmzcCh7n4KUmXG
	 uz1hIO1S1ln18PVcx9PsArwCn61NTGEDT+6ibg3Jp48OI2ZzhY5p17nMoy8ky5yUg0
	 KyGbFbwiDzGSs0LfbmSaPYcAZYNf4/wtrGpomumjEMkz6mpyTmY7z84nicptr3WT/8
	 RxgbatJmc0fP+5PEruglqmQNsVmlcvcYnePVLmcPF5rhWlw9iSwFakTC14vEGovfKN
	 zUZN80YOsQ3XA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 01/16] iommu/arm-smmu-v3: Discover RME support
 and realm IRQ topology
In-Reply-To: <apMjUSbxcnlAKjks@nvidia.com>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-2-aneesh.kumar@kernel.org>
 <apMjUSbxcnlAKjks@nvidia.com>
Date: Tue, 01 Sep 2026 14:16:10 +0530
Message-ID: <yq5aik4pnyul.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Nicolin Chen <nicolinc@nvidia.com> writes:

> On Mon, Apr 27, 2026 at 02:23:29PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-realm.c
>> @@ -0,0 +1,124 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2026 ARM Ltd.
>> + */
>> +
>> +#include <linux/interrupt.h>
>> +#include <asm/rmi_smc.h>
>> +#include <asm/rmi_cmds.h>
>> +
>> +#include "arm-smmu-v3.h"
>> +
>> +#define	RMI_PSMMU_IRQ_GERROR	BIT(0)
>> +#define	RMI_PSMMU_IRQ_EVENTQ	BIT(1)
>> +#define	RMI_PSMMU_IRQ_PRIQ	BIT(2)
>> +#define	RMI_PSMMU_IRQ_CMDQ	BIT(3)
> [...]
>> +	if (irq == smmu->realm_evtq_irq)
>> +		notify_flags =  RMI_PSMMU_IRQ_EVENTQ;
>> +	else if (irq == smmu->realm_gerr_irq)
>> +		notify_flags =  RMI_PSMMU_IRQ_GERROR;
>> +	else if (irq == smmu->realm_pri_irq)
>> +		notify_flags =  RMI_PSMMU_IRQ_PRIQ;
>
> These are defined as BIT(x)...
>
>> +		if (rmi_psmmu_irq_notify(smmu->base_phys,
>> +					 notify_flags, &event)) {
> [...]
>> +			rmi_psmmu_event_consume(smmu->base_phys, notify_flags);
>
> .. and passed to RMI_PSMMU_IRQ_NOTIFY and RMI_PSMMU_EVENT_CONSUME.
>
> RMI_PSMMU_IRQ_NOTIFY takes RmiPsmmuIrqSet type, which is a 4-bit
> field that has a range of [BIT(0), BIT(3)]. So this is correct.
>
> However, RMI_PSMMU_EVENT_CONSUME takes RmiPsmmuIrq type, which is
> a 2-bit field that has a range of [0x0, 0x3]. So this seems wrong.
>

Updated that to

#define	RMI_PSMMU_IRQ_PEND_GERROR	BIT(0)
#define	RMI_PSMMU_IRQ_PEND_EVENTQ	BIT(1)
#define	RMI_PSMMU_IRQ_PEND_PRIQ		BIT(2)
#define	RMI_PSMMU_IRQ_PEND_CMDQ		BIT(3)


#define	RMI_PSMMU_IRQ_GERROR	0
#define	RMI_PSMMU_IRQ_EVENTQ	1
#define	RMI_PSMMU_IRQ_PRIQ	2
#define	RMI_PSMMU_IRQ_CMDQ	3


and 
	if (irq == smmu->realm.evtq_irq) {
		notify_flags =  RMI_PSMMU_IRQ_PEND_EVENTQ;
		psmmu_irq = RMI_PSMMU_IRQ_EVENTQ;
	} else if (irq == smmu->realm.gerr_irq) {

...
	rmi_psmmu_event_consume(smmu->base_phys, psmmu_irq);

>
>> +void arm_smmu_setup_realm_irqs(struct arm_smmu_device *smmu)
>> +{
>> +	int irq, ret;
>> +
>> +	irq = smmu->realm_evtq_irq;
>> +	if (irq) {
>> +		ret = devm_request_threaded_irq(smmu->dev, irq, NULL,
>> +						arm_smmu_realm_notify_thread,
>> +						IRQF_ONESHOT,
>> +						"arm-smmu-v3-realm-evtq",
>> +						smmu);
>
> These IRQ numbers are raw numbers forwarded by firmware and then
> returned by RMI_PSMMU_INFO:
>
> +		if ((psmmu_info->flags & RMI_PSMMU_IRQCFG_MASK) ==
> +		    RMI_PSMMU_IRQCFG_IRQ_WIRED) {
> +			smmu->realm_gerr_irq = psmmu_info->gerror_intr_num;
> +			smmu->realm_evtq_irq = psmmu_info->eventq_intr_num;
> +			smmu->realm_pri_irq = psmmu_info->priq_intr_num;
>
> Should they be converted to Linux IRQ numbers before forwarded to
> devm_request_threaded_irq?
>

Yes, that needs conversion. I guess we can use the irq_domain associated
with the non-Realm IRQ number to create the mappings?

Something like:


+static struct irq_domain *arm_smmu_get_wired_irq_domain(struct arm_smmu_device *smmu)
+{
+	int irqs[] = {
+		smmu->combined_irq,
+		smmu->evtq.q.irq,
+		smmu->gerr_irq,
+		smmu->priq.q.irq,
+	};
+	struct irq_domain *domain = NULL;
+	struct irq_data *irq_data;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(irqs); i++) {
+		if (irqs[i] <= 0)
+			continue;
+
+		irq_data = irq_get_irq_data(irqs[i]);
+		if (!irq_data || !irq_data->domain)
+			return ERR_PTR(-EINVAL);
+
+		if (domain && domain != irq_data->domain)
+			return ERR_PTR(-EINVAL);
+
+		domain = irq_data->domain;
+	}
+
+	return domain ?: ERR_PTR(-ENXIO);
+}

>
>> @@ -782,6 +787,9 @@ struct arm_smmu_device {
>>  
>>  	int				gerr_irq;
>>  	int				combined_irq;
>> +	int				realm_gerr_irq;
>> +	int				realm_evtq_irq;
>> +	int				realm_pri_irq;
>
> Nit: this series adds a few realm-specific things in the top SMMU
> structure. Maybe a "struct arm_realm_psmmu" can make them clearer.
>

Added

struct arm_smmu_realm {
	int				gerr_irq;
	int				evtq_irq;
	int				pri_irq;
	struct mutex			mutex;
	refcount_t			users;
};

-aneesh
