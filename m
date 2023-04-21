Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E4133C7
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 12:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEE0C4339B;
	Fri, 21 Apr 2023 12:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1682081653;
	bh=9opgCbOJrBwmQQY6jxlzD9VuchuY6kdTsNf5q4hCqMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vR2ZbIZ9HlSWiFcPPkaQJgKpQfiebrHOVl1yQ5xZZX46LOs/0Up2ooGLNR9bFeiEQ
	 ffjYTSL8naFDrjEyzb9AbOXhcSy505+mWHqlvOMeCg0+ZQ/mSyRgpqFf7RDpcWqq8u
	 nxHiPrA6ZljRGgizq4IXusIjJ0+AbC0911N2O2fypQ9eELsNQ410nDToYnP+p/VVt4
	 agoxxg8dYWF2O2bMQCKhluygCSYevLtIFU/63YnmX77P1llVQuYo7AVwl2bZXlVolD
	 Mxp3n5rfHXHB7A/7X98MQ4Skgv+JX61KQ6QMxf8e1NykDjwP6Mmq+LPazEmY+ephax
	 0Q2SUJUdXos5w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ppqHC-00AAs4-Vx;
	Fri, 21 Apr 2023 13:54:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 0/3] KVM: arm64: Floating point documentation updates and code tweaks
Date: Fri, 21 Apr 2023 13:54:08 +0100
Message-Id: <168208160323.3020266.1586393936089126628.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221214-kvm-arm64-sme-context-switch-v2-0-57ba0082e9ff@kernel.org>
References: <20221214-kvm-arm64-sme-context-switch-v2-0-57ba0082e9ff@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: will@kernel.org, oliver.upton@linux.dev, alexandru.elisei@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, broonie@kernel.org, catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 07 Mar 2023 17:37:13 +0000, Mark Brown wrote:
> This series has some improvements to the documentation and code for the
> KVM floating point code, the main one being that it documents that the
> current behaviour where we disable streaming mode and ZA prior to
> running guests as being the intended behaviour. There's a more detailed
> discussion of that change in the patch commit log, but briefly we need
> to disable streaming mode in order to avoid EL1 triggering SME traps to
> itself due to executing instructions which should be valid.
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: Document check for TIF_FOREIGN_FPSTATE
      commit: 4c181e3d352e9280c84fb4b4c7a8940ce005374e
[2/3] KVM: arm64: Restructure check for SVE support in FP trap handler
      commit: d071cefdcca39fdbcdd4bf36868448820dbac34b
[3/3] KVM: arm64: Clarify host SME state management
      commit: aaa2f14e6f3f34de8edfb13566110a0fe0d88785

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


