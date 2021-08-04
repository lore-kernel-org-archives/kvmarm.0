Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35467C4338F
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 09:23:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A1EE460FC4
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 09:23:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A1EE460FC4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D60B49E93;
	Wed,  4 Aug 2021 05:23:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jbS+wKV7aBil; Wed,  4 Aug 2021 05:23:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D83E49F82;
	Wed,  4 Aug 2021 05:23:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9008340CF9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 05:23:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3g02kaE8vlVa for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 05:23:17 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F15C64086C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 05:23:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628068996;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=UkRs2HbzdB4h7mTj8+qY8hBZF+eBXTP8p+8ea8LWKp8=;
 b=FWER3PUiYLJeyKlt+stoEJAsT93ZblfwBdX6ZSWC3WZ5TiqOX/looeyccUmR2tdvbzpecD
 fymCUoMjIZTwmW9VgMVsJ+5GzErKiTkEYjYSCMVia1Pe40/cuohTcxb/qAnIMjRTiewiFC
 BBQv6KU9+yvYF/QhvrnQtCPk4E4Uaek=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-DDmba-ryO2S0jicKPZ3CCg-1; Wed, 04 Aug 2021 05:23:15 -0400
X-MC-Unique: DDmba-ryO2S0jicKPZ3CCg-1
Received: by mail-ej1-f69.google.com with SMTP id
 nb40-20020a1709071ca8b02905992266c319so600528ejc.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 02:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=UkRs2HbzdB4h7mTj8+qY8hBZF+eBXTP8p+8ea8LWKp8=;
 b=my97dJHsO0sgj71FrGn8nzfGvhwqLY5pQnAEwC/940/Cdb4+ULeeCsFm+Pstc/A0Du
 iUUTLp4li3xm36mm/zdrHM7GAW8qNPUiWgIhjUJlbhrKignGNVP7fsOQ6O5L53vxMvig
 Z7c0M8ICHBb4h3lD14Gl9KbQGvjGzvjSda1EUWa0AfQCGgzrDzVJkYfmAMmuVCTqelWL
 2dqh63SozVmCXV9VSfPqS2xM1/dJxm33vyoIQxqHozgVILWQXu+5h3G7M0PgO2F+4nWq
 QjMZ0Z0hADWG6VSZB01p9flHKN0cqzvXL4hiZdOGwAPYkDHUngXDTS8qrdZbxbVTLyuf
 WGYQ==
X-Gm-Message-State: AOAM532utiETdPTWFp8IglvS0YRwyMPMb+W2s2ZDCsafoCs7dI1qPhNf
 XE58UBZ9xcOE3pFK37pMg+oFkkT3QkqrMnxArtOS8i9QLDykb66map45IY3v0fGpmW8IE2O1IZM
 h0R1MYH5rD1jN5JvonGFnZP+K
X-Received: by 2002:a50:a6d7:: with SMTP id f23mr31030955edc.164.1628068994391; 
 Wed, 04 Aug 2021 02:23:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxE6m2UYvltRQ8Pgjp26MJaVNK+xKyPnxyh9OKvCZbbQ2+R1157cJg4uGkivonAtdYooD+rvg==
X-Received: by 2002:a50:a6d7:: with SMTP id f23mr31030924edc.164.1628068994149; 
 Wed, 04 Aug 2021 02:23:14 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id i16sm706151edr.38.2021.08.04.02.23.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 04 Aug 2021 02:23:13 -0700 (PDT)
Date: Wed, 4 Aug 2021 11:23:11 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v6 11/21] KVM: arm64: Refactor update_vtimer_cntvoff()
Message-ID: <20210804092311.yhruuke6buiblrel@gator.home>
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-12-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210804085819.846610-12-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Wed, Aug 04, 2021 at 08:58:09AM +0000, Oliver Upton wrote:
> Make the implementation of update_vtimer_cntvoff() generic w.r.t. guest
> timer context and spin off into a new helper method for later use.
> Require callers of this new helper method to grab the kvm lock
> beforehand.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/arch_timer.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 3df67c127489..c0101db75ad4 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -747,22 +747,32 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -/* Make the updates of cntvoff for all vtimer contexts atomic */
> -static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
> +/* Make offset updates for all timer contexts atomic */
> +static void update_timer_offset(struct kvm_vcpu *vcpu,
> +				enum kvm_arch_timers timer, u64 offset)
>  {
>  	int i;
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_vcpu *tmp;
>  
> -	mutex_lock(&kvm->lock);
> +	lockdep_assert_held(&kvm->lock);
> +
>  	kvm_for_each_vcpu(i, tmp, kvm)
> -		timer_set_offset(vcpu_vtimer(tmp), cntvoff);
> +		timer_set_offset(vcpu_get_timer(tmp, timer), offset);
>  
>  	/*
>  	 * When called from the vcpu create path, the CPU being created is not
>  	 * included in the loop above, so we just set it here as well.
>  	 */
> -	timer_set_offset(vcpu_vtimer(vcpu), cntvoff);
> +	timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
> +}
> +
> +static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	mutex_lock(&kvm->lock);
> +	update_timer_offset(vcpu, TIMER_VTIMER, cntvoff);
>  	mutex_unlock(&kvm->lock);
>  }
>  
> -- 
> 2.32.0.605.g8dce9f2422-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
