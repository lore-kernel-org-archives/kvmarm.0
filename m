From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC v2 3/6] irq: bypass: Extend skeleton for ARM forwarding
 control
Date: Tue, 7 Jul 2015 15:22:34 +0200
Message-ID: <559BD29A.9000208@redhat.com>
References: <1436184692-20927-1-git-send-email-eric.auger@linaro.org>
 <1436184692-20927-4-git-send-email-eric.auger@linaro.org>
 <E959C4978C3B6342920538CF579893F0025F342B@SHSMSX104.ccr.corp.intel.com>
 <559BB167.1030603@redhat.com>
 <E959C4978C3B6342920538CF579893F0025F34FC@SHSMSX104.ccr.corp.intel.com>
 <559BB463.6090406@redhat.com>
 <E959C4978C3B6342920538CF579893F0025F3568@SHSMSX104.ccr.corp.intel.com>
 <559BB642.5010701@redhat.com>
 <E959C4978C3B6342920538CF579893F0025F35E1@SHSMSX104.ccr.corp.intel.com>
 <E959C4978C3B6342920538CF579893F0025F3645@SHSMSX104.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E91F57E73
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 09:11:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ei2KkiJIg3iu for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2015 09:11:13 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86BF457E71
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 09:11:13 -0400 (EDT)
In-Reply-To: <E959C4978C3B6342920538CF579893F0025F3645@SHSMSX104.ccr.corp.intel.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Wu, Feng" <feng.wu@intel.com>, Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "avi.kivity@gmail.com" <avi.kivity@gmail.com>, "mtosatti@redhat.com" <mtosatti@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>, "b.reynal@virtualopensystems.com" <b.reynal@virtualopensystems.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 07/07/2015 13:33, Wu, Feng wrote:
>>> > > The need to store the consumer->producer link seems to be unique to
>>> > > posted interrupts.  It is difficult to say without seeing the PI code,
>>> > > but I prefer to keep the bypass manager as small as possible.
>> > 
>> > Fine. I will follow your suggestion!
> If using the following changes, how can we assign 'prod', we need to use
> container_of to get struct kvm_kernel_irqfd and then refer to 'prod', but
> we cannot do this in irq_bypass_register_consumer(), right? It is a
> common API. But we can only get the associated producer info inside
> bypass manager, right?

KVM's add_producer and del_producer callbacks do have a pointer to the
producer.

Paolo
