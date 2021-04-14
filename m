Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E21FC43460
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 20:09:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8597061179
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 20:09:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8597061179
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D87A4B304;
	Wed, 14 Apr 2021 16:09:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zRZqpT-9rbEc; Wed, 14 Apr 2021 16:09:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 842FA4B331;
	Wed, 14 Apr 2021 16:09:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66BE74B331
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 16:09:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1fhj0Lf77HYF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 16:09:28 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F01E04B2E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 16:09:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618430967;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=lPDLvyWiDWr007QIeC/gxWsnIDhSfOudqWTKl0gmPTU=;
 b=Tg4im1cIsc/ZaJXF2CM3pEN79UyHriPSxeQ7cNESD9dzhbF0C5aoUR7VP2wU5OTPabtYU+
 HQ0VpSD6haFe7sAWnXUUfDyd6nwWfr3BOkMAsagbrQFSfcaeirYxPt3WDd82Pp20LGM+cy
 feTgL4vZ/atJuLC6bK1Ign3elVEYdvc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-9XhduoplMruP510RiskrFg-1; Wed, 14 Apr 2021 16:09:25 -0400
X-MC-Unique: 9XhduoplMruP510RiskrFg-1
Received: by mail-wr1-f69.google.com with SMTP id
 f15-20020adffccf0000b02901028c7339ccso1536263wrs.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 13:09:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=lPDLvyWiDWr007QIeC/gxWsnIDhSfOudqWTKl0gmPTU=;
 b=qmujQPpYJx/RWMVB5rf6HERhueVkJVEXNucSx0SmQjCq/P1nf3SuZlARCjYGLyEDab
 pDveRKKHfcwK/myHwMqHhoIIgbUbhSTrxUwqPZBqC1cN1c+JQg04Un9BZeH2Gl2fqItB
 biUFfd3e2QkqwXmQM8bDtUnKbGXtoRstGTfkjLF855UQLUVR61LfFxcn4L3TWSmdHqnD
 HLuZs8DVvUuLuNzUtPyYBSxDhH2SRPIWo4uI6I0KVBY4QoCXUDgkAqO1ORmitO0hlmD5
 1FVIMUDGoN/nLTGCDtUgugGvviohc9b2vXJzWMFlUh6l8oYwNFlqwkrCwALORtulyMKR
 xzCQ==
X-Gm-Message-State: AOAM530MUNv022blgEo5/ybNkUpoztnVfGOZxki0/3VGuTgvkPn/eq41
 /yLvfaH8cz8Ry7+Tw+sPH48uQYkK6t2xc6tmbnlSp/OSVBQHn/2sMuqxFUyNLh3Cma+JxqmnRfQ
 b7SnxBBPNVlssEO6skS3kXOdsBnBUtzgC/8CJlGIv
X-Received: by 2002:a7b:c2fa:: with SMTP id e26mr4037338wmk.118.1618430964340; 
 Wed, 14 Apr 2021 13:09:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/XAvHspyAk+iSN2SFeJg1ElH6gfX+yek4iOtc5d3orcVRFuGmKT4pimIf7A4nXfVKrkNfELfMhIulk5i5bx4=
X-Received: by 2002:a7b:c2fa:: with SMTP id e26mr4037326wmk.118.1618430964125; 
 Wed, 14 Apr 2021 13:09:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210407172607.8812-1-rppt@kernel.org>
 <20210407172607.8812-2-rppt@kernel.org>
 <0c48f98c-7454-1458-15a5-cc5a7e1fb7cd@redhat.com>
 <YHdLSeYE3f5+v3n5@kernel.org>
In-Reply-To: <YHdLSeYE3f5+v3n5@kernel.org>
From: David Hildenbrand <david@redhat.com>
Date: Wed, 14 Apr 2021 22:09:13 +0200
Message-ID: <CADFyXm52avBBEitfCO-vt8rnQUy-PkKDxARqJ7mr3VWR9f920g@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH 1/3] memblock: update initialization of reserved
 pages
To: Mike Rapoport <rppt@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dhildenb@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0545650954576413949=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============0545650954576413949==
Content-Type: multipart/alternative; boundary="000000000000b5e15d05bff45259"

