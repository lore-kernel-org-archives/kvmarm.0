Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793987890;
	b=m92Kb63zHb2UsLsSvRWtWmD0Bh419NPfcQg0YFwhOnyis7bXIy+PzY52Q5GuHzhF/3Dg
	 juMrKXs9EaZkXPm76+Qh9dQqlcwuk7Owt1WS2xV19+xu5hLT80XQkBPpoqHoBFr08vsI+
	 uluaCdhaaRRCMcH21lew+bWyKG+v9ux7H1e2fTxNxJ7AY2zqXdGaEw254w6FdhepIJlVa
	 UYzqN7aQ799SFzzuAXAD5MmAW7fbyLaOFBY8TbTb1yHBpM08oQshTuaWf184/25+/h+mC
	 r/EsXkvilp/Uh+Eg7HHfkRhwqUbeA6dzuF8ATtkJbGIk3q8IMTTet6r3NeoNdoFE1kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793987890;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=QgfTA5a+5MMLBq/A4jGpp86Ey0W49QUd8AMooz78Jz8=;
	b=YVu59rsDM+FcOkl+/hSbhlbmai87G0pkQhoIPeYmBeA0nxApF+Jg05OW30j+OLf+zUnO
	 C8Q7E98xpSk9MU65TkAqvCFif+TXIzKDyDdBHjcufkn2Uifh/xZcYDSsARoTyXaKWAU/g
	 3bfzpaKzPrDCxY7PYmFVKb03VrwzxS0dYWKkk77oNW+9PcNU5r0Yx6kzMAZZ2XtVGigVM
	 KPCUkw8HXdJ+JtCde3WrNdsd6WYO+WuX2A5/fm15n66yw56UdUOSUoPfahsF/PYexlvYZ
	 fj6RL/545eASxcq3Zao0gkd5ebCLUSm1yHi/jbf1YxARLSsG0ASpTrakUJqTGaC1QjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=FFVRjDo1;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDC7606A32C
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 17:58:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4CDC7606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=FFVRjDo1
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4ac95761c85so6767725e9.2
        for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 09:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793987889; x=1794592689; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QgfTA5a+5MMLBq/A4jGpp86Ey0W49QUd8AMooz78Jz8=;
        b=FFVRjDo1bW501UyVXo2qNSfV9a5MMyr+ymVgSOKluI70DiyPxJfjEBzHbI0C07kULC
         fLKUrDrwS4doGNS8BFuFzZm7dy0phGW8d1yez5HvZFHMZEmdG/16wCYICWzHOTT8MhPf
         aGn0i2mbbBOuG1ucZLDvWD7sYIg9p6QmsyHJIreJDMk3q+m8oMhw3xHCQmWYmD7nZfIl
         B1EXbwt/oIyW4CJhxjI4q8fPp8JDNd9vo+d86BBuNFK6TpEZPSmhdqrdHqVT0XFrPhup
         4WaMIEeA5nbeuu98mCMTzLkTvsn4qySrbC3LBlEEt5p9qD41iURlxcqMGqRq2Om4nmz3
         rGAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793987889; x=1794592689;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QgfTA5a+5MMLBq/A4jGpp86Ey0W49QUd8AMooz78Jz8=;
        b=G6oetO41RkLuGTy3nONXUe2XHsHbhr6wv0gykU5TGO+oRfrb97lzGlvtPiTANLQ60M
         mgaeypv1hIQQJfKsIzuI1HwaMSoWAASd4V16fQqvPfLNh5je7EMcR720klfr0hgK8O+I
         w2OP0HdYGA0iRwb0vamoTYNYHzjDNBk/N/Z6/tVN/UVsilkr4BjFR1HeMTNHRCKP+7V6
         x/bro+n1PlsXDbZNZ11XC4IQk9gZy5EiNZfjBTIQlRPbaVH+1EanrnAuiOYchfabVfXQ
         N00dyVFmoHCIOxt5fD+3wR2j8xkQw5LPJd52o6Rcm4n1Qoi1PZf5GIiqeRXp2A2or3ne
         Qb1g==
X-Forwarded-Encrypted: i=1; AKwUvBxHms94hc3D87cih8+sw8jSKbTeYwV9ImbuHSHuoU2aQzEC68T3Q3wO0jPz0KMB9YA+fhpWtes=@lists.linux.dev
X-Gm-Message-State: APuU4Z/3+kNo3shBAGy3vKL59ERf6w4soir8tdHrM7jU77oPByckZ9qQ
	sVAqa3BioxfOIv2hpjzOL3hB9K9JzjtK9s5hwdPWxTpUSOej5FzaKymR5tmupwJecA==
