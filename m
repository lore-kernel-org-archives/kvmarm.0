Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2353D3A0
	for <kvmarm@lists.linux.dev>; Tue, 30 Apr 2024 08:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714464989; cv=none; b=H98ZbVFYiroPDl2E8xVYX9y1RXLyv9D8DlkQN6jVZDXux/lDUB547abhGhrfy5sknXhf63B/S6NLSG3pyOese7X5IJjBaWV5cYvEa2yFuqDMuqdYutZ8F+GLp6pAG3t8MIPoxW3OJOOucoGC/UZRy/gbAdKGuzKY2iqbbsWhYSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714464989; c=relaxed/simple;
	bh=NVnYxW3QJTYutfxbXtgnau80hytg/yoaTvbkE0xdzNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=poZcFhXx1bAcITtV74cAGZOZmgpbboo6s/QWt7cIpaN1+x5riGBTiIlBnNnuRhQ0Jzq0YvvrYc8IlCRoHjCH4BRQo0V/4ZP9kHapqy1ihzMG7Vw/LB7N/syEw+vc3n3d2uLzCkRQe2ZHthLlPsb+b73kkbVlu7QQDIp6MNJDk5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SlV+D0av; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SlV+D0av"
Date: Tue, 30 Apr 2024 08:16:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714464985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T1DaGfqTyGVEyeX19SrydI+o+zjIl3xtcFF9hoCYjaU=;
	b=SlV+D0av5BmTvJXBD8xZELozjub0db0BK9W7166KlA+hewHlTkrN7reV0BY6P/9vX1L8v7
	Cj/p6TaOcTpMvvNJv0H5MTG8+ZsZNDAvfKSkWChzf00RrDSvCwuIspu9/mrmJnbeDpuEeq
	AFmZN+hci4MYY8NpmkQ2Su+fMAf84w8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	James Morse <james.morse@arm.com>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.9, part #2
Message-ID: <ZjCo1Qj4k-mbNXtD@linux.dev>
References: <ZilgAmeusaMd_UeZ@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZilgAmeusaMd_UeZ@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 24, 2024 at 12:39:46PM -0700, Oliver Upton wrote:
> Hi Paolo,
> 
> Single fix this time around for a rather straightforward NULL
> dereference in one of the vgic ioctls, along with a reproducer I've
> added as a testcase in selftests.
> 
> Please pull.

Nudging this, Paolo do you plan to pick this up or shall I make other
arrangements for getting this in?

> -- 
> Thanks,
> Oliver
> 
> The following changes since commit fec50db7033ea478773b159e0e2efb135270e3b7:
> 
>   Linux 6.9-rc3 (2024-04-07 13:22:46 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.9-2
> 
> for you to fetch changes up to 160933e330f4c5a13931d725a4d952a4b9aefa71:
> 
>   KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF (2024-04-24 19:09:36 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.9, part #2
> 
> - Fix + test for a NULL dereference resulting from unsanitised user
>   input in the vgic-v2 device attribute accessors
> 
> ----------------------------------------------------------------
> Oliver Upton (2):
>       KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()
>       KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF
> 
>  arch/arm64/kvm/vgic/vgic-kvm-device.c           |  8 ++--
>  tools/testing/selftests/kvm/aarch64/vgic_init.c | 49 +++++++++++++++++++++++++
>  2 files changed, 53 insertions(+), 4 deletions(-)
> 

-- 
Thanks,
Oliver