--000000000000b5e15d05bff45259
Content-Type: text/plain; charset="UTF-8"

Mike Rapoport <rppt@kernel.org> schrieb am Mi. 14. Apr. 2021 um 22:06:

> On Wed, Apr 14, 2021 at 05:12:11PM +0200, David Hildenbrand wrote:
> > On 07.04.21 19:26, Mike Rapoport wrote:
> > > From: Mike Rapoport <rppt@linux.ibm.com>
> > >
> > > The struct pages representing a reserved memory region are initialized
> > > using reserve_bootmem_range() function. This function is called for
> each
> > > reserved region just before the memory is freed from memblock to the
> buddy
> > > page allocator.
> > >
> > > The struct pages for MEMBLOCK_NOMAP regions are kept with the default
> > > values set by the memory map initialization which makes it necessary to
> > > have a special treatment for such pages in pfn_valid() and
> > > pfn_valid_within().
> >
> > I assume these pages are never given to the buddy, because we don't have
> a
> > direct mapping. So to the kernel, it's essentially just like a memory
> hole
> > with benefits.
>
> The pages should not be accessed as normal memory so they do not have a
> direct (or in ARMish linear) mapping and are never given to buddy.
> After looking at ACPI standard I don't see a fundamental reason for this
> but they've already made this mess and we need to cope with it.
>
> > I can spot that we want to export such memory like any special memory
> > thingy/hole in /proc/iomem -- "reserved", which makes sense.
>
> It does, but let's wait with /proc/iomem changes. We don't really have a
> 100% consistent view of it on different architectures, so adding yet
> another type there does not seem, well, urgent.
>

To clarify: this is already done on arm64.


> > I would assume that MEMBLOCK_NOMAP is a special type of *reserved*
> memory.
> > IOW, that for_each_reserved_mem_range() should already succeed on these
> as
> > well -- we should mark anything that is MEMBLOCK_NOMAP implicitly as
> > reserved. Or are there valid reasons not to do so? What can anyone do
> with
> > that memory?
> >
> > I assume they are pretty much useless for the kernel, right? Like other
> > reserved memory ranges.
>
> I agree that there is a lot of commonality between NOMAP and reserved. The
> problem is that even semantics for reserved is different between
> architectures. Moreover, on the same architecture there could be
> E820_TYPE_RESERVED and memblock.reserved with different properties.
>
> I'd really prefer moving in baby steps here because any change in the boot
> mm can bear several month of early hangs debugging ;-)


Yeah I know. We just should have the desired target state figured out :)



