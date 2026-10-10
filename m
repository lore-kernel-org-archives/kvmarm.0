Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E67344D9D
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 09:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791625713; cv=none; b=mwxXdSJxJjYUU/nSv9Ng9oHI5pYXi9aKhRLQhrm7eg4wGfSG856bplgR98g8EM+uqgIc7puO/5L8MMeREOj6vS3Giz0k6W+KiNcsUCncJg+yDT4kfD5DLjsGuEOcjpWDk51QNWwKgYTnKfWBH+1hfFE6eK4MU6kIJlTDzNXcFFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791625713; c=relaxed/simple;
	bh=t9uqWitrLRhhyNMoVkWOFstV9pmx8GCsznQGf9jo5vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B4RbzKdaHjdEqbY7xJFaP7qYdnt+tmc3FMsRMiUXjrdYQQPEGgkoMprIZAueEGOgASnqDbgW90Voouu5TMGLm9dS/xr7jaT7SPr2/MaUNuHgNxCwTJjjbPTOiGMGXT1aiSJ4IbU0DwIqWFnWd+zOLZM8D+n5IpDQpPFEv8o9mvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aklk+sjo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aklk+sjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF351F000FF;
	Sat, 10 Oct 2026 09:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791625712;
	bh=vyYO4S8ARmzSdCuZ2VSg1OgVPsWiGyr9h3oQcinEopw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aklk+sjoCwd+IaoDl//Y6w5YbjwYwKjvCWj3vTOhcOKS4XKX3RqfWc30ZeLOfkL6K
	 dJ0kOmpLgnaj5z3G+2kf7Uglg1K+fjgTe7bbx87jWc8UGoaqkC7P4LItBpwxLyb2oW
	 0acFJ5n/e8n9YALfwvX4m0STUvG4IjMNmynjTtG5k3cg1FP9oF4lEZWRGcJiKNztN4
	 vOGviLgqnPOvoSh+RkoAGeKzInLL1fHgwndw+BppvkrRKo7DlNs8eigXSV7IauLgKC
	 KiMFJS9LX3hGZOZIAZ9Vmdxig7sfhfFnxF+cuHF0SLK76dZSIs7NJrDf8M4ZruK+MM
	 D4SFYWqzmEvGg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xFTgs-00000001JvU-072w;
	Sat, 10 Oct 2026 09:48:30 +0000
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
	fuad.tabba@linux.dev,
	qperret@google.com
Subject: Re: [PATCH v1 0/2] KVM: arm64: Fixes for hyp_trace
Date: Sat, 10 Oct 2026 10:48:27 +0100
Message-ID: <179162570115.845708.14917673397009490198.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261008104212.3134550-1-vdonnefort@google.com>
References: <20261008104212.3134550-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, vdonnefort@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 08 Oct 2026 11:42:10 +0100, Vincent Donnefort wrote:
> Here's a couple of fixes for hyp_trace:
> 
> The first one fixes a potential 64 bits overflow in the hypervisor trace
> clock.
> 
> The second may prevent tracing loading for certain buffer_size_kb
> configuration. This one depends on the allocator, so I have based the
> series on kvmarm/next.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Prevent 64-bit overflow when computing hyp clock rate
      commit: 6164ce3491bcc3a27a2e2e9260a286eb2df2301e
[2/2] KVM: arm64: Fix bpages backing allocation size in hyp_trace
      commit: aac4560e1287c36196fd2d78bf04d0c1c2559e3e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


