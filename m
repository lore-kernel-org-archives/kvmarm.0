Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E281F2BE041;
	Tue, 30 Sep 2025 09:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759224493; cv=none; b=es7+qNmOuaApDvyAhT/Nt2BNZPOqVHlyn6LAzWg3KLKQP6wu11IQj3Yo9dFYAOz8sPqvs/WOhyn3DzWbZssxIgsGnUmOeps9RwUzLd3i8snLBnN1Bq3+tUf54DDvJrts0EX1SKh49moGaFkP+/NSXdeN7bNpZcVEIXGRI9S7W/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759224493; c=relaxed/simple;
	bh=x8Wb2+R5Vp8+oLSCVFZXSVkEEpjiAOZ6ebwPO1lk0C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iDdblwsoz6ZTB5rQeO+OXntTImuFwsXqT7mFCjwhmI+Mcw8O8UlnANJfrha312tf9cMaJjRJFD3PUPH55SGi0c6j6wAIKgX+FqxL0lEc2nBT4mCIb9fJebHf5YcpJWZGxMKVOC6FxI8RZXbuxn1wtTbzBGagpF5VJjtyr1wNMRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZRPxRpiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZRPxRpiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816DEC4CEF0;
	Tue, 30 Sep 2025 09:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759224492;
	bh=x8Wb2+R5Vp8+oLSCVFZXSVkEEpjiAOZ6ebwPO1lk0C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRPxRpiHmerbXwiX2t4DbaH6qmUm/UGsKxOltMyW43uvzMEP4nvQ4CkdpzrOkyrH1
	 VnwBf71tKFxTtUEqyWgovQYGoQXwOCLEUmXl8dsPSdcHQhRHn1RXO1wDhDhQXnNVgx
	 YAy8h+6YkihvYWZ9XZB6rTkWHFNscTdBQ1XWecYo4687YP0wt19G4fKIpnF1HtHo0g
	 C3edxIaCIeoVdQKK2TVKBiaWugpVni2RES6zM3weRE8VZ7BPquZBFGKIYCbniQHw/a
	 bdZ7Vj0HJn2Z5S+DQYz+n8lot/ITS5AVTIj06tF8Yr/ZuntQqWQaZlCu50KRgKhImr
	 o3OO7s+SSBfDg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3WeY-0000000AUoH-2Arb;
	Tue, 30 Sep 2025 09:28:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Prevent access to vCPU events before init
Date: Tue, 30 Sep 2025 10:28:06 +0100
Message-ID: <175922446769.3360577.3691458337936348623.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250930085237.108326-1-oliver.upton@linux.dev>
References: <20250930085237.108326-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 30 Sep 2025 01:52:37 -0700, Oliver Upton wrote:
> Another day, another syzkaller bug. KVM erroneously allows userspace to
> pend vCPU events for a vCPU that hasn't been initialized yet, leading to
> KVM interpreting a bunch of uninitialized garbage for routing /
> injecting the exception.
> 
> In one case the injection code and the hyp disagree on whether the vCPU
> has a 32bit EL1 and put the vCPU into an illegal mode for AArch64,
> tripping the BUG() in exception_target_el() during the next injection:
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Prevent access to vCPU events before init
      commit: cc96679f3c0348bf8450a5c84b71bb1351c027f9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


