Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCC340B116
	for <kvmarm@lists.linux.dev>; Sun, 27 Sep 2026 16:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790526914; cv=none; b=Gk8sM/KeBx0XjjhZZxJp3dme2igFwtUzGxdZIzvvc9yUSm7GnJrr37wRRyP68qnAHhY8AFfNWesv4S+bAI+Xe8zIYEV13N8Ux/X3FpKMF0jGqm7B1H88t7lh5NKVLD5dGdlGfRezMOeBQ0f+QSDo3OCLigXDgnJXKHy7KdioOPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790526914; c=relaxed/simple;
	bh=AjTwMs2WKRCAS4daBNNL79qWHO0Gxu9X96E44j6a/SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rRSHDvi5oknSjEg94t3pkkyxMIcPCCdxfCRdX+rIZDsa/7ON69LMXGdINfGqLv2nAN6EQm9/YrfBuRtg3RMgEjCnGUaRE+TX3QcPXcWhC6CK02o4vL00JGww2JKE1+5nGgIkfULa8p/110LbSlrV0QeN+HoU40K52CNrleGa1T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DJnh36nn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJnh36nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160FD1F0089A;
	Sun, 27 Sep 2026 16:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790526911;
	bh=iPKgJC8RbpP+9ibDNCnvvFbPTYvz5LnInWapqFpnif0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJnh36nn6WxhyaCJbJGkTanQoKzCjItyolhMxnEc22pXRpCgSLUh9BRCw4+lEcamN
	 tIKd68LpYeUBraUKB2vRpJgNBIAXb0J7s6cYm3xfwsUsoL5SoXwHg0v81/rVOOIlUz
	 tzrgQwQ04P9WXmsMGOw0rNNiDhNHIRnxhp3YHtSMIlxjsulriBl3KBQ9cx9WB/XxQV
	 C+w7Gkmb7UsPZoAkXXCR0aOVWkghV7qt9E8nCip5ebUhL7xTeqa1Z9XrqJ23Kurrm/
	 JWWE/nD5R7pRguabfOazZd/5OrSaHSSx24R/egUC792zx9KO0P65cnc+B10CicfYr5
	 dZ8Khc/DmNzEg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xArqH-0000000E2Sj-1J3a;
	Sun, 27 Sep 2026 16:35:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Vincent Donnefort <vdonnefort@google.com>
Cc: joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kernel-team@android.com,
	fuad.tabba@linux.dev
Subject: Re: [PATCH] KVM: arm64: Remove PAGE_SIZE alignment for hyp event ELF sections
Date: Sun, 27 Sep 2026 17:35:06 +0100
Message-ID: <179052685160.3528802.5901671854382290571.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260924095154.807726-1-vdonnefort@google.com>
References: <20260924095154.807726-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, vdonnefort@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 24 Sep 2026 10:51:54 +0100, Vincent Donnefort wrote:
> .hyp.event_ids is mapped as part of .hyp.rodata. As a consequence this
> section does not need any page-alignment. Remove it to save a page worth
> of memory.

Applied to next, thanks!

[1/1] KVM: arm64: Remove PAGE_SIZE alignment for hyp event ELF sections
      commit: 8642afb74be6de014e49937c2c4de7576f45531c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


