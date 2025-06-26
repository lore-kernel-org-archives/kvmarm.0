Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE86D2264C5;
	Thu, 26 Jun 2025 07:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750924412; cv=none; b=ug7/q7CqAECMVE2zVcTJN+gBRwu5KMo1jWH94BrxE0RF63tQM6K0tRwZAdZ6UR95dHbbw791s9QKwqBRV1UQnuxDDLz+6hZsSAPwWP03I/57Fdxo3R9LQ/e0rXVkAcQeJaYzrhP3IVlZ+u/pGsTVOjf75vK/ed4VDmMISReRBJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750924412; c=relaxed/simple;
	bh=Lt9OFHu6pgL3Xmje4MpYWTnla2Hs12OXB8URktFGWC8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NDcrDckdn7/pEDiB7vgotDs4cyvgwYBTfndkodcnexrCV+V7J6bd1Gji/y/aPFmaaBtVf/6yJHb6rvMrV43RSot0Rn+KB7WuuFlvozUnrkYLs3UidfiOVnk2kV4RrQhmpD7oO9YA4Ql9rHtAI+wNCk3yER6GoZBF0y+Y0qzv8j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vRQYzUlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vRQYzUlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8940C4CEEB;
	Thu, 26 Jun 2025 07:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750924412;
	bh=Lt9OFHu6pgL3Xmje4MpYWTnla2Hs12OXB8URktFGWC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRQYzUlGmrZKYw+vT8bqUwSltgIAm5Ma1MAHXXJoWSNaZh8J69G6zYAI6IN4FEwc7
	 aUSJiTKI3+lVhWPzOfKjg3knt1l+dJsVEGTAilByPXGsPP98XmcmrwMqlx7d1kmnYc
	 CIAGEvr+S3GQ4CRc4Pmtz3rVxxlGMuKXUX2U5FeHQgv0/JjA68SFHnbQOMHV+VS5/7
	 4YTDjYryN+mx6ycDO6uNfpbSmPk4xaL6mlQPaKjS9m0+wFHhhHo6q0q/mWM20lLWJK
	 nQ/fCHwoMYYvyIIHkVnHnYvOP1D9o5en4Oi4zf9LqfuDmxDRAOkkhwbo1RiMQv9NtL
	 9ZrLKj4XofnPw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uUhQI-00A8hT-Je;
	Thu, 26 Jun 2025 08:53:30 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Mostafa Saleh <smostafa@google.com>
Cc: oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	qperret@google.com
Subject: Re: [PATCH v2] KVM: arm64: Fix error path in init_hyp_mode()
Date: Thu, 26 Jun 2025 08:53:27 +0100
Message-Id: <175092440336.8068.17654803423983782262.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250625123058.875179-1-smostafa@google.com>
References: <20250625123058.875179-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, smostafa@google.com, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 25 Jun 2025 12:30:58 +0000, Mostafa Saleh wrote:
> In the unlikely case pKVM failed to allocate carveout, the error path
> tries to access NULL ptr when it de-reference the SVE state from the
> uninitialized nVHE per-cpu base.
> 
> [    1.575420] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> [    1.576010] pc : teardown_hyp_mode+0xe4/0x180
> [    1.576920] lr : teardown_hyp_mode+0xd0/0x180
> [    1.577308] sp : ffff8000826fb9d0
> [    1.577600] x29: ffff8000826fb9d0 x28: 0000000000000000 x27: ffff80008209b000
> [    1.578383] x26: ffff800081dde000 x25: ffff8000820493c0 x24: ffff80008209eb00
> [    1.579180] x23: 0000000000000040 x22: 0000000000000001 x21: 0000000000000000
> [    1.579881] x20: 0000000000000002 x19: ffff800081d540b8 x18: 0000000000000000
> [    1.580544] x17: ffff800081205230 x16: 0000000000000152 x15: 00000000fffffff8
> [    1.581183] x14: 0000000000000008 x13: fff00000ff7f6880 x12: 000000000000003e
> [    1.581813] x11: 0000000000000002 x10: 00000000000000ff x9 : 0000000000000000
> [    1.582503] x8 : 0000000000000000 x7 : 7f7f7f7f7f7f7f7f x6 : 43485e525851ff30
> [    1.583140] x5 : fff00000ff6e9030 x4 : fff00000ff6e8f80 x3 : 0000000000000000
> [    1.583780] x2 : 0000000000000000 x1 : 0000000000000002 x0 : 0000000000000000
> [    1.584526] Call trace:
> [    1.584945]  teardown_hyp_mode+0xe4/0x180 (P)
> [    1.585578]  init_hyp_mode+0x920/0x994
> [    1.586005]  kvm_arm_init+0xb4/0x25c
> [    1.586387]  do_one_initcall+0xe0/0x258
> [    1.586819]  do_initcall_level+0xa0/0xd4
> [    1.587224]  do_initcalls+0x54/0x94
> [    1.587606]  do_basic_setup+0x1c/0x28
> [    1.587998]  kernel_init_freeable+0xc8/0x130
> [    1.588409]  kernel_init+0x20/0x1a4
> [    1.588768]  ret_from_fork+0x10/0x20
> [    1.589568] Code: f875db48 8b1c0109 f100011f 9a8903e8 (f9463100)
> [    1.590332] ---[ end trace 0000000000000000 ]---
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix error path in init_hyp_mode()
      commit: 9a2b9416fd1d18d97ce1b737a11fcbc521140e5d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


