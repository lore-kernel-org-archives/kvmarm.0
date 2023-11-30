Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEDB249EC
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 10:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lUOeGGlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EABC433C7;
	Thu, 30 Nov 2023 10:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701341280;
	bh=BvwuXeINjVAOB9rLljbV0ttcsQU3FkmE3qA55taRKfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUOeGGluvEDq84UKFmYceR4FGYFrE4BDTZXPVu0zDhRhpdfEvHkBpSYUxUEjY9ny3
	 sdc/5Ekk2QRV+YAPLoAORWL2uuyAtrL4uX6s53RwqgrOA3hkKXIitr1CQJzyCXBGmd
	 ZibUtN+O6888s/xgP8eYmIeNIlJyKeS7ZzNJq9uXhW9pzQNNSRd3JL28KcT64qRpl6
	 aCd6BK9EBv7lh1vwvQtwDXfOjvJ0p/lzISuvO7nMgGHcjyCx4rcN2hHGvP3DqbMPA+
	 fPLZGP/pyUYSo/9PiuaSuI5PFoLkcfN6t2plEzwaKH1G5uBMNgpYHl855sB1SNZZJP
	 K+Kfgc7gGNhGw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r8eaL-000CRi-Gn;
	Thu, 30 Nov 2023 10:47:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@google.com>
Cc: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] KVM: arm64: Use helpers to classify exception types reported via ESR
Date: Thu, 30 Nov 2023 10:47:54 +0000
Message-Id: <170134123350.1758683.364591904437456425.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231128140400.3132145-2-ardb@google.com>
References: <20231128140400.3132145-2-ardb@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, ardb@google.com, kvmarm@lists.linux.dev, oliver.upton@linux.dev, ardb@kernel.org, will@kernel.org, ryan.roberts@arm.com, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 28 Nov 2023 15:04:01 +0100, Ard Biesheuvel wrote:
> Currently, we rely on the fact that exceptions can be trivially
> classified by applying a mask/value pair to the syndrome value reported
> via the ESR register, but this will no longer be true once we enable
> support for 5 level paging.
> 
> So introduce a couple of helpers that encapsulate this mask/value pair
> matching, and wire them up in the code. No functional change intended,
> the actual handling of translation level -1 will be added in a
> subsequent patch.

Applied to next with Mark's suggestion applied.

[1/1] KVM: arm64: Use helpers to classify exception types reported via ESR
      commit: 11e5ea5242e38d44fcede879473566bb6d68f954

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


