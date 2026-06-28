Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210A53A7F62
	for <kvmarm@lists.linux.dev>; Sun, 28 Jun 2026 15:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782661490; cv=none; b=YSXS7fU3NRCZItx7334Rq5fdFLX7OFtnMfIdil0hORqpc3xNs7NwsjvG+ydSciLLO+o0h+5ZD23FUDpU8Dh6voawA/rJCBlLneMXJmjbWyg4ZHn5HvCYJmd0cnpABk9GrBUSl8p8RhCqOBRzpMhm34XHQsYV5rn9XVvo11Uit/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782661490; c=relaxed/simple;
	bh=XbLC/hBePDUMf2KSfI/RNXhwv4brM6tuZ32DJhN/Ibs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aawjqMUycMjH6V5XdS+0Bm84q0crZlJEgobhi1XnvMSBRdrQ8wNqAdurNSJdIqaiXg/5o9LhzLruACIjg+HM1rB0N9Rc4ZhAAP4+uUjrAANvXZxX7D6gMEPlqBvFRiSXfWYapeYWdDV2WRAfoGjQtcR/TvxJN/mYiX2FUGV/uZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t4KI/Mfy; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t4KI/Mfy"
Message-ID: <a6ccc7a8-488b-4454-81b1-f29dd875845c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782661486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SoYBPS92T9jxSeucptjXLkmBHa33QEMKFqRqtKW/zko=;
	b=t4KI/MfyAx/8dC/ImRGrYtKYp2FWHf5OATwSspzG2rLAQnlorpfLIdH5DHMsHBPpURHdEt
	6CKebtCpB6rgyPOrrP0qezt0lCo8jnidSyMlnahfleW5Mkq/mBaiF7iluBceFe8CDBdU7O
	vGGiCIiiTUexvIN4ivwxtVUCMxfmiAk=
Date: Sun, 28 Jun 2026 23:44:25 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] KVM: selftests: fix steal_time for arm64 with host page
 size > 4K
To: Sebastian Ott <sebott@redhat.com>
Cc: Jiakai Xu <xujiakai2025@iscas.ac.cn>, Shuah Khan <shuah@kernel.org>,
 Andrew Jones <andrew.jones@oss.qualcomm.com>,
 Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>
References: <20260504112808.21276-1-sebott@redhat.com>
 <7575a845-a542-4b16-b512-aec3126f97f3@linux.dev>
 <335f21e5-493d-012d-b07c-2e48cc2b9aeb@redhat.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <335f21e5-493d-012d-b07c-2e48cc2b9aeb@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 6/22/26 10:14 PM, Sebastian Ott wrote:
> 
> Fix the following failure when running with 16K host page size:
> ==== Test Assertion Failure ====
>   lib/kvm_util.c:991: vm_adjust_num_guest_pages(vm->mode, npages) == npages
>   pid=873 tid=873 errno=0 - Success
>      1  0x0000000000405a27: vm_mem_add at kvm_util.c:991
>      2  0x000000000040241f: check_steal_time_uapi at steal_time.c:223 (discriminator 7)
>      3   (inlined by) main at steal_time.c:539 (discriminator 7)
>      4  0x00007fff8b57af3b: ?? ??:0
>      5  0x00007fff8b57b007: ?? ??:0
>      6  0x0000000000402b6f: _start at ??:?
>   Number of guest pages is not compatible with the host. Try npages=4
> 
> Fixes: fc240715fc50 ("KVM: selftests: arm64: Fix steal_time test after UAPI refactoring")
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Link: https://lore.kernel.org/kvmarm/7575a845-a542-4b16-b512-aec3126f97f3@linux.dev/T/#u
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>  tools/testing/selftests/kvm/steal_time.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index 76fcdd1fd3cb..cdb81f3ee4b2 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -208,6 +208,7 @@ static void check_steal_time_uapi(void)
>  {
>      struct kvm_vm *vm;
>      struct kvm_vcpu *vcpu;
> +    unsigned int gpages;
>      u64 st_ipa;
>      int ret;
> 
> @@ -220,8 +221,9 @@ static void check_steal_time_uapi(void)
>      };
> 
>      vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
> -    vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, 1, 0);
> -    virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, 1);
> +    gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, 1);

Would vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE) be better
to describe the number of pages we want to add?

> +    vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
> +    virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages);
> 
>      st_ipa = (ulong)ST_GPA_BASE | 1;
>      ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
