Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC138F47
	for <kvmarm@lists.linux.dev>; Tue,  3 Jan 2023 17:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69800C433F0;
	Tue,  3 Jan 2023 17:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672768573;
	bh=bASjt/VEWeldoBQAa+xsMEZuXAK0ZYCNfXSwTOB8GAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umSYJHy9XKGc6R1lA1bNKX4EknwSK/Lwc1by42L+nD7RG1GZJYDkzn1/ZxSQ/772A
	 FILKGUMQ7IAMvQ/c96h4SP9B7rCE6Dw/K8gPYjPFNeVBvv/M9DXxQvgGzoSSVuscQy
	 E+XwCD4CGi68Ji6CEu40UpvqyXjLWJ1eyjAH1SUdyGGPN3jCAksxA6y0knpYK2+b6l
	 eH2pJcKHBhMFaXHnXPB6Q4Cky+KG+o/xHBZbc0xejjEUpIWe+KVKcCO9Xu1M0sUgW5
	 eBisX1OPuHET0+k52s4Fy5FUN7Yn58FsCk+iAyRJbyH2MsP1iDg+lC7YSn4i+auER1
	 xMMmm4vKHOL4w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pClWF-00Ga6D-5e;
	Tue, 03 Jan 2023 17:56:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Add Zenghui Yu as a KVM/arm64 reviewer
Date: Tue,  3 Jan 2023 17:56:08 +0000
Message-ID: <167276854454.3239244.4963037118223652100.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230103123933.3234865-1-maz@kernel.org>
References: <20230103123933.3234865-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, maz@kernel.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20230103175608.cNzXZcMn3ZUJp9ylO4qM04Jr6aECDob5q9mr1oaMrfo@z>

On Tue, 3 Jan 2023 12:39:33 +0000, Marc Zyngier wrote:
> Zenghui has been around for quite some time, and has been instrumental
> in reviewing the GICv4/4.1 KVM support. I'm delighted that he's agreed
> to help with the patch review in a more official capacity!

Applied to fixes, thanks!

[1/1] MAINTAINERS: Add Zenghui Yu as a KVM/arm64 reviewer
      commit: f4d488bcbeedf5f625904beef0e1e55d85cb29c9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


