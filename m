Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CF03FE37D;
	Tue, 19 May 2026 09:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779183626; cv=none; b=F+H8MdNFvR/ttjQV7UDjowPM5Z+vK/3L+BAdmmpUrm2WGzyCySD9nZ/TNJUShOXpxHc7Lqe+irH1aZWJvrLTwBB4pKqRtW2U1G4NNCEjV8nKNw8CuPtCCB3Jzq2xtyNB4sVEGfSvJNEmleUxUm3u9mXHiEU7LVUwWUgtdA2Gk84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779183626; c=relaxed/simple;
	bh=o4J6QqMYpGZvmNuQqLrqFIRgj7m9/fIFtO5TPzuauHo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bB/r9bqcrwDVS0x5WFOEtZzq/xEUu2WkVxI56h65aueFUFXNLadp9pu87SQ5CYIcQURiv0pM0X8qMdOsVhJ5cUP/vzvSzVBz4OPsHwhfmY8fKni+BGcM49MsHz80wSJlo428RN4QfIxHigrIm+NxWBl28sNwQIcX4lJtCPGJG/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oR6vMJHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oR6vMJHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133BAC2BCB3;
	Tue, 19 May 2026 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779183626;
	bh=o4J6QqMYpGZvmNuQqLrqFIRgj7m9/fIFtO5TPzuauHo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=oR6vMJHZ1hsZL72AJG0MkJgGa2n/YtUM32dpuHsbzYwF4H0uYIHfnCydwREwO3mQH
	 59RSQhrNfCZ9mxSbqk5WMHbJUveqd+xhOze1mf48iur17h0NVmhS/TBosAJYib0beS
	 Q2cxhihEbpbQk+aVfogepWt4oGWNxMu1MHlsUwZldkQkdf5Tj22UvVd7DF0pkdDwn1
	 IMWaV/6K5CcQdDt6YPKJMDJxVSqgznIq9dKBwUQVRXW45M6M8Td3hUr0DTWfCzN7ji
	 4aXAkmOwx8vMq+Vw8s0oQZFH7VeidG+bgPFc0LnB8ziEEvmaH7G2y4FZTGJMtP2M2r
	 QCeG9vkaY2/Hg==
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
Subject: Re: [PATCH v14 23/44] arm64: RMI: Handle RMI_EXIT_RIPAS_CHANGE
In-Reply-To: <20260513131757.116630-24-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-24-steven.price@arm.com>
Date: Tue, 19 May 2026 15:10:11 +0530
Message-ID: <yq5ay0hfspok.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

...

> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
> +			   unsigned long size, bool unmap_private,
> +			   bool may_block)
> +{
> +	unsigned long end = start + size;
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	if (!kvm_realm_is_created(kvm))
> +		return;
> +
> +	end = min(BIT(realm->ia_bits - 1), end);
> +
> +	realm_unmap_shared_range(kvm, start, end, may_block);
> +	if (unmap_private)
> +		realm_unmap_private_range(kvm, start, end, may_block);
> +}
> +
 
kvm_gmem_invalidate_begin() indicates a private-only invalidation. How
is that supported?

-aneesh
