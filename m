Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 967E3C28CF5
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 15:22:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FEFB49ED2;
	Wed, 26 Jan 2022 10:22:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m2q7e35AKFc8; Wed, 26 Jan 2022 10:22:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDD1049ECA;
	Wed, 26 Jan 2022 10:22:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDB2249E48
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:22:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t8kAc-XpkcIA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 10:22:09 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DA6549E3F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:22:09 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1643210529;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=WorBIKC9lbjfBDxKzo5pw1nKB30ZfGuREFtFDBIcBws=;
 b=ipAIDgOQjqw93FPmdNDf5vUiuBPlIye8LkKUwTbYs7RJy+IffNps2lR36K/WulmSnEJ9PE
 LgIp7wmI3/MuVnFEuLa6ACxKNSXkeScMogKJbZPePqE2BE5SyNQ83I7p3zFJGLz7hwC++Q
 mkb56qzKvsfZ4MMATwHg/3VFIrFBUaw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-li54eMPwPCmB8OfxaAZOBg-1; Wed, 26 Jan 2022 10:22:08 -0500
X-MC-Unique: li54eMPwPCmB8OfxaAZOBg-1
Received: by mail-ed1-f72.google.com with SMTP id
 w23-20020a50d797000000b00406d33c039dso9347603edi.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 07:22:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=WorBIKC9lbjfBDxKzo5pw1nKB30ZfGuREFtFDBIcBws=;
 b=NPG7t7vYzFrtPcOYyxEXYKVgCM8fePcH8nc6BDyUWqtcOYv3tAdLZ2owbYro8FAUBD
 M/Bod3RxDmYZ1KnDxKUbj5/JZnfwjTUgoxGWxC8x5bDe+8RWuqRN+4q8/IIq1GWbHWe3
 ziTx9i+mBeOIMyfXIFCvOFZul8Cp8iZrw792Pl4l0n4Fwb7eFGjPH7kY0hH8ChKzBlj1
 nlOHgxiEU6mD/1kXXANcyGGiJm/7+82T/AUJdxYrVtNhvK83kAvouW52lVApiw4dw8Z3
 LWcxsLb7SKaeGqu8dQflneg88vZrFprx3AvoN1AJ5P/foX62sX3bym/CmWlajcq4PBh/
 7+Sw==
X-Gm-Message-State: AOAM531LYkSODBBTH2E4CiRfQbk+IVUYPKhmwQiloZ07OMOWhMN5MEv5
 kDXP8xfxNuV0CVrI0DZR8r9ptmcMTB3xP5/B/kPw7Md1nB0Q9WpL/hkEF898O6F41VayiAfGWny
 K0uc1621J8qaEN76u1Cj4dnpc
X-Received: by 2002:a05:6402:34c2:: with SMTP id
 w2mr2805049edc.379.1643210526701; 
 Wed, 26 Jan 2022 07:22:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxElOvsv8SJJ1nwCkSv9koLh7Vv7cG+uKfk4D2lsBvzTfU/yP2njfAlCEweOvhK86Gp/TzgFg==
X-Received: by 2002:a05:6402:34c2:: with SMTP id
 w2mr2805032edc.379.1643210526511; 
 Wed, 26 Jan 2022 07:22:06 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id y5sm10023734edw.45.2022.01.26.07.22.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 26 Jan 2022 07:22:05 -0800 (PST)
Date: Wed, 26 Jan 2022 16:22:03 +0100
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 2/2] kvm: selftests: aarch64: fix some vgic related
 comments
Message-ID: <20220126152203.6bxqpqw2ld5r6eog@gator>
References: <20220120173905.1047015-1-ricarkol@google.com>
 <20220120173905.1047015-3-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20220120173905.1047015-3-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu
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

