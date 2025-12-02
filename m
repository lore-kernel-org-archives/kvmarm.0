Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A832F9DAB
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 22:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764715417; cv=none; b=ukA2jOE+TQhfrFHHnBiv4zosnGZJTceblNxboQCAl6mei55lDkZORwNGKbOPGyAepxkxTOlPVdjFPBd6IIjRro2tyb1zNShmOUBjDMd1/i9WJq8uih2lfcB1vrAGr85wRzXc2XFzjAKQenZ3wTFaZyza+DzGTPaeBMB8mS/kSGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764715417; c=relaxed/simple;
	bh=GV4nmZlTqNhyK5x8C0GUeistp+nziFPdQUXBsboHFBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jeDB7ScclMq4uayxogIGU5lboUS9Du9y2862Ls5FyKNA5mvnFTdebR/inOI0G5D2fLQR4lPWjNnzlw+eLNjMeo836ULETVOsU9XtjBYo8G3nr1aurAvBHHogtqa3qAJLGqo6n9OPlgNEMYebYxK+Zsm7QufV3GGzqJKtZWomtxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+OG7h2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+OG7h2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C840C4CEF1;
	Tue,  2 Dec 2025 22:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764715417;
	bh=GV4nmZlTqNhyK5x8C0GUeistp+nziFPdQUXBsboHFBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N+OG7h2StqSuMuBZhLDw0GRqK4uP5QDkjo1fRktjsnAKRVLG5XMuNPtDlpxgaWHsU
	 mu5KqH8TL451/7uUURfqh/J0H8C3UGOdmxyfeCGLZKhogteBy+2dJxmibmWcVICnqd
	 R45zpc7u6f2cIHrtMzCBXo+C20DcKk6kobttLeEbLYEF6I+EI6cWSGntc28wXu4PEl
	 3MPsrnpC/mNtjA13FngjE5LWM/Grqg1NGqcMbJP4GTH9U1BRHzo2nLs0g4V19Fp8Hz
	 RpM5yi2ZV6vCG/TEOJ4d5LZJoNG3mMu3WeG0vOPS64ql3UXqHi3gc3YC5K88azd3Ep
	 WTggPVCMY+Ksw==
Date: Tue, 2 Dec 2025 14:43:36 -0800
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH v1 0/5] KVM: arm64: Enforce MTE disablement at EL2
Message-ID: <aS9rmMgNna7I5g4F@kernel.org>
References: <20251127122210.4111702-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127122210.4111702-1-tabba@google.com>

Hi Fuad,

On Thu, Nov 27, 2025 at 12:22:05PM +0000, Fuad Tabba wrote:
> pKVM never exposes MTE to protected guests (pVM), but we must also
> ensure a malicious host cannot use MTE to attack the hypervisor or a
> pVM.
> 
> If MTE is supported by the hardware (and is enabled at EL3), it remains
> available to lower exception levels by default. Disabling it in the host
> kernel (e.g., via 'arm64.nomte') only stops the kernel from advertising
> the feature; it does not physically disable MTE in the hardware.
> 
> In this scenario, a malicious host could still access tags in pages
> donated to a guest using MTE instructions (e.g., STG and LDG), bypassing
> the kernel's configuration.
> 
> To prevent this, explicitly disable MTE at EL2 (by clearing HCR_EL2.ATA)
> when the host has MTE disabled. This causes any MTE instruction usage to
> generate a Data Abort (trap) to the hypervisor.
> 
> Additionally, to faithfully mimic hardware that does not support MTE,
> trap accesses to MTE system registers (e.g., GCR_EL1) and inject an
> Undefined Instruction exception back to the host.
> 
> This logic is applied in all non-VHE modes. For non-protected modes,
> this remains beneficial as it prevents unpredictable behavior caused by
> accessing allocation tags when the system considers them disabled.
> 
> Note that this ties into my other outgoing patch series [1], which also
> has some MTE-related fixes, but is not dependent on it.

To be honest, I've actually been having a bit of a hard time
rationalizing some of these targeted fixes for pKVM. It has been in a
half working state upstream for O(years) and we haven't made forward
progress on enabling pVMs.

Fully aware that guest_memfd has been one of the long poles here, but
I'm becoming less interested in fixes addressing "pKVM policy is XYZ"
without having the full picture of the feature.

What are the upstream plans on enabling some basic implementation of
protected VMs?

Thanks,
Oliver
