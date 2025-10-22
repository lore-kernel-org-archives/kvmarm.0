Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546CD311972
	for <kvmarm@lists.linux.dev>; Wed, 22 Oct 2025 09:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761123959; cv=none; b=dWbdZPKChKoUT00jxyUBGawYh1/0K8YGSMisN+kDmXmIo1nc/CDPjiro3ULTsvkVJF42Df1ZgfIQWDEucBv6YsD6fY/pfoC1ydGOa0VWho3Yr5f78WjEmC7oB2mrUATWoYfYS14wgYt3UCR2goEu8mub7IAJOURP8CgygjgngLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761123959; c=relaxed/simple;
	bh=ApO2QqFStd1/kutvxA3M9wcEyccDYzEZCHemELCX4+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gtBqlH9p4F/CBG8QjzP3LkPjbzLdCsmCuGk/jiQiV+nExReImRIEGL0hv/kFPjo9G8AAVPLzj/90V6ebAB1wH38+j9+r4tlO09a7YEyqrjDshM8YzHMFQ8cSkT+YIhwGtvzicashMbu0GZk6pbbS7TktVEHicWw3jfaZ/juUbbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K/i6fFuL; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K/i6fFuL"
Date: Wed, 22 Oct 2025 02:05:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761123955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mcx0Cd6fRztVt7bkpklMEX95Zbxxj526FWgRQl5fSRc=;
	b=K/i6fFuLjg5vwpn+mIWLLzRZVxspMEW4XQOKbpL8gQpbSs+FIO/Wu7C88Ndmpb5oAqinxB
	tL3qA/ChXpXT3yqbgQ1psqp3XswW7mEa8LrXKSPVzF9cn2+LUavKnqYOHlROKyV83EsOP9
	hR4znd16xgtwJtWZekODYlt75a6Oc/k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Itaru Kitayama <itaru.kitayama@linux.dev>
Cc: kvmarm@lists.linux.dev
Subject: Re: RFC KVM: arm64: selftest: stage 2 mapping helpers
Message-ID: <aPieUS7BTQB_dUFs@linux.dev>
References: <10A5745B-411F-4EB3-A168-0BC6CA99FF4D@linux.dev>
 <aPbL8NCPCfLHIB3w@linux.dev>
 <aPhq1tKKQCxhae43@vm4>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPhq1tKKQCxhae43@vm4>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 22, 2025 at 02:25:42PM +0900, Itaru Kitayama wrote:
> Hi Oliver,
> Thanks for your review. Below is the updated helper patch and a test program
> which does ERET in L1 guest (in guest_code). However, upon execution I keep 
> getting IABTs from lower EL.

I don't have the time to help debugging this, you'll need to spend some
time on this if you can.

> int main(void)
> {
> 	struct kvm_vm *vm;
> 	struct kvm_vcpu *vcpu;
> 	struct kvm_vcpu_init init = {};
> 
> 	/* Check we're on a NV2 hardware */
> 	if (!kvm_check_cap(KVM_CAP_ARM_EL2))
> 		exit(KSFT_SKIP);
> 
> 	vm = vm_create(1);
> 
> 	kvm_get_default_vcpu_target(vm, &init);
>         init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
>         vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);

Keep in mind that aarch64_vcpu_add() will wind up initializing the EL2
CPU context when HAS_EL2 is set. To get a functional EL1 you'll need to
initialize the EL1 CPU context, including the MMU and allocating a
separate stack.

You can probably get away with reusing the EL2&0 page tables at EL1 so
long as the stage-2 translation is an identity mapping.

Thanks,
Oliver
