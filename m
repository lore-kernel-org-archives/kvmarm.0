Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302D6C43334
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jun 2022 17:02:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80E5B4B346;
	Wed,  1 Jun 2022 13:02:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@quicinc.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p-jh4vvkjxEX; Wed,  1 Jun 2022 13:02:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 196C54B387;
	Wed,  1 Jun 2022 13:02:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 673764B427
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2022 13:23:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0eeUAt6zItya for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 May 2022 13:23:37 -0400 (EDT)
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com
 [199.106.114.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C4D4A4B421
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2022 13:23:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
 t=1654017816; x=1685553816;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=SS4f2RJO4J6Dl+skZQyymBm8JwW6+FCYen5Pp0Bb79k=;
 b=ov9pWJ9T6SfHSRx3T7OaCjn0K0xVeXJGYU7q0GR8wAaIRA4ulesq+7x3
 2kJoLuA4ABt3nue9i5CSlTlXmZNHK3OstWmddCacAFI2Z4QZINGaVrJhC
 /FroAPsILfMamONhkU+u7X8iJevhRJ41zzRsRzRQJfyd6ZQngVtKVY7iw M=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
 by alexa-out-sd-02.qualcomm.com with ESMTP; 31 May 2022 10:23:33 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
 by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 31 May 2022 10:23:32 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 31 May 2022 10:23:32 -0700
Received: from qian (10.80.80.8) by nalasex01a.na.qualcomm.com (10.47.209.196)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 31 May
 2022 10:23:31 -0700
Date: Tue, 31 May 2022 13:23:29 -0400
From: Qian Cai <quic_qiancai@quicinc.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix memory leaks from stage2 pagetable
Message-ID: <YpZPEStUD02jJ8C6@qian>
References: <20220526203956.143873-1-quic_qiancai@quicinc.com>
 <20220531165710.GB25631@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220531165710.GB25631@willie-the-truck>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Mailman-Approved-At: Wed, 01 Jun 2022 13:02:31 -0400
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On Tue, May 31, 2022 at 05:57:11PM +0100, Will Deacon wrote:
> On Thu, May 26, 2022 at 04:39:56PM -0400, Qian Cai wrote:
> > Running some SR-IOV workloads could trigger some leak reports from
> > kmemleak.
> > 
> > unreferenced object 0xffff080243cef500 (size 128):
> >   comm "qemu-system-aar", pid 179935, jiffies 4298359506 (age 1629.732s)
> >   hex dump (first 32 bytes):
> >     28 00 00 00 01 00 00 00 00 e0 4c 52 03 08 ff ff  (.........LR....
> >     e0 af a4 7f 7c d1 ff ff a8 3c b3 08 00 80 ff ff  ....|....<......
> >   backtrace:
> >      kmem_cache_alloc_trace
> >      kvm_init_stage2_mmu
> 
> Hmm, I can't spot a 128-byte allocation in here so this is pretty cryptic.
> I don't really like the idea of papering over the report; we'd be better off
> trying to reproduce it.

As far as I would like to reproduce, I have tried it in the last a few
weeks without luck. It still happens from time to time though from our
daily CI, so I was thinking to plug the knowns leaks first.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
