From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 0/7] arm/arm64: vgic: Implement API for vGICv3 live
 migration
Date: Wed, 16 Nov 2016 16:11:31 +0100
Message-ID: <20161116151131.GA19439@cbox>
References: <1478258013-6669-1-git-send-email-vijay.kilari@gmail.com>
 <20161116114722.GB3811@cbox>
 <CALicx6t=0sRYG1jn_=hqod+Kca9-8fWbtwL_-HXE3HvrA_h7PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C53C54050E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2016 10:11:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WHRH8nhkCYZW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2016 10:11:05 -0500 (EST)
Received: from mail-qk0-f173.google.com (mail-qk0-f173.google.com
 [209.85.220.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62A8240194
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2016 10:11:04 -0500 (EST)
Received: by mail-qk0-f173.google.com with SMTP id n204so178888764qke.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2016 07:11:36 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CALicx6t=0sRYG1jn_=hqod+Kca9-8fWbtwL_-HXE3HvrA_h7PQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vijay Kilari <vijay.kilari@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 16, 2016 at 08:24:16PM +0530, Vijay Kilari wrote:
> On Wed, Nov 16, 2016 at 5:17 PM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Fri, Nov 04, 2016 at 04:43:26PM +0530, vijay.kilari@gmail.com wrote:
> >> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >>
> >> This patchset adds API for saving and restoring
> >> of VGICv3 registers to support live migration with new vgic feature.
> >> This API definition is as per version of VGICv3 specification
> >> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
> >>
> >> The patch 3 & 4 are picked from the Pavel's previous implementation.
> >> http://www.spinics.net/lists/kvm/msg122040.html
> >
> > Do we have QEMU/kvmtool patches somewhere at this point so that I can
> > test this?
> 
> I will send you next revision of QEMU patches tomorrow.
> 
Sounds good, thanks.

-Christoffer
