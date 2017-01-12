From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 4/6] docs: mention checkpatch in the README
Date: Thu, 12 Jan 2017 18:08:29 +0100
Message-ID: <20170112170829.v7epg6lqhskc6ygs@hawk.localdomain>
References: <20170111162841.15569-1-alex.bennee@linaro.org>
 <20170111162841.15569-5-alex.bennee@linaro.org>
 <322298cd-aefa-e945-d3f4-1237767a06ef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A71B14019C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 12:06:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id prqKI6uIJmbZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 12:06:48 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1BA4B4019A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 12:06:47 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <322298cd-aefa-e945-d3f4-1237767a06ef@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 12, 2017 at 01:29:52PM +0100, Paolo Bonzini wrote:
> =

> =

> On 11/01/2017 17:28, Alex Benn=E9e wrote:
> > Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> > ---
> >  README.md | 1 +
> >  1 file changed, 1 insertion(+)
> > =

> > diff --git a/README.md b/README.md
> > index 5027b62..9462824 100644
> > --- a/README.md
> > +++ b/README.md
> > @@ -79,3 +79,4 @@ You can add the following to .git/config to do this a=
utomatically for you:
> >      [format]
> >          subjectprefix =3D kvm-unit-tests PATCH
> >  =

> > +Please run the kernel's ./scripts/checkpatch.pl on new patches
> =

> Does it really work well on kvm-unit-tests?

I use it on new code (liberally ignoring stuff I don't think
is worth conforming to), but there's no chance it'll work on
old files (many lib files and pretty much all x86 files). So
we can't really enforce for x86 developers, as we prefer
consistency over kernel style. That said, I think mentioning
in the README that new files could use it (at least for guidance)
is a good idea.

Thanks,
drew
