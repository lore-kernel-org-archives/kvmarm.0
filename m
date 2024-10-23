Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA831A76C8
	for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 11:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729681563; cv=none; b=fGlc+gtkZz7Zs7PJok2qcMBZVoA0GC+GiU/YO6mL9yNUqgJ9Z1We35bYWV+vrpFh9K442ZmW1imWM4MNT2+85c6s/TdkJKJZmZvXKbrJa22v+AE7YIEUYA8c5Fy7t4OUFgQ01FBxby0CzCFN2EiCEBlOdE7wWY5XcJH1d68YGHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729681563; c=relaxed/simple;
	bh=eYx9YD+9FJKe9sBrs79q+O62yWPIpMulrVns7VSjHog=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ArbEu6ByrdkbojoaFMVbZ3+nQN2cr+lXM/g49R/tyW+aPPbCcO7nzVGQ0rb669SJPER0t/RztqqaKspJEhJVVQH7MFShWVw18+r3IEvTtEe+dM07YukRWf0FUFTIAinmJDUue7VPsIKgUJeuUZTqIIhVdrAnsxC2FB5MC6rZP+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA03C4CEC6;
	Wed, 23 Oct 2024 11:06:01 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH] arm64: Add command-line override for ID_AA64MMFR0_EL1.ECV
Date: Wed, 23 Oct 2024 12:05:59 +0100
Message-Id: <172968153451.1430969.12754885741229995015.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241021181434.1052974-1-maz@kernel.org>
References: <20241021181434.1052974-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 21 Oct 2024 19:14:34 +0100, Marc Zyngier wrote:
> It appears that relatively popular hardware out there implements
> the CNTPOFF_EL2 variant of FEAT_ECV, advertises it via ID_AA64MMFR0_EL1,
> but cannot be bothered to set SCR_EL3.ECVEn to 1.
> 
> You would probably think that "this is fine, EL3 will take the
> trap on access to CNTPOFF_EL2 and flip the ECVEn bit", as that's
> what a semi-decent firmware implementation would do.
> 
> [...]

Applied to arm64 (for-next/misc), thanks!

[1/1] arm64: Add command-line override for ID_AA64MMFR0_EL1.ECV
      https://git.kernel.org/arm64/c/358dd4a9bdac

-- 
Catalin

