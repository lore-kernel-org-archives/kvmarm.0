Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3528A3BF68F;
	Sun, 27 Sep 2026 16:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790526911; cv=none; b=CJdY1uq2uMy1NyB1fCD2sQQ4ZnV3dz7sOIPO/tziB/BmfDvSPFTVb2mhxL8eDD+H0cjLQqHzrVOswqTBempV3siuumopBSTiW53K5ad/E0m3O/7EzB2s68KtLRNI+70M8nMHhHXjZYBfeAQXndDcsUxCZ/EkJfLE72Fj7Gk62Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790526911; c=relaxed/simple;
	bh=eOWrkJHSt+NiEPARVQRnbswzc8cM5mhNb/mu2flfBnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=meiIw+gk3k852X3HzxQ5DhpGaj+b/mSnvogVGo0IC6c/RK6yvZAZ52hoqRAa92VJFEGc3TIlRViMQqYOQygkdbRFO2RRdDiMCvUVDYVCMQhgA/MZlbGl+CZEBt8ypSeXbGw3tVeajmhc2nTjNycP5wg5A4AscW20+aYzZ5yBauQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RcA3jvfg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RcA3jvfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2001F000FF;
	Sun, 27 Sep 2026 16:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790526908;
	bh=RujpUbO0P+3HoDW6lFgN2NaCd44XmjPJC5yHMUlOFrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RcA3jvfgqnPMNyRGlqN0CgN02mPLov1sw6eJux27LWTLQwbXs7AkfDKsDMEBikvPx
	 ptoQbXFsHQTinml1srSBUafLUmTNBSIgrpC7JHWPwUFDRe6yC1foPjSI9FI/Wu4VCF
	 7GX364aXDAXiURlsz/9UT46fEoGOsuUTDZSZrcOMHvRnJxOt59PHl3bLW0XqJ1nNqT
	 QsxoYsBEmIGVkiXNwZm70kZBYoHX1DmAfQzpm+UKRAf+Ha7XThjOfsVPo1FMjKSAHz
	 /MVUb7+iMkciuDM8ZjR8wou1Qog3P9E6DL7VPANVpfdXr/XjTNaj2oqLJVUgtXbOAI
	 gcuJb6EQ3yYCQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xArqE-0000000E2Sa-3OLw;
	Sun, 27 Sep 2026 16:35:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Report SMCCC_VERSION and SMCCC_ARCH_FEATURES as implemented
Date: Sun, 27 Sep 2026 17:35:03 +0100
Message-ID: <179052685156.3528802.11780401181301860028.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914125827.1645980-1-fuad.tabba@linux.dev>
References: <20260914125827.1645980-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 14 Sep 2026 13:58:26 +0100, Fuad Tabba wrote:
> KVM reports SMCCC v1.1 to guests, which makes SMCCC_VERSION and
> SMCCC_ARCH_FEATURES mandatory, and DEN0028H 7.3.6 requires
> SMCCC_ARCH_FEATURES to return SUCCESS for both function ids: "This
> function must return SUCCESS when arch_func_id is the SMCCC_VERSION or
> SMCCC_ARCH_FEATURES function id." With arch_func_id set to either, KVM's
> guest handler returns NOT_SUPPORTED. Return SUCCESS.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Report SMCCC_VERSION and SMCCC_ARCH_FEATURES as implemented
      commit: 7ef1b9e11dd7b3832124e26a6fee703b342d6f7f
[2/2] KVM: arm64: selftests: Check the mandatory SMCCC_ARCH_FEATURES queries
      commit: 67d00fcc00761e9fe4debeac781eb4f992dd8506

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


