Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2D933C7
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 12:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C25C433D2;
	Fri, 21 Apr 2023 12:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1682081633;
	bh=SFmnpbBwyZdk103tRAIxDFqmzOD77JIVRnortemvYR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZWh7cwNQYrMpwRCVw/Rbo+Yu+fAv33RNihPWTP6KzcIkftznhcie+35HHMlB6Aye1
	 +/D7cVvw9/pGigeI3nyhRAaVsy2st7y9vcxGTIXCudzath2ewgi6LGnv1nfkz8WXYS
	 Lmr5Nr2EWWCgd3PLOEIRPPKk8jKhFNcxwaBHwl3OWoX4/wv+Vjn7STqsZBMN5tai/L
	 WySFBrIougUwhNn5NGOkRx5Qse4dM8A4bCbXYPXvNJsLSRnJXS6JLjL3Nd/8lSoLRQ
	 3DsQc87wdQiGaLwqD/3/1xHEJCBY0V00M+LGzbhURZ6gitLsf8lyaTfoKnmbZrLZoe
	 jj6K5H6Jrnh4Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ppqGt-00AArE-FM;
	Fri, 21 Apr 2023 13:53:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	David Matlack <dmatlack@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fix for mapping incorrect PA at stage-2
Date: Fri, 21 Apr 2023 13:53:48 +0100
Message-Id: <168208160323.3020266.13478114341809956086.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230421071606.1603916-1-oliver.upton@linux.dev>
References: <20230421071606.1603916-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, kvmarm@lists.linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, dmatlack@google.com, yuzenghui@huawei.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 21 Apr 2023 07:16:04 +0000, Oliver Upton wrote:
> Ugh.
> 
> So it appears that there is a race between two parallel stage-2 map
> walkers that could lead to mapping the incorrect PA for a given IPA, as
> the IPA -> PA relationship picks up an unintended offset. This series
> eliminates the problem by using the current IPA of the walk as the
> source-of-truth regarding where we are in a map operation. If you're
> curious about the race, it is spelled out in the first patch.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Infer the PA offset from IPA in stage-2 map walker
      commit: 1f0f4a2ef7a5693b135ce174e71f116db4bd684d
[2/2] KVM: arm64: Infer PA offset from VA in hyp map walker
      commit: 39bc95be3782ba88e55cd72e830f37e74395831b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


