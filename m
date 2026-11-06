Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.233
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793970022;
	b=VPSRNJJOsxWW1abg/TE6VCiADiF5iQr62xOcjXGzCqcLYychVEBORypTdbl2geIwHHMk
	 wqH+Z40Oqn2czq0NbkrZlPC4PbdlrkXsywJYCzdvAaza2yir5oLjQWxu7a2y03R3MxA3f
	 Eu7MM6ps2X4pS3mj7n+Wr5yBJb41KZhqKBZw9taJznzNFZSweakpcvy7486T2DsCzkD71
	 culyt/4kER7D7TMO6les++BwszWeS7qoBT+lzbzXiZKc0qE4FHkaNY8E9+Sy/UXo+xNJP
	 TxgeIeLtuYuuywwemQdRpnGUO9KNXqD33az2JJ1AdmFAqnrFsDwsIGb+G+ZueCWAsxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793970022;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=CmVIaM3M0lQoS5Gw+xCsHIl1GWfVDNYrrM5ZXpTz810=;
	b=oxHqMF43GHaMOem6D8tjPPUAK4pESziAsbOagnPJ/BMfczUNnOIfeEtrh6OCzbaUBPdx
	 pnT2/7H85bW3g5aDmFRlz0Z7hGpoeVHKkSVX2EINWwNFuy1oQuqkcQjmueIw7Ksg3G5jh
	 7ceB0lkkYOtuWX1G3q+lQ2BSMCv+5pYTuMKM36vE4T637+zVm10ay2EUTFWanhTsC6lg5
	 DGxsMgHhIDhLYXkWTtdgrsTcSJSQpm7Zs4S+HOR4dxmg89XZUTA0zMHebO0LaqHWsMLNn
	 PFNHC2IsDPfm46ZoksYU0nm0SkSEoa6wmCsK5KGGlm/k183atbAqzRY4tPIksBkd0Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="CpP+3/t6";
	arc=none smtp.remote-ip=91.218.175.233
Received: from mta0.migadu.com (out-233.mta0.migadu.com [91.218.175.233])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E7A606A33B
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 13:00:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57E7A606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CpP+3/t6
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=CmVIaM3M0lQoS5Gw+xCsHIl1GWfVDNYrrM5ZXpTz810=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793970019; v=1; x=1794574819;
 b=CpP+3/t68utR6hEDiZS/i6ooDqKtUlhSz7zh1/RLyui3ByMWAjFE81XcDitGRloMXri8Ue66
 mcDiR0U4pNJu0mpYwct9AkxWxq/xH51prg8RqIdyQ8sw+YCxytebbUvoqFy9daBD8aGbicrZvXC
 vV0G6AnXbbqyXWwMMGkigY48=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 0522a21d47d23cf3;
	Fri, 06 Nov 2026 13:00:19 +0000
X-Mizu-Trace-ID: 0522a21d47d23cf3
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5bfca2a2af4so3370e87.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 05:00:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwmn+RPid3WJ9jlM6sSkarBayHWln/Y2Oyv+SJrlP0aTvKCpJf94a2ShMW282D8EV0pdXeArQM=@lists.linux.dev
X-Gm-Message-State: APuU4Z/agCOSwKljtSts+4uUjUp4Ls+JMXltbzabDHb6isaxLo3wgjdl
	wTvWBk8X6Gugxl3J+O5T11fBhsUgegaYA1EbbOuKImaKrC8Y7tubp8mOSl3pS2xAoigOfLo90cY
	MjH+u/NoerG/8trDgbGWtU2BQZe5dGOm/ZeZkBrPk
X-Received: by 2002:a05:6512:2509:b0:5bf:c9c6:ae92 with SMTP id
 2adb3069b0e04-5c0071b526dmr56719e87.7.1793970013173; Fri, 06 Nov 2026
 05:00:13 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261105-pin-barrier-v1-1-04ebf118175a@cs.columbia.edu>
In-Reply-To: <20261105-pin-barrier-v1-1-04ebf118175a@cs.columbia.edu>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 6 Nov 2026 12:59:36 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxoNcx4s4L2DRXLu6VydiG2N3OqRYr+kscghp0jVVwg5g@mail.gmail.com>
X-Gm-Features: AclHuK-w8IPMfkMD2ik_GPs_KpCTf31_7nutwDTH3Csiea4URVFMI1--f_NjCec
Message-ID: <CA+EHjTxoNcx4s4L2DRXLu6VydiG2N3OqRYr+kscghp0jVVwg5g@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Order a later pinner's accesses after the hyp mapping
To: xuheng@cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Could you also give a case in the message that a well-behaved host can
hit? Since 7.4, two vCPUs of one VM can pin struct kvm at the same
time from the __kvm_adjust_pc hypercall (cf533b4d3630), which then
reads it on a CPU with MTE.

Either way:
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
