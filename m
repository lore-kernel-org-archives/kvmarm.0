Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB5047DD7C;
	Tue, 19 May 2026 10:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779184949; cv=none; b=qPKaJa9W2yRT/M9+RtOdjrB2nw1qBwQatXvTE/L1PSbQZx6hwCDj5q7Zs43fWifWZno0fUBKbGaFRDdQwnyz3Ycbh+nbrUB0oqAtPkzESvzba2uwrZAt0I0XrXu1W9UhINUsdFm3p7oiRo1NmeiF4qCRoz8YBrlHJTsVmhTyqAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779184949; c=relaxed/simple;
	bh=5CY+IUXkmbYVoZqzVuKhQ3pZoZ4Pk6BK8MnYzDSzr7E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=L422nkrg/B4aB+H2KniMKB9h4XsVfkhG3Nnl1XGU7z5XLfaKSY4Hm4dTAgap77FIzDsu8eAfq/UBku5tTZMecPqWTFrSsqiSNSLbo3Fs9ujqSCqqGhj9osUxo4+ibHE4OsziGyAj0+TykJdG55+ttuc1w0xBYtExXTlihPLPItw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FCjRvMHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FCjRvMHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDF4C2BCB3;
	Tue, 19 May 2026 10:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779184948;
	bh=5CY+IUXkmbYVoZqzVuKhQ3pZoZ4Pk6BK8MnYzDSzr7E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=FCjRvMHJals+Nn6CQNjvcIFda8xr7o7GvV7HXOOaPv+oBEkbfHumyHVdTzBWmzMJX
	 9y/9he4/VJ3Bs5eMQhEVcbDIlBmi+HBcoI12ORsQymuciY5S/osY3WzwQ2FjVbKMR5
	 oM9V8EMF6BOeoyf0r4MV0B3CNksvJqT0q3VjjYBO6unRdMEaVHsdWzBQ1sXpEEendH
	 /U/O6if5goDue3gM21oIUeqmenUE3zkhzrsVLvLMYrqjbA2aeQ3ghJeTj416jFfesO
	 pskTY1BS6PFCLAXcdtu6H6hIbMztjmp6g8bGSBXOKRVvrP+CEcVaojmEzKq/SZF/aD
	 hdsusPyjxEdkg==
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
Subject: Re: [PATCH v14 27/44] arm64: RMI: Set RIPAS of initial memslots
In-Reply-To: <20260513131757.116630-28-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-28-steven.price@arm.com>
Date: Tue, 19 May 2026 15:32:16 +0530
Message-ID: <yq5av7cjsonr.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> The memory which the realm guest accesses must be set to RIPAS_RAM.
> Iterate over the memslots and set all gmem memslots to RIPAS_RAM.
>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
 
 ...
 
> +static int set_ripas_of_protected_regions(struct kvm *kvm)
> +{
> +	struct kvm_memslots *slots;
> +	struct kvm_memory_slot *memslot;
> +	int idx, bkt;
> +	int ret = 0;
> +
> +	idx = srcu_read_lock(&kvm->srcu);
> +
> +	slots = kvm_memslots(kvm);
> +	kvm_for_each_memslot(memslot, bkt, slots) {
> +		if (!kvm_slot_has_gmem(memslot))
> +			continue;
> +
> +		ret = realm_init_ipa_state(kvm, memslot->base_gfn,
> +					   memslot->npages);
> +		if (ret)
> +			break;
> +	}
> +	srcu_read_unlock(&kvm->srcu, idx);
> +
> +	return ret;
> +}
> +
>  int kvm_arm_rmi_populate(struct kvm *kvm,
>  			 struct kvm_arm_rmi_populate *args)
>  {
> @@ -890,6 +922,10 @@ int kvm_activate_realm(struct kvm *kvm)
>  			return ret;
>  	}
>  
> +	ret = set_ripas_of_protected_regions(kvm);
> +	if (ret)
> +		return ret;
> +
>  	ret = rmi_realm_activate(virt_to_phys(realm->rd));
>  	if (ret)
>  		return -ENXIO;

relam guest already does. 
	for_each_mem_range(i, &start, &end) {
		if (rsi_set_memory_range_protected_safe(start, end)) {
			panic("Failed to set memory range to protected: %pa-%pa",
			      &start, &end);
		}
	}

if so why is host required to do this ?

-aneesh
