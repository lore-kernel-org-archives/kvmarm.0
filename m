From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC 12/17] irq: bypass: Extend skeleton for ARM forwarding
 control
Date: Fri, 3 Jul 2015 09:08:54 +0200
Message-ID: <55963506.8020200@redhat.com>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
 <1435843047-6327-13-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B4657897
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 02:57:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N0JU-qzmRc+1 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2015 02:57:41 -0400 (EDT)
Received: from mail-wg0-f45.google.com (mail-wg0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33BE657896
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 02:57:40 -0400 (EDT)
Received: by wgqq4 with SMTP id q4so80701743wgq.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Jul 2015 00:08:59 -0700 (PDT)
In-Reply-To: <1435843047-6327-13-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 02/07/2015 15:17, Eric Auger wrote:
> +	void (*stop_producer)(struct irq_bypass_producer *);
> +	void (*resume_producer)(struct irq_bypass_producer *);

Also, can you call these just "stop"/"resume" ...

> +	void (*add_consumer)(struct irq_bypass_producer *,
> +			     struct irq_bypass_consumer *);
> +	void (*del_consumer)(struct irq_bypass_producer *,
> +			     struct irq_bypass_consumer *);
>  };
>  
>  struct irq_bypass_consumer {
>  	struct list_head node;
>  	void *token;
> -	void (*add_producer)(struct irq_bypass_producer *);
> -	void (*del_producer)(struct irq_bypass_producer *);
> +	unsigned int gsi;		/* the guest gsi */
> +	struct kvm *kvm;
> +	void (*stop_consumer)(struct irq_bypass_consumer *);
> +	void (*resume_consumer)(struct irq_bypass_consumer *);

... and same here?  The KVM functions could be named

- kvm_arch_irq_bypass_add_producer
- kvm_arch_irq_bypass_del_producer
- kvm_arch_irq_bypass_stop
- kvm_arch_irq_bypass_resume

Paolo
