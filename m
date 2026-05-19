Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648EA3112C1;
	Tue, 19 May 2026 06:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779170541; cv=none; b=dtZd2XoCUM2k8wlv/DbzrSkd0gvQ7EHnQ9Dq8O77H88xGrHy4RwMmcQ+k0nRSn25LAM68FybjLRujkkMNLUtZjkXzJUSdXzYWNM2kN1NrVmGAt/WSTfLXbikZNuz2SgJ70bGLgjx28s3OJdqw+4JoJ4E2mH5otbkAEIHgU2STGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779170541; c=relaxed/simple;
	bh=22gkf18a8yg0K51zlDRHlTrUxxq1tyaqoQ1aURojOp8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=uphThIC5f2W5vQRIOfLmvq4TYYGq2CgbL5xfOOhCqtOInVlorKKsTHE8w3AVA6gAnVy0GrHS1mjt9Zyic0PgU7Xl8Su28c6tbwyCDkQBIEKVKW551ZRuzVkhzIkvPFz8QLUCkNt6x/+Bom/rckCcsU5iI3VBAeZUArU0XoqcP+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p0xABhC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p0xABhC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AC3C2BCB3;
	Tue, 19 May 2026 06:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779170541;
	bh=22gkf18a8yg0K51zlDRHlTrUxxq1tyaqoQ1aURojOp8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=p0xABhC0+b/gMmHS41oCAyCaMr4Q8ic65LXFQdch2Em4bqB2mWye0pa7rHQtncifD
	 5kEwuJnu7Bw1f4qkiOen91eN437m2ZbtKC5ZSCRdTRRwOSAbFKKE9ZlJZl745QjQut
	 4o6zsp62hCKLieLc0+5b0qJcUxWZeRIB4HVjHyZUOCsjNuY7byW5KXXb2sTUZ3M/ht
	 a41mM4IMvThbC+pJIkzDKT5sTEpCFxPjNE9/EkLONPv0ejXTCcOH5MjfJfdwITzhzE
	 2SSqFLCoGyvr+BbcUGWnvQABVso4Jtr4tmMldgFedmv+xJZ1FrV3dwPBfBFFqpnXpN
	 CA98XskqU7iIw==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
	Lorenzo.Pieralisi2@arm.com
Subject: Re: [PATCH v14 10/44] arm64: RMI: Add support for SRO
In-Reply-To: <20260513131757.116630-11-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-11-steven.price@arm.com>
Date: Tue, 19 May 2026 11:32:11 +0530
Message-ID: <yq5a7bp0szrw.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> +static unsigned long donate_req_to_size(unsigned long donatereq)
> +{
> +	unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
> +
> +	switch (unit_size) {
> +	case 0:
> +		return PAGE_SIZE;
> +	case 1:
> +		return PMD_SIZE;
> +	case 2:
> +		return PUD_SIZE;
> +	case 3:
> +		return P4D_SIZE;
> +	}
> +	unreachable();
> +}
>
> +
> +static void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs_in,
> +			     struct arm_smccc_1_2_regs *regs_out)
> +{
> +	struct arm_smccc_1_2_regs regs = *regs_in;
> +	unsigned long status;
> +
> +	do {
> +		arm_smccc_1_2_invoke(&regs, regs_out);
> +		status = RMI_RETURN_STATUS(regs_out->a0);
> +	} while (status == RMI_BUSY || status == RMI_BLOCKED);
> +}
> +
> +int free_delegated_page(phys_addr_t phys)
> +{
> +	if (WARN_ON(rmi_undelegate_page(phys))) {
> +		/* Undelegate failed: leak the page */
> +		return -EBUSY;
> +	}
> +
> +	free_page((unsigned long)phys_to_virt(phys));
> +
> +	return 0;
> +}
> +
> +static int rmi_sro_ensure_capacity(struct rmi_sro_state *sro,
> +				   unsigned long count)
> +{
> +	if (WARN_ON_ONCE(sro->addr_count > RMI_MAX_ADDR_LIST))
> +		return -EOVERFLOW;
> +
> +	if (count > RMI_MAX_ADDR_LIST - sro->addr_count)
> +		return -ENOSPC;
> +
> +	return 0;
> +}
> +
> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
> +				 unsigned long sro_handle,
> +				 unsigned long donatereq,
> +				 struct arm_smccc_1_2_regs *out_regs,
> +				 gfp_t gfp)
> +{
> +	unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
> +	unsigned long unit_size_bytes = donate_req_to_size(donatereq);
> +	unsigned long count = RMI_DONATE_COUNT(donatereq);
> +	unsigned long state = RMI_DONATE_STATE(donatereq);
> +	unsigned long size = unit_size_bytes * count;
> +	unsigned long addr_range;
>

Looking at above and the related code, I am wondering whether we should
use u64 instead of unsigned long for everything that the specification
defines as 64-bit.

-aneesh
