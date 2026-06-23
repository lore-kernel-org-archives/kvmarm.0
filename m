Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D0D37F74C;
	Tue, 23 Jun 2026 13:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782222797; cv=none; b=Th3BI/zGFvwNZL+JRVjJdaZHlSRALFKYZGhL/+DZVIdSWWJYSJw86NYZBSb7EutPfXg3+XBqvW5OwfJwPvH9tLDnclDxhRdE2QFnuOuliI4DhkVc/1pY00VN6BuFVT5BYN/635cbLtzKO9wu/UsOB1iCPrytuuQHZUHBQMyzgKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782222797; c=relaxed/simple;
	bh=4XXy0sF9aIBWyimYy41pwrNPwQkqwOQAzr2BTSFEAlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omgw1PBXjikmhflx+ScuI54BMEnN7NWO53QzNMGg2u/R/i3FJAy+EuSYIpl4HkQNfGeQhRi3+doz6Feg+GaGMD4LlfoshC518Cw4gDphqgRjbCTUN0viISMTasJCuB0l4WzrHhSMHZgSOExKfDZvplzyHvH+2yxL4elTo6Fywis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hz4o+8P5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hz4o+8P5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98421F000E9;
	Tue, 23 Jun 2026 13:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782222796;
	bh=qZG8O0FTKMGqPVn5P9rMKTqMAVjS5M0CRnVpJwaU138=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hz4o+8P53m6+5g1JZ/3AuhJv/7iMNsCH85Zb4nEg1DjSbRjCU0fShKQUk4cBkcy6W
	 wd0HNKQCA+qW6koNGTgXcZORbcdJShW2eVUyZCD9FVUKiMU0T1VP2ko9ZGJw68zyKt
	 628nJfgWvilWdw2QOK9DOOuFVBUR0ez4PapBv3aFomirgVJeuczRlp3SmO+WSiW29k
	 zcMTFaECteLYPl3KfIeFxV2nF545OPIIHq8wGOineeggkXP8lx4O03+p61eRaw2yeY
	 pgm9HOW91sEHQ5qaZ5RvWlo8+RZooUXFjH6haJb42nV1QDfGcSOY+69GkniSoruJuP
	 Bqt9Cl7Voe5cA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wc1Yw-0000000FJ27-043g;
	Tue, 23 Jun 2026 13:53:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Bradley Morgan <include@grrlz.net>
Cc: Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: account pKVM reclaim against the VM mm
Date: Tue, 23 Jun 2026 14:53:11 +0100
Message-ID: <178222278590.523236.18181071715501850418.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621213155.6019-1-include@grrlz.net>
References: <20260621213155.6019-1-include@grrlz.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, include@grrlz.net, tabba@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sun, 21 Jun 2026 21:31:55 +0000, Bradley Morgan wrote:
> Protected guest faults charge long term pins to the VM's mm. Teardown
> can run later from file release, where current->mm may be unrelated.
> 
> Drop the charge from kvm->mm instead.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: account pKVM reclaim against the VM mm
      commit: d098bb75d14fde2f12155f1a95ec0168160867ce

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


