Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEC6D531
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 13:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788872661; cv=none; b=Ni/z6kyK0XRfFsDM/b18BAwebEqDg4Rf+41uVPg8Ka1HDWCtp7spwL5zyui9v1gWU3hbE+0CVoCxCYX2G3TfO8sXHYVfmrFLUPQRKOhwb1+5Qgy7nhJl+WJtEANSm2w/OKgxvIrpQihuLXpg24NRV+cWpYPKFkQtu/Bae3v3LCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788872661; c=relaxed/simple;
	bh=Us/q7SLbzZ4oV0cqtA9AUdygdN3iWgHORK09/87t+C0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=krUv/x6yDbKvRyL5PH6lx1El/IlCHcKk/CtD+kvM7xneISQQHe06gYMBj9yn//cFn6cxk4Sqj4qRVzILe2ZdsVdAtLO5JwAIpQQy8KQDrqH2Fr5T3li1HDcyhihNuHT4pV1v7ZgEX+yZmGq0nG3BDkPVXymehkkwZ8p4m2WF/E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YtsbwTM1; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YtsbwTM1"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a18840e2abso6163624a12.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Sep 2026 06:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788872648; x=1789477448; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TF2FBSAbA99rTI7hgd6XJ5POJVbB9v0L/f44ZOGfZAY=;
        b=YtsbwTM1Yq+B4ryyqZVQ+jlDPCaCErCcu+4yYjQQvFpzfXfttiYbAefFrjDYEFnZxr
         8wS92OsEHZy856OslvEbYA2eAZ46WwfhcCmUsglPZKMs5C56daWMdeULiln9TUCR5hJq
         UTUcmg4Pp4NZmGz4t+HRJZnvAZiCFpidcQLcfwhYP62ZFaPPe7rug1fFvBMXuKh9iTiw
         FO20NchgYuJHUKlBMo+khqZv4yTTmZOddxf3myiC3F/WRJWNhtG9mgFLoSdQfDJRhQo5
         TBwRW8GimPAIpyuwIlQWIUU+rddH3wDiK5ZXdmvhhmXJhy3vjt08mVXU6GqQeiGrh/mB
         nSAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788872648; x=1789477448;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TF2FBSAbA99rTI7hgd6XJ5POJVbB9v0L/f44ZOGfZAY=;
        b=NuJsfPtwFCWwpEO2COLqd+BbdpoEJ0sDVyA4EqcJp1FoRBxtkRTg21atXlT6aH/rzW
         jdpuCVAicLtsfpdoD+8bos7NwFf7kv+f+S//WOT518nkLFIaxPqzDFWRuK6DmWTyPESC
         ab1vjbhc/JT0k+97a1qo6zkT6430e8daZ2Pp/M+EXNLsRE0moaObrSlmKNrMFNshInMx
         kqJMWfXXD6PWdlg+PKtEp7n6vB27DTOgbiLcRyBl6Cf6rQXoUDTfvUxtCASLzzEblNHP
         ZGYmjDUexLkj6JNB6i4NPyNCa7FSU9OnGo26AwDovgoxidfi8GWX4jqlc5QGs0tzLmbj
         LHoA==
X-Forwarded-Encrypted: i=1; AKwUvBzehbqW54t5E5bSR5c2oV/E7vgAAiCjHH6W5mA2Q/+lxIZGXs9uFGpdV9e1ifCm2G00jtnCN/o=@lists.linux.dev
X-Gm-Message-State: AFuF++k8PcXAFiuy29sc0YGN2QxMq4UP9rO5f5Xfq8ESkkAJ0ShmHztI
	pr0izhyfULNTktYRuefr5PAqAVkA5sNw3AaKAEcRLbtXXmNCk7u1d9ZtRSEYtsxR2A==
