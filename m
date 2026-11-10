Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794292222;
	b=caDap5t2OtP6XJC15lxY+p4c5GR06icjGGoSiEA4KHSJ5u73Z5fQXb48Woc75Z+BXCjh
	 POWRY9kcQvFNhCPGbeYXFwf1AtbCNvb4D4pwv/ZuR0JOMtlLixWEkelA678ONNE1Lttxk
	 FBeR+hMMJM1aRxn9fVqKhH2ktfNKXEQHt2DZLWArwRQx6fOIjdEDdU+1SqkXCGLaBIy67
	 YR9F4mr7i6JjCj/TgOAQz5KYgkVtCTWxkxDOctfxU5rOHIkZK/oNdpOh9LgN0Dsc54W2c
	 NfCe4jVZmzFxIK6v2sjg5KvDqJEAml0DO2AspZAC8124Bc7eXmPaqAGO4uRfVwA0elg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794292222;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UyKoJxiulzwVwB7OoQtvVr1mnOGtT0hnRjkwglAZSD4=;
	b=AUfvX6GzmWfH6jnZoLR4aoj9xV+tmJ+TkjYQONOswMU+4VVrvEmyjbXNUAe/ZRCncUbN
	 uybHQf9kqW34ePAfbvfogNsQSseYkuwxf+JV7Ox8BaXHU62X6jVz+9wKU2KPNxjIaNIpO
	 KVjlC0xBDou5qOFkInQUrPfwsv4vxpunHBdAQXt2+Igi+Zh2bPqxzwUsXu+95ibjJG+Pd
	 51bOavgyoM+xl2DOy98Wvg8uS42HGufiXeZSBP2U8jF8stHHQEC13ddHRBHJejOyXikeR
	 MkYErrIHS9+GycPbfCv6vNrIRsNPVZVSpTbV+2H2MwBjdwoPcg1gSA7iJF+IJ2uk0RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WRcry2Pr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD68D606A321
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 06:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WRcry2Pr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9FC1F0089F;
	Tue, 10 Nov 2026 06:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794292221;
	bh=UyKoJxiulzwVwB7OoQtvVr1mnOGtT0hnRjkwglAZSD4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WRcry2PrUU4o1ZHzD4LD89UOza4HwMazzzSfJELlkVBb+CMzmzEhFjVAyiPG6kz1z
	 nnCd3fUjG6i54xaZDmJ4WJ/YRsvfwPgyL8FKhqeQ1bwEmoRvlITGdjmQ5tzx8PLXQY
	 echDTuf///WKFk/avBtMGvO3IaS9R4YxMmvg07jhTlnYfu+0lj7b7o4dm3+uXRgVRH
	 3S8Nln7vIMsY0YSqwxl7alGu3QTX7KPBCLywPVWV4Um/Fm/wiOGwMjTQ88EmRGdnPj
	 Tva4pG6RIvztX8gYDvNJV07enzR/db7JnNmDMu71+hzXKNeDHRj4HJKVVDjMsBhCsE
	 oFC/I7Fuxbhaw==
Message-ID: <sashiko-outbox-206417@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: nv: Invalidate whole L1 blocks on TLBI
 RIPAS2E1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dan Carpenter" <dan@cryspen.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <6817d113e5f0a9cafe0ce5bc0847276b7f14aacc.1794210561.git.dan@cryspen.com>
References: <6817d113e5f0a9cafe0ce5bc0847276b7f14aacc.1794210561.git.dan@cryspen.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 06:30:20 +0000
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
- [Low] KVM: arm64: nv: multiple evaluation of compute_tlb_inval_range()
  in ALIGN*()
--

commit a02572444c705de05e0b8656d139113ddf1c61f9
Author: Dan Carpenter <dan@cryspen.com>

KVM: arm64: nv: Invalidate whole L1 blocks on TLBI RIPAS2E1

This commit widens the range unmapped by s2_mmu_unmap_range() to cover
the containing L1 stage-2 blocks using compute_tlb_inval_range().

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5ee1b521d2b3f..ef4554656ddfb 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -4116,6 +4116,17 @@ union tlbi_info {
>  static void s2_mmu_unmap_range(struct kvm_s2_mmu *mmu,
>  			       const union tlbi_info *info)
>  {
> +	u64 start =3D info->range.start;
> +	u64 end =3D start + info->range.size;
> +
> +	/*
> +	 * An L1 stage-2 block may be held in the shadow S2 as several smaller
> +	 * leaves, and R_TVTYQ requires the TLBI to invalidate all of them, so
> +	 * widen each end of the range to the L1 block containing it.
> +	 */
> +	start =3D ALIGN_DOWN(start, compute_tlb_inval_range(mmu, start >> 12));
> +	end =3D ALIGN(end, compute_tlb_inval_range(mmu, (end - 1) >> 12));

[Severity: Low]
Does passing compute_tlb_inval_range() directly to ALIGN_DOWN() and
ALIGN() evaluate it five times instead of twice?  ALIGN_DOWN(x, a)
expands a three times and ALIGN(x, a) expands a twice via
__ALIGN_KERNEL() and __ALIGN_KERNEL_MASK(), so each call to
s2_mmu_unmap_range() performs three redundant sets of shadow stage-2
page-table lookups under kvm->mmu_lock.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/6817d113e5f0a9cafe0=
ce5bc0847276b7f14aacc.1794210561.git.dan@cryspen.com?part=3D1
