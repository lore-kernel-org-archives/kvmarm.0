Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CB82DAFDA
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 17:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773249863; cv=none; b=SkSbQvm6vuMpQ4t+5tziQ9SDu+0YmYGsuqmoPwBBOVGYTAQk2GE/cZv9t3DnzhW0vE+QlOG/pS2ywG27wcKDUeH7odMkAiWEsUzNKi9lNSMBjuYWT8/n4ZKWjNBRCC2ONShCz4O8iK62XoXqK1hWs5R/AnsyZwtXH4KXHBqStss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773249863; c=relaxed/simple;
	bh=vIeT3rSFftaWh2UhBTytGLhB5LleCcqNZ5F/lFc9IFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d4j+GF2Jvq2n484v0fyvUakzei26XitnfUyRTd+gchhZzOGVeVa40GyrKxz7Viq1Hg3/7h5y9x7EcJ2dpLcivMOfcXBf08Fy55G7t7uUHQ2XpMfWyWQB5jVwVYnjo8tpWT6LySPN88VOBZYhVqYpEi/6F4VcoGtA+TPWXU4TE2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GmVazOWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GmVazOWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3FFC4CEF7;
	Wed, 11 Mar 2026 17:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773249862;
	bh=vIeT3rSFftaWh2UhBTytGLhB5LleCcqNZ5F/lFc9IFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmVazOWjKh3U2Yy4IfU4ZDKup7J4SjArMaGCa0SPaGfJdb6efW1QnLN4EwDIc/hPv
	 mtihe+m9+L1cIXnnjvbpWEShG1HuOQWYE1sGIZkD/x2CHSGspRJG+uY26NJEcAvrwb
	 rWIJHQAAFI62/6BDDs5pDIT9MMkkU1iiSAMURhe1bTkAf+FU3LAtOnO3aqe8UVc4fw
	 ECqGGcbdzYgz8JdPWW/y6yfhRVax5T1JOHOnyILHyNLYqWiM3roeOJgZ3NbeRJgfQW
	 mbnCFSx4DshqPWZjyCbE1tGacACoblTgn2xra+jWYY+JP/WntS3yz7P/XnurG4Ir5O
	 kYj6JVSOV8Gcw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w0NIC-00000000y5D-3Acn;
	Wed, 11 Mar 2026 17:24:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Fix out-of-tree build for nVHE/pKVM tracing
Date: Wed, 11 Mar 2026 17:24:18 +0000
Message-ID: <177324985285.329042.14266922779557644515.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260311164956.1424119-1-vdonnefort@google.com>
References: <20260311164956.1424119-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: vdonnefort@google.com, kvmarm@lists.linux.dev, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 11 Mar 2026 16:49:56 +0000, Vincent Donnefort wrote:
> simple_ring_buffer.c is located in the source tree and isn't duplicated
> to objtree. Fix its include path.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: Fix out-of-tree build for nVHE/pKVM tracing
      commit: ce6a2badf58170bcf73489cd73981bb5775c1e22

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


