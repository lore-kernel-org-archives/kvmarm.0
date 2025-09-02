Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C072EAB8E
	for <kvmarm@lists.linux.dev>; Tue,  2 Sep 2025 09:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756804940; cv=none; b=O7vvw9gQ7uT8geqkXPTyb2gWSpaj51gkIzhAn6wQQyMxh9ROISiqqYn5OA2Ub5OFgePFM/5SPjApn8U+eH7NXDTvL5TUQSHgKCRxKDMnaR39p0Qltz52bzDRr5DkX4E4MLUm3ax1msSQoMICVhmqyU0KYE/qVgx8YiOZbGq5AeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756804940; c=relaxed/simple;
	bh=JfU+C/+WNXrTU6x82nBJAMdCHq7IaWEhD6JeQAiASiA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bSxaBeeT2nX4O7byoFCgM2bGqZEI0+sGge2qq7R9CvqAAaOEQTcaFuuV92qdsW9a28EcShJQFM5xzAmC2wPmGk/attMYiJnvfr+Xda7vwtllE0XmkvQl/mFzYsOi52/B6i7u+HIgh7clmLggVn0weCu52ybTuFX0B9LWIL5JzF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zVvFQM+w; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zVvFQM+w"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b327480fd0so849581cf.0
        for <kvmarm@lists.linux.dev>; Tue, 02 Sep 2025 02:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756804937; x=1757409737; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UEJ7Ey14mWS9ux2fnI3lv4hByDSn+Z0hPpiKOiV6hv4=;
        b=zVvFQM+wGz5V3OzL7bM8yyT16QnhZ1+yZQOecxmE8GJALkx93HP2aITLT4GPpjxSwk
         FzSYiyXF/c4Y5DTR3TajURtTxC10e02ozV7QXVRs/mWcCAb7NxYBqrwXRjKgUdTucfr3
         DdOB+TWT90JSq/CwMApaHLJ9mcN19H/7cf4/RH4ArB0QYHsB6brHR6XvVrQgEEW0pVsF
         UlPUuznIjKnRTjwq7eZh+yufMhQ+hLxwkxl7hRSHZepa2J+6Gg5m3IyZrmxNry4T3m9C
         l3zWJbAuizXWveQNqW/8stUzSmTMTmDCHZFnq5UOiB0Ygn61IrMZEJPz71vwMCAGsOxE
         pqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756804937; x=1757409737;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UEJ7Ey14mWS9ux2fnI3lv4hByDSn+Z0hPpiKOiV6hv4=;
        b=YnSFKaxobPHetDBxn0mouCGbBXS1ExQClEZU+e0hNOhGOS/qYi78E+N/KcpwEfiIUJ
         Yep3lL9UeXZjYmBCc/N+Nu4tD8QRYsrF6htYDXw6SrH1LWUSAMgoeJojAbD2hbAW/Ppq
         LsuuW8QeqlztLBv7Cn4IY+kmaJP6YcfYXFm7WvdPbwqGHbjBjJLY8Q03xwXHOjCEwMFF
         yqT/d7em7zBo+Y0VTrB+RGhvGz5+2/ezgtf5vMj9ICz8vu2i2Fp95rky3rHxKjLvea+n
         KIPr7hTQqGj1vPFHCPmjOZUAweIyAr9qD70COHl3j3rLIVWjGtwZG554Sj9W1ewyATN7
         bttQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0RnI3CZVI85UF9wNi2gqYuOe6caSAfhsB+2fagmFCJcLC+13ZCDjXLFv3IugpJiP7U777OMc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxfLhEhkA3VtYaBFqR3JyRelPApefXzJg5SushNl2RLIy90aNGU
	xGpBZVr1VEuvaYxvlyCmuUC6tIeoikO1OioDiQbuBtXfBV6Igth4bjNIZUXTsiraiF2G72wUkol
	b4ewcGoRSNVB0vgwTs/Gt6AH8EIgYIHu9hDetnf3j
X-Gm-Gg: ASbGncvK7mf7yjm1xeowf9rf4YyUBo7gwD7YTKnEBUQhmGw+wwK9M8skNaNNfFLmGgs
	ViGaaMj1+iOIpbMjWc8cCsjG8ei6MgaZXAUXEz7X/sEIWva4ajA4hr8BIt9IxMCMZDVPNk1bQD6
	DHfPYG3biCwsVQs2ftENnACWAIfrgyEBkfcLDvhQQ6rWogiJGdv/WQ2AhA1b+MdXtwKOQMPJV1T
	D1PmJ6Url0SopU=
X-Google-Smtp-Source: AGHT+IE/365ZPa2na0I+61w5kSKHeQK2w8xYgvB2r/DuNmzeiSpIrPg40UHX6ZyJ0CzihYKx7admZMRUkLUk8hCwjvo=
X-Received: by 2002:ac8:5a56:0:b0:4b3:8ee:521b with SMTP id
 d75a77b69052e-4b31b0e2753mr12638851cf.0.1756804936638; Tue, 02 Sep 2025
 02:22:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CA+EHjTxymfya75KdOrUsSUhtfmxe180DedhJpLQAGeCjsum_nw@mail.gmail.com>
 <20250902091810.4854-1-roypat@amazon.co.uk>
