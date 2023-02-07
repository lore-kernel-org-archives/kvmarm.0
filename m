Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A3C2C9C
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 13:27:32 +0000 (UTC)
Received: by mail-wm1-f45.google.com with SMTP id j29-20020a05600c1c1d00b003dc52fed235so11469038wms.1
        for <kvmarm@lists.linux.dev>; Tue, 07 Feb 2023 05:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rJhiytKh63a2Q0Ih/4MzbnKZt6RxQbWjkc5IfouOZfs=;
        b=gZUl/q/IrBjT4+NNchJGC/9j7661ODQsEWoiN8mcIxVQ3uohgT9u5CQ6fj9ozdYkfX
         JFe6f+J3YeuYcIipg9phiWfhMw619XikEztoTe8mpR5vj3asxEGhlKDMyNUfG2W7M3By
         8rNcNWKpZ1L104qpU/w8d3KH5gkjiPctLJPAgv4ckR7iHY/LZ8FjxBTE1H5Ak/4pXpL9
         DktyE6nufnd1OcCl4IHgUNdGkSfKjDPZUrnPblZ7qaXAOpCst8y4BP2GnHilpYEEI+Qq
         pd6FxVP6WpcmPVNWZr0IdTOcAOuz6R8G36iH2QpNhtp0cFjE+SU74qtLMbh/llwuReMN
         bl2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rJhiytKh63a2Q0Ih/4MzbnKZt6RxQbWjkc5IfouOZfs=;
        b=lHwrjWbs0q0RMMGkInUNhQoiYRJMzr1sCR4fqVnApyOkjbdBrVh0m1nmRox1/N52xe
         npmZohUqPBiDUl6minNeE6vLa+2zd1nkvFt0J0oiF3Gi7LAUHOe4v7/MtyDHRM9REYCD
         kzpAbzTSz9l4es4k7IYpU5N8ZsU4C3s+wqJMq9IsrrWU1kh2/RkhXLhxG5urhIWVUbzn
         UNPVmPYAu1Cw0V6CcfWEdxYsAyl+SgAqwc0J1lAtmXHM9ectY/ESeC4alVRmMbDIEkZ7
         iT+2aqAY1f0SF9Dbke0kMr8hNcfokAoIcH4rtHn/JnN9CnjQgx675v2BanvQElYZ17GK
         4GyA==
X-Gm-Message-State: AO0yUKVeIu8aIbzP8RR3WZsqbmmuOp97gkgDp4JOcMmpyJ5kuvAhZvT0
	xECretgv352Do7DXvtlylCL7/Q==
X-Google-Smtp-Source: AK7set8ux4cP2Ybn/abiqHyZixmvKGdmZmX8C0T1Add8hEO97JsvL2S408J4ak5lR1f6nCjluGyEqQ==
X-Received: by 2002:a05:600c:3b93:b0:3df:f3cb:e8ce with SMTP id n19-20020a05600c3b9300b003dff3cbe8cemr126692wms.7.1675776450905;
        Tue, 07 Feb 2023 05:27:30 -0800 (PST)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id n9-20020a5d5989000000b002bc7fcf08ddsm11695324wri.103.2023.02.07.05.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 05:27:30 -0800 (PST)
Date: Tue, 7 Feb 2023 13:27:17 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 42/45] KVM: arm64: pkvm: Support SCMI power domain
Message-ID: <Y+JRl3WRwzDJOe2J@google.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-43-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201125328.2186498-43-jean-philippe@linaro.org>

Hi Jean,

> +bool kvm_host_scmi_handler(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(u64, func_id, host_ctxt, 0);
> +
> +	if (!scmi_channel.shmem || func_id != scmi_channel.smc_id)
> +		return false; /* Unhandled */
> +
> +	/*
> +	 * Prevent the host from modifying the request while it is in flight.
> +	 * One page is enough, SCMI messages are smaller than that.
> +	 *
> +	 * FIXME: the host is allowed to poll the shmem while the request is in
> +	 * flight, or read shmem when receiving the SCMI interrupt. Although
> +	 * it's unlikely with the SMC-based transport, this too requires some
> +	 * tightening in the spec.
> +	 */
> +	if (WARN_ON(__pkvm_host_add_remove_page(scmi_channel.shmem_pfn, true)))
> +		return true;
> +
> +	__kvm_host_scmi_handler(host_ctxt);
> +
> +	WARN_ON(__pkvm_host_add_remove_page(scmi_channel.shmem_pfn, false));
> +	return true; /* Handled */
> +}

I am not sure what a typical SCMI channel shmem_size would be.
But would map/unmap be more performant than
memcpy(hyp_local_copy,scmi_channel.pfn,scmi_channel.shmem_size ); ?

Thank,
Mostafa


