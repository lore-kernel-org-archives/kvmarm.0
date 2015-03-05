From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v9 5/5] KVM: arm/arm64: add irqfd support
Date: Thu, 05 Mar 2015 12:27:42 +0100
Message-ID: <54F83DAE.2060607@redhat.com>
References: <1425464076-20558-1-git-send-email-eric.auger@linaro.org>
 <1425464076-20558-6-git-send-email-eric.auger@linaro.org>
 <54F8359A.4020405@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82FE747D60
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 06:21:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id px84l5EAKjAs for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Mar 2015 06:21:42 -0500 (EST)
Received: from mail-wg0-f54.google.com (mail-wg0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FC4E47D38
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 06:21:41 -0500 (EST)
Received: by wggx12 with SMTP id x12so52758469wgg.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Mar 2015 03:27:46 -0800 (PST)
In-Reply-To: <54F8359A.4020405@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: "gleb@kernel.org" <gleb@kernel.org>, Andre Przywara <Andre.Przywara@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 05/03/2015 11:53, Marc Zyngier wrote:
> > +#ifdef CONFIG_HAVE_KVM_IRQFD
> > +	case KVM_CAP_IRQFD:
> > +		r = vgic_present;
> > +		break;
> > +#endif
> 
> Nitpick: we have "select HAVE_KVM_IRQFD", so we can lose the #ifdef-ery.

Alternatively, I've just posted a patch to move the KVM_CAP_IRQFD case
to common code.

vgic_present probably should be replaced by
IS_ENABLED(CONFIG_KVM_ARM_VGIC).  I've sent a patch for this.

Paolo
