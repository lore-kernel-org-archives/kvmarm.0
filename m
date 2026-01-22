Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EC3236437
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 09:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769073070; cv=none; b=f8Ux/ZQGuiYaINdRHMvpFD4ww4uo09zFcPrsDcvJLKb+ZLNviDsiATL62i4V5hWYoaspuKE6s3jlKoASonaRzR+cdcSq0eTL8U1F9xiaLp7SPtD8CeZZZRlQ5U+URXEeGwut5iR5UbR3nhxI9IHORI2pQ6bsIvtrCf/RLkbIc6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769073070; c=relaxed/simple;
	bh=LFW90VWHJHnmtxUoM+a3yP6IR8eMMDNjSdMlhzJlmnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lWHc/CylY5S4wf8Cl6mINgEA0S2mhONUc97y42UjOVvy+Tf8j+qaId5K/WRo8qeP/SpWGptoEJYTfs4s4YvNqzCL3Ownt0hhf5KhpOHTnOQqgzvAVkDnIBfblL5gMiUuiGtKppTqnKNRJQFjVAVuQep15amhNnCS+6EnDvympHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eYUHP9Nc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eYUHP9Nc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A891C16AAE;
	Thu, 22 Jan 2026 09:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769073070;
	bh=LFW90VWHJHnmtxUoM+a3yP6IR8eMMDNjSdMlhzJlmnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYUHP9Ncnk0czUylGrVq34W4sQ/D7IQEbxX3lFNcK07HFU+/P66K09I5iXwhp/npo
	 aoMFUOJVQ0ayjKypW5RvEdqI6n1OCNUnjO/TxvoKQjVBLyuxnWfAnMyVRdsPp92r8m
	 hZ1jaJUCuEFW8oEu7yr41IM+T/OZ8hknrwoMRRuQJWQMGLpN8Pj746v4TUPyTm02cf
	 jM8ps15g6A9f9zyAQ1yck8CmomoXPzp/hM0S75bbz7EvASiiz63yO83QzNnCUXb0Hl
	 Tg/s5e44Be8OV2bjDdo+6OIUU4D9308id5Al3MqRCAOyQhN6rUAhb7E77h4Yz+6Ewy
	 r8CZvY/aepsUA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1viqia-00000004cWq-0JnX;
	Thu, 22 Jan 2026 09:11:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Always populate FGT masks at boot time
Date: Thu, 22 Jan 2026 09:11:05 +0000
Message-ID: <176907305595.536564.11529095810436212819.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260122085153.535538-1-maz@kernel.org>
References: <20260122085153.535538-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, nathan@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 22 Jan 2026 08:51:53 +0000, Marc Zyngier wrote:
> We currently only populate the FGT masks if the underlying HW does
> support FEAT_FGT. However, with the addition of the RES1 support for
> system registers, this results in a lot of noise at boot time, as
> reported by Nathan.
> 
> That's because even if FGT isn't supported, we still check for the
> attribution of the bits to particular features, and not keeping the
> masks up-to-date leads to (fairly harmess) warnings.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Always populate FGT masks at boot time
      commit: 54adbfe40e3b6d238293cc36ef071ed9f35c8af7

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


