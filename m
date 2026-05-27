Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E7840DFA5
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 13:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779887591; cv=none; b=mLBuRwZ55JHPB2sskyvArS/36jNjs8syoF/0D/Wcbt4VP4E4H208enDSawAoRbU5SJkA0VSiyzOwb8lnj9zBAorAjx015BzeHpSVQZvteOdbbqDld+A6zkwoD/PkZx68ypUIl3M/HOaK4Uo+4n8+W0O/mRzxEsrEOHFT0xJFE+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779887591; c=relaxed/simple;
	bh=0KW4kXOclwbnhIW+REA0T9egC4fj+jrDURt+NNc5NeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rxTHs5Oq/nzy3iH32fW6C6QLOuFGAPDQb1tsp0Ld4z7WaoB/dravUvZ64JNXVotA5fY4ZXalc4YASRQLAhBVciWUWPQwJDy309xsgI69Dx17inLeqCd7tyIEbT2fThQs9Ky9aFzFLJsf46nVvq4TnVC+M8hW8XyihrN0c/EJYlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KNHyq9kT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KNHyq9kT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79391F000E9;
	Wed, 27 May 2026 13:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779887589;
	bh=Niw++E/3HBnaCkx4o+VI5DBHvskXLqB6ZBKTyJpxMkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KNHyq9kTC8JAbquYl7oHKMIvHVW4edX68G1uinaEO/07PW05DZJujqWyMY5a/xNom
	 e7APg4VDv2Oj1v62z19f+YT/V6B+nFji/fQ4pvIHZvmZqy+2nhyrdD9Rz4fsF+qpwC
	 i/MgrU+gzfDzaHScBAle62TavDqwepSYsucfNLGILYZ6OYllcktjc1I/oMVYzcafzO
	 arzs3uXLzXRh17Xk95yu3GGgsv/Zldj/pcOZIlG+PFcjnaZsRW1TsitQKVU+EbUjaU
	 qY2hm53TDVyJf4v6XHDHYbA1eL8lwhT/pXN07JDFpqoA7w+GMhNnQkZTX+PvUur0BL
	 VgAiXViBZlKXA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wSE4J-00000006gdv-4AQ9;
	Wed, 27 May 2026 13:13:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Oliver Upton <oupton@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH v2 0/3] Fixes for hyp_trace.c
Date: Wed, 27 May 2026 14:13:05 +0100
Message-ID: <177988756841.1513623.7911406206293058821.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521124613.911067-1-vdonnefort@google.com>
References: <20260521124613.911067-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, oupton@kernel.org, vdonnefort@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 21 May 2026 13:46:10 +0100, Vincent Donnefort wrote:
> While reviewing my v1, Sashiko found a couple of issues with the error path and
> more annoyingly a memory leak which I originally missed as the allocated
> decriptor isn't tracked by kmemleak.
> 
> Changes since v2:
> 
>   - Fix rollback in hyp_trace_buffer_share_hyp()
>   - Fix memory leak in hyp_trace_unload()
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: Fix meta-page unsharing in pKVM hyp tracing
      commit: 0f7abb6eaa3c3965f925e231c18409dac4f5a0c1
[2/3] KVM: arm64: Fix rollback in hyp_trace_buffer_share_hyp()
      commit: a23780ea9db3f3cadbb52ff6151384bff89d95d2
[3/3] KVM: arm64: Fix memory leak in hyp_trace_unload()
      commit: adae9996c04fea3b1791099b6d79e1df76d50849

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


