Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794952650;
	b=o9j358al1X+U3AdaFFmU6z/JuQS2lbbo6Ov1WIH+9Fc3Jera/RUeNgTn+DVWi12BaUYF
	 iVkKeOBWZ4ZTlJ5vntRFC3IYX6k/PTAEHndeHteFDbB2a/E0SXjjebnwxN78I9JVOFyL+
	 LuzHQMsKbvmP8zlcHjNQ2h8tsQRiOyyY2G62QmOgMKhfSA0no12FkvYipOitEEiSqlva9
	 w8pqFgjabOrZ3dkBOKozFP21tSngsjkRB8OJj0cLXIo0mIAqcYZ51tlXY5Jab0TxDf0TI
	 QPTA9TihLgJf2fdq1f/beKLWXxNVICCHtgFc3sS7G/J/T9UT1OOOCLKXxji6C4PWZEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794952650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=G7fFQmfgHuogWXnk7uusOnYOFKT4PPiSKrHtauxGcgU=;
	b=DtmzKPf7Jo7n4l5peQFY+tbpvJs+V9C/qYBOhYOmi2g5MlPOiPXtEtvTFhsWICItQsgd
	 6G3WLYYkILs4Qy7V5SBdFdYvchzQVL1zwyNElZWLQIisyuwO2CqKbVs03p5yjIfzsgNGH
	 iEz+3BZniBX37KYnY4YB6iLlJvdhc0Qh1i/Im78xzTCY8X6IBZ9Ub/mGaND+ya3csgI+D
	 0Xed9mFsa6EyGkUEP2Qs+JX7p8ZOQ29fQQRgt4mAPOg0C0lPAxMozvD6qNTBZEk4ffMby
	 QayL6r0xspc/wRcHpyLVlNVoamITspPGW+6UGOtsuXlINVYPKAaQxMUc0c/mgjR6JJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NvT6kx1R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3230606A335
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 21:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NvT6kx1R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09E31F000CA;
	Tue, 17 Nov 2026 21:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794952649;
	bh=G7fFQmfgHuogWXnk7uusOnYOFKT4PPiSKrHtauxGcgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvT6kx1R4/h5ELnoUZUl8+FEI4Jxg2pLq0917OQ8veuts2f04xapDsdcb2qp/UAfI
	 LSR71X7xulWsRvaGEOkL/gq2c93Wjw3DtkBvKE/DQ//K24kWs3uG2vv/3zztCsXJ9X
	 0yKkkdy0yRD5SPrGFkjwB3lFIJn0V+d7nypQF6eN+/MH/iBUzc6pk7yTjnRbUK3XCh
	 j/Bs7C3+KiVlnmuaGqbp5j7sNw3/hy5y91cbsgxORug7D0/DxNG2YEvCDNbX+7HZhD
	 UMRExhDtVFEVmRQ62ax3c3/ZcO9MpD6xpUpSlNWjSVYvgRpoY2VMBau5c1mD8qZhPC
	 2NHYrzWud4Umw==
From: Oliver Upton <oupton@kernel.org>
To: maz@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Vincent Donnefort <vdonnefort@google.com>
Cc: Oliver Upton <oupton@kernel.org>,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kernel-team@android.com,
	fuad.tabba@linux.dev
Subject: Re: [PATCH v2] KVM: arm64: Fast fail transparent_hugepage_adjust() for non-PMD folios
Date: Tue, 17 Nov 2026 13:57:25 -0800
Message-ID: <179495264132.1456871.3041044552825325460.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112113729.2858513-1-vdonnefort@google.com>
References: <20261112113729.2858513-1-vdonnefort@google.com>
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

On Thu, 12 Nov 2026 11:37:29 +0000, Vincent Donnefort wrote:
> transparent_hugepage_adjust() must walk the userspace stage-1 to detect
> if a PMD-level mapping is installed and whether a stage-2 block mapping
> can be used. Even though this stage-1 walk is most likely cache hot
> (in most cases, the mapping has just been installed), walking a
> page-table is still costly.
> 
> While we can't be sure by solely looking at the folio if the stage-1 is
> a block mapping as userspace has multiple ways to split it, we can infer
> from its size if the stage-1 mapping is smaller than PMD_SIZE. Anonymous
> memory or memfd faults allocate a big enough folio, as do khugepaged or
> MADV_COLLAPSE.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Fast fail transparent_hugepage_adjust() for non-PMD folios
      https://git.kernel.org/kvmarm/kvmarm/c/9da9b26ce1ac

--
Best,
Oliver
