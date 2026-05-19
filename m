Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A304BCAB9;
	Tue, 19 May 2026 10:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186349; cv=none; b=Ptmw44+yAhdf/lysXMoyWL3JsiafJdxrFsyJo/Jhe81UsxuynzUUAATyj1+S8sOPlxvs9/d0UQE2bjS+Dt5uyQ5G2OZV+VCqOQRij81BAnS/4aM6MQ8D3srP2X/oT24tPUrdn4zPEXhi5u8R3slDHFDvzYc6LTBi2FL9Amr0Z1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186349; c=relaxed/simple;
	bh=P5YfddLVQL7aZ5v/LZq0e1k59RJIWRdeUlHDtWhzr4c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pZgVR0+lsLKKqrzCdC96qjc1g4jQGtb8DJrsGNq97RRL0UpXf3BNL22su/n6Fg/2wA/RTkN/3BEC7dpaKFAz/OcaaMOLUSHS/Bd57tfiSO2zookC34tKsEdEYENLF+oOqjAd2+NxKCzUjXMHGb0QM7KKssul0DCwemjXAUhuvQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FNkvBKPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FNkvBKPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D69C2BCC9;
	Tue, 19 May 2026 10:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779186349;
	bh=P5YfddLVQL7aZ5v/LZq0e1k59RJIWRdeUlHDtWhzr4c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=FNkvBKPkbg7II0DvIuHKCqEJeTFm94iqnAJRMhA5FvZZh6jBd8ZlciRMQQfHH7rNm
	 O2gl8A3loKWcFmGK2B+tRaHPQ20f+lEVk0N6gLw+M4P7ly5oH41fpPhycawVND830T
	 0JlRGRjih8LfcZk1dRdBN5Q3uLFtWxU5Tm6G+5mCOrQehKaGtNuIgWGJ02u1Yz/o3f
	 XrHY6ghrqRVP50TtSAS3/eDoJXX/XxMOFLqiiifkxVbvU3Ev0Jk0qqXvGq3FuIBHyZ
	 irWqD7vYWxKX+ZA/0nE3JFOJIsnWAskrtWZYs664Wn2IxmWIwh4VIDtOoCkI6IKVuD
	 ZMiponcYh/GXA==
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
Subject: Re: [PATCH v14 37/44] arm64: RMI: Prevent Device mappings for Realms
In-Reply-To: <20260513131757.116630-38-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-38-steven.price@arm.com>
Date: Tue, 19 May 2026 15:55:37 +0530
Message-ID: <yq5ase7nsnku.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> Physical device assignment is not yet supported. RMM v2.0 does add the
> relevant APIs, but device assignment is a big topic so will be handled
> in a future patch series. For now prevent device mappings when the guest
> is a realm.
>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v6:
>  * Fix the check in user_mem_abort() to prevent all pages that are not
>    guest_memfd() from being mapped into the protected half of the IPA.
> Changes from v5:
>  * Also prevent accesses in user_mem_abort()
> ---
>  arch/arm64/kvm/mmu.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 776ffe56d17e..7678226ffd38 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1230,6 +1230,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  	if (is_protected_kvm_enabled())
>  		return -EPERM;
>  
> +	/* We don't support mapping special pages into a Realm */
> +	if (kvm_is_realm(kvm))
> +		return -EPERM;
> +
>  	size += offset_in_page(guest_ipa);
>  	guest_ipa &= PAGE_MASK;
>  

The commit message suggests that this will need to be updated to support
Device Assignment, but that is not true. IIUC, this is only used by
GICv2?. Can we update the commit message?

-aneesh
