Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CF317D6;
	Wed, 17 Jun 2026 11:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781697071; cv=none; b=hATW8+I8YeQQegLKwMIsGsaLUN1SBmO0vLPTAwRWdwmT01R43ylyW6IerfdL6QWrMawdEEOU2MSWqekmiSEMvedQ+pCXnR/Jt1CEhHrMsfY+A8hsNutyUQeaHOm7imGwqa7laHkgfHyIiLCxc9kQpVXp54GcIsG3UfBk8JHbVYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781697071; c=relaxed/simple;
	bh=vns+039O0jHdtzbx3h66I0TWFAHBaG0KYA0pcgwf+w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tOwE1IT40oc5kCP0KLztLnSRTSjJmBEDanQTxL9BiO+CgcyfMUXpIkqsWhVMCOrKjlv/Z1lqtTpICAEo+R+WctbJkNyLGck2okFuQ+S1GhxSnrumeJpB9m06MhLjgzWeQ37kv7Yrwx0pKL/edh3GMLXt0Y7vFuJDFqadXp0nGCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YeVNNSG5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YeVNNSG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45961F00A3A;
	Wed, 17 Jun 2026 11:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781697069;
	bh=KUfojMQDPzmAt1rWIlxXmoX+yM30rHIm3OhZbGuSpZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YeVNNSG5AMeK2eJFTF7hfhnSt0+7AyNdcyPkovOAamU8CxKwxQCaxlfi6Kd+q16oD
	 yToJD8TJOGoyMwJBRy49lQ4ABDTEL+BfJ9uXpCheW+8bzIHgvBtAptlcByIBm5BBHq
	 74lmwDkGVTdyE0qnPZh8XF7HKMNIQ4gXwDLxKb3izqdKhZwSlWtI3HuXeei3/BSKVL
	 ahWl6/DT3IUgntQuHIPW5C/1wqEpTlBXlpoLyAVrjn+BTtz7LFxZke36wr2odlj807
	 9RbsN1wUUAi/eTxM59kBZrZJajLk4mgXz/oZLqY1RYgRfROnmWuaVgu/mX9KDM5V1M
	 C/b0PmNnumBSw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wZonU-0000000DfJJ-0Krr;
	Wed, 17 Jun 2026 11:51:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Hyunwoo Kim <imv4bel@gmail.com>
Subject: Re: [PATCH] KVM: arm64: Handle race between interrupt affinity change and LPI disabling
Date: Wed, 17 Jun 2026 12:51:05 +0100
Message-ID: <178169701870.3049015.7729065316776992526.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260615181625.3029352-1-maz@kernel.org>
References: <20260615181625.3029352-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, imv4bel@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 15 Jun 2026 19:16:25 +0100, Marc Zyngier wrote:
> Hyunwoo Kim reports some really bad races should the following
> situation occur:
> 
> - LPI-I is pending in vcpu-B's AP list
> - vcpu-A writes to vcpu-B's RD to disable its LPIs
> - vcpu-C moves I from B to C
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Handle race between interrupt affinity change and LPI disabling
      commit: 7258770e5814f15e8308ebda82ac9acf6964ba8e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


