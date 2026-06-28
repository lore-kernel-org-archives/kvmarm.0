Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CF2348C68
	for <kvmarm@lists.linux.dev>; Sun, 28 Jun 2026 15:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782660803; cv=none; b=dliXwMhGEBxDqF6M7uZ/YMeFnje39lzOwFoFXjpbDJXfBlSiOkTzIKO2GN5zmNWDGbWEpWTD9DS7zpbBr20e++869ihh4q7/VFvqy5BMqi7aqi3gWf6rrooGLDwH3ZYeZgYXUNHhHTcaC0F+VJGPM5Slj/eUCAuB/6cgmV227zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782660803; c=relaxed/simple;
	bh=vQihpcy30IlBDydaV7ii1Seg8xplAljWQgsWE/KLrrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DHR7WxYMYK5lN7Yi0v6Awa82Kki/hI0R70D1iO24N+SE5NYBXK2cPz2R7kgNDRY4/slnpvCQ/l9r2HRuOj+ztLSMubZ0+FPfr7V9TdDMZAf51FXsVXDVfQBfJCHJLZxgObhELGAvCyS2vMpZpkAuEWBsKv5qalZPDAwph2a/ocg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GHK0W1IN; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GHK0W1IN"
Message-ID: <44ebdb14-c066-451f-9068-fe48113bb85f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782660790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=521uBux1OWZaz7rKel6xXuaQK1kRDc9D2ee6t7YURhE=;
	b=GHK0W1INwxWnzcud2xF1FNE+DGTTBQQ/nemDzgnWx/uv9/R+6MU4EZGK0Km3epK1uGT2Nh
	pmm5+vKDhjIN761kj8Cq2hAefqX/jELfTd6Xcvwuc6Aca+ebQXZjbMElLNhcC7TOUEy26W
	0lkpZcqv/79sjbbAd0EktnG5jxPt8aQ=
Date: Sun, 28 Jun 2026 23:32:45 +0800
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

Looks good to me,

Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>

Thanks,
Zenghui
