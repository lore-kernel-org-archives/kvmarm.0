Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794418690;
	b=Nrk9wefdw8EQ0pdWBevUvvTzO5BaWNSRcGeAaQISz9Duyz7hqSjlRBU8ieB3fnjH87ju
	 1HNIQ0K253342lldRdFiJyiYoXQlFI8sl0oeEF/gAQ4d7f3HxrkQXlVJWR0Oufx272Nu+
	 u84CrSwH38lJlyZzixbEXDQFpdlUkog3MG1lDdWYhC0ardSwlpI84vqO2YseQioFpti/O
	 S+2zoXmFhLqYLLgoIK845RfxeY/k+cpuceV/JvUF+fruMb2BPifOlunwOaBpeMqCd4F40
	 Tc62GQmC6oph2r50csZnJ8iGOHKgi6Xrtxu9v/i8K3BQnioV5qvw4lCBQl4sE/YsuXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794418690;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/Bs98Ts5xtUJhc7AHMMHcakLSJhIybWcO5Py19VTF5A=;
	b=KGvaKOQKrOaZXBISkB8jWrkKC5uOGEiSdpM3AZ95qRVlWlnuuN8uv0UqMyFVmLQ0oH8s
	 spGhts1TFCu2aJHv7jvZkR7TcFE7oGwXSukZTnI9l1wzf8ElBkkgX74RU0330kDg0CAbB
	 nLe9BEydjLnQat/bY842/bM2Oojd8elcVZDcT9BYgO8M7YNGmxVz8zWPwNsUaFhGyXeU1
	 cjENsSrc/azKW8LtRAfVPUMLLcdpzdINDx0oUd7tOBv8CqQQ80cuCoKHxEhvlgpwmMJEK
	 q8SUdgVhl6ccOQhuFfzRA3NgQO8XRklYI+RO9gtICKjvs7nFQL71IgWy+qSxJqP2WKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=btMb9Ss0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89EB606A337;
	Wed, 11 Nov 2026 17:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=btMb9Ss0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551781F00A07;
	Wed, 11 Nov 2026 17:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794418689;
	bh=/Bs98Ts5xtUJhc7AHMMHcakLSJhIybWcO5Py19VTF5A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=btMb9Ss0rv6t4jYnI5kkZdy1IhR21KfWgGNcOqVrkYfcLGvBgZPED8Ft5zUXj700r
	 Z/g5cZYcOKQ6WSRmmMpx/0AkSZvM/R/APSMghIagzWq13TY3g9dmCtPM3GxXetEjvz
	 7KO69fjWeeEcoFsWSKl6uPgF2zUlsK411m31FDatBT/DVNReHbrjC06CY0c78bheQi
	 JKhDb5rYK9MEPqLWlENspMbId6RCjoom0GMvYovVmGNHysgpJTaNhaDrDiJbFAfVE3
	 1KyLxh7JwjRF2tT2k7/W3NWCLN4DSG1jt394P3Am3gFz0zSaH1/gJOgTGYj66TYfms
	 wox0YlJqdRbng==
Message-ID: <sashiko-outbox-209425@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/12] KVM: arm64: CCA: Tear down RTTs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261111145758.217946-8-steven.price@arm.com>
References: <20261111145758.217946-1-steven.price@arm.com>
 <20261111145758.217946-8-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 17:38:08 +0000
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
- [Low] KVM: arm64: possible skipped parent retry in
  realm_tear_down_rtt_level()
- [Low] KVM: arm64: cca: leak of realm->sro on error returns in
  kvm_destroy_realm()
--

commit 9b5e6ebefa08ce4aff4f7ddec8f9b62647e79039
Author: Steven Price <steven.price@arm.com>

KVM: arm64: CCA: Tear down RTTs

This commit adds stage-2 unmapping and RTT destruction for CCA Realms,
walking and undelegating non-root RTTs before destroying the Realm
Descriptor.

> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 69c628cfb6c74..b904e6541fb07 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c

[ ... ]