X-Gm-Gg: AYBFou1SugxXxSNbzSO9RlGU0p35mfCOxHi+WAxTZwIZv92zMJ4dPabkw3ssEAxDjBe
	FbzK6B2QdcyGMV9ACYYepp9Zj+wAPx5c9uaJb3Qoamin8OTCARTpXpjJuYHQ+HnC7vE/SeV28PB
	V0l/qSYZKbz1OlCOcPhx5GgtAToM7aE1giPrgT7qLeU5tz186dwmBDuz3Rp2E+M+NfkwFkW8hVh
	UqwHjQHPpWmPWoXnA2XCw7k87buDml3+zr2TgBGY+4RPXUZOe5JO2r9ff70UhGtaQIc2/pEefMJ
	+zeI029gTOoRbzQTlEY0vB2lA/w8dUdW4nPEjNFdoIxjdM1cFVC4R3vVfyVcUAVj8sTdJkGMwTJ
	rYYDb8IRJxvG+5HVHhVQp0b1t90pDFNaM772qHpPIzMwVmRJ57AuMcdCRt6VEusBXlEhRSC921q
	mbGvg8Un4PIZzl8cLI5oHvKh0Neskpi3cMb0T9BJupOAChcqYT7ESWU8FfzViSPHalkVqrJuCUA
	+abDYJ/9FtMlTZmsiIiem694YRZuR7i
X-Received: by 2002:a17:907:c081:b0:c25:6230:dfcd with SMTP id a640c23a62f3a-c260c9e3320mr1176298766b.15.1788872647225;
        Tue, 08 Sep 2026 06:04:07 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d582304sm623294966b.43.2026.09.08.06.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:04:06 -0700 (PDT)
Date: Tue, 8 Sep 2026 14:04:03 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>, Keir Fraser <keirf@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Quentin Perret <qperret@google.com>,
	Hiroyuki Katsura <hk590@cam.ac.uk>, Fuad Tabba <tabba@google.com>,
	stable@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: arm64: Fix host access to the EL2 stacks
Message-ID: <aqAHw8Is0bNBbXUl@google.com>
References: <20260908110713.1540304-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908110713.1540304-1-fuad.tabba@linux.dev>

On Tue, Sep 08, 2026 at 12:07:09PM +0100, Fuad Tabba wrote:
> Hi folks,
> 
> The per-CPU EL2 stacks are initialised as host-owned after pKVM init.
> fix_host_ownership() walks only the linear-map alias of each memblock
> region, and the stacks, mapped in the private VA range for their guard
> pages, have none.
> 
> Patch 1 is the fix, and it needs none of the other three. Patch 4 adds
> the check that would have caught it and would catch similar instances
> in the future: once the transfer is done, walk the private VA range and
> fail init unless every valid leaf is hyp-owned, or is hyp text mapped
> without write access.
> 
> Patch 2 is a fix in its own right, but to a different bug.
> fix_host_ownership_walker() matches hyp text on its stage-1 permissions,
> and that test hasn't matched on a non-hVHE host since 7.0, so hyp text
> is donated there rather than left read-only. Nothing crashes, but the
> instruction dump on hyp panic reads a page the host can't access, so
> the Code: line comes out as question marks. It matches by physical
> address instead, which is what patch 4 needs too. Patch 3 splits the
> start of the range from the allocation cursor, with no functional
> change, so patch 4 knows where the range begins.
> 
> Based on Linux 7.3-rc2 (df2908090cda3).
> 
> Cheers,
> /fuad
> 
> Fuad Tabba (4):
>   KVM: arm64: Transfer the hyp stack pages out of the host stage-2
>   KVM: arm64: Match hyp text by physical address in fix_host_ownership()
>   KVM: arm64: Move the private VA allocation cursor to __io_map_next
>   KVM: arm64: Check every private mapping is hyp-owned at pKVM init
> 
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
>  arch/arm64/kvm/hyp/include/nvhe/mm.h          |  1 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 20 +++++
>  arch/arm64/kvm/hyp/nvhe/mm.c                  | 79 ++++++++++++++++---
>  arch/arm64/kvm/hyp/nvhe/setup.c               | 16 +++-
>  5 files changed, 108 insertions(+), 10 deletions(-)
> 
> 
> base-commit: df2908090cda368b01ff43709f51890076c56157
> -- 
> 2.39.5
> 

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Vincent Donnefort <vdonnefort@google.com>

-- 
Vincent
