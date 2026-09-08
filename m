Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7466654A7C4
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 13:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788874256; cv=none; b=QiIfv0lodcHP2SXptsYG8PehIVQVzgXxfG0QdFA4zvsF0DKONpPuvgobGUZy00bVEv97ytRgDUi79czBS3+nTWdTEWeqs1UEE6cyvtVAlXVH63LzzvBHrTtJeWvyztkO6CE6jkxR/L6bl2zA+hU+maWzJ8m/Ss+eiufiffSYN30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788874256; c=relaxed/simple;
	bh=FxlANSqLJch9ogY8r6MxlelWgMUH7qzZHSmD70GaCso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qo4HTPCChDHrjSHJ7MmeMAb9106Gwd2rd7pcE3gWbAmnZRh+rH/iqY9Bu9CC28vawXrqH7Cd7V5LBxrGQ6DIKZfR9vsBi0m1VyMDRtCXJv0DE0WjGAnOBrb65U8Ch0k3ezh6aKy55XpKAzzZQKdDnF3BIU9JvJw6Q7RIOscQ0aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lyG7t7rE; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lyG7t7rE"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FA301476;
	Tue,  8 Sep 2026 06:30:46 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6943D3F7B4;
	Tue,  8 Sep 2026 06:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788874250; bh=FxlANSqLJch9ogY8r6MxlelWgMUH7qzZHSmD70GaCso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lyG7t7rEGrKJcY9HdIQobQqmfLmq4ib8+qD0XWx8DKRxyZ01Xa2tPfvU9Uzq/BAzP
	 YWcpzlkshGxMwBTwJnLPiunzu/UxKSecYAUBK12IFiR4CP6d5ZFvX4dW750axagK2Q
	 1GvLjM0g1GSPKJfjLquP5rBvTnqo9oDXxh2G7CK8=
Date: Tue, 8 Sep 2026 14:30:40 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix the KVM_ARM_PREFERRED_TARGET
 documentation
Message-ID: <ea5gctsvi2j77avgo7r4esll33zwlscddlmu5obakmyxguvdpe@qaykd5afjamb>
References: <20260831162815.269851-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831162815.269851-1-fuad.tabba@linux.dev>

On Mon, Aug 31, 2026 at 05:28:15PM +0100, Fuad Tabba wrote:
> KVM_ARM_PREFERRED_TARGET has never set a feature bit: the original arm64
> implementation zeroed the bitmap, and kvm_vcpu_preferred_target(), which
> only ever zeroed it, was removed by commit 5346f7e13e5e ("KVM: arm64:
> Always return generic v8 as the preferred target"). The ENODEV error had
> gone earlier still, with commit 08e873cb70f3 ("KVM: arm64: Change the
> return type of kvm_vcpu_preferred_target()"). Document what it returns,
> that userspace selects vCPU features itself, and drop the error.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>

> ---
>  Documentation/virt/kvm/api.rst | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index e0430cc750c9e..193f3b0ec77d1 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -3600,20 +3600,14 @@ Possible features:
>  :Parameters: struct kvm_vcpu_init (out)
>  :Returns: 0 on success; -1 on error
>  
> -Errors:
> -
> -  ======     ==========================================
> -  ENODEV     no preferred target available for the host
> -  ======     ==========================================
> -
>  This queries KVM for preferred CPU target type which can be emulated
>  by KVM on underlying host.
>  
> -The ioctl returns struct kvm_vcpu_init instance containing information
> -about preferred CPU target type and recommended features for it.  The
> -kvm_vcpu_init->features bitmap returned will have feature bits set if
> -the preferred target recommends setting these features, but this is
> -not mandatory.
> +The ioctl returns a struct kvm_vcpu_init instance containing the
> +preferred CPU target type. The kvm_vcpu_init->features bitmap is
> +returned empty: userspace selects the vCPU features itself, and their
> +availability is reported by the capabilities listed under
> +KVM_ARM_VCPU_INIT.
>  
>  The information returned by this ioctl can be used to prepare an instance
>  of struct kvm_vcpu_init for KVM_ARM_VCPU_INIT ioctl which will result in
> 
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> -- 
> 2.39.5
> 
