Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E6A30BF68;
	Mon, 23 Feb 2026 16:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771864279; cv=none; b=p1bqyDon7YIG2Jmk2rU7MIoPPno9HMzZ4hED3C0YXQ/n41R0Q37LbvL9U71i4OcKpt4pKIhiHJVcePSdY7XGPIIImLOfznsheIomPvI+2bbfg8K3V8YUFoJAJJFhbUbKWYPSPcz7mbSFu+Zt+nQy8No8NCiL/AlQa8eq5rqA5H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771864279; c=relaxed/simple;
	bh=HbRaNni9Yhg7DH4GQw6rMyoMLa5GVOltpDIZsyjITfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DSNefCG0nME2o2gcpmKaoRB8wcHCrYNjrPWXJG3T3/M1Yh3JjJ+IFTh6ssozlzDRDEVsX8VnEeqPrqc2tNyLkg3mjeD0yepYEFbKKVUdaoguKtuIxTkwzVJFp2Jcyq5Ns79qlkOulCp8kS11pu49sCpMaPs+CnM/PhFlQzNQVEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=asRbb96U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="asRbb96U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B6BC116D0;
	Mon, 23 Feb 2026 16:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771864279;
	bh=HbRaNni9Yhg7DH4GQw6rMyoMLa5GVOltpDIZsyjITfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asRbb96Ua4NG0E2vTwwn45Mp+N9/NnVxIj7wsMXzdKSyCpQSpXNrE1hjQRNEAI/TW
	 +uQ15DGvP7pjJ9JP4GpSc4l/fOn8I+ViJ8zfCFf/IZDP8bz6g1pjf4hBGdyZTCe2Uy
	 J1WZYwB+h/CVA/uRUDJQN7Zjo885WSQuNSv2h+eSp206Bkq2q22CN/z/vgD3K+2Use
	 QPXH4sf5eYMzpFAd7g+mfzVovY7W2tmFhgFegDKY7mKDf3vQkoOh1BhOAwDQcjJN7J
	 tTJxZny0W0j3M4pwHUFgnwW/yGoX3FFGVBin/iWg/5yD8riSrmd0XbBZYml82QMQtc
	 07hViK1gOUM+w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vuYq5-0000000D3s7-0ASY;
	Mon, 23 Feb 2026 16:31:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix protected mode handling of pages larger than 4kB
Date: Mon, 23 Feb 2026 16:31:14 +0000
Message-ID: <177186426799.3533992.5872404007182314349.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260222141000.3084258-1-maz@kernel.org>
References: <20260222141000.3084258-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, qperret@google.com, will@kernel.org, tabba@google.com, vdonnefort@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sun, 22 Feb 2026 14:10:00 +0000, Marc Zyngier wrote:
> Since 3669ddd8fa8b5 ("KVM: arm64: Add a range to pkvm_mappings"),
> pKVM tracks the memory that has been mapped into a guest in a
> side data structure. Crucially, it uses it to find out whether
> a page has already been mapped, and therefore refuses to map it
> twice. So far, so good.
> 
> However, this very patch completely breaks non-4kB page support,
> with guests being unable to boot. The most obvious symptom is that
> we take the same fault repeatedly, and not making forward progress.
> A quick investigation shows that this is because of the above
> rejection code.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix protected mode handling of pages larger than 4kB
      commit: 08f97454b7fa39bfcf82524955c771d2d693d6fe

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


