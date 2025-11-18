Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8A03126D2
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 23:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508686; cv=none; b=LokbPeixhl5xrbQi0WuJPmYi23be08KS0HpcRozpKo715mvMouPYM8uuvITqdG95v+3p9+zHJITKB/XXopfPlpj31CPFuLxLpnbylHR8ssHauUXMScRxThL/mVwJFDHqfXG0+kRhSzR2PkyDj9WtCBk2toyAz8/iwIhUuzviUYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508686; c=relaxed/simple;
	bh=5WBwqUVhmKiZfIpTpsQTwtOFw21J/JhhQ4L/zj7meTg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cXWMr4LRzpIP3z1FXB5R0XaYGnP1sSANBriU8ro+bMVn+H5h9hlnLkX0a+JMp6et6srYWEog5FdBhQVH50/xdqomKw36rqHjr3xXKl4Szl0m/GsyQuoW2JKwy6RTEzOTN3ZvGAvWlHhpAev7YtQs87iEeWay4sPXlwdZFxA0RX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dM4+h413; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dM4+h413"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340bc4ef67fso7299216a91.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 15:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763508684; x=1764113484; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vhbmIaudy7FUgPhz41c9iiSjQeSWp1bqqQI5ni0zcdI=;
        b=dM4+h413M9e5eT8jdFlAi3oWJz8l0ODzEsU1+WISTVcLM9FYONH7qCpTtEWOmOYwGN
         mcJ+0vmq9q62MkIEsHtpouM/EWiXlPDe+fCH4Af5dSeuEH9NxT7SfIwrJPpJ2dfukL3B
         t9QkksyjgiX4DWmyfKtSGw8EZ9TFrtqTx3xBzRdg/u8riLwAwSoMz4CxYTYKSYHLPGp5
         NtKC735JidSXWz3Y/iHdZf2ZUFaxYNwxYfXpDfzAQifkgbAJoby+T7vmlOKDfzmGUei0
         9GYiXb2ShVed03aAav4Ya+B1kQ9CYyIUxF0NRUpOVwnRz/I5veXkaseNeeBWMBaL2gCd
         RmuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763508684; x=1764113484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vhbmIaudy7FUgPhz41c9iiSjQeSWp1bqqQI5ni0zcdI=;
        b=HqN6cOgPY4loned6gO5YZYpE8YYcgeyCxB8VpgeOYm6a1eliZKQxRyNkjswfaTJiT4
         ZYRZ3bHlC74iH7E6j6k0DjMZSIitCBsLGPzE6TZCVv3ENr3XE+TPhEiG64tLrlKx5kEf
         t1Gs2AdWAtIiCrOs2TofjMQmTYqKRkoPSnFzY6WhhUUaT7uE5b0qlWBaTk93u7UndQ6S
         yiW2l8NfffztMJwHhZKGJULydq6v4/OLqeHoXxq2AvCGs5DGZpLkgnCDTzrJ5fCXfXOn
         nRa2gPG7Bb260NXzCZN0FstDVbQQN2ytgs4KLVuCDR83bRoJPFc8zVH+OQjolWWWK5x9
         7k6g==
X-Forwarded-Encrypted: i=1; AJvYcCUKcjmTFkouPEtKkIi1ZUaCGsE2KXC0D0LIcYY/UnfwKXvSYBgAmOUYrh6n0C+8bRZT+mbAU+E=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSxVrtc9IaSKMInuaUtQYMmXXjl7sS90Jk5JiQtxkicU6JdUPV
	hHtQtFqN0kqDCIm61Bhm3IQWK/5b3ZysmoUigJ1onA+2Am+60MTcYJO39rzgizxKAe3B4X2L/3r
	ZOpZ99g==
