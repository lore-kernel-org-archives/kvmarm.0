Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A680272E42
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 23:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764028538; cv=none; b=SGqt6HWNvqMrQhdJuLHSGU9gkpRLHNOnQuaJR4LEycVVFjvzxAV4KzHqSD8CvYWe8eZYmG/rFLG6030CIfVkFN65GHkn6GlBLGjJio6YZlxG8TKvo5zwWr5llH6rDOBb8dKjQ6Z14wiYh0VkqTZBzbkbhb1bpnClCqU6BYu5QUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764028538; c=relaxed/simple;
	bh=+g4BsiSOOv2fzIxbsMz65MOZZrM4tm9FdMQA14UM6GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bitq3Xyy5OCk37usJ5g5ec4Ib95g3fkha2jyoaAzdhMImOzd3biOWbILRTWT/i0PcajcCid3V24y72tfHeCuq4j/V4VKmxtWjbBA2D1ut1irJpZNgmmeeloPbNIKH0Qcqy+iHMkRG+BGNgq2B6/Xsh6xsf7kVF5l7785bcIFaIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HxUJRqcB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HxUJRqcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9390C4CEF1;
	Mon, 24 Nov 2025 23:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764028537;
	bh=+g4BsiSOOv2fzIxbsMz65MOZZrM4tm9FdMQA14UM6GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxUJRqcBoniqnn3O0tlk/+hsN/wZg/7rbmL3BuRQ2lszdAeoju4Ek+tpayzdiivSK
	 93R7uhpUK3Zsq8aD+ZlKYhTHNYMoXDocMLttEs2cdOds+LZrfJ9EOsmhDXegjbtMAy
	 CIaphs2aG/uD9Cs2aya0UHN7XvzTiBgxGyQaCX+1zWA1J4b1QNotcAJGkFY3kPFP5G
	 Y3rWi3tLDsin44pth1aCE9yt5HSVXzRo14Ko88GdndILD2oClFgiEzbI8ZtQewOkRF
	 QV2rhVgkscYkBOtpxH/4TKW6S6F0fKiqIUCxVH+WmUrzu+SVzA07VvBHiQamrrvh4t
	 kzIOxzC+JamYQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] KVM: arm64: Fix compilation when CONFIG_ARM64_USE_LSE_ATOMICS=n
Date: Mon, 24 Nov 2025 15:55:35 -0800
Message-ID: <176402852965.1732225.2477505863451311884.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251124235409.1731253-1-oupton@kernel.org>
References: <20251124235409.1731253-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 24 Nov 2025 15:54:09 -0800, Oliver Upton wrote:
> __lse_swap_desc() is compiled unconditionally, even if LSE is disabled
> using the config option. Align with the spirit of the config option and
> fix some build errors due to __LSE_PREAMBLE being undefined with the
> application of some ifdeffery.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: Fix compilation when CONFIG_ARM64_USE_LSE_ATOMICS=n
      https://git.kernel.org/kvmarm/kvmarm/c/3350cbbc8f7d

--
Best,
Oliver
