Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB62A22A4D8;
	Fri, 19 Sep 2025 13:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758287721; cv=none; b=ZDTEPJQgn1gfUXyHtRv1N1oPWnndncIzE0hB5LZyIaKFEa2Ls+26kDXEOOtNDzlfgsJwizyVqakscZsXmHoEOjeTan4r5DE1Q5M+1G7SnJoNZrPc7t+KEe4J3ZRlq2nOFNDa9SxyhRC/jnIlFZfHw1kacPJgFuM9eA4sqnB0Us0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758287721; c=relaxed/simple;
	bh=f+KQxZ6ogJBRTh5AD6J/biKmMTTk229KHvOFfA3HFec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oGSCbhP/WV8FWp0MpmYQlbT2OI1Apu1Kl7yRqnUynIck/QjdIJB+CPSq049LyaemDwTQMUA7G433T6nguRRhjH8rEEUgnu5x608XpEY/kmUn81uxglpIORr2XQOoI4Z6Y4tIf6+MhK6bchkZDHmMmuqaEHV597OE7hSfaYT+NiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jEf0PYZ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jEf0PYZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AC3C4CEF0;
	Fri, 19 Sep 2025 13:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758287720;
	bh=f+KQxZ6ogJBRTh5AD6J/biKmMTTk229KHvOFfA3HFec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEf0PYZ2BZ+IxqPUYoOmHNBvKyHlg1FwjIvCCH5gR3kGJwFfwrVIHP+8e1mW72ueH
	 stA/TZwA7ziDsk0zksCmbX/+kF3q266bguCE4F99XUjcT7t1q0waXkfkVdt5lqSUiM
	 jYJVyLKtYaJtIoQPSgkB+af6f7QHMDUDjxxjVqASSsFED1Ie6qJw2bvolwICXVied8
	 4mhBKKp7ii2gO9C99xFW5+ttRtRa4dpDZL7xQlrMZ9td6pklxYPgdcvQkG0sM6OitX
	 azFvmIHI5cDkIViD+YMMPcc1IV6oO05FFQn5lZ7L2N7EM0qktDAWr4ZW0pLYGqyfvh
	 oo6VctwpIxWVw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uzaxK-00000007mgw-0Kxn;
	Fri, 19 Sep 2025 13:15:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	Jinqian Yang <yangjinqian1@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	liuyonglong@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH v3 0/2] KVM: arm64: make EL2 feature fields writable in ID_AA64MMFR1_EL1
Date: Fri, 19 Sep 2025 14:15:15 +0100
Message-ID: <175828771292.1762581.13961318453079156132.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250911114621.3724469-1-yangjinqian1@huawei.com>
References: <20250911114621.3724469-1-yangjinqian1@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, yuzenghui@huawei.com, yangjinqian1@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, liuyonglong@huawei.com, wangzhou1@hisilicon.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 11 Sep 2025 19:46:19 +0800, Jinqian Yang wrote:
> Allow userspace to downgrade EL2 features (TWED, HCX) to ensure VM live
> migration compatibility between hosts with varying feature support.
> 
> Although ID_AA64MMFR1_EL1.VH is an EL2 feature, it is still kept as non-
> writable in userspace. When FEAT_E2H0 is not implemented, HCR_EL2.E2H is
> res1. When E2H=1, EL2 operates in VHE mode. In this case, if userspace
> modifies the VH bit to 0, the Guest's kernel will still run in vEL2, leading
> to inconsistency.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Make ID_AA64MMFR1_EL1.{HCX, TWED} writable from userspace
      commit: 1a0b2bf6ff11d2e0438f3a7d1d299339edab96e8
[2/2] KVM: arm64: selftests: Test writes to ID_AA64MMFR1_EL1.{HCX, TWED}
      commit: be8c9192eaeee21fdaacd72ad4ba992b9e42377b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


