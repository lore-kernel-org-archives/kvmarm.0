From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool 4/6] Makefile: Remove echoing of kvmtools
 version file
Date: Thu, 31 Jan 2019 18:36:09 +0000
Message-ID: <20190131183609.07ac7afa@donnerap.cambridge.arm.com>
References: <20190125180801.209910-1-andre.przywara@arm.com>
 <20190125180801.209910-5-andre.przywara@arm.com>
 <20190130182036.GH18558@fuggles.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B589C4A39C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 13:36:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EoYlpXV8p-j3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Jan 2019 13:36:14 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BE634A2E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 13:36:14 -0500 (EST)
In-Reply-To: <20190130182036.GH18558@fuggles.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 30 Jan 2019 18:20:36 +0000
Will Deacon <will.deacon@arm.com> wrote:

> On Fri, Jan 25, 2019 at 06:07:59PM +0000, Andre Przywara wrote:
> > On every build we report the kvmtool "version" number, which isn't
> > meaningful at all anymore.
> > 
> > Remove the line from the KVMTOOLS-VERSION-GEN script to drop a
> > pointless message.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  util/KVMTOOLS-VERSION-GEN | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/util/KVMTOOLS-VERSION-GEN b/util/KVMTOOLS-VERSION-GEN
> > index f0dcfdea..91ee2c2f 100755
> > --- a/util/KVMTOOLS-VERSION-GEN
> > +++ b/util/KVMTOOLS-VERSION-GEN
> > @@ -35,6 +35,5 @@ else
> >  	VC=unset
> >  fi
> >  test "$VN" = "$VC" || {
> > -	echo >&2 "KVMTOOLS_VERSION = $VN"
> >  	echo "KVMTOOLS_VERSION = $VN" >$GVF  
> 
> It's probably fine, but can you check this doesn't break the debian
> packaging please?

Debian uses some date-based versioning (0.20170904-1) for kvmtool. I
built it with debuild and this patch in the patches directory, that
seemed to be fine (from my rather clueless Debian packaging point of
view, at least).

Cheers,
Andre.
