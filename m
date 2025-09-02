Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360262E7F1A
	for <kvmarm@lists.linux.dev>; Tue,  2 Sep 2025 07:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756799993; cv=none; b=IJO5ug7SDRJIMEMz2Z5FdgZsYdkdoZQKjDszD4tqZjUvMpQj+UOotiiIGXtm0tIQEpuJCK8cg32VK5JhKsifaf824o1NmGCOpnMI/M/d+C5REYFkY4t286Wrk9psdxl07j0fxaWw/xzFGzkrPYwCvQT1uw3SUTgmJib+JVh1fmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756799993; c=relaxed/simple;
	bh=tebRK0QcMgpMQT7H4oKZqhEct4KUpLNswRIw/gQ5Jd8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GdVl22+vAYWv6XLfrL7PvbS7RS5t4QCbKEWd/cBXkXaNJB5hblZAJe+CodXpbmf5sRqitdgMR1dBZJeiXuqfALYV55ky5QgbkdeOPWsxM4+jNFR9GQHIG5p6/FxoQa1gNSh4uFIBc2TlZUTibdNo/eRd1JFEelLIDnUrf9D/+vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lJMRNiZI; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lJMRNiZI"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b327480fd0so824561cf.0
        for <kvmarm@lists.linux.dev>; Tue, 02 Sep 2025 00:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756799991; x=1757404791; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oNeLWs2qHyUDts+2iHePFK0hNcgX1eWBxmSFpW760QQ=;
        b=lJMRNiZIBCGHpfe/N51fBnvH4OH8SeFN0WsUph6QnNlI19GOkeixJRR3a38wc4Q8Zi
         17/n+SUQpz09itiQafq7HlGvLF0wv4c9Nxo/VBT0ryYEgbrx6MJWczTV8hXqhS55ewXn
         e0QzQrWbI7Cz28IKEbw4JOloBGjgVoigZqSxH246HTOc5zdrUMzXDU4nB0nmpQphiYB9
         js0jfiTmg6Sn65XG44uFxIyF5pxLz80IJt+96MYe9kWEJtLXelsFHTL1MFinTgvMBiSS
         p5odzGYE0n2M2jtDQt//W8J6YLlHWn+JsOs2bhgAUjbrifVmZXMsVnd3xDvQKS8nlukx
         ir+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756799991; x=1757404791;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oNeLWs2qHyUDts+2iHePFK0hNcgX1eWBxmSFpW760QQ=;
        b=L0TCaK0d3vrlzjH1NNPubDmuceI6iZRuGPWO6zhJcmaMYXtlJYIw5gFb6XkpoGXdXb
         IJxnRseQo0OhIsR+Qw1pzEiuThf9+muKlDqRsyuKR/TcDHYNgU3tzlvxUWjeoOUtHftb
         t4cwShTFmc+aR1P1MILSQCLKoO6GdkA9sW+37NL+WcfgQiAufC+jUql2SeCYDJiMhUrY
         uPXOWNtKFGFAwqpTqYQpIqSOvIsHfQv3ju6tJSblqB6BELmajlhzqhqFKZ+ZXMRr/6oz
         O934DeV9UqLtiwbOnZeCKVI76z0enH54N70z/9qgpEqBS3RcYklXZsnQ0/C+vzHulxKY
         9u2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUKnp9eae7Ea3bKqpi6gGRpLVSbyQ4qzRIe9ZdcI+FoevsWxnCi3JM6uT3J4KHtTxM+04gDB+E=@lists.linux.dev
X-Gm-Message-State: AOJu0YzivVNVoEvo/mZ/F7E5Hx8w8agCanETP8TcreztIwyWTLUTlMwf
	5d/V32Ydy/5bT9XaSyX/2kWUyN5GMBI6VNScYowe1hKEE+nYh6F7TQx9DnfhM3X+0gCa2X11E3b
	KaWSm3lmkj/s8IiBTf98SSfLlBg1rJJCRi6PG88n4
