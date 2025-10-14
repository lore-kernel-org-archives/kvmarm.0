Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9AE219A8A
	for <kvmarm@lists.linux.dev>; Tue, 14 Oct 2025 08:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760431767; cv=none; b=kjm2bze5axwE3G8kDCc3aJPXQRYDEe5lGyoOAXK33TkAv4MkdJEA7bQf7GTImzi56W1stfhbQDxQYTtUUzrxw5nkFfieiygMhfA9e++VDt8yezAZysAB/VBiEMOaEI+nks5mhnU4dapHnAXr4Hnji/Wc4AeWxVLCzCXBrb+HriE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760431767; c=relaxed/simple;
	bh=C7JuaamqYjTY8yKNBk8DAaYNefNASMvcLoZIKSBAuJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f312lz3DAK55FW7n37MBi5bGq/UsHbLUinaLC87ALb8YiuX74M3wTBNtimZOHBYdnhw8GyqAA5rZk936jUY2rL8+7adfmcqXmBvBoBBLs7JNoQlO991vI6OOYLZgzrLif+uzmYt3eoEVMR4zbd9en8CC2dtvD9+hSG/A69mqAMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PLqbpLL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PLqbpLL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF8DC4CEF9;
	Tue, 14 Oct 2025 08:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760431766;
	bh=C7JuaamqYjTY8yKNBk8DAaYNefNASMvcLoZIKSBAuJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLqbpLL1+Oo1r/vYSggD+Gynz+O1HTnN3Ih9MriG3qxEBLKsfdJJ4YpwUiF4m7fzs
	 5ukz4smjDbUyHkGXfQGCg/mNL7AvE74QgnpsDidNa2YbM/ygwNuunF0OB2Je3tHEBn
	 O+WOimzFFYMKdcDYTC7YFX2ajKyn2Rswue4pcWxWgOvjaFPgk5PjaxL4W7nPck3hUs
	 TFbZoa4LKe8DLGtnrwntVo7EJByt1La91uB7pPTljp4zR5k1ehOoLNTcoy+eBzH5yI
	 fxB1o5SrAczaPGjIgISdKP+kdqp8Csr8ifmjh7KXWO1HEAf8Rddz27iIFp6gk5G5JN
	 K9MVoU9KZAVVQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v8aii-0000000Dms5-1mLR;
	Tue, 14 Oct 2025 08:49:24 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Jan Kotas <jank@cadence.com>
Subject: Re: [PATCH] arm64: Revamp HCR_EL2.E2H RES1 detection
Date: Tue, 14 Oct 2025 09:49:20 +0100
Message-ID: <176043175100.977560.12584294473093983228.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251009121239.29370-1-maz@kernel.org>
References: <20251009121239.29370-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, jank@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 09 Oct 2025 13:12:39 +0100, Marc Zyngier wrote:
> We currently have two ways to identify CPUs that only implement FEAT_VHE
> and not FEAT_E2H0:
> 
> - either they advertise it via ID_AA64MMFR4_EL1.E2H0,
> - or the HCR_EL2.E2H bit is RAO/WI
> 
> However, there is a third category of "cpus" that fall between these
> two cases: on CPUs that do not implement FEAT_FGT, it is IMPDEF whether
> an access to ID_AA64MMFR4_EL1 can trap to EL2 when the register value
> is zero.
> 
> [...]

Applied to fixes, thanks!

[1/1] arm64: Revamp HCR_EL2.E2H RES1 detection
      commit: ca88ecdce5f51874a7c151809bd2c936ee0d3805

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


