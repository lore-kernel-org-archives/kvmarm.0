Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769E2C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 18:55:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 122004086F;
	Fri,  2 Dec 2022 13:55:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jmitMYF7Lv+l; Fri,  2 Dec 2022 13:55:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB9D540BE7;
	Fri,  2 Dec 2022 13:55:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12BF7401AF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 13:54:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HCILduNv19Ll for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2022 13:54:57 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B277140183
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 13:54:57 -0500 (EST)
Date: Fri, 2 Dec 2022 18:54:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670007296;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=QF7YyY0zCO4x691PE+6++2gBpkKD4tpfGa6u+JeBMx4=;
 b=EXkS9mLpz+vLNs65I4j2M/dADkhs3aXj6C2J9/QQBDtzZvHcNqfe16I74H5FqC54X6IZh1
 vDlLk2ztWLvPpDhIQey3K7nj4r9t8dEgpELG+MGppVJXr0vTOFEn8BqpFWmyYmdKr0UKQZ
 7KgvNJRzvcj4Zw0lGfzfhiHCt5vdOM8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 0/3] KVM: arm64: Handle CCSIDR associativity mismatches
Message-ID: <Y4pJ+wnzHv0Rpws+@google.com>
References: <20221201104914.28944-1-akihiko.odaki@daynix.com>
 <867czbmlh1.wl-maz@kernel.org> <Y4jyn+aMUGcaa6Ag@google.com>
 <87k03au36k.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87k03au36k.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Will Deacon <will@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 asahi@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

On Thu, Dec 01, 2022 at 11:14:43PM +0000, Marc Zyngier wrote:
> On Thu, 01 Dec 2022 18:29:51 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > Could we extend your suggestion about accepting different topologies to
> > effectively tolerate _any_ topology provided by userspace? KVM can
> > default to the virtual topology, but a well-informed userspace could
> > still provide different values to its guest. No point in trying to
> > babyproofing the UAPI further, IMO.
> 
> I think this is *exactly* what I suggested. Any valid topology should
> be able to be restored, as we currently present the VM with any
> topology the host HW may have. This must be preserved.

Ah, I was narrowly reading into the conversation as it relates to the M2
implementation, my bad. SGTM :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
