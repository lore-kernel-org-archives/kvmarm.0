Received: from mta1.migadu.com (out-104.mta1.migadu.com [95.215.58.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423A446A5F2
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 12:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788526027; cv=none; b=iBFtze9WXMCL9gOUuW+SJHU0Sv2rSuPhaAwxnyZDTtNbI5/4mimifmedJc/kNqdhNwzxJ3T1Qq1GrHdYX8X7HREBPg9APhMwe8OxX+/Re3HdmvQRjGoGrkSCXqN/lT5PqlOq6pDm/IBfxtBSVoyQKJcZ9izEGV27kSCs4XnEkLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788526027; c=relaxed/simple;
	bh=/6RRvdPfNSRfPhC78RQVkUQB+HiIR+zg4OQYXsiR3d4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BrnlSDBnwIX9R2pDOdWI99KzxJsh+P8q3hNcgWw2L8xHc3/9pfnvrL4MmH5SfeYIdMNMiUb8Cg1dxLv6WCrvFSCXyqa1usyKVPE7YUv3T1+RzfGAfbZRDNbO2ssjhiLwLlrQDXhjAJ6juhy5OxkhVmRwl7tt15mR58IzfWHd4fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jVJ9j09c; arc=none smtp.client-ip=95.215.58.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jVJ9j09c"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=/6RRvdPfNSRfPhC78RQVkUQB+HiIR+zg4OQYXsiR3d4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788526024; v=1; x=1789130824;
 b=jVJ9j09cVwQqrhxpDL1HfRBotbhBQgO4bsp9Ce+ju5OF6eB7EhzWfUHYQlFaWqRXHIQGG/MF
 neFin0eAca+KZmpDo/DHIpa1SnguSFDBvmg+hpWzmdx/ee2X8X6PGKYEZmZ5QRnJqkoafNKNWHO
 5zn/59xwaLyCGper/EXUFvJs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cfd4ed1faf10b732;
	Fri, 04 Sep 2026 12:47:04 +0000
X-Mizu-Trace-ID: cfd4ed1faf10b732
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so5258e87.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Sep 2026 05:46:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzTyH/KO1aU8XcOXbRNRa+Ezcew69A9pZwndD4bbMv2kz5EpiveUb4KSsgOV0iCWaoI+A7p6sU=@lists.linux.dev
X-Gm-Message-State: AFuF++ktyI5Sur7VjzAFS9GPgG4QajTGaRPHLy/uFs2KEjo8I/BOr1po
	nMX7MLb53Rw6+s292iL6HTQ62qM4Jlb4HLG0L6pg11M19W1y0LxYlQYycRAr5HXlIMIdWnEBL3h
	FbrYFYn+77r5QwTiQgUSJ+IYLTT9lYP68bepl4DHc
X-Received: by 2002:a05:6512:3d24:b0:5b5:e890:1953 with SMTP id
 2adb3069b0e04-5b6170e3a94mr115834e87.12.1788526017205; Fri, 04 Sep 2026
 05:46:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260904122445.31163-1-hemanth.selam@gmail.com> <20260904122445.31163-4-hemanth.selam@gmail.com>
In-Reply-To: <20260904122445.31163-4-hemanth.selam@gmail.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 4 Sep 2026 13:46:21 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwW64qwPPAY7GpGWnW7kTHgK+NOycPD+ztZLu8MxhKEgg@mail.gmail.com>
X-Gm-Features: AcwNN1W9fb-ZaN5mBBYmzsD57qiSfwaTLbZIgob5aDfYAa6RFKBB487JA6wU6YI
Message-ID: <CA+EHjTwW64qwPPAY7GpGWnW7kTHgK+NOycPD+ztZLu8MxhKEgg@mail.gmail.com>
Subject: Re: [PATCH 3/3] arm64: kvm: fix repeated word 'is' in comment
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Hemanth,

On Fri, 4 Sept 2026 at 13:25, Hemanth Selam <hemanth.selam@gmail.com> wrote:
>
> Drop the second 'is', reported by checkpatch.pl as a possible repeated
> word.  Only touches a comment, no code changes.
>
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> ---
>  arch/arm64/kvm/pauth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/pauth.c b/arch/arm64/kvm/pauth.c
> index d5eb3ae876be..22ff4b78d0e9 100644
> --- a/arch/arm64/kvm/pauth.c
> +++ b/arch/arm64/kvm/pauth.c
> @@ -5,7 +5,7 @@
>   *
>   * Primitive PAuth emulation for ERETAA/ERETAB.
>   *
> - * This code assumes that is is run from EL2, and that it is part of
> + * This code assumes that is run from EL2, and that it is part of

The typo here is that the first "is" should have been an "it", rather
than being a duplicate.

+ * This code assumes that it is run from EL2, and that it is part of

Cheers,
/fuad

>   * the emulation of ERETAx for a guest hypervisor. That's a lot of
>   * baked-in assumptions and shortcuts.
>   *
> --
> 2.48.1
>
