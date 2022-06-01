Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03BE8C43334
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jun 2022 19:42:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BBAF4B36B;
	Wed,  1 Jun 2022 15:42:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gr7d6WawbqLN; Wed,  1 Jun 2022 15:42:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 106464B19D;
	Wed,  1 Jun 2022 15:42:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 693174B19D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jun 2022 15:42:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NjflaiegI4V7 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jun 2022 15:42:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A0574B0BE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jun 2022 15:42:33 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC536D6E;
 Wed,  1 Jun 2022 12:42:32 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC0173F73D;
 Wed,  1 Jun 2022 12:42:31 -0700 (PDT)
Date: Wed, 1 Jun 2022 20:42:45 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 kvmtool 09/13] builtin_run: Allow standard size
 specifiers for memory
Message-ID: <YpfBIzLfTrjeiSL9@monolith.localdoman>
References: <20220525112345.121321-1-alexandru.elisei@arm.com>
 <20220525112345.121321-10-alexandru.elisei@arm.com>
 <20220601143955.55e00cfd@donnerap.cambridge.arm.com>
 <Ypd1DtVQwktvXITa@monolith.localdoman>
 <20220601171400.7318cc0b@donnerap.cambridge.arm.com>
 <YpfAXNgyNQ3Y0J/a@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YpfAXNgyNQ3Y0J/a@monolith.localdoman>
Cc: linux-arm-kernel@lists.infradead.org, maz@kernel.org, julien@xen.org,
 kvmarm@lists.cs.columbia.edu, will@kernel.org
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

Hi,

On Wed, Jun 01, 2022 at 08:39:08PM +0100, Alexandru Elisei wrote:
> Hi,
> 
> On Wed, Jun 01, 2022 at 05:14:00PM +0100, Andre Przywara wrote:
> > On Wed, 1 Jun 2022 15:17:50 +0100
> > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Alex,
> > 
[..]
> > So if we care about garbage as an argument, we should do it by the book
> > (strtoul manpage), and compare the next pointer to the input string
> 
> I believe my approach is by the man page, where strotoull returns ERANGE on

Err... by return ERANGE I mean that is sets errno to ERANGE (it return
ULLONG_MAX on overflow).

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
