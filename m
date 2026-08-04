Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A953368BF
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 09:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785835872; cv=none; b=Me7dgCXLD4/fEVF0FNyJ1n7tDan+QmA18hWhlTRJWKgl2/Wb5iOMEPcpiFgl4YR89aY7dqDOAPv7Ae1c18oDwD4TYT0H9yBNXmyMV94JTrzLdgcpdE7xnIqmfLLuiwuvqlAPlQOq8pZgVFtbwEn2Y4p2RAwhIvdDEL08XH6dJCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785835872; c=relaxed/simple;
	bh=ndfEbLx6ryllD8rbesdTo54XdJU2olo7TJM2ICsv7ME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NJB5Dcr56EL3ebRrO8G61+Iro2fB6vrfPNSUt+DE+RCqkaHNYHErwsTP6CkJCgo3ARX0TzGpMz/wzLuaBioHROEcbceYMegt+TKlvTda37KXNfRdpA43kOCG9tinq0wa5AJ0lNqfIbKlaSKGIuvwgwj811VyS0mEHMU5ifZoxR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c1Tv6tJm; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c1Tv6tJm"
X-Forwarded-Encrypted: i=1; AHgh+Roote5WZz7nZKzDBLHVyr3fJ4/sjKX1uYd/caZOXUW86K7isGfVEpUx3QEo6Gb7nveytXe+1iQ=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785835868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OXQacLcIFwR7ZuYK6qsdnfsijiXHCug7tTEi1uY6KQk=;
	b=c1Tv6tJmxSRbr+X300jP8N/f9p3VrnL4LHGot3S3aDWGosI1Ypi6kTpLXy6mnLYt5gjgX+
	wDUOKZly4x26WmHBQn+gcdWGfqTQxZoQ1Ke/SpEgQurVUUeiRb3GYtn8NFVW7/fssuKK83
	2SfrZ23AyCtBwgU4G4iLRdDMZg9MLjI=
X-Gm-Message-State: AOJu0YydFkvXnmS/yGrXozTsTsJUo0yiLaH8rLir+sQP89I+msaoXV3U
	39KR4oyx3q+6QG1qpSK8EpbSKFS1hLIstMULvts2Wd0iGdNhnfnjyoxOgAP8PALmlyPkQSWXine
	9IauZHIVlCOn9COLTjc8fdNxxluUcarAvKBZ+hsMi
X-Received: by 2002:ac8:6f1b:0:b0:52c:d3a1:358a with SMTP id
 d75a77b69052e-52cd4fc8ac0mr12704081cf.14.1785835856207; Tue, 04 Aug 2026
 02:30:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260803-kvm-arm64-idreg-final-v2-0-d7d7e4efc640@kernel.org>
In-Reply-To: <20260803-kvm-arm64-idreg-final-v2-0-d7d7e4efc640@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 4 Aug 2026 10:30:19 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxNcZrS8vPrrymJq_FZHUenrvxOd3aJ+WB7Fn8qY0NkKA@mail.gmail.com>
X-Gm-Features: AUfX_mwOsdi-QRZEA5-6WcEPzmFvIg_rwrA6SfmdszIDnIgH0ZZi1VAKN1yeckA
Message-ID: <CA+EHjTxNcZrS8vPrrymJq_FZHUenrvxOd3aJ+WB7Fn8qY0NkKA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: ID register finalisation fixes
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Peter Maydell <peter.maydell@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Mark,

On Mon, 3 Aug 2026 at 23:54, Mark Brown <broonie@kernel.org> wrote:
>
> While looking at some feature enablement I noticed that there are some
> scenarios where we can end up with an inconsistently configured vCPU due
> to finalizing configuration based on ID registers before we have blocked
> writes to the ID registers. This series aims to clean up these issues.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

I didn't want to hold this for the broader coverage you suggested, so
here is a focused test for the failed-first-run path [1]. It fails
without this series.

Tested on top of v7.2-rc5 under QEMU: boot tests, plus the
set_id_regs, vgic_init and get-reg-list selftests, the last also under
nested virt (-M vhe, kvm-arm.mode=nested).

For the series:

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260804092421.1728880-1-fuad.tabba@linux.dev/

> ---
> Changes in v2:
> - Also replace the kvm_vm_has_ran_once() usage in kvm_set_vm_id_rg() and
>   kvm_vm_finalize_sys_regs() with kvm_id_regs_final().
> - Link to v1: https://patch.msgid.link/20260731-kvm-arm64-idreg-final-v1-0-3de2a5616dc6@kernel.org
>
> ---
> Mark Brown (2):
>       KVM: arm64: Finalize guest-wide sysregs prior to per-vCPU sysregs
>       KVM: arm64: Block ID register changes after we rely on the values
>
>  arch/arm64/include/asm/kvm_host.h |  8 ++++++
>  arch/arm64/kvm/arm.c              |  2 +-
>  arch/arm64/kvm/sys_regs.c         | 57 ++++++++++++++++++++++++---------------
>  arch/arm64/kvm/sys_regs.h         |  2 +-
>  arch/arm64/kvm/vgic/vgic-init.c   |  6 ++---
>  5 files changed, 48 insertions(+), 27 deletions(-)
> ---
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
> change-id: 20260729-kvm-arm64-idreg-final-77cbc46b558a
>
> Best regards,
> --
> Mark Brown <broonie@kernel.org>
>
