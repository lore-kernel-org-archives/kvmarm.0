Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFE91B3953
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 07:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729839847; cv=none; b=cYwaqhc1+Lf0RxiAek2dLTbbzk0Nbx2hNl4szfGe02/ELAWfnd2BRcYkP+NECCKHf0vn/1SwCiihcDU/pES1XHs9Oecv7PxCsAuQfoZ3Yvv6d//GlZuFhA/61yyXs3Hy8NB57sHtH9u0VH6OKmua5eYspeF/94UUSvCF6szPQzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729839847; c=relaxed/simple;
	bh=DBv6l7GloxbmSNMewON9UjbH4GqdMp2fpBD3pszXpE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bh85MDJ0T7qAk9uvBHvjAuqVHkyGhMO2JrNbbzbTNudy7ddDM4Ue9K/aVgJDE9vPhZWie1O7qhnYqdoNGY7gu6Yh+RDJCD9cOSTwfMmzQh5EmcgDQNfn2InAUM5bvVSOGXVm+GJKhqjZlJ2NsTCFkISBK7I1nImIxDzubuURHBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i3mG4BVx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i3mG4BVx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729839842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9p12DVJrh2/KaL703mBvE4NfeJ/21HDpgwP+rDFnf/I=;
	b=i3mG4BVx/BVf4YdwdnRIiFAomiNyHNLg4TKYk4FMUYVWn7A8dWTqPB2alde/qPGWB6aB1X
	c4vrbUsmhm8ga9N0yd3WnfsQEBypGF20seaQnrWqXljLew2EhbQlQ/LLMUQ5nKEassW23S
	PgUzWy1PpsA0+GbGBvyo5zMoFF2htoY=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-194-qeIMYvkQNXqBTylKLRUX6Q-1; Fri, 25 Oct 2024 03:04:01 -0400
X-MC-Unique: qeIMYvkQNXqBTylKLRUX6Q-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2e3912db200so2319035a91.2
        for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 00:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729839840; x=1730444640;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9p12DVJrh2/KaL703mBvE4NfeJ/21HDpgwP+rDFnf/I=;
        b=ND49nvZHOkbQCQv88C0ppxMd8uHsPGsCvnPtNriIppNzTmanUYWc9nIOxnJ3rTkUOK
         qSLzrNCHDD65SlZRy9l1WiCmaOAg4liKqcDf85APYzm3q3VLJkis2TB5NAJ3gybmIDca
         nJImaZ8uVYczTlw1sE9daLPbNurQl8WHaqHfQzaVZmvM/16SS66rceHrmnjlU46Rw1s+
         uSzCDiggc/7UcECv1oeJzPIDu+zW9Ln9HIUH98r/bc3UcjAVkya3O3xvIWtqI++8ZOyN
         OQws27o8VhLNVGaHxKYOvn6tiBA5oay/kCXNRgjeiOcwO3LDhikatBhTaX2tVZKneMV/
         XA4w==
X-Forwarded-Encrypted: i=1; AJvYcCUT0RlCZ417hypYWqP+tTUmxkIV+JCDh2jv0aTGTTSV5fvU/J8t3e0VHmdJGa3ICyuwrKr67TQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxj4ASRbb6gggEI8/O58D2Rni44NC07CJRRl5c6aa5q7v8Ts0fD
	OB36m9XjwbyHyOKYo21uqSYtAOKZgwVDnesM/5cRdx83jvk/5v85nqiXvnv7OwefwFTHWzwBOB0
	o2CUDypBplJ411q83NJgCzlyFurkCIv9X7Z0O0afqOsJDVGhGekwVrQ==
X-Received: by 2002:a17:903:1cb:b0:20f:c094:b80f with SMTP id d9443c01a7336-20fc094bce6mr29520145ad.49.1729839839650;
        Fri, 25 Oct 2024 00:03:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHqNkHcZK+wAbGtTfwcXjrQGB/oivx/BdHMIgJdpiz9apxigQic1a/Lr06F1uzOyU4AhBxK1g==
X-Received: by 2002:a17:903:1cb:b0:20f:c094:b80f with SMTP id d9443c01a7336-20fc094bce6mr29519855ad.49.1729839839211;
        Fri, 25 Oct 2024 00:03:59 -0700 (PDT)
