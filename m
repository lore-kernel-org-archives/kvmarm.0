Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56130CCA477
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jun 2022 17:02:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAD544B387;
	Wed,  1 Jun 2022 13:02:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@quicinc.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x3d5bK9p5To7; Wed,  1 Jun 2022 13:02:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AD304B3CB;
	Wed,  1 Jun 2022 13:02:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F30F4B2B9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2022 13:41:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vs8198grJXbl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 May 2022 13:41:37 -0400 (EDT)
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com
 [199.106.114.38])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 036EA4B29F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2022 13:41:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
 t=1654018897; x=1685554897;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=P69t0B2Jaz9Oq6WPSoVJEBxSVVjv0VZ1WwYPpxNmfU4=;
 b=tQqdXHaFZuobDPbvhnzqqBrngwQXjyVfOpgwFn3qRZ6YEviVhgu5qjpO
 7avfOgXLkfH1c6rohT5ahwCwT7Pagm4WJG+FuHkWkCx0Lvni42ZrwwzVZ
 bqYtkURfEeXfXj/rx5uBjK4KhpJs5vZs/a+I1OtvvbVTHrUQ/XVMWS71E 4=;
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
 by alexa-out-sd-01.qualcomm.com with ESMTP; 31 May 2022 10:41:35 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
 by ironmsg02-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 31 May 2022 10:41:35 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 31 May 2022 10:41:34 -0700
Received: from qian (10.80.80.8) by nalasex01a.na.qualcomm.com (10.47.209.196)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 31 May
 2022 10:41:33 -0700
Date: Tue, 31 May 2022 13:41:31 -0400
From: Qian Cai <quic_qiancai@quicinc.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix memory leaks from stage2 pagetable
Message-ID: <YpZTS5R+3cisLCzl@qian>
References: <20220526203956.143873-1-quic_qiancai@quicinc.com>
 <20220531165710.GB25631@willie-the-truck>
 <20220531170157.GC25631@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220531170157.GC25631@willie-the-truck>
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

On Tue, May 31, 2022 at 06:01:58PM +0100, Will Deacon wrote:
> Have you spotted any pattern for when the leak occurs? How are you
> terminating the guest?

It just to send a SIGTERM to the qemu-system-aarch64 process. Origially,
right after sending the signal, it will remove_id/unbind from the vfio-pci
and then bind to the original (ixgbe) driver. However, since the process
might take a while to clean off itself, the bind might failed with -EBUSY.
I could reproduce it a few times one day while was unable to do so some
other days.

Later, we changed the code to make sure the process is disappeard first and
then remove_id/bind/unbind. Apparently, it make harder to reproduce if not
totally eliminate it.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
