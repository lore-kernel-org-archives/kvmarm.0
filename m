From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 0/3] KVM: arm: Implement software vGICv2 emulation
Date: Tue, 30 Jun 2015 11:16:03 +0300
Message-ID: <01c601d0b30d$01cad080$05607180$@samsung.com>
References: <cover.1435567226.git.p.fedin@samsung.com>
 <20150629125213.GK11332@cbox> <559151FE.8020701@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F132856AA5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jun 2015 04:04:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W3t959q2pEU6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Jun 2015 04:04:55 -0400 (EDT)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35CEC56A7B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jun 2015 04:04:54 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQR00IZX0ASS760@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 30 Jun 2015 09:16:04 +0100 (BST)
In-reply-to: <559151FE.8020701@arm.com>
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
To: 'Andre Przywara' <andre.przywara@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: 'Marc Zyngier' <Marc.Zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> I wonder if these patches would pave the way to support running GICv2
> guests on GICv3s without compat support?

 Yes, it does. I haven't implemented GICv3 bit for this time, but - yes. And it will be a very small
addition.

> Pavel, is this "broken" GIC you are talking about going to appear in a
> publicly available SoC?

 In kernel documentation it's known as "FrankenGIC".
 First of all, it's Exynos 4 (however i don't know whether it implements virtualization extensions).
 Second, it is present in many consumer electronics products (does this count as "publicly
available"? But you can learn this fact from Samsung's opensource releases). I use one of these
boards for my tests because we have lots of them here :)
 Third, this code doesn't really depend on hardware GIC, and can be reused on RPi-2 with a little
more hacking.
 Fourth, there is at least of one ARM64 machine with broken vGICv3. And you can buy it. I have it
here. And it would also benefit from this code (yes, with GICv3 CPU interface emulation added, which
becomes trivial).

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
