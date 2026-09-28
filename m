Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9387B4E06E0
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 14:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790606469; cv=none; b=D7k7q8sgtg7Me3O8xWOLI5wKfVcvvo8UK04vflZcWrJY1Yb7qu1tgvUeEAGpGSV6L7MCv6GgquG+a+WkL1MGzJ3HMP8myKuztAVaPf/PoZymsZAXw2kJvN/id+u9PYO8+SEPQREQFWA9ORmljd7jRA5k0P4wbwQzhbEWBgUact0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790606469; c=relaxed/simple;
	bh=+TIUnXbh6vUGQ7wemfHcey4wwh+A2inWcaMajwFLna4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=hv64v0Cf8cECU+wfhkyMng1lr5gPowpspt3JQzjzE5necCM567OI6cokAGdyX9ujRqd3iVrRje/VcnK7nO2xdGW5T31QRWPKnMgYhVh6ZKrNeAUcT6Ka0oSBSgSOxJMQjiIUlTp78dNOl8GNP2War0nqA7juM6J4U4rg+mZh7UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=I8v8YQZq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="I8v8YQZq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 24D0C1655;
	Mon, 28 Sep 2026 07:40:55 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22ECA3F86F;
	Mon, 28 Sep 2026 07:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790606458; bh=+TIUnXbh6vUGQ7wemfHcey4wwh+A2inWcaMajwFLna4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8v8YQZqMR9j+pDqr77KVAOtM4QZtO6yiXI2UHS9D4sxl1e37lTawPMmv/0u+gpTt
	 12xAjJkud65oryp6O1D9+49971XLjIdfYlrcPdzlhtAY9kXzjS6qA/elkke/loP5SO
	 AVUxZffwBIUeLomUVI8sSFXw+ki0dQqKSFBXpBZI=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 18/22] KVM: arm64: nv: Set access flag on table descriptors at stage-2
Date: Mon, 28 Sep 2026 15:40:54 +0100
Message-ID: <arp8dv7aWGmcqFmJ@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-19-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-19-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:57AM -0700, Oliver Upton wrote:
> Implement access flag updates on table descriptors as required by
> FEAT_HAFT.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 2408d604a1e1..6f540d3481d5 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -133,6 +133,7 @@ struct s2_walk_info {
>  	bool		be;
>  	bool		ha;
>  	bool		hd;
> +	bool		haft;
>  };
>  
>  struct s2_walk_step {
> @@ -234,12 +235,15 @@ static bool should_set_access_flag(struct s2_walk_info *wi, struct s2_walk_step
>  	if (access->type == WALK_ACCESS_NONARCH)
>  		return false;
>  
> -	return wi->ha;
> +	return kvm_pte_table(ws->desc, ws->level) ? wi->haft : wi->ha;
>  }
>  
>  static bool should_set_dirty_state(struct s2_walk_info *wi, struct s2_walk_step *ws,
>  				   struct kvm_s2_trans *out, struct kvm_walk_access *access)
>  {
> +	if (kvm_pte_table(ws->desc, ws->level))
> +		return false;
> +
>  	switch (access->type) {
>  	/* R_RKMHW */
>  	case WALK_ACCESS_CMO:
> @@ -424,6 +428,10 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
>  			return 1;
>  		}
>  
> +		ret = handle_desc_update(vcpu, wi, &ws, out, access);
> +		if (ret)
> +			return ret;
> +
>  		base_addr = ws.desc & GENMASK_ULL(47, wi->pgshift);
>  
>  		ws.level += 1;
> @@ -562,6 +570,7 @@ static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
>  	wi->ha = vtcr & VTCR_EL2_HA;
>  	wi->be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
>  	wi->hd = wi->ha && (vtcr & VTCR_EL2_HD);
> +	wi->haft = wi->ha && (vtcr & VTCR_EL2_HAFT);
>  }
>  
>  int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
> -- 
> 2.47.3
> 


To me it looks the same as the previous one but for S2, and seems correct.

FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
