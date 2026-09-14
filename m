Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB4946D560;
	Mon, 14 Sep 2026 12:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387454; cv=none; b=S6QZ/AGHC8v3EF/PCuznc38T58H81hgiDiDtMBi/bkBQabHbHTNdwwN9Qu51kEWMpf7Fmv30V7l0zPcDWTwURtw31rwrOKkavGJdyK3s/XCLTyn0CPeDdoHB3Y7MNIr3f3iNtOOr8+QtNHQuI9X8QaXs+pSSIUpJSYI3xqqhlXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387454; c=relaxed/simple;
	bh=Zhfp8mk7kOl/7Ot+EE9qOhhKFJQoRYbVnyAkD8oHJbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ehBNnisojn4KqT6jZeMG/6hHsuloxcJlgGcG8+SVb3NYcJWhMc3KeWNTqqca5tkMmU9GoLuIdhO424c41jc6+eILipZyQiRaBqDuV0oFx/yCULlPStS9Z2+oh2vhQIK/kMRnwLqN8eDv3V65DHoyy2dfVHiljhk6aMqWRlpTGeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HTQxasZD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HTQxasZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7424E1F00893;
	Mon, 14 Sep 2026 12:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789387452;
	bh=lzGg9rI22MhcwX1aQHvZ6JRIjUo2SVdjqa4Tz4rXGgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTQxasZDH0gTt0LyFNMY8tEZcsUiBEO1nIpv0CLnVeSU2uKIao4nyU+J85DABBV0n
	 MgvzJHQojXKFzlOIfDKrS1MIzJ8XX27jqADxK9wI1jBppOJnBA3iDS6QP7HkN2d2wH
	 iSsSRorasu73m9VdJJqtnNGqN95fyprSToU50dfH3cbuz+6rwypVSthpxK+NteGPkj
	 CGOXa5yfoE7AcGOHNHA+aBOdbYMrr2zqdY79VSUsbryIyKx7tXL4hgaXuEh4AdQB0l
	 D2WK6iqOESLULLyXuWaWdu+Bvji+yojTYcPet6AMf6FaCxEekAGP+PabikpXJWhXd8
	 uS1C6c8dOJziw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x65Pu-00000008bE1-3N2I;
	Mon, 14 Sep 2026 12:04:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Like Xu <like.xu.linux@gmail.com>
Cc: jiaqiyan@google.com,
	kvmarm@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: selftests: arm64: Make sea_to_user skip cleanly
Date: Mon, 14 Sep 2026 13:04:10 +0100
Message-ID: <178938739500.3215146.4451146948664705585.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260818112920.26252-1-likexu@tencent.com>
References: <20260818112920.26252-1-likexu@tencent.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, like.xu.linux@gmail.com, jiaqiyan@google.com, kvmarm@lists.linux.dev, pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 18 Aug 2026 19:29:17 +0800, Like Xu wrote:
> This series hardens the arm64 sea_to_user selftest so that it reports a
> clean skip on hosts that cannot actually run it, instead of aborting or
> silently passing.
> 
> The test drives a real recoverable memory UER through APEI EINJ and
> expects the guest to consume the poison and exit to userspace with
> KVM_EXIT_ARM_SEA. That relies on host and firmware support that is not
> present everywhere, and each unmet dependency is now turned into a skip:
> 
> [...]

Applied to next, thanks!

[1/3] KVM: selftests: arm64: Fix EINJ handling in sea_to_user
      commit: 05fd5844cc83c1a51b0a38113a7ee196a69bda1d
[2/3] KVM: selftests: arm64: Skip sea_to_user without 1GB hugepages
      commit: 2665ac1063e71f23888091a0bdb1b96297bd0370
[3/3] KVM: selftests: arm64: Skip sea_to_user when EINJ places no poison
      commit: 754c7b7d45074337972c5c3ad76ed9e7b103e5d0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


