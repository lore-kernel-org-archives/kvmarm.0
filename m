Return-Path: <SRS0=jSi8=UD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39879C282CE
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 15:05:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E1F61242CA
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 15:05:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1F61242CA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A13B4A510;
	Tue,  4 Jun 2019 11:05:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tw2n30-+P4k8; Tue,  4 Jun 2019 11:05:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FF864A50F;
	Tue,  4 Jun 2019 11:05:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AB214A503
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 11:05:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DR639x2TVAnm for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jun 2019 11:05:02 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1485C4A4A0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 11:05:02 -0400 (EDT)
Received: from oasis.local.home (unknown [146.247.46.6])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5147B24059;
 Tue,  4 Jun 2019 15:04:59 +0000 (UTC)
Date: Tue, 4 Jun 2019 11:04:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: KVM Arm Device passthrough and linux-rt
Message-ID: <20190604110454.2b99ee6e@oasis.local.home>
In-Reply-To: <f2fbc06b-373f-ee2a-b111-ea40848dc1c5@arm.com>
References: <26832850-37ee-ae07-08ca-cc3e90978867@arm.com>
 <20190604091607.2e87eb36@oasis.local.home>
 <f2fbc06b-373f-ee2a-b111-ea40848dc1c5@arm.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>, julia@ni.com,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On Tue, 4 Jun 2019 14:53:26 +0100
Marc Zyngier <marc.zyngier@arm.com> wrote:

> That's to prevent the injection of an interrupt firing on the same CPU
> while we're saving the corresponding vcpu interrupt context, among other
> things (the whole guest exit path runs with interrupt disabled in order
> to avoid this kind of thing).

Can't we use a per_cpu local lock for this?

-- Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
