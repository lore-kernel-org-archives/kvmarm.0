Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F6417BCA;
	Tue, 15 Sep 2026 22:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789511146; cv=none; b=gu5Pzs/U6OWSWiJoAnaTt2S5s4EE5TWWfOAq0V3gCQZdSIrKKwjnr1nd8Zp6G994hls0+SqW/v9R9gprBV2+xz1yBewMrTdT5Fl04E/+MJBQD/i86lepHAMGb6YDK4dr8dllv3JAKLyHiViCKjHT+GQnUHHry1vRS6dyfq+PxBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789511146; c=relaxed/simple;
	bh=WmWs9jPf1QhIbh0wratZlEyglAqvOhfdXBCOK1ktGew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lCCAJtC3Kvxo+okshAbGQjefA1C5eUhjCEosP1ryELOAgujvJdZcXsWV5udW6bhdY6IdqB5tni1AgtKW1h8RZtJ3Q5+xhcWCanaoeqqYbuM8brhhubwj8bSrvFXzCtSyMlO8jONoaRMMIfaCoAt0aDhNw/4WnT+uzlB7k+LGm6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5IXNL+f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5IXNL+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC881F000FF;
	Tue, 15 Sep 2026 22:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789511145;
	bh=2kecQaR0F7g0/H9mop9k/ZA1PCRux2SHgqjXnuf3tgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5IXNL+fVFTtOFiiRyVTkNuytpziNyfhPeJrdEo9rSE5W+iLdKiE3IJQYf+PtFR2x
	 wTtpo6KRfyPuBDuWwyIB7v1BQAfmCl05JRLSWdlBCiZaDhMw3UucXQudZ3qG3tvEHW
	 rbPFfmhXJf2YcVEeeN/pggWtlHx9N64OBke0aa+ueA0xGpd5MP/L8Z8VME3U24tApq
	 TmPswHCzQD0LWELmWVs6W+hyy9+dKlpg08xPNt8/a4EorHlXr4r1aTMKNKrhKWVuPr
	 2+BB4KwfZNPp+HgbCIq/92kvRyWg/hMn3yeb7u0Ck3LVPGzLWjmyjUSggfDR4Eu3k2
	 z6n1C3Y21E0pQ==
From: Oliver Upton <oupton@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Leonardo Bras <leo.bras@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: (subset) [PATCH v20 02/14] KVM: arm64: Fix FGT mapping for HFGITR_EL2.nGCSEPP
Date: Tue, 15 Sep 2026 15:25:32 -0700
Message-ID: <178951103683.10790.7238421458148276106.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901-arm64-gcs-v20-2-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-2-f31750bdfadb@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 01 Sep 2026 22:47:00 +0100, Mark Brown wrote:
> The encoding to trap mapping currently maps a FGT on OP_GCSPOPX to
> HFGITR_EL2.nGCSEPP but as per DDI0601 2026-06 this FGT controls trapping
> of GCSPUSHX and GCSPOPCX, and not the separate GCSPOPX instruction.
> Update the mapping to reflect the architecture.
> 
> 

Applied to fixes, thanks!

[02/14] KVM: arm64: Fix FGT mapping for HFGITR_EL2.nGCSEPP
        https://git.kernel.org/kvmarm/kvmarm/c/089e4f3c4862

--
Best,
Oliver
