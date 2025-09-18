Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D3730FC3A
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 15:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758210572; cv=none; b=GYhCt2Cw8rT2j0gI2NcF6bcQBB7i5SO+Qps5XT/QGHCq2t99YKSXoDcR2PD/prwFCEnnGcJLlqk6F0zG/zcq6S6gXkudMHe5HHldj7HonWcEzR9T4Qva3Jit16qPKZVMRqOtSLr7w25EqV4oxntn1D24qb64UjEYWSo9PIClvGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758210572; c=relaxed/simple;
	bh=8N6jci7Nqm0E0bHYwE12wLEidPqbwmOdkiYeA0kQmNU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AgNHVxUR8FJzzbv38tK5ah7fVKsk21mRt0+SszBBYKnFGnKTu8unht2rgi32iD1unaMK/vbmfOc3wPMKw/IsTY7JeYrbk1HX9cyjdEUir3T/a0y/vDbIk9l/ecK5ckZGJCuyMkdE1c0fC2TfY21Quy2Pf7H+ggkv3uaM37yThpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d9oGu1kE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d9oGu1kE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56708C4CEE7;
	Thu, 18 Sep 2025 15:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758210572;
	bh=8N6jci7Nqm0E0bHYwE12wLEidPqbwmOdkiYeA0kQmNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9oGu1kEJ5xItBCnMjK8GaG3K/tEHFC/Gv9APbhjjRRcorc85eZ7oKMweYyIerhW8
	 HUScDmyruj3gg5NYAxaDXrXb7y7pxxRWzxGF+whuEsNeMwH125bWhQffjyjbs59iyO
	 MPyxejuTYrmOZJEwzdBFMpivG5/EpQZrKEQL+5eiCXCHRLF+nQeLWHwkGFyvcX7/BN
	 wwQ7wVuIMGw00V4YpCyobAD4uIM8AcozYF63Up1WZan4PB7WX0J14UN/2y1xchPGWo
	 4H2SLJLJ1wc8MKap5oaKXth2/3bnROZetw9V/FzWHcDCOJ8AJvS1uK6+23IbwxK7pQ
	 tYCNyc6YFMSCQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uzGt0-00000007UvO-1ogX;
	Thu, 18 Sep 2025 15:49:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/2] KVM: arm64: nv: Fixes for handling debug, MDCR_EL2
Date: Thu, 18 Sep 2025 16:49:27 +0100
Message-Id: <175821056033.1666408.6464337816121098317.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250917203125.283116-1-oliver.upton@linux.dev>
References: <20250917203125.283116-1-oliver.upton@linux.dev>
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

On Wed, 17 Sep 2025 13:31:23 -0700, Oliver Upton wrote:
> As I was working on EL2 support for KVM selftests I realized that use of
> self-hosted debug inside of the VM is completely broken. Further
> inspection reveals yet another case where FEAT_NV2 does something
> insane -- MDSCR_EL1 is redirected to the VNCR page in spite of affecting
> the EL2 context.
> 
> The situation can be remedied with traps. And after implementing that it
> became clear we make no effort of honoring the guest's MDCR traps.
> Whoops.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: nv: Trap debug registers when in hyp context
      commit: 4a684088421d5a1ffb3b13243c58a9078c99e4b9
[2/2] KVM: arm64: nv: Apply guest's MDCR traps in nested context
      commit: 3af1105c4fa362d17d577b55d2b8a7c4609f16fc

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


