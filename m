Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501AE2749FA;
	Tue,  6 May 2025 09:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746522479; cv=none; b=R33Y8JFxBSGAJe+fNdBIZaTSU9cUomw6OGGvwNV9Hu1BuvmjizYKcfTBHlX9III5AYG0gYWnp050JSqiixv9dXKrxPSgd3UK5AMW83ediJTZc0wHTmBdKBD1lPHzpfNzw61mmMJRFAPNZhYu2F0jrr6crsNtaSQTe0HHkpJD2zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746522479; c=relaxed/simple;
	bh=j31e8lcl30uAslMTPj/lN5w+liDEy+pA614g2Hzy8sw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hxe7S9XybiEeXdvABNEJdgVdt3V/9yYB/gTy24yGFCO4e43hz5x81yW0pYQAAL2VGpYwsqAFuPjJiwA+A20sPxKPhMh42E2hTKMkPwLkkwDKz7aWHnpyZp8CMCRE92ZOqHb204vT9Q0iIyr4FOqIB0ZEgRzLEwT1ETkHz4BvcZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJnLKHHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJnLKHHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6776C4CEE4;
	Tue,  6 May 2025 09:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746522478;
	bh=j31e8lcl30uAslMTPj/lN5w+liDEy+pA614g2Hzy8sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJnLKHHtHYU4BaA4zZ1CuOfgF4Wo62bsGVQG0zV6WPhIlXTOc3LfqPvVc4K5XmQyb
	 1pbV9Ul5k1OAnyepdlWtjUfq3hwyGWwIJTUYaX+EAG3VPfO6KeLX4MLjiKPOCnqZrg
	 xDwDxJq8403qq7tbu7W2/hFVzsshN+7fnHmWJmUn6bIhHWf2kyVOmrcAGpq8NzFTFS
	 ShWN0HG4FiLEp73mxWsMaF9NaiN8fC+gjhF09umy+uO6SOI10I00i5j8/XHMF07lyG
	 2oZL1EiBOMrCWcydGbrjoZ28IpPN42fH4Csim19QQjXYxzovbxdFNeSMwkIwxWfVFL
	 AvPYBOJUq8drg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCEHM-00CA0o-Kp;
	Tue, 06 May 2025 10:07:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] Selftest for pKVM ownership transitions
Date: Tue,  6 May 2025 10:07:50 +0100
Message-Id: <174652245698.339986.17396989011310666690.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250416160900.3078417-1-qperret@google.com>
References: <20250416160900.3078417-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, qperret@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 16 Apr 2025 16:08:56 +0000, Quentin Perret wrote:
> This is the v3 of the pKVM selftest series, v2 was here [1]. This series
> depends on [2] which moves the hyp tracking to the vmemmap. A full
> stack on top of v6.15-rc2 with everything applied is available here:
> 
>     https://android-kvm.googlesource.com/linux qperret/pkvm-selftest-v3
> 
> Changes since v2:
>  - rebased on top of v2 of the hyp-state-in-vmemmap series [2];
>  - thanks to above rebase, dropped the PKVM_SELFTEST kconfig option and
>    folded the selftest under the existing NVHE_EL2_DEBUG;
>  - fixed commit message of patch 02
> 
> [...]

Applied to kvm-arm64/pkvm-selftest-6.16, thanks!

[1/4] KVM: arm64: Add .hyp.data section
      commit: 74b13d5816c9389381e937b218f49f03921f87fe
[2/4] KVM: arm64: Don't WARN from __pkvm_host_share_guest()
      commit: 845f126732a8126dee3f15855487121f4836131a
[3/4] KVM: arm64: Selftest for pKVM transitions
      commit: 6c2d4c319c7db7be883428ae1161502f3f690e60
[4/4] KVM: arm64: Extend pKVM selftest for np-guests
      commit: 48d564507293082c370a5fc1eb3d73ad3de30561

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


