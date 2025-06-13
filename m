Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1DA293C5C
	for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 13:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749823043; cv=none; b=D0HXEapojblXqK3U9h9edO6Ma+6KySO8ZGV9vqhSOf6Nozxmgu4GSeg80n9LdWI+MDEojuh9RV3oUhe/icA0RngtHLmD4w/HZyawDgcEPnBmXKsG5GnwMNv3gXGDqFxTuAiwuto8B+Tc/JfM8HXhDvouVd2ZZwZtu2XeiHRLWQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749823043; c=relaxed/simple;
	bh=j/eRngj8H8ZbdpnO0fFDIsk8hiEYRjMNb+L170l84M4=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=puAj14ufZ9Fbdojk+GfIQgNCnAoQooWY+vRpI6Zq7tf7r8cPbR07LbSyRsd9YYtM99eLAvuk6i5z/8oWB8rXlIG7ZuP13cy593LzSBuuw7cLvplg7UjYZFIeyyK9TZPrB/ybSUb9KnQY92uYohYdm4yGNPUGZL/Jouh0BEVl0Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DvowhBNM; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DvowhBNM"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-234dbbc4899so30989615ad.2
        for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 06:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749823041; x=1750427841; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dkuRqqw31HUjS3f3ozaxg1qfTggthracEAgq5uGUxWg=;
        b=DvowhBNMZ/FiiFchNNzZghpr/xzEan7xRl7OjPidJJg9Esgye/wW9uD79VZawU8DZF
         +U2ubZuFuTC69B7EOI0e85mTBgpYtjH9F5NHRm/bj7uk6fscWnHKlAfOiU8STpL8sfqW
         zhssFW4lPzm9RZt5X1KJsz1YQTJ35HBWR4nNwh+O/3t/JwhgHJIJquEmVpHQ7t4zq36z
         1nf0c0zALSJR5TnJOe9gkF89qPiTvc2HPdcpUpbI8r1HPwbgrnUlVDrfcswE9RNi/qR1
         H1IQCahFc9jqF6AUIe/O0YAMI9vGGjnqJqVwDZNBi1o4ED5QSwrE2Ppspx6QWuT4xcyK
         z3PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749823041; x=1750427841;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dkuRqqw31HUjS3f3ozaxg1qfTggthracEAgq5uGUxWg=;
        b=Whd84ygl/VxncM7pOLNS/gPEEmTP5MeMIWaNsro9fwsZk8JXQ1qDVUwaODWFYQDBBm
         qW6aXBjev1q1wSdvfiw3IaIjo+cuv8AlYzPWs9GQHeQdDxPkqfN0lGawD7o6Zwx6Uvwp
         oMgnLe0S9oVoUX3iJ9y+iCZL7sGZOXhNjsgfi9E0IBmOHyJLAmZxkLXjSbySt9tx6Qfm
         OVpciUj345eWc7a8HNE8qig3PvTcyPN014+D1sU4Zw1WuT/l1hhtuyBG7xsZkRoMIiSi
         fe4DjuwfQosSsr+coljECpylA52q8RR6CcS/R18KV1XKY3LMSoqboV/NtWXS4jGq9jjX
         5dxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWG6+A5OfM5lm6Wgx5rqkHL9Xdxo3NHjMY2gKv6acogN+V3e1wgWkrmoYlbRzscI4I7pcTgqCU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxkc6vxugyVfLpbGk1wGkNzcR8IzTkVz5VnstbpHfZtIhV0HO9o
	OvFSwGY7tO+4YLmKWMXiiLFdna66m0r2M2jgNdvTC8Tj2Yv9YbA4xEuKQ9QKPGwIkqc9lw04E6Y
	fxL/bFfdXBwXeRi8ex8mMZ7cuWg==
X-Google-Smtp-Source: AGHT+IE4pdDA+YU0xuWw2bZwqNNa/bw6PDc1eh7mNKACvMbud4eEJ6Hw9B3p1LPkjrd3WQIzMQtFfcUKJ8Y+9UsC3w==
X-Received: from pgbfm22.prod.google.com ([2002:a05:6a02:4996:b0:b29:82be:c692])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:fc44:b0:234:c549:da14 with SMTP id d9443c01a7336-2365dc0d163mr46118995ad.29.1749823040963;
 Fri, 13 Jun 2025 06:57:20 -0700 (PDT)
Date: Fri, 13 Jun 2025 06:57:19 -0700
In-Reply-To: <20250611133330.1514028-5-tabba@google.com> (message from Fuad
 Tabba on Wed, 11 Jun 2025 14:33:16 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <diqzv7ozvj5s.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v12 04/18] KVM: x86: Rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> The bool has_private_mem is used to indicate whether guest_memfd is
> supported. Rename it to supports_gmem to make its meaning clearer and to
> decouple memory being private from guest_memfd.
>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 4 ++--
>  arch/x86/kvm/mmu/mmu.c          | 2 +-
>  arch/x86/kvm/svm/svm.c          | 4 ++--
>  arch/x86/kvm/x86.c              | 3 +--
>  4 files changed, 6 insertions(+), 7 deletions(-)
>

This [1] is one recently-merged usage of arch.has_private_mem which
needs to be renamed too.

[1] https://github.com/torvalds/linux/blob/27605c8c0f69e319df156b471974e4e223035378/arch/x86/kvm/vmx/tdx.c#L627

[...]
