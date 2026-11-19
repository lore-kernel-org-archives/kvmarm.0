Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795092225;
	b=w9oDZTLyWZ5VBopeQ9y6fAWjwt5uoma1VmtvTPOcC/7V/YYBi7Hlze25q6QUXn0FQo39
	 0YoOx31nB3nnC0DQu3t2prY+dDmoOHcIMeJvIyZYrFe4H5xudIoYc6Ar7fjcQYU+pwhYE
	 LzYKU3nFIm9/eXCXl9o0lQLM/f+GYJ5WGRpD2ntPBpmPeypm5teiJTMHmjg4QvKAfHbZO
	 DexgS5vG5Dfc3NvG2dSaBa/hJ/sMY5OWMXPIa9R71Sh9swI7EYmSwyaKOLjmDW153Q12D
	 xIZoxJpUS+OEehrCLT/4tIYJNwwvWRujnhBPutjyB/4OwvySajuy9Te4UFz2M2gOqVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795092225;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=zRjcGPEqo9GIymUz7E2xF35WQXytvmcIckbBFZO8Xxw=;
	b=QA+G4mmFMCRRh1UkfqP0QblceTgEMnFHA11tBkSxkq0n/q3ELdwNp2AXgE0RSDN/J51z
	 tfyo1TANKy1f0llBkI47KDhgiRSwBK3seLyt0+GzKVl/BKWyIfdOkpSrsjqOYXQBio1gn
	 G9uOuf3aZ7L0Ww2j64qtWtYuNRqtVDRpol6aCHGN7JCb9DpO2zMIXr++CYEe4ykYHfX46
	 sNHCxB+T7lqr9tUMA4/KNzIG9C0NmWwM3kNq5q5T/rmGrz+F09aFkNmaT0LrmeusVigZS
	 kJtjZKoByGL8nX5ksBGKSqhU0kS9HwysKq38TiwNKJCCw+4+55/Hh5XjHRWMB6UpD0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YEvLMjAR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237F5606A338;
	Thu, 19 Nov 2026 12:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YEvLMjAR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1161F000C5;
	Thu, 19 Nov 2026 12:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795092225;
	bh=zRjcGPEqo9GIymUz7E2xF35WQXytvmcIckbBFZO8Xxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YEvLMjARz7pZgG6OJf6NMedt4DnGUuMuuDMIrc/M7hLWYwW5rJtdw2LxdNcjLx3eg
	 hE97c56nSSt5csVIfTta3IIuDPTIO7PTdvFHccfs3Mf+Jf4/SVWo5toqn5gjG0yk2u
	 j5Ku3RVpNmLkGZNpoS1R/AIuyfC7iDtyxlZn2Zlqwy+fm0S8cLd+1Iq2gimc3pWbm+
	 6y42EfefS9ZlG3ctNAl17WOmgySjaX6awji9dz97/TmZl4NUcSjkxBoln7lAsbx+vB
	 N6wTrMOQU93cQMhHCS9jMFdCZeArzCQA1s4vOlTuGQEQY/hg2hHK3uQG+x5UiqjOCm
	 cAwzJuOdWN8vA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xU1UN-00000000RvW-1Iur;
	Thu, 19 Nov 2026 12:43:43 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: (subset) [PATCH v2 01/19] KVM: arm64: Hide generic ptrauth from protected VMs without ptrauth
Date: Thu, 19 Nov 2026 12:43:34 +0000
Message-ID: <179509215925.3938200.7140871147964039894.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109084854.840576-2-fuad.tabba@linux.dev>
References: <20261109084854.840576-2-fuad.tabba@linux.dev>
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
X-SA-Exim-Rcpt-To: oupton@kernel.org, fuad.tabba@linux.dev, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, pbonzini@redhat.com, seanjc@google.com, shuah@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, vdonnefort@google.com, qperret@google.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 09 Nov 2026 08:48:36 +0000, Fuad Tabba wrote:
> A protected VM without the ptrauth vCPU features shouldn't have pointer
> authentication in its ID registers. Commit 3d7ff00700d1 ("KVM: arm64:
> Rework specifying restricted features for protected VMs") gated APA,
> API, APA3 and GPA3 on vm_has_ptrauth(), but left GPA and GPI capped
> at IMP. So generic authentication is advertised to a protected guest
> without ptrauth, and PACGA UNDEFs.
> 
> [...]

Applied to fixes, thanks!

[01/19] KVM: arm64: Hide generic ptrauth from protected VMs without ptrauth
        commit: 50e9e6b6eb3d9b2c318babce60abdf3b300cfb35

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


