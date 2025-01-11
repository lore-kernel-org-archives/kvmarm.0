Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AD51E492;
	Sat, 11 Jan 2025 15:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736607758; cv=none; b=Hce9rSVS6RxxxYIGsFEDPFv1PPZvnYfQL/EJCkK/UFJdYZ5F+7rbQm06AnXIJyRWbWGXUpAT3FjLmNhsNhaJOWzb7jUJ1l5bAPrpcp2O+ZHi/ExvEMOwq7M7sxus1cLlI2e8pCvxigQkDe0p6yK1YQzBBUxyzQJzJyQQUBc74uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736607758; c=relaxed/simple;
	bh=U6bro49caK6aBzW6XG6V8QOCPxjNZ0rPepiWlKEKqd0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WlI0W0nHaHEIGeDyFAPrxFOax5u8b+Lwm0w8Cy0yIBWs+gx5DyffMNHq+OKFk1OnirVdpxRxPdLYJDS4fpRTmvhcn/RNA2uW5IIF/hLdxSmYQytjV5SMXaI2Ff7WofaCWAt9jRdKwzR4fmaHCP5rsCrCd4O3dviMBusBIk6YkOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pAxFbrlv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pAxFbrlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C313C4CED2;
	Sat, 11 Jan 2025 15:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736607758;
	bh=U6bro49caK6aBzW6XG6V8QOCPxjNZ0rPepiWlKEKqd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pAxFbrlvT1HYG5aLIdA47ajh4hlbVAT+fWIMgcyLXsQM239da7+yQ0KjaOad78SDC
	 a1uYSdK7mXAdYP0jWelWC3fHZAWcYqshrtiMtqagMwb9vmLpSpGIWO3B5+7/SZ3rCf
	 E0xRN6O/0IcTbHN2XDkzU7yA+WTdqFfGqq5ZEzCLzrFCqIZyNxM9X8c/JHQRAoxfhn
	 +tSpngkIwXnPJwoseZQ7eb6AI1OFOLhNUwxqpHtJDyswqmJarqnrmIgrIn3EWpqmih
	 p/muBQthODZyn/ERV8zdLWr7vEJoTN7LIZxZUy4Fy0B8nPWRdtqhR523CMZtXSiWdg
	 Ee14JZGEMVMTA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tWd0W-00BBeb-3P;
	Sat, 11 Jan 2025 15:02:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Explicitly handle BRBE traps as UNDEFINED
Date: Sat, 11 Jan 2025 15:02:33 +0000
Message-Id: <173660773861.818546.3192188976167687860.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250109223836.419240-1-robh@kernel.org>
References: <20250109223836.419240-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, robh@kernel.org, mark.rutland@arm.com, anshuman.khandual@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 09 Jan 2025 16:38:36 -0600, Rob Herring (Arm) wrote:
> The Branch Record Buffer Extension (BRBE) adds a number of system
> registers and instructions which we don't currently intend to expose to
> guests. Our existing logic handles this safely, but this could be
> improved with some explicit handling of BRBE.
> 
> KVM currently hides BRBE from guests: the cpufeature code's
> ftr_id_aa64dfr0[] table doesn't have an entry for the BRBE field, and so
> this will be zero in the sanitised value of ID_AA64DFR0 exposed to
> guests via read_sanitised_id_aa64dfr0_el1().
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Explicitly handle BRBE traps as UNDEFINED
      commit: a7f1fa5564be565bd4bc18875bb46ffd0c01d292

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


