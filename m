Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5FA7B3E1
	for <kvmarm@lists.linux.dev>; Fri, 28 Jun 2024 20:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719607771; cv=none; b=WhVX7uBXcHLtItp2b0+EeAoO+gfruuh3lfCpBJ/xvqOp2TsBnql6slxvd11WdfU7L/hwtH39AgNU9HNToWiH9hSiFN7LeYq8a6CJ5cMh1Wb3PKEAOabt/ilNY4kHPctNIaop9gJfk/4urQaEFz36bZnINh26qIVMKw1sYuKgrIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719607771; c=relaxed/simple;
	bh=8Za/lAVwuvWokMBmroq+V5P/zhKL0SfUTTZrERGLYSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BP4so1+Su9RKuGZpGfbhc0IZALHZnT12Gb10BDEaZ8+oi75UHrF+xRq9xz8/HXdUW8ytfrSHdHAzNqQPAmaXxXsYUcXLV4MC9mi6wE6/tnJkIYRWWtIFFvxIl7c8K7P9sGfboaUCdCcDiKqHpYxn/0w8gUrbk6J6oeyK+JpMPD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DldBWtS7; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DldBWtS7"
X-Envelope-To: sebastianene@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719607765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jm4qG4jRCo56oJ0Gz0jQZFPpgs7Y8kASTCWIVGIqg04=;
	b=DldBWtS7JkZ+XMO2kxkCv9BeXtdroJZvvDHu+jjNdE4iSJybzG4ffHXET0pTFxfa5lkXJ0
	/FNgUg7PQ0IR9wwdeCsofKNATSODWS6HreWGN3Q1u5NAWGX7kDcayuAVPM9EfDK4Tkv7Im
	T1QG+OJozVc858vX33SmdzNmSMmnEI4=
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: alexghiti@rivosinc.com
X-Envelope-To: ankita@nvidia.com
X-Envelope-To: ardb@kernel.org
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: christophe.leroy@csgroup.eu
X-Envelope-To: james.morse@arm.com
X-Envelope-To: vdonnefort@google.com
X-Envelope-To: mark.rutland@arm.com
X-Envelope-To: maz@kernel.org
X-Envelope-To: rananta@google.com
X-Envelope-To: ryan.roberts@arm.com
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: will@kernel.org
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: kernel-team@android.com
Date: Fri, 28 Jun 2024 20:49:19 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ene <sebastianene@google.com>
Cc: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com,
	ardb@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, james.morse@arm.com,
	vdonnefort@google.com, mark.rutland@arm.com, maz@kernel.org,
	rananta@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v7 6/6] KVM: arm64: Expose guest stage-2 pagetable config
 to debugfs
Message-ID: <Zn8hzwIEtvBFjdkk@linux.dev>
References: <20240621123230.1085265-1-sebastianene@google.com>
 <20240621123230.1085265-7-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621123230.1085265-7-sebastianene@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 21, 2024 at 12:32:30PM +0000, Sebastian Ene wrote:
> Make the start level and the IPA bits properties available in the
> virtual machine debugfs directory. Make sure that the KVM structure
> doesn't disappear behind our back and keep a reference to the KVM struct
> while these files are opened.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/ptdump.c | 50 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index cc1d4fdddc6e..17649e3cbc8f 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -215,8 +215,58 @@ static const struct file_operations kvm_ptdump_guest_fops = {
>  	.release	= kvm_ptdump_guest_close,
>  };
>  
> +static int kvm_pgtable_debugfs_show(struct seq_file *m, void *unused)
> +{
> +	const struct file *file = m->file;
> +	struct kvm_pgtable *pgtable = m->private;
> +
> +	if (!strcmp(file_dentry(file)->d_iname, "ipa_range"))
> +		seq_printf(m, "%2u\n", pgtable->ia_bits);
> +	else if (!strcmp(file_dentry(file)->d_iname, "stage2_levels"))
> +		seq_printf(m, "%1d\n", pgtable->start_level);

The name of the file suggests sounds like this is the number of page
table levels instead of the starting level of the walk.

So instead:

		seq_printf(m, "%1d\n",
			   KVM_PGTABLE_LAST_LEVEL - pgtable->start_level + 1);

> +	return 0;
> +}
> +
> +static int kvm_pgtable_debugfs_open(struct inode *m, struct file *file)
> +{
> +	struct kvm *kvm = m->i_private;
> +	struct kvm_s2_mmu *mmu;
> +	struct kvm_pgtable *pgtable;
> +	int ret;
> +
> +	if (!kvm_get_kvm_safe(kvm))
> +		return -ENOENT;
> +
> +	mmu = &kvm->arch.mmu;
> +	pgtable = mmu->pgt;

nitpick: pgtable = &kvm->arch.mmu.pgt

-- 
Thanks,
Oliver
