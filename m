Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793111067;
	b=Mf0YCZta4VFWmQc5y9/MVF+KGNJyxgtWStn76k8ci0v+gcfiQye8pcwo4rfbhlJBt7Xc
	 Gf5shJ9NhagdrAsIQX6qvTl+I5ttigZI47bEaXCyAmQmI3t704TMS4J3cYcT1dmKbrzBb
	 DsSLSl3Uba4klfDWBaXlDnDEt7FaIf1wP64vlrPFzDO+CB6qdcGhrToXJfiGiZPYCxD7n
	 3o8LC821C7bx2nWrBU5wT+JBtpZDz8UcPqJULORIJAwtaEoGDrZWM4NyyhQpPPrv3RlDb
	 iaHRKBMcI69DiaTFiSiAiIP+RwMrgcSVV1hUGOT/cjJAlKWDictv6qFk0vVDoQPdXCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793111067;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=jwywrlpki9bMHHIBRrQFn5CCln+QEbHNkdjd7saLhsU=;
	b=NZHSMDdLWOlhNiOSfC+chGeR8LRczxyWtlgxPMV/kbbBpDLCR/0+luBGBmWrIQ4yHRDh
	 Oq/3Y+oubzgCl5xpFfakvfeBjAvHQQuFdK8bV+GNfFxPCgV9Mk9HDugdVBEueef3zjmtg
	 LgBXyT9M5p3kyaOohBbm5+Sb/6x2Qh8Xpy+5w8w8QgJUX5TMiNY52wJ1nCGbj6iizhOB3
	 zVGF00zl0hHHt7Pmv3y2cIZIVTQHvgm0HuoB+/HquyT9n0Rsx+i9YT+nCMyef48m35Ex8
	 4VKRRIM7WddPpibLge6oiJ09X38U7qA16ZVQuVpi9UD2KFcrud0QYApWDk1Tdx8+sFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UrCfeUe+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9478606A31B;
	Tue, 27 Oct 2026 14:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UrCfeUe+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCC41F01829;
	Tue, 27 Oct 2026 14:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793111067;
	bh=jwywrlpki9bMHHIBRrQFn5CCln+QEbHNkdjd7saLhsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UrCfeUe+fb3TmiBWvrRfzazy9kqW+cw4mJpuRy/iD27QfDHrJs+CYjvuCemQ1D9LU
	 KzBvECnAI1cG7LQLmeBcRdRb9qC+PlPw+WOPTp8C8cSMMrq3uAjgMmbG5e6W+rTOoS
	 IvJgLkhR4dcp848RYdR3/+yOQCKMvvpAmPxhe7BwbRbOoukZNovKujzpyc+cU2NZw9
	 bi16C2AYxa+UTIZV/jKLDxHOma+ijQ03hAPR40Bq11z+EbBKGtIOd6hoxCdKZJKQnC
	 Agd6K9KO0iXA9NZvxMkf6xViYvnO8A5QBdw5ctZjjgjzJO5InPQ/cwIQWsexqLhR7V
	 oAtq4FBvcV2tw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLi6C-00000007k8T-2lj1;
	Tue, 27 Oct 2026 14:24:24 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Eric Auger <eauger@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] irqchip/gic-v4, KVM: arm64: Fix the vgic init error paths
Date: Tue, 27 Oct 2026 14:24:22 +0000
Message-ID: <179311103723.2732161.15358895757190897834.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260921072958.2918477-1-fuad.tabba@linux.dev>
References: <20260921072958.2918477-1-fuad.tabba@linux.dev>
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
X-SA-Exim-Rcpt-To: oupton@kernel.org, fuad.tabba@linux.dev, tglx@kernel.org, eauger@redhat.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, Sascha.Bischoff@arm.com, sebastianene@google.com, yaoyuan@linux.alibaba.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 21 Sep 2026 08:29:54 +0100, Fuad Tabba wrote:
> Changes since v2 [1]:
>   - Patch 3: a vgic_v4_init() failure now frees only the SPI array,
>     since that function unwinds its own state; the teardown label is
>     for the routing failure. (Yuan Yao)
>   - Rebased on kvmarm/next, where the routing failure already tears
>     down the GICv5 state. Patch 3 moves that into the shared label, so
>     the SPI array is freed on that path too.
>   - Collected Reviewed-by from Yuan Yao on patches 1 and 2. (thanks!)
> 
> [...]

Applied to fixes, thanks!

[1/4] irqchip/gic-v4: Clear the domain and fwnode pointers after freeing them
      commit: 1fbdcc13ab303987048669c73134352ef5706666
[2/4] irqchip/gic-v4: Unwind what its_alloc_vcpu_irqs() allocated on failure
      commit: 6b44f7777ee826360714044b1a82fbdb1388304c
[3/4] KVM: arm64: vgic: Tear down what vgic_init() created when it fails
      commit: 25993ec8c5bb30baa746936d7a76f03c58150927
[4/4] KVM: arm64: vgic-v4: Restore nr_vpes before freeing the vPE resources
      commit: 99ec74a33d52219f57cc61a2bc7bd5114cc997b0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


