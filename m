Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8C13783C8
	for <kvmarm@lists.linux.dev>; Mon,  5 Oct 2026 08:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791187772; cv=none; b=h8RG9IEYqZMBKFULOfvRHnmc2Kcv0fXxlragH1GvA0QSnDipNgqr8ocCtzdBFWZMghDEuRkcJOCGoT9O0zI7ePc1dFwWkHNLp+GWGeyRRlu3LtqlUU1hayfeZXSEwgil1KVXo4jspVwmSnaNPNVexnQBQ552ju2l03Yx5WteMUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791187772; c=relaxed/simple;
	bh=8Ht32jWnPGpXzNOU1Ahi58x+0Gp+IIYwZW6gzDfKv78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k2WBDQyvVm0r6Rp8caG1vUTcc5RwZdUitHqfbf0jMDzd+FWA93X8rIkaczzcy99NGZ0NYqAOYRzWC4F62q9XgfncU1Tw5mxpGbzV5orlpjGJsglK/k5rYfZJxEFNItgILiropHGFU0HYRQxLa2R0qsOaXAQquFU1v8aNF1ElC2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BDiOIjRQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BDiOIjRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97EC1F000FF;
	Mon,  5 Oct 2026 08:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791187770;
	bh=DyajoXEiE5OZTyyC4HoS1mecTSELNPfDNIq8DNtLUK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDiOIjRQv1EGmqCsNVvPO3VFpxHPm1p+dL8msuPVOWYylIPSmUBxkBrmoJq8b3/eZ
	 Q5B9CvoKyaXadPxVRJiLiXD2fXWIk0+85yhB5IdDANPsNr/Q7bjA73Xj9rQd6tEwqQ
	 QImX85QUrDamFCxTH4qvftrRyFfGdZ7uedb3AMgP+igyN1Nj8EpmQ+P7N53ZA3XsG/
	 0ub4/sS12G/7vkyCcbRElBOaiHrqFYqS/3FAp4l82Vbz1EqrJdTeFEbkmuQEgqMFaD
	 5CfUy3wJXzKd5MAT5k6QMIqnpGm+YNtPG11nuPaopCqsL3eHGYg+F6w5ByXvn3ZI1r
	 Mjv1Juutcwq4A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xDdlI-0000000Gyvk-2GAO;
	Mon, 05 Oct 2026 08:09:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Vincent Donnefort <vdonnefort@google.com>
Cc: joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kernel-team@android.com,
	fuad.tabba@linux.dev
Subject: Re: [PATCH] KVM: arm64: pkvm: Drop keneldoc markers for the allocator structs
Date: Mon,  5 Oct 2026 09:09:22 +0100
Message-ID: <179118775350.630534.9707834125912557281.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261005072046.2246900-1-vdonnefort@google.com>
References: <20261005072046.2246900-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, vdonnefort@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 05 Oct 2026 08:20:46 +0100, Vincent Donnefort wrote:
> chunk_hdr and hyp_allocator are private. Their description is not
> exposed to the API documentation. Drop the kerneldoc markers.
> 
> While at it add the missing description for chunk_hdr::data.

Applied to next, thanks!

[1/1] KVM: arm64: pkvm: Drop keneldoc markers for the allocator structs
      commit: 6b1abd43b27a5ecac0672482dc8ca1e48c2c8d15

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


