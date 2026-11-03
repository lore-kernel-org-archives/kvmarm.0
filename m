Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711183;
	b=iO+9q/jMzIfqzcggk7KPkaY2PoMkerWeDOarLj7U4uJ4UGIouwtDWI84NSh7ZpsNpW/y
	 uYwMp8vxKYmtgHKioF2mJ0d/G+vTULrP43BrsTrA9BhAZdbzTzFydTuQoBS1Ah6H8nEJg
	 Lf/54vM6twYa3aCU2WOYJNXjVbj8P7yl9necmhoG6iLah9OJW87kr0WR0v/MgHiJJF91X
	 1SxsnjX026hVWkEJhDqDpEwrQaIZ71KbJAiiYbVc20ioQtGa5mOxiH/ZHj3KrTBGV448W
	 /a6SW7lW9a5XvhsWQ02xAt4DthUCDHWT0XaHw1H7/X6/Uga7CTqH5mREdJYfYyKHkjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711183;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=LyvyqRc0CsiBtv9AFJeJRC/mSnmi8GfQ7gHCAIH28jI=;
	b=1Ab/s0Rz+73meWk4GL7bcp28asxEbduVzboI6eIEZKqpT1wEqxey5roE0eTzk0huTqo0
	 h1vQcPSDBh7n8PoB7OYEs48NM5ggiNOMeJK3GNLx3LUTLXoQNIOb5EA1q27pO2PiNCTD7
	 b48Qhf41MuMXzTCg+lhKRXzy5Vvm7bYUq2eiq+IPoLFwZBAmWx/oumZb4h13/eKpSw/Iw
	 ijngm/S6egBL+DR2KXOKX68NnVG9bf2YlwMkeDo3YoppFRXb9aTHH3u0CsVQabfMKRUle
	 YVfqQkGzHE+7Idx54H2m6UJR1eSjwxrJMpKjbVog9/6AZYKASK3nefBNq/GtIg6jVjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iRdVuYB8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0624C606EE8F;
	Tue,  3 Nov 2026 13:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iRdVuYB8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79901F00A2A;
	Tue,  3 Nov 2026 13:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711182;
	bh=LyvyqRc0CsiBtv9AFJeJRC/mSnmi8GfQ7gHCAIH28jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRdVuYB860boaLF2XHWfKA/JoRpq1+7x5EGMhX+x+WwYvOJjdexCU1VkSxDnkfNnA
	 GYFbGf6LucbzSNDrOXu0OIz5zsB+OrnALPkpibaBxxnFTAtT1/uoqg4iB5xEtnLfI8
	 G5vuz/Rzk/qfiaS9tq+4C3oEFoL/NE5fufAkBggHKxBQvF4rFp8t9NsdISmfsiUTrg
	 Pl/H5RsTFR5Rdqt5UJfXiEMGzN5mSPKytZAMGagIxRLUX2H+5u1OGNWArUphiAgqAa
	 rSJs/tORiXFEZnZ+15fzASCOh5vEBZWJ8YzkQumwv0tRtWZKcyE1Mf8Y3p4a/x/tR/
	 ujiiZN8+tn8BQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEDV-0000000ATWs-0XjH;
	Tue, 03 Nov 2026 13:06:21 +0000
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
	Gavin Shan <gshan@redhat.com>,
	Leonardo Bras <leo.bras@arm.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Dirty logging fixes/cleanups
Date: Tue,  3 Nov 2026 13:05:44 +0000
Message-ID: <179371111272.2844725.7421436715198308487.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029175238.3214788-1-weilin.chang@arm.com>
References: <20261029175238.3214788-1-weilin.chang@arm.com>
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
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, weilin.chang@arm.com, oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, gshan@redhat.com, leo.bras@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 29 Oct 2026 17:52:36 +0000, Wei-Lin Chang wrote:
> These are two fixes/cleanups I found when reading the code. It fixes
> dirty logging detection in ring-only mode and updates a stale comment.
> Please view the patches for more detail.
> 
> * Changes from v1 ([1]):
> 
>   - Keep memslot_is_logging() and use kvm_slot_dirty_track_enabled() in
>     it. This preserves the RO memslot check.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Fix dirty logging detection in ring-only mode
      commit: 98b2eab9345c502cb13ef2e347ab5a6c288db482
[2/2] KVM: arm64: Remove stale remark on canonical IPA alignment
      commit: 4bc0c9cd84767a978046c3b2a73dc932bdb8d9f9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


