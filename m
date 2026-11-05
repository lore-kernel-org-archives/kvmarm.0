Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900871;
	b=UGbBS7JxRC7DCgXkJMgTttwydbKyUQaRl51U6ukZONbjz5EEsvZrly6xgMsNnv3HDPgP
	 mIUOghzTGOJtCbFPZJMGnBkvlo0U/GC6IZdUUk8XUjZR9OANrpp0JbSrW7v7a6X0kHCKa
	 hGRwqhVVpAeQPSqDP18DXJyMCZN1E29aFVEw+6N6gdVaZ9LlE9Bum5gSqQ6nfDEHvMVKO
	 1E/K/DRqxz169jAEz+RcclJpDe72JGVxzPVo2ERchRolbK2SyteLzTmfnH5JGb/aysoxd
	 OKg9KsgIkM/6dizmXXeqQb0ijtSVACHxve1q6Oes1erZHamgCqTzLJ53YtITKs2CMrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900871;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=yK5guq06GyB2POOrEH6V5+qRnqqw9aF5Y+PexajT4A4=;
	b=fHCiWbOc3g/6zTvlxfeWhpYDCe3Z6XPSeBopDSEdBQsn/qJ9oGgUbNkXt/1XwmXreRBV
	 WJrJUZPKbEZV9nvTOHPvSjPT8Rlro1IkBhYLbaSMX3jzijF8JM/7uhl2KPmgYiQF2dxpl
	 XQ/2sJRbX82v9ffDg8KeVRHtWa1kty33oQeOS510DUMFMTRw5C1VyxebuCpoLd6V33npc
	 6uyqhLqUScV5UdQK+8qidMppYoSYo9DmqPE5knQFnQYVbsfp+x6zAquhLzGufFhn7B8K6
	 PECmO/tbVtXT8Ltw5nSV04VlQ8/rUL9QRQ1+cGrmYGt0bQbL70TTrwnku0sz5Q1Gqqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UnPfYa3q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317F6606A328;
	Thu,  5 Nov 2026 17:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UnPfYa3q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EAC1F00919;
	Thu,  5 Nov 2026 17:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793900870;
	bh=yK5guq06GyB2POOrEH6V5+qRnqqw9aF5Y+PexajT4A4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UnPfYa3qDnqLQRHvVrNAuqpvDaJOJ6jHV4/9Jd5TTybeyTuR2OyeLNAuJTFs7rX74
	 WdurwevvTTlLMWrTN+MB/OG8bqZbWlno2jZcDxqc8v6r5x5eDVVKYWye0VDbOgCzS9
	 VnvjRlqdfPSOTPQNHP0WxkFApO6jZlD/ka496TCgdL52NPJAE573xfOxfF2qxK8fll
	 wn5Amn07xx1cFgTDqBxL376qtOmGlb9aBEq70HVIbobk0ptY/VS7lM+xWSrrA/kw02
	 YgqNnPraKUOLNRVTyJzRdeSj+cwT1oRv9DlhuUkbMkiV4Gd9fZi3XeVp3Rn/Q9CKOl
	 +siiQprvThIEA==
Date: Thu, 5 Nov 2026 17:47:45 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 00/28] KVM: arm64: Add Statistical Profiling
 Extension (SPE) support
Message-ID: <auy-TwnMbIn-r2xl@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-1-alexandru.elisei@arm.com>

Hi Alex,

I've gone through all of the patches now, thank you for your patience with
the review :)

So there are various dependencies/architectural decisions that need to be
made here to go from RFC -> non-RFC:

1. The 'Ignore MMU notifiers for guest_memfd-only memslots' patch [0] is a
   hard dependency for the series. I chased over there, hopefully we can
   get something landed there.

2. non-VHE, pKVM, NV disallowed for SPE - As I mentioned off-list, I spoke
   to Marc, and he confirmed that he's more than happy for these to be off
   the table for a v1. So I think you can drop the HACK: patches and just
   make these conditions of using SPE.

3. The entire VM needs to be pre-faulted, but who should do it? - I do
   think that relying on userland to do this is a little iffy. So I wonder
   whether it might be possible to, on SPE first run, prefault the ranges
   there, and make that a condition of using it? Relatedly, KVM could
   reject non-guest_memfd memslots for an SPE VM rather than trusting
   userspace there too.

4. Dirty page logging - patch 27/28 relies on series [1] being landed,
   which is also an RFC, and allows migration of SPE VMs. So we need to
   decide - do we want this migration? Additionally, I think it's
   reasonable to, if we want it, send both [1] and patch 27/28 as a follow
   up separate from the v1 non-RFC of the series.

5. Errata handling - the default already disallows SPE on the affected
   silicon, which seems right. I wonder whether kvm-arm.ignore_spe_errata
   should exist at all though, other than in some sort of debug mode.

So 1 is a known dependency, I think there's no getting around that, and
thus that makes merging [0] or something like it a top priority.

It seems to me 2 is pretty clear-cut, and 4 can reasonably (if we want it)
be sent as a follow up.

So really 3 and 5 are the decisions to make here!

--
Cheers, Lorenzo

[0]: https://lore.kernel.org/all/20260714160411.302386-1-alexandru.elisei@arm.com/
[1]: https://lore.kernel.org/kvmarm/20260702142912.6395-1-alexandru.elisei@arm.com/
