Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA597E
	for <kvmarm@lists.linux.dev>; Tue,  1 Nov 2022 19:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3280DC433C1;
	Tue,  1 Nov 2022 19:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667331296;
	bh=oShCEF9NRJjAE4n2W3q/l/9oZevZoQxX1cMXOGY3qCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuC8fGkhgnOThnLRdVt4mBn+bFGEEs7eDPT8M6m3URhNMdUCisQy1h2PzUnzugTeL
	 kqGBa3tR7ME8q25XRJFZf2xB02EZUsYRNcTGpMCaykCpvscj4ra3dhc3oNJZ2sO5ad
	 RYp6G4Lu32H10G8p67uToeSpY/S1BWrji2YaJswZtSYQI7xs2nmvtI4afuk9Z2HiMB
	 YBH88PEtl3LsGt8PT02gqZPFbthNj73a/AKgpn+KZO1Yx7duTrBdBxTWO+VUMcicYb
	 OBwaPrAJVl8D/jWHfEzHFW2MR/r0RbihuQ68cqLhSuO4kfWdvPxLoE6klRcRtqSsj9
	 tnX/h0ssQqHkA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1opx2D-0033dw-No;
	Tue, 01 Nov 2022 19:34:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Peter Maydell <peter.maydell@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Richard Henderson <richard.henderson@linaro.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: (subset) [PATCH v2 0/2] arm64/sme: Fix SMPRI_EL1 traps for KVM guests
Date: Tue,  1 Nov 2022 19:34:50 +0000
Message-Id: <166733126046.2105693.11092530869480090538.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221101112716.52035-1-broonie@kernel.org>
References: <20221101112716.52035-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: will@kernel.org, broonie@kernel.org, catalin.marinas@arm.com, alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org, oliver.upton@linux.dev, richard.henderson@linaro.org, vdonnefort@google.com, james.morse@arm.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 1 Nov 2022 11:27:13 +0000, Mark Brown wrote:
> When adding support for SME I missed management of traps for SMPRI_EL1
> in KVM guests, and also the need to manage TPIDR2_EL0 fine grained traps
> for EL1.  This series adds that management, and also updates the
> documentation to help avoid such issues in future.
> 
> This was noticed due to Vincent Donnefort noticing that qemu has
> implemented support for SME virtualisation but not fine grained traps
> which was causing problems for qemu in nVHE mode since that already used
> fine grained traps with SME, the FGT registers are not implemented and
> UNDEF.  As a result of this change VHE will also be affected so a
> separate series "KVM: arm: Refuse to enable KVM on systems with SME but
> not FGT" has been sent which will ensure we don't run on such systems
> though initial review suggests that this will likely be treated as a
> qemu documentation issue.
> 
> [...]

Applied to fixes, thanks!

[1/2] arm64: booting: Document our requirements for fine grained traps with SME
      commit: be0ddf5293a7895a8c9096e1a8560930c6a0ab3f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


