Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E9D1428E4
	for <kvmarm@lists.linux.dev>; Thu, 25 Jul 2024 21:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721944571; cv=none; b=UXCg7qv4dU5NrT4MqBn5LLrZPMh0qg7ESFkv4lim+/BGq/wAWyVcRDUmYxJRqT2QZFMhRVtzQ3jn4cZo8n7JL5AmON2PC9jK80px+Tw0eZsg/qyjbtYhW9MibEtuw4rZOwAMbSwebX/ONVvcimCY7qAMTaWbHFkKMjmIcuJ7gpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721944571; c=relaxed/simple;
	bh=G0SV+4c0df7kDP/HmTtBo/ahkooNcX5psIcCqUvYfMo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dQ/gxivv7qgpG79kYNbNklgVzqUA+W0+9qJEF1T7opOKZgvexfxHuL0u7Ew0sAmQq8zj5qmd4BnmZ4OReaesIhD9xjl7Y7NDRuX7WN96gJgmZLyZ+Czv3A+yNX16t8eC+IVZ8NR/rUjuOaMegMJe7fS41tW0p9DPgoD5Tq0rbE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bs7rCUsV; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bs7rCUsV"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-44fee2bfd28so15631cf.1
        for <kvmarm@lists.linux.dev>; Thu, 25 Jul 2024 14:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721944567; x=1722549367; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o5zN0Ee2V5PvZ/loIwKVW1h0fdtsfazaCJoYyQYKYrE=;
        b=Bs7rCUsVawywy0+OLM+zDopW1Pv9euupkXSqALmH7MnCBe1BnaGkhXQhN0A//32sDE
         hsYImLP2tAEjhuuBypAoMNqVVXXfDT1kGcmLF5kF28AH9ZDHowvAS3ZP6pWlYa9F2QD9
         Px+6RMk/CBzsHUtlTaeVd4xmrR28ZgGMC0NXpiSTIMvfaa/EOOo+SNP10cs5g/Sv94YC
         wpK4iRTXSDoSZG9A7zo2Q4QPisYzAkPqwGPz7Pb1q8CvxMNbBcS2TtCCKl7XPm1QuybS
         xBTiiHv5j+eIRvl6q/aSKBUVnfi/Gdg6wfq0863/D9PRywheUc1eanJgxLQI39XVKYws
         Mbcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721944567; x=1722549367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o5zN0Ee2V5PvZ/loIwKVW1h0fdtsfazaCJoYyQYKYrE=;
        b=waBHpUn9NEQbWpmY/kt66RKbo4ArrRuInIWuhlHpvkdPJpQVGyKENA43CG2O8yMjoe
         Zlj7hX8hqjdPvDNaP2JUxNI1qSc2Ke7s8CEAvkyUl+JTX03JgQWXvneUi4QKRSdmBB+L
         +u+xxnyOm1cd7eUQU/2ztnLMh+XV5Obc76mtl3OXznb1WV741xaoT7cLyU8JuVJroJDe
         Sp0f6mZbjYOnUfHn7h2C5a4JwCXCn7OzAtJLjE+nt8FXmfkVhmG4O+offKlirkv0Ci9g
         OXS+FKx20yVg28GHx9tWFvuEwXACWdA34VCuLK4Plv8wtQ6uX3f1o0FJp8jesZMVTs/Q
         wv6w==
X-Forwarded-Encrypted: i=1; AJvYcCWLVVtwwGmgziLjEOs4vQAYctn4CZ1NUDK0C9X1ELyKorir7zG6yifv813ju4W/E7yxopuu/SnGIfvZAz+IuhA5rJM0CzRg
X-Gm-Message-State: AOJu0YxjcBBy/N2HSAw7fcWhayk4y893v+1PTgoAwFHlJaXInqel2v4K
	ojrg+4RZAmcx4rq5EtRS+kwSU5XJyI6ncI2Nd8yPN8ZCatR5XbRhbb6EDWxMRukMB8tWz0cAnrB
	rcvRlvMkiisOVwb6AcehnAJOD41Y3/R4qvXZ5
X-Google-Smtp-Source: AGHT+IFhP5/yTm7ISgwUHXy+IaF0SeriofzfJKq8H3XwJMAsEhtvrR3NBZlrFcMQ5LfszxCadNdzcI48wvWetEqqHuE=
X-Received: by 2002:a05:622a:134b:b0:447:e76a:c04b with SMTP id
 d75a77b69052e-44ff3a6ea56mr930791cf.10.1721944567177; Thu, 25 Jul 2024
 14:56:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com> <20240724011037.3671523-4-jthoughton@google.com>
In-Reply-To: <20240724011037.3671523-4-jthoughton@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 25 Jul 2024 14:55:30 -0700
Message-ID: <CADrL8HV5M-n72KDseDKWpGrUVMjC147Jqz98PxyG2ZeRVbFu8g@mail.gmail.com>
Subject: Re: [PATCH v6 03/11] KVM: arm64: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 23, 2024 at 6:11=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> Replace the MMU write locks (taken in the memslot iteration loop) for
> read locks.
>
> Grabbing the read lock instead of the write lock is safe because the
> only requirement we have is that the stage-2 page tables do not get
> deallocated while we are walking them. The stage2_age_walker() callback
> is safe to race with itself; update the comment to reflect the
> synchronization change.
>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---

Here is some data to show that this patch at least *can* be helpful:

# arm64 patched to do aging (i.e., set HAVE_KVM_MMU_NOTIFIER_YOUNG_FAST_ONL=
Y)
# The test is faulting memory in while doing aging as fast as possible.
# taskset -c 0-32 ./access_tracking_perf_test -l -r /dev/cgroup/memory
-p -v 32 -m 3

# Write lock
vcpu wall time                : 3.039207157s
lru_gen avg pass duration     : 1.660541541s, (passes:2, total:3.321083083s=
)

# Read lock
vcpu wall time                : 3.010848445s
lru_gen avg pass duration     : 0.306623698s, (passes:11, total:3.372860688=
s)

Aging is able to run significantly faster, but vCPU runtime isn't
affected much (in this test).

It would be really nice to motivate this patch with a test that didn't
require patching the kernel... Oliver and Marc, please let me know if
you'd like to see more data. I'm also happy to simply drop this patch.
