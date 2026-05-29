Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B867340409
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 08:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780042889; cv=pass; b=sh8hm2bRkfRuqAfN8OEFOSMybM8hVgIaFGEH/+eeVI7JeQJ5a4OBZAm06ccUoP+VEOrEyQOhS51bzAGOs6pr7jxIE+j3YJHpl9ntZjdn7ZNIrxGzyjZOLKSE+zkpsK74uPPmG0yvNtfG4hG7ySiZawYlzxbw8zPyQWWKGsVg5J8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780042889; c=relaxed/simple;
	bh=HCRBoVkJzn5YM7vwIS0/sFI8L9azsTe3ITWMrE8Yq3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eiCYogheyh+3IOkzH5fsfBzUUr1UuICja1nHbTkwexOmBnQWpAFvYfpOH7PIVGWx3wmjakWxG6rGOJtfEVpKv+2Gmbf5BpV2l7WK4Qb1r4M2eazJoKNmmdzSTIl9PWSjjMKRtxX51HtnDTO09mzK34+TkWcbehBbd1BW9xJGW3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BJantJ76; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BJantJ76"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-516d78ba1adso7711cf.1
        for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 01:21:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780042887; cv=none;
        d=google.com; s=arc-20240605;
        b=JvtnLpcCnh0RDWLig8EQYR0lc+PZw1GBEFwFQOx39VQINMVfxp82xZSnzOmShJz7Dl
         cXKgDEx1Ue8W1xke4HX3GHx/F21gh3aCSnGdGzQWABycqqQ/2XfM0Ni773LQIWFOnk7D
         fyJh3fB+JS6LqjCSY3UZtCzLzc6f2pJsuULkh7i0ZmvmiwmIBBqEWnrKrj+dm2PO57x2
         hr5GslDQ1BGSMKiXNQOAyGd2bMHGr0f0modwTG9jB0nlmSIUnge6+sGWq239KgQ4HFMx
         aPb9FQjIUgaaP54c0jSfUoVRvXTWEDRiSzI1lG0MhiAGICEaaK5psNOrL2sWEgNCH00M
         Xuqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=RTmG6wPP6fYkEoyy61gm5D9QOKDalR8QCsFErCfDfZc=;
        fh=2+QEuFpwNIAGIZ5/El8oscqG9mOhWrfxl5kPusZofqE=;
        b=LID6j02SLMWYcwHAo6Czr0NJjOO1faqZEhu7FcKO2/jOQorloLtN07XwNP2uKDU7pQ
         hVn/j8eEtWRrGy2B+MiqZUjM7nX7S+Y9HkV6H+ORkjvOm87knIWyEQTXflTMi0os6Nu7
         ZAEUP3gbQQQAGXq6bmtJt9Q96pa8sVNzq0BIiY4KwEJ9YmDUOGHQT7ZXKP9XIzcLrhZv
         BhO62Tfwb+V0qSujI9DD+i/UstvIgncjG3QHaf1lkzR580u4X5VRJelYVL+fpV3nveKn
         P6RnW3IjIXDCjqyaWHpZ3qnXliCv6hiBZnQpoXWIunmbAhbahPx5UNlJHRI+gtTNfb1I
         tQhA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780042887; x=1780647687; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RTmG6wPP6fYkEoyy61gm5D9QOKDalR8QCsFErCfDfZc=;
        b=BJantJ76N/s8S767CCy+Y4nhepM/ibg2MD6d6NEZ1oS2xikVm9JEUpMQmwhBaKyoJK
         ZkO//O8xpFwlGqYDogXYEjfvIg5sxLArCr6gzDFo5+ibtABAYQ7/vRGrmF/ytduqGpXc
         LDcPZrxHXvVnbOnpAb7yMxqImOYebPJ3xQtbgqScoS/1XchrFvfePgw9iVaJNbJOA1xS
         UF+vfO7O4OyRbJrC4RhiHIKBh4D7UGg4h+FpDPlmm4uHgNszOMBRWsvfkQJX8qxIPjkH
         vl53uhKFtnl2W7QxYBtfkm75Vg6VNjk8F8G6x+AODZY52Hkn7UVRkrpXzbQ6yFuaAvUY
         Zeig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780042887; x=1780647687;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTmG6wPP6fYkEoyy61gm5D9QOKDalR8QCsFErCfDfZc=;
        b=gYBwjr4jZWFuA1WziVwci2B61Ht+Uhc2nL0NPX+jPfSDBvu4RWMDSv0xx0NYl/GkHI
         et1BeKHSNwXjcUUbG43kDbLmbVftaDz/YRS59UTKgjw7JRCn7mqh7m1pPiMSb0SrOJ0q
         /GOhTSLYdvjYoaJpCshR48ayDrGhXUZmHAIB62v3R7BrIyfYxmbfzV4wP/+nvOejPIr5
         tL0DgIP7fbEpFDgDM3dWJTiR9Gn2IiQWI8oAYpO8SaHfBBaZi8YVszGrP9fZXaHjsXOj
         5aVtdaC8rPNbNHTq2VTtdM2MDcMFkRMXazdSX4coqKM27TRf3wQFHFHVJvWaAgkRS3vs
         /p0w==
