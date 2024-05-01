Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0376D2F0
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 16:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714581246; cv=none; b=Hx8RWf7WkEqns83thKt0X9kH9q73hIYsjsuUgJQ6xIYTVh7PGMlQ2ky7LFtgCUMiXpb3gmcJqkQdMjR2viwHLohF/WSBgrz2RHNwpO3bAqg6P0ioMkXf5sy0Xnw+iF45TTWACi4zPK9arCXIUK5YUpikB/Gg2LeLSBHEq2fGcjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714581246; c=relaxed/simple;
	bh=rBOua23Gp9m9rCOAr2SWCDFzzgvaI9thtyfTsKfuoo8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=vBqAk6GjySRubWr8JjVQYwF0AT4o1Zz6sPgfrt7Kr5WUANTXUSFG3onms60xasCFV/0+xjqkFzuweMljfJJTCZslsP+QXcdsxBP4V818wI/Pa1UNhlj6K6QdHuap/mbRkP5+Jic4SBch1RCm37EMHWTOzlqhVgvUAWfE7Rzg7WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=laVwj+hO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="laVwj+hO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3061AC072AA;
	Wed,  1 May 2024 16:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714581245;
	bh=rBOua23Gp9m9rCOAr2SWCDFzzgvaI9thtyfTsKfuoo8=;
	h=From:To:Cc:Subject:Date:From;
	b=laVwj+hOljwDfvwsgLGeCrnOi0viDp1RAsG5rcFOr43fjlm0N4r2HgQh4boGCQ6GV
	 BBy7mzsIvqZ5J1xM2h4BnoVjAuj7gelpfg2QOZ9+0W1eS0mI/IBclIZcz1s5LUrS9B
	 wf6ppvPAst6rDy66YehFjOdgHfkL+ICaP/0WMlEh6kjR01k2r6X9i3b6s18GxOp6Xk
	 td94LpUTsRK6UAFnXDk/k9Jpm+i/iOXKGRIgTMEhfMwzrexR0tiraG7BzSoWa1DZ27
	 med0BUKxSG/cDFHNgK5Qvc8Rf0mwzSGG/oruIhA1Zz62X3j+asLlzJELrDjNndtPip
	 k2mRrmxKzH9+w==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] Tweaks to the kvm-arm.mode= early cmdline parsing
Date: Wed,  1 May 2024 17:33:58 +0100
Message-Id: <20240501163400.15838-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Here are a couple of tweaks to the early parsing of the 'kvm-arm.mode='
cmdline option so that:

  1. kvm-arm.mode=nvhe overrides an earlier arm64_sw.hvhe=1 option
  2. Protected KVM initialises in hVHE if VH is available in the CPU

This is useful for Android, where we'd like the default cmdline to work
on all CPUs (i.e. with and without VH) but using hVHE by default where
available and finally allowing nVHE to be forced by the bootloader
appending additional arguments.

The patches could probably be squashed, but I kept them separate because
they're doing different things and this code is quite fiddly when you
start reasoning about the possible interactions between all of the
options.

Cheers,

Will

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>

--->8

Will Deacon (2):
  KVM: arm64: Fix hvhe/nvhe early alias parsing
  KVM: arm64: Use hVHE in pKVM by default on CPUs with VHE support

 arch/arm64/kernel/pi/idreg-override.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.45.0.rc0.197.gbae5840b3b-goog

