Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D44A6312C
	for <kvmarm@lists.linux.dev>; Wed, 13 Mar 2024 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710350768; cv=none; b=GO+R/dmJPkJ5yYADPGkFVAQD9bUqDRVi6jdmHL0uFC0rVcB6/WXlZ/hSP6f0NKyAbloIVq5dVnx5f6lcJ3W8Wo1vaawn1rBq7YDJfYkvPSVGLL1kYYlWdTu5xta4zE1ifV4Qi6qN44v2bLGhv+cS1ELT6ytySUUiDIXn8hlur1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710350768; c=relaxed/simple;
	bh=I9c458fau7s/qbgcTvTxY2l0yV6utr/un5/7JO6yezw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z4Z8BsS2RMm1fmAoytr2UIkjBtZgpYRHel9CItMiIGDtc3yQDw1vjU2ukOE7v+1C0FrBFWCcxKBEIOYve+icbhVWpTABYNP04AJPf9EuQesb5qrlDxFPeYK0p0YMlDDMBEY2Ijpcj4WPmUdGr6sg4TBLQRIRt4sUhuqWJ36DM6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3ZQcpTk3; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3ZQcpTk3"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60cbba6fa0bso1784177b3.3
        for <kvmarm@lists.linux.dev>; Wed, 13 Mar 2024 10:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710350765; x=1710955565; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gcX9AtUTgbRRWqaR56NvhsHN3P+6d/4V94cthzgWh0Y=;
        b=3ZQcpTk3zOki+phO0MW4Ao+dyJ/AuXqaXp0v85ZwkxsYWqFD69ZVa+1kqu/h/KUjRk
         x/xagrNpjokYWRjPArLcMnFArob7VOBC9zmk8oJg+TX29dimQVOrT8C+U+Viv6efb1UU
         Yu8oiII+9fqCjQGvnkObWtEQchK2xneRvEYEYkiubtalANl/CxRSzQyje6gQ20WqooF/
         aQSqIdZlIL/xu0Cm0DylIEhb5h/i1dCG9vz+UIs7QJ45JXyG/w/iudl6t27dMefzB4+S
         ke52NML7p2pdpPVlUg2QxcL+dbBUKFgvFGWPofLgutNrCDg10X9VSPPBizxHgYg8YnXa
         JtuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710350765; x=1710955565;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gcX9AtUTgbRRWqaR56NvhsHN3P+6d/4V94cthzgWh0Y=;
        b=beVmlTQFX4EMp/0+/NE2YXNCjya56jy/kevfj0SVKhp+1IUIjtXfARlFOxHR21aNkQ
         NLQ69SFYkkrnVF4UA5qSdK4Wfg/i56XCtpEXt0Qn9DKtLz0HkAcwBwQyv7BOP5UZKSAO
         QKGRCXKpmrIpqEcu4wjIm5++gz1KBasEKKFLtyvGKlvDYsqQDNdM2qHDjOjqUoyLBAP8
         V9Qn49NgCzLxBSd6C/azjOZu92zYpxSqYfqjKjIkktToeDTNF1nLY2uIIiosBPTXio96
         /8toeWqJQWi2Id/qL16MeyFjffbpdKjnuCZSa/vfYvEm5Z1DspaW0Iw9++STDqngTVwd
         dEgA==
X-Forwarded-Encrypted: i=1; AJvYcCW22uQeOt32FNspHqU+kTmE5dngkXhIS0MmbOIlvU1x61vNxJyuuDLZTyI8amAC+IpO94f43B49jy7cDrbMDVnP662qjzw5
X-Gm-Message-State: AOJu0YyNQgMds4YU+Dsl7sn/SxmIR+5A1tFCex84rMEtE5lll4gPVD7a
	9YQkrSJMQX6wwrU5T/Nuu4hYz+dB9FUaDGHAzR1cRcPRJt4oJqKt53jVG5Wnm22NPuCFEvWSIrr
	+AA==
X-Google-Smtp-Source: AGHT+IGwf4gX+F4bms+2BpnmsZ3qxkW6UAbgseQC7+OYfG1HM4dh63OwsGqGDl91AxyXFXlj5L0z6ITsjhA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:dfd2:0:b0:609:38d1:2ad9 with SMTP id
 i201-20020a0ddfd2000000b0060938d12ad9mr816732ywe.4.1710350765330; Wed, 13 Mar
 2024 10:26:05 -0700 (PDT)
Date: Wed, 13 Mar 2024 17:26:03 +0000
In-Reply-To: <93df19f9-6dab-41fc-bbcd-b108e52ff50b@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240229025759.1187910-1-stevensd@google.com> <ZeCIX5Aw5s1L0YEh@infradead.org>
 <CAD=HUj7fT2CVXLfi5mty0rSzpG_jK9fhcKYGQnTf_H8Hg-541Q@mail.gmail.com>
 <72285e50-6ffc-4f24-b97b-8c381b1ddf8e@amd.com> <ZfGrS4QS_WhBWiDl@google.com>
 <0b109bc4-ee4c-4f13-996f-b89fbee09c0b@amd.com> <ZfG801lYHRxlhZGT@google.com>
 <9e604f99-5b63-44d7-8476-00859dae1dc4@amd.com> <ZfHKoxVMcBAMqcSC@google.com> <93df19f9-6dab-41fc-bbcd-b108e52ff50b@amd.com>
