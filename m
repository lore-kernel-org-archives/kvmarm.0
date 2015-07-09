From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 0/7] KVM: arm/arm64: gsi routing support
Date: Thu, 09 Jul 2015 21:08:36 +0300
Message-ID: <028401d0ba72$4736dbc0$d5a49340$@samsung.com>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
 <023601d0ba54$c4d6e020$4e84a060$@samsung.com> <559E927E.8040403@arm.com>
 <026801d0ba5f$43a79520$caf6bf60$@samsung.com> <559EAB3D.2080205@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8106658492
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 13:57:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sE8sWp3yPEsg for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 13:57:04 -0400 (EDT)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB83158490
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 13:57:04 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NR800HXCFQEWJA0@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 09 Jul 2015 19:08:38 +0100 (BST)
In-reply-to: <559EAB3D.2080205@linaro.org>
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
To: 'Eric Auger' <eric.auger@linaro.org>, 'Andre Przywara' <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: eric.auger@st.com, kvm@vger.kernel.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

> Well personally I prefer the type thing and I don't see much difference
> at userspace level anyway. But I am not this kind of hyperspace
> architect guy. So, since there is no consensus here, I would say let's
> wait for formal reviews of our maintainers and I will align.

 Hah, okay... Don't take it for too much. Anyway your word weighs much more than my one...

> hope this eventually works with
> ITS ;-)

 You know... There are actually problems with irqfd. However i'm not sure whether they are result of
some bug or of poorly made vGIC CPU interface software emulation. I don't have hardware with working
vGICv3 here. With GICv2m everything is fine, but code path is quite different, and LPI != SPI.
 This is further overcomplicated by the fact that as soon as i start up the profiler, the problem
goes away. Looks like increased number of context switches have impact.
 Actually, the problem is very poor vhost-net throughput, which jumps up when i start the profiler
and goes back down when i stop it. Just to note...
 I'm off since now for a small vacation, will be back on monday or tuesday. See you guys!

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
