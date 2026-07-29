Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A8547140C;
	Wed, 29 Jul 2026 11:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785323710; cv=none; b=YmvNXt/nU1vS4GynaYF3LN1g6+GGeC92q/Bk6Ov2sKzSPi5gspNoEjJkq9akSwZAtYW+SH3S1LDPgXEM+RnLaTkTj//CALVpGJpOjV8PAaqb1kGQqALMnCIt8hmpQQw7rsG8rEqruxw4z8wXO+Pwc68MqIlHKY0kYrz8+vtDewA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785323710; c=relaxed/simple;
	bh=F1+KmFyfJ9/PpEfXPqt6sOe6PRC+SXghIewP5cEMzxs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ogVAtqsykLIUvTNnYcgBaojAMTZuU+8aRUpRu2WFWsLLRJArCssSkKDYcrIeHF9OrfNnOyapXkvo3K/5L8o7j1jj5uuTzZ7hvfIr6kIkjYNsd2B336UR9xg63f4YUYgJIy1SYIQqvAFprEP3McqAwMf9Yy8ywF501gaBqcv8Ly4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XVSRNii+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XVSRNii+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5EE1F00A3D;
	Wed, 29 Jul 2026 11:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785323692;
	bh=tKvnyUlNglSuRC/NCqoBklSPll76aDe3LA+8HeghdP8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XVSRNii+wS9HmDlxh9oSyuTzskyW+gRBo3sWe49V690UaMGD99EWgMc7sDmaFEAeq
	 yLPTFyN312vLfz0kDbYVzKuJlgw8dTNziq7ORYTiPAef3fZHTtydruyCGPeyh/1yO7
	 uRwK4ySB94shavYCLjcaCNKEh7LWrlC712ft4EPX+oiDW50Qtd8/QhQgA5lLTO6ofB
	 k1UY8NR1je6BGEvGGqBSj+6ZzauOXGHxKt6D2XeWANur4p9Mx62K6s+5np2xprz3g4
	 SXmV3aGjgbWL4xSO5gQ0njRTpMsiXtN47Al8eL8qx8h5bHyZolWiZTIAJRxXccz8bb
	 jPaSot1Hez1Xg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/11] kvm/dirty_ring: Add arch-generic interface for
 hw-accelerated dirty-ring cleaning
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260729104548.3439958-10-leo.bras@arm.com>
References: <20260729104548.3439958-1-leo.bras@arm.com>
 <20260729104548.3439958-10-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 11:14:51 +0000
Message-Id: <20260729111451.EB5EE1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Low] The monolithic `#ifndef CONFIG_HAVE_KVM_HW_DIRTY_BIT` guard causes =
a build failure for architectures that implement only one of the hardware-a=
ccelerated dirty logging hooks.
- [Low] The undocumented API contract of `kvm_arch_dirty_ring_clear` silent=
ly shifts the responsibility of updating KVM dirty ring state to the archit=
ecture hook.
- [Low] Missing forward declaration for `struct kvm_dirty_ring` in `include=
/linux/kvm_dirty_bit.h`.
--

--- Patch [9]: [PATCH v3 09/11] kvm/dirty_ring: Add arch-generic interface =
for hw-accelerated dirty-ring cleaning ---
commit 54695fde1ebfc7f27e678570e500f9d9eb6ecff5
Author: Leonardo Bras <leo.bras@arm.com>

kvm/dirty_ring: Add arch-generic interface for hw-accelerated dirty-ring cl=
eaning

Introduce kvm_arch_dirty_ring_clear() to allow architecture-specific
hardware-accelerated dirty-ring routines. The call is added to
kvm_dirty_ring_reset() and falls back to a software version if not
implemented or if an error is detected.

> diff --git a/include/linux/kvm_dirty_bit.h b/include/linux/kvm_dirty_bit.h
> index fa4f6b67b6235..8492979d694e7 100644
> --- a/include/linux/kvm_dirty_bit.h
> +++ b/include/linux/kvm_dirty_bit.h
> @@ -18,6 +18,13 @@ static inline int kvm_arch_dirty_log_clear(struct kvm =
*kvm,
>  	return -ENXIO;
>  }
> =20
> +static inline int kvm_arch_dirty_ring_clear(struct kvm *kvm,
> +					    struct kvm_dirty_ring *ring,

[Severity: Low]
Does this struct need a forward declaration?

If this header is included before include/linux/kvm_dirty_ring.h, might this
cause a compiler warning for struct kvm_dirty_ring being declared inside a
parameter list?

> +					    int *nr_entries_reset)
> +{
> +	return -ENXIO;
> +}
> +
>  #else /* CONFIG_HAVE_KVM_HW_DIRTY_BIT */

[Severity: Low]
Could this monolithic config guard cause a build failure if an architecture
enables CONFIG_HAVE_KVM_HW_DIRTY_BIT to provide kvm_arch_dirty_log_clear(),
but does not implement kvm_arch_dirty_ring_clear()?

Because the fallback for kvm_arch_dirty_ring_clear() is excluded when the
config is enabled, omitting it in the arch-specific header would leave it
undeclared.

> =20
>  #include <asm/kvm_dirty_bit.h>
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 807c45fb1fc7b..3fa62894f3d24 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c

[ ... ]

> @@ -133,6 +134,9 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_=
dirty_ring *ring,
>  	 */
>  	lockdep_assert_held(&kvm->slots_lock);
> =20
> +	if (kvm_arch_dirty_ring_clear(kvm, ring, nr_entries_reset) >=3D 0)
> +		goto out;
> +

[Severity: Low]
Does this bypass implicitly require the arch-specific hook to manually upda=
te
the internal state of the dirty ring?

If an architecture implements kvm_arch_dirty_ring_clear() and returns succe=
ss,
this goto skips the generic software loop. The arch hook would need to
manually increment ring->reset_index, update *nr_entries_reset, and call
kvm_dirty_gfn_set_invalid() for each processed entry to avoid corrupting the
ring state. Is this API contract expected to be documented here?

>  	while (likely((*nr_entries_reset) < INT_MAX)) {
>  		if (signal_pending(current))
>  			return -EINTR;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729104548.3439=
958-1-leo.bras@arm.com?part=3D9
