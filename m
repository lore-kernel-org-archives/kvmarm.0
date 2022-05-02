Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B622CC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  3 May 2022 13:31:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21A354B129;
	Tue,  3 May 2022 09:31:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yZl64FyGbWfa; Tue,  3 May 2022 09:31:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEEF74B131;
	Tue,  3 May 2022 09:31:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B0134B0BE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 12:41:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QYcmsbb-Omrs for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 12:41:35 -0400 (EDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
 [209.85.221.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9CDE49F5D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 12:41:35 -0400 (EDT)
Received: by mail-wr1-f54.google.com with SMTP id t6so20282104wra.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 09:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=62IvqHI1fPfsDTYOxWAZqLaXvv0bxV93yimr+M9jpt0=;
 b=iHyOCwWrlVytNmY5kDXsFKgvgBdgQH093JMTVYtj7C6PiNMnkjycoz77hO2//mqSBu
 0FV0FBD0afAWefBbtJc09h06uiwVGguAhFvxPvI6OoaoXbtGw394E557wKd0p3W9c4RS
 cXnCtuUMM9/47EHG6Y4VC9dKvVdb0tEs2s85Irpc7ugM0EQr2GzExoAWKSD/Y47cljaM
 mDRQk2ukFTBc2sLdpwVcfjIYmaQr9t/I9aQJfVseMfbQNnntZUQ3cUThoWda7/djKML1
 zQgQqYTxkFPqf/yJCXbYGbRlstb5n3iL4Vz0+YKx20H8Fq5s4zVEjqyftbKsnF6Oc31F
 X9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=62IvqHI1fPfsDTYOxWAZqLaXvv0bxV93yimr+M9jpt0=;
 b=KsJkfoOK9eNBQjIRR/vnVBT7TDNZ2i7Y2slg2OHVErL46ofcGrxb2HCfaK+bFWg6SK
 u0FlCvPoAvIbwRj2BWGendQkamtXmy5NEeJnHLbc2DP1QOxf3Zi3K2St9Cn1z07rNHhi
 39GEa5jSJbDavEubf2y3X+TizgKZYyeRzkfpkn3ExmarvjzNFt7025k5NPvcO0PNz2V2
 /bG13EtNK0SlZjH18c94jQe59MkTF0Ax+NzDD2/v8I8lpTlFpE/84xBhDqUtUHYt7m9H
 iRYfOAC1k7tOE9GaNlGdo+i/mgFoYUMW8y7C+o6z5PEjqnPoUk2qF7dT+fenkKDND393
 1GMA==
X-Gm-Message-State: AOAM530cNjUncsO0DHjO/CVXcyxLRY5C5Ummvr0FIssg5HiOsp63l4KM
 mhnrkqYsTCTRJPoZgw0saCkit1Db8SUjmvm5Tjv0sg==
X-Google-Smtp-Source: ABdhPJzw3szkktfP5cD9rxhTjLw4EIjWshOQOMc+1Sm/TArbNr+CWDqd6B+lq74OgNTIKetf+oIw0DNRJSjAbJP+jEU=
X-Received: by 2002:a05:6000:1815:b0:20a:deee:3cf0 with SMTP id
 m21-20020a056000181500b0020adeee3cf0mr9846614wrh.210.1651509694568; Mon, 02
 May 2022 09:41:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-5-yosryahmed@google.com> <Ym+HLD/U0wwrxtaB@google.com>
 <87k0b4i7se.wl-maz@kernel.org>
In-Reply-To: <87k0b4i7se.wl-maz@kernel.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 2 May 2022 09:41:23 -0700
Message-ID: <CAJD7tka2NBymZaTQtDqGZRKZFwP7eniYU0Qa=HHjrZUkv032Cg@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] KVM: arm64/mmu: count KVM s2 mmu usage in
 secondary pagetable stats
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Tue, 03 May 2022 09:31:31 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 linux-mm@kvack.org, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
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
Content-Type: multipart/mixed; boundary="===============2488745840893879905=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============2488745840893879905==
Content-Type: multipart/alternative; boundary="000000000000b0b71305de0a10c8"

--000000000000b0b71305de0a10c8
Content-Type: text/plain; charset="UTF-8"

On Mon, May 2, 2022 at 2:48 AM Marc Zyngier <maz@kernel.org> wrote:

> On Mon, 02 May 2022 08:24:28 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > Hi Yosry,
> >
> > On Fri, Apr 29, 2022 at 08:11:31PM +0000, Yosry Ahmed wrote:
> > > Count the pages used by KVM in arm64 for stage2 mmu in secondary
> pagetable
> > > stats.
> > >
> > > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > > ---
> > >  arch/arm64/kvm/mmu.c | 35 +++++++++++++++++++++++++++++++----
> > >  1 file changed, 31 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index 53ae2c0640bc..fc5030307cce 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -92,9 +92,13 @@ static bool kvm_is_device_pfn(unsigned long pfn)
> > >  static void *stage2_memcache_zalloc_page(void *arg)
> > >  {
> > >     struct kvm_mmu_memory_cache *mc = arg;
> > > +   void *virt;
> > >
> > >     /* Allocated with __GFP_ZERO, so no need to zero */
> > > -   return kvm_mmu_memory_cache_alloc(mc);
> > > +   virt = kvm_mmu_memory_cache_alloc(mc);
> > > +   if (virt)
> > > +           kvm_account_pgtable_pages(virt, +1);
> >
> > Sorry I didn't say it last time around, would now be a good time to
> > clean up the funky sign convention of kvm_mod_used_mmu_pages()? Or limit
> > the funk to just x86 :)
>
> Indeed. I pointed this out in my initial review of this series, and
> expected these to be gone by now.


Hey everyone,

Sorry about that. Will clean that up in the next version.


>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>

--000000000000b0b71305de0a10c8
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div><br></div><div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=
=3D"gmail_attr">On Mon, May 2, 2022 at 2:48 AM Marc Zyngier &lt;<a href=3D"=
mailto:maz@kernel.org">maz@kernel.org</a>&gt; wrote:<br></div><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1p=
x;border-left-style:solid;padding-left:1ex;border-left-color:rgb(204,204,20=
4)">On Mon, 02 May 2022 08:24:28 +0100,<br>
Oliver Upton &lt;<a href=3D"mailto:oupton@google.com" target=3D"_blank">oup=
ton@google.com</a>&gt; wrote:<br>
&gt; <br>
&gt; Hi Yosry,<br>
&gt; <br>
&gt; On Fri, Apr 29, 2022 at 08:11:31PM +0000, Yosry Ahmed wrote:<br>
&gt; &gt; Count the pages used by KVM in arm64 for stage2 mmu in secondary =
pagetable<br>
&gt; &gt; stats.<br>
&gt; &gt; <br>
&gt; &gt; Signed-off-by: Yosry Ahmed &lt;<a href=3D"mailto:yosryahmed@googl=
e.com" target=3D"_blank">yosryahmed@google.com</a>&gt;<br>
&gt; &gt; ---<br>
&gt; &gt;=C2=A0 arch/arm64/kvm/mmu.c | 35 +++++++++++++++++++++++++++++++--=
--<br>
&gt; &gt;=C2=A0 1 file changed, 31 insertions(+), 4 deletions(-)<br>
&gt; &gt; <br>
&gt; &gt; diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c<br>
&gt; &gt; index 53ae2c0640bc..fc5030307cce 100644<br>
&gt; &gt; --- a/arch/arm64/kvm/mmu.c<br>
&gt; &gt; +++ b/arch/arm64/kvm/mmu.c<br>
&gt; &gt; @@ -92,9 +92,13 @@ static bool kvm_is_device_pfn(unsigned long pf=
n)<br>
&gt; &gt;=C2=A0 static void *stage2_memcache_zalloc_page(void *arg)<br>
&gt; &gt;=C2=A0 {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0struct kvm_mmu_memory_cache *mc =3D arg;<br>
&gt; &gt; +=C2=A0 =C2=A0void *virt;<br>
&gt; &gt;=C2=A0 <br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0/* Allocated with __GFP_ZERO, so no need to ze=
ro */<br>
&gt; &gt; -=C2=A0 =C2=A0return kvm_mmu_memory_cache_alloc(mc);<br>
&gt; &gt; +=C2=A0 =C2=A0virt =3D kvm_mmu_memory_cache_alloc(mc);<br>
&gt; &gt; +=C2=A0 =C2=A0if (virt)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kvm_account_pgtable_pag=
es(virt, +1);<br>
&gt; <br>
&gt; Sorry I didn&#39;t say it last time around, would now be a good time t=
o<br>
&gt; clean up the funky sign convention of kvm_mod_used_mmu_pages()? Or lim=
it<br>
&gt; the funk to just x86 :)<br>
<br>
Indeed. I pointed this out in my initial review of this series, and<br>
expected these to be gone by now.</blockquote><div dir=3D"auto"><br></div><=
div dir=3D"auto">Hey everyone,</div><div dir=3D"auto"><br></div><div dir=3D=
"auto">Sorry about that. Will clean that up in the next version.</div><div =
dir=3D"auto"><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0p=
x 0px 0px 0.8ex;border-left-width:1px;border-left-style:solid;padding-left:=
1ex;border-left-color:rgb(204,204,204)" dir=3D"auto"><br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 M.<br>
<br>
-- <br>
Without deviation from the norm, progress is not possible.<br>
</blockquote></div></div>

--000000000000b0b71305de0a10c8--

--===============2488745840893879905==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2488745840893879905==--
