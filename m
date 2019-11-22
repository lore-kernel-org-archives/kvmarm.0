Return-Path: <SRS0=LttP=ZO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD085C432C0
	for <kvmarm@archiver.kernel.org>; Fri, 22 Nov 2019 15:29:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 393F120715
	for <kvmarm@archiver.kernel.org>; Fri, 22 Nov 2019 15:29:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 393F120715
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90D184AED3;
	Fri, 22 Nov 2019 10:29:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G9Iz+1S9a2ON; Fri, 22 Nov 2019 10:29:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A14644AEC1;
	Fri, 22 Nov 2019 10:29:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AD654ACE6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 10:29:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D1cFtX2vAE-p for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Nov 2019 10:29:13 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E998C4A591
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 10:29:12 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iYArv-0004R5-1i; Fri, 22 Nov 2019 16:29:11 +0100
To: Daniel Verkamp <dverkamp@chromium.org>
Subject: Re: =?UTF-8?Q?KVM=5FCOMPAT=20support=20on=20aarch=36=34?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Fri, 22 Nov 2019 15:29:10 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <CABVzXA=DGxc4eE0RQX=tGu3QAYQ0RmEL7Y=WZYWBr355zEp_vA@mail.gmail.com>
References: <CABVzXA=DGxc4eE0RQX=tGu3QAYQ0RmEL7Y=WZYWBr355zEp_vA@mail.gmail.com>
Message-ID: <a07bd7883278838c26a955a1b4c43441@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: dverkamp@chromium.org, kvmarm@lists.cs.columbia.edu,
 dgreid@chromium.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: Dylan Reid <dgreid@chromium.org>, kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Daniel,

[please use my kernel.org address, as I'm not employed by ARM anymore]

On 2019-11-21 20:16, Daniel Verkamp wrote:
> Hi Marc,
>
> I noticed that in recent kernels (4.19 in our case), KVM no longer
> works for 32-bit processes running on arm64 machines. We
> (Crostini/crosvm, Linux VM support on Chromebooks) use this 
> KVM_COMPAT
> on all arm64-based Chromebooks that support VMs, since our entire
> userspace (including crosvm) is 32-bit.
>
> I found this commit (KVM: arm64: Prevent KVM_COMPAT from being
> selected):
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=37b65db85f9b2fc98267eee4a18d7506492e6e8c
>
> Is there any particular reason the compat ioctl is disabled (e.g.
> actual bugs/breakage), or would it be possible to re-enable 
> KVM_COMPAT
> for ARM64?

Well, it never worked the first place! :( The whole API is entirely 
different,
and you should feel extremely lucky that it ever seemed to work!

> In my brief testing with a 4.19-stable-based kernel on a new arm64
> board, everything seems to work fine with the commit above reverted.

The key word here is *seems*. It may happen that the userspace ABI
somehow align for some of the basic stuff, but it will fail for
anything moderately serious (I really doubt QEMU would be able to
run at all).

I suppose to tried this with crosvm? 32 or 64bit guest?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
