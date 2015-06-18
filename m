From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 13/13] KVM: arm64: enable ITS emulation as a virtual MSI
 controller
Date: Thu, 18 Jun 2015 18:03:16 +0300
Message-ID: <01a401d0a9d7$e87997d0$b96cc770$@samsung.com>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
 <1432893209-27313-14-git-send-email-andre.przywara@arm.com>
 <558284B4.104@linaro.org> <5582D410.60708@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3066955ED3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 10:52:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hFC26OWw21W0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2015 10:52:39 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B48155EA2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 10:52:38 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQ50097HB5HNK50@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 18 Jun 2015 16:03:17 +0100 (BST)
In-reply-to: <5582D410.60708@arm.com>
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
To: 'Andre Przywara' <andre.przywara@arm.com>, 'Eric Auger' <eric.auger@linaro.org>, christoffer.dall@linaro.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> But that fails compilation on ARM (which uses this file as well),
> because we have a dummy fail function in the header if
> CONFIG_HAVE_KVM_MSI is not defined.

 May be then remove that fail function too? Too many #ifdef's are not good...

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
