Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C544927472;
	Thu, 30 Oct 2025 16:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761841417; cv=none; b=Cn4dDuOF0zi0gSxPAzQ5Io31Fj6tcON/hdY1wwvwfUUes0F4S8jpq3cO4FEpJm4QQrZb8ZT+AehPdebfB+OXklOdr/AL3Q4s+q18+IK/nsN1APdaudjzEP2/1LAB70IdUx3DhXrC1LJ5dEF+TD7MiNfaOoW4968PJG+59401MKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761841417; c=relaxed/simple;
	bh=alt5OGhl+CQnMwRUmeuBmHbbimh+37LwESCV4sQBqV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V9HxRbaIrQIK058IZ4kA9P4/AA8VlPapDUfm6nw/MidtTHI0+J6V6Gmi/MN4xk9HyoE7Y/OJVJlbCHf6xRAz8DtIleg/3W6gfst5bDYMMOnYUgD82dnGTruBYQt+7ytvT7pNwsIsgirmKEbWB3ZvWbY9STYk54UaL0mJ+5Uuy34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c6i53vHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c6i53vHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE4BC4CEF8;
	Thu, 30 Oct 2025 16:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761841417;
	bh=alt5OGhl+CQnMwRUmeuBmHbbimh+37LwESCV4sQBqV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6i53vHPU6YAiIfBIJHAbKGm5eV3IT31HgygOC07aK+xSLrjgGhopj/kxTUYGPKuW
	 w6kr6TJFuU5C0/y5EfFxbA4ad9tzCAVeh4M58wV+u6R51gd8ZC39XZVArf1ChqOJKL
	 W2/wp79V/fnWzm2XhltjAsYGiF1FomPDNufQbSXIvJmA7oU/rWg/gpKAnGxpIfGEKl
	 I38Sg3k/fJfUT00C16U+o0LgXscry/nkiV1CerDUWVe4MxHE8bBXl9XmEcLdoYDXIq
	 TlSYpOtnYCZaLCreYP2jt/1mR2cBroVVPJHjHdodgzBuxcC3e//3X6ByWZuipbjBpN
	 Uku1jD3HJBbSg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vEVR1-000000013AW-1ccB;
	Thu, 30 Oct 2025 16:23:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Vincent Donnefort <vdonnefort@google.com>
Cc: qperret@google.com,
	sebastianene@google.com,
	keirf@google.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v3] KVM: arm64: Check range args for pKVM mem transitions
Date: Thu, 30 Oct 2025 16:23:32 +0000
Message-ID: <176184141215.2037781.15285129673531696378.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251016164541.3771235-1-vdonnefort@google.com>
References: <20251016164541.3771235-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, qperret@google.com, sebastianene@google.com, keirf@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 16 Oct 2025 17:45:41 +0100, Vincent Donnefort wrote:
> There's currently no verification for host issued ranges in most of the
> pKVM memory transitions. The end boundary might therefore be subject to
> overflow and later checks could be evaded.
> 
> Close this loophole with an additional pfn_range_is_valid() check on a
> per public function basis. Once this check has passed, it is safe to
> convert pfn and nr_pages into a phys_addr_t and a size.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Check range args for pKVM mem transitions
      commit: f71f7afd0a0cd3f044cd2f8aba71a1a7229df762

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