X-Forwarded-Encrypted: i=1; AFNElJ/5ivuytiEgJLYGwvLHLgcEqIipe3HdkUnIVWAP5XAwio8QqDvThM/eyHhYCVi9oSBUoOw1Kpc=@lists.linux.dev
X-Gm-Message-State: AOJu0YynD6H6a5w4GAGMiL2kFGBSNV9vV1f9H3NU7yLfb45+wEL3rOA4
	Q9VAmZCzhJ+SKMJEz2vt/Dbafwll/joXqMR3I+tjZPdMCvYwxqYkWCuJTXIffPL5ldLrkkq9F4A
	k18Gezi0oNcjBNl5VJFDwMshNzjW1xugm2fwaOjZa
X-Gm-Gg: Acq92OGyLu0psFQmAj/3gNi9uXMORK5gaZxONhuGyQwLAF7MZXn6YYREJJOxEr66pN1
	ziV0AiyLn4YQZPGGbKQG2AiQnGDjpxBvtE+XBR/TetXprPqDZcW+Q94mABTMnDrqFcMwd1zK6s4
	ob50bL7sjRLdQtEwEjnxawk0fCttIQv6zr2G7/8M6I3S5aG8hOJCBWHY93vniSUrt0Ojbhd7rMl
	bbwswYv1xHpIFfQwwbaF5LxAlzfVh5Tkv/Zdyy4RxLmY/bn7omf07+YvzOS5HcfCp32vwKehWdI
	3vxq7cYH7bJoAQGgzyk=
X-Received: by 2002:ac8:58d1:0:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-5172f749fe4mr4854041cf.1.1780042886761; Fri, 29 May 2026
 01:21:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260529074341.2271950-1-tabba@google.com> <ahlIJQU-1b0mayPP@google.com>
 <CA+EHjTxktk4-B6qcAOf4O26++M5s6CKkkP539s4dRBRWxZN83Q@mail.gmail.com> <86a4tivdh3.wl-maz@kernel.org>
In-Reply-To: <86a4tivdh3.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 29 May 2026 09:20:50 +0100
X-Gm-Features: AVHnY4LMBqEt41ppX0e4qdU_UDhI0C7nxs47IWnoXMk36_X18jqA-R0xuCxrKOQ
Message-ID: <CA+EHjTykVY6x+iFwSFH7MaK7rfV5CTSeFwx4cZatbB+Fuzu9Yg@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fix host/hyp tracking on share/unshare
 hypercall failure
To: Marc Zyngier <maz@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 29 May 2026 at 09:15, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 29 May 2026 09:05:35 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > On Fri, 29 May 2026 at 09:02, Vincent Donnefort <vdonnefort@google.com> wrote:
> > >
> > > On Fri, May 29, 2026 at 08:43:39AM +0100, tabba@google.com wrote:
> > > > Hi folks,
> > > >
> > > > Yet another bug I found while testing Sashiko locally with fixes to
> > > > review-prompts.
> > > >
> > > > share_pfn_hyp() and unshare_pfn_hyp() in arch/arm64/kvm/mmu.c
> > > > maintain a host-side RB-tree mirroring the set of pages shared with
> > > > EL2. Both invoke a hypercall that can fail (page-state mismatch,
> > > > EL2 refcount still held), but neither cleans up on failure:
> > > >
> > > > - share_pfn_hyp() inserts the tracking node before the hypercall
> > > >   and leaves it in the tree on failure, leaking the allocation and
> > > >   presenting a phantom share to a later unshare.
> > > >
> > > > - unshare_pfn_hyp() erases the tracking node before the hypercall;
> > > >   on failure the host loses its record while EL2 still owns the
> > > >   share, breaking later operations on the same pfn.
> > > >
> > > > Severity is low (no isolation impact) and the failure paths are rare
> > > > in practice, but the desync is real. Both patches are independent and
> > > > apply cleanly to current mainline. In other words, this can wait for
> > > > 7.2.
> > >
> > >
> > > I believe I fixed that here lore.kernel.org/all/acyKhZL2di_QQ9xm@google.com but
> > > as Quentin pointed-out, there's absolutely no reason for the hypercall to fail.
> > > So I haven't sent a v2.
> >
> > At the very least we need to add a comment, otherwise, people like me
> > and LLMs like Sashiko would stumble upon it.
> >
> > That said, this fix adds no real overhead, makes the code clearer, and
> > guards us against a future where that call might fail.
> > Self-documenting in essense.
> >
> > WDYT?
>
> If a hypercall really cannot fail, why does it have a return value?

Good point. If we know it cannot fail, how about just `void`?

That said, Vincen't exact words are: `very much unlikely`, not the
same as cannot fail :)

https://lore.kernel.org/all/acyKhZL2di_QQ9xm@google.com/

/fuad

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
