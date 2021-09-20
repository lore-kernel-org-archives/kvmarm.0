Return-Path: <SRS0=SY58=OK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34814C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 12:28:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A16460F58
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 12:28:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9A16460F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1206F4B0B3;
	Mon, 20 Sep 2021 08:28:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dJRhv3Ha20L5; Mon, 20 Sep 2021 08:28:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEEC14B0B4;
	Mon, 20 Sep 2021 08:28:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E047B4B089
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 08:28:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tt4KU0592Xbs for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Sep 2021 08:28:38 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0FC44ACC9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 08:28:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632140918;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=bbQ8h/wkBS10Efo8Um8TUhVatac0+20cWgk++bQq2ME=;
 b=UTNH7lvNmESK4ljGlSFUFOGM+eCvRooyeMqapeV67uMW5DR4nNtwWQD0g0cIIiH2CcTA0Q
 tVNk2fBWpt6hKMERpq+70HA7Al+PfvBzGdWgF/1ISVaHLIMrF3svpLTyxspn7CLFRuwFLX
 Rv3p0g92Y/zVcQVWW4GVwmNBiKyuSlY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-qs-Vbsu6Nx6ebCA_k0l3Tg-1; Mon, 20 Sep 2021 08:28:37 -0400
X-MC-Unique: qs-Vbsu6Nx6ebCA_k0l3Tg-1
Received: by mail-wr1-f72.google.com with SMTP id
 x7-20020a5d6507000000b0015dada209b1so5915378wru.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 05:28:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=bbQ8h/wkBS10Efo8Um8TUhVatac0+20cWgk++bQq2ME=;
 b=2B+l5kAUYdOCOQ7se/oDelNMcMEUT9/Fv5ZFTXfqrywoHwMq1WovcBZsil0p2KyTau
 KOTOCKx30Ya+LLkznYbZP9kqya0Va7k35gcR2TkRUxgw78+tRc5gHB4Ljc3MVtmXvPBt
 +TTrOsDx5NgYG1fDRRQL5gNPOw1MDkfpNC+/9nQrDnK41sUB82lAs69bzU8U6Po5vVBs
 cVP8j769PT+x9esB+ap/iNP7xn4kNp7kZBXIePDFia8dX7O+e6s3LPYrXDuZXlLKcuGF
 q9RoUomx7OkbERcXRZFFP7n8K7VnyLIujcS20bT5uCzr25Ot4YcpeLY8LNnnSSBz1QOC
 DkhA==
X-Gm-Message-State: AOAM5324t0i2BdgZluCtTyuP5UOu24kQ561E9hke6BMe40zIqu3Gsdp/
 73tGWXxwEJ9Dyo8uW3bAdVIV15DNUmdj4J9HjQREvYEG0mBuuQgv7H8VYmNRxxT7aXgrW6ZxYyv
 gLQBidw87N3r75BCrZdLH2PWl
X-Received: by 2002:a05:6000:14d:: with SMTP id
 r13mr28662742wrx.420.1632140916107; 
 Mon, 20 Sep 2021 05:28:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzOtn1g3FI6YAdIMt8FsZF+ei+aITEY4UXbrvUzTUEapa6XDjXm/kHFoQf2LfEEBBOLiZ3jw==
X-Received: by 2002:a05:6000:14d:: with SMTP id
 r13mr28662707wrx.420.1632140915903; 
 Mon, 20 Sep 2021 05:28:35 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id a75sm16193423wmd.4.2021.09.20.05.28.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Sep 2021 05:28:35 -0700 (PDT)
Date: Mon, 20 Sep 2021 14:28:33 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v8 9/9] selftests: KVM: Test vtimer offset reg in
 get-reg-list
Message-ID: <20210920122833.wlo7xj4ckq4upjch@gator>
References: <20210916181555.973085-1-oupton@google.com>
 <20210916181555.973085-10-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210916181555.973085-10-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On Thu, Sep 16, 2021 at 06:15:55PM +0000, Oliver Upton wrote:
