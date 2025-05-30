Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5F021578F
	for <kvmarm@lists.linux.dev>; Fri, 30 May 2025 09:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748597269; cv=none; b=mdYEht+QgZYD65xzS/9wSeN66pL9vDjxKbnrHRS5JUShPMrnCvAQt9dxZxdFBqoH8C7bhB9aLpL1EeQYnjfBpvXvPLS8BL2H7bU16qz7WhguRFJDPNfkBVY9XkFOS0SfUg1ff1Gs/2vhVe5hlw7IW4Lp7R8QvWrS6/WOD31sRNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748597269; c=relaxed/simple;
	bh=/ebqk5EBZxzGGlkyw6B6h4CC/MuDUNAPuwoTejd2tEs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=chRoGbmyXMy9x5C9W6UOtgFSgLdqyI+Vwdc+uY4sk+hhbs/uQOdXmY8//ppcBy80t3RQAKf1ToufEs3crTlQmOlIxV+t3OAop0qZd5v8ijzWUMeMxpxgN63rvZsQlbqOW6AjUNIzD5hNAWsqVs+bhiWvZ36i7uuMwpZYzO42KB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G36byAWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G36byAWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E304CC4CEEE;
	Fri, 30 May 2025 09:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748597268;
	bh=/ebqk5EBZxzGGlkyw6B6h4CC/MuDUNAPuwoTejd2tEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G36byAWVROT11g+bEvLS/8ozKuiVqs56Ag0r/SFA6WwNNrQv2eEsUY0fsxvvnESwf
	 ZiTV09ahOfD3LiNTveCaMEjxc3PKc9C7pjlvtNV/udzcOsqxiurIdrPx4P8NyD4d4a
	 o9RiZJPLbK1d6KXVSa+pdP2NOsfe5tqmCcDShAGZxBECV531Ov3DCO0gVbsT6DMzLC
	 DiIIVr6PICv1zvYwQmirQky5VwZyU0D07aptZdK6Y6E2lA8oR63pE0gPkD3aXCs1g5
	 DQRlmf8Zm6JbdkDkzRir4CL3P2SCcXnaGZ3wfec0pW9+gX8izhRP6odMsb06BUjbh2
	 UMzMynxIiEc2Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uKw1i-001oIv-Uj;
	Fri, 30 May 2025 10:27:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH] KVM: arm64: vgic-debug: Avoid dereferencing NULL ITE pointer
Date: Fri, 30 May 2025 10:27:44 +0100
Message-Id: <174859721253.1152851.15902065633561816989.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250530091647.1152489-1-maz@kernel.org>
References: <20250530091647.1152489-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, dan.carpenter@linaro.org, jingzhangos@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 30 May 2025 10:16:47 +0100, Marc Zyngier wrote:
> Dan reports that iterating over a device ITEs can legitimately lead
> to a NULL pointer, and that the NULL check is placed *after* the
> pointer has already been dereferenced.
> 
> Hoist the pointer check as early as possible and be done with it.
> 
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: vgic-debug: Avoid dereferencing NULL ITE pointer
      commit: 4d62121ce9b58ea23c8d62207cbc604e98ecdc0a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


