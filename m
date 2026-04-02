Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC5217DFE7
	for <kvmarm@lists.linux.dev>; Thu,  2 Apr 2026 13:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775137070; cv=none; b=Bys9V3ag98QJO1Qg4qIbNQ6HiIVwbZCNiC+CZ8DF2E32vas20trm0BvMGtGmO6A6JzsjKP4EufzzCoImIS9FdYsEnvADdN6TvwM2P/TOBNPZdF6Q+RWYKW9QBgjmitd03KDSbfhyWlLd+DY7u7qbvw0FeE2LSogHir9nlMgnM8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775137070; c=relaxed/simple;
	bh=Qzgk/iZjoZnwo81KZZUDeMH/+ALFpUHEWvzUVLjFXA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FunfiuvD7knlGJGKspZGihQ4z96tbxa3xcr6TjcSIB4QNRcfWT3xoJ/bEQc0jFlZ3mR1qgKCWt7T2/ANbYlFzSKW9suPRT7zMpBtRDkOdl6IqE8QC0XHYGIHwzrf3AX+modmPYVGRdPbwKOyOKjVU4Q2ROMEiQZ3y0bJY506zZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhyH76e1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhyH76e1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE30FC116C6;
	Thu,  2 Apr 2026 13:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775137070;
	bh=Qzgk/iZjoZnwo81KZZUDeMH/+ALFpUHEWvzUVLjFXA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhyH76e1jkbrbnWqDJDMSo9gyycWmrdVrQ3YUBzfe/Dcq8dyFSeIQrvyqo9i6eXeA
	 yk0IEZ7A9ARfXdiYWLiV2h6eShVtl9BRqrBRtAXuQIVYfODId/HSC95aoPUTYDhmxt
	 5ZiTsGsV7PotlJ+wg81q1LwLPnt9Jr3ffAEZJ1GQmhFd85xnBaFFRCgJ5mF4uMyDod
	 58hFjlwQR6OZgy5fTHN5cjAYMxxPGL8GNHwqwafecPg4/CdsqwpCF2oar5RyqSp+KT
	 26GpStoW70AGOJMdEsuxVOsw+Kki5dDpLLhh0RNDPao6wvzocJCM++yKi7ZUbJQQ8b
	 7T5ygAU7jMH9g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w8IF2-00000008H4M-2tGH;
	Thu, 02 Apr 2026 13:37:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] KVM: arm64: Advertise ID_AA64PFR2_EL1.GCIE
Date: Thu,  2 Apr 2026 14:37:45 +0100
Message-ID: <177513705965.454087.2424216826926153221.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401170017.369529-1-maz@kernel.org>
References: <20260401170017.369529-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 01 Apr 2026 18:00:17 +0100, Marc Zyngier wrote:
> As we are missing ID_AA64PFR2_EL1.GCIE from the kernel feature set,
> userspace cannot write ID_AA64PFR2_EL1 with GCIE set, even if we are
> on a GICv5 host.
> 
> Add the required field description.
> 
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Advertise ID_AA64PFR2_EL1.GCIE
      commit: 899ff451fcee1289f3f37d061da66c3e38748a69

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


