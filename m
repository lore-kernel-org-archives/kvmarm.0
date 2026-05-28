Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E85F13FEE
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 05:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779947480; cv=none; b=ClFLpMmNUT5aWK+O2X9LQGHb2adJFm/IKWwBm06LaecMcK2hZrHs8WeITxRIk78JXKSzTY51R9V5Iy42QzTdzvQ2/PbaRysuvzW/RLgO2h2BZIwip7fN37At8Y2sRU7wduf+jTrJBJZn+56MfTZFluISzXvR2R83mzflh4Z1EWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779947480; c=relaxed/simple;
	bh=FHRVIhUAFH5KDpn/shPHOAVCNvEYbouCioZUb/GVzo4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d0OC49jXj2GX+VxU1Ie+XvhUgdEL41QCodN2bfMrpGPph+iqC7SdjSq1KF3Y8l7lvlaAJYmTI8dh4EIlaztExc9Hv277D6TlpzBvqJ7VaZIsgRa8aH5s0SVJLKTlEOLuf3sBKKnecW2AIdBhPrq+Wn8RykfNIvD3qW7J1H9tJ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gFpAil3y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gFpAil3y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779947477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yaJmUdTEXFkt0b6LYeGSP6p56fd+jhXHb8g1dv7VOCM=;
	b=gFpAil3yYfGvB1yZyNmZ6B5wuGxv+IEJgNRT8FXGatMCDcrKOEUfpVwCuLUhZcxQ5O+a60
	vwjdXBZFMFhrzJQulkpGf4jYGmVtDkp68QTc7LFhc4zfem2vAxfRZisZYD6CeFSPlpP3QD
	iAu2V4LzTpKyEx5MHxAYdZal7PATNs0=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-cKL_fB_rPvOlX7GpkAcBVw-1; Thu, 28 May 2026 01:51:16 -0400
X-MC-Unique: cKL_fB_rPvOlX7GpkAcBVw-1
X-Mimecast-MFC-AGG-ID: cKL_fB_rPvOlX7GpkAcBVw_1779947475
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-369467ab5bfso10653212a91.0
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 22:51:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779947475; x=1780552275;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yaJmUdTEXFkt0b6LYeGSP6p56fd+jhXHb8g1dv7VOCM=;
        b=oKpmHrNrWcmsYBzMHiQ/obYma9xBinLGl8/j/zg3oZbFYlM4aXW8X/yhLySaPJwGDy
         7qqe0oMC2d8fyh3O5Qkg/kVJhiX3hj3ezhNjovtsdUL8HPg8EVIua7vMQLv16Ul+cSin
         YL3LFQpkrTll2cRJwnUMprchJ1+rs+8TUXAbWKN5YiGxH13jmwRFt1Km1r3hV1hql0nB
         DBCinKZ2VsyBwfEa5XJhCZroYsp2XQ7tcZr3g9t3+A77+q5u/JgnDOyotaPrDoPfBJG+
         1+bn34qsRVxIJmzWmf2y/z1eFjIvmyPxfE117wGhK5JkXVs4VNuPO7hB+i9mPEdx6ZBo
         o8Gw==
X-Forwarded-Encrypted: i=1; AFNElJ9UxNE9wrqLlZeM1V10MHJnICs8mCWBk7Wmo8PZB1Np/XHi/3gGJkN0YLr7nUR7uJy4TUvJIqA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9EiipBggmspBLZw8JQTVg32BXnbP3bM5T4mwSfAKaZflD58rk
	13QWIUKmE3cRQS68/48BiTBRPyHms1b3j+CN060P9s0Gec6nkcIn1GSqfFZfaTMpHiNNSi0VvXN
	jNXG+oqyZUoR9Oq8KL51Wk4M+QzXeWaRpMlwDpqvTfQBHc+GVQvfdxCLsfQ==
X-Gm-Gg: Acq92OEsbTrp5a1YtJ/AqB6c7ZpPnSZTqH/9rXUVSjMhj84+81s+j21vErhevJIAeDd
	/4XnwJ9ONaKupuI1NTcM+J+EsVPMVnOjAmaa3289FLRPiGVZhZqMn23Gkalr5EHfI8aihPv/Dt9
	qIylHLW3AvrEL+SCj1mIoLg+xN9snx7aitFLQXaLu/ZHfduh6lk2YS2WVR718lEt0Qlv/YFxKiB
	zQ5GNR+3hxdFt8uNuOqJ+BkZTtCBf2o4+iPi56w2uollicxmsNMVQ5njzlxKYxh+sV4NkYhn8bM
	9ZdP6Nj6fiVzCUGYhRnGEnEhtPqHfenaMN78p0PizkwkMIdLEVXWOA2rPXaQ7OkeLwMGk8BvlmA
	IMXmVaXUtk2k2hn6oxKBQy4pn+FZ28ux5b72h3Y7k+fC4/C045Vln7bwL/66isZ5Dbip5tnPURX
	w=
X-Received: by 2002:a17:90a:da8f:b0:36b:98a3:4a85 with SMTP id 98e67ed59e1d1-36b98a35a8amr592444a91.27.1779947474731;
        Wed, 27 May 2026 22:51:14 -0700 (PDT)
