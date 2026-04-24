Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5469539E194;
	Fri, 24 Apr 2026 11:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777028885; cv=none; b=D0ul7GjiOX1MKrY4izP+d7CKmV6aQUC7xKZthYrXkuWcrZl5Qzcy1VWs/nDwE/e2YdOiza2sIbOD0Ysx1ucasHX8cR/I/zvonFFYotQgE0SdDIIIRBi1N2SJ6alBFnnWNuvzGnwykPfO3rPFTEpUyGV73STkC8xBzBzv5xxiyXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777028885; c=relaxed/simple;
	bh=EhTixBg2942FDflTxtXBYV+26rSI2mTgBToDUlR3aI0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ETf81DYbWwR1JSEtajdDipyGDFt/IF9dJvu1m613i6oJ7G4Ky2WXk9DnF0fqTXJZ7CdCSQ1IvmGqQg4Jl6Z1eeNBAYQec7HqfzPI5KHozoHOU5AAh8+V1IBrMhvasIVuNDMCE+G7mI3BXKJSHpPtNljkb4tjDP3qwPg2VsvFT+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gyLsioWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gyLsioWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD78C19425;
	Fri, 24 Apr 2026 11:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777028885;
	bh=EhTixBg2942FDflTxtXBYV+26rSI2mTgBToDUlR3aI0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gyLsioWS5UkEU/oiFMqlSXoZ/KEgJoWh5e1lbm7vRt1m8h6wiureytQh1/CpEvSjq
	 UxYGnWQlFTW3mpCio70n3eisrCnXOjs9UcarC1eTY0DtkXTwmgPpz8IrTn4hV06pOq
	 Nhe8Im1geRV7iqZx1OZbwwMuZbjRHEXWPC3gcvgvFTcHd+WCZ2661lb1CvJdbc5cSh
	 l4u9acMIVyDT8UTSUlkAenrMYOPEMvlYSJ4k+ItlgAV8gj9DIIsQKExGrfLly9ut9t
	 2CUBWlTveBbgoXYbuPugjG/kozw652T0pt3Xhm5ECHSQeOKhA9IOAR298hZo380dfN
	 VWSNRF7Vk687g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wGEOA-0000000ELuP-12bL;
	Fri, 24 Apr 2026 11:08:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>
Subject: Re: (subset) [PATCH 1/3] KVM: arm64: vgic: Fix IIDR revision field extracted from wrong value
Date: Fri, 24 Apr 2026 12:07:57 +0100
Message-ID: <177702878141.537738.13460155220731277452.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407210949.2076251-2-dwmw2@infradead.org>
References: <20260407210949.2076251-1-dwmw2@infradead.org> <20260407210949.2076251-2-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, shuah@kernel.org, dwmw@amazon.co.uk, rananta@google.com, eric.auger@redhat.com, kees@kernel.org, arnd@arndb.de, nathan@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 07 Apr 2026 21:27:02 +0100, David Woodhouse wrote:
> The uaccess write handlers for GICD_IIDR in both GICv2 and GICv3
> extract the revision field from 'reg' (the current IIDR value read back
> from the emulated distributor) instead of 'val' (the value userspace is
> trying to write). This means userspace can never actually change the
> implementation revision — the extracted value is always the current one.
> 
> Fix the FIELD_GET to use 'val' so that userspace can select a different
> revision for migration compatibility.
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: vgic: Fix IIDR revision field extracted from wrong value
      commit: a0e6ae45af17e8b27958830595799c702ffbab8d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


