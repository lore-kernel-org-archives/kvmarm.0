Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3061468C29;
	Mon, 14 Sep 2026 12:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387450; cv=none; b=R485M30v7ubTs+3FRgnfk5vx7F2G9gTjKdiVnml5W5BDZscDzE6FQW9zJrmp2xAdaHaOI4Lof+4uUKethIj2zEIhfZ2TYzglBxs3PO/MNq+Xx9lsK5BBhptifZ5GixGth42zkLU+xfWVDWFXe0zVxQnVSz6+uGz1d3ihV3/hytA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387450; c=relaxed/simple;
	bh=3pQTq8P60wc4I2/0+qQ/bDpdUcp+1bRG78MlTjRrP1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ssONDh7AlhkMBWbCdgbvT/C/kfuCpK8oZTxKNjOxVbsktUXic43nA37zLqNJ3N/ft2AWHM0Dg8Kfvj/0usVjj5QdgE8nOIdv5TKBjxNNFvi7n2Z6lNu2iOgNLPm+1g9/krUJ9J9YHq9+h+Sn1orPrEermNpgatN4uALAs2Ylas0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+lPgklz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+lPgklz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D0B1F00898;
	Mon, 14 Sep 2026 12:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789387447;
	bh=xM1TDdqfEl6GU2ywllZBD4mpsnLKKgTMKLuTMtixxJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+lPgklzo7cE4au5q0x9M+DrqjT+A/VqRZQodgjulWV/PFbot37UXBgW5utO4T03E
	 3U+f8S8Zydx9o+esMJVLStQfXKqSJLNYpIgiZH6pUF8YlcsJK0rXHFfadgU64MX6Hs
	 9chjolL25a1uwAAzVnPzmAGmirsaWtQ8YhqBNba+tNbMf+KIQ2bq3JqUdxdGE5nObu
	 rF7JzL+FuEuI75Urw4nAHYHKw67NKu53VTbgdmtwSQuLjS3xzD6tNAqnmRzsvHvvM+
	 82KhFNf/BzskXOdKmK1KRRxlpUKP//3XfuhBfuinJ1oHrrb2EKexotaDDV2J50n1vT
	 qStzdEXtKSzUg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x65Pp-00000008bDF-3RvC;
	Mon, 14 Sep 2026 12:04:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/11] KVM: arm64: Restore type-checking across the host/hyp hypercall boundary
Date: Mon, 14 Sep 2026 13:04:00 +0100
Message-ID: <178938739493.3215146.204121223910333681.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901140326.3812068-1-fuad.tabba@linux.dev>
References: <20260901140326.3812068-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, fuad.tabba@linux.dev, catalin.marinas@arm.com, will@kernel.org, rostedt@goodmis.org, mhiramat@kernel.org, alexandru.elisei@arm.com, vdonnefort@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com, ardb@kernel.org, linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 01 Sep 2026 15:03:15 +0100, Fuad Tabba wrote:
> Changes since v3 [1]:
>   - Rebased onto 7.3-rc1. The pkvm-7.3 handler rework that made patches
>     9-11 deviate on kvmarm/next is upstream now, so there is a single
>     version of the series again. It applies to kvmarm/next unchanged.
>   - Dropped the Fixes: tag from patch 1. No config fails to build
>     without the include, so it is a self-containment fix rather than a
>     fix for an active break. (Steven)
>   - Collected Marc's series-wide Reviewed-by, and Vincent's on patch 1.
> 
> [...]

Applied to next, thanks!

[01/11] tracing: Include linux/types.h in trace_remote_event.h
        commit: 968c346143b71678a4970d1d0ab3f6505be7dfd9
[02/11] KVM: arm64: nVHE: Share the stacktrace per-CPU declarations with EL2
        commit: 424f7785bcf316645e7f5f4620e3f9d8efdffb0f
[03/11] KVM: arm64: nVHE: Declare the hyp event IDs before defining them
        commit: be44596c05ae1b34d7b9029acc1c9d41ee3b8783
[04/11] KVM: arm64: nVHE: Use NULL to reset the trace buffer backing pointer
        commit: 3d7a7a01243408df1b0232288e4f9cf7362980b9
[05/11] KVM: arm64: nVHE: Run the source checker under C=2
        commit: c3ac2ba27ed74b58525bd6614c503b30b221bb51
[06/11] arm64: pi: Run the source checker on the libfdt objects under C=2
        commit: 44b14ff4aebeae98663d0fd424b4ef88237ee981
[07/11] KVM: arm64: nVHE: Pass host VA arguments as pointers
        commit: 79a2e4681fd5936f4d7ab26251fe96ee76d60940
[08/11] KVM: arm64: Move the host hypercall interface to its own header
        commit: 3a189b358018d76020c65b5a52c90ea9353ef642
[09/11] KVM: arm64: Type-check hypercall arguments at the caller
        commit: db89e04ddbb7838b40f7d7b59b69220212678702
[10/11] KVM: arm64: nVHE: Check hypercall handlers against the declared ABI
        commit: ab31289483f54892dc6204a6ce2015420d0d5213
[11/11] KVM: arm64: Tag host-VA hypercall parameters __kern
        commit: 8bd0e6812a1be71d50620f00445940ded0df897c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


