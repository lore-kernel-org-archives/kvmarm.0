Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4132773CA
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 13:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773755071; cv=none; b=j04rJjapcDWSHVr5jhv59Li4mKNHpKXTDHbb1deQ4C6qVmf16VP3c/UZBJ/vTDzxtPigYqp4Wqsw1Q4Il5yMLYvhs9VS06Fc+QA1FPsqqdmHFmEPxJTmkiXPkgBsOYO0pN9XglK0GJ+2XMXyPvRi9mv5ExEsyPJ61K2QkqjZ9aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773755071; c=relaxed/simple;
	bh=xDYlTj5oh0PNIz4gI3ATDUGTOj/ofdzKUm3Eoj3jiWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WsYkrcTh9fXq7XrnvEid6SHySSOxa8PZ8/zzup6Kl/7EvjDjhSkTleTwOntOWkPRZ4Tn9pgWoh78EaAbQOg3PiwubVRPuMcVBH3Zd9AROklVuXKKXTCpstqJ8gdI0NtiJQ7mBjBfBq1aMLVzE1avxYpZ2nWaMjwFHyrL8UTG++c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNl9nDdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNl9nDdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86322C4CEF7;
	Tue, 17 Mar 2026 13:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773755071;
	bh=xDYlTj5oh0PNIz4gI3ATDUGTOj/ofdzKUm3Eoj3jiWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mNl9nDdHF+cPk2NZzCOwLbeBfSxKTlIZGn4PRwFOpGQVfpyQKL+Yu+q4vrpzwKRgE
	 kVghIMBF3ho71K4mtfHZCiOtYdODBZxDgfUhvZXdOOTd6wpbfwU6JzBPPqa8zlu+aV
	 lkJKS+9O3fTrc1FlAYLO15FcfPDaMfyvuEPjDjzXFiHQAhYXUzDW4XwJJ1vtll0yka
	 HFoSofEz+hLXqsELs0iL7fpBSYgUZUOQriBT9ct9hn1+In4Oxz6Eh0Y32qqY2iXfWC
	 kcGdObCRNLsqxYk6uP1K8bzPfkHCCkVas1yGeKLR/9PcgFZTRH9AHBzzT+eHvKtN5a
	 S++9KdjkTEXvw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w2Uij-00000002raI-1Bu6;
	Tue, 17 Mar 2026 13:44:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Cc: oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH] KVM: arm64: Fix the descriptor address in __kvm_at_swap_desc()
Date: Tue, 17 Mar 2026 13:44:25 +0000
Message-ID: <177375505490.1884461.5958230825865756810.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260317115748.47332-1-zenghui.yu@linux.dev>
References: <20260317115748.47332-1-zenghui.yu@linux.dev>
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

On Tue, 17 Mar 2026 19:57:48 +0800, Zenghui Yu wrote:
> Using "(u64 __user *)hva + offset" to get the virtual addresses of S1/S2
> descriptors looks really wrong, if offset is not zero. What we want to get
> for swapping is hva + offset, not hva + offset*8. ;-)
> 
> Fix it.
> 
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix the descriptor address in __kvm_at_swap_desc()
      commit: 0496acc42fb51eee040b5170cec05cec41385540

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


