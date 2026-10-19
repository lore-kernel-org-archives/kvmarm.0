Received: from mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6774549BB72
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 08:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792399840; cv=none; b=HtlpeKEfbstSqhzCbrklHz5bE6AAoCi5UaLfFWLYDq5ncz98UEXuAcKAj/POXZmB0sGpUhEAMFTZfDad/+iCnO+e2PkvXvfN3a+WIQyvfZyzSgNVTnZ/HyHCGzse0rPG248kBzQ+Y8Hi5Fm7H88LQIDrZfWx37Qj88H9uU35t0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792399840; c=relaxed/simple;
	bh=smuPfukUTEhnLlad9GsBi0MdMFhYsr8EsSBrkOpeT54=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jb85p0WFU1JbmIqRBAKd+6fY9PsatJlyRwhKY+Kz+ey4wwQqUU/rgiRVpH05AHTCa9XAwhVgL6ZOjoXDbUOgJGBOBVcvq4Y+L1DvhDp/UGnXxjWg2RKzIxtt3LSPKII02ji5TTEwEnh0jEPpdzuVVU5UGbzs8TStqL0gvDotsic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CnVNoI7W; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CnVNoI7W"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=smuPfukUTEhnLlad9GsBi0MdMFhYsr8EsSBrkOpeT54=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792399836; v=1; x=1793004636;
 b=CnVNoI7WKYqX4ZhlD7DL/KlSqj6WOfzOfBqX0ZJbLEfD82y0q/siPiANqTTgnkRWCMj5yKn9
 fGpgXDlLAauSv5gCB+8S+NQizRl5VX/6f7+XMc12kiOUaSlK8e0b8W8iQ8zhmiZaQG6CH83Rh9p
 Bu3dqT9n87cJv/lkSMGAwH9c=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b6915b6c1e99e6bb;
	Mon, 19 Oct 2026 08:50:34 +0000
X-Mizu-Trace-ID: b6915b6c1e99e6bb
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5be3b2f17c1so6734e87.1
        for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 01:50:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByhxZCFLgCrYY0Pz80sL0GCdjnGpdRxN9IlObMvb+0ro8RqYivTYpHJjD/MY3KiFXR2DjLAq7U=@lists.linux.dev
X-Gm-Message-State: AFq9FYL7r7nI34N2euvt6+41EvSpvnwsbJN3WET996n25UQ+hBtGvS5r
	+zCxH5KeYI4eBn8wTL5fPmfi3EloKcqxUayS0dy6M/DxUU9iz5VOUToTfZA/feHCNCaNSpDI+Xf
	GrYV56O3vlqt6CFkguzVXDSu65SXh5euq04QYwjyd
X-Received: by 2002:a05:6512:ace:b0:5ba:3602:4343 with SMTP id
 2adb3069b0e04-5be51d51c40mr121150e87.16.1792399829578; Mon, 19 Oct 2026
 01:50:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261018080921.3942517-1-fuad.tabba@linux.dev>
 <8633u229lq.wl-maz@kernel.org> <CA+EHjTwHP7h_=e1s-iCDekMNvHGAQA3K1zv5v_4=PXQw9ueiFg@mail.gmail.com>
 <861p9m1709.wl-maz@kernel.org>
In-Reply-To: <861p9m1709.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 19 Oct 2026 09:49:53 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyDJ87A3e7tr6Q2UEvi9BRuuu5HQ90A_3VWaOFKnRmZkw@mail.gmail.com>
X-Gm-Features: AclHuK_GC1ojwYomVv0QIMlxdcqQYksqozcLWRejxdRqCJ0NJlVWgmqtZaSv6zY
Message-ID: <CA+EHjTyDJ87A3e7tr6Q2UEvi9BRuuu5HQ90A_3VWaOFKnRmZkw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Only enable S1PIE and S1POE with the
 features they imply
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 19 Oct 2026 08:31:18 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > I'll send your patch as v3, rebased on -rc3 with you as the author,
>
> Please at least add yourself as a co-author.

Will do, thanks.

> > once I've tested it. I'm dropping v2's trap table changes, since
> > they're redundant once the ID registers are sanitised. I made two
> > changes to your patch. The sanitisation now runs before
> > kvm_init_nv_sysregs(), so the nested RESx masks are computed from the
> > sanitised values.
>
> Isn't that already the case? At least with kvmarm-7.4,
> kvm_vm_finalize_sys_regs() is called before kvm_init_nv_sysregs().

It is. -rc3 doesn't have Mark's split of kvm_finalize_sys_regs(), so
kvm_init_nv_sysregs() still runs there first. I'll rebase v3 on
kvmarm-7.4 and keep the call where you had it.

> > I dropped the res1 half, which isn't set by anything.
>
> I'd like to keep this, as it will eventually get used, just like the
> recompute loop is a bit useless for now, but will become useful in the
> future as dependencies get recomputed.

Ack.

Cheers,
/fuad
