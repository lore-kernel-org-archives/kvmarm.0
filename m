Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7ECCD516
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 18:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66568C433D6;
	Thu, 27 Oct 2022 18:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666896777;
	bh=cE0DsxHVn8E3WSzZRpP4LLIDtwwk7/ADnshfq6mGRvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBkhQYh+SUZhFRwlDyQceHZjgXEG22RW+xi2baopYZjGNtcrGWBmbA0OnwrUcxDxf
	 1AbLkvJG5RzXjYSSSnntiRK7Bac2YMrk6Ci3v5ywlwwewQnwbxRWvLOUqK/NOQrHqD
	 RA32Rb7rof30eixL/BzOco41FkMrlEzR5wDNtoH/nVmdknb36avKFisqC4s3Wx+1eg
	 koJBef8N589Hrw4zo7igWctkRMn3n5ZSvUJT43RcVsWynwUORw6GUoPXFFKVbyCUYs
	 ImSsbs9ynpqpN564sc/e9/vDRCAzE2NSplLCk60owpp6bvenCwx3hdfVgq55SAKGD2
	 O+X7ry5BqKu9A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1oo7zr-0024QE-1F;
	Thu, 27 Oct 2022 19:52:55 +0100
From: Marc Zyngier <maz@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v1] KVM: arm64: Fix bad dereference on MTE-enabled systems.
Date: Thu, 27 Oct 2022 19:52:49 +0100
Message-ID: <166689668290.1967996.11076695324695573284.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221027120945.29679-1-ryan.roberts@arm.com>
References: <20221027120945.29679-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: ryan.roberts@arm.com, steven.price@arm.com, catalin.marinas@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20221027185249.l-zIdIFKESkCW1sfsftm9qF6TNjOZ9HaXiW7t_gIBBQ@z>

On Thu, 27 Oct 2022 13:09:45 +0100, Ryan Roberts wrote:
> enter_exception64() performs an MTE check, which involves dereferencing
> vcpu->kvm. While vcpu has already been fixed up for hyp va, kvm is still
> a kern va pointer.
> 
> Fix this by first converting kvm to a hyp va pointer. If the system does
> not support MTE, the dereference is avoided in the first place.
> 
> [...]

Applied to fixes with minor commit message fixes, thanks!

[1/1] KVM: arm64: Fix bad dereference on MTE-enabled systems.
      commit: b6bcdc9f6b8321e4471ff45413b6410e16762a8d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


