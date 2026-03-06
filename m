Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F81371D0D
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 10:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772794112; cv=none; b=BE7OmEMxDEeWAcb9Jk/7YRopOuMxEAWE3++Z48yb+71pnjDfPxUM/C1y/qbbDVvPjTlYmcrwUTFYujWFeJ78XwjGTfBqsbP6CbisioutNaTkCGv0a2+r5fOKxR/+8Zew+rxvdw3D0Rn06a/84CBuHJ4PJuh+Q7ArZfFUhRDV8YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772794112; c=relaxed/simple;
	bh=I4BLXGkdfGb0t5nzy1NgItpRVyXjbFiNT2NMk6LuQMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kF5ZGjZfq6ZQW9vJGLrbMP/rBLzJS1KE80LKt84ezNsOoL+ti5bG13YXHeCCjDI3REFpfn2x2u8ecgLRbdeavvUHsdwhv2fA6BKIsZBF7tUxmrFm4QXPpFFR3wJfpZjqLc3N8OCg936xwdQpQGYqgwW6Yc3MHODcapNnLRBJWDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cGIqvlDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cGIqvlDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5877BC4CEF7;
	Fri,  6 Mar 2026 10:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772794112;
	bh=I4BLXGkdfGb0t5nzy1NgItpRVyXjbFiNT2NMk6LuQMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGIqvlDCiMEIfv7619WJJnEtIEznXnhubTs1Nbk1HfhkBuT8kb4XUYEK9UCTrGeIx
	 X3smIfUc0MNSq0O6S/h6OLaQGYrBarrWzisG3jyKJKUljlRdDJb2Y1CS/DgIPvn1wB
	 HJfSY6l22Lyu5FbGvcELkBnpk8BXpiM0DSpHwVwYlaIC95BDgo9KqezZ+9gI3Xk1Em
	 SmrBdnAu3sE/cubujhz6y/ZvGd9CTBJnc2sx4KxLdlURcTES/Z2XYNIb7gVQ0X8J5B
	 jYlJ9hZwgQimxCdr4/H/6l71G0xaI2O3bouTF96oMe+CG7aub5mYy+uM+z0DKZYk5i
	 diYhSt3M0D3Vw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vySjO-0000000Gnnr-2AE3;
	Fri, 06 Mar 2026 10:48:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Cc: oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH] KVM: arm64: Remove the redundant ISB in __kvm_at_s1e2()
Date: Fri,  6 Mar 2026 10:48:27 +0000
Message-ID: <177279406015.3200749.13428414885597289.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306074422.47694-1-zenghui.yu@linux.dev>
References: <20260306074422.47694-1-zenghui.yu@linux.dev>
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

On Fri, 06 Mar 2026 15:44:22 +0800, Zenghui Yu wrote:
> We already have an ISB in __kvm_at() to make the address translation result
> visible to subsequent reads of PAR_EL1. Remove the redundant one right
> after it.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: Remove the redundant ISB in __kvm_at_s1e2()
      commit: 3599c714c08c324f0fcfa392bfb857c92c575400

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


