Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6959E36126
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 22:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718922322; cv=none; b=KjS5eVvUOz2tQT7jD1kk6yt8gKQ8hPewImBKzvZkGw+jhDB5VVtqWMgqfmSfXt8onVaSQqam6yzpK52RTbFn0iq+PzTzNAr35FuttvvKYpFlpwJBNgR2x3/viVbIqzjtWOvSoyTJmCMsXjc6tU83jB4rBxg0W7fHflN1MQjDo0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718922322; c=relaxed/simple;
	bh=vOe00d5j/GRKKvnR0SNgjWpMOZX3TOzny5aWvhsRJRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=if+fXW3rFI0rm7Rjhn2Dvmpn4v/CxIKo40ujJa47fUdAhIDAQQc9alM6itIHvU/8xQyoiFR73NORUuSFTAbpsCdfRL4iZYmkF5qyWzIse0WbSu9OfhStJyhZEuDFTQKejThluKk3mA5+FGCb2krzYJQZjQ2Qe+fHcfUJfhjjArI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pEdK0dhl; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pEdK0dhl"
X-Envelope-To: jiangkunkun@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718922314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2HOphrwM8ahMoEd8ea1CfPz+XIb/VONzJcmnDUUVW20=;
	b=pEdK0dhlAlB2nt4kZOtVidCzxzCpFUa7hGiAp1o2YOcqeqIp4RuLtQA62ti0lET9UHXlOL
	1iivbVqTGJHkNQy1kYysKggv+uSsTLzW637k0pACCMfgN6HtagWWmByJ1Lfc5cJneorwi1
	kgwGf9DdN0EC2jFP9XCiTNdeFmI4hk8=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: will@kernel.org
X-Envelope-To: rdunlap@infradead.org
X-Envelope-To: eauger@redhat.com
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: wanghaibin.wang@huawei.com
X-Envelope-To: lishusen2@huawei.com
Date: Thu, 20 Jun 2024 22:25:02 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
	Eric Auger <eauger@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	wanghaibin.wang@huawei.com, lishusen2@huawei.com
Subject: Re: [PATCH 1/3] KVM: arm64: vgic-its: Add a data length check in
 vgic_its_save_*
Message-ID: <ZnSsPmfBXMGRYPmL@linux.dev>
References: <20240620130650.1279-1-jiangkunkun@huawei.com>
 <20240620130650.1279-2-jiangkunkun@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620130650.1279-2-jiangkunkun@huawei.com>
X-Migadu-Flow: FLOW_OUT

Hi,

On Thu, Jun 20, 2024 at 09:06:48PM +0800, Kunkun Jiang wrote:
> In all the vgic_its_save_*() functinos, it does not check
> whether the data length is larger than 8 bytes before
> calling vgic_write_guest_lock. This patch add the check.
> 
> Link: https://lore.kernel.org/kvmarm/86v82ckimh.wl-maz@kernel.org/
> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 40bb43f20bf3..060605fba3b6 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2094,6 +2094,7 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
>  	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
>  		ite->collection->collection_id;
>  	val = cpu_to_le64(val);
> +	BUG_ON(ite_esz > sizeof(val));

Does it really make sense to blow up the kernel over this? (hint: no)

What _might_ make sense if if you bugged the VM and failed the ioctl,
i.e.

	if (KVM_BUG_ON(ite_esz != sizeof(val), kvm))
		return -EINVAL;

Also, this isn't even asserting the right thing. You want to assert that
the u64 being written to memory is *exactly* the size of a single ITE.
No more, no less.

>  	return vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
>  }
>  
> @@ -2246,6 +2247,7 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
>  	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
>  		(dev->num_eventid_bits - 1));
>  	val = cpu_to_le64(val);
> +	BUG_ON(dte_esz > sizeof(dte_esz));

Did you even test this? A bit of substitution arrives at:

	BUG_ON(8 > sizeof(unsigned int));

See the issue?

Please do not test these sort of untested patches on the list, it is a
waste of everyone's time.

-- 
Thanks,
Oliver
