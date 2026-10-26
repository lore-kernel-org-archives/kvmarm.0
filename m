Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016080;
	b=T3Fx8hAAd6VY37TGjhAtUS263s1NhM46ssa4yOZmZ8d/udHEY1T1/Rp0+K4ja79FC6+A
	 tg84YEfZprNSF52HbOsgr2RpRFYlYx23X0UU5JqGQpJFjou5i3tlrNr3+yNnd3gIU1uF3
	 iVp3bkZTUdo3B5n2+s5Z3sNx13I5nm9MHQBj4nKfWaFWR2SIHrbwbOX3Kdd22ygiEu5Hu
	 zwGv+NZp8M5Y2gV+LMf+dPuOaI/AJHNE+dmdYg8q2Qn21TTBIFGUNWifC4vyBv+pYlhwe
	 aJo0ODCpX8CFPJ4S3uSJAGOlIhbyFW/2T0un778J2LVsU6nefjMEKHkaSm0d9ZCobBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016080;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=wlK4J5+u27LNMsvRQXEEEMIC66E4N0DC/9wfhCw0BeY=;
	b=lF4vBdwH7cgMyyihdToMbMf70aMEovpK8fsVg9yYA20iBHDBBEgUXDTb66jSk+BGdt/n
	 wMRFLcqBVNjGYcj2ESO9QEKZjGxOtaXsqw6mWjkFLiPmvdP2PshOWO0mygVrI4NTfdCT6
	 fW6m0Wyk9YVB20cfw9MpQGPQCNsiDkJcZJhA1agmMAeN4lZvNXFxWLxzm5YXzkv7T29F3
	 F/4pjDpCMQ2kqsvz105x9dZd1fOJbzRj73hqg1i5wbxEpZJF5KlnwzJvpYSVa3ev/GGcd
	 9bh0zI8xVgQ82UeMG4rRRbwaxOMJ5jCcsV7kNVigd1EcTsC9mJvgDclBpnacpLc72gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jbyzkPZe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2453606A33B;
	Mon, 26 Oct 2026 12:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jbyzkPZe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70501F01828;
	Mon, 26 Oct 2026 12:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016079;
	bh=wlK4J5+u27LNMsvRQXEEEMIC66E4N0DC/9wfhCw0BeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jbyzkPZe6foy50XtTP9CpXx4hvabTiJl7PmzZzs0+hz/Vw0IYK/3YaR4jznmU4gE6
	 owoMZot7uL5NWe8yELeqdFDQjlxc0uUAm0TvfYszXhYnYCUpeXba8jiRRIwLb9yWiJ
	 s1TasvE9jh1C6EmxBzBlX3swxc+3anPAy3marb64KvJOm4UhvlRb1zHyR+oJsVjiUe
	 r7ecFk678xweiS/cW0IqMNtwxIcpV/jBszlAEZjT78prDnnhg4rebyVRH1C0GXDORm
	 CJumswHuuCm1ozrecgRDPAt4WpDRF+aTyL9St/PaBKOI1Uu7qmNlYJyYTbrp/eGlq9
	 zX6Ba+OQNZerg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLJOA-00000007Fr6-0Y6d;
	Mon, 26 Oct 2026 12:01:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Take a protected vCPU's TWI and TWE only at vCPU load
Date: Mon, 26 Oct 2026 12:01:07 +0000
Message-ID: <179301587188.2527370.14948250574472478110.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261017165204.3343275-1-sashal@kernel.org>
References: <20261017165204.3343275-1-sashal@kernel.org>
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
X-SA-Exim-Rcpt-To: oupton@kernel.org, sashal@kernel.org, fuad.tabba@linux.dev, pbonzini@redhat.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, vdonnefort@google.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sat, 17 Oct 2026 12:52:04 -0400, Sasha Levin wrote:
> Commit 06499de8f998 ("KVM: arm64: Skip fixed-feature state flush for
> protected vCPUs") moved the copy of the host's TWI and TWE in
> flush_hyp_vcpu() into the non-protected branch: a protected vCPU takes
> them in __pkvm_vcpu_load() instead, and only VSE comes from the host on
> each entry.
> 
> Commit 04447b95c62b ("KVM: arm64: Use the host's HCR_EL2 for
> non-protected VMs in pKVM") was written against the old code, where
> both VM types took TWI, TWE and VSE on each entry, and kept that for a
> protected VM as PKVM_HCR_EL2_HOST_PVM. The merge of the two applies
> PKVM_HCR_EL2_HOST_PVM in the common path, so a protected vCPU takes TWI
> and TWE from the host's vCPU on every entry again.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Take a protected vCPU's TWI and TWE only at vCPU load
      commit: 5b34f0b4adbf983174e53721f68b617113376f2f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


