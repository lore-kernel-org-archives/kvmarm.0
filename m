Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03FAC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 14 Oct 2022 10:41:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21CAD40E62;
	Fri, 14 Oct 2022 06:41:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iqobjV8Re4z0; Fri, 14 Oct 2022 06:41:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77C934B0D7;
	Fri, 14 Oct 2022 06:41:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73CD84B0D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 06:41:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hlmv+5EeSZcn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Oct 2022 06:41:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24D9C410DE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 06:41:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 939F913D5;
 Fri, 14 Oct 2022 03:41:11 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.1.42])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EEDF33F792;
 Fri, 14 Oct 2022 03:41:03 -0700 (PDT)
Date: Fri, 14 Oct 2022 11:41:01 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [REPOST][URGENT] kvmarm mailing list migration
Message-ID: <Y0k8vdn5kmIuvDIq@FVFF77S0Q05N>
References: <86edvbg3q7.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86edvbg3q7.wl-maz@kernel.org>
Cc: kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Thu, Oct 13, 2022 at 04:09:20PM +0100, Marc Zyngier wrote:
> [Reposting this, as it has been almost two weeks since the initial
>  announcement and we're still at sub-10% of the users having
>  subscribed to the new list]

FWIW, I didn't subscribe until just now because there weren't clear
instructions on the linked page. For everyone else's benefit, to subscribe you
need to send a mail to:

  kvmarm+subscribe@lists.linux.dev

... with any subject and body. You'll then get a confirmation email that you
need to reply to.

Thanks,
Mark.

>  
> Hi all,
> 
> As you probably all know, the kvmarm mailing has been hosted on
> Columbia's machines for as long as the project existed (over 13
> years). After all this time, the university has decided to retire the
> list infrastructure and asked us to find a new hosting.
> 
> A new mailing list has been created on lists.linux.dev[1], and I'm
> kindly asking everyone interested in following the KVM/arm64
> developments to start subscribing to it (and start posting your
> patches there). I hope that people will move over to it quickly enough
> that we can soon give Columbia the green light to turn their systems
> off.
> 
> Note that the new list will only get archived automatically once we
> fully switch over, but I'll make sure we fill any gap and not lose any
> message. In the meantime, please Cc both lists.
> 
> I would like to thank Columbia University for their long lasting
> support and willingness to help during this transition, as well as
> Konstantin (and the kernel.org crew) for quickly stepping up to the
> challenge and giving us a new home!
> 
> Thanks,
> 
> 	M.
> 
> [1] https://subspace.kernel.org/lists.linux.dev.html
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
