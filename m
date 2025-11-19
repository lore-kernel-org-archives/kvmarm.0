Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2676F30E0F2
	for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 22:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763591732; cv=none; b=WAJCJV5U14U3+qlNwmRNAnPC5cFtyVd1OeT2iZJ9yFva9U25yBiFP00M3kxEKc714M0ewzcYGn4m9Ih619Hm9hk1zaWJEKVSl2NJwBrbazzplhjpZWn/det3raINDNTFz45qMyy9vDqgujolI9Icap9D1LNaGfvJvB6sNB2tur4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763591732; c=relaxed/simple;
	bh=DJy6fnE5dbdhKjrUNfky4jJT0ghtNhfTiQzLKtcXCDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vF3XCi5VkPCi/ggY0W9jYIs6A2HuZ7zmuHF6tgf84+xGrw+6b+wzLlJ2VeBMns1f2t7iNhCvf4ooA9gk3O9fvmmHJDuibwsNczu0tWQqjBGvhSpTMxXsyPUIHzU8bAT1XTNhwTXuLUljRJl0s1ZGkzx5ustlLgmkwxZuQKkH6xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C70E3GFW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C70E3GFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CE6C16AAE;
	Wed, 19 Nov 2025 22:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763591731;
	bh=DJy6fnE5dbdhKjrUNfky4jJT0ghtNhfTiQzLKtcXCDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C70E3GFWeWSEXXDjZ++W5CncR+JbntusCdMVgQHKP8pMpMnuofojOXQevuguqmy4d
	 VrzBNDaCbsbYBmPcN5GOtoQUr475VDscFzgRvSWoAO+ZSElC7Su/vmqi9x6DpoG4MO
	 1Pgo2AcNgsaZtswR22kIijIIwi7JEOr4rzTMU29fk907gaOoMn8e8Htd5OzeBlpGCj
	 Vg8Ku88gFzRnf3Mtpn3hTlqxNqXDt+UQqHAO1WGNdGVDQgDL2+c3L4u5rRYJfRxMEd
	 VZGqI2tqPiJGlzrH2S14QZtftguY4RK+ReX3pEo3F/9P+yWAYa1pjxfq6f2XWbxhRR
	 JMKqij1Hc8i+Q==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fixes to KVM struct allocation
Date: Wed, 19 Nov 2025 14:35:27 -0800
Message-ID: <176359161116.183996.3170816859732930577.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251119093822.2513142-1-oupton@kernel.org>
References: <20251119093822.2513142-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 19 Nov 2025 01:38:20 -0800, Oliver Upton wrote:
> Small fix to drop __GFP_HIGHMEM from KVM struct allocation GFP flags,
> which was always completely pointless and now trips a WARN for passing
> such an unsupported flag to vmalloc().
> 
> Oliver Upton (2):
>   KVM: arm64: Drop useless __GFP_HIGHMEM from kvm struct allocation
>   KVM: arm64: Use kvzalloc() for kvm struct allocation
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Drop useless __GFP_HIGHMEM from kvm struct allocation
      https://git.kernel.org/kvmarm/kvmarm/c/297877069bc2
[2/2] KVM: arm64: Use kvzalloc() for kvm struct allocation
      https://git.kernel.org/kvmarm/kvmarm/c/cb17d79ff51d

--
Best,
Oliver
