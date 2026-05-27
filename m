Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D97410D1B
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 13:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779889091; cv=none; b=arB4ZEkwkllbohlOyDhXPluk73H4/x37FCa4xVe0Cc5cc1ybyBaRneE8gVbA784abK4qEGp/p9Kj70Lhm1dDrHWJwTqUrmU4wcXaR+XtAXM5CiY8++prfY2Tz2iAkwNcdRasQJ7DrEWpCf0hrbqwBZb13dmr3F9X8KtZbo/K7OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779889091; c=relaxed/simple;
	bh=b6sTn0HRA/qre3/qc+G1c3HJi8JwPf+jIdUtB+mcuEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KIAaWGi+3LZQkvj90xwUEmwq8f+lVEDlbirUcwhtAcvEaYPsJf+u9bO9Tg4+/8zyxhf52+Cw2S/l7EM5lzOML5VDLNxBi4G8b+9KLJmrIOSyZJEcOlaiN81HhCbxAcbARMUwY7noPg/foPuuLF6tQRfxG+g9mc2XDv2rpJH/CWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bB9EHCAP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bB9EHCAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3681F000E9;
	Wed, 27 May 2026 13:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779889089;
	bh=St9joyObd4559kn1TWbjfpbc4F9p0cjGD2hsL2jvuXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bB9EHCAPWbu8uNTYmToasHcjo+mV13euImXQY1TmFI1pgyrcC60GEp5W9hwa6YlmB
	 JEw9LPkF/tSOhAAMiJ8WVwHaNHgXk6b+8iu3qRXi35+JjWx8nL3rLusFD9Qv0HJ7Rk
	 pI6n3QO3mGli5WNCEbD+VcLf07iTa1JtJTs3/cAzmnlzKGQ/IcL0Cssc2SivleEDPv
	 NunKiX4kztXMBUayM8sBiwWqoCgTk67ecLIGiNYcbG4eDu2a15oeqR4zE+jDgeg33+
	 gE76Fa3s8SO/ZCcr1+h7fzwTXXa19ZwsiWCKI/HnMXUh/H6guh4nQU+HWQKYtrMMh5
	 KWZ5QF7oezGLw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wSESW-00000006hBG-0CYG;
	Wed, 27 May 2026 13:38:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Oliver Upton <oupton@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kernel-team@android.com,
	qperret@google.com,
	tabba@google.com
Subject: Re: [RESEND v3 0/3] Fix __pkvm_init_vm error path
Date: Wed, 27 May 2026 14:38:04 +0100
Message-ID: <177988907507.1514704.9577495043154510677.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521143626.1005660-1-vdonnefort@google.com>
References: <20260521143626.1005660-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, oupton@kernel.org, vdonnefort@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kernel-team@android.com, qperret@google.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 21 May 2026 15:36:23 +0100, Vincent Donnefort wrote:
> Sashiko reported a potential refcount leak in the unlikely case where
> insert_vm_table_entry fails.
> 
> While at it, I have added a fail-safe to __pkvm_hyp_donate_host to ensure this
> function doesn't allow leaking refcounted pages.
> 
> Changes since v3:
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: Reset page order in pKVM hyp_pool
      commit: 6835fbed39bb329744a3f44e8e6a39e24079af10
[2/3] KVM: arm64: Fix __pkvm_init_vm error path
      commit: 20d2753295b1cd3c766199b5990119ca514e1302
[3/3] KVM: arm64: Add fail-safe for refcounted pages in __pkvm_hyp_donate_host
      commit: 5c30c9fc117cc7d0c1b45741d1127edd4c2ae990

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


