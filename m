Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F808BE1
	for <kvmarm@lists.linux.dev>; Tue,  8 Nov 2022 16:25:50 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id gw22so14272968pjb.3
        for <kvmarm@lists.linux.dev>; Tue, 08 Nov 2022 08:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTF7zBV9BebekratF2JVorEYVbhlKTgdQ9m8AxTWHRk=;
        b=rQzrBHKna1kMWB/FTWk17gtE5olvWShg6ghF8NLwazHqkAG98BIFOuEmDIqeZcx0Dq
         x8TI9L3ATQXwCsMqDemKLxtgDjBO6h+7iozA96wlf4afwjPbN2O7/BmSACchQ1QsBSAY
         eIxZleAKK3blkRPX68m5b61IHnX2CnofahbVYhopt+kNyHT7kfQuVhwWNAabRDMMmfhW
         t8j80v6pWp0hGYnUJ7nEDa9DOVBX2Dq74yy9NjvDuZPIxoG6MTgPKpDOvKuo2WCJg9rz
         asY7HP/PV4JhksLG2wQXKRcQ9jPcOh3uUTagyaE0gls3Uinuu0RmvyVj+HddGKugWBSj
         XtPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZTF7zBV9BebekratF2JVorEYVbhlKTgdQ9m8AxTWHRk=;
        b=g0XwKuTEFbbzEI6/fV6FXlIUQx089qUS9hO7/xT1SV09Jxt8PA30yWn6fAXqAGW9hP
         cRBYcL2K7YbSkiqMn+Mry24hH2GY/jnRS7hElrvWTU6ViB4wwmTAzVY27aiWownzYUNJ
         DIsTOQ8GIdp19Q1Vb101A75Mm8Uw+POdvzeb7X43m55SLZeEYBDD4K8E1PIjMF4jxSnm
         99o0tEF2QXR1KNBlN7GneGJ1IMJjmbtLrVB9FHSrj5Pv6uvgCaB0Z2RTuhz0AeTrxOUc
         lz6CYICdlYdQ1yQZOsc9hcmxX8D6lySG16WVNv+wrTM+xUpTfMQWN1AaPJVuRP7dE14U
         dTHw==
X-Gm-Message-State: ACrzQf26JYkiubmP7nFtQkm8+hxFBHV/Nssm0bXLwm2WZDEtFlhQcadE
	30wuOsYdiKvM/v8jNKMFTYRL9Q==
X-Google-Smtp-Source: AMsMyM5ulA1kczG/5edhpphYQpzdwQVBPzle22DMXKS1AiAksaw+qNmqzhYbIHAV8riAiSrCetMPNw==
X-Received: by 2002:a17:902:8ecc:b0:188:5f4b:260e with SMTP id x12-20020a1709028ecc00b001885f4b260emr27873892plo.111.1667924750257;
        Tue, 08 Nov 2022 08:25:50 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ij22-20020a170902ab5600b0017f36638010sm7078822plb.276.2022.11.08.08.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 08:25:49 -0800 (PST)
Date: Tue, 8 Nov 2022 16:25:46 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, shuah@kernel.org, catalin.marinas@arm.com,
	andrew.jones@linux.dev, ajones@ventanamicro.com, bgardon@google.com,
	dmatlack@google.com, will@kernel.org, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, pbonzini@redhat.com, maz@kernel.org,
	peterx@redhat.com, oliver.upton@linux.dev, zhenyzha@redhat.com,
	shan.gavin@gmail.com
Subject: Re: [PATCH v9 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2qDCqFeL1vwqq3f@google.com>
References: <20221108041039.111145-1-gshan@redhat.com>
 <20221108041039.111145-4-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108041039.111145-4-gshan@redhat.com>
Message-ID: <20221108162546.mUpnhGM0xtn8As2KYel61BqOquC5r2IdzEdaoGmg1A8@z>

On Tue, Nov 08, 2022, Gavin Shan wrote:
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 800f9470e36b..228be1145cf3 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -33,6 +33,14 @@ config HAVE_KVM_DIRTY_RING_ACQ_REL
>         bool
>         select HAVE_KVM_DIRTY_RING
>  
> +# Only architectures that need to dirty memory outside of a vCPU
> +# context should select this, advertising to userspace the
> +# requirement to use a dirty bitmap in addition to the vCPU dirty
> +# ring.

The Kconfig does more than advertise a feature to userspace.

 # Allow enabling both the dirty bitmap and dirty ring.  Only architectures that
 # need to dirty memory outside of a vCPU context should select this.

> +config HAVE_KVM_DIRTY_RING_WITH_BITMAP

I think we should replace "HAVE" with "NEED".  Any architecture that supports the
dirty ring can easily support ring+bitmap, but based on the discussion from v5[*],
the comment above, and the fact that the bitmap will _never_ be used in the
proposed implementation because x86 will always have a vCPU, this Kconfig should
only be selected if the bitmap is needed to support migration.

[*] https://lore.kernel.org/all/Y0SxnoT5u7+1TCT+@google.com

> +	bool
> +	depends on HAVE_KVM_DIRTY_RING
> +
>  config HAVE_KVM_EVENTFD
>         bool
>         select EVENTFD
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index fecbb7d75ad2..f95cbcdd74ff 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -21,6 +21,18 @@ u32 kvm_dirty_ring_get_rsvd_entries(void)
>  	return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size();
>  }
>  
> +bool kvm_use_dirty_bitmap(struct kvm *kvm)
> +{
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	return !kvm->dirty_ring_size || kvm->dirty_ring_with_bitmap;
> +}
> +
> +bool __weak kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)

Rather than __weak, what about wrapping this with an #ifdef to effectively force
architectures to implement the override if they need ring+bitmap?  Given that the
bitmap will never be used if there's a running vCPU, selecting the Kconfig without
overriding this utility can't possibly be correct.

  #ifndef CONFIG_NEED_KVM_DIRTY_RING_WITH_BITMAP
  bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
  {
	return false;
  }
  #endif

> @@ -4588,6 +4608,29 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>  			return -EINVAL;
>  
>  		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
> +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP: {
> +		int r = -EINVAL;
> +
> +		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> +		    !kvm->dirty_ring_size)

I have no objection to disallowing userspace from disabling the combo, but I
think it's worth requiring cap->args[0] to be '0' just in case we change our minds
in the future.

> +			return r;
> +
> +		mutex_lock(&kvm->slots_lock);
> +
> +		/*
> +		 * For simplicity, allow enabling ring+bitmap if and only if
> +		 * there are no memslots, e.g. to ensure all memslots allocate
> +		 * a bitmap after the capability is enabled.
> +		 */
> +		if (kvm_are_all_memslots_empty(kvm)) {
> +			kvm->dirty_ring_with_bitmap = true;
> +			r = 0;
> +		}
> +
> +		mutex_unlock(&kvm->slots_lock);
> +
> +		return r;
> +	}
>  	default:
>  		return kvm_vm_ioctl_enable_cap(kvm, cap);
>  	}
> -- 
> 2.23.0
> 
