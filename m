Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3F24A33F2
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 16:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784823088; cv=none; b=WwkHjJhZjDLZITAWrotQYrZpZKqgCEiHmia6AdglWnl12XzLlo3ZfM4Zqp5TyUhynUz9ph+wWKi57WkbR/02GEYuEnWEvUbiob+CdCRhGCxPGq4kcXq+ES4YlDGYB4o8S057D6WcdAvQDPAiWh9Yor2yovVU67GieP5IIrH73RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784823088; c=relaxed/simple;
	bh=hUmfdPloO7s0Hx9WocnHwJ1q1wUcDysog6Jk3VO024Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sZCH4vP2eY9t8oPuYwfMumqKB2jnHY3bZW8xqHeQHCtJGK+zW9TvpcB4iAHZ/TzzA4i1wakcOvgcrJr530ls+WxBmxMjq8QNXpMCWgIIiWTqNTVDQVjMabWp1OY86tUQVVhBeqATQ/yUiFbL66KW+xG6QyD8rbOe0i7mgaDPxzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oj34C3EP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oj34C3EP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD541F00A3A;
	Thu, 23 Jul 2026 16:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784823087;
	bh=Weyp/oLhKZLkacjeN1Ftw2HMrf7BTwE3TsZf9PvNHAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oj34C3EP08ZKjzQnPJu842SViTXjFZ4wZwO94E6yE9pq/0b/m7TY7D32jSflXGsph
	 HCn6Sb/Ce3BwLgCJqcUIM71tpjeynpCxkU0k4CUNA6RySAi0REBEmXsLsRR489wLI8
	 Wg/aOjDJ42/1LLM38t4KM4X6iDrFIk+njibI8Uae2dulMFiIWruI5dkWZW+QXcYSo4
	 um35Eczjv1F0FgIh89afKna3ODWziZhG6VbnFqNGTBRWs4GRtuQFPCwt1+AShh8LyL
	 8DWpOADHHXfSqr+/EVAXoUFVj+pqeovjm+1KfwGgWSwHqHEY6tSL/862yKJzoGaLjO
	 MFJAjH+BWTrJA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmw0y-0000000872z-1KXd;
	Thu, 23 Jul 2026 16:11:16 +0000
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
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2 0/2] KVM: arm64: KVM: arm64: Fix potential leak in hyp_trace_buffer_alloc_bpages_backing
Date: Thu, 23 Jul 2026 17:11:13 +0100
Message-ID: <178482303775.3351010.17818493792689450146.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710114819.2689386-1-vdonnefort@google.com>
References: <20260710114819.2689386-1-vdonnefort@google.com>
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

On Fri, 10 Jul 2026 12:48:17 +0100, Vincent Donnefort wrote:
> This series provides two fixes for the nVHE/pKVM hyp trace remote buffer
> allocation.
> 
> Changelog:
> 
> v2:
>   - Added patch: "KVM: arm64: Fix hyp_trace_desc allocation size in
>     hyp_trace_load()"
>   - Collected Reviewed-by and Tested-by tags from Fuad Tabba for the
>     leak fix
>   - Do not set bpages_backing_* on __map_hyp() failure (Fuad)
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Fix potential leak in hyp_trace_buffer_alloc_bpages_backing
      commit: df7a9d376f7a388ecfacf8dfe0b5819ddfba6972
[2/2] KVM: arm64: Fix hyp_trace_desc allocation size in hyp_trace_load()
      commit: ca28278d10ec234592989ad370d58294b9d43e0f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


