Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20423C1D62;
	Sat,  1 Aug 2026 11:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785583724; cv=none; b=hb8RY/0BKJZvhIY/vD/YR20FIZmO1stJTjsp5md8XlsVJA5zmKY7zxjIqMF36hd9RNrcwUAPJHFTEGSeEZIAOSnmHckhX84ICks8cxheFKNODn+nLqwrUA0V4Qz2wOJl5ZA4cMV7ZNFvkjAhkteZ+36QjZlDB3RNwPc+YubVO0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785583724; c=relaxed/simple;
	bh=I7nT9IGbjCbtco9vXpvryb89FfTThbqrXY0icwSQiUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XI+aB9RQckw769R9mfth2yvxZM8+ucaz44mbk3/2rsrgncLOuy1wqGYbt23e0UJ1lZq8P+FR5my2GmZrqRg1MxPspNUlc0P8t6s5Dz80WTdcpSLNQHkfzgKLKgnaj6Unn0KrBHI7+XnHbnfZnhj5xz9GfFjnZ2SGr41DynyEbSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GbK9p9zE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GbK9p9zE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F901F00AC4;
	Sat,  1 Aug 2026 11:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785583721;
	bh=UFhxUhix1Fh8RyfzClPpjIgKKDDYGolNHrzZ3o8gQXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GbK9p9zEG9BU+xJo7viBzq2OLwkvHk+oATw1ZuOTuUHy+4f8JESv6wL2WF66kIYOs
	 3V0ZrjeqbpbLEsiZwVcudS1oYVwO6N1l39MpEjQh9KOkc0aCJVI5zqnXqsPNViCC6r
	 Df+HeIJMbQfEDBs+Lcw4naXGy7XDcwytdsDbaNCRhRTZZvIHM1SqnCC0k1Pjuw/mfL
	 N7rvkO6GRmEey5jUt94p9nIedrsvaFGCSSNV4B6qdayQ/91UX0Hz3J2pBQ3NBUsaxb
	 Hhcd05vGbDpGu+pVLiydbMLZJLmFMvY4w+yIYL87Zu53A9Ld5/kWMZlM3LlpG/dccP
	 aDy3ftYY6ULOQ==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] arm64: Query per-VM capabilities when selecting vCPU features
Date: Sat,  1 Aug 2026 12:28:27 +0100
Message-ID: <178551846502.372256.14001177589864266246.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714110329.12113-1-fuad.tabba@linux.dev>
References: <20260714110329.12113-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 14 Jul 2026 12:03:29 +0100, Fuad Tabba wrote:
> kvm_cpu__select_features() and kvm_cpu__configure_features() probe vCPU
> feature availability with kvm__supports_extension(), which issues
> KVM_CHECK_EXTENSION on the global /dev/kvm fd. That reports the host's
> raw capabilities, unaware of any per-VM restrictions.
> 
> Protected VMs support a subset of the host's features. The kernel
> reflects this on the VM fd (commit a3163dca4817 ("KVM: arm64: Use KVM
> extension checks for allowed protected VM capabilities")), while the
> global fd still advertises capabilities such as SVE that the VM cannot
> use. kvmtool then requests SVE in KVM_ARM_VCPU_INIT, which the kernel
> rejects.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] arm64: Query per-VM capabilities when selecting vCPU features
      https://git.kernel.org/will/kvmtool/c/84464ba0246b

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
