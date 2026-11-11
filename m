Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794420371;
	b=NXunhG16iblw4eParuj3N2YEMdF61+t6tl8c6qwzBh+B1cwqsVTaHLb7WPQKmOKen3YD
	 l2KgQ/LxemEcAJESN5SznUwAnjm04ddLMUdggvtxZkW8Euu72tOavQVyT25SfiXJVFij4
	 icyOa1lI0j/EJ6qUKNESBxLaC2os5Hlfy9c+j5KYKuGC7McEDOrMQTvQkUSrxKrPFU3GQ
	 zz3N/rhO2J3nvQZO1wtMrPmRVuMK+z/geVL0JJCi2b2cFEmtid/HQRKHAIVqOuCM2buvo
	 A9NsWuNCtWoYvW7UulzaRhnUuPC6hnAIcfbKYqPaow9HqRorsRVA6LsepV6MhMnm52A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794420371;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nwZSOB7nv5mfMD76NYXhw0l0C4u8SWDXtLLQ6qO27Sw=;
	b=NeT2UCqkJ2nI/XDZqEGxJmGc2WJdTa9ibgvO0qZlBO8iVV0z6/7oIv7YBAOgWnVvqjHy
	 X8ZtvRRHC1cftfDQj45dXuTUBIqoPnq1coOoyyU7E/N6ooN8jCfqtVj0hQ7cgQJ7s3jm0
	 RIvWaMlfdD0ukXjEoOz9FWCP90iTk+XcWZSm6UgADMq35FzPgF7Xo1RcuYqreZsoadGs4
	 sNaNPBsmocOeIGMa0oM95KygLqX2cB/EmjdPxEgCesw5JDU+BmkoFniC8+oUJQv1wd4cb
	 Rxpc3z+QEJ7sj/09QU/JiGkyEUgqlv8hFzuaa9phzUs/lzZTu3+2MKUEdf3Yc/HD8aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FAw8aSSw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EBD606A31C;
	Wed, 11 Nov 2026 18:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FAw8aSSw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257C11F00A05;
	Wed, 11 Nov 2026 18:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794420370;
	bh=nwZSOB7nv5mfMD76NYXhw0l0C4u8SWDXtLLQ6qO27Sw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FAw8aSSwJBOyV6HWsjAbX77NwM7Y0oZNbXY5wsYwerV7Gcu2QDnk79j5TstbLzaJN
	 y18jUwDmEBL/fugRD7PFh5rd4NPZxu2k0qVri2yuDvhzcKZ1jdtbMHQxLzcdszSrcu
	 hnCnRXufK5HHPZSu7gm3N0XX2NDPaTKDDEdeu+xhCtiAEjWOnZsKVKB4ouwyeVy/FS
	 NzeCp0mmcSvEeuwrG+E1paXsLn4pwoVfDRVOuTor7DQBb0Jc+QZ+pt8Z3q36wljfh6
	 GOK9DpLw/aTmjEV/RNf1yufTGxFTd9uCxozbcauG2i2fgwZfkZBOqkT5OP+IeSbLjD
	 tc8kzKoo/sxgw==
Message-ID: <sashiko-outbox-209447@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/12] KVM: arm64: CCA: Add Realm RTT mapping and
 invalidation helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261111145758.217946-9-steven.price@arm.com>
References: <20261111145758.217946-1-steven.price@arm.com>
 <20261111145758.217946-9-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:06:09 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] KVM: arm64: wrong granule level when skipping missing RTT in
  realm_fold_rtt_level()
- [Medium] KVM: arm64: cca: unhandled GFP_ATOMIC failure in
  realm_create_rtt_levels()
--

commit 68d993c0f3cb9846fd5972acfd789cb5ebe22bac
Author: Steven Price <steven.price@arm.com>

KVM: arm64: CCA: Add Realm RTT mapping and invalidation helpers

This commit adds helpers to create, fold, and unmap Realm Translation
Tables (RTTs) for shared and private IPA ranges.

> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index b904e6541fb07..5aa34d68de595 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c

[ ... ]

