Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7A549E127
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 16:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790009924; cv=none; b=NsMDj3fEWorE9oV/oFThwYIbcQ7wGaJnuMpYRQ0XgpTOz4cipXJeAc4Hq1OrdzTtWvIxbtcwtvbe5ugE8u8E6O10I0ALYewYUA6F/G2q0glIURgx/ODSphnEtGrrAHQpTS7Pf+wMRQ/Xez7wnPPBGaw79eOzMnsZnhTCqeUfXic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790009924; c=relaxed/simple;
	bh=0lILdtK/tx1bWXvDhjGxTI2itN4v8y7CRofldmPdtbw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cl2INEt5CXLzceSir2J6jTnsqpTWpC+dR8FgeHwcGnD8cv0TvxLmE3B5gVtdf1jYrTUACi5f4SLrRQk6IBXVrI7PRKuALx9QWKeqBeq7rx29px1V4mAhfWOKt7WppVB+G4EruB+M5V+Jh8iaXzSqIO4JhpykPMhIhZRB3GLE41M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gEli3nrr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gEli3nrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EE21F000FF;
	Mon, 21 Sep 2026 16:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790009921;
	bh=Ks8VroNyKEAtna6IVB+BVDyk5Oxibs+RhZvXkvuH+sc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gEli3nrrkLEmJLGWHBL2ZlOtiggDK9gQ4A5/RvfQ1FfpyYmEQiTb4YJWVmO0JJSmG
	 At7H8G/m78UU27r0+wG1uWncquC0lmHCPCDS2LboGktGATp+XvNIGyuNDyVOoVv8gr
	 u9pCv8SFfTnMjKGUupgtK24M3UUEqBbfoUeoO1zN6gPukI095kH0gkbR6cX3VH3Hjy
	 kDjfjnhe8m3pwjZdW5CQlzIgSMLumNmPZM5NdmtWDAl8bMPCs91Pcl2zF00VOuaGj8
	 SWbZJsZpF7KooPP5XbsQsgyML/9B7cgyZmcK9HyzFe84BkB39n/0XQVduq7GJOiJ0g
	 zTpoaP8FGj07A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] firmware: arm_ffa: Add FFA_FN64_MEM_RECLAIM2
 function ID
Reply-To: sashiko-reviews@lists.linux.dev
To: "Snehal Koukuntla" <snehalreddy@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260921164748.2958578-2-snehalreddy@google.com>
References: <20260921164748.2958578-1-snehalreddy@google.com>
 <20260921164748.2958578-2-snehalreddy@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 16:58:41 +0000
Message-Id: <20260921165841.93EE21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] arm_ffa: missing 32-bit counterpart for FFA_FN64_MEM_RECLAIM2
--

commit b51b8a72f11f56713926464f6a895ddb89b963d1
Author: Snehal Koukuntla <snehalreddy@google.com>

firmware: arm_ffa: Add FFA_FN64_MEM_RECLAIM2 function ID

This commit introduces the FFA_FN64_MEM_RECLAIM2 function ID in arm_ffa.h
to support the FFA_MEM_RECLAIM2 ABI introduced in FF-A v1.3 ALP5. This ABI
allows an owner to reclaim exclusive access to pages without requiring
intermediate transaction state maintenance.

Link: https://support.arm.com/documentation/den0140/j

> diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
> index e71d83ee0aef3..c78cfd72832a7 100644
> --- a/include/linux/arm_ffa.h
> +++ b/include/linux/arm_ffa.h
> @@ -78,6 +78,7 @@
>  #define FFA_EL3_INTR_HANDLE		FFA_SMC_32(0x8C)
>  #define FFA_MSG_SEND_DIRECT_REQ2	FFA_SMC_64(0x8D)
>  #define FFA_MSG_SEND_DIRECT_RESP2	FFA_SMC_64(0x8E)
> +#define FFA_FN64_MEM_RECLAIM2		FFA_SMC_64(0x91)

[Severity: Low]
Does the missing 32-bit counterpart for FFA_FN64_MEM_RECLAIM2 break
FFA_FN_NATIVE() compatibility on 32-bit architectures?

Every other FFA_FN64_ prefix in the header has a 32-bit counterpart. If
FFA_FN_NATIVE(MEM_RECLAIM2) is ever used on a 32-bit build, it will evaluate
to FFA_MEM_RECLAIM2 due to the architecture-conditional logic, which does
not exist here, and would cause a compilation failure.

For 64-bit exclusive ABIs like FFA_MSG_SEND_DIRECT_REQ2, the convention
is to omit the FN64_ prefix entirely.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921164748.2958=
578-1-snehalreddy@google.com?part=3D1
