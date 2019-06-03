Return-Path: <SRS0=VRSS=UC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECDEC28CC6
	for <kvmarm@archiver.kernel.org>; Mon,  3 Jun 2019 11:09:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 28A3123BF6
	for <kvmarm@archiver.kernel.org>; Mon,  3 Jun 2019 11:09:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28A3123BF6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7659A4A3B2;
	Mon,  3 Jun 2019 07:09:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xrnvkHXya3JD; Mon,  3 Jun 2019 07:09:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D34E4A4BD;
	Mon,  3 Jun 2019 07:09:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1F184A319
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jun 2019 07:09:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cVqGTutoSVOs for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Jun 2019 07:09:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ED8F4A49C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jun 2019 07:09:03 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0DB8A78;
 Mon,  3 Jun 2019 04:09:02 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1EE1C3F5AF;
 Mon,  3 Jun 2019 04:09:00 -0700 (PDT)
Date: Mon, 3 Jun 2019 12:08:58 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool v3 3/9] update_headers.sh: arm64: Copy
 sve_context.h if available
Message-ID: <20190603110858.GI28398@e103592.cambridge.arm.com>
References: <1559229194-3036-1-git-send-email-Dave.Martin@arm.com>
 <1559229194-3036-4-git-send-email-Dave.Martin@arm.com>
 <20190531180340.047189da@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190531180340.047189da@donnerap.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Christoffer Dall <cdall@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
 Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Amit Daniel Kachhap <amit.kachhap@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, May 31, 2019 at 06:03:40PM +0100, Andre Przywara wrote:
> On Thu, 30 May 2019 16:13:08 +0100
> Dave Martin <Dave.Martin@arm.com> wrote:
> 
> > The SVE KVM support for arm64 includes the additional backend
> > header <asm/sve_context.h> from <asm/kvm.h>.
> > 
> > So update this header if it is available.
> > 
> > To avoid creating a sudden dependency on a specific minimum kernel
> > version, ignore the header if the source kernel tree doesn't have
> > it.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  util/update_headers.sh | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/util/update_headers.sh b/util/update_headers.sh
> > index a7e21b8..90d3ead 100755
> > --- a/util/update_headers.sh
> > +++ b/util/update_headers.sh
> > @@ -25,11 +25,22 @@ fi
> >  
> >  cp -- "$LINUX_ROOT/include/uapi/linux/kvm.h" include/linux
> >  
> > +unset KVMTOOL_PATH
> > +
> > +copy_arm64 () {
> > +	local src=$LINUX_ROOT/arch/$arch/include/uapi/asm/sve_context.h
> 
> To go with your previous patches, aren't you missing the quotes here?

Hmmm, good question.  This is "obviously" a fancy variable assignment,
and so there would be no word splitting after expansion.  So quotes
wouldn't be needed here, just as with a simple assignment.  bash and
ash seem to work this way.

dash doesn't though, and a padantic reading of the bash man page
suggests that the dash behaviour may be more correct: i.e., local
is just a command, whose arguments are expanded in the usual way,
even if it happens to assign variables as part of its behaviour.

So, while I'm not sure whether or not quotes are officially needed here,
I guess we should have them to be on the safe side.

> > +
> > +	if [ -e "$src" ]
> > +	then
> > +		cp -- "$src" "$KVMTOOL_PATH/include/asm"
> > +	fi
> > +}
> > +
> 
> Maybe we can make this slightly more generic?
> copy_optional_arch() {
> 	local src="$LINUX_ROOT/arch/$arch/include/uapi/$1"
> 	[ -r "$src" ] && cp -- "$src" "$KVMTOOL_PATH/include/asm"
> }
> ...
> 	arm64) KVMTOOL_PATH=arm/aarch64
> 	       copy_optional_arch asm/sve_context.h
> 	       ;;

Happy to change it along those lines.  It's certainly possible this will
be needed again later for some future arch header.

Also, foo && bar exits the shell if foo yields false and set -e is in
effect, so I've reverted back to using an if.

(I'm still a little confused though, since I struggled to reproduce this
behaviour outside the script.)

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
