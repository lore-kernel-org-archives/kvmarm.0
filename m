Received: from mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF153403F5
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 01:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437054; cv=none; b=jAkmdQ5MsnK3N7w5U7mJfZx2y/c9DKNvT4d47srwzziqYPJ9jQkCPcrCkPGxm9RxT30Dtgdo9Ciwu0PbRlyRos+2o1V4v3NaWwh5upK4HGgCsVQ4yRpcr5MPo2c+4WF1D5KEciTqHcvcgOgq8dF8r8ZL6iw8M4sNyDeJaddiMVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437054; c=relaxed/simple;
	bh=4rxySM4BS49fBSwCNRAkTQRrhsddhvxjSfqJYWi8hAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=majbKCfL9LnOIln3/a0FQthNFyijXapmxwj/5VNnF+KQ3kT90enBlIxBaz7uTGTWzssXXHhGRvCAWZzpAxGx3q6jOeIGUp/PH8a5GeIdh/q1DjKcw0v52HVzt0iLWrBfru8oeF6DL+0kz4tTgNNpbZmsEpihDfiz96eoVfNFzYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QhTvgcbQ; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QhTvgcbQ"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=4rxySM4BS49fBSwCNRAkTQRrhsddhvxjSfqJYWi8hAE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789437049; v=1; x=1790041849;
 b=QhTvgcbQcYVsm7cIyvWM5B5O4sjONPx9ZGeSjIMKaQ1zVSwlk5Vig31jCR5/D+DMQz5EtYTE
 8JuYsL47j1fyi9HudnykIomGqFJ40cXRtEzyPTndrr/Cx3cZTBnt7103TfUJNRnWYXN8fZDo6Qn
 ZFfUKBarFdoNP2ldtupo4lo4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c1588fdb51580307;
	Tue, 15 Sep 2026 01:50:38 +0000
X-Mizu-Trace-ID: c1588fdb51580307
X-Migadu-Flow: FLOW_OUT
Message-ID: <62f1f8d6-0902-4c1f-a32e-6ae5d90b1fa6@linux.dev>
Date: Tue, 15 Sep 2026 09:50:29 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: selftests: fix steal_time for arm64 with host
 page size > 4K
To: Sebastian Ott <sebott@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Sean Christopherson <seanjc@google.com>, Jiakai Xu
 <xujiakai2025@iscas.ac.cn>, Shuah Khan <shuah@kernel.org>,
 Andrew Jones <andrew.jones@oss.qualcomm.com>,
 Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev
References: <20260914131013.60334-1-sebott@redhat.com>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260914131013.60334-1-sebott@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/14/26 9:10 PM, Sebastian Ott wrote:
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
>  tools/testing/selftests/kvm/steal_time.c | 30 ++++++++++++++++--------
>  1 file changed, 20 insertions(+), 10 deletions(-)

Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Thanks,
Zenghui
