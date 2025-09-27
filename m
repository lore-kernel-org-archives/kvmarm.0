Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98008279780
	for <kvmarm@lists.linux.dev>; Sat, 27 Sep 2025 11:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758972623; cv=none; b=FxeTNhNBWuWlMfB7I8UDBuF5lL4a8YHkMc5fzcn+xuvG1tVPOSfPbiq+1rLz7W7RwxWsxkEmeGaqTTjRHC2K2wsTpsCOFDJko6BhieX0vhGdbeSdnQbkVSGJNfxWDeuAIU+3W7fOExszfRHVGC2aySlMFvJ92BMiYyWcpt//SU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758972623; c=relaxed/simple;
	bh=QdnnLgLKcIPxCknC9byIK25jdEzns36k6etvDE6eIYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DaLnOhbOaQADSyt/ZrrWDpe6TfqhyROqujfMylAFC91eyTlh9rLBazQM5fK6wdbiJW5o3bR+bvSGQunl2Iog2tJ9YF4a/kQbQeBOyvCxoordG68dpx1gUrCWQNkxAlsanywR8OScz02ABAz63BPOuLWg/A0JPC0pllkeCKzLdVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GFcfLP1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GFcfLP1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD52C4CEE7;
	Sat, 27 Sep 2025 11:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758972623;
	bh=QdnnLgLKcIPxCknC9byIK25jdEzns36k6etvDE6eIYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFcfLP1lDzgGW4eUYnJHl5OWNqNgzoU2HvHegHXX0OgfeM86Qg7pwoDaHZJCJn5Bx
	 rsPqhuQmH/4tgkWaHjDc4fGEX09+mW308+rWTJ2EyrYMtunNjv8CkeAcwqHSmhNNzw
	 F53e1+lo8VDHSyqDdDfUgmU1cSP+ZIbqH5eOVFc55j+pQtwe19UB7haHEvEvLguhpx
	 Ss6Cu7QMgnzvHlsyKs4wGrOMVqWPRQeAqyCCesdzlYU7Qmq8ji5HzU/nDrmLj4PhDS
	 GwcnV46tomC4Q5tM9Bt867V2E93O6BhOXkjHH4GaGjez0Tl7/n5M/6boaHIBscZqKS
	 Jmge/NAWjp+Bw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v2T89-00000009reG-0l3r;
	Sat, 27 Sep 2025 11:30:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: selftests: Test effective value of HCR_EL2.AMO
Date: Sat, 27 Sep 2025 12:30:15 +0100
Message-ID: <175897261490.2798601.7417454549485476932.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250926224454.734066-1-oliver.upton@linux.dev>
References: <20250926224454.734066-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 26 Sep 2025 15:44:54 -0700, Oliver Upton wrote:
> A defect against the architecture now allows an implementation to treat
> AMO as 1 when HCR_EL2.{E2H, TGE} = {1, 0}. KVM now takes advantage of
> this interpretation to address a quality of emulation issue w.r.t.
> SError injection.
> 
> Add a corresponding test case and expect a pending SError to be taken.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: selftests: Test effective value of HCR_EL2.AMO
      commit: 0c5bc849fd765a6af2c6d6fe3116c187966c7f66

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


