Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2FA17B505;
	Sat,  1 Aug 2026 13:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785589357; cv=none; b=b7Pqkpebqrq1JTfmLT6C0hQX7jfHOX69yNKQcMTBUWISeh+jsMJ1AaavrlF+NKM6ujjn2ubV1yQLNla8EItvoCKLTenrVl0iCiJrUct4vhucInMyO5Oo4mDWpCixoswxaThBK06/JFwtbxv/mYZCt/WXSYqjbYs3CPQTBrcGc9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785589357; c=relaxed/simple;
	bh=g54X71I/ZUN6ITTVFC1emr8s6KCQGGMfUpJIo1+7p5c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=THOeTLLyOEpQFoVk1RqD51BgRjEGC6aEMlOFewjcPCWn8Xgcoq5KcUYJubpDXSwYZ2IoBeb1hqotCgCMs1x/5dJAyhOlLrmvFnIZEmCuypT7LKGv544jCPEYhHBm7IdGm1zMsncdcFbTQCMp7Xxz4V2WYdH40kzD6zwITXdXPds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ocTiOX0r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ocTiOX0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376BD1F00AC4;
	Sat,  1 Aug 2026 13:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785589356;
	bh=d24Ey/KMYXa45hN87+XbUtAVsPUF37W1aWT/VBGazmg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ocTiOX0r5uKU8ASS8ZY2M9Bk1rB8I99TFLIHYojQfNOnBEnDsKxO6AKAZs5FRnwMS
	 QevX/tseU1SB5sDSvnsO9Ow7+qPfcEpzyWtSBDUazL/OoXyA4oWvrD9z8xeAWaYJXS
	 jLnKUDKKBfQdDArZsbHl5YQItj2ZxFbklLYExMN0Pg5Xr6XeYhE7yO46+kaqCXtqH8
	 qMyLwNEZoQaOeGNeNHP1ZSG6ZZK70iMSxa8lJ+MqMQ4oTzXoDCQPYkTu1bHfOS29ji
	 /nPUC1y78UBfscpPcb2LIh3AUGXk9K2mVVDdXTbaYhbuW/Q5liYZOal6QdOgvUxai0
	 yB9cLXGBqdtTg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/6] KVM: arm64: Handle negative S1 walk levels in VNCR
 TLB size evaluation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260801124818.366274-3-maz@kernel.org>
References: <20260801124818.366274-1-maz@kernel.org>
 <20260801124818.366274-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 13:02:35 +0000
Message-Id: <20260801130236.376BD1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Stage-1 huge block mappings (e.g., 4TB, 64GB) are incorrectly trun=
cated to 1GB due to a 32-bit return type and a hardcoded fallback, leading =
to under-invalidation of the VNCR software cache.
--

--- Patch [2]: [PATCH 2/6] KVM: arm64: Handle negative S1 walk levels in VN=
CR TLB size evaluation ---
commit 55a3817e6985fb11462e68c9b396c2d3ee056461
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Handle negative S1 walk levels in VNCR TLB size evaluation

This patch fixes a bug where negative Stage-1 mapping levels (used to indic=
ate
S1_MMU_DISABLED) were mishandled by pgshift_level_to_ttl(), leading to an
invalidation size of 0. It introduces __ttl_to_size() and ensures ttl_to_si=
ze()
always falls back to SZ_1G when no valid TTL size is found.

Link: https://lore.kernel.org/r/ameGoxbn2wzBq2kL@v4bel

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 983ba0adaf4e6..b026d160f253d 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c

[ ... ]

> @@ -506,7 +506,7 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_ad=
dr_t gipa,
>  	return ret;
>  }
> =20
> -static unsigned int ttl_to_size(u8 ttl)
> +static unsigned int __ttl_to_size(u8 ttl)

[Severity: High]
This is a pre-existing issue, but does this unsigned int return type cause
huge block mapping sizes to be incorrectly truncated?

Since __ttl_to_size() and ttl_to_size() return a 32-bit unsigned int, they
cannot represent sizes 4GB or larger (like 4TB for 64K granule Level 1, or
64GB for 16K granule Level 1).

> @@ -562,10 +562,22 @@ static unsigned int ttl_to_size(u8 ttl)
>  	return max_size;
>  }
> =20
> -static u8 pgshift_level_to_ttl(u16 shift, u8 level)
> +static unsigned int ttl_to_size(u8 ttl)
> +{
> +	return __ttl_to_size(ttl) ?: SZ_1G;
> +}

If a nested L1 guest maps its VNCR page in such a huge block using 52-bit
VAs and later issues a TLBI with a VA far from the VNCR page VA, KVM will
calculate a severely undersized invalidation window. Because the true size
overflows unsigned int (or evaluates to 0), the fallback restricts it to 1G=
B.

This could leave KVM using a stale IPA, potentially corrupting nested guest
state by writing into unmapped or reassigned guest physical memory.

Should these size calculation functions be returning an unsigned long or u64
instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801124818.3662=
74-1-maz@kernel.org?part=3D2
