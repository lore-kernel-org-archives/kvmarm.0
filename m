Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EC4424D72;
	Thu, 24 Sep 2026 20:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790282506; cv=none; b=g3kp+3aeA0apLEd0Ln4AVBA/b/73gnWgXcJvswklGKZTF055qHR7Rdi191bFZGAHjr1CqBpLhmVa1PEXd+XnkU2wrVEhD7+mEPOxxfsPGnJmZVZnVWNOSs9LSbHgYUOlv8XtphdyWOP1+mdCZiW8VVyvncIkFUy2xNiCujHpXfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790282506; c=relaxed/simple;
	bh=Sy48jdUbNk3M+wq4adZ7xWGjYCT26yfISv3LGif2Yck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mSoNIhFLvBVmIRgX3aQlkCh9gYprbOAPO+8acqZPg6qmBHzzUCwYqPAZLNyeFrQogAfaktvWgPaGF+hmJmLZKP3cThNrlMjqID+9kPvVYyKQ5Ika2twr9ZBz3uA/huzy3wwtCJRXJJMYeWjlwBC1KiTsHARtv+Izn3TWhHma0cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XWp0aJkE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XWp0aJkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F249C1F000FF;
	Thu, 24 Sep 2026 20:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790282505;
	bh=LrQRBYeuaf7bM5VgfiKLi/L2mfGazHWpQ69tMlYoN8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XWp0aJkEH9tKAO+pH5S1/zfH7gUvwStJwvtV3eRAkj6wI5UsEohSwMiuEehdHIU7e
	 hza7memeIIMWugFEhpgTWbYc6Ycre+zXLAirP3GQlWMHTbhhpkNoF2qOBxO+Kc0UiN
	 Nluq96Ic0Gt6CNZJlTDd+MGPWZX3G1UWnaIXSZ+kTr2ruNRVZGBFODwBv4sPNrhrns
	 yMMxGm9X3CsdxgcNKt8c2Mu0OuAaQzCjE5/e5v1q5JbQXOEFDWqpGidSZjEfYbTsME
	 nh+4ktuWxdLzEmsFDHjde37kE9e9Abn21BXyEXlmGq7qlPVK9lt7ZiCYyETVsi8wsT
	 HuwaoSduxe0VQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x9qGF-0000000DDHY-0WZd;
	Thu, 24 Sep 2026 20:41:43 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Wei-Lin Chang <weilin.chang@arm.com>
Cc: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>
Subject: Re: [PATCH v4 0/2] KVM: arm64: ptdump: Shadow ptdump fixes
Date: Thu, 24 Sep 2026 21:41:38 +0100
Message-ID: <179028246123.3395858.14855686686610426217.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260924094951.727352-1-weilin.chang@arm.com>
References: <20260924094951.727352-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, weilin.chang@arm.com, oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, sebastianene@google.com, vdonnefort@google.com, itaru.kitayama@fujitsu.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 24 Sep 2026 10:49:49 +0100, Wei-Lin Chang wrote:
> This is v4 of fixing the sleep-in-atomic problem of the shadow ptdump.
> This version relaxes a few write_lock to read_lock, and collected tags.
> Please see the details below.
> 
> * Changes from v3 [1]:
> 
>   - Take read_lock instead of write_lock when getting pgt metadata.
>     (Vincent)
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: ptdump: Check the page tables aren't freed when accessing
      commit: 7d7199bdf77a3a6ed74d0037133f435a7febe97c
[2/2] KVM: arm64: ptdump: Fix shadow ptdump sleep-in-atomic-context problem
      commit: b1cc219eb21ab5f31fe4caa32be8057159e42db5

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


