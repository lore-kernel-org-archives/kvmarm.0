Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8CA5990A
	for <kvmarm@lists.linux.dev>; Thu, 21 Dec 2023 18:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XRyh/wvg"
Date: Thu, 21 Dec 2023 18:27:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703183284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0jZW0b0lm5RMynnWmSejBR19+/LyL1/KkgZ6oIXL75I=;
	b=XRyh/wvgzvJPwABrAu1MA0OdmzIh1K33vCQXcnoSSO1C4xR6Xhl33pLhM8pHnqXvk4aiO3
	5+00f0sGhR13/Qz44jmbdyy5wYNkM94B3BFz8FWYsoHBLKHy/I2QiUDNM3U3SBPQwMtOMp
	Rmemg1S1xZw5ePNCXP77oRWcc7y71/c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ene <sebastianene@google.com>
Cc: will@kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com,
	mark.rutland@arm.com, akpm@linux-foundation.org, maz@kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com,
	vdonnefort@google.com, qperret@google.com, smostafa@google.com
Subject: Re: [PATCH v4 10/10] arm64: ptdump: Add guest stage-2 pagetables
 dumping
Message-ID: <ZYSDr9uYi3cUk_Jt@linux.dev>
References: <20231218135859.2513568-2-sebastianene@google.com>
 <20231218135859.2513568-12-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218135859.2513568-12-sebastianene@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 18, 2023 at 01:59:00PM +0000, Sebastian Ene wrote:
> Register a debugfs file on guest creation to be able to view their
> second translation tables with ptdump. This assumes that the host is in
> control of the guest stage-2 and has direct access to the pagetables.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>

I couldn't see how this patched worked at all until I went back to patch
1 and found this:

> +static int kvm_ptdump_open(struct inode *inode, struct file *file)
> +{

[...]

> +	if (!reg->show_ptdump_info)
> +		reg->show_ptdump_info = kvm_ptdump_show;

[...]

> +}


> +static int kvm_ptdump_show(struct seq_file *m, void *)
> +{
> +	struct kvm *guest_kvm = m->private;
> +	struct kvm_s2_mmu *mmu = &guest_kvm->arch.mmu;
> +	int ret;
> +
> +	write_lock(&guest_kvm->mmu_lock);
> +	ret = kvm_ptdump_show_common(m, mmu->pgt);
> +	write_unlock(&guest_kvm->mmu_lock);
> +
> +	return ret;
> +}

Where are you getting a reference on the kvm struct? You need to do this
to ensure the VM doesn't get destroyed behind your back.

-- 
Thanks,
Oliver
