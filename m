From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC 12/17] irq: bypass: Extend skeleton for ARM forwarding
 control
Date: Fri, 3 Jul 2015 09:02:44 +0200
Message-ID: <55963394.8010401@redhat.com>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
 <1435843047-6327-13-git-send-email-eric.auger@linaro.org>
 <55953F5F.9090203@redhat.com>
 <E959C4978C3B6342920538CF579893F0025E6C23@SHSMSX104.ccr.corp.intel.com>
 <E959C4978C3B6342920538CF579893F0025E6C38@SHSMSX104.ccr.corp.intel.com>
 <559631C0.4050806@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1208157885
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 02:51:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XBXBFqSjtVJ0 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2015 02:51:36 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0BB115787D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 02:51:35 -0400 (EDT)
In-Reply-To: <559631C0.4050806@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, "Wu, Feng" <feng.wu@intel.com>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "avi.kivity@gmail.com" <avi.kivity@gmail.com>, "mtosatti@redhat.com" <mtosatti@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>, "b.reynal@virtualopensystems.com" <b.reynal@virtualopensystems.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 03/07/2015 08:54, Eric Auger wrote:
>> > Oh... we can get gsi from irq_bypass_consumer -> _irqfd -> gsi, so it
>> > is not needed in irq_bypass_consumer. Got it! :)
> The issue I have is that struct _irqfd is local to eventfd.c so it
> cannot be used in archi specific code. Is it acceptable to move it to
> kvm_host.h, naming it something like kvm_kernel_irqfd (as done for
> kvm_kernel_irq_routing_entry)? Would also need to move _irqfd_resampler
> there (kvm_kernel_irqfd_resampler).

Yes, that's okay.  Can you put it in a new header file kvm_irqfd.h though?

Paolo

> irqfd user struct cannot be used in a standalone manner since we miss
> the kvm handle.
