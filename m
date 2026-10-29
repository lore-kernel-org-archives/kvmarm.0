Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.142
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793299202;
	b=yx30vrb6MHZOQylpkKENjkN+Ae+JUglBCtuZrB7LL7NZgNtiBfqJc+ctf/aCtuW+HO8w
	 H2I3YYqILFnyHUotjnq6ezHWla/1yquX8Xg3EYK+2/xjLmFpteBZDRPaeuJQwX9hBG8ux
	 nJ52VVFS13OVb/FfrlNay7wBB5wX4FYC8rHjqvPk3S/TYhTBxNLXl2evly/7KTsnvP+wK
	 /TQjlVGDXqFbMzdReImL3eRYa6jnzetxEH2ivhPg36lX+ukJKaw8lbAQl5doOo0cuwv7k
	 K/p29xtqXtM3RPCmaf+Ij/UIYs5W3l5DpZ2BJCY4declD0iDgd/844I7Gwx/a3TsbAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793299202;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=P8sAw5ur2lstKWkCV1NN3TteySnzETKS77xqYaYoeEY=;
	b=BeIZiD2Lgf1l9WBeDYQtsJxGuv+AryUl86CkouggtjLXd5dJabIuOEklhGPIZcMekWr2
	 Co6lweW2FPU3ySqHeScAJo/8C/XBBl8b6w9+VLJ5Bx4zVPhJFKkIFIRfX5O5uRXPwXG89
	 W+sMJaaxrp78P6Z5IJToJgLAUFFjZ7KUysFXrU96DKfivoyoCBoX+76+R0+P5BDMb4Ndt
	 keNmMxaUcjPKtME+M9c4Wnf/bjxq9PDpMheD9NR772buhO/bMDjqFWiUeCxnCYGnwV52T
	 C9PRHqKGbtATyFWj0+DVMye97f04lrnJC/OiIu3nznI8ohk25pghGgiFGRMH2jgyaiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=t6a9PSBl;
	arc=none smtp.remote-ip=91.218.175.142
Received: from mta0.migadu.com (out-142.mta0.migadu.com [91.218.175.142])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CA3606A31A
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 18:40:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6CA3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=t6a9PSBl
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=P8sAw5ur2lstKWkCV1NN3TteySnzETKS77xqYaYoeEY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793299198; v=1; x=1793903998;
 b=t6a9PSBl4enjIZvZUgCJyobtTBoRxozb1frOF1fvvA3HOVr+ROd1zIHfrqDefJSytPK/eWLk
 SrA3Zdg8C5RslKMSIB5HB4ShQzDM8xUAb/oCww0H25kpof9+yH3zJu09fpycc7ja6E2QevKEjDw
 nRqYC7lPf0BsBMHwYnyMbu1E=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 63c55e25a272ad8d;
	Thu, 29 Oct 2026 18:39:58 +0000
X-Mizu-Trace-ID: 63c55e25a272ad8d
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5be3b2f17c1so1350e87.1
        for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 11:39:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzUIRnV7GFgwzft+GNpUHbUaKYlbon6uDDKDb5bogfHSH4Nf7FUc5PXHHQ1LU4bpjaT+kOsqbE=@lists.linux.dev
X-Gm-Message-State: AFq9FYJ1N93QOOCmbwMXlM4ahG1EdCYXTiA7bqTs7J2qfJS/SuaMB/wF
	A42nqqBpsM2kZwZfjiXMPwUjBtNAk6fDc2aMEIg9FVvfLSW6oKJfKQWBgokkJ6BDvPzW+FRyuG5
	4zWBB/2Xm6ri+3SacRNcSBpM2Mp73ls9x23dRsKd+
X-Received: by 2002:a05:6512:1383:b0:5bf:cea4:4150 with SMTP id
 2adb3069b0e04-5bfd140feebmr228838e87.5.1793299192378; Thu, 29 Oct 2026
 11:39:52 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261029175238.3214788-1-weilin.chang@arm.com> <20261029175238.3214788-3-weilin.chang@arm.com>
In-Reply-To: <20261029175238.3214788-3-weilin.chang@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 29 Oct 2026 18:39:15 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzBB05GZdz6be0uqHFs7sK1879yBVDJrEqKrTtM8=_Lyw@mail.gmail.com>
X-Gm-Features: AclHuK_Wm_aye4dCeSRhGryTZlCEP8KkPO9b0e0oBdSMGn1JW0SmL7sHjZoHOTw
Message-ID: <CA+EHjTzBB05GZdz6be0uqHFs7sK1879yBVDJrEqKrTtM8=_Lyw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Remove stale remark on canonical IPA alignment
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Gavin Shan <gshan@redhat.com>, 
	Leonardo Bras <leo.bras@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 29 Oct 2026 at 17:53, Wei-Lin Chang <weilin.chang@arm.com> wrote:
>
> Commit 3b8ce2b5132ae ("KVM: arm64: Use a variable for the canonical IPA
> in kvm_s2_fault_map()") created a variable to store the canonical IPA,
> instead of calculating it when needed. It moved the aligning just before
> mark_page_dirty_in_slot() to an earlier place but did not update the
> comment.
>
> Remove the stale part of the comment.
>
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
