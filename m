Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6FC0364057
	for <kvmarm@lists.linux.dev>; Sat, 12 Sep 2026 07:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198206; cv=none; b=YyMb0q1y3df9eMiDH08rqTo2doIRZv2gCO0GBOt2jXMcd5vmJMS9XwaDLYP9ngvPl3A9yq4Hu/F9NJvXgb3X5qAY5NEw0hWlL/gxlAVKHUVylS0CfyGLFWz+08gcyVfH5CXywdNhg7/2werkBjxOW9GCsOkshf9x3fzHToODqQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198206; c=relaxed/simple;
	bh=9xmDwIJXv8L7N9NrAJj92+QxRvL7KpgrKc/hpWtuVtA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xakp2qUXE9JffzXmfuDtGi1uqN3DBHf1135BBXftu9xyhWVYF02+EAjryx9WFAhIcNjoG1XRaH9Bk3GqkEKUYApNXBMPli26prFhZXJiooacew3wvaEg+7YvxjoZ6FtUYE+A7vQaX6z0uQ6Ar1O7Mu4u2q6dukSbu0doTW6oPbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hdhMZ+sC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hdhMZ+sC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49A1E16F2;
	Sat, 12 Sep 2026 00:29:59 -0700 (PDT)
Received: from [10.57.10.2] (unknown [10.57.10.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C2F93F7D8;
	Sat, 12 Sep 2026 00:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789198202; bh=9xmDwIJXv8L7N9NrAJj92+QxRvL7KpgrKc/hpWtuVtA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hdhMZ+sCKY9b1Z9bZRkHsLOQ54Fsj1pwUYmGkBYtSJr+3wwGONmgg/5QurTTd3LkE
	 c1ZzysJnJUGxDId0PUkxMM4MuCtksyqyyhhtMf8zAnrQ30X4Sjn7si6tPg6mq27PP7
	 xNm3PHW29zFh6BhQCY30u0Xx+FAbGKkbaLTJnb58=
Message-ID: <f0cf2d64-c7c3-49ec-b3c8-bd1f30270411@arm.com>
Date: Sat, 12 Sep 2026 08:29:59 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool 5/5] arm64: Query counter-offset support on the VM
 fd
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <20260831192406.1341841-1-fuad.tabba@linux.dev>
 <20260831192406.1341841-6-fuad.tabba@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260831192406.1341841-6-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/08/2026 20:24, Fuad Tabba wrote:
> kvm__arch_set_counter_offset() probes KVM_CAP_COUNTER_OFFSET with
> kvm__supports_extension(), which issues KVM_CHECK_EXTENSION on the
> global /dev/kvm fd. That reports the host's raw capabilities, unaware of
> any per-VM restrictions.
> 
> pKVM does not offer the counter offset to a protected VM, and reflects
> that on the VM fd alone. kvmtool's own check passes, and the
> KVM_ARM_SET_COUNTER_OFFSET that follows is refused by
> commit b12b3b04f6ba ("KVM: arm64: Check whether a VM IOCTL is allowed
> in pKVM"):
> 
>    KVM_ARM_SET_COUNTER_OFFSET: Invalid argument
> 
> Query it on the VM fd via kvm__supports_vm_extension(), so
> --counter-offset on a protected VM fails with kvmtool's own message:
> 
>    Fatal: No support for global counter offset
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> ---
>   arm64/kvm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arm64/kvm.c b/arm64/kvm.c
> index 36b3284..0bb3535 100644
> --- a/arm64/kvm.c
> +++ b/arm64/kvm.c
> @@ -155,7 +155,7 @@ static void kvm__arch_set_counter_offset(struct kvm *kvm)
>   	if (!kvm->cfg.arch.counter_offset)
>   		return;
>   
> -	if (!kvm__supports_extension(kvm, KVM_CAP_COUNTER_OFFSET))
> +	if (!kvm__supports_vm_extension(kvm, KVM_CAP_COUNTER_OFFSET))
>   		die("No support for global counter offset");
>   
>   	if (ioctl(kvm->vm_fd, KVM_ARM_SET_COUNTER_OFFSET, &offset))