X-Google-Smtp-Source: AGHT+IE1o3OuDgEYh+WwImWCZtj32ss/bDTcBxOCjrPrz1sqG0DLMNd/QRhOEpFCg6/bq23FewNy3cS6Bik=
X-Received: from pjbpd18.prod.google.com ([2002:a17:90b:1dd2:b0:340:e8f7:1b44])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5484:b0:341:124f:474f
 with SMTP id 98e67ed59e1d1-343fa6390cfmr19214010a91.32.1763508684387; Tue, 18
 Nov 2025 15:31:24 -0800 (PST)
Date: Tue, 18 Nov 2025 15:31:22 -0800
In-Reply-To: <20251028002824.1470939-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <aP-1qlTkmFUgTld-@google.com> <20251028002824.1470939-1-rick.p.edgecombe@intel.com>
Message-ID: <aR0Byu3bd3URxzhu@google.com>
Subject: Re: [PATCH] KVM: TDX: Take MMU lock around tdh_vp_init()
From: Sean Christopherson <seanjc@google.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: ackerleytng@google.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	binbin.wu@linux.intel.com, borntraeger@linux.ibm.com, chenhuacai@kernel.org, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, ira.weiny@intel.com, 
	kai.huang@intel.com, kas@kernel.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev, maddy@linux.ibm.com, maobibo@loongson.cn, 
	maz@kernel.org, michael.roth@amd.com, oliver.upton@linux.dev, 
	palmer@dabbelt.com, pbonzini@redhat.com, pjw@kernel.org, 
	vannapurve@google.com, x86@kernel.org, yan.y.zhao@intel.com, 
	zhaotianrui@loongson.cn
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 27, 2025, Rick Edgecombe wrote:
> Take MMU lock around tdh_vp_init() in KVM_TDX_INIT_VCPU to prevent
> meeting contention during retries in some no-fail MMU paths.
> 
> The TDX module takes various try-locks internally, which can cause
> SEAMCALLs to return an error code when contention is met. Dealing with
> an error in some of the MMU paths that make SEAMCALLs is not straight
> forward, so KVM takes steps to ensure that these will meet no contention
> during a single BUSY error retry. The whole scheme relies on KVM to take
> appropriate steps to avoid making any SEAMCALLs that could contend while
> the retry is happening.
> 
> Unfortunately, there is a case where contention could be met if userspace
> does something unusual. Specifically, hole punching a gmem fd while
> initializing the TD vCPU. The impact would be triggering a KVM_BUG_ON().
> 
> The resource being contended is called the "TDR resource" in TDX docs 
> parlance. The tdh_vp_init() can take this resource as exclusive if the 
> 'version' passed is 1, which happens to be version the kernel passes. The 
> various MMU operations (tdh_mem_range_block(), tdh_mem_track() and 
> tdh_mem_page_remove()) take it as shared.
> 
> There isn't a KVM lock that maps conceptually and in a lock order friendly 
> way to the TDR lock. So to minimize infrastructure, just take MMU lock 
> around tdh_vp_init(). This makes the operations we care about mutually 
> exclusive. Since the other operations are under a write mmu_lock, the code 
> could just take the lock for read, however this is weirdly inverted from 
> the actual underlying resource being contended. Since this is covering an 
> edge case that shouldn't be hit in normal usage, be a little less weird 
> and take the mmu_lock for write around the call.
> 
> Fixes: 02ab57707bdb ("KVM: TDX: Implement hooks to propagate changes of TDP MMU mirror page table")
> Reported-by: Yan Zhao <yan.y.zhao@intel.com>
> Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> Hi,
> 
> It was indeed awkward, as Sean must have sniffed. But seems ok enough to
> close the issue.
> 
> Yan, can you give it a look?
> 
> Posted here, but applies on top of this series.

In the future, please don't post in-reply-to, as it mucks up my b4 workflow.

Applied to kvm-x86 tdx, with a more verbose comment as suggested by Binbin.

[1/1] KVM: TDX: Take MMU lock around tdh_vp_init()
      https://github.com/kvm-x86/linux/commit/9a89894f30d5
