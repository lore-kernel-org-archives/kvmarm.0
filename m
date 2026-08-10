Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2133DB96B
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 13:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786367761; cv=none; b=EbTZk/xz+5gS75EJqPNt6RhZ/yng0Gwwy4u/u7ZpSfbp2Gd9AJEEP6ZhyynY+TCVhDV2EuiyRfyI+IhHBIRgA1z52MrEgOo+jmHwjUI4LazvCcGE41EWeuuoDBKd3oai1mXucXSbsHBo88dOMHdjoxzyIyltURNttDJVOX/HHWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786367761; c=relaxed/simple;
	bh=XU+Yh6jvhHTQ2a/3HxdMnwUDwPqj59NubIS9TFTIlO4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KCmi4f2zTTrmsqeEGOUt9qiD2wslRBfEpUaAyVKe5DzikGjw4FCUazKRGmaGm8dpSBaJX9d2RtRGFdg5BZS2MvnCuFm1OGpshtQCeHgMXR1pXVigudskVujPJcofouUdf1rioykZOjhUhREF93mjy//LAuXCNYQaApjVBZ5Ixms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hNguqcLK; arc=none smtp.client-ip=209.85.218.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hNguqcLK"
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c1c25c44d15so214449366b.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 06:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786367758; x=1786972558; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XU+Yh6jvhHTQ2a/3HxdMnwUDwPqj59NubIS9TFTIlO4=;
        b=hNguqcLK3II98t/ne7ZW54Ejk8fTsLuFf2KcGgHHVFNxV6wE9VM3MRIJInVKnOQPWT
         yUnXD/g6ICuy/UIVlozk8gfJ1Qutd0PFbUnEL75WJ/GlaH/SxUs7ORLjFBJex9Ic81cE
         /r78r5S14gK0vAMA8z73YCB7fEvXW88qgZT3HIGghp0Ug/DLcmv5dDsZ+i3ZEFoXbJce
         xwVJx0UfnGIkM+ZuR21nMFdroyEnMgkj+epwx/FZd7Pqi274GaaeVQojMWW6wsLPKrQe
         wriwY2UE/OVViU6eLj3xPa+3jsrRKsghhucf0kyHyK3TBRkCCoB1iQWZSpJ8KL5NifsO
         +l/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786367758; x=1786972558;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XU+Yh6jvhHTQ2a/3HxdMnwUDwPqj59NubIS9TFTIlO4=;
        b=S67TWbuLDIGvoAimwtuDJpvId26SPoX1r5UvOwwtVE6L6j6o7G7B44V7FYLr/mlwdu
         3Wv+4JF56VfA4i5y1+arz9rFchLsBStQuFo1kWSienc1kFWLSL6vKbo/uzJV4hM6UXvd
         VKmprHviEfyqy5qnyLqH7hvGbw3tG+Et/UtnamiU6nr/9dRlUgQvkkN5id/kllkkUwPe
         Oj3pOZ1Wp+qZs1+mUPBT1GJ3r8s1jchXTocpGik9E2HloKcBP9iRsXsOE7OdIHCRS4vk
         Z9jo7+WkBrHWyNVsPmNTEIQ2H7XW8/1kggUKFnOzGaIan2wMuv5EfdnCYxbzdsYE8Mc2
         pZ4g==
X-Forwarded-Encrypted: i=1; AHgh+RrP1rf6bLyZfsnjVBDuzPxiCtizrh0CDRPtx87cGxfpQJtj49nN8UZ47gvcl205+xMUFEtjo1E=@lists.linux.dev
X-Gm-Message-State: AOJu0YzxrNB+dcU+14y7C+FKf0ej7YcjcJ771pYTqHWDLlsEd7eaSbKP
	Ppqb82XGfk2KQLZXD/g62QtL9uvsez1BQix0sUeL12GwO4inLcwWvKr+Tdd6PfqeiSZo6bUdN9c
	86y/j690n/OldKmslyw==
X-Received: from ejcww4.prod.google.com ([2002:a17:907:a904:b0:c19:52d4:dc8f])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:7955:b0:c1f:5f64:1912 with SMTP id a640c23a62f3a-c20c68b9233mr86192466b.7.1786367757496;
 Mon, 10 Aug 2026 06:15:57 -0700 (PDT)
Date: Mon, 10 Aug 2026 13:15:56 +0000
In-Reply-To: <CAEvNRgHvBTKaG4G5J=sMFGYepEnOFaeCBtjkzN6xmGtZ+o6XxA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-8-tarunsahu@google.com> <CAEvNRgHvBTKaG4G5J=sMFGYepEnOFaeCBtjkzN6xmGtZ+o6XxA@mail.gmail.com>
Message-ID: <9huz4ih286b7.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 07/11] KVM: guest_memfd: Add support for freezing mappings
From: tarunsahu@google.com
To: Ackerley Tng <ackerleytng@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

Ackerley Tng <ackerleytng@google.com> writes:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>> Introduce kvm_gmem_freeze() to freeze a guest_memfd inode's mapping,
>> which prevents fallocate() operations and new page fault allocations
>> during preservation.
>>
>> Use a global SRCU (`kvm_gmem_freeze_srcu`) to synchronize freeze state
>> checkers without incurring per-fault locking overhead or risking per-CPU
>> memory exhaustion (as per-CPU structure not counted in cgroup) from
>> per-inode SRCU structures by faulty/compromised VMM.
>>
>
> I wonder if everything to do with freezing should be gated behind
> CONFIG_LIVEUPDATE_GUEST_MEMFD. What do people think?

Right now, Only liveupdate is the usecase. There was a discussion
around the future usecase when IOMMU FD can use few pages from
guest_memfd and will have to prevent punch_hole operation. But
that will also avoid new faults. So freezing is not the solution here.

A SEAL type solution like in memfd can be explored later. But this
is very far in future so Plenty of time to discuss more ideas.

On gating the freeze across CONFIG_LIVEUPDATE_GUEST_MEMFD sounds good
 Idea. As in future, there is a plan to remove the freeze at all from
the preservation path. Before LIVEUPDATE, there was no usecase and in
future, that usecase will also be gone. So gating it against the config
makes sense.

Would love to know what do people think?

~Tarun

>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>>
>> [...snip...]
>>
