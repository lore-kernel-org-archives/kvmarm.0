Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711182;
	b=F/Wj4xZ0qRQltI8Q0x7P409DM/rmaRuYQSNw2GzNnuZZOzdOiz6V3XMIAJaIVvSz5yf/
	 OhBTahbxHHzzSEfw8sfg7b3xFvwZYCkLjFW/xfGE8QjMvB87eeN+fTxdV95qHfOcFxrsE
	 PnJJXmbC1IqmDvTQfXvgHs3ed4aIONIRglYBC/oaGRkOKBeccRrV9DQ6Yc/hjq7m9qRkj
	 3hHFvo6TiY6QNeLLlpAwB3tX6gFX6L94vTa7YdQM+B1mew8yH6Zp0xLCXeaVFN5kVIX0M
	 hDODzs8SagNItkgsMBvYX+2sDwsWQXf794K7HZTkI/pCP/LG3A11wfhZlZlL2o22oGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711182;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=3JuamxyQxu19gK7K2J52HPeF5X4ClmNvTcYsIkXxa2k=;
	b=fWkkrWT7z3BTKl0C+72RtxLSiJySk2rdvzm+o5gloZMVhPv/vm+g4LschuEO2I+xi+/N
	 CxhYObQkGDNkKdGeRQjs5M3yN8ge9HVPr3t+P56cxgsU2fxpfRuCnminiiAiQkc6uhgH5
	 xKBkVc8kmuyBjj2cwrGZpo0aNxs9PnvpnU2Sb9D4lBWZTPYefsLaoBzmsN0LSt3aRt2K9
	 tlhqswalEbfjcZwKQWlstqZ2SNmcWj5ahe03G/qPPBWzuhmGvScRhI+4pE282LnzZpWSe
	 gxbCzhEwwrx0P1IVNrjlnIqsw/TLl0uz44AJPxCI4P3r2FtXkaGEoiSTzdKTcAOFekA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hJoBEkHT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA00606D836;
	Tue,  3 Nov 2026 13:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hJoBEkHT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5681F00A1F;
	Tue,  3 Nov 2026 13:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711181;
	bh=3JuamxyQxu19gK7K2J52HPeF5X4ClmNvTcYsIkXxa2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJoBEkHTLsJStAeM4+S5tYAwvoyqBQk/y8VWaGYAidfKCHGr/Er+/AN4+pmUToqai
	 buDGt/2W5ShglYzroYSpXWAfO9sWuFYCn8kDkk58Mbl3IMXJH2tohTexX4CbpQaB55
	 DBju+3Rrihd/cDvoVcmDwUmvz4zdSIAQYU87R+WCp7b0G31pp8N2eFNI2RtdL/QYTS
	 uAdxFl8xXQ9KSS+hPHitsl/nhnitJ8MCjT4tylohr4Bv340tCb3HnabAzJsSd/Crj7
	 8bmoRQaE+qWn8oUVBHzNKbOwD54OT67y3zOxG6903poq1YuWjG+mxw0LNJg3Ey6ok5
	 tDvPUc6VpezDA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEDU-0000000ATWs-0ifC;
	Tue, 03 Nov 2026 13:06:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Matthias Goergens <matthias.goergens@gmail.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org
Subject: Re: [PATCH v2] Documentation/process: Add a maintainer entry profile for KVM/arm64
Date: Tue,  3 Nov 2026 13:05:40 +0000
Message-ID: <179371111286.2844725.14445338385718888809.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261030083351.3040604-1-matthias.goergens@gmail.com>
References: <20261030083351.3040604-1-matthias.goergens@gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, matthias.goergens@gmail.com, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, corbet@lwn.net, skhan@linuxfoundation.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, rdunlap@infradead.org, linux-kernel@vger.kernel.org, workflows@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 30 Oct 2026 16:33:51 +0800, Matthias Goergens wrote:
> KVM/arm64 has no P: entry in MAINTAINERS, so nothing tells a contributor
> that the kvmarm tree is used for integration only, or what the
> maintainers expect patches to be based on.  Marc Zyngier said a profile
> would help.
> 
> Add one covering the trees, the base for patches, the submit checklist,
> key cycle dates and review cadence, and point the KVM/arm64 entry at it.
> 
> [...]

Applied to fixes, thanks!

[1/1] Documentation/process: Add a maintainer entry profile for KVM/arm64
      commit: 0e086eebb3f38c392789dde6f0731f6555d793c5

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


