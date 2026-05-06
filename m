Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1511E48C8DA;
	Wed,  6 May 2026 16:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778084085; cv=none; b=GRpSskbU253P7hH2lEEV4EyYo0KPE53iCgd7vFWf+LAup2O19wYJWuL5ilqpSfV2BaVw55VbY7QDcNA33Ksh8lIMpVjEdqsx7XrkxAzzn+l+GBuY34Ng5MaQHH23DuV+f+7jbz9HWhSnch64s/F4aFfRwv5t3v9rPc81/ljFP40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778084085; c=relaxed/simple;
	bh=p4+NUlHRcOu5P2zipShb0qY76fjH/71ZYiZBLp82jYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b+s1ARqLjKihckG8PuW9A5volejsjlVAK9ukGjwy8RKyc2KFdXLkZj41b8OW6hIZ6opMs61ouo2TE5ne7FDPdOMNt02csEVLRIrZkMJnmrOsulJUuI5dCjfPEP9beX48RAtf+D0+fzJ6IlV4YXhIkiwfRZTSneT9gi2rMppZOYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WxYjBi5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WxYjBi5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26122C2BCB0;
	Wed,  6 May 2026 16:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778084084;
	bh=p4+NUlHRcOu5P2zipShb0qY76fjH/71ZYiZBLp82jYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxYjBi5OXUCGKu+En+S22iqTJt9058js756VEeEAmR4oTGD2eFOF++cRFGgQxn5dc
	 8k+7lehNNWppFImmmhsMbA1oe97CfisyW/KD3H/nSkJ62lS4diiTDdNZtDSDSgZctJ
	 vkKTu9671xOjZOJi81L2szjn7wpiUxwtTmwaKSpL5bopdnezVe+Cp25tTvTeJTQHgL
	 7QlSfa/TXz9oFUY0cOUHahSizXCKJCiBTbGX4cAgZ+jta3zQ5Ze6sbf7W0AxdVjCH1
	 xG4my8s8pLB4AkV2p+gsB6ecCZDvBFTzJ1IebKRhgt+gBAh2VdGA//Sgbss1Hp5BNt
	 gQytwPCI4lnuQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wKetW-00000000MIY-0Lm2;
	Wed, 06 May 2026 16:14:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	vdonnefort@google.com,
	tabba@google.com,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Harden clock for nvhe/pKVM
Date: Wed,  6 May 2026 17:14:39 +0100
Message-ID: <177808404898.2712489.96941803949912620.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260430103724.2151625-1-smostafa@google.com>
References: <20260430103724.2151625-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, smostafa@google.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, vdonnefort@google.com, tabba@google.com, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 30 Apr 2026 10:37:24 +0000, Mostafa Saleh wrote:
> Sashiko(locally) reports possiblity of division by zero and
> out-of-bounds bitwise shift in trace_clock_update().
> 
> Although the clock update is untrusted, we should at least have some
> basic checks to avoid the clock value getting out of sync if the host
> is buggy.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Harden clock for nvhe/pKVM
      commit: 9a624ea3f26f40c76bd2c7f77cde30659d42efbd

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


