Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EA6376467;
	Wed, 17 Jun 2026 17:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781717791; cv=none; b=FEQodoh+60vQLv+K5XX3XNKhMDh4jXqtS1/6ChoZH/mafI84xBctTJGFw0/Qn+hC0dyGzpP33DpDqCwu9rsy6RY1kITMUoMVxvsb8kjGuGMwSlalKFOW4lnrEyfoZ0Ro4qz6Spq/DbsnXao2QZ7UlMv7sBfg/nsBfh1s9dCN42I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781717791; c=relaxed/simple;
	bh=iqrijUV+7RRKQYB8khF6N1ZYRFNHBJ9DG7lREmGADJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H9rpsZqYqaKmQzm0d4/qSjNRAXdxrZckCPJ9c8PPnFR1baPfnYFJTv9OB8uxznRIkMkD+FtMy2MV187uHtozRmlM0nWpx0lQ6LaV76ggOJC8+y9Ie0kByxJV6ihdkATkDa5ZbbsIqPs99lBFgBETlhq3Q8twKFHdXoP/UyT9ZsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aDuOCp5F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aDuOCp5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C261F000E9;
	Wed, 17 Jun 2026 17:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781717788;
	bh=9c4JXxUSHmrMHbwQQezcBaAvkJYq69p41kAusufWTpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDuOCp5FcyoOulq2FR+bh4HO1geXcFkVep1yQVImvGf0P1gdPhCqy/oQbqfw2kLff
	 3J19L8KfcIY+CJvWFiL0q1mXXr9yrh4pE2DwVJOSHhQ2wKkKMjktcPePgky3NANOwT
	 VJ3/0d07Zz5mZ7erZr6qlVhTTamFdHNZyt7Dzxvg+vzflCIXH1C9a/4VqbEoanP0Zk
	 qjSfrzgzpyqECZTML/rI6mxY/+CiRqMdHze95d/w4T4gIDpWvS7nDQFvrf/qWRnfC9
	 gUqlfrBAv93hFQqZeX0IvVKWHVTHcqMlvHjESL4UZA6ojMUCTddA9N/UF/lYmF/Aej
	 LhSzujhqJfkEA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wZuBe-0000000DlkU-2Mrq;
	Wed, 17 Jun 2026 17:36:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <tabba@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jintack Lim <jintack.lim@linaro.org>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: nv: Fix PSTATE construction on illegal exception return
Date: Wed, 17 Jun 2026 18:36:23 +0100
Message-ID: <178171777578.3090427.13421187058645390320.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617144907.2972095-1-tabba@google.com>
References: <20260617144907.2972095-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, tabba@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, jintack.lim@linaro.org, gankulkarni@os.amperecomputing.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 17 Jun 2026 15:49:07 +0100, Fuad Tabba wrote:
> kvm_check_illegal_exception_return() sourced the flags {N,Z,C,V} and
> masks {D,A,I,F} of the resulting PSTATE from the current PSTATE, but
> R_VWJHB takes them from the SPSR being returned to and leaves
> PSTATE.{EL,SP,nRW} (and EXLOCK when FEAT_GCS) unchanged. PAN, ALLINT
> and PM were not applied at all.
> 
> Build the PSTATE by taking those fields from the SPSR while preserving
> EL, SP, nRW and EXLOCK from the current PSTATE, then set IL.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: nv: Fix PSTATE construction on illegal exception return
      commit: 0e8e955b9bcf84a70f20079390e19971fec1586d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


