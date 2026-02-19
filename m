Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC3D33A9C1;
	Thu, 19 Feb 2026 13:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771507646; cv=none; b=rKea9swOiR2JMmWWiJeto96GVCLPAvgRoCZ+d7zRhlrT6FYjnXoLOJDGK+NvbP6qc1VVcE9mnomp+DU4TXCKD3NMkTEW4bF30QNYsPn2Fp2SyeaJCkcHZVHR7UWLeiFlnoXVGD/ps8+ExdpOzn+BNrDgDEMV3PrLkuAX4BEsEaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771507646; c=relaxed/simple;
	bh=dCrBPubZIKcbvmgILfm1PhzeloMsfYN/6KzdN4upxjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BlyLTMYHYPbJzPspoxD6aWrKXszhj+M6gTFhLpJhBQh8VbSvy+IAImGFxk8959hDlOTlDyviu7NlC6klb7NPUyZ3pKdYTSy2+n6vUVGW/tNxFFT1ri4odbt0XhmL6xKgs9nB5uJ8X7ItqBYbsIHrRwRg7SESITpOEpbZS94yW48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iup8LWX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iup8LWX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06406C116C6;
	Thu, 19 Feb 2026 13:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771507645;
	bh=dCrBPubZIKcbvmgILfm1PhzeloMsfYN/6KzdN4upxjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iup8LWX8ognOvISD9w5llksSOwW3xkoq4ytdQwtwtRTKriqn1u6/Aj9VxoXNDsEsi
	 /0ndxj7apEWcVsezZ02z/cffyAh+UW4Uu6qoTRsLIHwNxalzk5aWXbdhVod0HoOFXA
	 thvLOmgzaa9+T3j7FlxQ4LT/7K00Yxs8bLoN26iSv2gIGxMv/aIbnwrueSmUvTf2EF
	 d+eH1gqbQdqHtWOFaSPtkOKTFjupXJteyxM1fE9CRAavnF+BdgfZXkdPPIvAP9CP7u
	 ryttfjXpMtj49qm1aAYuUkzwTrtQnVinGEI9p/J+HitNp7Ck/lnaMp8LIO2wo+qy0p
	 akI6aeJNUaX/g==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Hyesoo Yu <hyesoo.yu@samsung.com>,
	Quentin Perret <qperret@google.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] arm64: Force the use of CNTVCT_EL0 in __delay()
Date: Thu, 19 Feb 2026 13:27:13 +0000
Message-ID: <177150437545.2426887.1189373653228730903.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260213141619.1791283-1-maz@kernel.org>
References: <20260213141619.1791283-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 13 Feb 2026 14:16:19 +0000, Marc Zyngier wrote:
> Quentin forwards a report from Hyesoo Yu, describing an interesting
> problem with the use of WFxT in __delay() when a vcpu is loaded and
> that KVM is *not* in VHE mode (either nVHE or hVHE).
> 
> In this case, CNTVOFF_EL2 is set to a non-zero value to reflect the
> state of the guest virtual counter. At the same time, __delay() is
> using get_cycles() to read the counter value, which is indirected to
> reading CNTPCT_EL0.
> 
> [...]

Applied to arm64 (for-next/core), thanks!

[1/1] arm64: Force the use of CNTVCT_EL0 in __delay()
      https://git.kernel.org/arm64/c/29cc0f3aa7c6

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
