From: Ronald Minnich <rminnich@google.com>
Subject: Re: stand-alone kvmtool
Date: Wed, 03 Jun 2015 17:07:07 +0000
Message-ID: <CAPAv03MV1p8P+1bgLnhFvqanyGiFbNyJF4-p4yJ-aezgfZKTAw@mail.gmail.com>
References: <54DDD465.3050300@arm.com> <20150218155042.GF22017@arm.com>
 <54EB622E.3020700@iki.fi> <20150603170457.GL17581@arm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6494090986139102017=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2432E52E77
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jun 2015 12:57:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AoCu4UnZm1dA for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Jun 2015 12:57:17 -0400 (EDT)
Received: from mail-oi0-f54.google.com (mail-oi0-f54.google.com
 [209.85.218.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 694DC52E5B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jun 2015 12:57:16 -0400 (EDT)
Received: by oiww2 with SMTP id w2so12347430oiw.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Jun 2015 10:07:18 -0700 (PDT)
In-Reply-To: <20150603170457.GL17581@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Pekka Enberg <penberg@iki.fi>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Andre Przywara <Andre.Przywara@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>, Asias He <asias.hejun@gmail.com>, Sasha Levin <sasha.levin@oracle.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

--===============6494090986139102017==
Content-Type: multipart/alternative; boundary=e89a8ff1ce146198300517a01731

--e89a8ff1ce146198300517a01731
Content-Type: text/plain; charset=UTF-8

GREAT stuff. I'll be looking for it :-)

ron

On Wed, Jun 3, 2015 at 10:05 AM Will Deacon <will.deacon@arm.com> wrote:

> On Mon, Feb 23, 2015 at 05:23:58PM +0000, Pekka Enberg wrote:
> > On 2/18/15 5:50 PM, Will Deacon wrote:
> > > Thanks for doing this. Since it looks unlikely that kvmtool will ever
> be
> > > merged back into the kernel tree, it makes sense to cut the dependency
> > > in my opinion.
> >
> > I am certainly OK with a standalone repository which preserves the
> > history. Will, would you like to take over the proposed new repository
> > and put it somewhere on git.kernel.org, perhaps?
>
> Finally got around to this with Andre's help, so I'll post a separate
> mail advertising it.
>
> Will
>

--e89a8ff1ce146198300517a01731
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">GREAT stuff. I&#39;ll be looking for it :-)<br><br><div>ro=
n</div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr">On Wed, Jun 3,=
 2015 at 10:05 AM Will Deacon &lt;<a href=3D"mailto:will.deacon@arm.com">wi=
ll.deacon@arm.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote"=
 style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On=
 Mon, Feb 23, 2015 at 05:23:58PM +0000, Pekka Enberg wrote:<br>
&gt; On 2/18/15 5:50 PM, Will Deacon wrote:<br>
&gt; &gt; Thanks for doing this. Since it looks unlikely that kvmtool will =
ever be<br>
&gt; &gt; merged back into the kernel tree, it makes sense to cut the depen=
dency<br>
&gt; &gt; in my opinion.<br>
&gt;<br>
&gt; I am certainly OK with a standalone repository which preserves the<br>
&gt; history. Will, would you like to take over the proposed new repository=
<br>
&gt; and put it somewhere on <a href=3D"http://git.kernel.org" target=3D"_b=
lank">git.kernel.org</a>, perhaps?<br>
<br>
Finally got around to this with Andre&#39;s help, so I&#39;ll post a separa=
te<br>
mail advertising it.<br>
<br>
Will<br>
</blockquote></div>

--e89a8ff1ce146198300517a01731--

--===============6494090986139102017==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6494090986139102017==--