On Thu, Jan 20, 2022 at 09:39:05AM -0800, Ricardo Koller wrote:
> Fix the formatting of some comments and the wording of one of them (in
> gicv3_access_reg).
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Cc: Andrew Jones <drjones@redhat.com>
> ---
>  tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 12 ++++++++----
>  tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 11 +++++++----
>  tools/testing/selftests/kvm/lib/aarch64/vgic.c   |  3 ++-
>  3 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> index e6c7d7f8fbd1..258bb5150a07 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> @@ -306,7 +306,8 @@ static void guest_restore_active(struct test_args *args,
>  	uint32_t prio, intid, ap1r;
>  	int i;
>  
> -	/* Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
> +	/*
> +	 * Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
>  	 * in descending order, so intid+1 can preempt intid.
>  	 */
>  	for (i = 0, prio = (num - 1) * 8; i < num; i++, prio -= 8) {
> @@ -315,7 +316,8 @@ static void guest_restore_active(struct test_args *args,
>  		gic_set_priority(intid, prio);
>  	}
>  
> -	/* In a real migration, KVM would restore all GIC state before running
> +	/*
> +	 * In a real migration, KVM would restore all GIC state before running
>  	 * guest code.
>  	 */
>  	for (i = 0; i < num; i++) {
> @@ -503,7 +505,8 @@ static void guest_code(struct test_args args)
>  		test_injection_failure(&args, f);
>  	}
>  
> -	/* Restore the active state of IRQs. This would happen when live
> +	/*
> +	 * Restore the active state of IRQs. This would happen when live
>  	 * migrating IRQs in the middle of being handled.
>  	 */
>  	for_each_supported_activate_fn(&args, set_active_fns, f)
> @@ -837,7 +840,8 @@ int main(int argc, char **argv)
>  		}
>  	}
>  
> -	/* If the user just specified nr_irqs and/or gic_version, then run all
> +	/*
> +	 * If the user just specified nr_irqs and/or gic_version, then run all
>  	 * combinations.
>  	 */
>  	if (default_args) {
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> index e4945fe66620..93fc35b88410 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> @@ -19,7 +19,7 @@ struct gicv3_data {
>  	unsigned int nr_spis;
>  };
>  
> -#define sgi_base_from_redist(redist_base) 	(redist_base + SZ_64K)
> +#define sgi_base_from_redist(redist_base)	(redist_base + SZ_64K)
>  #define DIST_BIT				(1U << 31)
>  
>  enum gicv3_intid_range {
> @@ -105,7 +105,8 @@ static void gicv3_set_eoi_split(bool split)
>  {
>  	uint32_t val;
>  
> -	/* All other fields are read-only, so no need to read CTLR first. In
> +	/*
> +	 * All other fields are read-only, so no need to read CTLR first. In
>  	 * fact, the kernel does the same.
>  	 */
>  	val = split ? (1U << 1) : 0;
> @@ -160,8 +161,10 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
>  
>  	GUEST_ASSERT(bits_per_field <= reg_bits);
>  	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
> -	/* Some registers like IROUTER are 64 bit long. Those are currently not
> -	 * supported by readl nor writel, so just asserting here until then.
> +	/*
> +	 * This function does not support 64 bit accesses as those are
> +	 * currently not supported by readl nor writel, so just asserting here
> +	 * until then.

Well, readl and writel will never support 64 bit accesses. We'd need to
implement readq and writeq for that. If we're going to rewrite this
comment please state it that way instead.

>  	 */
>  	GUEST_ASSERT(reg_bits == 32);
>  
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> index b3a0fca0d780..79864b941617 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> @@ -150,7 +150,8 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
>  		attr += SZ_64K;
>  	}
>  
> -	/* All calls will succeed, even with invalid intid's, as long as the
> +	/*
> +	 * All calls will succeed, even with invalid intid's, as long as the
>  	 * addr part of the attr is within 32 bits (checked above). An invalid
>  	 * intid will just make the read/writes point to above the intended
>  	 * register space (i.e., ICPENDR after ISPENDR).
> -- 
> 2.35.0.rc0.227.g00780c9af4-goog
>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
