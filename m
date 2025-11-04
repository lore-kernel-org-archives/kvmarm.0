Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75F4221FB2
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 20:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762287554; cv=none; b=Peqw3WWvhp+Xm0k1AjO0meOdhrNugaF2XUknhVfmfAEQDdF9rKWIxu7E9kIMc/0jkTd16gir8/aL9e/sOrKlAHngaPdfYCnc5tFYQtUJJDMApmHVcX++/fyvJBQ24FYBRI0KQkUz1Vg2GfpVgR48HkLRjrOHydiZrSf0wr3w8bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762287554; c=relaxed/simple;
	bh=BqhHgAqSkG4l2z1eoyySaP6wFCFo56cQORvWEuGj/N0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qy/BDXEyJ+mZ/V4/ifupgIEBKMG7YimRRNgpc6DSgFuWIgSIIR2/kNy1m7O8eRyvKIx0B0/h7xLM41n9Cb6UKRuSMMCf5MHTCmBVqZh4k1eBnWvjLvwGEfbvJV+WscDJR6kvso9q0Fhu+mtinBEX8C+rWp99gl0k+T7WcgpFsaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HQL+moJ+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HQL+moJ+"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3416dc5754fso2125479a91.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 12:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762287552; x=1762892352; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K4Bva0w0KbqgCJAJfbsSK/8FEB2ivKz4/LZ5P7kuzw0=;
        b=HQL+moJ+1Bptm0kZr5KF5Bh3gDwb3/jVYaOhaUc9wmdseO4cJYO54DK7YSxPtyghoN
         g0gtx5HutJnL+wtBuuwl12Lpz8zHDQGjo/TDtwwzEgcWQXAi3g1V6T9HOcCrgfD1/7nj
         UGVzQYtuOFRE2PprYBjbVlDQVMT7RRi5VPNRify8TWWFzXIbooB712WPT/w6RaLjj+rX
         dngAx+M7zme3CH0sGoyStfwUMKt948bZNa/txvvZKeAADBQFLKDcVmwXQKzvNM4eHD/f
         EUeuNfQdNrh9KpY8blc/fjA50w6D+kW1yiCdZNPMShCjkSfQqjHa0aaLmUi/KASwKOKI
         UyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762287552; x=1762892352;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K4Bva0w0KbqgCJAJfbsSK/8FEB2ivKz4/LZ5P7kuzw0=;
        b=gLVousOngH4ZhWW+KBO063OVfXjnxN6/x9AGINKHScS6e8W9brxxoyCHtL1Kl8O/5A
         CDO458532UeYHhDevw6V1GQcOcuMNiefTm8dQCQyEnnhxyp/fsXan2FET/2ORlLq0WK9
         6WemiWhw3/EsB2fM0ZTiSoy3Gjp9+Sgn0bIdlWnjYefqVnOFL0HxYL3jp8w+tSucNzf2
         JJU/ojdo0fThYIjHLtlDWWupxhxUFEgiMWJAlwmmkw9vrSMJQ0ArE8wTUdJ5oaYRqw+m
         JJ1vS9XDEwz6wm4XadQjHBahp28QwOast+VxBcbaiDkxsseE9txUIQCkT9wgCJaZX0Ky
         4doQ==
X-Forwarded-Encrypted: i=1; AJvYcCUs8Af3ECdH4urALm1MoUnHPCPyOnOOgZAZ2tcbqFJHAJrrKk801qQq1GUYbs2s712+GR4Qpzc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9vQknjNscVQ5dkgxKZE5fFGTny1mg22X+UCjOc/y3N5xcH6k1
	hO0tDO2rFZG3Oe02TqkH0amtZxyu75J5Q+dA0eGIZ6mcgJ4HqblJ7Up2Kvqwm3Q1yrDHKTn/MrJ
	2mnRYqw==
