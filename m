Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 391123D34BA;
	Thu, 16 Jul 2026 09:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784193820; cv=none; b=ciKjjVcKVkxWeafok/II7DhSKAvg2Nund57PE2HHj7rcd2ARE0ffJqG4A0uwFP7gSy/cVPKUmWKF0q7+H+d4AgO6pXmhFddROzI83t7v3wOrcy0ZoAn4ptbbmfgJp18H9UDqiBCTV6H4GMT0z23e31Opv2kmuoWJ7GF+XgiZegE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784193820; c=relaxed/simple;
	bh=hG1AAdfCvqq1PEpYDQg4tcJcHBug5oUPy4nkfJ+JHPo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BKeZe6wgt8ZacTBy+VMz6f0avpwrzjIuKvjqRncr27HzYqPM5f9/KUk7P61/DgNF7M8VCgtP2hRINkiiadE8SZfnnNdEMoSfqXjWSaB8R+ZnBBroRFOw3F5gYFkGp7WdRfc6KO/wEBitR7XVGFG6XgcxWnl/qXlCfnprcgjaST4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=M2gNlSD0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="M2gNlSD0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46DF82B;
	Thu, 16 Jul 2026 02:23:33 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 354103F905;
	Thu, 16 Jul 2026 02:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784193817; bh=hG1AAdfCvqq1PEpYDQg4tcJcHBug5oUPy4nkfJ+JHPo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M2gNlSD06Eo/0bw4AaGfsOUvnQlmNgn1GcyuFBqxEOACl3lhlk7M+BaPXceu+15lh
	 OCFObqwONsxAK9j0DLse+RoEpz2oGSgxC2iNd/V5BYfVZc5/lsUkesDcQPX8n2hgOs
	 JKTEe/TsrdZ/g6txCyOaseoRiccmPvNxqWeWVtFA=
Message-ID: <c3bccaed-e11f-4f00-8cdc-2d51b55f38e9@arm.com>
Date: Thu, 16 Jul 2026 10:23:32 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 05/37] KVM: arm64: CCA: Check for LPA2 support
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-6-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260715142841.80544-6-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/07/2026 15:28, Steven Price wrote:
> If KVM has enabled LPA2 support then check that the RMM also supports
> it. If there is a mismatch then disable support for realm guests as the
> VMM may attempt to create a guest which is incompatible with the RMM.
> 

We may be able to relax this in the future with the UNPROT MAP/UNMAP
RMI ABIs now accepting the OutputAddress and Attributes separately
and gracefully handle cases where the requested IPA size exceeds
the RMM limit.

But practically I don't see why we should support it. So :

> Signed-off-by: Steven Price <steven.price@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> ---
> v15:
>   * Extend rmi_has_feature() to take the register number and check the
>     presence of SHA-256 support which is default.
> v13:
>   * New patch
> ---
>   arch/arm64/kvm/rmi.c | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
> 
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 384991d69f78..247c4f033945 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -5,9 +5,31 @@
>   
>   #include <linux/kvm_host.h>
>   
> +#include <asm/kvm_pgtable.h>
>   #include <asm/rmi_cmds.h>
>   #include <asm/virt.h>
>   
> +static bool rmi_has_feature(int reg, unsigned long feature)
> +{
> +	return !!u64_get_bits(rmi_feat_reg(reg), feature);
> +}
> +
> +static int rmm_check_features(void)
> +{
> +	if (kvm_lpa2_is_enabled() &&
> +	    !rmi_has_feature(0, RMI_FEATURE_REGISTER_0_LPA2)) {
> +		kvm_err("RMM doesn't support LPA2\n");
> +		return -ENXIO;
> +	}
> +
> +	if (!rmi_has_feature(1, RMI_FEATURE_REGISTER_1_HASH_SHA_256)) {
> +		kvm_err("RMM doesn't support SHA-256 measurements\n");
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +
>   void kvm_init_rmi(void)
>   {
>   	/*
> @@ -20,5 +42,8 @@ void kvm_init_rmi(void)
>   	if (!is_rmi_available())
>   		return;
>   
> +	if (rmm_check_features())
> +		return;
> +
>   	/* Future patch will enable static branch kvm_rmi_is_available */
>   }

