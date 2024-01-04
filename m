Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290DC2C6A6
	for <kvmarm@lists.linux.dev>; Thu,  4 Jan 2024 19:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bBx0SXHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE01C433C7;
	Thu,  4 Jan 2024 19:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704396872;
	bh=tgI30V4ajcB5MFVw+I6wMT+8SDLfY+0Rffiyhxuoj8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBx0SXHxrmrpaax9fwiZh0ri2e2zdRbROcbDR0RSl1i6Ym2ldQZRTaAh3qbDWyX3P
	 D9kW+AT6ae/z0KdXrX6097uyB5EAlj5cRjviq8TeEznlfafhw0TuQI5QHzrBVWWrK1
	 BdOjfkNMYz+N/6NmS1wWUhDlfHx063a33h0901QEvsh0jYM/HUcF+5ItqACMW1ojfV
	 //K/B/zEFdoGpFmEw/NZtIUMz1rr4rFPtXwYKawnhEK0bCajBRorpHoZ+5U0ry6fOg
	 UZ8PKkdkZgkMKuF7hw9/GpTEmiCb3udaXNuId508KfAcvkVkdudIDC2s9X0nu76i1v
	 d7GUWzPj2oyVw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rLTU6-008uL2-7J;
	Thu, 04 Jan 2024 19:34:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev
Cc: keirf@google.com,
	linux-arm-kernel@lists.infradead.org,
	oliver.upton@linux.dev,
	Quentin Perret <qperret@google.com>
Subject: Re: [PATCH] KVM: arm64: Add missing memory barriers when switching to pKVM's hyp pgd
Date: Thu,  4 Jan 2024 19:34:16 +0000
Message-Id: <170439682675.922629.9956474617490140442.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240104164220.7968-1-will@kernel.org>
References: <20240104164220.7968-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: will@kernel.org, kvmarm@lists.linux.dev, keirf@google.com, linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 4 Jan 2024 16:42:20 +0000, Will Deacon wrote:
> In commit f320bc742bc23 ("KVM: arm64: Prepare the creation of s1
> mappings at EL2"), pKVM switches from a temporary host-provided
> page-table to its own page-table at EL2. Since there is only a single
> TTBR for the nVHE hypervisor, this involves disabling and re-enabling
> the MMU in __pkvm_init_switch_pgd().
> 
> Unfortunately, the memory barriers here are not quite correct.
> Specifically:
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Add missing memory barriers when switching to pKVM's hyp pgd
      commit: 040113fa32f27096f531c377001936e0d7964597

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


