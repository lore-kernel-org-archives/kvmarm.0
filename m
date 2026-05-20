Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B8C3769FD
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 07:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779261287; cv=none; b=ANMZBXke/El+WiO4dttCPIiStlze2ftXXD3QjKSN4dkq5eSwyhdXF5SwO2lQxzx2n2gdJukG2ZMIACSzNdHhIoy7dQmXY2ao1L3F7E7M8j2x1BnDr1VRZfVAgdvkm6B8iEEfa6gEJmfc+oFP4EaMviTRt439YZB4K9jDdQXwfLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779261287; c=relaxed/simple;
	bh=FQl0fTSRLQyhWGV8C/F4mJZ+mXFBNUwiW8pOXAsL908=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SikaBRFVvgchWp7Z+V5CLdJJXwmYKuVFB0z8tWaX90HmoJQTlbA1a17wTYtO+pRaTIDnLrivFj0JmpQNM1eWUWsmcDZmkmjMFPJAbzafvioOi7pdTNWbSv6jfPZ4+HkT0z5ro7uJehPMQQAWCWOPE3tqQoFKOl9sVH/JFu8b3Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LKtBo6KU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LKtBo6KU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4A81F00893;
	Wed, 20 May 2026 07:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779261286;
	bh=SBSFzFA3KQepz/6hUJEehGOkcBZDsXn/cI/byRrIStA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKtBo6KULLlxvCyAj6v4urxZpuP63Q6SlIcvNVbGCIG2g1HW1DZ35FgD4UU1NLG9f
	 Nf4gCEmFKMkw9azxJJ7L2wOAL3hYjV7qY9wMtNqDfu6hfGmkIDaIeiUq7m9iv53jaw
	 cDAPB+9P+/VMBZ4mi/AXy6YfALYuZ3DCHuPQWiSWnkVzQg07lUlDnsDDTCnn2xdeCC
	 +rYsan38zoIwkQH0f4+ybNLpLRQH5C4McADa8lSPcW2cSRYm3gBhwmgmPob+bSlqUP
	 tJEuk7rWKBoceY53P4m3HhSLDfWcx5+EcJ28zfygwnXE1J0f4TmR/dBW+3LDWSBK5T
	 NmmIOdmVVUghA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=localhost.localdomain)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPb8e-00000004FaD-1YHa;
	Wed, 20 May 2026 07:14:44 +0000
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
Subject: Re: [PATCH] KVM: arm64: Fix nVHE/pKVM hyp tracing error on invalid desc
Date: Wed, 20 May 2026 08:17:55 +0100
Message-ID: <177926141814.52935.12967491031659448633.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514162624.3477857-1-vdonnefort@google.com>
References: <20260514162624.3477857-1-vdonnefort@google.com>
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

On Thu, 14 May 2026 17:26:24 +0100, Vincent Donnefort wrote:
> pKVM must validate the host-provided tracing buffer descriptor.
> However, if an error is found, the hypervisor would just return 0 to the
> host. Fix the return value on validation failure.
> 
> While at it, rename the function to hyp_trace_desc_is_valid() and skip
> validation for the nVHE mode as we trust host-provided data in that
> case.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix nVHE/pKVM hyp tracing error on invalid desc
      commit: 1702da76e017ae0fbe1a92b07bc332972c293e89

Cheers,

	M.
-- 
Jazz isn't dead. It just smells funny.


