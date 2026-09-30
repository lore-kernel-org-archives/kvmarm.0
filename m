Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3156446C00;
	Wed, 30 Sep 2026 08:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790757154; cv=none; b=J4qAU0nRcKun+7vvIKHVkW0q2b1F3ZWDKNU4UjWFfrNQ+cf+PcA9TYo+LdpIAnvY/IhdU6tNqL6h0SAjwKeU41UVXq8cp+1L/+MSqAchzKIOsaKr5Rx+Otxe/gTYmMbvF9eTPUx4V+BRwf/3n2w0kfAUYO4fWxgr4v6Y2sipKd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790757154; c=relaxed/simple;
	bh=RqeMRAnSUPQdC/xknqu0oC5DvSQ+nhy0gLGCurP7J0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U4z4CnEoyfAVPszjxOvBZcNxY1KwPWTyDhoPWuvkBsVftx61hibcdW8Vcps8JItFxYveH/DxUSJ3e8sywY1w7cuGVYJmSr5PBV80XilLHcE3rRWab/MaeavQnd1Yi21AFuOLJibRfddIoRG2bmNq/dHT0rBwPBhtrDB6qHuXUrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a9UMJIgS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a9UMJIgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7AD1F000FF;
	Wed, 30 Sep 2026 08:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790757141;
	bh=7GEwGzPFR3eS1g4eqL+386ChUqhdJX3OYn9ry9qloeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9UMJIgSn7nz3T1pogOL3Cfpo86EZ2RED9JQHQgU8+VgWCWsOJmrPygYc40OJN9s4
	 /W3EfWS4qiDE82jGEjSox+WrPqhuKdmK4v4Mg+pxwpadNEzPoOCycgO0EWuG4ukdjI
	 VG6XznwyIbIQttpV+EO7sT4Tj7cmjIF0PCQ828yWjUMfTny+0LWqzVs90YoL/iZrA+
	 Do5Yhxt/StPDSHiJYMuloikvQb3xypTIZIi5JYg7lmsfOZhCfp/gFw8VoUS7Kxt3O4
	 ci3bakGuc4/WaEwoxJ8GmQttrizsFCye7oEYoh/HFhL9N5BD34T+pJsFLm0TtjCx+w
	 Ug7b1OIdsFqIA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xBpjf-0000000FDC2-38Va;
	Wed, 30 Sep 2026 08:32:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Mark Brown <broonie@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH v4 0/3] KVM: arm64: ID register finalisation fixes
Date: Wed, 30 Sep 2026 09:32:15 +0100
Message-ID: <179075713104.3615171.13350186839186516597.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929-kvm-arm64-idreg-final-v4-0-75296dde994d@kernel.org>
References: <20260929-kvm-arm64-idreg-final-v4-0-75296dde994d@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, fuad.tabba@linux.dev, broonie@kernel.org, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, ljs@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 29 Sep 2026 12:57:57 +0100, Mark Brown wrote:
> While looking at some feature enablement I noticed that there are some
> scenarios where we can end up with an inconsistently configured vCPU due
> to finalizing configuration based on ID registers before we have blocked
> writes to the ID registers. This series aims to clean up these issues.

Applied to next, thanks!

[1/3] KVM: arm64: Finalize guest-wide sysregs prior to per-vCPU sysregs
      commit: 19868b67e3e73c34493efdd5b0791ccfdc7bf192
[2/3] KVM: arm64: Block ID register changes after we rely on the values
      commit: 2ce80f62403200f0a59f898dd9cd2ccf756a5a1a
[3/3] KVM: arm64: selftests: Check ID regs are immutable after a failed run
      commit: 00e309933879cbf181a95a0bd02384715a381cff

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


