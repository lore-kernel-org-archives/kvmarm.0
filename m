Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47BC43A383B;
	Thu, 14 May 2026 09:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778751224; cv=none; b=Xkw1ZkmHa4aOJULaGnWR/gZ9IA7yMBjh61T3PtJwfuH3wFyqu6a1X0DuEoQhCVeuUDkXfkg79vm4v470HyfzvSNstIvv5Pu33kzH06N/5JKNTmkEei4CyajXwsjDHNcZ6/i16uUHHifm8AEc6xoEkqjrSfCODp8GgCGlgOA0pKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778751224; c=relaxed/simple;
	bh=15IYn3iLfZXckiqY4v2WG/U+nBEKAauifaebzvl2v8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aKIvAjDPlg5CCjSaV43EK4WkFVkvbtfU2jlO0F1T6c/GqqYb2Tnj26Oqh29gCCD6eDkaravqeQfxQOoQc5/wDI4YmsmEkhcYQTHvhtjpIAxg+LLWVlFsR+djMFpsyulp/Oewhj66mvtJ1G1cb6chbYTUgwRMsAAY3/+dVtTINuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TrJFW2FE; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TrJFW2FE"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A7C03502;
	Thu, 14 May 2026 02:33:37 -0700 (PDT)
Received: from [10.1.37.28] (e122027.cambridge.arm.com [10.1.37.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0D2F3F85F;
	Thu, 14 May 2026 02:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778751222; bh=15IYn3iLfZXckiqY4v2WG/U+nBEKAauifaebzvl2v8U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TrJFW2FE7DK1dKESIWBDe4IoPEqOi52Xs5k+YIeEW8bac5xeRkCBiGICFhWFFd8uv
	 vCK4kCAoGx/O73KOo79kmau7br4yf19Ge4m7WFcUWYEVgAwX6liLi0xrV3L5aDHlrk
	 MQ8oFeuLm/txVMFOmUezID+d4euoxwT3zcB89z54=
Message-ID: <cc21ea56-827f-4077-b6f7-3ef00c0b9408@arm.com>
Date: Thu, 14 May 2026 10:33:35 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 10/44] arm64: RMI: Add support for SRO
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-11-steven.price@arm.com> <yq5a8q9ma08r.fsf@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yq5a8q9ma08r.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/05/2026 09:01, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
>> +unsigned long rmi_sro_execute(struct rmi_sro_state *sro, gfp_t gfp)
>> +{
>> +	unsigned long sro_handle;
>> +	struct arm_smccc_1_2_regs regs;
>> +	struct arm_smccc_1_2_regs *regs_in = &sro->regs;
>> +
>> +	rmi_smccc_invoke(regs_in, &regs);
>> +
>> +	sro_handle = regs.a1;
>> +
>> +	while (RMI_RETURN_STATUS(regs.a0) == RMI_INCOMPLETE) {
>> +		bool can_cancel = RMI_RETURN_CAN_CANCEL(regs.a0);
>> +		int ret;
>> +
>> +		switch (RMI_RETURN_MEMREQ(regs.a0)) {
>> +		case RMI_OP_MEM_REQ_NONE:
>> +			regs = (struct arm_smccc_1_2_regs){
>> +				SMC_RMI_OP_CONTINUE, sro_handle, 0
>> +			};
>> +			rmi_smccc_invoke(&regs, &regs);
>> +			break;
>> +		case RMI_OP_MEM_REQ_DONATE:
>> +			ret = rmi_sro_donate(sro, sro_handle, regs.a2, &regs,
>> +					     gfp);
>> +			break;
>> +		case RMI_OP_MEM_REQ_RECLAIM:
>> +			ret = rmi_sro_reclaim(sro, sro_handle, &regs);
>> +			break;
>> +		default:
>> +			ret = WARN_ON(1);
>> +			break;
>> +		}
>> +
>> +		if (ret) {
>> +			if (can_cancel) {
>> +				/*
>> +				 * FIXME: Handle cancelling properly!
>> +				 *
>> +				 * If the operation has failed due to memory
>> +				 * allocation failure then the information on
>> +				 * the memory allocation should be saved, so
>> +				 * that the allocation can be repeated outside
>> +				 * of any context which prevented the
>> +				 * allocation.
>> +				 */
>> +			}
>> +			if (WARN_ON(ret))
>> +				return ret;
>> +		}
>> +	}
>> +
>> +	return regs.a0;
>> +}
> 
> Can you also add support to return x1,x2 etc

Indeed that's going to be needed. Looking at this function again I don't 
think we actually need the on-stack 'regs' any more. So the below (very 
lightly tested) diff would use the regs from sro which also means they 
will be there for the caller if it needs them.

Thanks,
Steve

---8<---
diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
index a8107ca9bb6d..58a0216be409 100644
--- a/arch/arm64/kernel/rmi.c
+++ b/arch/arm64/kernel/rmi.c
@@ -356,30 +356,29 @@ void rmi_sro_free(struct rmi_sro_state *sro)
 unsigned long rmi_sro_execute(struct rmi_sro_state *sro, gfp_t gfp)
 {
 	unsigned long sro_handle;
-	struct arm_smccc_1_2_regs regs;
-	struct arm_smccc_1_2_regs *regs_in = &sro->regs;
+	struct arm_smccc_1_2_regs *regs = &sro->regs;
 
-	rmi_smccc_invoke(regs_in, &regs);
+	rmi_smccc_invoke(regs, regs);
 
-	sro_handle = regs.a1;
+	sro_handle = regs->a1;
 
-	while (RMI_RETURN_STATUS(regs.a0) == RMI_INCOMPLETE) {
-		bool can_cancel = RMI_RETURN_CAN_CANCEL(regs.a0);
+	while (RMI_RETURN_STATUS(regs->a0) == RMI_INCOMPLETE) {
+		bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0);
 		int ret;
 
-		switch (RMI_RETURN_MEMREQ(regs.a0)) {
+		switch (RMI_RETURN_MEMREQ(regs->a0)) {
 		case RMI_OP_MEM_REQ_NONE:
-			regs = (struct arm_smccc_1_2_regs){
+			*regs = (struct arm_smccc_1_2_regs){
 				SMC_RMI_OP_CONTINUE, sro_handle, 0
 			};
-			rmi_smccc_invoke(&regs, &regs);
+			rmi_smccc_invoke(regs, regs);
 			break;
 		case RMI_OP_MEM_REQ_DONATE:
-			ret = rmi_sro_donate(sro, sro_handle, regs.a2, &regs,
+			ret = rmi_sro_donate(sro, sro_handle, regs->a2, regs,
 					     gfp);
 			break;
 		case RMI_OP_MEM_REQ_RECLAIM:
-			ret = rmi_sro_reclaim(sro, sro_handle, &regs);
+			ret = rmi_sro_reclaim(sro, sro_handle, regs);
 			break;
 		default:
 			ret = WARN_ON(1);
@@ -404,7 +403,7 @@ unsigned long rmi_sro_execute(struct rmi_sro_state *sro, gfp_t gfp)
 		}
 	}
 
-	return regs.a0;
+	return regs->a0;
 }
 
 static int rmi_check_version(void)

