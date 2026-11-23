Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795432486;
	b=rTb7lYYl0lwTcSSZioL5pbhjck1dFofS//Uu7Ile8YgRfQEGOQ1AK/sej7nOPbf7+baS
	 UjuZceTN6t2ThH21vHax1YQP8yV88h4Pskzmg5DHIgL8kXWCEUPeavoxQdKsBfvDrBx7z
	 RwslRxp3s+ZmKZRTMwwEteWY2kJrc0/HTtiqrlf122VmSratx47UjpfnUwhz5VHJPAr0Z
	 GhO1rgB3NLqDg6SNTk7Y2njtIs08K6/UUWCSoYynMic8y/EmSc09pT3GiyARSaaOUQR2g
	 IsKQLunRzenksDbK3Gn8BK1Qz952X1cGgOthR/LZAOm/PnR0TqvBRVTWzn8k3xmnvVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795432486;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TGR7nJf9Ig8CkPt4tFeuuk9mGRg/PknkGT5IU6Vkp7c=;
	b=A0qxMDe5+3haSJDqF4njkJWBXQFz6rfQQyhMeoWGJpCRNrDP0gdVIFnZviMfEAJFfqnC
	 0CwXLUhz8w07BmVyZARdN6HrXzuj/fGUVOXgQpDoPgPjqBgIglAtImpyOcO47h0J3dBr2
	 6Vyku4J4XUK9m89voHbOQNqvN9rg00MiZ2wSk6iRRS1IBs/16Y5aNVuFvIf+5pTebpJtu
	 YvOolCkBxn/mMOoHh1DUSOZaQEHdR0yWF+1NgDQRiHT07V/N1UCzS41nOa3rCMDCPK2rV
	 t5r7pq0JnHFiL+1m6OlIIFuqdS3FOjiPbhyJ2ptzYiiefEFtErXM5Mb4LbPb0P5jKkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZoQ9T1Hi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41586606A31A;
	Mon, 23 Nov 2026 11:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZoQ9T1Hi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318BA1F000C4;
	Mon, 23 Nov 2026 11:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795432485;
	bh=TGR7nJf9Ig8CkPt4tFeuuk9mGRg/PknkGT5IU6Vkp7c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZoQ9T1HiI/SWPe4Y3tSeNLJlwsaBkrr6LcDpafNXy8anSNM0htBgt6+1Wueu2esI8
	 Usblb2Hu0wfxebkwIPMk28caB7CP943C1QMoC+NNXHdnXP3WjKtOSlwvMDGkP1m+RV
	 FY3axUSYWGuTdDGsQz977Vh3lLduw+4aKQrFD5bgy5Mb2lA9r4QhcMp4QtSbtA1rIn
	 LX8JqTr1Uzjd6JZeaRHUaoirabCUwWDw3PNK3k2LK0kjYos6Q/fNKQshlp7/cNWjfK
	 DwBRXtpu3u3pA6VRa4ffdGmGVojDQahXgN/x/jrGMdt8ZvbNu2N3BHgS4ogsMFexHN
	 e1hhT2xBR2HFQ==
Message-ID: <sashiko-outbox-229104@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 10/11] KVM: arm64: CCA: Support runtime faulting of
 memory
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261123104233.95710-11-steven.price@arm.com>
References: <20261123104233.95710-1-steven.price@arm.com>
 <20261123104233.95710-11-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 11:14:44 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] KVM: arm64: RMI_BLOCKED and start_level mishandled in
  realm_map_unprotected()
--

commit ad7be4b62d117614b38172987f33095d60197e1c
Author: Steven Price <steven.price@arm.com>

KVM: arm64: CCA: Support runtime faulting of memory

This commit adds stage-2 page fault handling for Arm CCA Realm guests,
delegating private guest_memfd pages to the RMM and mapping shared
pages at unprotected IPAs.

> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index b34f5320b50b6..ab606a2dc2f57 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -593,6 +593,274 @@ void kvm_realm_unmap_range_filter(struct kvm *kvm, =
unsigned long start,

[ ... ]

> +static int realm_map_unprotected(struct kvm *kvm,
> +				 unsigned long ipa,
> +				 kvm_pfn_t pfn,
> +				 unsigned long size,
> +				 enum kvm_pgtable_prot prot,
> +				 struct kvm_mmu_memory_cache *memcache)
> +{

[ ... ]

> +	while (ipa < ipa_top) {
> +		unsigned long range_desc =3D addr_range_desc(realm, ipa, phys,
> +							   ipa_top - ipa,
> +							   RMI_OP_MEM_UNDELEGATED);
> +		unsigned long call_top =3D ipa + RMI_ADDR_RANGE_COUNT(range_desc) *
> +			rmi_addr_block_size_to_bytes(RMI_ADDR_RANGE_BLOCK_SIZE(range_desc));
> +		unsigned long out_top;
> +
> +		ret =3D rmi_rtt_unprot_map(rd, ipa, call_top, flags, range_desc,
> +					 &out_top);
> +		if (ret < 0)
> +			goto err_unmap;
> +
> +		if (ret) {
> +			/* Create missing RTTs and retry */
> +			int level =3D RMI_RESULT_DATA_LEVEL(ret);
> +			int req_level =3D KVM_PGTABLE_LAST_LEVEL -
> +				RMI_ADDR_RANGE_BLOCK_SIZE(range_desc);
> +
> +			if (RMI_RESULT_STATUS(ret) !=3D RMI_ERROR_RTT ||
> +			    ++retries > KVM_PGTABLE_LAST_LEVEL + 2) {
> +				ret =3D -ENXIO;
> +				goto err_unmap;
> +			}
> +
> +			/* Replace an existing mapping to update its permissions. */
> +			if (level >=3D req_level) {
> +				realm_unmap_shared_range(kvm, ipa, ipa_top, false,
> +							 memcache);
> +				continue;
> +			}
> +
> +			ret =3D realm_create_rtt_levels(realm, ipa, level,
> +						      req_level,
> +						      memcache);

[Severity: Medium]
Should realm_map_unprotected() translate RMI_BLOCKED into -EAGAIN and
check level < realm->start_level, matching realm_map_protected()?

When rmi_rtt_unprot_map() returns RMI_BLOCKED under RMM lock contention,
RMI_RESULT_STATUS(ret) !=3D RMI_ERROR_RTT turns it into -ENXIO, causing
realm_gmem_abort() or realm_s2_fault_map() to fail KVM_RUN instead of
dropping mmu_lock and retrying the fault.  Also, on RMI_ERROR_RTT with
level < req_level, level is not checked against realm->start_level before
calling realm_create_rtt_levels().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123104233.9571=
0-1-steven.price@arm.com?part=3D10
