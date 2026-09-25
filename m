Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2542741687D;
	Fri, 25 Sep 2026 11:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790337406; cv=none; b=Fo/TE8z9QELCsRKOJNhMYCA1BbWdgghXrt6dfxiY+n3LRqbgdB+CkdCKybuekAVQetWxmXHgXTFvrJEySnQNKDoZQsFOAXfG0Zl315OTfw4QsDPzBUeKx7g0Ii4ofyWt/PwIMqIcl6RJmfs2HqlBOC25+oqZHfCxgyljexfJ7SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790337406; c=relaxed/simple;
	bh=NWvP4bp61oJ9JUE/KO0abBEniNY3zf5ZJnrDX2baCh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TXxG+bJj95Vcj73Y3IqVWE9Ie9L6Z8wqi9bEXum6993+N+6VHNNxrtzYOREH1oAUg1VE0IGM1Y/YVjG1jUju09lpzbEA3trotHljTqyAgxxOuhHCHY9L/ka32r6zLPhbTCpncntNWzj+LFfP3L69hRnSNpca2TPAJlD2kOMPCew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ruy17rAU; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ruy17rAU"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07BF3169C;
	Fri, 25 Sep 2026 04:56:41 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ACE8D3F86F;
	Fri, 25 Sep 2026 04:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790337404; bh=NWvP4bp61oJ9JUE/KO0abBEniNY3zf5ZJnrDX2baCh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ruy17rAUaPubtMkD0lV1Gdg3WSAAQRlrEPuUowdOFMWXkOOQCxEJCmtmZqFurmwue
	 R6mXbNJYY9CC6Rr4JH3y34FHWuZJJgTV6FqaLY2I3ohMrahzAtSOKy04ThwmO7rBOR
	 vz4yUVKMAA0mANNhxAUssHGtLbZzoZsOxsJ+kNQs=
Date: Fri, 25 Sep 2026 12:56:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
	sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
Subject: Re: [PATCH v19 7/7] firmware: arm_rmm: Add wrappers for Realm
 related RMI commands
Message-ID: <arZhdzjoOejKdAvp@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-8-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924135201.850038-8-suzuki.poulose@arm.com>

On Thu, Sep 24, 2026 at 02:52:01PM +0100, Suzuki K Poulose wrote:
> + * rmi_rec_create() - Create a REC
> + * @rd: PA of the RD
> + * @rec: PA of the target REC
> + * @params: PA of REC parameters
> + * @sro: Allocated SRO context to be used
> + *
> + * Create a REC using the parameters specified in the struct rec_params pointed
> + * to by @params.
> + *
> + * Return: 0 on success, positive RMI result code or negative Linux error code
> + */
> +static inline long rmi_rec_create(unsigned long rd,
> +				  unsigned long rec,
> +				  unsigned long params,
> +				  struct rmi_sro_state *sro)
> +{
> +	long ret;
> +
> +	sro->addr_count = 0;
> +	sro->regs = (struct arm_smccc_1_2_regs) {
> +		SMC_RMI_REC_CREATE, rd, rec, params
> +	};
> +	ret = rmi_sro_memxfer_execute(sro, GFP_KERNEL);
> +	rmi_sro_free(sro);
> +
> +	return ret;
> +}

Nit: isn't this just open-coding rmi_sro_memxfer_cmd()?

-- 
Catalin
