Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B2D1F5F5;
	Thu,  6 Jun 2024 07:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717660535; cv=none; b=gISjIM5qTpwzWKvs3hTLR7JXc0yZ5qrSAp3H6Lzdssv2H6s0NIY0gA6nafKy4+RkVHN4AHU13OWtue2SACr/8lGmA4lOzlbpjDm2MKAZEC9EfvijgcJnvLvVneni7ZYxNZht2n3+fBgyU6+qfNkrF13i70h6KVnk4MD4EUkU+fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717660535; c=relaxed/simple;
	bh=k1drabkzVURPruHQ7cFwt9snaV//tKgwTZ05eYyRRmw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rg3QVmmi0ZkXoAmIszG/pm/6pN1NX2fWvANcMFkiJX8V/q+lw89hP26ubE2QfqCpHWZgWGjiZ2KFforxVbMXXSfwRD+viZJ45yxyd8cxNOZuHN7JXEleESCQjQJLCO2maCX7l8bkl6gq9t0hK6ZX1wjN7eRCdcJ+J4YwHePCHw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sJhsI+37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sJhsI+37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2310C3277B;
	Thu,  6 Jun 2024 07:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717660534;
	bh=k1drabkzVURPruHQ7cFwt9snaV//tKgwTZ05eYyRRmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJhsI+37H17NM9VLnBfD6+eADmySbg4blj3JjQIu/ANKYY2dV3MNyEaAyMr6kBhaF
	 jKzaPd22DgyT0MDGKZhy7L+8m4/JjQpE+ETh89v5yc8BypQJnsnJWlLsb7xtzkg0rV
	 iXr3ycHbNNWHLP5U+apDR+433L+tTJqstirLmwEoRm/drmTBD6btXJd0hDTKl3CifH
	 FrA3KPOIgOaWHMSrEnbcgI2LenLU4jnqqFJQYy3cpw+iMRlZk9ECERZxQ7LPpyuUZH
	 RCUvQJvwBsNfpwRDVhSvLE6in0HIuuV+tTlHx5nJ7IkAYmeHygeZ7sK0jgQhS0JkYK
	 6ENFOEHZ5rq2Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sF7y8-001Csv-49;
	Thu, 06 Jun 2024 08:55:32 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	glider@google.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Disassociate vcpus from redistributor region on teardown
Date: Thu,  6 Jun 2024 08:55:05 +0100
Message-Id: <171766050034.1641840.17955474220978769285.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240605175637.1635653-1-maz@kernel.org>
References: <20240605175637.1635653-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, glider@google.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 05 Jun 2024 18:56:37 +0100, Marc Zyngier wrote:
> When tearing down a redistributor region, make sure we don't have
> any dangling pointer to that region stored in a vcpu.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: Disassociate vcpus from redistributor region on teardown
      commit: 0d92e4a7ffd5c42b9fa864692f82476c0bf8bcc8

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


