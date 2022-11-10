Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C6E1C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 16:46:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F7934BAF0;
	Thu, 10 Nov 2022 11:46:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tp6CFh4iB6wi; Thu, 10 Nov 2022 11:46:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 075A44BAE3;
	Thu, 10 Nov 2022 11:46:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84AFB4BAE2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 11:46:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NNVCdDThnRgX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2022 11:46:28 -0500 (EST)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
 [209.85.215.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6833C4BAC2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 11:46:28 -0500 (EST)
Received: by mail-pg1-f171.google.com with SMTP id h193so2332907pgc.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 08:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=a539VitztAG3TKQr5dsSfcto7Kn2fUnZnm78m05er/Er1uTjSDSpJo0GayGn088VlN
 4E5gAa8RjySryniBKbX2Fmm4tHkIJEeC8t48nx+PVBnIDDa/wqJohwhm/CVNBMfqLqRW
 wWPMxj6/JEjwwhRhqZ0qP/tzBvjIemxXnGnNewBhVdJQ5ohTf4JDjwL5nmuiBUbxSGkb
 sbpBb2Q5LDhJ5uOe0TYrGv5/e28yE+3KbgTYPIn3EmOowI4NKueCLmEjLxg11Pl8eKN3
 0uvtae1o1H3xThX04xIMgVtDNMmcecuPmjwl+lz05o1CvWDa33fiMaeyrrET80BLoyzm
 Rc/g==
X-Gm-Message-State: ACrzQf1by0YGZLOVVNers7r2t8eaSiVA/tVpvqNy4hdRewwE3Vp5OnOt
 XDopxJWznz8oDxEqWGpN0HLIXg==
X-Google-Smtp-Source: AMsMyM4andjMtozNDHwKUR79MwOWnsANiX8BxagW4L0ABg19mJtlpxm75HvZvM5ap551d+EVBvWSSQ==
X-Received: by 2002:a05:6a00:1626:b0:56b:b253:36da with SMTP id
 e6-20020a056a00162600b0056bb25336damr2997325pfc.59.1668098787148; 
 Thu, 10 Nov 2022 08:46:27 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 f143-20020a623895000000b0056b6d31ac8asm10722598pfa.178.2022.11.10.08.46.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 10 Nov 2022 08:46:26 -0800 (PST)
Date: Thu, 10 Nov 2022 16:46:22 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v10 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y20q3lq5oc2gAqr+@google.com>
References: <20221110104914.31280-1-gshan@redhat.com>
 <20221110104914.31280-4-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221110104914.31280-4-gshan@redhat.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, dmatlack@google.com, will@kernel.org,
 shan.gavin@gmail.com, catalin.marinas@arm.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
