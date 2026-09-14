Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FDE444707;
	Mon, 14 Sep 2026 12:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387443; cv=none; b=UrNaDX58BdBj/qujSbgdrhOUqW13lN5myk6frS6PVxcUFfuzXXZKonQq3YgqVwB6+39/V3TSvEpaVSg5XBYajryRs8+RQ7mBPMLo7luHIkw1qPl24JvdgXMnrIVZsCejd/p+zUqHRv7Z2NMr/ttxMDbEwvwWtyraqPQ83lJhEJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387443; c=relaxed/simple;
	bh=e7WLh5KB/B0DBpKcW1DUwnx+lCTe8XcvWZd64p73F14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=es5XtJkbEsKHd906+oOE2WAZZznxEbKj7Z2RPnNzUuOhexv2xFDVWwtrY60hi42BRkeYWiYaLfx6GBmrF8GE5TvYt7Z1hy8YEHzcDRHGPRREjVM3/XVWy3g+TW1TT+AFlyYLakPSW6W+sDhuvxGNetbZ5I08LjGrgzJW9Puga/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hm09lbjG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hm09lbjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256C01F000FF;
	Mon, 14 Sep 2026 12:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789387441;
	bh=hxY5YIWX2A55LWhwTPL5a90n771CdZxutiK9owzN9tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hm09lbjG22f4PN/yF9G8XjJkOF4aj3sN5qj5QWjCyuk76RaboRefzBZNzlyIfqKwu
	 tvm5UpfLMueqyIZumZ9L7yzuLTJ5B10Vk3bulmN57i4ptJlHKkEACEi6qH7WZ4jBds
	 oEKJNjJiheQy903xfNUEzSA8VVopfwajnYhZPN1NpgMmsernD5fdd9dXTfrWlSDcZX
	 9s5X6U+7c7bxajmer28FIPJgkV1yIC4Qa/WoEh+visEE1rtiR354cwDrUvY+7GM5ax
	 pZCv24o9v/ud0dZJth16m6W13XpRlk8CUn/VOVVyzPru/L/yNMf51mViueMAEr7X3F
	 +kHot3CyfVK2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x65Pi-00000008bC0-3CKp;
	Mon, 14 Sep 2026 12:03:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix the KVM_ARM_PREFERRED_TARGET documentation
Date: Mon, 14 Sep 2026 13:03:36 +0100
Message-ID: <178938739487.3215146.6544975088974680554.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831162815.269851-1-fuad.tabba@linux.dev>
References: <20260831162815.269851-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, fuad.tabba@linux.dev, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, vdonnefort@google.com, qperret@google.com, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 31 Aug 2026 17:28:15 +0100, Fuad Tabba wrote:
> KVM_ARM_PREFERRED_TARGET has never set a feature bit: the original arm64
> implementation zeroed the bitmap, and kvm_vcpu_preferred_target(), which
> only ever zeroed it, was removed by commit 5346f7e13e5e ("KVM: arm64:
> Always return generic v8 as the preferred target"). The ENODEV error had
> gone earlier still, with commit 08e873cb70f3 ("KVM: arm64: Change the
> return type of kvm_vcpu_preferred_target()"). Document what it returns,
> that userspace selects vCPU features itself, and drop the error.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Fix the KVM_ARM_PREFERRED_TARGET documentation
      commit: f3435cb7df9b8fe242bbf776a9ac496bdd2184e9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