X-Google-Smtp-Source: AGHT+IGdgZKcyoQ0zGdQrLNOdi7+EjeBGpl2/tWI68ux+7RvDN8zvERNjHKEkloiI0RWSyl4SFGplL1NmQw=
X-Received: from pjvf13.prod.google.com ([2002:a17:90a:da8d:b0:33b:e0b5:6112])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c8b:b0:340:a961:80c5
 with SMTP id 98e67ed59e1d1-341a6defed9mr629130a91.32.1762287552241; Tue, 04
 Nov 2025 12:19:12 -0800 (PST)
Date: Tue, 4 Nov 2025 12:19:10 -0800
In-Reply-To: <0c3db907-7012-43c3-b7fc-36848789da52@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251013151502.6679-1-jackabt.amazon@gmail.com>
 <20251013151502.6679-3-jackabt.amazon@gmail.com> <aPpi1c-8EpWuo87B@google.com>
 <c52db7bf-494f-49a8-9829-3805db6dda7c@gmail.com> <aQkZtjLt6lIULffA@google.com>
 <0c3db907-7012-43c3-b7fc-36848789da52@gmail.com>
Message-ID: <aQpfviS-oAmanqpq@google.com>
Subject: Re: [PATCH v2 2/4] KVM: selftests: Fix unaligned mmap allocations
From: Sean Christopherson <seanjc@google.com>
To: Jack Thomson <jackabt.amazon@gmail.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	isaku.yamahata@intel.com, roypat@amazon.co.uk, kalyazin@amazon.co.uk, 
	jackabt@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 04, 2025, Jack Thomson wrote:
> On 03/11/2025 9:08 pm, Sean Christopherson wrote:
> > On Tue, Oct 28, 2025, Jack Thomson wrote:
> > > 
> > > 
> > > On 23/10/2025 6:16 pm, Sean Christopherson wrote:
> > > > On Mon, Oct 13, 2025, Jack Thomson wrote:
> > > > > From: Jack Thomson <jackabt@amazon.com>
> > > > > 
> > > > > When creating a VM using mmap with huge pages, and the memory amount does
> > > > > not align with the underlying page size. The stored mmap_size value does
> > > > > not account for the fact that mmap will automatically align the length
> > > > > to a multiple of the underlying page size. During the teardown of the
> > > > > test, munmap is used. However, munmap requires the length to be a
> > > > > multiple of the underlying page size.
> > > > 
> > > > What happens when selftests use the wrong map_size?  E.g. is munmap() silently
> > > > failing?  If so, then I should probably take this particular patch through
> > > > kvm-x86/gmem, otherwise it means we'll start getting asserts due to:
> > > > 
> > > >     3223560c93eb ("KVM: selftests: Define wrappers for common syscalls to assert success")
> > > > 
> > > > If munmap() isn't failing, then that begs the question of what this patch is
> > > > actually doing :-)
> > > > 
> > > 
> > > Hi Sean, sorry I completely missed your reply.
> > > 
> > > Yeah currently with a misaligned map_size it causes munmap() to fail, I
> > > noticed when tested with different backings.
> > 
> > Exactly which tests fail?  I ask because I'm not sure we want to fix this by
> > having vm_mem_add() paper over test issues (I vaguely recall looking at this in
> > the past, but I can't find or recall the details).
> 
> The test failures happened with pre_faulting tests after adding the
> option to change the backing page size [1]. If you'd prefer to
> have the test handle with this I'll update there instead.

Ah, yeah, that's a test bug introduced by your patch.  I can't find the thread,
but the issue of hugepage aligntment in vm_mem_add() has come up in the past,
and IIRC the conclusion was that tests need to handle the size+alignment, because
having the library force the alignment risking papering over test bugs/flaws.
And I think there may have even been cases where it introduced failures, as some
tests deliberately wanted to do weird things?

E.g. not updating the pre-faulting test to use the "correct" size+alignment means
the test is missing easy coverage for hugepages, since KVM won't create huge
mappings in stage-2 due to the memslot not being sized+aligned.
