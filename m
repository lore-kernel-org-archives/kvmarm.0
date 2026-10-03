Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17ECA391E5B
	for <kvmarm@lists.linux.dev>; Sat,  3 Oct 2026 09:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791019635; cv=none; b=bK19VcNZdxMElF0f9rAPYKjlGBoNrvnXW9O9rlblCBmZvk1v59KGX9PUKICAp1wdaAalKv8IfI2OCbY2JUtymzqq0+PuisppTSz/ZYKxN0OXqnL8UvgckvFxKwS+IULcilO4p6zVi5L5CQzB0Hi5Lr6jbR87jeyAyQDSZe6je4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791019635; c=relaxed/simple;
	bh=gJAbYCBgfyZBsLDiveSN72j/tQo+YZh+meOFvFvdh0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WIyBcplNuyB3ISRSRVPFDdiZvxTFqLxHB+d9zNODR41PjsD+iPaI4h0kLjDEonxeal/dPcxibCFdqH1h9oEdmqhVcoTRHupfmiF4L7Of96ZJZW4sNLsyEPn7HGIlyn3ouxDyLwe/FrrVtMVgHTQce0NmJe7z1GSbtp8Eb/OiJT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=feglxkK/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="feglxkK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AE71F0089B;
	Sat,  3 Oct 2026 09:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791019633;
	bh=PyX8VvJHS5WFJC5R8op7rV8x56n/aE6duu5Fw2y3gp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=feglxkK/piFBaeQNWOUvhHgfXd5/PW+ToT5SWiPOGnxHv6LZJDO+qmRizom0HM3rK
	 5Qlq67AJdE0dTetjoZXDk5RcfxVXfKaJh5nY/Ho0YZSrX08WjzY2j2OIzGJd/b43f8
	 dXrIO7lzgpAdgMgKpldaoSVf9f7RaIE2UQLZcn7RlcWaqU1v70QSXqNk7yBRoGNSII
	 gajigRafR+c1uVm7nOQh7Yd97eE7V56G9MuFTIoSM43wIYzv3BH8SF5H9Gu800T1/O
	 V6onJXa2f9OTHYdejKzPlxsFuPYyYtSvxUXvYW2jXXySzRYm1m+SlGaorLGj9ikcre
	 yb/uTo1mBEjFw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xCw1P-0000000GV3c-1FKs;
	Sat, 03 Oct 2026 09:27:11 +0000
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
Subject: Re: [PATCH v5 0/4] trace_hyp_printk() for pKVM/nVHE hypervisor
Date: Sat,  3 Oct 2026 10:27:08 +0100
Message-ID: <179101962008.602721.42919125204106176.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261001143000.3371786-1-vdonnefort@google.com>
References: <20261001143000.3371786-1-vdonnefort@google.com>
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

On Thu, 01 Oct 2026 15:29:56 +0100, Vincent Donnefort wrote:
> This series adds a hypervisor event "hyp_printk" which enables
> developers to log pretty much anything into the hypervisor tracing
> buffer, just like the kernel function trace_printk().
> 
> This enables rich logging from the hypervisor, while leaving all the
> string parsing burden to the kernel. This has been the main way of
> debugging pKVM in Android.
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
      commit: d35311c5d66095da3949787064d4738fee435d67
[2/4] KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
      commit: 955feee93e037af78caed7e98d29bbf0268420b0
[3/4] tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper
      commit: 604aaeb39521ef70f56c036dc065b133c85f06aa
[4/4] KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp
      commit: 92866564020c2fbede7f77f5957a75f11f931d53

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


