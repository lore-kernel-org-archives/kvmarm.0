Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC203F413B;
	Thu, 14 May 2026 08:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778745681; cv=none; b=WLKeQ26SJTxd2+ULFtszQcrLbFpAeeI23chM5ZMuE/V7cvAVfn+NEWL9z5bbXki21gu0n+JmRQklI17NLUrrDzwdpFw98BhoVmKXT6WzItAAhq67Ax8srXPfZ+BQNi252K1e+Q2X09z4s/lgbZeqA+525EbP7TiVPlWN/pVPT2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778745681; c=relaxed/simple;
	bh=YTT3wpiFKK2siKn7VB9xMRxwfCKefIy+RDPtffN3pIg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YEcl9IqaP6SNrScq0r7RQLfWHAkb+V0PT9f2mWjDj+4m3GiOjH6aSD1FYkPK+GwBRJcG7wAX1tvoXDS1cxUyzRKTML1zk+O63p7jQnyiSreiWFPZgxvwRB7XdHpCzMKDFZlm5xgh5abo/wq5Z1859jqaBQ2Qwj/IRKATHgYiWSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KfuT90G2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KfuT90G2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873E2C2BCC7;
	Thu, 14 May 2026 08:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778745681;
	bh=YTT3wpiFKK2siKn7VB9xMRxwfCKefIy+RDPtffN3pIg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=KfuT90G2ESMWQbmWA7EwQ+PxsLgj/Ta0NabGR6iGez+3gbJJ8F6mlQ13yKjbvA+WJ
	 uw3uv6k+KUBUmNSACOZ8BgnFzfKaXoiFX+o49MPEZfegdjPqJv75rmMTA+cpMTx9Rr
	 pZmrEw2U1EAGmfEUbuI/CpEk1QfZQzJjBDVsSDyACzpFmbD6gDQlr4xuItiqqmzvqW
	 xQwDijnGx6/3fan8w5F5COM3fI58wYFJwSKVjPIabnbKGbyzMkDoCZPvUgYGjwoiWn
	 ziTb4MKhIuBt19SCK/WqPQJxBRasw9psTnM9Ruj9zAE4E2HDyH9VR/dZvKMxRmDZ0M
	 2kjUJ85XtKh9Q==
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
Date: Thu, 14 May 2026 13:31:08 +0530
Message-ID: <yq5a8q9ma08r.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> +unsigned long rmi_sro_execute(struct rmi_sro_state *sro, gfp_t gfp)
> +{
> +	unsigned long sro_handle;
> +	struct arm_smccc_1_2_regs regs;
> +	struct arm_smccc_1_2_regs *regs_in = &sro->regs;
> +
> +	rmi_smccc_invoke(regs_in, &regs);
> +
> +	sro_handle = regs.a1;
> +
> +	while (RMI_RETURN_STATUS(regs.a0) == RMI_INCOMPLETE) {
> +		bool can_cancel = RMI_RETURN_CAN_CANCEL(regs.a0);
> +		int ret;
> +
> +		switch (RMI_RETURN_MEMREQ(regs.a0)) {
> +		case RMI_OP_MEM_REQ_NONE:
> +			regs = (struct arm_smccc_1_2_regs){
> +				SMC_RMI_OP_CONTINUE, sro_handle, 0
> +			};
> +			rmi_smccc_invoke(&regs, &regs);
> +			break;
> +		case RMI_OP_MEM_REQ_DONATE:
> +			ret = rmi_sro_donate(sro, sro_handle, regs.a2, &regs,
> +					     gfp);
> +			break;
> +		case RMI_OP_MEM_REQ_RECLAIM:
> +			ret = rmi_sro_reclaim(sro, sro_handle, &regs);
> +			break;
> +		default:
> +			ret = WARN_ON(1);
> +			break;
> +		}
> +
> +		if (ret) {
> +			if (can_cancel) {
> +				/*
> +				 * FIXME: Handle cancelling properly!
> +				 *
> +				 * If the operation has failed due to memory
> +				 * allocation failure then the information on
> +				 * the memory allocation should be saved, so
> +				 * that the allocation can be repeated outside
> +				 * of any context which prevented the
> +				 * allocation.
> +				 */
> +			}
> +			if (WARN_ON(ret))
> +				return ret;
> +		}
> +	}
> +
> +	return regs.a0;
> +}

Can you also add support to return x1,x2 etc

This would help things like

static int rmi_rtt_dev_unmap(unsigned long rd_phys,
		unsigned long base, unsigned long top,
		unsigned long *out_ipa, unsigned long *out_desc,
		unsigned long *rmi_ret)
{
	unsigned long flags = RMI_ADDR_TYPE_SINGLE;
	struct rmi_sro_state *sro __free(sro) =
		rmi_sro_init(SMC_RMI_RTT_DEV_UNMAP, rd_phys, base, top, flags, NULL);
	if (!sro)
		return -ENOMEM;

	*rmi_ret = rmi_sro_execute(sro);
	if (*rmi_ret)
		return 0;

	*out_ipa = sro->regs.a1;
	*out_desc = sro->regs.a2;

	return 0;
}

-aneesh
