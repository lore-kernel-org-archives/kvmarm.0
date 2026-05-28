Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0043F2E7381
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 17:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779991002; cv=none; b=CPiSYxCnkrOv+2mqSJ5t7s8E3qWGRphk5YwV+O2gQaIFBFICoGlOkT9vD8L05m+YVNcBfp0QI0POUwUIhBfjiCPuBZTUIKDfzrMKlK3RQd1Hx49l5PhpwiwYGTTjMmM61gB6XfLtuBQzgGAmcivmxMx2Phiyo2PmaVTmGqBNZeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779991002; c=relaxed/simple;
	bh=tifHFKIyGYCuqH14y9kKTgDVVPDyq56Hyt38uzz6E6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RW4ELWzSL7C5bWtF2gbMBYqoNUTn0YrXrPstBxNkJ2huouoiStzWaSAACO/bw3WtRyJKueUXL8I26xfpszxOzUMb+z+8kb2K1SjBHY8fujDBwnvb7ZgSK2XLTY5LVtOH7kL1KPIiA2/hUwAJf9kl4b0Ls7XoCYhMLa8LibkXUYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P5G+Eix9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P5G+Eix9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE021F000E9;
	Thu, 28 May 2026 17:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779991001;
	bh=Naf3wXJ2EyrFvHMdJcyKV7tDwmuIz0pC4n157xSFJ8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5G+Eix9YABB7wMgZVO5Q+vMS6tFX7oY1PkD91PWXzwGDKrxzk8yq/hGqjlWft94I
	 Rmvue2+hRRsCFPGEMjvOb3HNA1nNoYN08zMxhBXUVZ1GIiUVXZzXIq5Aa0p7FCNyjK
	 PkcRwfotYhLN5g3i/K7wPhLU9WR61Z8kqlE+w479jk/FM62TEutBgN98GmVzH4s/jm
	 aPZhid8JeLGhb5WKwaum52RyaaWbxDpJG0+dfgzfTtuvPpCUWFbkUQ/chFdnzYNW+K
	 e/17gq/5sBjf7Z8lwMfwxqWoPDBPR5UVyFnaPuakGWFwjhzays9hs4LR+cwf8pG6d7
	 dyd6mx1j0DuUQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wSeyF-000000078lE-1sfq;
	Thu, 28 May 2026 17:56:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Cc: oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH] KVM: arm64: Remove @arch from __load_stage2()
Date: Thu, 28 May 2026 18:56:36 +0100
Message-ID: <177999096482.1739911.18058733022037753764.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260318144305.56831-1-zenghui.yu@linux.dev>
References: <20260318144305.56831-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, zenghui.yu@linux.dev, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 18 Mar 2026 22:43:05 +0800, Zenghui Yu wrote:
> Since commit fe49fd940e22 ("KVM: arm64: Move VTCR_EL2 into struct s2_mmu"),
> @arch is no longer required to obtain the per-kvm_s2_mmu vtcr and can be
> removed from __load_stage2().
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: Remove @arch from __load_stage2()
      commit: e72b425f617edebf6f374fa39f2c763c9b3696ec

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


