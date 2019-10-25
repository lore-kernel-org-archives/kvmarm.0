Return-Path: <SRS0=vP85=YS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24EE4CA9EA0
	for <kvmarm@archiver.kernel.org>; Fri, 25 Oct 2019 08:24:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A45C021872
	for <kvmarm@archiver.kernel.org>; Fri, 25 Oct 2019 08:24:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A45C021872
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B9064A609;
	Fri, 25 Oct 2019 04:24:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wTXucxNe2e77; Fri, 25 Oct 2019 04:24:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 013FE4A5A3;
	Fri, 25 Oct 2019 04:24:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F6004A51D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Oct 2019 04:24:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8UHLW-12lBMv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Oct 2019 04:24:40 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1700E4A4DF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Oct 2019 04:24:40 -0400 (EDT)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iNutf-00012T-1B; Fri, 25 Oct 2019 10:24:35 +0200
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2] irqchip/gic-v3-its: Use the exact ITSList for VMOVP
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Fri, 25 Oct 2019 09:24:34 +0100
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <1571802386-2680-1-git-send-email-yuzenghui@huawei.com>
References: <1571802386-2680-1-git-send-email-yuzenghui@huawei.com>
Message-ID: <0f99f6a4ea567f53d38fb3bc0e6f59e4@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, tglx@linutronix.de,
 jason@lakedaemon.net, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, wanghaibin.wang@huawei.com,
 jiayanlei@huawei.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: jason@lakedaemon.net, jiayanlei@huawei.com,
 LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2019-10-23 04:46, Zenghui Yu wrote:
> On a system without Single VMOVP support (say GITS_TYPER.VMOVP == 0),
> we will map vPEs only on ITSs that will actually control interrupts
> for the given VM.  And when moving a vPE, the VMOVP command will be
> issued only for those ITSs.
>
> But when issuing VMOVPs we seemed fail to present the exact ITSList
> to ITSs who are actually included in the synchronization operation.
> The its_list_map we're currently using includes all ITSs in the 
> system,
> even though some of them don't have the corresponding vPE mapping at 
> all.
>
> Introduce get_its_list() to get the per-VM its_list_map, to indicate
> which ITSs have vPE mappings for the given VM, and use this map as
> the expected ITSList when building VMOVP. This is hopefully a 
> performance
> gain not to do some synchronization with those unsuspecting ITSs.
> And initialize the whole command descriptor to zero at beginning, 
> since
> the seq_num and its_list should be RES0 when GITS_TYPER.VMOVP == 1.
>
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>

I've applied this as a fix for 5.4. In the future, please cc LKML on 
all
IRQ-related patches (as documented in MAINTAINERS).

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
