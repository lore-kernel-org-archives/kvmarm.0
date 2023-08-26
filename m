Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3726CA58
	for <kvmarm@lists.linux.dev>; Sat, 26 Aug 2023 13:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FDAC433C7;
	Sat, 26 Aug 2023 13:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1693054985;
	bh=BKQzKaMT4EWz0OB1KrT4OytLGbQVwYE8Bm/6NB4Wb6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SYxnZOHUay3poFNOeISOybe6+iEXeaMOGOswhLKS6uJDutoAybyhD63ywLZf7V05+
	 Ki4lIdVGv9beVRnLSSJl6+uZwrY/n8dKDX644c8VoUeuiu2gYMAY4QSD8i9KpmNoSu
	 Lm3ttws47TN0bZBzbqzytZlnDCns8v+s2BGl2oNspMlYWm6h6zoMIrCyY32pA71llq
	 /ecW3lahW//iKBon4rbxpXvJcC2lEt8Am+llYlevfXVRZFGsV9Aiprvgd6owdJ8MQ8
	 WuORcL93udbACc+tMrYQ8qLmCzMTNpFu6IWlMRZ5rImiYSj4OZhwTjzHWPtIBmpagc
	 nXkto8vcxxVow==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qZswQ-008I6n-Mo;
	Sat, 26 Aug 2023 14:03:02 +0100
From: Marc Zyngier <maz@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>,
	oliver.upton@linux.dev
Cc: smostafa@google.com,
	kernel-team@android.com,
	kvmarm@lists.linux.dev,
	qperret@google.com,
	will@kernel.org,
	kaleshsingh@google.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] KVM: arm64: Remove size-order align in the nVHE hyp private VA range
Date: Sat, 26 Aug 2023 14:02:59 +0100
Message-Id: <169305496429.3979957.11944896678371919319.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230811112037.1147863-1-vdonnefort@google.com>
References: <20230811112037.1147863-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: vdonnefort@google.com, oliver.upton@linux.dev, smostafa@google.com, kernel-team@android.com, kvmarm@lists.linux.dev, qperret@google.com, will@kernel.org, kaleshsingh@google.com, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 11 Aug 2023 12:20:37 +0100, Vincent Donnefort wrote:
> commit f922c13e778d ("KVM: arm64: Introduce
> pkvm_alloc_private_va_range()") and commit 92abe0f81e13 ("KVM: arm64:
> Introduce hyp_alloc_private_va_range()") added an alignment for the
> start address of any allocation into the nVHE hypervisor private VA
> range.
> 
> This alignment (order of the size of the allocation) intends to enable
> efficient stack verification (if the PAGE_SHIFT bit is zero, the stack
> pointer is on the guard page and a stack overflow occurred).
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Remove size-order align in the nVHE hyp private VA range
      commit: f156a7d13fc35d0078cd644b8cf0a6f97cbbe2e2

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