Received: from [192.168.68.55] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bc02f6f1sm4190065ad.226.2024.10.25.00.03.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2024 00:03:58 -0700 (PDT)
Message-ID: <d3e0b74a-7c01-487e-ac77-5c8afbd720d4@redhat.com>
Date: Fri, 25 Oct 2024 17:03:49 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/43] arm64: RME: Add wrappers for RMI calls
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
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
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-7-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004152804.72508-7-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 1:27 AM, Steven Price wrote:
> The wrappers make the call sites easier to read and deal with the
> boiler plate of handling the error codes from the RMM.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v4:
>   * Improve comments
> Changes from v2:
>   * Make output arguments optional.
>   * Mask RIPAS value rmi_rtt_read_entry()
>   * Drop unused rmi_rtt_get_phys()
> ---
>   arch/arm64/include/asm/rmi_cmds.h | 510 ++++++++++++++++++++++++++++++
>   1 file changed, 510 insertions(+)
>   create mode 100644 arch/arm64/include/asm/rmi_cmds.h
> 
> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
> new file mode 100644
> index 000000000000..3ed32809a608
> --- /dev/null
> +++ b/arch/arm64/include/asm/rmi_cmds.h
> @@ -0,0 +1,510 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#ifndef __ASM_RMI_CMDS_H
> +#define __ASM_RMI_CMDS_H
> +
> +#include <linux/arm-smccc.h>
> +

It can be dropped since the header file has been included by <asm/rmi_smc.h>

