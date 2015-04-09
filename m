From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Advice on HYP interface for AsyncPF
Date: Wed, 08 Apr 2015 18:46:54 -0700
Message-ID: <5525DA0E.2010103@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 080D04BCD0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Apr 2015 21:39:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RiItcnfH7i6q for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Apr 2015 21:39:26 -0400 (EDT)
Received: from usmailout2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D5714BCCE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Apr 2015 21:39:25 -0400 (EDT)
Received: from uscpsbgex4.samsung.com
 (u125.gpu85.samsung.co.kr [203.254.195.125]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NMI002RGNMC09A0@mailout2.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 08 Apr 2015 21:47:00 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

I'm working with AsyncPF, and currently using
hyp call to communicate guest GFN for host to inject
virtual abort - page not available/page available.

Currently only PSCI makes use of that interface,
(handle_hvc()) can we overload interface with additional
hyp calls in this case pass guest gfn? Set arg0
to some range outside of PSCI use.

- Mario
