Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477A23DCDBC
	for <kvmarm@lists.linux.dev>; Thu, 27 Aug 2026 08:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787821158; cv=none; b=jDF/WybpNya5Wl3plQDWDiV4TDhr+QmPxH4KOZnt9lcfIJuod+OycgcXU9QKqVvTwZXvls7uLw4pAXS05y6LAfLxEPsCZYdoKYfUzDOkr1eKIZ6zHJxNQRYR03LTvnF4eOUTY2Mb+kUabdCNykeiywlDkuhEU0qoKSuaVNVA3yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787821158; c=relaxed/simple;
	bh=vMcrYLKb2rGiNl2lES7gb9jc/fRo/kFIrFythpqbA5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jNVIdtImi/A4CHy4ZjLqnFJGZfANykXGrJojv/qDyS3DMaPnnRmmIXlVBnZf2YAW1937hT2G8dJI8GMxOhFiqciEoMgmwfDKk66zhDMuJ4upbDMxYo35pWDc5rWQdEadKm/muB5pQQSU+ySKSBACdRpfEgKxUzUUeOp91eCJQLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bjbu6xDw; arc=none smtp.client-ip=91.218.175.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bjbu6xDw"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=vMcrYLKb2rGiNl2lES7gb9jc/fRo/kFIrFythpqbA5Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787821153; v=1; x=1788425953;
 b=Bjbu6xDw5xwy40l8slr+57pqm1R1Lt5SHwz3pEvecuLMTCz1LwsqDD7gJn1fNkG0sa08DHEh
 H2Z5mEsSVadYQQVsjWFOxgP5luqFYVChtZCmv7eC2p0uCZqauDc2NNM0XM76hq3dP7f5MqL1ul2
 w/vuXf1vFmtFeQvBQ9Jbf0dQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b8c7b551844ca6eb;
	Thu, 27 Aug 2026 08:59:13 +0000
X-Mizu-Trace-ID: b8c7b551844ca6eb
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b0129cf6ffso5076e87.0
        for <kvmarm@lists.linux.dev>; Thu, 27 Aug 2026 01:59:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqouTTeGBDuRUPUdbBM7589j0FQAcGHPiRIxZt0J/sT680Dh6s7IgRbJxs6aSvzVDe3q56KVCQ=@lists.linux.dev
X-Gm-Message-State: AFuF++m3gxrHjHeNkeJTzjSL1Hr3jZ5vSiZ2QEDcJ/qNdsO10Ew9USSt
	/Pk7qFg6LktCLOjR1Xy29uoMb1XEuHc42UUuk43JRDZQ469OOl7AmZM4/MXCmdOC/cOTr9NPkzo
	ppCiU7V1Pls3Sc4cwKRkIdCuJAs3TSaonuHs5B5DH
X-Received: by 2002:a05:6512:2509:b0:5b2:a967:c0c9 with SMTP id
 2adb3069b0e04-5b503826bb7mr82177e87.7.1787821148250; Thu, 27 Aug 2026
 01:59:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260825164219.3347229-1-fuad.tabba@linux.dev>
 <20260825164219.3347229-2-fuad.tabba@linux.dev> <ao7uY-dpJocX6ety@arm.com>
In-Reply-To: <ao7uY-dpJocX6ety@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 27 Aug 2026 09:58:32 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzVVf_r2WU=2-WtNsQbmsCZ2iymS=7TXRZJUWgvN3ibcQ@mail.gmail.com>
X-Gm-Features: AcwNN1VmFyCYMk2mFQCC6IsCKuKvuxtYbRK_OCmChpUR57uHP893DFhxuwtdqPM
Message-ID: <CA+EHjTzVVf_r2WU=2-WtNsQbmsCZ2iymS=7TXRZJUWgvN3ibcQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] arm64: Apply overrides to CPU local capabilities
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Catalin,

On Wed, 26 Aug 2026 at 14:47, Catalin Marinas <catalin.marinas@arm.com> wrote:
...
> For completeness, we should add:
>
> Fixes: b3341ae0efa2  ("arm64: cpufeature: Use IDreg override in __read_sysreg_by_encoding()")

Ack

...
> > +     /* Apply the overrides */
> > +     new = override_cpu_ftr_reg(reg, new);
>
> Not sure we need this. The init value has already been clamped, made
> safe, so it won't change the result.

I'll fix both on the respin. I'll wait to see if Will or anyone else
has further comments before doing that.

> Otherwise:
>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks for the reviews!
/fuad
