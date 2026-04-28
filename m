Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314E5DDA9;
	Tue, 28 Apr 2026 16:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777395472; cv=none; b=Aq8vqB8MP3QRoSTLIb+6ZgYizru3xY6HAmHvuVBKKveOUZ7QxiIkJc9jIBHK5DkZsO8vDimVM77xDsWgHnvSL1QbmG3r/PUsg90bLJyqEZ+ipqvBUjyfPuUsU3eqG/VhYl+XDR2uq2BBqttD5PmgDVx3YBm8w+kRFqBhtYcqL7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777395472; c=relaxed/simple;
	bh=hZ0/IZxdG0H8WXycgd5737y0AjNHtzAueGMbQWJW+O4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XZr4JziAUPqnfgBQNhbqQHbgtn1hco2TkClQ3HslNm6vADxA93u7u6m7qbR3y00yaZZ+eN+tszPakenH7kUBlLLJJYD6NZxQW67PBHEkJ14PzSgZJ5O/lbx6kurNNimUYIU0oeyf1KrcpVSnWEOhc5UlY7rFvNtc1jEeBf/XyZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X2EVUPYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X2EVUPYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4ECC2BCAF;
	Tue, 28 Apr 2026 16:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777395471;
	bh=hZ0/IZxdG0H8WXycgd5737y0AjNHtzAueGMbQWJW+O4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X2EVUPYpppo5GxMsQv13o/gSgMZj7fOKUguIJ68E0aS7QIhkZCtBuQdeQlEGaGEJ4
	 2+hCxuRocGWSIr+VV4huz0XZaPITihk5mylBsEVHczQoHpii947l022VCJAD+9BkJ0
	 PdWlmeYnQwdvpAfiecEi3OtwvsHl35VMPZ0J1E8jCClb+9gvYmB72ItI4KiK6PQbr3
	 BXPl1x31U3a8NBX0EgUE10zasgy0i1L8n3i8lm8CFu+mwr4NJ6tVDmTYYMiXHDMt6C
	 wDO74dGyJ4q5fF36X751WSa4boJ1CkIMTVrMfoThG8Trl/Y+d1EoEi/KQaQLTwD7Dj
	 braGODl3UgWLQ==
Date: Tue, 28 Apr 2026 17:57:46 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com,
	vdonnefort@google.com, catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6/8] KVM: arm64: Propagate stage-2 map failure on
 host->guest donation
Message-ID: <afDnCiQNJrP7UI2m@willie-the-truck>
References: <20260428103008.696141-1-tabba@google.com>
 <20260428103008.696141-7-tabba@google.com>
 <afC5_jrTEVRfJ77x@willie-the-truck>
 <CA+EHjTyTy2qLm=CbOOYR6rmjg5tH38PifAV+qAhbZxidY5szxQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EHjTyTy2qLm=CbOOYR6rmjg5tH38PifAV+qAhbZxidY5szxQ@mail.gmail.com>

On Tue, Apr 28, 2026 at 03:36:43PM +0100, Fuad Tabba wrote:
> On Tue, 28 Apr 2026 at 14:45, Will Deacon <will@kernel.org> wrote:
> V2 will drop two patches (in addition to the HCR_EL2 one), and will be
> as follows:
> 
> 1. host->guest share and host->guest donate (kept, rewritten): add a
>    memcache-sufficiency check during the existing pre-check pass
>    (option 1) and return -ENOMEM cleanly without touching any state.
>    Restore the WARN_ON() on the subsequent kvm_pgtable_stage2_map() —
>    with the topup precheck it asserts an established invariant rather
>    than ignoring a reachable error.
> 
>    For the single-page donate, "topped up" is
>    KVM_PGTABLE_LAST_LEVEL - vm->pgt.start_level (mirroring host EL1's
>    kvm_mmu_cache_min_pages). For multi-page share I plan to use the
>    conservative nr_pages * (LAST_LEVEL - start_level) bound and flag it
>    as conservative in the commit message; happy to compute a tighter
>    alignment-aware bound if you'd prefer.

For now, I think we should just check against kvm_mmu_cache_min_pages()
because that's what the host is using.

Cheers,

Will
