Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CE98F47;
	Tue,  3 Jan 2023 17:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79571C433D2;
	Tue,  3 Jan 2023 17:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672768585;
	bh=UC4RdBvcPnI5XJhhZ46pv1YotwVqygpNpSpelRcjc+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNq2WgLp6fiiAgRTQt9iNPOZmuaaRoeBfgUewesNE5DImDRlCrMbjbqSMDDiIsrFy
	 fQ83YDSZTq659bmYpz0aXisuvux6mnraKOdoQTbm8JpDuEzCHDkdZCh0Mmds2rOQr4
	 zwjr57RrWgKHYZBAU2oGsX+AOLkodvGX+nd5XUGzF+g2U5a6wQmmlHrkb/NpGNyF1g
	 jiab5756EaFtBNsVqKqCW7kzfCZqz0E0E9J4T6flkSFrvguURllYJpT8ZFXEwxrudf
	 t41+RiIxV47Yxh5zw0ecjSLfdvnlD3015xQwGTLefok2gZH6Usex2tz5xk+tFQ/HKP
	 hD7KRz4wXqP0A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pClWR-00Ga6w-6F;
	Tue, 03 Jan 2023 17:56:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Hector Martin <marcan@marcan.st>,
	Sven Peter <sven@svenpeter.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	asahi@lists.linux.dev,
	James Morse <james.morse@arm.com>
Subject: Re: (subset) [PATCH 0/3] KVM: arm64: M2 vgic maintenance interrupt rework pre-NV
Date: Tue,  3 Jan 2023 17:56:19 +0000
Message-ID: <167276854454.3239244.7195924669135808939.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230103095022.3230946-1-maz@kernel.org>
References: <20230103095022.3230946-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, maz@kernel.org, kvmarm@lists.linux.dev, suzuki.poulose@arm.com, linux-kernel@vger.kernel.org, oliver.upton@linux.dev, alyssa@rosenzweig.io, catalin.marinas@arm.com, marcan@marcan.st, sven@svenpeter.dev, alexandru.elisei@arm.com, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, will@kernel.org, asahi@lists.linux.dev, james.morse@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20230103175619.anZF86vZFlS1qHpSmg2y3_kxgJ1p4Pr_TGWVbRH0UF8@z>

On Tue, 3 Jan 2023 09:50:19 +0000, Marc Zyngier wrote:
> I've spent the holiday break reviving the Nested Virt KVM/arm64
> implementation[1] and allowing it to work on the Apple M2 SoC. The
> amusing part is that it actually works!
> 
> However, the way the vgic is implemented on this HW is still at odds
> with the rest of the architecture, and requires some hacks, some of
> which are independent of the actual NV code. This is what this series
> is about.
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: vgic: Add Apple M2 cpus to the list of broken SEIS implementations
      commit: 4f6202c9fb51cc6a2593ad37d8ddff136b7acef2

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