X-Gm-Gg: ASbGnctz7GNXVwUZ1hZA8gDFvhPKy3rrH4mhPwok2laKNQWQh66McGJqPKPV148gf0b
	fWOEYmHx/89e0w7LGKUMLchFevaHHFWp5cApAoQlpxXVST61tAbhNdHdFQfb8Dh7ogXy7glW5BA
	LqzlOOBsftwz6asjWehQGSUejyDznJbvK1ZSKaHVsFi4BzNhfsX+7PkAlKZY/1BIy/hba2QCYRp
	U17jXFxcDee4nZeCJStgczqfjMkTWJFIWm/
X-Google-Smtp-Source: AGHT+IFkdbqiMarowY+mmKOzuU9RyYySZu0bnzDQg3QNeDfxzMXfy+3OtZ2GRaaDn0H+MAu5W+vNpqCjVKeX20zwo4o=
X-Received: by 2002:a05:622a:107:b0:48d:8f6e:ece7 with SMTP id
 d75a77b69052e-4b31b245bdfmr13130661cf.3.1756799990207; Tue, 02 Sep 2025
 00:59:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250901135408.5965-1-roypat@amazon.co.uk> <20250901145632.28172-1-roypat@amazon.co.uk>
In-Reply-To: <20250901145632.28172-1-roypat@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 2 Sep 2025 08:59:13 +0100
X-Gm-Features: Ac12FXwFaub6kV3Kd2ykY4foMIV_-u80DlGRtIr2iGvqoKH4iO-6ScE4yMry24U
Message-ID: <CA+EHjTxPfzDk=XmwS0uAtjwsYB829s1uZSMC6x3R6KGQ-SqjtQ@mail.gmail.com>
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

Hi Patrick,

On Mon, 1 Sept 2025 at 15:56, Roy, Patrick <roypat@amazon.co.uk> wrote:
>
> On Mon, 2025-09-01 at 14:54 +0100, "Roy, Patrick" wrote:
> >
> > Hi Fuad!
> >
> > On Thu, 2025-08-28 at 11:21 +0100, Fuad Tabba wrote:
> >> Hi Patrick,
> >>
> >> On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:
> >>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> >>> index 12a12dae727d..b52b28ae4636 100644
> >>> --- a/include/linux/pagemap.h
> >>> +++ b/include/linux/pagemap.h
> >>> @@ -211,6 +211,7 @@ enum mapping_flags {
> >>>                                    folio contents */
> >>>         AS_INACCESSIBLE = 8,    /* Do not attempt direct R/W access to the mapping */
> >>>         AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
> >>> +       AS_NO_DIRECT_MAP = 10,  /* Folios in the mapping are not in the direct map */
> >>>         /* Bits 16-25 are used for FOLIO_ORDER */
> >>>         AS_FOLIO_ORDER_BITS = 5,
> >>>         AS_FOLIO_ORDER_MIN = 16,
> >>> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_spac
> >>>         return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
> >>>  }
> >>>
> >>> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
> >>> +{
> >>> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> >>> +}
> >>> +
> >>> +static inline bool mapping_no_direct_map(struct address_space *mapping)
> >>> +{
> >>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> >>> +}
> >>> +
> >>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
> >>> +{
> >>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
> >>> +}
> >>> +
> >> Any reason vma is const whereas mapping in the function that it calls
> >> (defined above it) isn't?
> >
> > Ah, I cannot say that that was a conscious decision, but rather an artifact of
> > the code that I looked at for reference when writing these two simply did it
> > this way.  Are you saying both should be const, or neither (in my mind, both
> > could be const, but the mapping_*() family of functions further up in this file
> > dont take const arguments, so I'm a bit unsure now)?
>
> Hah, just saw
> https://lore.kernel.org/linux-mm/20250901123028.3383461-3-max.kellermann@ionos.com/.
> Guess that means "both should be const" then :D

I don't have any strong preference regarding which way, as long as
it's consistent. The thing that should be avoided is having one
function with a parameter marked as const, pass that parameter (or
something derived from it), to a non-const function. Instead of
helping, this could cause a lot of headaches when trying to debug
things in the future, and figuring out what something that's supposed
to be "const" is being "corrupted".

Cheers,
/fuad


>
> >> Cheers,
> >> /fuad
> >
> > Best,
> > Patrick
>
