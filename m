From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 4/6] docs: mention checkpatch in the README
Date: Thu, 12 Jan 2017 18:09:22 +0100
Message-ID: <20170112170922.kfr4mssz6udxhu4s@hawk.localdomain>
References: <20170111162841.15569-1-alex.bennee@linaro.org>
 <20170111162841.15569-5-alex.bennee@linaro.org>
 <322298cd-aefa-e945-d3f4-1237767a06ef@redhat.com>
 <87lgug318o.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD7AC4019C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 12:07:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kq+f+4h3OVzP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 12:07:40 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DACC54019A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 12:07:40 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <87lgug318o.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 12, 2017 at 12:35:03PM +0000, Alex Benn=E9e wrote:
> =

> Paolo Bonzini <pbonzini@redhat.com> writes:
> =

> > On 11/01/2017 17:28, Alex Benn=E9e wrote:
> >> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> >> ---
> >>  README.md | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/README.md b/README.md
> >> index 5027b62..9462824 100644
> >> --- a/README.md
> >> +++ b/README.md
> >> @@ -79,3 +79,4 @@ You can add the following to .git/config to do this =
automatically for you:
> >>      [format]
> >>          subjectprefix =3D kvm-unit-tests PATCH
> >>
> >> +Please run the kernel's ./scripts/checkpatch.pl on new patches

s/patches/files

All patches should be new :-)

drew

> >
> > Does it really work well on kvm-unit-tests?
> =

> Well I keep getting pulled up on kernel coding style on my reviews so if
> we mean it we should enforce it.
> =

> --
> Alex Benn=E9e
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
