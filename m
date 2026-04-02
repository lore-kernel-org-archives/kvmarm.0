Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A7130B50D
	for <kvmarm@lists.linux.dev>; Thu,  2 Apr 2026 13:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775137026; cv=none; b=j7RmdqD+Ax/hktIesdgOj//BiV4xE7iEJddniJSiTbyzuiXZ1cymhuHtt1dIhywCRfufT6xVepHWz5gMFFlra9woeedRlyjKZDn1qfsdBVhcrLC8UfWg48vtQH8wBjzfREoixYqHllM16FRBGaTwUdDt9Z5+xxnEyu/u4yCT9IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775137026; c=relaxed/simple;
	bh=QnR+5ZPsi9aBhWPoij2khowQATygqtU/rg9EGE59exM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G/TrhPoD/5CfU8TVq/e+Iljr9EK+wBZUqBDILGMthG33vl+S2zm9mxeKRtZnTxUx6t7yNZXsYpcFxL/wD5CLQ9jnSD8pLkHIYXC09msxmvknFjUUm4W+m938/G+DfCYCQ6U5DJ8ceMThRzSONcUrNXp42c7rSGzGtGg360HP9eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R706PM/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R706PM/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF10AC19424;
	Thu,  2 Apr 2026 13:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775137025;
	bh=QnR+5ZPsi9aBhWPoij2khowQATygqtU/rg9EGE59exM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R706PM/I2JxvODs6tJtfSTyrjfyqI6dFCmfqSPWwahcMaEuVuVCvVHAuYAn3cO1G+
	 yuljNy3dntSzagdB5wkbVIkqcRjJesnkWRTQYs0cJ/CPjhTm8tBuUoNSzOZxixkAyj
	 fuRy6aEOqDhO2VNtg6JUc5zC2D0dDbQrogyJpp5Bus7VJTzJzdwbd+dBEwghdDSOhl
	 5Ts6Np7c/QaZRZAM4o4iwUdgrYqTKl/4SLnEQvdroe9/ABG3+X/uN639toLlmeX7vv
	 uhjSDrMAynmdLLJjb9aclUDgJG+f9o5Kjc+2To/eUQk7lN0564ULAPrY9Y8MO7nmee
	 TbKmzf7D6L3ug==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w8IEJ-00000008H1C-3LHQ;
	Thu, 02 Apr 2026 13:37:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Tentative fixes for page-table lifetime issues
Date: Thu,  2 Apr 2026 14:36:59 +0100
Message-ID: <177513700675.453054.2462359302983806549.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327192758.21739-1-will@kernel.org>
References: <20260327192758.21739-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, will@kernel.org, linux-arm-kernel@lists.infradead.org, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 27 Mar 2026 19:27:55 +0000, Will Deacon wrote:
> Sashiko highlighted a couple of potential page-table lifetime issues
> in the upstream code while it was reviewing the pKVM protected memory
> series. They make sense to me so I've had a crack at fixing them and
> writing a better description of the problem in the commit message.
> 
> For the second issue, I've tested it by forcing the notifier
> registration to fail and then watching the SecPageTables line in
> /proc/meminfo after attempting to create VMs.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Don't leave mmu->pgt dangling on kvm_init_stage2_mmu() error
      commit: 2fc0f3e2b9a9f397554ffe86e8f6eb0e2507ec6e
[2/2] KVM: arm64: Destroy stage-2 page-table in kvm_arch_destroy_vm()
      commit: a3ca3bfd01b7ee9f54ed85718a6d553cdd87050e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


