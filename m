Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE3A18858A;
	Fri, 29 Nov 2024 09:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732874300; cv=none; b=GZPhVCpFvZdKyQECpyeNPH5tTBNMQvbkGo0bm/u9E5yk4wlP+jGjcwqebYWYpy4VMiSy0c36iDrDx5rm43MekfciHwtwUPUH+diLJxVtUbdz1dxg027wWtNBUvoDNJUeDssFMex818dVmn4il4KR49GjsRv8Fdt+gLsuA31VBFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732874300; c=relaxed/simple;
	bh=b3I9qr/L+dZimBd48x5jitIlhaZduHneXsbuO2bUb18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nVmObEo1HvErXJM2PEu7Z4tTQt5aCO/2gkUIZHPM9Nviiei/saUYf9n/eePEfRUAYQMk53j7N5ea9R/HkgNhO466k09beQAfrb2VPewuQJr38Sm51tN71cB1BsBTLX0wpS6PzjsjrwwzLGDZT702TRsPlFMwB/VMXaoUejnmEyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iFb6pMjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iFb6pMjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB079C4CECF;
	Fri, 29 Nov 2024 09:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732874298;
	bh=b3I9qr/L+dZimBd48x5jitIlhaZduHneXsbuO2bUb18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iFb6pMjJb/KBhpXJDU4lD2/QSmEZSL9NfXB4ZXJsE2d4Ar20NhTU6SIq1pm/2toNK
	 SFCVBGfwais5M7ThYzZmGS8nyNZRCRobUPYgY9CXmju+3tj26he6AjSrZPKAWTon7i
	 0aYPYGVHQ9+y5O/DHVOSWPy+cVgAx7vysrOyCCQY8lHuFCwQkrCoS3mqUrzq9MaJ7k
	 NWKAU3n4X94fqxBYIQcx/k4xUikiqr7r7fqwgFzmqTBtqHW84/z8dGWJBnUqoyCgay
	 i2D5Syv4+8LaeCmnhJ29ZJNN10krGaV8ddfNm3jriQ0T7Tpaipn+5npT4YHc1H5e1X
	 IMW1VI2DLo0Ag==
Date: Fri, 29 Nov 2024 09:58:13 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Always check the state from hyp_ack_unshare()
Message-ID: <20241129095812.GA4298@willie-the-truck>
References: <20241128154406.602875-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241128154406.602875-1-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Nov 28, 2024 at 03:44:06PM +0000, Quentin Perret wrote:
> There are multiple pKVM memory transitions where the state of a page is
> not cross-checked from the completer's PoV for performance reasons.
> For example, if a page is PKVM_PAGE_OWNED from the initiator's PoV,
> we should be guaranteed by construction that it is PKVM_NOPAGE for
> everybody else, hence allowing us to save a page-table lookup.
> 
> When it was introduced, hyp_ack_unshare() followed that logic and bailed
> out without checking the PKVM_PAGE_SHARED_BORROWED state in the
> hypervisor's stage-1. This was correct as we could safely assume that
> all host-initiated shares were directed at the hypervisor at the time.
> But with the introduction of other types of shares (e.g. for FF-A or
> non-protected guests), it is now very much required to cross check this
> state to prevent the host from running __pkvm_host_unshare_hyp() on a
> page shared with TZ or a non-protected guest.
> 
> Thankfully, if an attacker were to try this, the hyp_unmap() call from
> hyp_complete_unshare() would fail, hence causing to WARN() from
> __do_unshare() with the host lock held, which is fatal. But this is
> fragile at best, and can hardly be considered a security measure.
> 
> Let's just do the right thing and always check the state from
> hyp_ack_unshare().
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index caba3e4bd09e..e75374d682f4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -783,9 +783,6 @@ static int hyp_ack_unshare(u64 addr, const struct pkvm_mem_transition *tx)
>  	if (tx->initiator.id == PKVM_ID_HOST && hyp_page_count((void *)addr))
>  		return -EBUSY;
>  
> -	if (__hyp_ack_skip_pgtable_check(tx))
> -		return 0;
> -

Acked-by: Will Deacon <will@kernel.org>

I suppose __hyp_ack_skip_pgtable_check() is now quite poorly named,
since we only want to use it in cases where the page is PKVM_PAGE_OWNED
by the initiator. Hopefully nobody smart tries to add it back here!

Will