> +#include <asm/rmi_smc.h>
> +
> +struct rtt_entry {
> +	unsigned long walk_level;
> +	unsigned long desc;
> +	int state;
> +	int ripas;
> +};
> +
> +/**
> + * rmi_data_create() - Create a Data Granule
> + * @rd: PA of the RD
> + * @data: PA of the target granule
> + * @ipa: IPA at which the granule will be mapped in the guest
> + * @src: PA of the source granule
> + * @flags: RMI_MEASURE_CONTENT if the contents should be measured
> + *
> + * Create a new Data Granule, copying contents from a Non-secure Granule.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_data_create(unsigned long rd, unsigned long data,
> +				  unsigned long ipa, unsigned long src,
> +				  unsigned long flags)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_DATA_CREATE, rd, data, ipa, src,
> +			     flags, &res);
> +
> +	return res.a0;
> +}
> +

Is there a particular reason why the first letter for 'Data Granule' and
'Granule' has to be upper-case?

> +/**
> + * rmi_data_create_unknown() - Create a Data Granule with unknown contents
> + * @rd: PA of the RD
> + * @data: PA of the target granule
> + * @ipa: IPA at which the granule will be mapped in the guest
> + *
> + * Create a new Data Granule with unknown contents
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This line can be dropped since the same content has been given at the
beginning.

> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_data_create_unknown(unsigned long rd,
> +					  unsigned long data,
> +					  unsigned long ipa)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_DATA_CREATE_UNKNOWN, rd, data, ipa, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_data_destroy() - Destroy a Data Granule
> + * @rd: PA of the RD
> + * @ipa: IPA at which the granule is mapped in the guest
> + * @data_out: PA of the granule which was destroyed
> + * @top_out: Top IPA of non-live RTT entries
> + *
> + * Unmap a protected IPA from stage 2, transitioning it to DESTROYED.
> + * The IPA cannot be used by the guest unless it is transitioned to RAM again
> + * by the Realm guest.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_data_destroy(unsigned long rd, unsigned long ipa,
> +				   unsigned long *data_out,
> +				   unsigned long *top_out)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_DATA_DESTROY, rd, ipa, &res);
> +
> +	if (data_out)
> +		*data_out = res.a1;
> +	if (top_out)
> +		*top_out = res.a2;
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_features() - Read feature register
> + * @index: Feature register index
> + * @out: Feature register value is written to this pointer
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_features(unsigned long index, unsigned long *out)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_FEATURES, index, &res);
> +
> +	if (out)
> +		*out = res.a1;
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_granule_delegate() - Delegate a Granule
> + * @phys: PA of the Granule
> + *
> + * Delegate a Granule for use by the Realm World.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_granule_delegate(unsigned long phys)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_DELEGATE, phys, &res);
> +
> +	return res.a0;
> +}
> +

Same as above, why the first letters for 'Realm World' have to be
in upper-case? :-)

> +/**
> + * rmi_granule_undelegate() - Undelegate a Granule
> + * @phys: PA of the Granule
> + *
> + * Undelegate a Granule to allow use by the Normal World. Will fail if the
> + * Granule is in use.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_granule_undelegate(unsigned long phys)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_UNDELEGATE, phys, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_psci_complete() - Complete pending PSCI command
> + * @calling_rec: PA of the calling REC
> + * @target_rec: PA of the target REC
> + * @status: Status of the PSCI request
> + *
> + * Completes a pending PSCI command which was called with an MPIDR argument, by
> + * providing the corresponding REC.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_psci_complete(unsigned long calling_rec,
> +				    unsigned long target_rec,
> +				    unsigned long status)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_PSCI_COMPLETE, calling_rec, target_rec,
> +			     status, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_realm_activate() - Active a Realm
> + * @rd: PA of the RD
> + *
> + * Mark a Realm as Active signalling that creation is complete and allowing
> + * execution of the Realm.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_realm_activate(unsigned long rd)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REALM_ACTIVATE, rd, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_realm_create() - Create a Realm
> + * @rd: PA of the RD
> + * @params_ptr: PA of Realm parameters
> + *
> + * Create a new Realm using the given parameters.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_realm_create(unsigned long rd, unsigned long params_ptr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REALM_CREATE, rd, params_ptr, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_realm_destroy() - Destroy a Realm
> + * @rd: PA of the RD
> + *
> + * Destroys a Realm, all objects belonging to the Realm must be destroyed first.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_realm_destroy(unsigned long rd)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REALM_DESTROY, rd, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rec_aux_count() - Get number of auxiliary Granules required
> + * @rd: PA of the RD
> + * @aux_count: Number of pages written to this pointer
> + *
> + * A REC may require extra auxiliary pages to be delegated for the RMM to
> + * store metadata (not visible to the normal world) in. This function provides
> + * the number of pages that are required.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rec_aux_count(unsigned long rd, unsigned long *aux_count)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_AUX_COUNT, rd, &res);
> +
> +	if (aux_count)
> +		*aux_count = res.a1;
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rec_create() - Create a REC
> + * @rd: PA of the RD
> + * @rec: PA of the target REC
> + * @params_ptr: PA of REC parameters
> + *
> + * Create a REC using the parameters specified in the struct rec_params pointed
> + * to by @params_ptr.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rec_create(unsigned long rd, unsigned long rec,
> +				 unsigned long params_ptr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_CREATE, rd, rec, params_ptr, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rec_destroy() - Destroy a REC
> + * @rec: PA of the target REC
> + *
> + * Destroys a REC. The REC must not be running.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rec_destroy(unsigned long rec)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_DESTROY, rec, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rec_enter() - Enter a REC
> + * @rec: PA of the target REC
> + * @run_ptr: PA of RecRun structure
> + *
> + * Starts (or continues) execution within a REC.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rec_enter(unsigned long rec, unsigned long run_ptr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_ENTER, rec, run_ptr, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rtt_create() - Creates an RTT
> + * @rd: PA of the RD
> + * @rtt: PA of the target RTT
> + * @ipa: Base of the IPA range described by the RTT
> + * @level: Depth of the RTT within the tree
> + *
> + * Creates an RTT (Realm Translation Table) at the specified level for the
> + * translation of the specified address within the Realm.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rtt_create(unsigned long rd, unsigned long rtt,
> +				 unsigned long ipa, long level)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_CREATE, rd, rtt, ipa, level, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rtt_destroy() - Destroy an RTT
> + * @rd: PA of the RD
> + * @ipa: Base of the IPA range described by the RTT
> + * @level: Depth of the RTT within the tree
> + * @out_rtt: Pointer to write the PA of the RTT which was destroyed
> + * @out_top: Pointer to write the top IPA of non-live RTT entries
> + *
> + * Destroys an RTT. The RTT must be non-live, i.e. none of the entries in the
> + * table are in ASSIGNED or TABLE state.
> + *
> + * Return: RMI return code.
> + */
> +static inline int rmi_rtt_destroy(unsigned long rd,
> +				  unsigned long ipa,
> +				  long level,
> +				  unsigned long *out_rtt,
> +				  unsigned long *out_top)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_DESTROY, rd, ipa, level, &res);
> +
> +	if (out_rtt)
> +		*out_rtt = res.a1;
> +	if (out_top)
> +		*out_top = res.a2;
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rtt_fold() - Fold an RTT
> + * @rd: PA of the RD
> + * @ipa: Base of the IPA range described by the RTT
> + * @level: Depth of the RTT within the tree
> + * @out_rtt: Pointer to write the PA of the RTT which was destroyed
> + *
> + * Folds an RTT. If all entries with the RTT are 'homogeneous' the RTT can be
> + * folded into the parent and the RTT destroyed.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rtt_fold(unsigned long rd, unsigned long ipa,
> +			       long level, unsigned long *out_rtt)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_FOLD, rd, ipa, level, &res);
> +
> +	if (out_rtt)
> +		*out_rtt = res.a1;
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rtt_init_ripas() - Set RIPAS for new Realm
> + * @rd: PA of the RD
> + * @base: Base of target IPA region
> + * @top: Top of target IPA region
> + * @out_top: Top IPA of range whose RIPAS was modified
> + *
> + * Sets the RIPAS of a target IPA range to RAM, for a Realm in the NEW state.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rtt_init_ripas(unsigned long rd, unsigned long base,
> +				     unsigned long top, unsigned long *out_top)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_INIT_RIPAS, rd, base, top, &res);
> +
> +	if (out_top)
> +		*out_top = res.a1;
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rtt_map_unprotected() - Map NS pages into a Realm
> + * @rd: PA of the RD
> + * @ipa: Base IPA of the mapping
> + * @level: Depth within the RTT tree
> + * @desc: RTTE descriptor
> + *
> + * Create a mapping from an Unprotected IPA to a Non-secure PA.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rtt_map_unprotected(unsigned long rd,
> +					  unsigned long ipa,
> +					  long level,
> +					  unsigned long desc)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_MAP_UNPROTECTED, rd, ipa, level,
> +			     desc, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rtt_read_entry() - Read an RTTE
> + * @rd: PA of the RD
> + * @ipa: IPA for which to read the RTTE
> + * @level: RTT level at which to read the RTTE
> + * @rtt: Output structure describing the RTTE
> + *
> + * Reads a RTTE (Realm Translation Table Entry).
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rtt_read_entry(unsigned long rd, unsigned long ipa,
> +				     long level, struct rtt_entry *rtt)
> +{
> +	struct arm_smccc_1_2_regs regs = {
> +		SMC_RMI_RTT_READ_ENTRY,
> +		rd, ipa, level
> +	};
> +
> +	arm_smccc_1_2_smc(&regs, &regs);
> +
> +	rtt->walk_level = regs.a1;
> +	rtt->state = regs.a2 & 0xFF;
> +	rtt->desc = regs.a3;
> +	rtt->ripas = regs.a4 & 0xFF;
> +
> +	return regs.a0;
> +}
> +
> +/**
> + * rmi_rtt_set_ripas() - Set RIPAS for an running Realm
> + * @rd: PA of the RD
> + * @rec: PA of the REC making the request
> + * @base: Base of target IPA region
> + * @top: Top of target IPA region
> + * @out_top: Pointer to write top IPA of range whose RIPAS was modified
> + *
> + * Completes a request made by the Realm to change the RIPAS of a target IPA
> + * range.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rtt_set_ripas(unsigned long rd, unsigned long rec,
> +				    unsigned long base, unsigned long top,
> +				    unsigned long *out_top)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_SET_RIPAS, rd, rec, base, top, &res);
> +
> +	if (out_top)
> +		*out_top = res.a1;
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rtt_unmap_unprotected() - Remove a NS mapping
> + * @rd: PA of the RD
> + * @ipa: Base IPA of the mapping
> + * @level: Depth within the RTT tree
> + * @out_top: Pointer to write top IPA of non-live RTT entries
> + *
> + * Removes a mapping at an Unprotected IPA.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rtt_unmap_unprotected(unsigned long rd,
> +					    unsigned long ipa,
> +					    long level,
> +					    unsigned long *out_top)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_UNMAP_UNPROTECTED, rd, ipa,
> +			     level, &res);
> +
> +	if (out_top)
> +		*out_top = res.a1;
> +
> +	return res.a0;
> +}
> +
> +#endif

#endif /* __ASM_RMI_CMDS_H */

Thanks,
Gavin

