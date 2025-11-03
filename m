Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4692FE59F
	for <kvmarm@lists.linux.dev>; Mon,  3 Nov 2025 10:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762166142; cv=none; b=iFFJudVD7lxBLlQnAPLN3a0LAH8AbpDqGiYFeKg08wSHWBYIllt3KpaFYKsHZp0DF8xC+9xaHFLl9pfr6L9S47Wrpi1FzWPrtpyT6OckRtlDRExlzeYAdmj8vsa8ZwUykMLRgrcpU/btP3/uVhJ4qEElhq4IiUb2M7voNznD8CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762166142; c=relaxed/simple;
	bh=8+P2mAiDVHSJp2el3mv9Dg4i98lSGdENhVxS8H1dViM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F+0MPMIImx/qFNdAKzFhLQwXrWBj9VTSU+4WbCG78+HRvdZmwSk+KyyTjiZw65sWAsMpUfABhAC70GLPxH1WOlbotBzwmSf82CTbmQbMjYEOeV6E2PkhYKTbvp5Qi80npxdz+S6Te9onZbB3SQ9HTwh8ryEOVpjrFIaAiLL5P2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2joWsz9P; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2joWsz9P"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-475de1afec6so14048365e9.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Nov 2025 02:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762166139; x=1762770939; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HIh+p2hn8CWwp1yzNpGitqYXRaRZUOuOWC3H0V0dQOo=;
        b=2joWsz9PMPNh/wgnP9dkl2UGoXgzbJnPaJgUUb9PUMP8d0cH/tK6Q1plspg68ii2vN
         lyflZgQ6WXa+uEfgdEDPieCEM1B5yR1RT1wbNmpanOm+pbPmVH4GIcqRm+yGeB3hjaBZ
         qbmvC1OjRNzBMGoNqapOzOcbeilDtX9hgIcbZ21SJtuJ6oLXyl9g8z0xZ/nD6Nso58pn
         zc+guYQBgWWtTeN5oVccCaYNNhRLHFZTZahRSt1Jx3K2Lb+/G+QAvaoq73BW95PGRlCF
         imgaWGJMoq7TdZtp/1Pjn3QxXszxiYsctDYUHKISSv2GM21omkT16lDa+K+Q29ENEzc8
         9hgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762166139; x=1762770939;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HIh+p2hn8CWwp1yzNpGitqYXRaRZUOuOWC3H0V0dQOo=;
        b=YcED0oZpQGXf4GYQjKs0PAjIlobw85qdYu7XHwSvk2lrvS0ioQ4Vm50gJ0vhzmYdm+
         5EkZY6uO7l9ut/oGZa4FAZ6NKm9IRjAaeD+PJGahotE+Ut/sVIBCeXpbdTHb4Lv87GoK
         SbqATLIW5ZJRumLq6zvSrgsxF7Mct0oGOkxKayrer4+6ptlkLrIg9kjfpfR2GmWVPooN
         LlwsOsL8ozvSxzi0VNmVggfhckTJxqj1zxfyhNDkKSmoz5sKG9nvAWfOdfl9oVZw69ac
         iHace0KNflpCnG5aZPhhEDiDSP6/ztl2wUGcX0SUBGoNpXXOo2pAH/JsHfE489CHaC9f
         JSBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNWWEPAW9ilZTfh4BcWbOSaF5A2eVDEkAF5N9aiugP6bjDqXc9LzK4oe0kJNxZYI+tu7C9p38=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDZWxiNcg2Ky4EotQOhleE6j2kxbxiQfAu4bU29FfCOGpPWN9T
	nbWg5V8YZ+wFjQZMVq1hg8+5t8l7wK+mzG9Sy7gJ7ZZKIbz+Ul9nl2J7uGDH5GLVA/VqmyZcdHb
	9mSz21LJVlpCBfQ==
X-Google-Smtp-Source: AGHT+IGsdQiHDuxdy1N3E7iEx3V3SXYmD4K71IvzTwmgh+q16FRulMDnGB/75cnoaLGyb09UfRoHjiberggitA==
X-Received: from wmco10.prod.google.com ([2002:a05:600c:a30a:b0:477:cf9:f4a3])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:699a:b0:477:19af:31c2 with SMTP id 5b1f17b1804b1-477300d96c2mr124516735e9.9.1762166139059;
 Mon, 03 Nov 2025 02:35:39 -0800 (PST)
Date: Mon, 03 Nov 2025 10:35:38 +0000
In-Reply-To: <aQXVNuBwEIRBtOc0@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk> <20250924152214.7292-2-roypat@amazon.co.uk>
 <DDWOP8GKHESP.2EOY2HGM9RXHU@google.com> <aQXVNuBwEIRBtOc0@kernel.org>
X-Mailer: aerc 0.21.0
Message-ID: <DDYZRG8A99D1.2MYZVGBKJNHJW@google.com>
Subject: Re: [PATCH v7 05/12] KVM: guest_memfd: Add flag to remove from direct map
From: Brendan Jackman <jackmanb@google.com>
To: Mike Rapoport <rppt@kernel.org>, Brendan Jackman <jackmanb@google.com>
Cc: "Roy, Patrick" <roypat@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "song@kernel.org" <song@kernel.org>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>, 
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>, "tabba@google.com" <tabba@google.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

On Sat Nov 1, 2025 at 9:39 AM UTC, Mike Rapoport wrote:
> On Fri, Oct 31, 2025 at 05:30:12PM +0000, Brendan Jackman wrote:
>> On Wed Sep 24, 2025 at 3:22 PM UTC, Patrick Roy wrote:
>> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> > index 1d0585616aa3..73a15cade54a 100644
>> > --- a/include/linux/kvm_host.h
>> > +++ b/include/linux/kvm_host.h
>> > @@ -731,6 +731,12 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>> >  bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
>> >  #endif
>> >  
>> > +#ifdef CONFIG_KVM_GUEST_MEMFD
>> > +#ifndef kvm_arch_gmem_supports_no_direct_map
>> > +#define kvm_arch_gmem_supports_no_direct_map can_set_direct_map
>> > +#endif
>> > +#endif /* CONFIG_KVM_GUEST_MEMFD */
>> 
>> The test robot seems happy so I think I'm probably mistaken here, but
>> AFAICS can_set_direct_map only exists when ARCH_HAS_SET_DIRECT_MAP,
>> which powerpc doesn't set.
>
> We have stubs returning 0 for architectures that don't have
> ARCH_HAS_SET_DIRECT_MAP.

I can't see any such stub for can_set_direct_map() specifically?

(But again, the bot seems happy, so I still suspect I'm wrong somehow or
other).
