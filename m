From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 3/7] KVM: irqchip: convey devid to kvm_set_msi
Date: Fri, 17 Jul 2015 13:21:23 +0300
Message-ID: <029401d0c07a$55a3ddd0$00eb9970$@samsung.com>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
 <1436430137-24205-4-git-send-email-eric.auger@linaro.org>
 <01d401d0c062$086c2ee0$19448ca0$@samsung.com> <55A8D44A.3030105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55A8D44A.3030105@redhat.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Paolo Bonzini' <pbonzini@redhat.com>, 'Eric Auger' <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> >> > +	} else if (!msi->flags)
> >> > +		return -EINVAL;
> >  Did you mean "if (msg->flags)" here (inverted condition)?
> 
> Indeed, and also you need { } around the return for the QEMU coding
> standard.

 It's kernel and not qemu :)

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia

