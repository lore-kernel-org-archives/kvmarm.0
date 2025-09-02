Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43052E36F4
	for <kvmarm@lists.linux.dev>; Tue,  2 Sep 2025 08:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756803083; cv=none; b=PphD4imzETriMc7w9BlHq6Iym2p9O/WFxFnivUHWOKHTxnT4EOPdsYtjtJBoPAQ5XD1jZQ50hSmXNJlD/76j2jIMFDuwIo+B/0YZMmelRm3X8v1ZFTkD2aGjdxDAfKGONj2jHGVCvX4IrLr4DS9eylmDyX8SZADzjlk9zAiotrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756803083; c=relaxed/simple;
	bh=LpctAe6OrOBL+wU0ij68SMzomzlRkC/NvKCrGAq8e4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BCqBEcaJNJl3zG2b9qlFyqIl+CoDyTEubdiGGEVSdjceuFjxnZwZsxVM+3lrRRUHYFt7h2IboXzaLLqVYVDnGEZSwFhfnlbbq6suiJUtXQDWUnsMfeLuIS0cfGIMwpibIHLw98R7X6CHWW2MuIhhNI0drKtfPk6t7RmDno0oEkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i6eCPzRa; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i6eCPzRa"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b30bb04ed8so458021cf.1
        for <kvmarm@lists.linux.dev>; Tue, 02 Sep 2025 01:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756803081; x=1757407881; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iP4mX/+2DHYze7f0itBbCFIKzjrmdvMk6mmWMpcGwHA=;
        b=i6eCPzRaQl/dvaIDufdogA3Q/i2wdFlmE/ZBbJdaqqlwD8qwY2anXlm+1x2dsH63Ga
         S5kaREBoTojhDuy+zpmNm9fA+W4WSD3RZ4kjfEAz/u/FDVkvhdxISPv8cqzhYY5r2I4l
         csirQxsJCZBxQnDeGTUX3ZIkFtuCUq88S1elP/bbdggbDDkUjrhewGh8i6aGbcPq8LFL
         2GlihVMt00i3Sop0UpsoA5xrGNon08OiNqZfHnGIpP41/yk7J8glhf8P2+CA1gQofOH0
         WdHziPf70Qw46QgJXKEXVVUaMNHFIohmRe5BnX84iHMfEIp+nVXL8dxlOfTA84xWZ5wz
         PNcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756803081; x=1757407881;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iP4mX/+2DHYze7f0itBbCFIKzjrmdvMk6mmWMpcGwHA=;
        b=vx6HDDy3oLtvW39UlhzzFXkG9LRILhd+4IAGAVxRAvw1nvYC4XZPkuceK796GgWRXk
         ZfNmtZC0l2gfgYB0NoG03KOcvQeZ3HpeBTggj4Zy7l13oDXDrMDqxT1LQ13FY5w6zfTS
         xWl7CXBP4Fw1WLzAH9CUT8L+itE1aarUcaTpQ4nTbkkViAvaz7M3YLZ8gD7GnnOCmYen
         sP0zPdN34NP/kfuHAGMLzONLQaZq5yfuHE/0zwUfNLnfa8KV08EF5l9zlQKQcjxD9cxI
         1BmvehKnSDhsABRDxlvMnsv+ibdX+rf8AMvheLFT/0Mi/4OMLr02RMsJOtdUSG6DSht5
         Vmxw==
X-Forwarded-Encrypted: i=1; AJvYcCUSmv8TnDHpb9bNG/c5OJ1Z7JIWZaLY0OUMRjfGyCKoMl/2yrBTIIWKmbQWg89xr4B2T48NOI4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyP6el3PhAwV7ZH2+b7izQcudqW6HBVh6RgY8CLwuoJwNBfV2ed
	7Ks82F7JAxFxqFLE4NtSE+kleQ9jVL8M2Y5cQl8XysMKbTMAHZXlWKEvTV0rVYTk1x3RAhxysax
	eJGl6gjt4HrFnkN24pVF3VWrhWiZgwRn1fYLkibYf
X-Gm-Gg: ASbGnct2QwVkWACWR8KK1tssNaEyACF3qQoWYePrSE2oVyII9Ot0FENGetvmkpPsrF3
	4/M7rVq7hrM5gnyP3XIAADQKZoWgxCrVU+z/hE6lTJ072js9oy8X6z3JRKV9MKRWWkFZF23iC2x
	VR9ox+y8E/lxj3PjtEumJ6th3m8aTnDOrD5pWGYRzSk0rEWe2m6GMr1MacylyPSwVZ7pBC53Cyp
	Jw84gjD5n6u8V7e1aCGPzDRUQ==
