Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAF0176252;
	Tue, 10 Sep 2024 20:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725999123; cv=none; b=kw+p97EZMxLxFGLSb1MdcEZZqLD62DZAue1WZeMEObmeS9AbFUqfnW8mIEMN+532hkOdd/6QUSU/vVEH2SSAKCTZ6lTP3bYnBHwnbGFsls57MIybdQVvyrpjklnw+9ZII+Mk0TwSI4ozqc6UTrYV/4pdZIBSVE22j+ap6UrL8T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725999123; c=relaxed/simple;
	bh=9BALyp1uL4b1nN0mypRuLZqJnUYgxTKpzQwRVAx2iVQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dn5NUMHlMwKzuFfpXTtESfoHbUqKSTKsgVjyX3Acqqah7KMVWdbLe9Lt8Mzaf+gHPND0145sqFBZk55GVgLLp1wgMVmSBDyHvSdQwTFGTntI8tJjC5cxisAktZVMoyvHwfic1T5WtFjhaNyFxiDyixwaG4aDg7jfASxlIkO5mJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CIu6MWa7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CIu6MWa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895A5C4CEC3;
	Tue, 10 Sep 2024 20:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725999122;
	bh=9BALyp1uL4b1nN0mypRuLZqJnUYgxTKpzQwRVAx2iVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIu6MWa7vltKZskvmW2WNi7V99gCYsiadXXqNgcakt01FdvjCJEnspScUf0C5ezZw
	 A76LMv9mrnkEyBZC1cwTmGYQhAh80V+XraQTM/V1jF/iI23w/CPPuhG6/xP2ncgKbi
	 QGhdtXL1vh+D+HHY4aBhAzqae353/wmOpUMXidlvNamEERQ5qD27EJn/QVnYZ4nkPB
	 DVL4Uu6SeDwb0gEE2/6+5Osa/w6YT6+rJ+fSu11oyvZS6fLHiOl5HS+t/d/AtQjDkO
	 syiszQq+6ypNeBdgWD+ze+/R4l9NoxWTKVgOvQ7HGDTvDhG09mqsJ+8nudENPgMYpT
	 v5CkalanqIL3Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1so7DT-00Bs1F-Ob;
	Tue, 10 Sep 2024 21:11:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Snehal Koukuntla <snehalreddy@google.com>,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] KVM: arm64: Add memory length checks and remove inline in do_ffa_mem_xfer
Date: Tue, 10 Sep 2024 21:11:52 +0100
Message-Id: <172599899804.385892.17266018060492319071.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240909180154.3267939-1-snehalreddy@google.com>
References: <20240909180154.3267939-1-snehalreddy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, snehalreddy@google.com, r09922117@csie.ntu.edu.tw, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, sudeep.holla@arm.com, sebastianene@google.com, vdonnefort@google.com, jean-philippe@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 09 Sep 2024 18:01:54 +0000, Snehal Koukuntla wrote:
> When we share memory through FF-A and the description of the buffers
> exceeds the size of the mapped buffer, the fragmentation API is used.
> The fragmentation API allows specifying chunks of descriptors in subsequent
> FF-A fragment calls and no upper limit has been established for this.
> The entire memory region transferred is identified by a handle which can be
> used to reclaim the transferred memory.
> To be able to reclaim the memory, the description of the buffers has to fit
> in the ffa_desc_buf.
> Add a bounds check on the FF-A sharing path to prevent the memory reclaim
> from failing.
> 
> [...]

Applied to next, with the BUILD_BUG_ON() issue fixed.

[1/1] KVM: arm64: Add memory length checks and remove inline in do_ffa_mem_xfer
      commit: f26a525b77e040d584e967369af1e018d2d59112

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