>
> > > Split out initialization of the reserved pages to a function with a
> > > meaningful name and treat the MEMBLOCK_NOMAP regions the same way as
> the
> > > reserved regions and mark struct pages for the NOMAP regions as
> > > PageReserved.
> > >
> > > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > > ---
> > >   mm/memblock.c | 23 +++++++++++++++++++++--
> > >   1 file changed, 21 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/memblock.c b/mm/memblock.c
> > > index afaefa8fc6ab..6b7ea9d86310 100644
> > > --- a/mm/memblock.c
> > > +++ b/mm/memblock.c
> > > @@ -2002,6 +2002,26 @@ static unsigned long __init
> __free_memory_core(phys_addr_t start,
> > >     return end_pfn - start_pfn;
> > >   }
> > > +static void __init memmap_init_reserved_pages(void)
> > > +{
> > > +   struct memblock_region *region;
> > > +   phys_addr_t start, end;
> > > +   u64 i;
> > > +
> > > +   /* initialize struct pages for the reserved regions */
> > > +   for_each_reserved_mem_range(i, &start, &end)
> > > +           reserve_bootmem_region(start, end);
> > > +
> > > +   /* and also treat struct pages for the NOMAP regions as
> PageReserved */
> > > +   for_each_mem_region(region) {
> > > +           if (memblock_is_nomap(region)) {
> > > +                   start = region->base;
> > > +                   end = start + region->size;
> > > +                   reserve_bootmem_region(start, end);
> > > +           }
> > > +   }
> > > +}
> > > +
> > >   static unsigned long __init free_low_memory_core_early(void)
> > >   {
> > >     unsigned long count = 0;
> > > @@ -2010,8 +2030,7 @@ static unsigned long __init
> free_low_memory_core_early(void)
> > >     memblock_clear_hotplug(0, -1);
> > > -   for_each_reserved_mem_range(i, &start, &end)
> > > -           reserve_bootmem_region(start, end);
> > > +   memmap_init_reserved_pages();
> > >     /*
> > >      * We need to use NUMA_NO_NODE instead of NODE_DATA(0)->node_id
>
> --
> Sincerely yours,
> Mike.
>
> --
Thanks,

David / dhildenb

--000000000000b5e15d05bff45259
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div><br></div><div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=
=3D"gmail_attr">Mike Rapoport &lt;<a href=3D"mailto:rppt@kernel.org">rppt@k=
ernel.org</a>&gt; schrieb am Mi. 14. Apr. 2021 um 22:06:<br></div><blockquo=
te class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-widt=
h:1px;border-left-style:solid;padding-left:1ex;border-left-color:rgb(204,20=
4,204)">On Wed, Apr 14, 2021 at 05:12:11PM +0200, David Hildenbrand wrote:<=
br>
&gt; On 07.04.21 19:26, Mike Rapoport wrote:<br>
&gt; &gt; From: Mike Rapoport &lt;<a href=3D"mailto:rppt@linux.ibm.com" tar=
get=3D"_blank">rppt@linux.ibm.com</a>&gt;<br>
&gt; &gt; <br>
&gt; &gt; The struct pages representing a reserved memory region are initia=
lized<br>
&gt; &gt; using reserve_bootmem_range() function. This function is called f=
or each<br>
&gt; &gt; reserved region just before the memory is freed from memblock to =
the buddy<br>
&gt; &gt; page allocator.<br>
&gt; &gt; <br>
&gt; &gt; The struct pages for MEMBLOCK_NOMAP regions are kept with the def=
ault<br>
&gt; &gt; values set by the memory map initialization which makes it necess=
ary to<br>
&gt; &gt; have a special treatment for such pages in pfn_valid() and<br>
&gt; &gt; pfn_valid_within().<br>
&gt; <br>
&gt; I assume these pages are never given to the buddy, because we don&#39;=
t have a<br>
&gt; direct mapping. So to the kernel, it&#39;s essentially just like a mem=
ory hole<br>
&gt; with benefits.<br>
<br>
The pages should not be accessed as normal memory so they do not have a<br>
direct (or in ARMish linear) mapping and are never given to buddy. <br>
After looking at ACPI standard I don&#39;t see a fundamental reason for thi=
s<br>
but they&#39;ve already made this mess and we need to cope with it.<br>
<br>
&gt; I can spot that we want to export such memory like any special memory<=
br>
&gt; thingy/hole in /proc/iomem -- &quot;reserved&quot;, which makes sense.=
<br>
<br>
It does, but let&#39;s wait with /proc/iomem changes. We don&#39;t really h=
ave a<br>
100% consistent view of it on different architectures, so adding yet<br>
another type there does not seem, well, urgent.<br>
</blockquote><div dir=3D"auto"><br></div><div dir=3D"auto">To clarify: this=
 is already done on arm64.</div><div dir=3D"auto"><br></div><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;=
border-left-style:solid;padding-left:1ex;border-left-color:rgb(204,204,204)=
"><br>
&gt; I would assume that MEMBLOCK_NOMAP is a special type of *reserved* mem=
ory.<br>
&gt; IOW, that for_each_reserved_mem_range() should already succeed on thes=
e as<br>
&gt; well -- we should mark anything that is MEMBLOCK_NOMAP implicitly as<b=
r>
&gt; reserved. Or are there valid reasons not to do so? What can anyone do =
with<br>
&gt; that memory?<br>
&gt; <br>
&gt; I assume they are pretty much useless for the kernel, right? Like othe=
r<br>
&gt; reserved memory ranges.<br>
<br>
I agree that there is a lot of commonality between NOMAP and reserved. The<=
br>
problem is that even semantics for reserved is different between<br>
architectures. Moreover, on the same architecture there could be<br>
E820_TYPE_RESERVED and memblock.reserved with different properties.<br>
<br>
I&#39;d really prefer moving in baby steps here because any change in the b=
oot<br>
mm can bear several month of early hangs debugging ;-)</blockquote><div dir=
=3D"auto"><br></div><div dir=3D"auto">Yeah I know. We just should have the =
desired target state figured out :)</div><div dir=3D"auto"><br></div><div d=
ir=3D"auto"><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px=
 0px 0px 0.8ex;border-left-width:1px;border-left-style:solid;padding-left:1=
ex;border-left-color:rgb(204,204,204)" dir=3D"auto"><br>
<br>
&gt; &gt; Split out initialization of the reserved pages to a function with=
 a<br>
&gt; &gt; meaningful name and treat the MEMBLOCK_NOMAP regions the same way=
 as the<br>
&gt; &gt; reserved regions and mark struct pages for the NOMAP regions as<b=
r>
&gt; &gt; PageReserved.<br>
&gt; &gt; <br>
&gt; &gt; Signed-off-by: Mike Rapoport &lt;<a href=3D"mailto:rppt@linux.ibm=
.com" target=3D"_blank">rppt@linux.ibm.com</a>&gt;<br>
&gt; &gt; ---<br>
&gt; &gt;=C2=A0 =C2=A0mm/memblock.c | 23 +++++++++++++++++++++--<br>
&gt; &gt;=C2=A0 =C2=A01 file changed, 21 insertions(+), 2 deletions(-)<br>
&gt; &gt; <br>
&gt; &gt; diff --git a/mm/memblock.c b/mm/memblock.c<br>
&gt; &gt; index afaefa8fc6ab..6b7ea9d86310 100644<br>
&gt; &gt; --- a/mm/memblock.c<br>
&gt; &gt; +++ b/mm/memblock.c<br>
&gt; &gt; @@ -2002,6 +2002,26 @@ static unsigned long __init __free_memory_=
core(phys_addr_t start,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0return end_pfn - start_pfn;<br>
&gt; &gt;=C2=A0 =C2=A0}<br>
&gt; &gt; +static void __init memmap_init_reserved_pages(void)<br>
&gt; &gt; +{<br>
&gt; &gt; +=C2=A0 =C2=A0struct memblock_region *region;<br>
&gt; &gt; +=C2=A0 =C2=A0phys_addr_t start, end;<br>
&gt; &gt; +=C2=A0 =C2=A0u64 i;<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0/* initialize struct pages for the reserved regions=
 */<br>
&gt; &gt; +=C2=A0 =C2=A0for_each_reserved_mem_range(i, &amp;start, &amp;end=
)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0reserve_bootmem_region(=
start, end);<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0/* and also treat struct pages for the NOMAP region=
s as PageReserved */<br>
&gt; &gt; +=C2=A0 =C2=A0for_each_mem_region(region) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (memblock_is_nomap(r=
egion)) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0start =3D region-&gt;base;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0end =3D start + region-&gt;size;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0reserve_bootmem_region(start, end);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; +=C2=A0 =C2=A0}<br>
&gt; &gt; +}<br>
&gt; &gt; +<br>
&gt; &gt;=C2=A0 =C2=A0static unsigned long __init free_low_memory_core_earl=
y(void)<br>
&gt; &gt;=C2=A0 =C2=A0{<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0unsigned long count =3D 0;<br>
&gt; &gt; @@ -2010,8 +2030,7 @@ static unsigned long __init free_low_memory=
_core_early(void)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0memblock_clear_hotplug(0, -1);<br>
&gt; &gt; -=C2=A0 =C2=A0for_each_reserved_mem_range(i, &amp;start, &amp;end=
)<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0reserve_bootmem_region(=
start, end);<br>
&gt; &gt; +=C2=A0 =C2=A0memmap_init_reserved_pages();<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 * We need to use NUMA_NO_NODE instead of NODE=
_DATA(0)-&gt;node_id<br>
<br>
-- <br>
Sincerely yours,<br>
Mike.<br>
<br>
</blockquote></div></div>-- <br><div dir=3D"ltr" class=3D"gmail_signature" =
data-smartmail=3D"gmail_signature">Thanks,<br><br>David / dhildenb</div>

--000000000000b5e15d05bff45259--


--===============0545650954576413949==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============0545650954576413949==--