> @@ -156,12 +286,94 @@ static int realm_tear_down_rtt_range(struct realm *=
realm,
>  					 start, end);
>  }
> =20
> +/*
> + * Returns 0 on successful fold, a negative value on error, a positive v=
alue if
> + * we were not able to fold all tables at this level.
> + */
> +static int realm_fold_rtt_level(struct realm *realm, int level,
> +				unsigned long start, unsigned long end)
> +{
> +	int not_folded =3D 0;
> +	ssize_t map_size;
> +	unsigned long addr, next_addr;
> +
> +	if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
> +		return -EINVAL;
> +
> +	map_size =3D kvm_granule_size(level - 1);
> +
> +	for (addr =3D start; addr < end; addr =3D next_addr) {
> +		phys_addr_t rtt_granule;
> +		long ret;
> +
> +		next_addr =3D ALIGN(addr + 1, map_size);
> +
> +		ret =3D realm_rtt_fold(realm, addr, level, &rtt_granule);
> +		if (ret < 0)
> +			return ret;
> +
> +		switch (RMI_RESULT_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			free_rtt(rtt_granule);
> +			break;
> +		case RMI_ERROR_RTT: {
> +			int err_level =3D RMI_RESULT_DATA_LEVEL(ret);
> +
> +			if (err_level < level) {
> +				/* No RTT at this level; skip the missing ancestor. */
> +				if (WARN_ON(err_level < get_start_level(realm)))
> +					return -EINVAL;
> +				next_addr =3D ALIGN(addr + 1,
> +						  kvm_granule_size(err_level - 1));
> +				break;
> +			}

[Severity: Medium]
Should this advance next_addr by kvm_granule_size(err_level) instead of
kvm_granule_size(err_level - 1) (matching realm_unmap_shared_range() and
realm_unmap_private_range())?

When realm_rtt_fold() fails at err_level < level, the walk stopped at a
single non-table entry in the table at err_level, which spans
kvm_granule_size(err_level).  Using err_level - 1 skips the span of the
entire table at err_level, leaving any foldable sibling RTTs in the rest of
that table unfolded, and evaluates kvm_granule_size(-1) when err_level is 0
on 4-level stage-2 tables (shifting past 64 bits on 16KB and 64KB pages).

[ ... ]

> @@ -191,6 +403,154 @@ int kvm_realm_teardown_stage2(struct kvm *kvm)
>  	return 0;
>  }
> =20
> +static void realm_unmap_shared_range(struct kvm *kvm,
> +				     unsigned long start,
> +				     unsigned long end,
> +				     bool may_block)
> +{

[ ... ]

> +		case RMI_ERROR_RTT: {
> +			int err_level =3D RMI_RESULT_DATA_LEVEL(ret);
> +			int level =3D find_map_level(realm, addr, end);
> +
> +			if (WARN_ON(err_level > KVM_PGTABLE_LAST_LEVEL))
> +				return;
> +
> +			if (err_level >=3D level) {
> +				/* Nothing present, so skip */
> +				next_addr =3D ALIGN(addr + 1,
> +						  kvm_granule_size(err_level));
> +				break;
> +			}
> +
> +			ret =3D realm_create_rtt_levels(realm, addr, err_level,
> +						      level, NULL);
> +			if (WARN_ON(ret))
> +				return;

[ ... ]

> +static void realm_unmap_private_range(struct kvm *kvm,
> +				      unsigned long start,
> +				      unsigned long end,
> +				      bool may_block)
> +{

[ ... ]

> +		case RMI_ERROR_RTT: {
> +			int err_level =3D RMI_RESULT_DATA_LEVEL(ret);
> +			int level =3D find_map_level(realm, addr, end);
> +
> +			if (WARN_ON(err_level > KVM_PGTABLE_LAST_LEVEL))
> +				return;
> +
> +			if (err_level >=3D level) {
> +				/* Nothing present, so skip this RTT entry. */
> +				next_addr =3D ALIGN(addr + 1,
> +						  kvm_granule_size(err_level));
> +				break;
> +			}
> +
> +			ret =3D realm_create_rtt_levels(realm, addr, err_level,
> +						      level, NULL);
> +			if (WARN_ON(ret))
> +				return;

[Severity: Medium]
Can realm_create_rtt_levels() fail with -ENOMEM here, triggering WARN_ON()
and aborting the unmap?

Passing mc =3D NULL causes alloc_delegated_granule() to allocate RTT pages
with GFP_ATOMIC | __GFP_ZERO | __GFP_ACCOUNT.  When unmapping a sub-block
range under memory pressure or a memcg limit, an allocation failure fires
WARN_ON(ret) and returns early, leaving the rest of [addr, end) mapped in
the Realm RTTs (for example across an MMU notifier invalidation before the
host frees the backing pages).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111145758.2179=
46-1-steven.price@arm.com?part=3D8
