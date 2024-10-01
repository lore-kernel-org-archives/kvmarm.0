Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B5819D06E;
	Tue,  1 Oct 2024 14:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727792934; cv=none; b=ezJlJoT0+AGNMxuafPWHySLexjfac4B5UglTRkRcAtw0f/R+0pmSwbwTPEnv8jUV+M9Um/tTUlLsODnDWLihTzIk/xTptcJoeWB57XyjthlHy6h5QCRf/Kxgaqd+4W2Di+w20vupXMxB5OMEzGg1zTzLPqXbrUqcJzD9OOdjqt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727792934; c=relaxed/simple;
	bh=BfXFLlNKiq7zB8ABiOruQbTuJYh7ru1h5GVjgRxtnu4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DuUzF0afVADdzmye6NF/i2LiVFsMPCJGbac1xyHvyn3KD8RQkuQsWUgAnTceTbi9V5wdPt5QqFWL+BZM/g+3da1VCI9SZZGBccCEzAmvunCHVwqTk8AT6cyGEqk98Re7FzE/bqitk2z9iX4vXSLpuffDpIBaIFIDcXRMwIAnYyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=awZQFoKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="awZQFoKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B174FC4CEC7;
	Tue,  1 Oct 2024 14:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727792933;
	bh=BfXFLlNKiq7zB8ABiOruQbTuJYh7ru1h5GVjgRxtnu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awZQFoKoX2m3aot9qn/OsvWfaUQ5EGw8IqS8Y/Qj+W7aBnfd8lq+QvE6m+H9SG0L7
	 sFwIPsTzVHk8qC1ye78D8rPHJ84JHROUq7H+n3qzdXa3znnewH58S15yZJzJyOrAKz
	 JTh9Ct8PQKZVWQvn316Km+WxzxoXunuA8FAO8kl8uiJCNSqejBjJLG4tmrJrlP+Er3
	 Q8yOuUT1nwz/E/LHIvb5m+1/2XMuiwj2CsHbid+4IJA2z3MP2YPqmpTM8SyxCe4YWo
	 86QVrAiE2y9TNDajrEmJUoW09BXtf/x+N2tULrd+57twVDUAQ4GT39fE5NKQWVu69b
	 shFOLuFQ2sVDQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1svdru-00GmGt-GR;
	Tue, 01 Oct 2024 15:28:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Constrain the host to the maximum shared SVE VL with pKVM
Date: Tue,  1 Oct 2024 15:28:40 +0100
Message-Id: <172779288243.1647258.11526223607121965745.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912-kvm-arm64-limit-guest-vl-v2-1-dd2c29cb2ac9@kernel.org>
References: <20240912-kvm-arm64-limit-guest-vl-v2-1-dd2c29cb2ac9@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org, tabba@google.com, broonie@kernel.org, Dave.Martin@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 12 Sep 2024 12:39:35 +0100, Mark Brown wrote:
> When pKVM saves and restores the host floating point state on a SVE system
> it programs the vector length in ZCR_EL2.LEN to be whatever the maximum VL
> for the PE is but uses a buffer allocated with kvm_host_sve_max_vl, the
> maximum VL shared by all PEs in the system. This means that if we run on a
> system where the maximum VLs are not consistent we will overflow the buffer
> on PEs which support larger VLs.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Constrain the host to the maximum shared SVE VL with pKVM
      commit: a9f41588a902f386b48f021f56a4c14735cd9371

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


