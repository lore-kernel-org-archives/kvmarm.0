Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A21E1B5813
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 17:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718905184; cv=none; b=XaQj4fxEoe3pjwCxEDiB1Qw1bsuS7fHZwmmlouB5NOXxC7GPPgcD7BEy1E4CBYqc9QVgmVtgGPjrVdwAPwoSaRRCImvUQYVZ2MYFJnhCMwelfbEtgHPs4t9C2IfSJa1jwgjDzVpeyNmlvniHdzg/fVf3T0eYRHrZTSlUFC3xVTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718905184; c=relaxed/simple;
	bh=oMDPZXkOqyWUCpkLJroHMS8cDvMBn2+L37sdHRJkzsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nfZErNiBqfdMJ2Ur75ZzehZC8cFeeYyFvI4MCHRB/eKFS8mtEdJGMi5mn7rY9S/+bHqkm/hTdag8uJFLmWJrj/W6vcRZWsDKaKII1jihmDZDF+CoXjwKue2vPVpIlJX7ydDwYDyXg7Uhral+QT0ApbvopGW4cbF7PS+Sdlvhs9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bnk/m78c; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bnk/m78c"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718905180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E5k/mqyQHSNQbgC0Oj9mNxKhD7o2n/7C/7pyjSDJcjo=;
	b=bnk/m78cQ7+qKvef1ORSH7n1oW/DPak+UQEoTlZI8AuTnEKRyHLYrdNl4zIO+hImRm8l/J
	R9t91rYGnzZHH8pX0CtaKlHvtVo2yo7fNjLGNF6CApJ8gHCrBOqGTUKL+dH//SYQRxQWho
	GbzIeflrANCLTJoZAfnF32RzTyGPRD4=
X-Envelope-To: oliver.upton@linux.dev
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: eric.auger@redhat.com
X-Envelope-To: sebott@redhat.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: maz@kernel.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	kvm@vger.kernel.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v5 00/10] KVM: arm64: Allow userspace to modify CTR_EL0
Date: Thu, 20 Jun 2024 17:39:29 +0000
Message-ID: <171890515830.1223590.8660930452290685977.b4-ty@linux.dev>
In-Reply-To: <20240619174036.483943-1-oliver.upton@linux.dev>
References: <20240619174036.483943-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 19 Jun 2024 17:40:26 +0000, Oliver Upton wrote:
> As I'd mentioned on the list, here is my rework of Sebastian's CTR_EL0
> series. Changes this time around:
> 
>  - Drop the cross-validation of the guest's CTR_EL0 with CLIDR_EL1 and
>    the CCSIDR_EL1 hierarchy, instead independently checking these
>    registers against the system's CTR_EL0 value.
> 
> [...]

Applied to kvmarm/next, thanks!

[01/10] KVM: arm64: Get sys_reg encoding from descriptor in idregs_debug_show()
        https://git.kernel.org/kvmarm/kvmarm/c/4e8ff73eb7ae
[02/10] KVM: arm64: Make idregs debugfs iterator search sysreg table directly
        https://git.kernel.org/kvmarm/kvmarm/c/410db103f6eb
[03/10] KVM: arm64: Use read-only helper for reading VM ID registers
        https://git.kernel.org/kvmarm/kvmarm/c/97ca3fcc15cc
[04/10] KVM: arm64: Add helper for writing ID regs
        https://git.kernel.org/kvmarm/kvmarm/c/d7508d27dd88
[05/10] KVM: arm64: nv: Use accessors for modifying ID registers
        https://git.kernel.org/kvmarm/kvmarm/c/44241f34fac9
[06/10] KVM: arm64: unify code to prepare traps
        https://git.kernel.org/kvmarm/kvmarm/c/f1ff3fc5209a
[07/10] KVM: arm64: Treat CTR_EL0 as a VM feature ID register
        https://git.kernel.org/kvmarm/kvmarm/c/2843cae26644
[08/10] KVM: arm64: show writable masks for feature registers
        https://git.kernel.org/kvmarm/kvmarm/c/bb4fa769dcdd
[09/10] KVM: arm64: rename functions for invariant sys regs
        https://git.kernel.org/kvmarm/kvmarm/c/76d36012276a
[10/10] KVM: selftests: arm64: Test writes to CTR_EL0
        https://git.kernel.org/kvmarm/kvmarm/c/11a31be88fb6

--
Best,
Oliver
