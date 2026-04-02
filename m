Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C25A3A5431
	for <kvmarm@lists.linux.dev>; Thu,  2 Apr 2026 21:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775164449; cv=none; b=mV3SA1rKGe2q/j1EFf7iMJ1y6CIrzC7gW88osTrXRfPWp8Avm1dx+Pljyl9KB8l8VNSHcN6BeoGjBBYdwbxVyQQf5V44nL2NeLjXJqgu6s4dSyTvbT5L+TijAMTvXJtwi7WKHeQf3NBvfSELcR9qW+3Dj81ZpaJdtSzx9ox0RDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775164449; c=relaxed/simple;
	bh=I9dw14O86cZwkKMn5PUe2owUIFbxPW/XNrvSe558xsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pzVcr5WYGiNIxTVexl1/SRSq5hcBuikoJkVKH3mPPUB2cDTfrWTr5qtBDNbaNeXpaYvZZLwJSRQcklODC7yndT30h8CQQ/JHoPAD4+o0JBLcro2gjOhrPy3v0PdaStwtWqfOSc+RXu1thVoIJBLLAZVvfxbC4y72eN9eEjWqR3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NUdab221; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NUdab221"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8A4D19F6;
	Thu,  2 Apr 2026 14:14:01 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17AE13F7D8;
	Thu,  2 Apr 2026 14:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775164447; bh=I9dw14O86cZwkKMn5PUe2owUIFbxPW/XNrvSe558xsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NUdab221kb6KYuy9thKc6lr0wavgu6G0BdzLcaJyX/ORI0eU/ChjYSG6lxDSuHXA8
	 fHN5vDTYyvgPT+hoq8NrZKJ4GHDaxtuDhSl3FE2itE/3xEMa6nHaegoCLnHUkSowYl
	 xJOQDb+Epa+QlgYWE+3FczNfLY849JDaZPWkjQBQ=
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Mark Brown <broonie@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: (subset) [PATCH v10 00/30] KVM: arm64: Implement support for SME
Date: Thu,  2 Apr 2026 22:12:18 +0100
Message-ID: <177516433892.97388.575450953513622752.b4-ty@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 06 Mar 2026 17:00:52 +0000, Mark Brown wrote:
> I've removed the RFC tag from this version of the series, but the items
> that I'm looking for feedback on remains the same:
> 
>  - The userspace ABI, in particular:
>   - The vector length used for the SVE registers, access to the SVE
>     registers and access to ZA and (if available) ZT0 depending on
>     the current state of PSTATE.{SM,ZA}.
>   - The use of a single finalisation for both SVE and SME.
> 
> [...]

Applied to arm64 (for-next/sysreg), thanks!

[01/30] arm64/sysreg: Update SMIDR_EL1 to DDI0601 2025-06
        https://git.kernel.org/arm64/c/85b6f920a869

I looked to add more core arch patches but they all look like
preparation for subsequent KVM support. If the subsequent patches will
have to change following review, I couldn't figure out whether the first
3-4 patches in this series will remain the same.

-- 
Catalin
