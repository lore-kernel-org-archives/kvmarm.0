From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [Qemu-devel] [PATCH v3 4/4] target-arm: Add the GICv2m to the virt
 board
Date: Tue, 26 May 2015 09:39:32 +0300
Message-ID: <00c101d0977e$b990ea60$2cb2bf20$@samsung.com>
References: <1432464666-4825-1-git-send-email-christoffer.dall@linaro.org>
 <1432464666-4825-5-git-send-email-christoffer.dall@linaro.org>
 <011b01d096ec$1a395e80$4eac1b80$@samsung.com>
 <CAFEAcA9QWKuh3zjXg_n3HiABEgoXaiRJ8sHMnj=uOzdMGF6yDQ@mail.gmail.com>
 <55634D0D.3010103@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6272452014
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 02:29:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zoFemqRxSqWt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2015 02:29:57 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B9A75200F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 02:29:56 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NOY0064C2HX9950@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 26 May 2015 07:39:33 +0100 (BST)
In-reply-to: <55634D0D.3010103@linaro.org>
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
To: 'Eric Auger' <eric.auger@linaro.org>, 'Peter Maydell' <peter.maydell@linaro.org>
Cc: 'QEMU Developers' <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

 Hi!

> > Why? The v2m device isn't really related to the GICv3...
> In the future this handle could point to GICv2m or GICv3 ITS or GICv3
> (if I understand it correctly, when it supports message base interrupts
> and no ITS). They all would play the same role of msi-controller.

 Yes, exactly. In my implementation being developed i actually reused first patch from this set, and indeed 'v2m_handle' appeared to be useful for ITS. My code flow is something like:
 if (gicv3)
  create_its()
else
  create_v2m()

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
