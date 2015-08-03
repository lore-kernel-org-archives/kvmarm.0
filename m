From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 14/15] KVM: arm64: implement MSI injection in ITS
 emulation
Date: Mon, 03 Aug 2015 12:16:27 +0300
Message-ID: <00f101d0cdcd$146a6090$3d3f21b0$@samsung.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-15-git-send-email-andre.przywara@arm.com>
 <55BB7678.5080105@linaro.org> <55BE7BA1.40403@arm.com>
 <00a201d0cdb7$70a623f0$51f26bd0$@samsung.com> <55BF2F51.6020701@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 646FD59D6E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2015 05:03:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7c2BdjN-UEjP for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Aug 2015 05:03:49 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A01A059D6D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2015 05:03:49 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NSI00FSM1RGI830@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 03 Aug 2015 10:16:29 +0100 (BST)
In-reply-to: <55BF2F51.6020701@linaro.org>
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
To: 'Eric Auger' <eric.auger@linaro.org>, 'Andre Przywara' <andre.przywara@arm.com>, 'Marc Zyngier' <Marc.Zyngier@arm.com>, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> Again the case that leaves me uncomfortable is the one where the
> userspace does not provide the devid whereas it must (GICv3 ITS case).

 Hypothetical broken userland which does not exist for now ?
 IMHO the userland should just know, that if it supports ITS, it has to provide devIDs.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
