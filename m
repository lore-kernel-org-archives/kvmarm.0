Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE1739CD1B;
	Thu, 24 Sep 2026 20:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790282493; cv=none; b=Z2hMdbrrynMh89ZpTYve6lLesGoysVECT65NO2TJtkK5zvS7wNm5V4Wl6FwCTO7GCRILXqrX99AZWbr70QPH2NJTRJiacFlzK+Lw10foBh+N04hvpL7eG4VHxgMpM3tMxqyzJ4x+cVFTKzmA3Hf9SLEzuEos6o8SuQegFb8j8S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790282493; c=relaxed/simple;
	bh=4zV9EgV87qOLZ5DtU90+UDa6c157F60BeVU77okqFBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ebHWOcjqVyMuT7ZBE0HeuEtDJiohZMrAn2vpjLioa9jbB7tCKayVocQSysaD8N/ESthRqg1OSPSXH7OD50+oSYZC+ME9DZaSAlh0mLSLWCbPRPgsCeVfnnV98q4JGUtZvoUH6akVELKL3PUJG0FbAT+NNjGH9SF2zHFlD/uZOKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qo8AksOc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qo8AksOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA4B1F000FF;
	Thu, 24 Sep 2026 20:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790282491;
	bh=i0P8UquZTMzoLeTcu1N/8IjI1pGOo9Exjooyz7DQixc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qo8AksOcGexF+fKbzzUM8yk8rQAM8arupT5f1/wxZCJAeChofBjgrW7wwtCL0XN8C
	 NvGJdZD2OjHzM8pewzjcl4FC3pPYMFcTZ8h60e36ZL7jLpmqFelJhCWjHt1G3VW2Oz
	 7W9+CoV8sn58zoMUBRZyKUFU3kCxXLbno6+w4IqiuTi/IRmhSmfj08KUiMorWs2hyC
	 2CJIS8cgtwjkgjA+o0hoChW5JtTX//v4+muOEp3HC3UH9g7lMbWosuKiBNwty0Fh7V
	 3bdOphQ0knaXVOmQKCs/ItfLt10WBuzV1I439rcellwyqCXgZH99glnkClKonQ3eSl
	 3L00IIktn4jdA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x9qG1-0000000DDGu-2Wfm;
	Thu, 24 Sep 2026 20:41:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Wei-Lin Chang <weilin.chang@arm.com>
Cc: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH v6 0/7] KVM: arm64: nv: Implement nested stage-2 reverse map
Date: Thu, 24 Sep 2026 21:41:24 +0100
Message-ID: <179028246121.3395858.305245720728794780.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915154305.3852871-1-weilin.chang@arm.com>
References: <20260915154305.3852871-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, weilin.chang@arm.com, oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, itaru.kitayama@fujitsu.com, wanghan@linux.alibaba.com, xueshuai@linux.alibaba.com, ljs@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 15 Sep 2026 16:42:58 +0100, Wei-Lin Chang wrote:
> This is v6 of optimizing the shadow s2 mmu unmapping during MMU
> notifiers.
> 
> This version fixes a few issues, and adds Marc's space optimization
> for kvm_guest_s2_mapping [1]. Please see the changelog for the details.
> 
> Tested by booting L3, and running in-kernel targetted tests described
> in [2]. v5 got some tested-by's from Itaru and Wang (thanks), I didn't
> carry them over since some bugs fixed in v6 are non-obvious. Some
> retest would be much appreciated!
> 
> [...]

Applied to next, thanks!

[1/7] KVM: arm64: Use a variable for the canonical IPA in kvm_s2_fault_map()
      commit: 3b8ce2b5132ae4eebd81811ffd3bc2395c41ecfd
[2/7] KVM: arm64: nv: Introduce guest stage-2 tracking structures
      commit: a6ca6cba59598de94eda90e4b3a4e405621aca90
[3/7] KVM: arm64: nv: Track guest stage-2 mapping creation
      commit: c2778d14cd2ff757224715221a2ddff89fc6f127
[4/7] KVM: arm64: nv: Track guest stage-2 mapping removal
      commit: 5491980c1a416139ea67faa6c4d52fa1ed0cd4e0
[5/7] KVM: arm64: nv: Avoid full shadow stage-2 unmap
      commit: e6084aecaeefe9177280ea74c90127294260d805
[6/7] KVM: arm64: nv: Drop kvm_s2_mmu pointer from kvm_guest_s2_mapping
      commit: 2064f15b08485384d4fca892c63a1c1b4f86e9c8
[7/7] KVM: arm64: Refactor kvm_unmap_gfn_range() with common variables
      commit: 862fa568078514d0a41bd0946a65c23a0c0edec9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


