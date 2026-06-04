Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31E43CF97E
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 06:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780555306; cv=none; b=W+hJXzop0mzmm17Eog8q7U2baBO+5kdvgHxZDLMfkTqmcrHMSADaxE+sCxtH4DAZcOLElnhOvsGXXHpK+BE8N5ifGM4R1Q7giQ+cnepncN6aN47yvhsWYWcBTbbOQvPXYQYBcdQEpdTE4IaQFf5hJafjLxXyXRqXKsisDHoZxPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780555306; c=relaxed/simple;
	bh=qqfSr7uYDfnllRkdLwA3MmV+oy61MBbw7p53qEwonLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0eTb/DJyqzIHj53uaexxsJzBLe3G2raeg8jcLBV+foBAFpTnUf1OFF+jGF1O157+iJo1mlw6VdoioGG7PHVFO6bA++J6gHliFBaen52D6IIuseJByR21X/wPrx5OZ/wSrwynBOgRE/ckPytiOm5BNyhdLp9nyqrKj4LSpU4r/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEG1PuDe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEG1PuDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37EA1F00898;
	Thu,  4 Jun 2026 06:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780555305;
	bh=S+cWsncRD03je/liyU9E26MvnIevGkcwfAlxMTWYAhg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dEG1PuDeUMCxLZDz1wMI/Aeheib98GLI9JjfdvCRwyT0NIu0aAqSha66unrJ9nErk
	 9ZFBMDduEtEnPaeA6JmR9LG3OB/nPOfRw7L90ZqFY4Pws4gZUhZhfzdT+D6zNeXW7g
	 7+07ufCean/reg+uU4t5T7LPlj6llAEnvpAygzhwj/rXGAI2SXJQK8JTUsgIlxYZU4
	 Dba6NATbph5g3ptC2B055KghmxmnwQaS1WTVygXqz+lf6Px0ynBoEoV66k5vh+xL2o
	 p6y98fpeQ5ZfZPz9UidRuOU6Shddf4tP5nlNKfJEOGYn+W0c4H5GG+F6wpPORYcMqZ
	 t6XpPvQc5W3zw==
Date: Wed, 3 Jun 2026 23:41:44 -0700
From: Oliver Upton <oupton@kernel.org>
To: Jackie Liu <liu.yun@linux.dev>
Cc: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
	yuzenghui@huawei.com, will@kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM/arm64: vgic-its: Fix memory leak when
 vgic_its_set_abi() fails
Message-ID: <aiEeKGsLg9098OUt@kernel.org>
References: <20260604031426.16109-1-liu.yun@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604031426.16109-1-liu.yun@linux.dev>

On Thu, Jun 04, 2026 at 11:14:26AM +0800, Jackie Liu wrote:
> From: Jackie Liu <liuyun01@kylinos.cn>
> 
> In vgic_its_create(), if vgic_its_set_abi() fails after allocating the
> its structure and setting kvm state, the allocated 'its' is leaked
> because the function returns without freeing it.
> 
> Fix by rolling back the kvm state flags and freeing the its structure
> when vgic_its_set_abi() returns an error.
> 
> Fixes: 71afe470e20d ("KVM: arm64: vgic-its: Introduce migration ABI infrastructure")
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>

vgic_its_set_abi() always succeeds so there's no actual memory leak
here. I'd prefer getting rid of the return value instead.

Thanks,
Oliver
