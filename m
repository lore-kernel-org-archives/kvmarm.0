Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D771D7E41
	for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 04:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782100939; cv=none; b=Z1zeDpzxJ93MgQX5mN+okhK3R3wk02qV7HynVCYhvMr6NVFQaR7g7jAYgot3zvJIP6W+HiCNqpV0xvExn67pX60LbVOVqoOFmL2OlIq3fp6vadrPIDa2Moxer0vwLIw8BwWCTPHvpnUpCY38ZtaRNu7XGaW9TVD65tXJahEPLqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782100939; c=relaxed/simple;
	bh=CD5Ph06CPaXxHfHphhlnVu45e1oyKw0c/V8mkUOTLmo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oVLLygM834BZ8cHOwsi95a1yOmF9j+pOCjFDamlKLTk4MLHkkEEdjFAmGwXgcCe7XGMmsf6VN0ko/nCyfnsE/cpGu5RN/dx88xmSE1Lvk/n5WQUlQvlO8vN4Rwhe0Yuo1oJ4Aph3svVAXOz2aWdJHogl42jUfu52zSy5m2mdsaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wEe9oYFq; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wEe9oYFq"
Message-ID: <7575a845-a542-4b16-b512-aec3126f97f3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782100935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n8KweA+GOAzNbdnfxjRKoY6yg21KoyRjb/aSyCQSquM=;
	b=wEe9oYFqc2SXE/qfiBwSL01qIhMH8Mll+m9cXpnpcrLyCZ7siHRJrwc+6qSfFbgkZMBofp
	Xb2h6NPuQVqokRGgpBt+y+HNkLguAg3pepuPJvpaBDPgJi18FfHL8DfvnzpRnxzQXKxGd2
	EnFAj0RHdwoh2rouVemdtWnY6jVDHt4=
Date: Mon, 22 Jun 2026 12:02:05 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] KVM: selftests: fix steal_time for arm64
To: Sebastian Ott <sebott@redhat.com>
Cc: Jiakai Xu <xujiakai2025@iscas.ac.cn>, Shuah Khan <shuah@kernel.org>,
 Andrew Jones <andrew.jones@oss.qualcomm.com>,
 Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>
References: <20260504112808.21276-1-sebott@redhat.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260504112808.21276-1-sebott@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Sebastian,

On 5/4/26 7:28 PM, Sebastian Ott wrote:
> Fix the following failure to the steal_time test on arm64 by making
> the timer address known to the guest.
> 
> ==== Test Assertion Failure ====
>   steal_time.c:229: !ret
>   pid=18514 tid=18514 errno=22 - Invalid argument
>      1  0x000000000040252f: check_steal_time_uapi at steal_time.c:229 (discriminator 20)
>      2   (inlined by) main at steal_time.c:537 (discriminator 20)
>      3  0x0000ffffa23d621b: ?? ??:0
>      4  0x0000ffffa23d62fb: ?? ??:0
>      5  0x0000000000402b6f: _start at ??:?
>   KVM_SET_DEVICE_ATTR failed, rc: -1 errno: 22 (Invalid argument)
> 
> Fixes: 40351ed924dd ("KVM: selftests: Refactor UAPI tests into dedicated function")
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>  tools/testing/selftests/kvm/steal_time.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index 7df2bc8eec02..76fcdd1fd3cb 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -220,6 +220,8 @@ static void check_steal_time_uapi(void)
>  	};
>  
>  	vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, 1, 0);

This leads to the following failure when the host page size is greater than
the guest's:

[root@localhost kvm]# getconf PAGESIZE
16384
[root@localhost kvm]# ./steal_time 
Random seed: 0x6b8b4567
__vm_create: mode='PA-bits:40,  VA-bits:48,  4K pages' type='0', pages='672'
TAP version 13
1..4
__vm_create: mode='PA-bits:40,  VA-bits:48,  4K pages' type='0', pages='660'
==== Test Assertion Failure ====
  lib/kvm_util.c:991: vm_adjust_num_guest_pages(vm->mode, npages) == npages
  pid=873 tid=873 errno=0 - Success
     1	0x0000000000405a27: vm_mem_add at kvm_util.c:991
     2	0x000000000040241f: check_steal_time_uapi at steal_time.c:223 (discriminator 7)
     3	 (inlined by) main at steal_time.c:539 (discriminator 7)
     4	0x00007fff8b57af3b: ?? ??:0
     5	0x00007fff8b57b007: ?? ??:0
     6	0x0000000000402b6f: _start at ??:?
  Number of guest pages is not compatible with the host. Try npages=4

> +	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, 1);
>  
>  	st_ipa = (ulong)ST_GPA_BASE | 1;
>  	ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);

Thanks,
Zenghui
