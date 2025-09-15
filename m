Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201BB1E47B3
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 09:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757929852; cv=none; b=JWbwQZlFXy1M51HRIxEEfxRz0+TFKy38Uwux67mWVkp6SjlMMl5AMbjfTWmZ4gWlGvjpos+YnsB3lZel2c84QFsybcyfi9GUZKIs4kw2yc8nlkAmjvBmRebJCB/Xd+5/m8DnhHFbcnvtxukW0Nggur2akKYIddwGyztqw0eaeds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757929852; c=relaxed/simple;
	bh=Oi62lywdDLKkKygUTfWGFHwFeq/dkJsnfIBR3CLOMG8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YduUMdlEKS7honrhHdqVqvVm3uVhjPX9w7kw3vziYMmZTS9jChf43Qv9+Lf2Dqa3LW+j4oIpg3JVkhDOUZTVceEAq2pTatb7979k03iUQbRqyeZAx9NRdbILr70/YvWRg35YJ7MUjVlcvBn2jskINYpnEXPA3dtSivr1xLiclus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tbyR1yVc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tbyR1yVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC335C4CEF5;
	Mon, 15 Sep 2025 09:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757929852;
	bh=Oi62lywdDLKkKygUTfWGFHwFeq/dkJsnfIBR3CLOMG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbyR1yVcylRKlSrNl0nReGo3ggSA0LVb6GVj5wea81t9vI1pQU0JN+HFGrbtLCVEi
	 X3dwfItwNIsY0hoKMHcG1KrYrPoIvxUBgrNX0BZVVOzp6y5SkVsxXf8MFonq9bBY0V
	 u35v9N1g3MJeGIKS2lHkAoC2fqc3fkMdCABYC82TVidTXgFXMY0xfEFG+OPOAtIJH6
	 DHiG+HgGb3ALsmc7BXu8QbjWe2TPoaDLt/1VCbW/IVuZUneQjte8t9IAEaUFxE7zMi
	 LMqiFujiupsci11e6qGAv62sntNc26l2GIHN7B0ICETp7rVVqtmHDmKc/FV5tYavet
	 P0oSUPVQjHbBQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy5rG-00000006JVk-04gs;
	Mon, 15 Sep 2025 09:50:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <tabba@google.com>
Cc: oliver.upton@linux.dev,
	will@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	broonie@kernel.org,
	vdonnefort@google.com,
	qperret@google.com,
	sebastianene@google.com,
	keirf@google.com,
	smostafa@google.com
Subject: Re: [PATCH v4 0/9] KVM: arm64: Reserve pKVM VM handle during initial VM setup
Date: Mon, 15 Sep 2025 10:50:46 +0100
Message-Id: <175792983912.521298.3255691890570537685.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250909072437.4110547-1-tabba@google.com>
References: <20250909072437.4110547-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, tabba@google.com, oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com, qperret@google.com, sebastianene@google.com, keirf@google.com, smostafa@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 09 Sep 2025 08:24:27 +0100, Fuad Tabba wrote:
> Changes since v3 [1]:
> - NOTE: only the last patch (9/9) has changed.
> - Fix bug reported by Mark [2]. The existing call to pkvm_init_host_vm()
>   wasn't gated by protected mode being enabled, unlike the call to
>   pkvm_destroy_hyp_vm(). This imbalance caused failures in non-protected
>   mode, especially when creating and destroying multiple VMs. Tested
>   with kvm demand_paging_test using nvhe, vhe, and protected.
> - Rebase on Linux 6.17-rc5
> 
> [...]

Applied to next, thanks!

[1/9] KVM: arm64: Add build-time check for duplicate DECLARE_REG use
      commit: f9ac33e45d57bc4aa365363ffb650c830e5bb325
[2/9] KVM: arm64: Rename pkvm.enabled to pkvm.is_protected
      commit: 58dfb66b1e4cfb998db9e71437a2c0d9b83a93c0
[3/9] KVM: arm64: Rename 'host_kvm' to 'kvm' in pKVM host code
      commit: 604a5032b454bde03200d755f6ecc3f724511c6a
[4/9] KVM: arm64: Clarify comments to distinguish pKVM mode from protected VMs
      commit: 070362648f5f546018747a9a1857c1597594934e
[5/9] KVM: arm64: Decouple hyp VM creation state from its handle
      commit: 3c45b67625357ac680ee2508493b697cdcd78128
[6/9] KVM: arm64: Separate allocation and insertion of pKVM VM table entries
      commit: 1abc1ad52989fcc45a0de68bc49656d9fd0c2d74
[7/9] KVM: arm64: Consolidate pKVM hypervisor VM initialization logic
      commit: 814fd6beacf3c105ab8c8796be07d740952899fe
[8/9] KVM: arm64: Introduce separate hypercalls for pKVM VM reservation and initialization
      commit: 256b4668cd890b741c54f83dbbef76ba847c23be
[9/9] KVM: arm64: Reserve pKVM handle during pkvm_init_host_vm()
      commit: 07aeb70707b1d52968f4959a5dba321ea4219c8a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


