From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 3/5] KVM: arm64: Refactor system register handlers
Date: Fri, 04 Sep 2015 18:32:57 +0300
Message-ID: <023c01d0e726$fa307e80$ee917b80$@samsung.com>
References: <cover.1441370053.git.p.fedin@samsung.com>
 <855f207e2bb867041cd967d9ad02b7cb5f846e00.1441370053.git.p.fedin@samsung.com>
 <55E9B4BA.2030808@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0E8041289
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2015 11:32:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G3xkL15kK7mB for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2015 11:32:34 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8CB741280
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2015 11:32:34 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NU500M25SIYAT20@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 04 Sep 2015 16:32:59 +0100 (BST)
In-reply-to: <55E9B4BA.2030808@arm.com>
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
To: 'Andre Przywara' <andre.przywara@arm.com>
Cc: 'Marc Zyngier' <Marc.Zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> Mmmh, not sure about this, but I guess u64 would be more precise here?
> With the Rt2 handling below we rely on this being 64 bits anyway. But I
> guess that breaks with assigning vcpu_reg later and since this is arm64
> only, long is always 64 bits?

 It is because ' params.val = &val'. And params.val is u_long * because of: 'params.val =
vcpu_reg(vcpu, Rt)'. vcpu_reg() is declared as unsigned long * :
http://lxr.free-electrons.com/source/arch/arm64/include/asm/kvm_emulate.h#L102
 Initially i declared params.val as u64 *, but got warning in 'params.val = vcpu_reg(vcpu, Rt)'. So
i decided to change it to u_long * instead of having casts here and there. Do you like casts?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
