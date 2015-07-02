From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC 13/17] KVM: introduce kvm_arch functions for IRQ bypass
Date: Thu, 2 Jul 2015 15:41:08 +0200
Message-ID: <55953F74.4030207@redhat.com>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
 <1435843047-6327-14-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1435843047-6327-14-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 02/07/2015 15:17, Eric Auger wrote:
> +#ifdef CONFIG_IRQ_BYPASS_MANAGER

Please use a separate symbol CONFIG_KVM_HAVE_IRQ_BYPASS.

> +void kvm_arch_add_producer(struct irq_bypass_consumer *,
> +			   struct irq_bypass_producer *);

add_irq_bypass_producer, and so on below.

Paolo

> +void kvm_arch_del_producer(struct irq_bypass_consumer *,
> +			   struct irq_bypass_producer *);
> +void kvm_arch_stop_consumer(struct irq_bypass_consumer *);
> +void kvm_arch_resume_consumer(struct irq_bypass_consumer *);
> +
> +#else
> +void kvm_arch_add_producer(struct irq_bypass_consumer *,
> +			   struct irq_bypass_producer *)
> +{
> +}
> +void kvm_arch_del_producer(struct irq_bypass_consumer *,
> +			   struct irq_bypass_producer *)
> +{
> +}
> +void kvm_arch_stop_consumer(struct irq_bypass_consumer *)
> +{
> +}
> +void kvm_arch_resume_consumer(struct irq_bypass_consumer *)
> +{
> +}
