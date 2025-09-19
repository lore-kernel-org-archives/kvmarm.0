Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512231EB5E3
	for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 13:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758287732; cv=none; b=Gh3Alsth+I21gQVGsOlVYA2yevYkj/247Ynz2fAlgig7CFPawbLrxk7xHBP2fZwMIKK6t+4tCqIfj/Mv+PokTsIePgqByaM50VVCmDSXfC4S41F2jDu4oKJMgkeOWmQDtpuUGvsklMFQ6L7oE6Y6xfAQWcgztrajucDCX3BS6EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758287732; c=relaxed/simple;
	bh=KQmLig4/Iha5njfgbx7WpOZfsPdfPlyo3BasFv3XG+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CNEsns+ndv835wWRK46yu1rXIeoeE/6bQRkdHrD3Bt3JMvF0P0+34fZRGDd9ygTG8CONY2NBkxaUUyWLZNnzKLNKTbT8fTojDWwutRCe1pspgycxL0mgGBUooWhwyTTvihLlMkSQ82EMaGGYNERBnobqGuErS5E56CM9n67f7i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHQhMBin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHQhMBin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C3CC4CEF0;
	Fri, 19 Sep 2025 13:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758287731;
	bh=KQmLig4/Iha5njfgbx7WpOZfsPdfPlyo3BasFv3XG+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHQhMBinB8x+15ZHd8LolitS1gTMCptmBTcDBdOo6CjJAST4YHtv0zctFcXVO/lk3
	 dkvR+zSo88j6F9KrtYYB+tblQ2ewdDQ5KNWFfm3wK5AsrV9axIyJykfply8a3oPJXy
	 01deS+hKEu0Vu0A1PVLay4MfIBvUIeRPdUO9w1dtGdOBdkCGeOnSbw9VkLjZFk4WXz
	 hSjHl5eg8cE5/d5X9XRr5/hb1FM2/HI3DWLLk1sQPfKRMJVttVu5Wn4+ahwyUnpFX4
	 cj/WlpjbKhVUiky/oDpMUsMd16jTkV8eINAHsT5uujK46DukeZYsXkmNp7TPTsVJRZ
	 jYexeC0CLkGYg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uzaxV-00000007mhV-2ITz;
	Fri, 19 Sep 2025 13:15:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: Re: [PATCH 00/11] KVM: arm64: nv: Align feature limitations with current state of support
Date: Fri, 19 Sep 2025 14:15:26 +0100
Message-ID: <175828772197.1762775.16941301924076332511.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250912212258.407350-1-oliver.upton@linux.dev>
References: <20250912212258.407350-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, yangjinqian1@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 12 Sep 2025 14:22:47 -0700, Oliver Upton wrote:
> There's a mix of features we currently hide for NV VMs that we actually
> can already support, either because they have no impact on our NV
> implementation or the feature was already implemented and someone forgot
> to update the mask...
> 
> On top of that, I decided to invert our masking for several registers to
> have denylist behavior. This is a better way to express things, IMO, as
> the features we do not support are explicitly listed. In so doing, I
> found a bug relating to FEAT_DoubleLock where we accidentally claim
> support where we shouldn't as the 0 value implies the feature is
> implemented.
> 
> [...]

Applied to next, thanks!

[01/11] KVM: arm64: nv: Convert masks to denylists in limit_nv_id_reg()
        commit: d3c35b7c57fc33ce787921e2faf84b7d58989a2a
[02/11] KVM: arm64: nv: Don't erroneously claim FEAT_DoubleLock for NV VMs
        commit: 49da9872a6a6fa943c02448eeae6db5e7f479283
[03/11] KVM: arm64: nv: Expose FEAT_DF2 to NV-enabled VMs
        commit: fac4ee7abe47a078a790ad2a9dd777257a186acc
[04/11] KVM: arm64: nv: Expose FEAT_RASv1p1 via RAS_frac
        commit: 26785cf28bb10bc94b2a52820c8ba1b3cfc534e5
[05/11] KVM: arm64: nv: Expose FEAT_ECBHB to NV-enabled VMs
        commit: 7cbdb25bed4046dacf139cce25fad9ef39a04a5f
[06/11] KVM: arm64: nv: Expose FEAT_AFP to NV-enabled VMs
        commit: 09dc6b42c62e47718ce0e94d44db7deffdc193ff
[07/11] KVM: arm64: nv: Exclude guest's TWED configuration when TWE isn't set
        commit: 05d9f3408334afb97b91dc869c658e6951c3dcb3
[08/11] KVM: arm64: nv: Expose FEAT_TWED to NV-enabled VMs
        commit: 952387c9d39998c7ba48a93aa7f8b8eb420d61dd
[09/11] KVM: arm64: nv: Advertise FEAT_SpecSEI to NV-enabled VMs
        commit: fe2c9cd439e0f84a31b3610e2530663e5d1d3fa8
[10/11] KVM: arm64: nv: Advertise FEAT_TIDCP1 to NV-enabled VMs
        commit: 6f2224ef07437116ae9c46257b323306260074d1
[11/11] KVM: arm64: nv: Expose up to FEAT_Debugv8p8 to NV-enabled VMs
        commit: b8b1d62f17d6fb323dc1f38dd7ad43a88fcd75e3

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


