Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3804C60B
	for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 20:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707771392; cv=none; b=KOYFsa0aKwyfGCdu2nCNDaTuOWYsg5vB7zrA3EewXBcOKmbKaZTKk/HK8tL1wxTnD0ROx3ZjglsIjx5NpMXWnpvemwqKra6uvCx9dKedAmQnxjGc/Or6gIDWdZebFycL96+l3DMzVCHl00m84uAUba0Gp5/aHaINJaOjUJ/m3Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707771392; c=relaxed/simple;
	bh=nioYI8QzAMJASNr/swtGxAoJRoICVkBq70p7F3S641g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ty9DlIAebzOznovwhI9KDZJgIoYlZ5BaX3D6Mtrvd0Edv/g5bEIOa/wF2pv4JstkUHUV1y75q3B07zfW9Nbbjg5wknvDbrmS4P03RgyPuNddqwejybqwQMI2j1wqxAMErPDN+DTTU0BMSmTvjboy0XN65pqyv12av1huKx4PrBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rV9G/aKR; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rV9G/aKR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707771388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oO68mIHZbHwg1QujSUyddQTzN62mxLj24Qcfye1RG6k=;
	b=rV9G/aKRuZKpoHt0MZ0FBk8TLUAHSaC4X2CCjHf1tVsuGDYJrG2vw3qotTrhAacseXRY8L
	py/DofBCE/YUlC4HR1owo7xGWGDc78VgW6PPKsNW75BIP91Lv/PH81HmBnt+3+Dr0duNpH
	MKK82nau0tnZEh82YnmcGWg4qcACbqQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] KVM: selftests: Fix GUEST_PRINTF() format warnings in ARM code
Date: Mon, 12 Feb 2024 20:56:08 +0000
Message-ID: <170777114723.3090079.16291479870607585815.b4-ty@linux.dev>
In-Reply-To: <20240202234603.366925-1-seanjc@google.com>
References: <20240202234603.366925-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 2 Feb 2024 15:46:03 -0800, Sean Christopherson wrote:
> Fix a pile of -Wformat warnings in the KVM ARM selftests code, almost all
> of which are benign "long" versus "long long" issues (selftests are 64-bit
> only, and the guest printf code treats "ll" the same as "l").  The code
> itself isn't problematic, but the warnings make it impossible to build ARM
> selftests with -Werror, which does detect real issues from time to time.
> 
> Opportunistically have GUEST_ASSERT_BITMAP_REG() interpret set_expected,
> which is a bool, as an unsigned decimal value, i.e. have it print '0' or
> '1' instead of '0x0' or '0x1'.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: selftests: Fix GUEST_PRINTF() format warnings in ARM code
      https://git.kernel.org/kvmarm/kvmarm/c/06fdd894b473

--
Best,
Oliver
