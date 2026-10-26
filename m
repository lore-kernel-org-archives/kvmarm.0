Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016079;
	b=0B2Q6xAoCgY4iXY6XxxVrOjwJMcfwjyyX6IPEaTJCau0X7nbqrE8649lNSx/ndXPyNAx
	 +zTpiI+Nblt02EM1Tcuemr8il/+UJvbvmdH5s+NNRb6q1PfdVE3cM9t430FytS+V1VSd2
	 2BDV2q70R1NBbaoqwmNalxNKfBtUAaTrkR97PJMsw9MaofjhPi0U9A/1rnl3wmUtqzTPg
	 0umSbN6OgHavGVMCk8wBYthraGY19ShJQi4hduGexfvcUiXOmJiZ38BIOoIzhSbZJ7s28
	 g4XgA1gojU33ZhDR8vVwKL8gBsvuYpfutO8ReZIi1lTsZplm/P5mC7GRRaOynl3M7lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016079;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=vxZ84y/v0ROAkqwdYRKaaVq1PVyc3FNXCyfgsxU59Xk=;
	b=2jFEQsicTi34X/oWuCtoS/QQilitn+iJGbkRDfygxDQje7DI+pP06KIsws8tyujr/LHi
	 lo1onmQh36eUc4HMVQwJrprvW6Z0EZZNQ52H5soK8EEld6k4ecDSHYBViUJILnj4y5H6s
	 Ls3bgWWzY6GHWmQCVJtpUKLZb61we/TQVZl+Ey8z8mckx3mJWbf9RDYw/2Pru6M2zupzB
	 4IF1nDTpWQGHWFTJl7kzwbrXYA+saySkLJ6HD7Z54rCKYsu4RcbMLEYTfyjh22LeybmV+
	 OYBRp1CTTLkJOxfQgymvpOmSy7RFy2m3PQQSPeUyFnELGueUm2uRBiR4aRHxRHN/QUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64181606A321
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 12:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9181F031ED;
	Mon, 26 Oct 2026 12:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016079;
	bh=vxZ84y/v0ROAkqwdYRKaaVq1PVyc3FNXCyfgsxU59Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjkSKlC398a6ND7aRWe0t4HTOVqLBQ+/gKOZNyt5CXwNimMz5FkvqH+oLXxk/eTAg
	 Eu2Uvzm0ryqGgDjm+m++Sxo6DFIE+iOE3f3OQsIs6egg79rYgAWWJ4WDgPY3JKvC1/
	 BQbrCKBLxp3umJG67ECSRp6isgMB5Z8W7Z50+81s2O2N7sxfDOd39Xtsv7+r8DGiqM
	 tZERtMDdWeIukQIXd9uO0fKs8qmKr0S8xUtXdWLwQK6kDNSLGSFi/+1fK3x4JxIrRc
	 bc09gNfqD0MAomRjvPrFmHadN3JB8mxneDBEYyv2o8CU8sBHS1BMzn+iQqAdEdRfrX
	 amUcxArJGk9sw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLJO9-00000007Fr6-2ThD;
	Mon, 26 Oct 2026 12:01:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: oupton@kernel.org,
	Sascha Bischoff <sascha.bischoff@arm.com>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] KVM: arm64: gic-v5: Drop unused addr variable
Date: Mon, 26 Oct 2026 12:01:05 +0000
Message-ID: <179301587208.2527370.6364647605927514096.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261021082204.1494581-1-sascha.bischoff@arm.com>
References: <20261021082204.1494581-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, sascha.bischoff@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, lkp@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 21 Oct 2026 09:22:04 +0100, Sascha Bischoff wrote:
> vgic_v5_has_attr_regs() assigns reg_attr.addr to addr, but never uses
> addr. Drop the unused local and assignment to avoid a W=1 warning.

Applied to fixes, thanks!

[1/1] KVM: arm64: gic-v5: Drop unused addr variable
      commit: 576a1b5ab4b8be03ab5cf7b41b475850795e3fe2

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


