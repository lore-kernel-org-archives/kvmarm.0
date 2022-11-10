Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C2A107A2
	for <kvmarm@lists.linux.dev>; Thu, 10 Nov 2022 16:46:27 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id v28so2673363pfi.12
        for <kvmarm@lists.linux.dev>; Thu, 10 Nov 2022 08:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cf15YvEbXrX092vFJYldq4iJgRxE5PH6mXEH53N3kFk=;
        b=IsXiakdp55hdcajmv6iMD32S0ndyQYKGif2RAiKMX+z9xjzgJBJ+pyjfpGyokoqjj2
         EYAF2TXzIw5l4VUGpg6GmJPj7bwMPP3vm7S2O+W3Xl0sKWTStrjqwYjGIS72rvJU8SpV
         DDzEOXTSEkQalMP5UsSSBKvVgdVmXGQM1pjVc0KvpHKI4kSFHBMV+zVzi2CDXbWx7/9K
         bRHBcUL9yc08F/zfcVyqHdogZfWuLjW56HNKVVrrWeBT/psPWkKBxbjzY25p/pxD8J21
         DQ3ctBKRKGiqTZ/7QOSfqR834j5LzCO3d+XslE/1S8Utq1e6hsU7azBEmgCpYVDpebEy
         FYAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cf15YvEbXrX092vFJYldq4iJgRxE5PH6mXEH53N3kFk=;
        b=OQSCJeI44Fti08QyQIHAT23prQV51o91r/08qzxh6xcG3VkY3/0cpHV0FU3d2nFOv/
         TkSpbNJnehH4Nr89RjcAbeVEVc40mgQwUrrM4B4LRSgajZWE72bey+0rpyLVswOlbHlR
         w9NIHW5UprZYybLsMkPl7o100YdtUg+ZHPWhwOOz8npNNxLgx1HvnBYOwa5SjRX7BuKI
         4a/a+GbAt0c1u2C/FpMj+iaJenMKXZbPxEB1x8zVQe4fQirliIlsI/lU4QiGDe2QZuiP
         L7Nty3rMvxdanYNIjeF6OF6oBf6ASa8M8llqMU5mU1D+XkTdVr2B03mqJlOULyPAwtej
         tPxA==
X-Gm-Message-State: ACrzQf0OjK/l2M1XM5yPYOHjiItI4mBIz5iIwM9nl9C5Sr4MIMKAinGW
	uET+uQ9fWxE+J7PuWrAwm9XVKA==
X-Google-Smtp-Source: AMsMyM4andjMtozNDHwKUR79MwOWnsANiX8BxagW4L0ABg19mJtlpxm75HvZvM5ap551d+EVBvWSSQ==
X-Received: by 2002:a05:6a00:1626:b0:56b:b253:36da with SMTP id e6-20020a056a00162600b0056bb25336damr2997325pfc.59.1668098787148;
        Thu, 10 Nov 2022 08:46:27 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f143-20020a623895000000b0056b6d31ac8asm10722598pfa.178.2022.11.10.08.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 08:46:26 -0800 (PST)
Date: Thu, 10 Nov 2022 16:46:22 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, maz@kernel.org, shuah@kernel.org,
	catalin.marinas@arm.com, andrew.jones@linux.dev,
	ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
	will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
	pbonzini@redhat.com, peterx@redhat.com, oliver.upton@linux.dev,
	zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v10 3/7] KVM: Support dirty ring in conjunction with
 bitmap
Message-ID: <Y20q3lq5oc2gAqr+@google.com>
References: <20221110104914.31280-1-gshan@redhat.com>
 <20221110104914.31280-4-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110104914.31280-4-gshan@redhat.com>
Message-ID: <20221110164622.GlznfuCCztmEc4Ok4xWcngyAdwaxeWKotmWdXyFSEI0@z>

On Thu, Nov 10, 2022, Gavin Shan wrote:
> @@ -3305,7 +3305,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>  	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>  
>  #ifdef CONFIG_HAVE_KVM_DIRTY_RING
> -	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
> +	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
> +		return;
> +
> +	if (WARN_ON_ONCE(!kvm_arch_allow_write_without_running_vcpu(kvm) && !vcpu))

Nit, the !vcpu check should come first.  99.9% of the time @vcpu will be non-NULL,
in which case the call to kvm_arch_allow_write_without_running_vcpu() can be
avoided.  And checking for !vcpu should also be cheaper than said call.

Since the below code is gaining a check on "vcpu" when using the dirty ring, and
needs to gain a check on memslot->dirty_bitmap, I think it makes sense to let KVM
continue on instead of bailing.  I.e. fill the dirty bitmap if possible instead
of dropping the dirty info and potentiall corrupting guest memory.

The "vcpu->kvm != kvm" check is different; if that fails, KVM would potentially
log the dirty page into the wrong VM's context, which could be fatal to one or
both VMs.

If it's not too late to rewrite history, this could even be done as a prep patch,
e.g. with a changelog explaning that KVM should try to log to the dirty bitmap
even if KVM has a bug where a write to guest memory was triggered without a running
vCPU.

---
 virt/kvm/kvm_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 43bbe4fde078..b1115bbd6038 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3313,18 +3313,20 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 #ifdef CONFIG_HAVE_KVM_DIRTY_RING
-	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
+	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
 		return;
+
+	WARN_ON_ONCE(!vcpu);
 #endif
 
 	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-		if (kvm->dirty_ring_size)
+		if (kvm->dirty_ring_size && vcpu)
 			kvm_dirty_ring_push(&vcpu->dirty_ring,
 					    slot, rel_gfn);
-		else
+		else if (memslot->dirty_bitmap)
 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }

base-commit: 01b4689ee519329ce5f50ae02692e8acdaba0beb
-- 



>  		return;
>  #endif
>  
> @@ -3313,7 +3316,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>  		unsigned long rel_gfn = gfn - memslot->base_gfn;
>  		u32 slot = (memslot->as_id << 16) | memslot->id;
>  
> -		if (kvm->dirty_ring_size)
> +		if (kvm->dirty_ring_size && vcpu)
>  			kvm_dirty_ring_push(vcpu, slot, rel_gfn);
>  		else
>  			set_bit_le(rel_gfn, memslot->dirty_bitmap);

Not checking memslot->dirty_bitmap will allow a malicious userspace to induce a
NULL pointer dereference, e.g. enable dirty ring without the bitmap and save the
ITS tables.  The KVM_DEV_ARM_ITS_SAVE_TABLES path in patch 4 doesn't check that
kvm_use_dirty_bitmap() is true.

If requiring kvm_use_dirty_bitmap() to do KVM_DEV_ARM_ITS_SAVE_TABLES is deemed
to prescriptive, the best this code can do is:

		if (kvm->dirty_ring_size && vcpu)
			kvm_dirty_ring_push(&vcpu->dirty_ring,
					    slot, rel_gfn);
		else if (memslot->dirty_bitmap)
			set_bit_le(rel_gfn, memslot->dirty_bitmap);

If ARM rejects KVM_DEV_ARM_ITS_SAVE_TABLES, then this can be:

		if (kvm->dirty_ring_size && vcpu)
			kvm_dirty_ring_push(&vcpu->dirty_ring,
					    slot, rel_gfn);
		else if (!WARN_ON_ONCE(!memslot->dirty_bitmap))
			set_bit_le(rel_gfn, memslot->dirty_bitmap);
