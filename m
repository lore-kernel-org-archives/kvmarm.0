From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5 02/22] KVM: arm/arm64: Add GICV3 pending table save
 API documentation
Date: Wed, 26 Apr 2017 06:14:21 -0700
Message-ID: <20170426131421.GA50776@lvm>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-3-git-send-email-eric.auger@redhat.com>
 <CAFEAcA_0N9Jx5ym+=jjmxAzSaXPjt-m+gW1cq90of8Qhw3LOzg@mail.gmail.com>
 <a5ab9181-8398-f62b-12f1-032961b12c28@redhat.com>
 <CAFEAcA-u-sH+v-Pnr_3gRC3iSJP0ZK68+GqkDzmi3xe1-B2WAQ@mail.gmail.com>
 <20170426084830.GB2098@work-vm>
 <4dc866a0-582c-af69-916f-eb435988b5ec@redhat.com>
 <20170426130020.GM4104@cbox>
 <CAFEAcA8t0Y-UBu_Fx_YTsmnw8zvd4fctTfobdb-akjdx_81PWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28FF840C42
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 09:11:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EoPLcwIdwG-a for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Apr 2017 09:11:33 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7BF940C17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 09:11:32 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id r190so3973192wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 06:14:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA8t0Y-UBu_Fx_YTsmnw8zvd4fctTfobdb-akjdx_81PWA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Christoffer Dall <cdall@linaro.org>, kvm-devel <kvm@vger.kernel.org>, "prasun.kapoor" <Prasun.Kapoor@cavium.com>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Juan Quintela <quintela@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Vijaya Kumar K <vijayak@caviumnetworks.com>, "Kumar,
 Vijaya" <Vijaya.Kumar@cavium.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 26, 2017 at 02:01:55PM +0100, Peter Maydell wrote:
> On 26 April 2017 at 14:00, Christoffer Dall <cdall@linaro.org> wrote:
> > Alternatively we should mark a pending error notification to the guest
> > in KVM, so that when the guest boots it gets something like an SError
> > instead, given that presumably the guest wrote the weird value.  Except
> > of course if the problem is caused by QEMU fudging with the register
> > value for the PENDBASER.
> 
> If we have scope for complaining at the guest we should do it at
> the point where the guest sets PENDBASER in the first place...
> 

Is that what the hardware would have done?

Also, userspace could restore a bogus value in the PENDBASER (even
though the guest wrote something sane), so maybe we should just keep
this as is and handle it nicely in QEMU?

Thanks,
-Christoffer

> thanks
> -- PMM
