Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FA623770D
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 19:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753127217; cv=none; b=Ypnrqq/M3wdO8iqB/Z+zdXwfJIdJEG+NsTLSfNFVnasr805gTNytDqcqM2yY8eFUKy6x8JQey83V0+eXQIivnTfY2UO4SGSiPcpymu3CQ0komMSr07yqqLbnfVJQ4OEHKWyQiYCLNpX8qvKENrXmLGwQtHluSCVbvBD5dpiVXKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753127217; c=relaxed/simple;
	bh=ahaM8OfPRMeDGUWSbe2Ir10rA7XZXeQys+W1mU1oI/g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EY2u4LNVFwkAEmGnPxLUIqGxVL+Xe7OiWK81t5WTZXcPI4FBGgCGQMpawCEwph+vW37nF4vrxBRe4bTxce1JCPEz9YOlPEYL5wPU4i/AiUGNsZj8USAvp0SHyzEZbtbfrOnnuDxAjpCUEFAi2iKGsdFW+My+oj8q/iSxQ2xUu1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vt8MvPfk; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vt8MvPfk"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3141f9ce4e2so6969011a91.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 12:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753127215; x=1753732015; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eAzCPpfQMz1gzK4so/oBZateRTf7Y7I8QQ8KelEOi7Y=;
        b=Vt8MvPfkZX6pbrha9BpSnQKa/jYE2cVknsmVLDA1DnF6lMzPCDAr1FpZi4hUAAZaXK
         0LJnNguqIUrepFWdKUtPwERkrfcJnF4XompjTfOyApagfluRZyzQezVRhy8Xs549wTpM
         ihDh82vYf04P4zwZiUqNBFoQJ290rjCn5rV8LvtbkWtSLWtCdD99gHyongSgA5ObuqtG
         pBfuGMhKRLhRE8ER05YPqFImZi54BmWWpzAdjCpPyD+qou6LCakA0VIBLKumXdrFR0oY
         PDtFYYTs5I+AO2zKKSHd5coHG0m8qw7+QGJtdahN8CDW3qOFaYRQSkTNHYIgZblCsO5K
         WLaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753127215; x=1753732015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eAzCPpfQMz1gzK4so/oBZateRTf7Y7I8QQ8KelEOi7Y=;
        b=ANQ68BZlUYx21yswrs/llUJNIBdZPQ9IuKd8bNeX7494/V0Ty0iCu8cmRte3oS5RPI
         YrnZRa6QnLR4CJozz/A0itMcZ0kHh/IW9Hv4JQtat+BFLRGP3km9z2Tz3QkKTJohD/WH
         xAJdJSeG61ie9K0KvtyxO3HHERmGsCSyuZe7WeQOcD728qy70miVTBhkFj+uoy7uq1In
         fE+MFoy1oTqmPdWYKp+60rGiQ2nNxOeRRsVzDA61IqBJr9LSkVBbaU7U9KwxP5FEXqpt
         3XOlWw/Ft7hf9ZmN2gtQXaC5rk//eiLnnFAYRRkdaxU3g2f1GsS7t58owhFi5aZDq+Yv
         Wd1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWW/r7V3+fkP5xZhaIYJdQOaXhzLfcsciNW7SbqFs5Xm7LD4xkHStcNwg5mT7EVsnJc3bHQPcU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQ7Wfj/aRcWaM9ghGa4ufGBlk4BhdRmuyjdxMn7UFZPEDoHhT/
	by9TkEEx7c/2dwkoCxdETHjHjR2/D6VPh+r79ltTubWrG2whkiATOveTNjnacUBMWlRr8D9MqSB
	rXbP6vA==
X-Google-Smtp-Source: AGHT+IHCdTRyaZvpqo+/OPaDQY8r+AbasdEQ23wkQlt2bLrH8q67zZ1ProzQYNVQGguXSMigXOn343oEtxk=
X-Received: from pjbnw5.prod.google.com ([2002:a17:90b:2545:b0:313:17cf:434f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f91:b0:311:ea13:2e70
 with SMTP id 98e67ed59e1d1-31c9f3c612fmr34864736a91.14.1753127215555; Mon, 21
 Jul 2025 12:46:55 -0700 (PDT)
Date: Mon, 21 Jul 2025 12:46:53 -0700
In-Reply-To: <20250717162731.446579-11-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-11-tabba@google.com>
Message-ID: <aH6ZLYgwK0EdIERg@google.com>
Subject: Re: [PATCH v15 10/21] KVM: x86/mmu: Generalize private_max_mapping_level
 x86 op to max_mapping_level
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 17, 2025, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Generalize the private_max_mapping_level x86 operation to
> max_mapping_level.

No, this is wrong.  The "private" part can be dropped, but it must not be a fully
generic helper, it needs to be limited to gmem.  For mappings that follow the
primary MMU, the primary MMU is the single source of truth.  It's not just a
nitpick, I got royally confused by the name when looking at the next patch.

s/private_max_mapping_level/gmem_max_mapping_level and we're good.
