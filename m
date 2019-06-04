Return-Path: <SRS0=jSi8=UD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB60C282CE
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 16:01:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1212B2053B
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 16:01:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1212B2053B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 876524A51F;
	Tue,  4 Jun 2019 12:01:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o3jeWMNfOohE; Tue,  4 Jun 2019 12:01:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1BD84A4C2;
	Tue,  4 Jun 2019 12:01:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 598184A4FA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 09:50:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FsMxxnqLdS18 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jun 2019 09:50:53 -0400 (EDT)
Received: from Galois.linutronix.de (Galois.linutronix.de [146.0.238.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16DF24A4F1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 09:50:53 -0400 (EDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
 (envelope-from <bigeasy@linutronix.de>)
 id 1hY9pw-0001pl-94; Tue, 04 Jun 2019 15:50:48 +0200
Date: Tue, 4 Jun 2019 15:50:48 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Julien Grall <julien.grall@arm.com>
Subject: Re: KVM Arm Device passthrough and linux-rt
Message-ID: <20190604135047.5bwclgkvvr642ucj@linutronix.de>
References: <26832850-37ee-ae07-08ca-cc3e90978867@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <26832850-37ee-ae07-08ca-cc3e90978867@arm.com>
User-Agent: NeoMutt/20180716
X-Mailman-Approved-At: Tue, 04 Jun 2019 12:01:22 -0400
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>, julia@ni.com,
 Marc Zyngier <marc.zyngier@arm.com>, Steven Rostedt <rostedt@goodmis.org>,
 kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

On 2019-06-04 13:58:51 [+0100], Julien Grall wrote:
> Hi,
Hi,

> This is happening because vgic_v2_fold_lr_state() is expected
> to be called with interrupt disabled. However, some of the path
> (e.g eventfd) will take a spinlock.
> 
> The spinlock is from the waitqueue, so using a raw_spin_lock cannot
> even be considered.
> 
> Do you have any input on how this could be solved?

There is swair (init_swait_queue_head() and friends) in case that works
for you.

> Cheers,

Sebastian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
