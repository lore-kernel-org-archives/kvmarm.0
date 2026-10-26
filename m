Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016079;
	b=pA4Eeqk5XTbp9k4H81rklrJKx3TW++pgC20ytxrJ/ZjNuOg7NK84TTbKOJdmAW8zdMXn
	 vcDaoWQaX68yzTTY6n659gJSawySH/iEaSLMc7Z6f4mA968ATTwZZmiv7QSekzNtfcZGY
	 s9PHWGuWRV5jPOL04NjOUYWfVjfik7Yxr/au4UTzeZR3AoD6AO3+aINjvqBdWncMVCQOp
	 DPsiwW+lXDT0Nj6xp0jipfvqU9v/o4wcsFnzymXoQchYcg8o20L7dy2y8VE4l56TJumyS
	 ePEy319tGi2j5lk0FIweIO8AfDFkTxag19gUj9tQJ33pcTOFqs0iPGLg99bQ5Ihp07Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016079;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=00z8Y8GW8ca1Wv3c+CFIBQZrxnGa28sKK7la2T75TrI=;
	b=cukk6Mjl/b0Qpelbb6UP0vx01P8x0u52Wg+K6ldNruzSYPf+YHKsCKZV/VoxrKfC+/Ab
	 UoE18TH5XUhhLeKLWX2ZDxefrftTiwm96jgmP/qnjMe6pbHvVQCLekgaOGVVD2YTLKSMa
	 jEaKLJ9sSE6UXJpf0dbM/wZtFoa4gfPFroXkgUP3/PZBFL7xgo1JPCv2nhCdcvk4mgkMh
	 xWyuUJv0ow5ctnOigu/MVO2Rqn7xiWBHJEvQZkKXJfzw0DpIYnljsdgZ1LiC4amzghk8g
	 MK66WrPRNCRVGb6lrwTRNcMMCVGNmwr7M5ZSMrAyxSC9Xgw8bpSsuKeB2Nxuz17ycJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fbOeMxVz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7ACA60A2604;
	Mon, 26 Oct 2026 12:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fbOeMxVz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D79F1F031E1;
	Mon, 26 Oct 2026 12:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016079;
	bh=00z8Y8GW8ca1Wv3c+CFIBQZrxnGa28sKK7la2T75TrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbOeMxVzZ2wwyoueUYpOU4eoNV33v/2vwwS64f+6CntR9IYN15e8WRqPxMIQVCO6C
	 xt3u2xemlqPYoFa3/MSnMFB4XGIWwoyJ8MkaB06zBLgpUeLN/e2ISwrsmLfM/OF1Rb
	 x0JNVnwP/NiaEM19QM4eSB8FVG3lpdAipT6ixfTmDE8b87pxFOwR/5qbdNPJBlDVI4
	 id/CAFWkSslNMNI5z9jmK12XlLFdlW4j3gXfmO/wHxWOThV7CeDxoFJu5D5OdGUYBm
	 QDn9SUBkGYUmjTziAj6mFkWvyEb29xfrJx13q+64lfJb32w3cGXIt9VQyAZKycV16H
	 IhHYLJ3mcXtUg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLJO9-00000007Fr6-3Xwv;
	Mon, 26 Oct 2026 12:01:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Sascha Bischoff <sascha.bischoff@arm.com>
Cc: oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v3 0/2] KVM: arm64: Reject mismatched VGIC/ITS models
Date: Mon, 26 Oct 2026 12:01:06 +0000
Message-ID: <179301587210.2527370.18024850620938589623.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261020163923.1407856-1-sascha.bischoff@arm.com>
References: <20261020163923.1407856-1-sascha.bischoff@arm.com>
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
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, sascha.bischoff@arm.com, oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 20 Oct 2026 17:39:21 +0100, Sascha Bischoff wrote:
> On a GICv5 host with legacy GICv3 support, KVM exposes both VGIC
> models to userspace. A VM can create a GICv3 ITS alongside a GICv5
> VGIC, because neither creation path checks the model of the other
> device. The ITS sets has_its, but a GICv5 VM cannot use a GICv3 ITS
> for MSI translation. Creating the ITS before the VGIC also lets
> userspace select an incompatible VGIC model later.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: vgic: Require matching VGIC and ITS models
      commit: 05620a31421935f737d16a060d2dfe731f7b2f74
[2/2] KVM: selftests: Reject GICv3 ITS with a GICv5 VGIC
      commit: b17eea28dc815f63aa3279a66fd1e4de47a8a446

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


