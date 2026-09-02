Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3ED378D82
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 17:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788371621; cv=none; b=flT3PLHXSKJ5vesG2QOjrFmnB2wOuyjgVnjp0hd2WagJ/3B6zFmn+8RN+G4HFzbslOwkRAxsSy/lH9enPY6FDGtAwyVjhE/+toxA/+yLMLZyzMuN3o0CqdmvR5sz2umInsJHHQeZ+OoY7lJsR30O8TcXz9eM8mKYm319M9tl17Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788371621; c=relaxed/simple;
	bh=b5kh2R8Hzwwj57HzVfabs/YOUfR+MDkcYfNrpEGQb5g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hhoq2+hAfk0pMQxJYchFNHzg7gmPJi/sv76N0jdRDKI6NXJp830c0rKJq0WKxtFlK8fne71zxyo42TpvfZ/iNY8rrkJH83UrMEbdf4XquG08gz2o95uswsLIViSlG1lSR7N85AdFjs2YVd/20nuoo0DYze77V1zZlHJBfvCcK10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KwKHqDXA; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KwKHqDXA"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-855315ccb64so1214806b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 10:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788371619; x=1788976419; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SdKJUU1oimzE531v2SlLnET8xKOYeS+3soklD8mAhs4=;
        b=KwKHqDXAhFQCJDtPYRuxqtzlwafa4jE8MHaSxtouqmlLdfP+o14ikfAupq0JrCTE0M
         giarWoB7Z0Gv2GPZ0a1d0OxaJX8WpG9NxS8qSR2OprxYLcm2CYDBPnVW5BPMiQGkApoM
         0OvxnuebuQI9LnXH6eTvLRVwt0/wdrvSBzcHF2F0/ibwKGbC/gJBBH/XhvTJdDmOEg+p
         3mCm54+awPLEqnhxgXpTavTpibILN/M7Gth4JDE7OFUCNnRReIxQO3IVtOgMgQ+V3Blf
         T4iKjJMpSYk49S1auLzSmdMrl6doWqhsHUlSbfZdoPBnxxI5HUtrnjSOQoyrBXo9KU4H
         gfGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788371619; x=1788976419;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SdKJUU1oimzE531v2SlLnET8xKOYeS+3soklD8mAhs4=;
        b=iVmr3Aqsxbv7CZE/YtVNnexefbDHscSr8LDjCshzNvkejZFV/dShw0J0JNaiwmnEmu
         gmnI8Eu85KR1h3WR1dODV3XB/ZsIEfuIFygNXUgk74UdodAqphD7WxEOGl5FkayTNvHl
         99KXpVW3m9NYdPulBYiT0UdQf+TwfZCSMaRNwnagq27/YTzF/rp88dhYpzCGbtcJOW5A
         X9F2COxbnCJLXlZRbL3U3M0pecFIOH3YU/m8YiXSGa8vBAaJBLqt3B8/7cSatSBe8JO5
         Ti2YYmVlKNMCOwzeKNMK2t4gwgwjAmwvEK15RXulHzaU8JhF+s1VfV/hhN5QXMmb1S5W
         mFLQ==
X-Forwarded-Encrypted: i=1; AKwUvBwIwthHtTKDoJFxqApos2eFWKPZCX1yGQtg0je3fNsZDda0Pyko6NKC0t5Sbk5TxsPdJ8QqYBc=@lists.linux.dev
X-Gm-Message-State: AFuF++kKTYXfoz23iaJic6GX5k2YBgOASAIvmE+3hmk6oYo0eJbk0sZV
	g5bFb176S7zJEFTMGaxYrKH2WGRVKpQIVoXrXSGuO7fE0ThcEpr5Tc8Ai/BzmzUGFy9AhvEpJjx
	XiBSJRA==
X-Received: from pfan9.prod.google.com ([2002:aa7:8a49:0:b0:842:83c0:8d73])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:440b:b0:847:9aa8:d3ce
 with SMTP id d2e1a72fcca58-85ed1b0e821mr10816352b3a.2.1788371618918; Wed, 02
 Sep 2026 10:53:38 -0700 (PDT)
Date: Wed, 2 Sep 2026 10:53:38 -0700
In-Reply-To: <aphhKDm7Vx7G5ivr@Gautams-MacBook-Pro.local>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com> <aphhKDm7Vx7G5ivr@Gautams-MacBook-Pro.local>
Message-ID: <aphioo_KTboUCtZd@google.com>
Subject: Re: [PATCH 00/20] KVM: selftests: PPC pre-enabling
From: Sean Christopherson <seanjc@google.com>
To: Gautam Menghani <gautam@linux.ibm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 02, 2026, Gautam Menghani wrote:
> 
> + linuxppc-dev

Ah, shoot, I *just* posted v2.  I'll add linuxppc-dev to that cover letter.

https://lore.kernel.org/all/20260902164123.2546762-1-seanjc@google.com
