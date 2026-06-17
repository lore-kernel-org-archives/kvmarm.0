Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F634376494;
	Wed, 17 Jun 2026 17:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781718208; cv=none; b=naw5HLpqzxKGaRRjie5osQ+zVVtmObhjwmlPCYS6hSJbi/eb1HIZfH7RTATQF6MhM+8FHtllPRj8w+NoKSKngxAnmta7AOAxEAuD9wgjBklbJneMcs8yC81zl4mJWnrlW0DYWG3WECFXW2PZVirTglg0szdWesU0sAzSpRqO+HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781718208; c=relaxed/simple;
	bh=qOBpmKkB/hOCfkK0Z2QdoL15T3nuglbGF8V9dMgnnYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=brWBFjj8pstTFKl38kx1FmiZZROui5IsVClt4zJAsl+f8MtI/BvCc3xTrQfov89YXveoffWqsrwjzTrSavkd9nui8TY0Z2IF8Cvtkf/AimryZ3cG990H3AdJpvCyDMglILPhS0ktpqaVaaDX3hfQUnNLvKdLVeqtGGeP5bA3KTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VeSGAYYY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VeSGAYYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3118E1F000E9;
	Wed, 17 Jun 2026 17:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781718207;
	bh=lZ7H8QpSLKtlrs3aJ59J9ZliAuUMrSHycmz8Pt9ipY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VeSGAYYYxL2RZiet8lQGPQSHevyLmzs9/2lP3L/FLjRbj9m/NKJTKwa0pPzQmQ5DU
	 BAGmGpBI75ctCNoYAXZiIVVVaQ8rT1Qll5LwJHou2HOWA/keQTpyeNPdWbPZbJ3yp6
	 FQtk4hkdKLZ0O15Qn1wLTaC3NU/zG4Yci7hx0oe24bw9R3jFA9IYlog+TSTilMz4eG
	 UdTobY/ZYH5FkjFsZfjjp7k5kTMGqxirFQNUe/97j+wHQj9lA9xXelB5nJf4myXMnQ
	 /n/R2rlitGD4kTHiHmCe/+eWmCv7gSuRM0Ayf5oMv43ps91RvifSdeL4AFrXM6H45H
	 FNRu6g34AbjeQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wZuIP-0000000Dlun-1ahg;
	Wed, 17 Jun 2026 17:43:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Add Fuad Tabba as a reviewer
Date: Wed, 17 Jun 2026 18:43:20 +0100
Message-ID: <178171819812.3090852.2907545296309805581.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617131237.2842619-1-tabba@google.com>
References: <20260617131237.2842619-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, tabba@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 17 Jun 2026 14:12:36 +0100, Fuad Tabba wrote:
> I have been working on KVM/arm64 for a couple of years, mostly on
> pKVM, and am currently upstreaming protected guest support, with more
> to come later. I already review KVM/arm64 patches more broadly, and
> am happy to continue doing so in an official capacity.
> 
> Add myself to the KVM/arm64 reviewer list.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Add Fuad Tabba as a reviewer
      commit: fcda30b134d262a1b1826555352bd7349051486e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


