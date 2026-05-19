Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962371D89EF;
	Tue, 19 May 2026 05:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779168933; cv=none; b=m4cKOOsuKYawxbdmAbnpQTCBKUtGWBDoNTzBaB2+/IN8RDXwClHOwuEsKWqXkgxKrZLUhlIJZZSOt75KtaUqGqoy+pr279v74ZyyRoJOLoGqBRg8zmMPxgk9Rshhp+f0fbrBnAOOO/Nf0HvrR6BZT+cq18jYXPbcxDBgGnTmdG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779168933; c=relaxed/simple;
	bh=rP9RzIPHI8dCnBjHtIv/y8xFe4w0kc8tSuhI6pYZh4E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jXhBcEYs4/nR1vpDoRuDQ1lGwkCGsFsBoNHMK51NNteugzt4Vn3nT4AY364XLdf0neN++uAw5KpsiXe3JkCYnSrhhaVyPHUpD05vtfP90VJfXEc+qLaCJhca9m3CSm3FPOhKJlZ5VQxkJLVb6ZA9Hr4UyuzI6mmWEL5mWV4AhXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TmPhvEP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TmPhvEP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1908FC2BCB3;
	Tue, 19 May 2026 05:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779168933;
	bh=rP9RzIPHI8dCnBjHtIv/y8xFe4w0kc8tSuhI6pYZh4E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=TmPhvEP+EV1rsncpjT3wPHyPBm6X0H7DE38LSE7TRfUiD5uiNuDbbf7Z6GIY/J732
	 tZYU5Zrf3nKGmTdXvGkjcZcmPIRzURLUPo5iW/o3kWpNhrz9Imr6pqGQqKH02OT5bi
	 GV94tpcX+G0ea47kVAEDqwuSbgGGThL2N9O02eY+CkNRCbfXyGSJx3JJdyZRcz8VQC
	 8BFrVXYCoeDYNgFTJtGTOr37P/2r7jd7JI6DvO8qdQ2liiPnOwnZZpdLRaZhUmvu71
	 bfbViwK+gz3rGm/kdTYVhKjKbSvqEvHnnUwjhnXGua5wLHunAkaiJn8z2X35XQP2pF
	 G0npnvxEopUSw==
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
Subject: Re: [PATCH v14 05/44] arm64: RMI: Add wrappers for RMI calls
In-Reply-To: <20260513131757.116630-6-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-6-steven.price@arm.com>
Date: Tue, 19 May 2026 11:05:22 +0530
Message-ID: <yq5aecj8t10l.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> The wrappers make the call sites easier to read and deal with the
> boiler plate of handling the error codes from the RMM.
>
> Signed-off-by: Steven Price <steven.price@arm.com>
> +#define rmi_smccc(...) do {						\
> +	arm_smccc_1_1_invoke(__VA_ARGS__);				\
> +} while (RMI_RETURN_STATUS(res.a0) == RMI_BUSY ||			\
> +	 RMI_RETURN_STATUS(res.a0) == RMI_BLOCKED)
> +

I guess this is not used. Also, that would require the call site to have a struct arm_smccc_res res.


-aneesh
