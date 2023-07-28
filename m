Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B05D304
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 11:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A686C433C8;
	Fri, 28 Jul 2023 11:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690542301;
	bh=hi6Wts+RQuZp7i6CazrYDjg4Tk1ftTNLMWZhyyvtYKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ts96Vs9bl/EU1bJFGEn3J47DjjAf+gQkQMnu+7me8TYybCMzG2K+/vGQn0ZqIhtT4
	 EKD8+RuwRP8ltDkhJwHsoGI7V143oRM79h3WlrgRWd0QqRkIU22MIQJfjZtnq8HOwB
	 0ngLYtOiBo9qWnUndDhcfD0wXaaZDYSkQt0BoAPrg/BC2PhHoMfiYW9+pePdWRJtrx
	 +KC4nSayyBzDY3Eyx35kbQP/fztdrP5Co8H1PxIqaqw6o774VA4yVpcO3Tu2I8x4RO
	 PsZCjqEqgbWp9H9AZJjbVQhqbdjCcHMAHTpIV6nIjHxznrIO3foH+0jvQYni/X/7Ea
	 Gc55sWux/Gy5w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qPLHH-0003Kc-9A;
	Fri, 28 Jul 2023 12:04:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: oliver.upton@linux.dev,
	wanghaibin.wang@huawei.com,
	suzuki.poulose@arm.com,
	james.morse@arm.com
Subject: Re: [PATCH] KVM: arm64: Drop HCR_VIRT_EXCP_MASK
Date: Fri, 28 Jul 2023 12:04:56 +0100
Message-Id: <169054228043.973403.5579728754127374700.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230724142257.1551-1-yuzenghui@huawei.com>
References: <20230724142257.1551-1-yuzenghui@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, yuzenghui@huawei.com, oliver.upton@linux.dev, wanghaibin.wang@huawei.com, suzuki.poulose@arm.com, james.morse@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 24 Jul 2023 22:22:57 +0800, Zenghui Yu wrote:
> This was introduced in commit 0369f6a34b9f ("arm64: KVM: EL2 register
> definitions") and for more than 10 years nobody used. Remove it.

Applied to next, thanks!

[1/1] KVM: arm64: Drop HCR_VIRT_EXCP_MASK
      commit: e21f3905f98ff1f72b06614440c2be93fda58b44

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


