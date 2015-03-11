From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v9 5/5] KVM: arm/arm64: add irqfd support
Date: Wed, 11 Mar 2015 15:24:18 +0100
Message-ID: <20150311142418.GB14799@cbox>
References: <1425464076-20558-1-git-send-email-eric.auger@linaro.org>
 <1425464076-20558-6-git-send-email-eric.auger@linaro.org>
 <54F8359A.4020405@arm.com>
 <54F83DAE.2060607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54F83DAE.2060607@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Andre Przywara <Andre.Przywara@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>, "gleb@kernel.org" <gleb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 05, 2015 at 12:27:42PM +0100, Paolo Bonzini wrote:
> 
> 
> On 05/03/2015 11:53, Marc Zyngier wrote:
> > > +#ifdef CONFIG_HAVE_KVM_IRQFD
> > > +	case KVM_CAP_IRQFD:
> > > +		r = vgic_present;
> > > +		break;
> > > +#endif
> > 
> > Nitpick: we have "select HAVE_KVM_IRQFD", so we can lose the #ifdef-ery.
> 
> Alternatively, I've just posted a patch to move the KVM_CAP_IRQFD case
> to common code.
> 
> vgic_present probably should be replaced by
> IS_ENABLED(CONFIG_KVM_ARM_VGIC).  I've sent a patch for this.
> 
I have applied all of this together with my kill-the-vgic-config-option
patch here:

git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git queue

Take a look please.

Thanks,
-Christoffer
