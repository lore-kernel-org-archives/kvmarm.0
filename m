Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E892080C0;
	Thu,  8 May 2025 10:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746700347; cv=none; b=aR9AL3zO+NkpfncuIfrs9INqBIqKVdiOFhZRNZKKIboPp/tR1AXf6NbJhLXwHrbefYbVF0oe+T8XvKeYMHBhzmeQltkEF6kkPK9D8PZOAAUS0Go7zwteJoGSkof/NhhXwBpRtMmNvLH7IyMbA1FB/VnhsyYieKegXdJEuJuD82A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746700347; c=relaxed/simple;
	bh=fPyoI7GcCfxKWwChni9nUi+L2Wk2v6G0KwoooXekSVo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BspaOuYAHBAl9CnwQVlxirfI+pA7X45ZfPJfGW4ugNnd2+r8af6/n2YLATYWd6kcSMdKRJnoIRn5NOzYyaJxMUtk25EzGQ/cMtnwbdcgk6Z0dVWpgc8LVlkzckx8qRUbSaIvMg+YNiK7U8BjUxJAchWkBGO27vYPrclgeESaKGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TnYsoKeW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TnYsoKeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61736C4CEE7;
	Thu,  8 May 2025 10:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746700346;
	bh=fPyoI7GcCfxKWwChni9nUi+L2Wk2v6G0KwoooXekSVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TnYsoKeWnumJC7kHcV86iLinM+qGPnU5j8s0Dnzx8wx027ZTNi/PHAMDfoegmS8zb
	 tW1tRNHwZN6Y0A4QYcyYtatGe4DZemNncfzskryPkrhrtHDR3oic4acBp2zKpKjsxW
	 4VLK1jbG53CrXSMdzX7wy1KUNF+I4hXFL8Ao9o6g4S8Reat5T2sz13mMgX0WVsHoEX
	 N7sMGe9gOp+hzGZsfAk488f19lvbHRXNga5ER8WzWdfeKZxm3s6kPDlfWTkcedbaTs
	 GnUbvEiTWje7lcp3AwxbaULnIb/yBOIxbSKNI3ILUwaPz9LSxuWtYB/zUogPNP7Kb7
	 F8Q2yu+/em/ng==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCyYC-00Cy6h-34;
	Thu, 08 May 2025 11:32:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	qperret@google.com,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	shan.gavin@gmail.com
Subject: Re: [PATCH] KVM: arm64: Drop sort_memblock_regions()
Date: Thu,  8 May 2025 11:32:20 +0100
Message-Id: <174670033399.833075.10663406924785088950.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250311043718.91004-1-gshan@redhat.com>
References: <20250311043718.91004-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, gshan@redhat.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, qperret@google.com, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, shan.gavin@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 11 Mar 2025 14:37:18 +1000, Gavin Shan wrote:
> Drop sort_memblock_regions() and avoid sorting the copied memory
> regions to be ascending order on their base addresses, because the
> source memory regions should have been sorted correctly when they
> are added by memblock_add() or its variants.
> 
> This is generally reverting commit a14307f5310c ("KVM: arm64: Sort
> the hypervisor memblocks"). No functional changes intended.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Drop sort_memblock_regions()
      commit: 00b0300cf1e265b8f3fa57106b940eff6f388d57

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


