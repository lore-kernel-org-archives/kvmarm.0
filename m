From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: BUG ALERT: ARM32 KVM does not work in 4.4-rc3
Date: Wed, 02 Dec 2015 11:19:52 +0300
Message-ID: <00b201d12cda$3899c7f0$a9cd57d0$@samsung.com>
References: <00fe01d12c09$576ca200$0645e600$@samsung.com>
 <565D677E.8000505@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 916B24977A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 03:18:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RQw0mh9VR7xP for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2015 03:18:28 -0500 (EST)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A7D648912
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 03:18:28 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYQ007CO1T5A300@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 02 Dec 2015 08:19:53 +0000 (GMT)
In-reply-to: <565D677E.8000505@arm.com>
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> > My project involves ARM64, but from time to time i also test ARM32
> > KVM. I have discovered that it stopped working in 4.4-rc3. The same
> > virtual machine works perfectly under current kvmarm/next, but gets
> > stuck at random point under 4.4-rc3 from linux-stable. I'm not sure
> > that i have time to investigate this quickly, but i'll post some new
> > information as soon as i get it

[skip]

> So until you bisect it to an exact commit and configuration, I declare
> the alert over. ;-)

 Just in case, to make sure you don't miss it. I have found the problem, and it's just good luck that it works on some machines.
Unreliably, BTW. The problem is that it verifies guest's physical addresses (IPA) against host memory map; and the fix is here:
http://www.spinics.net/lists/kvm/msg124561.html

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
