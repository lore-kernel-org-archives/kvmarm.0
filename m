Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261DB49158C;
	Wed,  7 Oct 2026 12:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791374927; cv=none; b=c+Fkvjz8P1Ci9DWys72Rjq7hKH62jUa5NcSF0Gepj/8ZTGm3Dahu5McuqKiRZlw/Hmt/9K9wFDHpRk7hvd4V4NHUAQDBlUEajhdfWV9dps29pO2N5QwMsi/9gWRdeMSe0Lqn0u2Q4t5oUVpmYOj8NzoqzLHIg83dBezbGa0pKYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791374927; c=relaxed/simple;
	bh=n6O2tTMXptdBxyvW61b5jo40KgT3use+/BoCKR1n1Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IJmLJsFYF9qleWN+VFvNfqA4PaU2RbbvX5VHPv95Mhc41g6aSvwSC1uV+fogY0XyQLzGhC1BM/X2/M9EfmGg7+QsLLAhHbMD28NdixgHTti3ANqddZm9MFSdzU6XZzqZ6iT/1T1Z0TNx2Kewqumo70wFzcDJyf9ViBoyPishyu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJ8x+/dh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJ8x+/dh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46B51F0089C;
	Wed,  7 Oct 2026 12:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791374918;
	bh=eXYCbGv/F5Vt1j/YtSf4+kukmf2z4zJPoM7b8kguA9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BJ8x+/dhRv33KPE2HySL7S7CKpaUFP7Q8CmhydKnZ8PI0MWnayQVrgjG55RDsYIri
	 d7XiSYzE2OEanIGU5gVJAB3/Ncreo6UgL+nnXO3vwjElLRXnmhUsOTLij9gUnnTQY4
	 fGu9zB7evqlvtpHWam+/dGj9wWXe9v7+NIQEIxixPNbgE9FHvvTlF1iBkTPH2/d2zU
	 iiRo2ECbi1KE+Lj+T7wvqEhWoNxpxVK4+2rJaktSGlDF3tuA1wvrvyjpMOkrNqBC9n
	 vbROrCy0SUj+tPn3M7KBDLW/1H1tId2R+O7GBEIRXFbbwTmknTywAtuHj4IpMxbpzC
	 oqPgSODKrEtAg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xEQRo-00000000G5C-2nan;
	Wed, 07 Oct 2026 12:08:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3] KVM: arm64: Only emulate an SError's entry for vCPUs with NV
Date: Wed,  7 Oct 2026 13:08:34 +0100
Message-ID: <179137490041.698747.10587011555353009441.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261007080833.371899-1-fuad.tabba@linux.dev>
References: <20261007080833.371899-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, fuad.tabba@linux.dev, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, vdonnefort@google.com, qperret@google.com, mark.rutland@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 07 Oct 2026 09:08:33 +0100, Fuad Tabba wrote:
> kvm_inject_serror_esr() emulates an SError's exception entry when the
> host's copy of PSTATE says SErrors are unmasked, although only NV needs
> this, for a nested context whose guest hypervisor owns the vSError. A
> protected vCPU's PSTATE lives at EL2, and the VMM can unmask SErrors in
> the host's copy before the first run, so KVM emulates the entry on that
> copy and the guest never takes the SError.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Only emulate an SError's entry for vCPUs with NV
      commit: 3bd107ed6b23de45b861e7f0c151d7fba59d721a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