Message-ID: <ZfHhqzKVZeOxXMnx@google.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: "Christian =?utf-8?B?S8O2bmln?=" <christian.koenig@amd.com>
Cc: David Stevens <stevensd@chromium.org>, Christoph Hellwig <hch@infradead.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2024, Christian K=C3=B6nig wrote:
> Am 13.03.24 um 16:47 schrieb Sean Christopherson:
> > [SNIP]
> > > It can trivially be that userspace only maps 4KiB of some 2MiB piece =
of
> > > memory the driver has allocate.
> > >=20
> > > > I.e. Christoph is (implicitly) saying that instead of modifying KVM=
 to play nice,
> > > > we should instead fix the TTM allocations.  And David pointed out t=
hat that was
> > > > tried and got NAK'd.
> > > Well as far as I can see Christoph rejects the complexity coming with=
 the
> > > approach of sometimes grabbing the reference and sometimes not.
> > Unless I've wildly misread multiple threads, that is not Christoph's ob=
jection.
> >  From v9 (https://lore.kernel.org/all/ZRpiXsm7X6BFAU%2Fy@infradead.org)=
:
> >=20
> >    On Sun, Oct 1, 2023 at 11:25=E2=80=AFPM Christoph Hellwig<hch@infrad=
ead.org>  wrote:
> >    >
> >    > On Fri, Sep 29, 2023 at 09:06:34AM -0700, Sean Christopherson wrot=
e:
> >    > > KVM needs to be aware of non-refcounted struct page memory no ma=
tter what; see
> >    > > CVE-2021-22543 and, commit f8be156be163 ("KVM: do not allow mapp=
ing valid but
> >    > > non-reference-counted pages"). =C2=A0I don't think it makes any =
sense whatsoever to
> >    > > remove that code and assume every driver in existence will do th=
e right thing.
> >    >
> >    > Agreed.
> >    >
> >    > >
> >    > > With the cleanups done, playing nice with non-refcounted paged i=
nstead of outright
> >    > > rejecting them is a wash in terms of lines of code, complexity, =
and ongoing
> >    > > maintenance cost.
> >    >
> >    > I tend to strongly disagree with that, though. =C2=A0We can't just=
 let these
> >    > non-refcounted pages spread everywhere and instead need to fix the=
ir
> >    > usage.
>=20
> And I can only repeat myself that I completely agree with Christoph here.

I am so confused.  If you agree with Christoph, why not fix the TTM allocat=
ions?

> > > And I have to agree that this is extremely odd.
> > Yes, it's odd and not ideal.  But with nested virtualization, KVM _must=
_ "map"
> > pfns directly into the guest via fields in the control structures that =
are
> > consumed by hardware.  I.e. pfns are exposed to the guest in an "out-of=
-band"
> > structure that is NOT part of the stage-2 page tables.  And wiring thos=
e up to
> > the MMU notifiers is extremely difficult for a variety of reasons[*].
> >=20
> > Because KVM doesn't control which pfns are mapped this way, KVM's compr=
omise is
> > to grab a reference to the struct page while the out-of-band mapping ex=
ists, i.e.
> > to pin the page to prevent use-after-free.
>=20
> Wait a second, as far as I know this approach doesn't work correctly in a=
ll
> cases. See here as well: https://lwn.net/Articles/930667/
>
> The MMU notifier is not only to make sure that pages don't go away and
> prevent use after free, but also that PTE updates correctly wait for ongo=
ing
> DMA transfers.
>=20
> Otherwise quite a bunch of other semantics doesn't work correctly either.
>=20
> > And KVM's historical ABI is to support
> > any refcounted page for these out-of-band mappings, regardless of wheth=
er the
> > page was obtained by gup() or follow_pte().
>=20
> Well see the discussion from last year the LWN article summarizes.

Oof.  I suspect that in practice, no one has observed issues because the pa=
ges
in question are heavily used by the guest and don't get evicted from the pa=
ge cache.

> I'm not an expert for KVM but as far as I can see what you guys do here i=
s
> illegal and can lead to corruption.
>
> Basically you can't create a second channel to modify page content like
> that.

Well, KVM can, it just needs to honor mmu_notifier events in order to be 10=
0%
robust.

That said, while this might be motivation to revisit tying the out-of-band =
mappings
to the mmu_notifier, it has no bearing on the outcome of Christoph's object=
ion.
Because (a) AIUI, Christoph is objecting to mapping non-refcounted struct p=
age
memory *anywhere*, and (b) in this series, KVM will explicitly disallow non=
-
refcounted pages from being mapped in the out-of-band structures (see below=
).

> > Thus, to support non-refouncted VM_PFNMAP pages without breaking existi=
ng userspace,
> > KVM resorts to conditionally grabbing references and disllowing non-ref=
counted
> > pages from being inserted into the out-of-band mappings.
>=20
> Why not only refcount the pages when out of band mappings are requested?

That's also what this series effectively does.  By default, KVM will disall=
ow
inserting *any* non-refcounted memory into the out-of-band mappings.

"By default" because there are use cases where the guest memory pool is hid=
den
from the kernel at boot, and is fully managed by userspace.  I.e. userspace=
 is
effectively responsible/trusted to not free/change the mappings for an acti=
ve
guest.
