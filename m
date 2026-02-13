Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EC4347BDC
	for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 11:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770983423; cv=none; b=Qyu2ySmJZndASaP9UsmG9Oo7VykPVGSPGEt4n3Es+GRZgOTIbWWCXivJUQemb+ZwP9rEBdBYVkcCZxlAeSbZPfPtJWRU8OjZhvSQoeISZfKHeJnFDh4eC8F/M5kM+Y4CMjWl3yJ7DhaxJ2hd/9wy48FFQSgHGIOt66u/zkgYfm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770983423; c=relaxed/simple;
	bh=IA7py+VkxSXmQX5i7N3ZSjefyqj9pWVBggAoLp9bFnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PJSgwPf3O/OEc7wnqsSEwmQgoWB5+QvLJpyOcptISQ00sV25sKRPDdf5s2u2bu1F1qmDiDmHjVQ/OznKaMQBjKLVA1Z8/fq5R2y1uDOt14i5+smx1W6rFC+v0cUvEdOninmap+kOOaBxkCOccHgl0dR6r/+vCDr3o4+PWcjIvD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j6MSJXKl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j6MSJXKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4F3C116C6;
	Fri, 13 Feb 2026 11:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770983422;
	bh=IA7py+VkxSXmQX5i7N3ZSjefyqj9pWVBggAoLp9bFnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j6MSJXKlKBYkEOIzUjmeOsOq73irttsPSO9huPOIy+XZUW2WUz4VH2x52PidgkoIz
	 BbrFcIMSzpF2icxHxFz4K052ko8VDo2gjQGuZuSY55a/adZ0RwO9PWu/Ibgo503d08
	 5QyozIOCN5+Lxvb+BcqMsmWgLaH29MZVcRE2RpnAdPLJpDPQURcA+JW3pADakqqg3n
	 2/XSPG9Wman4fcDCWix3laD05vzXN38pEdabqeU7aBIw1GfkyYsquMBLrwDswmKtHj
	 L4oFI10+xt8cetVJpg7Z4rofL9+5PryyfjyNJVRW+zLWJfrPjOK706Y0rhx4aWoqe3
	 xSlKP/+aNGXrw==
Date: Fri, 13 Feb 2026 11:50:17 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>, kvmarm@lists.linux.dev,
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com
Subject: Re: Broken udelay() on KVM host with a vcpu loaded
Message-ID: <aY8P-ccWbKobEL-d@willie-the-truck>
References: <ktosachvft2cgqd5qkukn275ugmhy6xrhxur4zqpdxlfr3qh5h@o3zrfnsq63od>
 <86qzqsbw1m.wl-maz@kernel.org>
 <aYtP_rgolLfm_UDD@willie-the-truck>
 <motrqsddhooajk66sq75dt74huvxmwtreoznwc6yjqirit36bl@2mlt2546mjnp>
 <86o6lwbchv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86o6lwbchv.wl-maz@kernel.org>

On Tue, Feb 10, 2026 at 07:54:36PM +0000, Marc Zyngier wrote:
> On Tue, 10 Feb 2026 15:58:14 +0000,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > Ouch, it does seem that the SET_ONE_REG stuff allows to mess with that
> > value _out of vcpu context_, so yeah userspace could change the value
> > while a vcpu thread is preempted in the middle of a udelay loop ...
> 
> I don't think so. You can only do that on the vcpu fd, and if the vcpu
> is loaded, it means that you are already holding the vcpu mutex. And
> if you do that from the vcpu thread, then you already have done a
> vcpu_put().

Just working this through, I think you're right that the vCPU mutex
saves us here (thanks!), although that's because it's held across the
duration of the KVM_RUN ioctl() and not because of the vcpu_put() (which
would run off the back of the preempt notifier if we were preempted
anyway). It would be good to capture that in a comment if we go with
your approach of using the virtual counter on the host.

There's also a VM ioctl for messing with the offset
(KVM_ARM_SET_COUNTER_OFFSET) but that uses kvm_trylock_all_vcpus() so
it's fine.

Will