> Assert that KVM exposes KVM_REG_ARM_TIMER_OFFSET in the KVM_GET_REG_LIST
> ioctl when userspace buys in to the new behavior.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../selftests/kvm/aarch64/get-reg-list.c      | 42 +++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index cc898181faab..4f337d8b793a 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -40,6 +40,7 @@ static __u64 *blessed_reg, blessed_n;
>  struct reg_sublist {
>  	const char *name;
>  	long capability;
> +	long enable_capability;

cap.cap is a __u32

>  	int feature;
>  	bool finalize;
>  	__u64 *regs;
> @@ -397,6 +398,19 @@ static void check_supported(struct vcpu_config *c)
>  	}
>  }
>  
> +static void enable_caps(struct kvm_vm *vm, struct vcpu_config *c)
> +{
> +	struct kvm_enable_cap cap = {0};
> +	struct reg_sublist *s;
> +
> +	for_each_sublist(c, s) {
> +		if (s->enable_capability) {
> +			cap.cap = s->enable_capability;
> +			vm_enable_cap(vm, &cap);
> +		}
> +	}
> +}
> +
>  static bool print_list;
>  static bool print_filtered;
>  static bool fixup_core_regs;
> @@ -412,6 +426,8 @@ static void run_test(struct vcpu_config *c)
>  	check_supported(c);
>  
>  	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> +	enable_caps(vm, c);
> +
>  	prepare_vcpu_init(c, &init);
>  	aarch64_vcpu_add_default(vm, 0, &init, NULL);
>  	finalize_vcpu(vm, 0, c);
> @@ -1014,6 +1030,10 @@ static __u64 sve_rejects_set[] = {
>  	KVM_REG_ARM64_SVE_VLS,
>  };
>  
> +static __u64 vtimer_offset_regs[] = {
> +	KVM_REG_ARM_TIMER_OFFSET,
> +};
> +
>  #define BASE_SUBLIST \
>  	{ "base", .regs = base_regs, .regs_n = ARRAY_SIZE(base_regs), }
>  #define VREGS_SUBLIST \
> @@ -1025,6 +1045,10 @@ static __u64 sve_rejects_set[] = {
>  	{ "sve", .capability = KVM_CAP_ARM_SVE, .feature = KVM_ARM_VCPU_SVE, .finalize = true, \
>  	  .regs = sve_regs, .regs_n = ARRAY_SIZE(sve_regs), \
>  	  .rejects_set = sve_rejects_set, .rejects_set_n = ARRAY_SIZE(sve_rejects_set), }
> +#define VTIMER_OFFSET_SUBLIST \
> +	{ "vtimer_offset", .capability = KVM_CAP_ARM_VTIMER_OFFSET, \
> +	  .enable_capability = KVM_CAP_ARM_VTIMER_OFFSET, .regs = vtimer_offset_regs, \
> +	  .regs_n = ARRAY_SIZE(vtimer_offset_regs), }
>  
>  static struct vcpu_config vregs_config = {
>  	.sublists = {
> @@ -1041,6 +1065,14 @@ static struct vcpu_config vregs_pmu_config = {
>  	{0},
>  	},
>  };
> +static struct vcpu_config vregs_vtimer_config = {
> +	.sublists = {
> +	BASE_SUBLIST,
> +	VREGS_SUBLIST,
> +	VTIMER_OFFSET_SUBLIST,
> +	{0},
> +	},
> +};
>  static struct vcpu_config sve_config = {
>  	.sublists = {
>  	BASE_SUBLIST,
> @@ -1056,11 +1088,21 @@ static struct vcpu_config sve_pmu_config = {
>  	{0},
>  	},
>  };
> +static struct vcpu_config sve_vtimer_config = {
> +	.sublists = {
> +	BASE_SUBLIST,
> +	SVE_SUBLIST,
> +	VTIMER_OFFSET_SUBLIST,
> +	{0},
> +	},
> +};
>  
>  static struct vcpu_config *vcpu_configs[] = {
>  	&vregs_config,
>  	&vregs_pmu_config,
> +	&vregs_vtimer_config,
>  	&sve_config,
>  	&sve_pmu_config,
> +	&sve_vtimer_config,
>  };
>  static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
> -- 
> 2.33.0.464.g1972c5931b-goog
>

Other than the enable_capability type nit

Reviewed-by: Andrew Jones <drjones@redhat.com>
 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