X-Gm-Gg: AYBFou3iAX8XLtgXCL3qee04aWnTudUlTwS2+lfZJ53eSQDW2aa7098Qem7fjX+Zlu+
	Ohw2fUtCNMGVtySVVVMRiPxSbs9CEJZNKO18u0EAs2Cq/VH23G5ziDb/uwI0iUcvX+Mit3aBMCq
	+wLnFJShLUuUkYC93VEmUba/BOkHS4cUMVjwwQ669EK8fRJyClfuq6vrgZt+INb1y5vGMrYinYF
	jB2RCD6DckCEIfSrASFliygm+zUOhm7qc1X8OkY5NKpM2tld09WNR02EYwWplvXfHGL/4pvIA6U
	XloEyr/ecKhFo5RUHuwlKl4UNeIt+HfuEBpPWLYz2+0ZytA1qAcVyROQ3Lo9/GT6w/xRznoSBv5
	ZQTtNItuXNWZxlc0t1qF+Uf/ds+8EmTN203FxnTXt6YDOX5nvGvbR14nt2F0BidZTTwGylKOnDN
	lge1WHXmAPvIg29C4fjVOW/1ezSSVFS5saRaOP6eXGuXcvK2//QbnADbdOdPFezPygNCjrVdFkd
	4w+GrRE8/VZUw+IltlkQxRNWM9/R1YW7HoflrYIuzazh/PqT2LNxyBDj7TgV/yqxzrHu0znsVOY
	B69cviEqpfnuEFe+IkM5FUmadHPHCpJ+Rlxuci1dqb0i/+mA64TRcH2oiiKDm0unjOY0Fw/DWjC
	n5fgidPOk2w==
X-Received: by 2002:a05:600c:3e08:b0:4a8:f2ad:a9e5 with SMTP id 5b1f17b1804b1-4b6db4a9ea1mr49691395e9.3.1793987888277;
        Fri, 06 Nov 2026 09:58:08 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b76cbd082dsm8048725e9.1.2026.11.06.09.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 09:58:07 -0800 (PST)
Date: Fri, 6 Nov 2026 17:58:03 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: arm64: Support SVE in protected VMs
Message-ID: <au4VKxSnkJgDtcpG@google.com>
References: <20261105130456.1617185-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105130456.1617185-1-fuad.tabba@linux.dev>

On Thu, Nov 05, 2026 at 01:04:52PM +0000, Fuad Tabba wrote:
> Hi folks,
> 
> This series adds SVE support for protected VMs. EL2 allocates a
> protected vCPU's SVE state from its own heap rather than pinning the
> host's buffer, so the host never sees the guest's vector registers. It
> then advertises ID_AA64ZFR0_EL1 to protected VMs, and routes the SVE
> trap to the lazy FP switch. The first patch is a small tidy-up of the
> pKVM FP sync code that saves a guest's SVE state.
> 
> v2 of the pKVM selftests series [1] will add a selftest for this.
> 
> Based on Linux 7.4-rc1 (6628e7d4c6b25).
> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20261104084842.132944-1-fuad.tabba@linux.dev/
> 
> Fuad Tabba (4):
>   KVM: arm64: Remove redundant kern_hyp_va() calls from the pKVM FP sync
>   KVM: arm64: Allocate a protected vCPU's SVE state at EL2
>   KVM: arm64: Advertise ID_AA64ZFR0_EL1 to protected VMs
>   KVM: arm64: Allow protected VMs to use SVE
> 
>  Documentation/virt/kvm/arm/pkvm.rst |  6 ++---
>  arch/arm64/include/asm/kvm_hyp.h    |  2 ++
>  arch/arm64/include/asm/kvm_pkvm.h   |  1 +
>  arch/arm64/kvm/arm.c                |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c  |  4 +--
>  arch/arm64/kvm/hyp/nvhe/pkvm.c      | 41 +++++++++++++++++++----------
>  arch/arm64/kvm/hyp/nvhe/switch.c    |  1 +
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c  | 22 ++++++++++++++--
>  arch/arm64/kvm/reset.c              |  2 ++
>  9 files changed, 59 insertions(+), 21 deletions(-)
> 
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> -- 
> 2.47.3
> 

For the whole series

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Vincent Donnefort <vdonnefort@google.com>

-- 
Vincent
