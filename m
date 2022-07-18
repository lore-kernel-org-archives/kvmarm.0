Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9FEC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 16:00:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BE7D4D784;
	Mon, 18 Jul 2022 12:00:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JH1KgL3CPRoU; Mon, 18 Jul 2022 12:00:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B280C4D769;
	Mon, 18 Jul 2022 12:00:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F2904D769
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 12:00:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5ffPyiuTFvPk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 12:00:33 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6DC3E4D756
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 12:00:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=mtkzJ8gYIfVJHGmdttrnhSApebA9lu35Rql+jSin4as=; b=qLZBllo2beUcZ4h47K6T14QkxU
 PEU68ddXgkJWQ+kM5WeuQpEmri4NJrW6H8GNwBeH0CNDG/5bbP4s1bund9sceoaQtfCOOnDBjfT/n
 y/TheW5S9/VKWrIxWSgqhSy6DpE8oj3dZ/ppNSioe0JBXOerhepdc4S7TTKLioz2AqnQogl6AF+fX
 wXiNOPPFR0MqrH6gY5byXYfnj3EJpEt98S7229giNLCVc8Rg0GL2ibbusUo648XNZqOua/Dl8yrWG
 jeuALN/KLuSYKCMyRzbvBH8/t5N2STz6cSW0jf2FKYXXn43iI8YAp0tH/DGQgMFquY5T34zjHHkAz
 C9vGxqYg==;
Received: from shell.armlinux.org.uk
 ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33414)
 by pandora.armlinux.org.uk with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <linux@armlinux.org.uk>)
 id 1oDTAG-0001mC-9n; Mon, 18 Jul 2022 17:00:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
 (envelope-from <linux@shell.armlinux.org.uk>)
 id 1oDTAD-00024v-7W; Mon, 18 Jul 2022 17:00:05 +0100
Date: Mon, 18 Jul 2022 17:00:05 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v4 01/18] arm64: stacktrace: Add shared header for common
 stack unwinding code
Message-ID: <YtWDhV4PPtTrYbMH@shell.armlinux.org.uk>
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-2-kaleshsingh@google.com>
 <YtVXokYGdlq1maQu@shell.armlinux.org.uk>
 <CAC_TJvfZG6CQOdSKeiNfVQhmL2TyeEuFbo9qo9yT20Qh49d3ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC_TJvfZG6CQOdSKeiNfVQhmL2TyeEuFbo9qo9yT20Qh49d3ZQ@mail.gmail.com>
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, elver@google.com,
 vincenzo.frascino@arm.com, will@kernel.org, android-mm@google.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, madvenka@linux.microsoft.com,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 drjones@redhat.com, ast@kernel.org, broonie@kernel.org, andreyknvl@gmail.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

On Mon, Jul 18, 2022 at 08:26:14AM -0700, Kalesh Singh wrote:
> On Mon, Jul 18, 2022 at 5:52 AM Russell King (Oracle)
> <linux@armlinux.org.uk> wrote:
> >
> > Hi,
> >
> > Can you please explain why you are targetting my @oracle.com email
> > address with this patch set?
> >
> > This causes me problems as I use Outlook's Web interface for that
> > which doesn't appear to cope with the threading, and most certainly
> > is only capable of top-reply only which is against Linux kernel email
> > standards.
> 
> Hi Russell,
> 
> Sorry I wasn't aware of it (I got your oracle email from
> get_maintainer script). Going forward I'll use the one you responded
> from instead.

Oh, this is the very annoying behaviour of get_maintainer.pl default
mode to think that if someone touches a file, they're interested in
future changes to it. In this case, it's because we both touched
arch/arm64/include/asm/memory.h back in November 2021, and this
silly script thinks I'll still be interested.

b89ddf4cca43 arm64/bpf: Remove 128MB limit for BPF JIT programs

(The patch was originally developed for Oracle's UEK kernels, hence
why it's got my @oracle.com address, but was later merged upstream.
Interestingly, no one spotted that Alan Maguire's s-o-b should've
been on it, as he was involved in the submission path to mainline.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
