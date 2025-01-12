Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1362C1A8F7A;
	Sun, 12 Jan 2025 14:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736690530; cv=none; b=DV9uIIC54MK6t7FvLLadI1BDtdoIHYWrgoyA2k5LxfqVY1MPLwldpbRteUmt3A995VIgqnUEsscD/CKyh4JpN6OMKMH3JNftYm3x4T64RZo4UYZpo30kVDH6A3hxIqmfAMThlxHBPDKPLjUbCOSHSQkdQXfaIXzbyXBfoRaMVIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736690530; c=relaxed/simple;
	bh=LkIr9/qMHsqCCXEL2skzxvD0LdZzq3jF/JileN/w4jw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BgHKL535PAUr8DdZrv5DZNL2gvoQ7Z29XHD1EIOUpeykTf0ercyNj1khd/29JNZQMOdwmgySnlgaeYcn6otWq/vegsfPmus/cxiueErOXkjODaqA4UojZb/Esjal4wWz1dTGyG48wnUlVTWQ7CL/i+I0v0kFCgQPgmbnymCgPlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zhj19cq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zhj19cq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA06C4CEDF;
	Sun, 12 Jan 2025 14:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736690529;
	bh=LkIr9/qMHsqCCXEL2skzxvD0LdZzq3jF/JileN/w4jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zhj19cq008cHmAcc1BbuLxVaBOg+52Dy4VUj4XFLqfkyf7hCic/gU47KrLHhrspu3
	 iwXmmPzW0VXy/MySqRbivBrPkQC/xd/+3C93eC/wA8v7pEzypWtaT8+EBEdxMqooMD
	 s7NeqWgm4oJpdotgRxK6aRIQWc75r87vhxtkN1NxaigS44qXKjPLaeuUvtnWUlzZFU
	 njeMHOVo2Or2Sex1ANK6cumunmYgUl7BnpgyqCRMRjmROvVu7ltvMNN3Gkm36jQcVq
	 3qy6ELfLcK+uAjvt0Z3Ozg1p93Ti0wKAVhR+f9kUnLJ8ZIBNya5TMFWCI6ff9k01Wr
	 Hr7DxHTWut56w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tWyXX-00BM8R-9A;
	Sun, 12 Jan 2025 14:02:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	coresight@lists.linaro.org,
	James Clark <james.clark@linaro.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: (subset) [PATCH v10 00/10] kvm/coresight: Support exclude guest and exclude host
Date: Sun, 12 Jan 2025 14:02:02 +0000
Message-Id: <173669046278.1179369.4535548560849309424.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250107113252.260631-1-james.clark@linaro.org>
References: <20250107113252.260631-1-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, suzuki.poulose@arm.com, coresight@lists.linaro.org, james.clark@linaro.org, joey.gouly@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mike.leach@linaro.org, alexander.shishkin@linux.intel.com, mark.rutland@arm.com, anshuman.khandual@arm.com, robh@kernel.org, broonie@kernel.org, shiqiliu@hust.edu.cn, james.morse@arm.com, tabba@google.com, rananta@google.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 07 Jan 2025 11:32:37 +0000, James Clark wrote:
> FEAT_TRF is a Coresight feature that allows trace capture to be
> completely filtered at different exception levels, unlike the existing
> TRCVICTLR controls which may still emit target addresses of branches,
> even if the following trace is filtered.
> 
> Without FEAT_TRF, it was possible to start a trace session on a host and
> also collect trace from the guest as TRCVICTLR was never programmed to
> exclude guests (and it could still emit target addresses even if it
> was).
> 
> [...]

Applied to next, thanks!

[05/10] tools: arm64: Update sysreg.h header files
        commit: 38138762faffeb923d9f49efbcc09884f1530786
[06/10] arm64/sysreg/tools: Move TRFCR definitions to sysreg
        commit: c382ee674c8b5005798606267d660cf995218b18
[07/10] coresight: trbe: Remove redundant disable call
        commit: a2b579c41fe9c295804abd167751f9fdc73c7006
[08/10] KVM: arm64: coresight: Give TRBE enabled state to KVM
        commit: a665e3bc88081dd65642d83fc22a1abdb6a901bc
[09/10] KVM: arm64: Support trace filtering for guests
        commit: 054b88391bbe2e470c5484cb91622238314344fb
[10/10] coresight: Pass guest TRFCR value to KVM
        commit: aaf69eff6cdb8613ff1f6a520821f769dc92f969

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


