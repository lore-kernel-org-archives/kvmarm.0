From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 5/5] KVM: arm64: Implement vGICv3 CPU interface access
Date: Fri, 04 Sep 2015 18:40:00 +0300
Message-ID: <023d01d0e727$f6630650$e32912f0$@samsung.com>
References: <cover.1441370053.git.p.fedin@samsung.com>
 <20be17e4e8aebcd7f1a52a634f449955bef99996.1441370053.git.p.fedin@samsung.com>
 <55E9B528.50106@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BFE941280
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2015 11:39:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k3BVLhNsUxog for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2015 11:39:37 -0400 (EDT)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75F7A41278
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2015 11:39:36 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NU500HYASUPUZ10@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 04 Sep 2015 16:40:01 +0100 (BST)
In-reply-to: <55E9B528.50106@arm.com>
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

> So can you model the register size according to the spec and allow
> 32-bit accesses from userland?

 I can. But i'll have to invent my own macro for encoding register IDs into the attribute, as well
as drop reusing index_to_params(). Will it be OK?
 Upside: i can further extend "cpu id" (actually CPU index) field to 31 bit. :)

 It's friday evening here, work week is almost over, i'll read your replies 2 days later on monday.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
