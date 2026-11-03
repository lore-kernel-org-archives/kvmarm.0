Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711179;
	b=2n2zNGaSljeqvaw+Lh4P92e9O67SpG14C7OOVlzQ7wUQwrfh93f9b763Kfj7b0Bo45mE
	 gYIZ+CaQH33yWjM51XKUEFN24g8qCrV6KnmRj5JfJElrLf5TsDCHVAyiY0RLNMDH+aZyS
	 XnE8nPLgVmaRf9GRdG6ifmWqCz0xXYR/jdN+rMaAj1LKS+xMIJlZzha7iEHKEZ7IOSt6w
	 44zqGRHd/yMzQgaC8tB97GNFLvntbQgjeJmRfAoTtal66tJPvG8F+0jotY17pZ5iNYH15
	 P68J25xAiVJoJudkp/C3rlNM8yJ92spvto4HwJD7B2b3lfOOmMy6/vQyk7vE7GuIyOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711179;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=rGq3BFd/+B7P9vI1bpgAX9feA3OyMCXcQKhqEkCS1rM=;
	b=goDIlK5wtazkcPWsWPW3Y/oZjAnGjGFHFrS3NemW3lHwkKnS1fuHrGwYiGUt9nHOR1ie
	 w68r2AKyVQL5jhEoYSKxt9ezG6x3kx0uDrZFEmEtLqxCN0Hr+IXvsEqjicA7Jd0mXdkZ7
	 7VS4QgpdsnA+fyxi0XGqsKWNzsuD3kgrXotK6bNJSIAIYi77yJONJFEoRrPYrdP30MdF0
	 cwu3C8CKK6rlqosVK6svupnloBtHNyNRFR2hBraFrBWnOb5ubCkjDOTTRmbIiiWV/Lqn5
	 VB1c2HVTtMf/d4V7FGcf+o0HwjYbh2VqTPMquhbelWASM1U7X8OJeWdghKhTvygp15A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bKzeSrpZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B640606A328;
	Tue,  3 Nov 2026 13:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bKzeSrpZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACE31F00A1C;
	Tue,  3 Nov 2026 13:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711179;
	bh=rGq3BFd/+B7P9vI1bpgAX9feA3OyMCXcQKhqEkCS1rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bKzeSrpZBD/FDvBjIxoyxU43+9fHS9P6oNrQ0Y8TGiObRJL1si8STS9hUza1EHBGx
	 x7l9myctHMlHNo5UHogePR19WVXsmU7sfAZ8oZeVOpJRW4ixTxocvft0kpL85q9b17
	 JcXysnDx+Fy9eLPwNkRaL+Zrl2kuJH87lLkfPXsJuOn2pg5rbhzZSnD4gFmYVQKRad
	 l/Lx+AxoyUgPWzgVMn02R12T8pd/nfsal3lN50qlQn/83ZlrUPfDpdAKEDCvBk4tlE
	 F4t4peBgT4F9OKwUwcIjC/75hXc1EPMZe9cuyxPMGlVwYnit2WDwTS8AkGc7nMPc6F
	 U6gPNVE89yGeg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEDR-0000000ATWs-2wl5;
	Tue, 03 Nov 2026 13:06:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] KVM: arm64: vgic-v4: Don't allocate vPEs that a VM can't use
Date: Tue,  3 Nov 2026 13:05:31 +0000
Message-ID: <179371111249.2844725.8495619581179342527.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028101318.2170928-1-fuad.tabba@linux.dev>
References: <20261028101318.2170928-1-fuad.tabba@linux.dev>
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
X-SA-Exim-Rcpt-To: oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, rananta@google.com, eric.auger@redhat.com, Sascha.Bischoff@arm.com, will@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 28 Oct 2026 10:13:16 +0000, Fuad Tabba wrote:
> Changes since v1 [1]:
>   - Gate vgic_v4_init() on vgic_supports_vpes(), split out of
>     vgic_supports_direct_msis(), instead of open coding the nASSGIcap
>     check. (Oliver)
>   - Use vgic_is_v3() for the GICv2 check, in vgic_supports_vpes(). (Oliver)
> 
> Two fixes for vgic_its_create() allocating vPEs for a VM that never
> uses them. Nothing frees them when the VM is destroyed, and each
> doorbell handler stays registered with a freed vCPU.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: vgic-v4: Don't allocate vPEs for a GICv2 VM
      commit: 1995650e0a5eb29f624e9b3e4afe487541bfd3cf
[2/2] KVM: arm64: vgic-v4: Don't allocate vPEs when userspace clears nASSGIcap
      commit: 6ade9467e37149d62ec704d1a03d52f334906f13

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


