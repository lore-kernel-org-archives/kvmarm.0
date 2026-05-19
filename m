Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D6F364049;
	Tue, 19 May 2026 05:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779170131; cv=none; b=Ln39TwWSYSDdNo2xoVfubJ7bAVBuxokAzkV6Lps5D9mm6D77Sf/Ouck64nrqSxg0m8ZDvZMmcKqym98+FFazM9m1zb0PTxam8FxnRlxonS9JPn8h5tFPqy3fLRPvCDj3JG9RYa8Rr0RlyBQ1Gg6WFYDPjPp8kMaFEnl/CtpezE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779170131; c=relaxed/simple;
	bh=U+Hl3eDsVF7nBwtYqMoO1EpuTpi6vhdR2CjkU58X1K8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kkqljH3HXMVxTLsRnbTdHFHKyfT5aFmpRwxxT+hYCRQMWYzg+wXd3WhdBo1z/w7HWdFHwhIpP14qrjJwnoUA6udfPg2Mu+usrNDkluUH5FTsy2c1Xw1wLQlbzoMKJE8QPMd+VjeEY9gMF66MK/opPYkitNozS/OqtwPS0NhNVpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mMDO+eQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMDO+eQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F35AC2BCB3;
	Tue, 19 May 2026 05:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779170130;
	bh=U+Hl3eDsVF7nBwtYqMoO1EpuTpi6vhdR2CjkU58X1K8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=mMDO+eQso5vvPD9awxSIkdn8LkkgoJYL/gtU7cPm1cUQBkjGh1a3dnF6b2yMC4PSf
	 +uHyzMSQOXh6OnMQjNyfOdZBjp6RhlPrkBYADKdUPfLxeix9YZIJeVGNcEQGokkde7
	 HcSqTXLUztSWFiQWNNBPRftSSRINCirh4zR4Y1yRFLJqBgm0+aS2XYQSq97zVddULB
	 ju2/r5/WZ9e+TeZ0OpwkPld1/SnpjPZmf0AdasYsq98pBK454KH/7sPTpIB8iFQ46+
	 CYBxw7NHwz5NyzwXDGM23u2AqB8nwLz8nrK539TXyWgyxFqsSdqpekK5DzTehKFOZN
	 gXutkYur7OjVw==
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
Subject: Re: [PATCH v14 08/44] arm64: RMI: Ensure that the RMM has GPT
 entries for memory
In-Reply-To: <20260513131757.116630-9-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-9-steven.price@arm.com>
Date: Tue, 19 May 2026 11:25:20 +0530
Message-ID: <yq5aa4twt03b.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

> +
> +bool rmi_is_available(void)
> +{
> +	return arm64_rmi_is_available;
> +}
> +

Can we rename to is_rmi_available(void) ?

-aneesh
