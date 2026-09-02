Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BBC3876BA
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 18:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788372325; cv=none; b=I/1qCik2D4sY9zFno6bInR7yqcc0QaTPyJxcIBdZ9vpmv/LkUtU7uxJ20Su5k/HZyELWiXdBpvKOi/3DTwoDX0w1Sdx/84YhjxUJD7R9KQefUXA7Rz77ISr2cqoJ+0MjjSLmyBZX1HbJLQF4lbBLRhbedSi9yiwcbB7VR7CxUaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788372325; c=relaxed/simple;
	bh=YdqSsfXweYukjRzVRqCbG8U6cCS12JCA8Eln1yuWlpg=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=Aw8B11aFqaRyWNd3FDQMNMr7tccunMhpmv2p+0f9/wrTxW9EcG/a3OmukWcDg1MLL71c+ar4bYx15Uar32Lg8R/mwpJWJOWzB0NZodO4B2OsaVfF2nL/MdPToqEMNKw//uhRqX7KnPQGgMga3Y03PSvkFV/rxgLAqvSUuW9SWtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HGzCdsiZ; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HGzCdsiZ"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38ea87caafeso1373417a91.3
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 11:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788372323; x=1788977123; darn=lists.linux.dev;
        h=content-type:mime-version:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mIy9w1/7l+YPH2gFOr27PV6p4ska6UcSUlBoAUwTOLk=;
        b=HGzCdsiZ495i+yULtm11JusOpw76nVf3lJrVa+x+2EYe2goWCOXjZULCD1m5GrrG/U
         ViqoHnNeilu3pf/3VxevUHHr+apvIEEIpP3Y7FL4DHMjwNQqafWspTJogjT1BADK8J7u
         S89hQe3wGayjxMnNzJ98zDJ7wM/MM1mQFDOepEamj6JD4WyIQKLz1gPRj1xNmVyM9MT6
         DeQnPhdorC5nVLuJ8K4N1gV8hUSHPAfW34c+wgiBfYymklRaEVz2Npl8dKW2eYrLQ5aN
         2JIK/DkaPDPy1CX1M7Uc6R388zpRVBXsGX1URpEYZzWsQtprAQKEwIq91TFYN/0DrsTv
         1JYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788372323; x=1788977123;
        h=content-type:mime-version:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mIy9w1/7l+YPH2gFOr27PV6p4ska6UcSUlBoAUwTOLk=;
        b=qHEC0mS5GejGgOawHwTYrh3SJWc49RBKQUXxxLxg46NUJqcsW9Gc4CfGimK6++WkXJ
         FmrlE/Ba4KRIpkgCvZDgJSwZs5C2xmYpqWbQT2rwaGW3cG38Lc9DouS0/5QjRv6w+WwI
         c7ooXpGpanMCqiNAYalAiiorrexx5PxzcHx6A4bOjW+z9sLA6ylwWP3L8j3TckiyUWFt
         XasSmWTbBKW2ASzGTDVWgX/xkXb6vDCbqIbFPg8V8wBNyXRLsc8J9rgOiUYkAVKRAaNR
         8KwnoCzMMaRnY8xMP7CW7ShuGYrq/kijqT4ZbTjIqSUOqdGi7uRsEBi5ijhNKKWGd63V
         /KZQ==
X-Forwarded-Encrypted: i=1; AKwUvBxVW/MYn5EYSDCsO70G+hX8cBAyLolJ0iUOcKMXAWBafzE0CwPYDJXdwtasnnrh3ZtNcxoDGbY=@lists.linux.dev
X-Gm-Message-State: AFuF++knjD084Z58DzLAIka55+w3ccYYqiuK7DdaE6djkPC85LOFKvhW
	h1lCVNJ6YB3+/2umhykgcjdvckGiQmn7SKg8xSpodeiSJkGI8PJTLF/W
X-Gm-Gg: AYBFou0s06A642n0Ov9aLSUleJgsLP888W4rLyXxiB5RH7WcwrQRRYHojxD8B/eB3ql
	E/4otO4VUnNzipd1J9fzaxESecJxE6cE6Cba66vJmL4Zy4YoNoirJslcjD+NlkNCgNBAgL/J8JU
	sfSjSov544kRK15ECdV6TUAJaEoZ8tg8RY4C4vHIv3wIyMvxKnKQzY+Ca1CudUkmEWXPJm+gZw8
	Pvxh+dlys9Y79lgLldMAh3WdPzb/veRCD3bCRmGI8Szklu16qka8+zow3Wacz1pkh/NRJKHekKz
	Airaikr215f6kv0g4UFQZYoGDeT3d6CR12CDfDTcv5L+IFTahkNZ3RxhNlmXKMJLgeSPkE9Jtjl
	JRiT9yms5M2Nk1aZ2Eo8WfkpjNVm6vximMtH01yDXNqQ02zjs70/V0zXW5HeC5mvWkObi5JiNtt
	6zZVQeULmQxVDu0yryjfzDCjxOKISUNrEuAQliPG7oCI4N/LSUXdOnlxKYQ7m9AsY/+fbLJyhcg
	8JVtIW+F1VC5h0gHgQz/OObc79YKHFNrfaBMxHsbB/w
X-Received: by 2002:a17:90b:4b89:b0:398:c3ca:1ebc with SMTP id 98e67ed59e1d1-39aee105a46mr9138561a91.18.1788372321290;
        Wed, 02 Sep 2026 11:05:21 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f07b79cf9sm9808273eec.18.2026.09.02.11.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 11:05:20 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Sean Christopherson <seanjc@google.com>, Gautam Menghani <gautam@linux.ibm.com>
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
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 00/20] KVM: selftests: PPC pre-enabling
In-Reply-To: <aphioo_KTboUCtZd@google.com>
Date: Wed, 02 Sep 2026 23:29:06 +0530
Message-ID: <h5k7ttzp.ritesh.list@gmail.com>
References: <20260826230511.972824-1-seanjc@google.com> <aphhKDm7Vx7G5ivr@Gautams-MacBook-Pro.local> <aphioo_KTboUCtZd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Sep 02, 2026, Gautam Menghani wrote:
>> 
>> + linuxppc-dev
>
> Ah, shoot, I *just* posted v2.  I'll add linuxppc-dev to that cover letter.
>
> https://lore.kernel.org/all/20260902164123.2546762-1-seanjc@google.com

Thanks Sean for sharing these changes.

Thought of sharing an interim update:
I have rebased PPC KVM selftests support on top of this series and the
initial tests ran fine. I am currently looking info few findings though
- but will soon rebase those changes on top of your v2, review that &
update the results.


-ritesh

