From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 02/22] KVM: arm/arm64: Add GICV3 pending table save API
 documentation
Date: Wed, 26 Apr 2017 14:01:55 +0100
Message-ID: <CAFEAcA8t0Y-UBu_Fx_YTsmnw8zvd4fctTfobdb-akjdx_81PWA@mail.gmail.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-3-git-send-email-eric.auger@redhat.com>
 <CAFEAcA_0N9Jx5ym+=jjmxAzSaXPjt-m+gW1cq90of8Qhw3LOzg@mail.gmail.com>
 <a5ab9181-8398-f62b-12f1-032961b12c28@redhat.com>
 <CAFEAcA-u-sH+v-Pnr_3gRC3iSJP0ZK68+GqkDzmi3xe1-B2WAQ@mail.gmail.com>
 <20170426084830.GB2098@work-vm>
 <4dc866a0-582c-af69-916f-eb435988b5ec@redhat.com>
 <20170426130020.GM4104@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC21C40C43
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 08:59:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KGabHMYXOgxB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Apr 2017 08:59:25 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 283CD40C2C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 08:59:25 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id u65so49694127wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 06:02:16 -0700 (PDT)
In-Reply-To: <20170426130020.GM4104@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: "prasun.kapoor" <Prasun.Kapoor@cavium.com>, kvm-devel <kvm@vger.kernel.org>, Juan Quintela <quintela@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Vijaya Kumar K <vijayak@caviumnetworks.com>, "Kumar,
 Vijaya" <Vijaya.Kumar@cavium.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On 26 April 2017 at 14:00, Christoffer Dall <cdall@linaro.org> wrote:
> Alternatively we should mark a pending error notification to the guest
> in KVM, so that when the guest boots it gets something like an SError
> instead, given that presumably the guest wrote the weird value.  Except
> of course if the problem is caused by QEMU fudging with the register
> value for the PENDBASER.

If we have scope for complaining at the guest we should do it at
the point where the guest sets PENDBASER in the first place...

thanks
-- PMM
