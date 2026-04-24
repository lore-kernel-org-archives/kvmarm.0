Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EFE2BD587;
	Fri, 24 Apr 2026 16:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777047008; cv=none; b=R/PUPY6x4YGpycCg3qFnYnXYdGHVJAf8f1zAPo+hYCzC/B2DxKfx/vgoKonAv6ivbIFrUxEH8azR2i3XSSHj9xbdG2k1rHKqKuL8xvrU9iWusRN6z4iATZDYMEJyPNEasNQp8lafLkCnmSFeFPuHwyapikz186SVl8fIBwKrW88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777047008; c=relaxed/simple;
	bh=601cB8DvX/sMTRCeJ5tft8T4kzWVDphwpc5xreOjr9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jSy6zrO4EB7Vdx49EkJAtKnb1GOdf5p5Dsk78tH9vGCmTiG7v2NNRF6r3d8Vef+U5ySb3i/r8WmfsuXgiabwJwQrEbmIH2spp7TrwK10qEKYqjAHBoPtKBB30RZsHEM5R89k/OBs9TwUdtb3t+CGjt3avCoEXe0xeG6J0WVf3nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DsBCw9fG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DsBCw9fG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C24BC19425;
	Fri, 24 Apr 2026 16:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777047008;
	bh=601cB8DvX/sMTRCeJ5tft8T4kzWVDphwpc5xreOjr9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DsBCw9fGL1lmy/570MGacEaj15Tz/tgkHAXOraXAYkcMp2w+JuZoUieEKUtLqW/dV
	 tbDagWYVY+V62iqzgPbaZwDMQpq0+CLo2JYjB15VbrTObhUog+M9DOcduFKuGlv2Y/
	 TECFbW1JYp/MPpLa74OSrHGOdA0/B6jMXqPfOK0sx1gayM/heDHRjmi8qePhbodUKB
	 BzAO7roHWGKtb0PDIe3V8cKwEEm3FZeVPMn9AR7IISsj8Fgwn8yZlYYBK2wDORm0hH
	 3th9ZftEFWpFALlVq95YOgNzHvQ2XpiqFpaM02AAQob0z73jRtd0fkO9AidHx2de0+
	 m9iGCqd1BxDVA==
Date: Fri, 24 Apr 2026 17:09:59 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Jonathan McDowell <noodles@earth.li>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	Sudeep Holla <sudeep.holla@kernel.org>,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	jarkko@kernel.org, jgg@ziepe.ca, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, noodles@meta.com,
	sebastianene@google.com, Yeoreum Yun <yeoreum.yun@arm.com>
Subject: Re: [RFC PATCH v3 4/4] Revert "firmware: arm_ffa: Change initcall
 level of ffa_init() to rootfs_initcall"
Message-ID: <20260424-pompous-eagle-of-poetry-e6dfe7@sudeepholla>
References: <cover.1777036497.git.noodles@meta.com>
 <2e7b4dc552b45ddf14cc43bc449cbebb4ade0027.1777036497.git.noodles@meta.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e7b4dc552b45ddf14cc43bc449cbebb4ade0027.1777036497.git.noodles@meta.com>

On Fri, Apr 24, 2026 at 02:24:42PM +0100, Jonathan McDowell wrote:
> From: Yeoreum Yun <yeoreum.yun@arm.com>
> 
> This reverts commit 0e0546eabcd6c19765a8dbf5b5db3723e7b0ea75, which was
> added to address ordering issues with the IMA LSM initialisation where
> the TPM would not be fully ready by the time IMA wanted it. This has
> been resolved within IMA by retrying setup during late_initcall_sync if
> the TPM is not available at first.
> 

Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>

-- 
Regards,
Sudeep
