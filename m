Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E49D35F8B9;
	Fri, 13 Feb 2026 15:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770995010; cv=none; b=JwjMVzLdmwikSzIDbbmh0TlkkoeZXJPHlNIGk9KN/HOkBFE8TqwLmxVTyLqxgst6hNo9IR4idcr0dhmtRw6XJz7xARLnM/ZCE+BCzaXRBdvV0fi7FR/A3fhl0J+67DUI7ccTz5yrJGM9xSUT7zUNfcXlP9BNZLID6PBap5ydTMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770995010; c=relaxed/simple;
	bh=bwBJBP1hyUViZ0rrcDmZcdmQyIs7K+antF4a/1Hue/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RplCi5G+YFbIwl93T6kL7eZYTbb124hNomYMzgxWH4s6DYyEkA0+o9CM8/Y+pgRjkjGAb+EUae4wBuBcjkZRq6OreNyUZKWQHvJ+sf7SsqUU+TRPHr9ByaAXGoDlFpfWgSNZf2i5XDQGZe84aERUfTyMDx9Xdl9ze9RrOfuBMfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RoZu0Dg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RoZu0Dg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B5FC116C6;
	Fri, 13 Feb 2026 15:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770995010;
	bh=bwBJBP1hyUViZ0rrcDmZcdmQyIs7K+antF4a/1Hue/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RoZu0Dg2b9XDeXZS54xi7WeNHlr3klAe5otMih7vU5ffwiMrxFvTzBilOtZQWVymj
	 6re4vKIGISqc/+irVYOCPDegqJNuFx3zC5N5iYoE8WtYg4A5JQP0P4vQzwB2Q6kD1f
	 Vh8jMUrjl8cmXpOCtpXDOEy81aMjtK2uVZ/7y0GpswQ2sIzqsJGjkehaZjRoRFIskS
	 vRmb4la70yQFyyYvTvfNT3az92LAqGJ2S46XcdaJmSOMDDF2vmMiCd4Kn3+RR32k0O
	 P/ave6ETbUhw+bfjhH/UHOQfiNetcAs575UBBmaumAQcQlynIsDnG9ENz1aY5QBoiu
	 QvQgQY2IfCQng==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vquhb-0000000AuPm-3u3k;
	Fri, 13 Feb 2026 15:03:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Timothy Hayes <timothy.hayes@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Keir Fraser <keirf@google.com>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: vgic: Handle const qualifier from gic_kvm_info allocation type
Date: Fri, 13 Feb 2026 15:03:24 +0000
Message-ID: <177099499992.1792318.9934885934778681296.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206223022.it.052-kees@kernel.org>
References: <20260206223022.it.052-kees@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kees@kernel.org, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, glider@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, timothy.hayes@arm.com, Sascha.Bischoff@arm.com, keirf@google.com, linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 06 Feb 2026 14:30:23 -0800, Kees Cook wrote:
> In preparation for making the kmalloc family of allocators type aware,
> we need to make sure that the returned type from the allocation matches
> the type of the variable being assigned. (Before, the allocator would
> always return "void *", which can be implicitly cast to any pointer type.)
> 
> The assigned type is "struct gic_kvm_info", but the returned type,
> while matching, is const qualified. To get them exactly matching, just
> use the dereferenced pointer for the sizeof().
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: vgic: Handle const qualifier from gic_kvm_info allocation type
      commit: ee5c38a8d31e5dea52299c43c2ec3213351ab6e1

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


