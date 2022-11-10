Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA0E1A629
	for <kvmarm@lists.linux.dev>; Thu, 10 Nov 2022 19:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D1CC433D6;
	Thu, 10 Nov 2022 19:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668108362;
	bh=dPkyAknHwJryAPn5DmZoOATQrFVqFoY2H5wqDArcLSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OlPzDUfPH4qRJqJBMcVhC2MfHGh/uFutBSLILpLEuNSo/CPq6Ux30Pa92/a6zhyJU
	 aoLMTsW7suxzHWYuZbKkubP4hDWHDV3XruHe8pRr8rAX2zcimHYU1S/waBcpXMG1Iq
	 2NkXeHvHXjUAkPyy+Y7FASHdp5PlfzbvrOUj1p0tH16gY4QYGtN+Hsf76ll07F1Lqg
	 lUf8tjGnpXyJsAoZZlCFeoe7djH967m7k3DQZW5w2xSp0yp7sgZRrtWSkqaGZpYPSb
	 uAirsWdJtMwHKnW3TiWw0ohfMINotOssm8STJbIyM1MyeAiH9ag0cXS19tfIK9XrCW
	 esbWXKwl3zKcw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1otDBY-005EvE-8l;
	Thu, 10 Nov 2022 19:26:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v1 0/2] KVM fixes for exotic configurations
Date: Thu, 10 Nov 2022 19:25:57 +0000
Message-ID: <166810833824.3362685.17402898950434182398.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221103150507.32948-1-ryan.roberts@arm.com>
References: <20221103150507.32948-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: ryan.roberts@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20221110192557.4VbLAl21T9e3qa3mFnfvJLcn_904BNn85yjanC8J6H4@z>

On Thu, 3 Nov 2022 15:05:05 +0000, Ryan Roberts wrote:
> I've been adding support for FEAT_LPA2 to KVM and as part of that work have been
> testing various (84) configurations of HW, host and guest kernels on FVP. This
> has thrown up a couple of pre-existing bugs, for which the fixes are provided.
> 
> Thanks,
> Ryan
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Fix kvm init failure when mode!=vhe and VA_BITS=52.
      commit: 579d7ebe90a332cc5b6c02db9250fd0816a64f63
[2/2] KVM: arm64: Fix PAR_TO_HPFAR() to work independently of PA_BITS.
      commit: a0d37784bfd7f699986ba3a64cfeb68a03cb7fd0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


