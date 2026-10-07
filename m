Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC72396B70;
	Wed,  7 Oct 2026 12:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791375408; cv=none; b=VUN8omIoX/c5O7HfanSw0hfTxqzjf6Pg3zotPDh7z6BMK3kchgH02vgdLGjCTOqjYYoS07e6OvwYpHHwbxucJm61kOH9vxTxp+e7GMsuwbQMip1sBuTI3X2K1UeUCU7n3Vzr1cnGLJcXNKCcds8Z4CKnZX45GG//E4JmX7nY7Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791375408; c=relaxed/simple;
	bh=xEBzt1BEf+JnghpXD1opJU8qu5Tzm90T+1FaD62L2Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RTfMcHix5Ye8wI0SKWWP3tZm9rhgbXVHbssNYw5yjd40x/RffpoQFLU33VnbTZX+zkpyY0Y21lNi+faAGc7GXFOceoRZe1zSr+Vh8ir30JZ+Xk/I3aeZ73eeUj5bN1RSCMqRZ78xEkBj+i7X4tejpNeVFtP1Fss8u8RfcaSgJz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FDpQx/oQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FDpQx/oQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16731F0089B;
	Wed,  7 Oct 2026 12:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791375400;
	bh=3/dEtmAwKr7ZR+4MeKQdc3RXVW7UjGf5ICaRVp/tj/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FDpQx/oQpMsMNBcFozRTE9j18Y8+LtZvEx+RvXAloudQWUXoyIC54g4fa6GqrchtA
	 /NgtwQalk8mSo0f+Zxykozo/txYdFwePH8tErTcMftJvaYP6Blh19Q9yseCT86vpPW
	 ZHqzmmKhJru5DeLyVg6YPSXYt1Hsrkwnriaqlc8NZAi44H7ssDwftCO1XHfvjAnl37
	 nLUJ+m1S1WBh4PpOvBnVA73Ef8of1GnR68KgngzIz30ZfzFol6VuWIltzaVJTqdzgc
	 M6Rym7XMPww2XXzEaNIqrhJPmFafof3iW4w7HHf/EjAW0FloKoLZRKqJjVDiSH04HX
	 Arv6sT0sIe4Ww==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xEQZa-00000000GHs-2b0w;
	Wed, 07 Oct 2026 12:16:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	vdonnefort@google.com,
	qperret@google.com
Subject: Re: [PATCH v4] KVM: arm64: selftests: Check the pending SError state in external_aborts
Date: Wed,  7 Oct 2026 13:16:34 +0100
Message-ID: <179137539018.699295.11516742459649413558.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006092841.2202109-1-fuad.tabba@linux.dev>
References: <20261006092841.2202109-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, fuad.tabba@linux.dev, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, vdonnefort@google.com, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 06 Oct 2026 10:28:41 +0100, Fuad Tabba wrote:
> None of the external abort tests look at the vCPU events once the guest
> is done, so an SError left pending after the guest took it, or dropped
> while the guest had it masked, goes unnoticed.
> 
> Read the vCPU events back at the end of every test that runs the guest.
> The SError must still be pending in the masked case, with the injected
> ESR when the vCPU has RAS, and no SError, injected or spurious, may be
> pending in any of the others.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: selftests: Check the pending SError state in external_aborts
      commit: 49664cd0b1db434b6bbf9e37c84b3f448a545dc5

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


