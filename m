Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBE7BE4B
	for <kvmarm@lists.linux.dev>; Tue, 12 Sep 2023 12:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C7BC433C7;
	Tue, 12 Sep 2023 12:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1694521090;
	bh=BXu6ptgyecQIUkrKFm2tH6nrbuPPAmU1MiyX8w/vABI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UVf7CFIWK64KFybURAaxmszYuAJZQVkq3WPYIbjkEplAj/6ow9D+P8WwJFy04wj5s
	 VGAwo1gcklm3mT6mFYiu1zPSiCectHLvAJEZVjW5TT4VLVzQ+FdHjEQy3i0gq4L5QG
	 gtjZqKa0YZGTNQrSzR49Ow8Ro2KOkbSjp3Rf73NdOI1fRosQYnc/+AnLPbhHmkN9C3
	 SzEa6LfwifMJ+n6chToUNulW1ouVXnVMF9jQaaG/GLq3e+5pQEE2rV8UvMAC+Vn/pv
	 hGQBIwb9NJTmG0aoSffjx0utYXr1JYhzD4Rtq2/w9KO80oSCpQIqcrIXZ8aurSX5H9
	 JftbrsgMgFH0A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qg2LH-00CG6M-St;
	Tue, 12 Sep 2023 13:18:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>,
	oliver.upton@linux.dev
Cc: catalin.marinas@arm.com,
	Ben Horgan <ben.horgan@arm.com>,
	sudeep.holla@arm.com,
	mark.rutland@arm.com,
	james.morse@arm.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	lpieralisi@kernel.org,
	suzuki.poulose@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com
Subject: Re: [PATCH] KVM: arm64: nvhe: Ignore SVE hint in SMCCC function ID
Date: Tue, 12 Sep 2023 13:18:04 +0100
Message-Id: <169452107383.1254351.9556136170175405271.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230911145254.934414-4-jean-philippe@linaro.org>
References: <20230911145254.934414-4-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: jean-philippe@linaro.org, oliver.upton@linux.dev, catalin.marinas@arm.com, ben.horgan@arm.com, sudeep.holla@arm.com, mark.rutland@arm.com, james.morse@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, lpieralisi@kernel.org, suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 11 Sep 2023 15:52:57 +0100, Jean-Philippe Brucker wrote:
> When SVE is enabled, the host may set bit 16 in SMCCC function IDs, a
> hint that indicates an unused SVE state. At the moment NVHE doesn't
> account for this bit when inspecting the function ID, and rejects most
> calls. Clear the hint bit before comparing function IDs.
> 
> About version compatibility: the host's PSCI driver initially probes the
> firmware for a SMCCC version number. If the firmware implements a
> protocol recent enough (1.3), subsequent SMCCC calls have the hint bit
> set. Since the hint bit was reserved in earlier versions of the
> protocol, clearing it is fine regardless of the version in use.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: nvhe: Ignore SVE hint in SMCCC function ID
      commit: 373beef00f7d781a000b12c31fb17a5a9c25969c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