> +static int realm_tear_down_rtt_level(struct realm *realm, int level,
> +				     unsigned long start, unsigned long end)
> +{
> +	ssize_t map_size;
> +	unsigned long addr, next_addr;
> +
> +	if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
> +		return -EINVAL;
> +
> +	map_size =3D rmi_rtt_level_mapsize(level - 1);
> +
> +	for (addr =3D start; addr < end; addr =3D next_addr) {
> +		phys_addr_t rtt_granule;
> +		long ret;
> +		unsigned long align_addr =3D ALIGN(addr, map_size);
> +
> +		next_addr =3D ALIGN(addr + 1, map_size);
> +
> +		if (next_addr > end || align_addr !=3D addr) {
> +			/*
> +			 * The target range is smaller than what this level
> +			 * covers, recurse deeper.
> +			 */
> +			ret =3D realm_tear_down_rtt_level(realm,
> +							level + 1,
> +							addr,
> +							min(next_addr, end));
> +			if (ret)
> +				return ret;
> +			continue;
> +		}
> +
> +		ret =3D realm_rtt_destroy(realm, addr, level,
> +					&rtt_granule, &next_addr);
> +		if (ret < 0)
> +			return ret;
> +
> +		switch (RMI_RESULT_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			free_rtt(rtt_granule);
> +			break;
> +		case RMI_ERROR_RTT:
> +			if (next_addr > addr) {
> +				/* Missing RTT, skip */
> +				break;
> +			}
> +			/*
> +			 * We tear down the RTT range for the full IPA
> +			 * space, after everything is unmapped. Also we
> +			 * descend down only if we cannot tear down a
> +			 * top level RTT. Thus RMM must be able to walk
> +			 * to the requested level. e.g., a block mapping
> +			 * exists at L1 or L2.
> +			 */
> +			if (WARN_ON(RMI_RESULT_DATA_LEVEL(ret) !=3D level))
> +				return -EBUSY;

[Severity: Low]
Can SMC_RMI_RTT_DESTROY return RMI_ERROR_RTT with next_addr > addr (and
next_addr < addr + map_size) when the target RTT at level has non-live
initial entries followed by a live child table entry, or does the walk
terminate at level - 1?  This rests on an RMM specification detail for
SMC_RMI_RTT_DESTROY that could not be confirmed from the kernel source.

If RMM returns RMI_RESULT_DATA_LEVEL(ret) =3D=3D level with addr < next_add=
r <
addr + map_size, the next_addr > addr check treats the live RTT as missing
and advances addr to the unaligned next_addr.  The next iteration sees
align_addr !=3D addr, tears down the remaining child RTTs at level + 1, and
executes continue, advancing to the next map_size boundary without retrying
realm_rtt_destroy() on the parent RTT at level.  Alternatively, if the walk
terminates at the parent entry and returns RMI_RESULT_DATA_LEVEL(ret) =3D=3D
level - 1 with next_addr =3D=3D addr, WARN_ON(RMI_RESULT_DATA_LEVEL(ret) !=
=3D
level) triggers and aborts teardown with -EBUSY, leaving the RD and RTTs
leaked.

[ ... ]

> @@ -29,12 +206,24 @@ void kvm_destroy_realm(struct kvm *kvm)
> =20
>  	kvm_set_realm_state(kvm, REALM_STATE_DYING);
> =20
> +	/*
> +	 * REALM_DESTROY requires the realm to be non-live: all RECs must have
> +	 * been destroyed and the root RTTs must be empty. Unmap the IPA space
> +	 * and destroy any non-root RTTs before tearing down the RD. The root
> +	 * RTT pages are still owned by the RMM at this point, so keep the KVM
> +	 * pgtable alive until after REALM_DESTROY and undelegation.
> +	 */
> +	realm_unmap_stage2(kvm);
> +
>  	if (realm->rd) {
>  		phys_addr_t rd_phys =3D virt_to_phys(realm->rd);
> =20
>  		if (WARN_ON(rmi_realm_terminate(rd_phys, realm->sro)))
>  			return;
> =20
> +		if (WARN_ON(realm_destroy_rtts(kvm)))
> +			return;
> +
>  		if (WARN_ON(rmi_realm_destroy(rd_phys, realm->sro)))
>  			return;
>  		rmi_free_delegated_page(rd_phys);

[Severity: Low]
Does returning early on failure in realm_destroy_rtts() (or the surrounding
RMI teardown calls) leak realm->sro?  Unlike realm->rd and the stage-2 PGD
pages, realm->sro is host-owned heap memory that is never delegated to the
RMM, and kfree(realm->sro) at the end of kvm_destroy_realm() is skipped on
these early returns.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111145758.2179=
46-1-steven.price@arm.com?part=3D7