X-Received: by 2002:a17:90a:da8f:b0:36b:98a3:4a85 with SMTP id 98e67ed59e1d1-36b98a35a8amr592407a91.27.1779947474246;
        Wed, 27 May 2026 22:51:14 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36b9096a918sm660809a91.16.2026.05.27.22.51.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 22:51:13 -0700 (PDT)
Message-ID: <80b6ab2d-1a3e-4c15-b06b-00aaa23fcf74@redhat.com>
Date: Thu, 28 May 2026 15:51:02 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 28/44] arm64: RMI: Create the realm descriptor
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-29-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260513131757.116630-29-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: N7C_XTneDauNHYShdAJbGTFLeE2X9c87cUJ3QUG4HAo_1779947475
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve,

On 5/13/26 11:17 PM, Steven Price wrote:
> Creating a realm involves first creating a realm descriptor (RD). This
> involves passing the configuration information to the RMM. Do this as
> part of realm_ensure_created() so that the realm is created when it is
> first needed.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v13:
>   * The RMM no longer uses AUX granules, so no need to ask it how many it
>     needs.
>   * Adapted to other changes.
> Changes since v12:
>   * Since RMM page size is now equal to the host's page size various
>     calculations are simplified.
>   * Switch to using range based APIs to delegate/undelegate.
>   * VMID handling is now handled entirely by the RMM.
> ---
>   arch/arm64/kvm/rmi.c | 88 +++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 86 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index fb96bcaa73ed..cae29fd3353c 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -418,6 +418,77 @@ static void realm_unmap_shared_range(struct kvm *kvm,
>   			     start, end);
>   }
>   
> +static int realm_create_rd(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	struct realm_params *params = realm->params;
> +	void *rd = NULL;
> +	phys_addr_t rd_phys, params_phys;
> +	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
> +	int r;
> +
> +	realm->ia_bits = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
> +
> +	if (WARN_ON(realm->rd || !realm->params))
> +		return -EEXIST;
> +
> +	rd = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> +	if (!rd)
> +		return -ENOMEM;
> +
> +	rd_phys = virt_to_phys(rd);
> +	if (rmi_delegate_page(rd_phys)) {
> +		r = -ENXIO;
> +		goto free_rd;
> +	}
> +
> +	if (rmi_delegate_range(kvm->arch.mmu.pgd_phys, pgd_size)) {
> +		r = -ENXIO;
> +		goto out_undelegate_tables;
> +	}
> +
> +	params->s2sz = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
> +	params->rtt_level_start = get_start_level(realm);
> +	params->rtt_num_start = pgd_size / PAGE_SIZE;
> +	params->rtt_base = kvm->arch.mmu.pgd_phys;
> +
> +	if (kvm->arch.arm_pmu) {
> +		params->pmu_num_ctrs = kvm->arch.nr_pmu_counters;
> +		params->flags |= RMI_REALM_PARAM_FLAG_PMU;
> +	}
> +
> +	if (kvm_lpa2_is_enabled())
> +		params->flags |= RMI_REALM_PARAM_FLAG_LPA2;
> +
> +	params_phys = virt_to_phys(params);
> +
> +	if (rmi_realm_create(rd_phys, params_phys)) {
> +		r = -ENXIO;
> +		goto out_undelegate_tables;
> +	}
> +
> +	realm->rd = rd;
> +	kvm_set_realm_state(kvm, REALM_STATE_NEW);
> +	/* The realm is up, free the parameters.  */
> +	free_page((unsigned long)realm->params);
> +	realm->params = NULL;
> +
> +	return 0;
> +
> +out_undelegate_tables:
> +	if (WARN_ON(rmi_undelegate_range(kvm->arch.mmu.pgd_phys, pgd_size))) {
> +		/* Leak the pages if they cannot be returned */
> +		kvm->arch.mmu.pgt = NULL;
> +	}

In the latest RMM implementation (topics/rmm-v2.0-poc_2), rmi_delegate_range() works
with the granularity of granule (4KB) and it can fail on any granule. For example,
we have 16x granule as the root RTT and rmi_delegate_range() fails on the first
granule, we're going to undelegate all these 16x granules, which were never delegated
to RMM. It eventually leads to error and memory leakage.

For this, rmi_delegate_range() could be improved to return the number of granules that
have been delegated. The return value can be used by the caller to handle the erroneous
case by passing the correct range to rmi_undelegate_page().

> +	if (WARN_ON(rmi_undelegate_page(rd_phys))) {
> +		/* Leak the page if it isn't returned */
> +		return r;
> +	}
> +free_rd:
> +	free_page((unsigned long)rd);
> +	return r;
> +}
> +
>   static void realm_unmap_private_range(struct kvm *kvm,
>   				      unsigned long start,
>   				      unsigned long end,
> @@ -647,8 +718,21 @@ static int realm_init_ipa_state(struct kvm *kvm,
>   
>   static int realm_ensure_created(struct kvm *kvm)
>   {
> -	/* Provided in later patch */
> -	return -ENXIO;
> +	int ret;
> +
> +	switch (kvm_realm_state(kvm)) {
> +	case REALM_STATE_NONE:
> +		break;
> +	case REALM_STATE_NEW:
> +		return 0;
> +	case REALM_STATE_DEAD:
> +		return -ENXIO;
> +	default:
> +		return -EBUSY;
> +	}
> +
> +	ret = realm_create_rd(kvm);
> +	return ret;
>   }
>   
>   static int set_ripas_of_protected_regions(struct kvm *kvm)

Thanks,
Gavin