In-Reply-To: <20250902091810.4854-1-roypat@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 2 Sep 2025 10:21:40 +0100
X-Gm-Features: Ac12FXxFB1Y6AnaQmou77bzNFiPMi0bpB9wRe5PhLp9QE0Dg7CKdLpI-R4eIPWU
Message-ID: <CA+EHjTz1JxOy=E3p=So2q+k=UK3cDG6C8gOUgA9NQEpqRdhW5g@mail.gmail.com>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "ackerleytng@google.com" <ackerleytng@google.com>, "david@redhat.com" <david@redhat.com>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "will@kernel.org" <will@kernel.org>, 
	"Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Sept 2025 at 10:18, Roy, Patrick <roypat@amazon.co.uk> wrote:
>
> On Tue, 2025-09-02 at 09:50 +0100, Fuad Tabba wrote:
> > On Tue, 2 Sept 2025 at 09:46, David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 02.09.25 09:59, Fuad Tabba wrote:
> >>> Hi Patrick,
> >>>
> >>> On Mon, 1 Sept 2025 at 15:56, Roy, Patrick <roypat@amazon.co.uk> wrote:
> >>>>
> >>>> On Mon, 2025-09-01 at 14:54 +0100, "Roy, Patrick" wrote:
> >>>>>
> >>>>> Hi Fuad!
> >>>>>
> >>>>> On Thu, 2025-08-28 at 11:21 +0100, Fuad Tabba wrote:
> >>>>>> Hi Patrick,
> >>>>>>
> >>>>>> On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:
> >>>>>>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> >>>>>>> index 12a12dae727d..b52b28ae4636 100644
> >>>>>>> --- a/include/linux/pagemap.h
> >>>>>>> +++ b/include/linux/pagemap.h
> >>>>>>> @@ -211,6 +211,7 @@ enum mapping_flags {
> >>>>>>>                                     folio contents */
> >>>>>>>          AS_INACCESSIBLE = 8,    /* Do not attempt direct R/W access to the mapping */
> >>>>>>>          AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
> >>>>>>> +       AS_NO_DIRECT_MAP = 10,  /* Folios in the mapping are not in the direct map */
> >>>>>>>          /* Bits 16-25 are used for FOLIO_ORDER */
> >>>>>>>          AS_FOLIO_ORDER_BITS = 5,
> >>>>>>>          AS_FOLIO_ORDER_MIN = 16,
> >>>>>>> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_spac
> >>>>>>>          return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
> >>>>>>>   }
> >>>>>>>
> >>>>>>> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
> >>>>>>> +{
> >>>>>>> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> >>>>>>> +}
> >>>>>>> +
> >>>>>>> +static inline bool mapping_no_direct_map(struct address_space *mapping)
> >>>>>>> +{
> >>>>>>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> >>>>>>> +}
> >>>>>>> +
> >>>>>>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
> >>>>>>> +{
> >>>>>>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
> >>>>>>> +}
> >>>>>>> +
> >>>>>> Any reason vma is const whereas mapping in the function that it calls
> >>>>>> (defined above it) isn't?
> >>>>>
> >>>>> Ah, I cannot say that that was a conscious decision, but rather an artifact of
> >>>>> the code that I looked at for reference when writing these two simply did it
> >>>>> this way.  Are you saying both should be const, or neither (in my mind, both
> >>>>> could be const, but the mapping_*() family of functions further up in this file
> >>>>> dont take const arguments, so I'm a bit unsure now)?
> >>>>
> >>>> Hah, just saw
> >>>> https://lore.kernel.org/linux-mm/20250901123028.3383461-3-max.kellermann@ionos.com/.
> >>>> Guess that means "both should be const" then :D
> >>>
> >>> I don't have any strong preference regarding which way, as long as
> >>> it's consistent. The thing that should be avoided is having one
> >>> function with a parameter marked as const, pass that parameter (or
> >>> something derived from it), to a non-const function.
> >>
> >> I think the compiler will tell you that that is not ok (and you'd have
> >> to force-cast the const it away).
> >
> > Not for the scenario I'm worried about. The compiler didn't complain
> > about this (from this patch):
> >
> > +static inline bool mapping_no_direct_map(struct address_space *mapping)
> > +{
> > +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> > +}
> > +
> > +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
> > +{
> > +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
> > +}
> >
> > vma_is_no_direct_map() takes a const, but mapping_no_direct_map()
> > doesn't. For now, mapping_no_direct_map() doesn't modify anything. But
> > it could, and the compiler wouldn't complain.
>
> Wouldn't this only be a problem if vma->vm_file->f_mapping was a 'const struct
> address_space *const'? I thought const-ness doesn't leak into pointers (e.g.
> even above, vma_is_no_direct_map isn't allowed to make vma point at something
> else, but it could modify the pointed-to vm_area_struct).

That's the thing, constness checks don't carry over to pointers within
a struct, but a person reading the code would assume that a function
with a parameter marked as const wouldn't modify anything related to
that parameter.

Cheers,
/fuad

> > Cheers,
> > /fuad
> >
> >
> >> Agreed that we should be using const * for these simple getter/test
> >> functions.
> >>
> >> --
> >> Cheers
> >>
> >> David / dhildenb
> >>
>
