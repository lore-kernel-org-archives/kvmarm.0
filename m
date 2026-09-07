Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 122E3377015
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 18:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788806092; cv=none; b=XQayzHZ2OdGfz3o5t1WbAHvxgKsdA+M90FA1si3MdDSCsnC1vOMU+y8zCrEvtUgoL/d1x5XTn/88k8pRoqh+cLUQqKaDmruAdGzrG3mHCLRgbl7VHTd6YHnlk2kNRA4++x/Au98rKe6Cul3kbXfilRZ4S19TslmQJZRlxUcX3Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788806092; c=relaxed/simple;
	bh=Ox53w8vlukQqk29PxMv7Of5O2VoRl9viNkh3MI9BUgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ml06EaQqoBGT2s4PCKkpEyWPKvAuRJm9/8sEP0KTAI908s7T08sNNFHDrmcozPr5tezAQpZyWfbO0ywfX5bUe9adBxIR5txEDszvZIO5thiIfxUvDCAzlrYzK83VtwmS+p710BaDZLVSMppIvSzV2Kj2oin8CBnyQTFoftlassM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fsTMVaqy; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fsTMVaqy"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BD011476;
	Mon,  7 Sep 2026 11:34:46 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0E44E3F528;
	Mon,  7 Sep 2026 11:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788806090; bh=Ox53w8vlukQqk29PxMv7Of5O2VoRl9viNkh3MI9BUgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fsTMVaqyP/VWuAhLNnQQpYB8ddw7IBWV7Q8jbcfyZ+kOJYAj44jj5UYtNph0sT1VJ
	 G/spHE65/+01gqUlv7kTaDRoBEmzV5ARLYR8+1zOSQ6cdbx6PZbunfUm21YKusnUPv
	 a2Imhi0CcQEnpwhsqfnvLBWDEiGx5RT0/Rw2Eesg=
Date: Mon, 7 Sep 2026 19:34:40 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org, 
	oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 01/20] KVM: arm64: Prefault host stage-2 entries on block
 split
Message-ID: <paokd4d2c3x2rnkoa7pwtsa4t6rwdgbcbtaytt5qbhxe2xk3kr@2nsyoy7i2hst>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-2-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803100904.3563942-2-vdonnefort@google.com>

On Mon, Aug 03, 2026 at 11:08:45AM +0100, Vincent Donnefort wrote:
> From: Keir Fraser <keirf@google.com>
> 
> For the host stage-2 that is idmap, we can avoid lazy-mapping on block
> splitting by propagate existing valid mappings to neighbouring entries
> of the new table.
> 
> Co-developed-by: Quentin Perret <qperret@google.com>

I believe the co-author also needs a Signed-off-by line.

Thanks,
Wei-Lin Chang

> Signed-off-by: Keir Fraser <keirf@google.com>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b74dd5ce1efd..34f78a58cded 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1030,10 +1030,39 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
>  	return 0;
>  }
>  

[...]