X-Google-Smtp-Source: AGHT+IEl9wSTHdiJwZPLw2efIYDBOrEGcJPxDblGkQXiafOiZIaocXkLc6odVx1VLSTjodsqJVOs6KtZuN8sumvistY=
X-Received: by 2002:a05:622a:a28a:b0:4b0:9c14:2fec with SMTP id
 d75a77b69052e-4b325008444mr9184701cf.8.1756803080383; Tue, 02 Sep 2025
 01:51:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250901135408.5965-1-roypat@amazon.co.uk> <20250901145632.28172-1-roypat@amazon.co.uk>
 <CA+EHjTxPfzDk=XmwS0uAtjwsYB829s1uZSMC6x3R6KGQ-SqjtQ@mail.gmail.com> <862475d8-5a4f-44c3-9b3f-56319f70192d@redhat.com>
In-Reply-To: <862475d8-5a4f-44c3-9b3f-56319f70192d@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 2 Sep 2025 09:50:43 +0100
X-Gm-Features: Ac12FXwr7whnN-VXo5s-ZgZo6eW3l7wyHW3APjTTLjncve_-hqyXmzJXVm4lqgs
Message-ID: <CA+EHjTxymfya75KdOrUsSUhtfmxe180DedhJpLQAGeCjsum_nw@mail.gmail.com>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
To: David Hildenbrand <david@redhat.com>
Cc: "Roy, Patrick" <roypat@amazon.co.uk>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "will@kernel.org" <will@kernel.org>, 
	"Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Sept 2025 at 09:46, David Hildenbrand <david@redhat.com> wrote:
>
> On 02.09.25 09:59, Fuad Tabba wrote:
> > Hi Patrick,
> >
> > On Mon, 1 Sept 2025 at 15:56, Roy, Patrick <roypat@amazon.co.uk> wrote:
> >>
> >> On Mon, 2025-09-01 at 14:54 +0100, "Roy, Patrick" wrote:
> >>>
> >>> Hi Fuad!
> >>>
> >>> On Thu, 2025-08-28 at 11:21 +0100, Fuad Tabba wrote:
> >>>> Hi Patrick,
> >>>>
> >>>> On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:
> >>>>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> >>>>> index 12a12dae727d..b52b28ae4636 100644
> >>>>> --- a/include/linux/pagemap.h
> >>>>> +++ b/include/linux/pagemap.h
> >>>>> @@ -211,6 +211,7 @@ enum mapping_flags {
> >>>>>                                     folio contents */
> >>>>>          AS_INACCESSIBLE = 8,    /* Do not attempt direct R/W access to the mapping */
> >>>>>          AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
> >>>>> +       AS_NO_DIRECT_MAP = 10,  /* Folios in the mapping are not in the direct map */
> >>>>>          /* Bits 16-25 are used for FOLIO_ORDER */
> >>>>>          AS_FOLIO_ORDER_BITS = 5,
> >>>>>          AS_FOLIO_ORDER_MIN = 16,
> >>>>> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_spac
> >>>>>          return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
> >>>>>   }
> >>>>>
> >>>>> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
> >>>>> +{
> >>>>> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> >>>>> +}
> >>>>> +
> >>>>> +static inline bool mapping_no_direct_map(struct address_space *mapping)
> >>>>> +{
> >>>>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> >>>>> +}
> >>>>> +
> >>>>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
> >>>>> +{
> >>>>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
> >>>>> +}
> >>>>> +
> >>>> Any reason vma is const whereas mapping in the function that it calls
> >>>> (defined above it) isn't?
> >>>
> >>> Ah, I cannot say that that was a conscious decision, but rather an artifact of
> >>> the code that I looked at for reference when writing these two simply did it
> >>> this way.  Are you saying both should be const, or neither (in my mind, both
> >>> could be const, but the mapping_*() family of functions further up in this file
> >>> dont take const arguments, so I'm a bit unsure now)?
> >>
> >> Hah, just saw
> >> https://lore.kernel.org/linux-mm/20250901123028.3383461-3-max.kellermann@ionos.com/.
> >> Guess that means "both should be const" then :D
> >
> > I don't have any strong preference regarding which way, as long as
> > it's consistent. The thing that should be avoided is having one
> > function with a parameter marked as const, pass that parameter (or
> > something derived from it), to a non-const function.
>
> I think the compiler will tell you that that is not ok (and you'd have
> to force-cast the const it away).

Not for the scenario I'm worried about. The compiler didn't complain
about this (from this patch):

+static inline bool mapping_no_direct_map(struct address_space *mapping)
+{
+       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
+}
+
+static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
+{
+       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
+}

vma_is_no_direct_map() takes a const, but mapping_no_direct_map()
doesn't. For now, mapping_no_direct_map() doesn't modify anything. But
it could, and the compiler wouldn't complain.

Cheers,
/fuad


> Agreed that we should be using const * for these simple getter/test
> functions.
>
> --
> Cheers
>
> David / dhildenb
>
