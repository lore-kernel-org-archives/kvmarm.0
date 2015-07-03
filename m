From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Fri, 03 Jul 2015 18:29:32 +0300
Message-ID: <018401d0b5a5$10576a60$31063f20$@samsung.com>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
 <011f01d0b498$6a17aeb0$3e470c10$@samsung.com> <55954F6E.5030008@linaro.org>
 <55955542.6000809@arm.com> <55955728.3080506@linaro.org>
 <02eb01d0b4dd$50b25160$f216f420$@samsung.com> <55955B98.1000504@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF4FD57975
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 11:18:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iA4FC5xALVSP for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2015 11:18:18 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0704C5792A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 11:18:17 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQX00D0A4DAQZ80@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 03 Jul 2015 16:29:34 +0100 (BST)
In-reply-to: <55955B98.1000504@linaro.org>
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
To: 'Eric Auger' <eric.auger@linaro.org>, 'Andre Przywara' <andre.przywara@arm.com>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hi!

> OK so both of you say the same thing. Will respin accordingly

 You may also want to add this:
Tested-by: Pavel Fedin <p.fedin@samsung.com>

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
