Return-Path: <SRS0=ff4l=6N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53CAC83006
	for <kvmarm@archiver.kernel.org>; Wed, 29 Apr 2020 16:58:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E07A208FE
	for <kvmarm@archiver.kernel.org>; Wed, 29 Apr 2020 16:58:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fuujgmR5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E07A208FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 384EF4B1E2;
	Wed, 29 Apr 2020 12:58:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DzgNbJhq2mvU; Wed, 29 Apr 2020 12:58:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7A7D4B3DB;
	Wed, 29 Apr 2020 12:58:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E89644B360
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2020 08:23:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DBk+NP2Hcq4V for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Apr 2020 08:23:50 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 925624B34E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2020 08:23:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1588163030;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=f73XFclQGMI95HoTU649yPccrfl6BgMf60JAuz7AmbU=;
 b=fuujgmR5ob2u7VwkF5yr0BeWbm3SaQ0BmMHX5j/5WckyPOlC9NNPqbN4aBnX+mrtycYc2U
 U1IKI3cU/nrTDSMfmuj2L9dNLpk7qMeOgptZTTGAMDu4qw83r83zI8Wdk1kwIXfed2xnH2
 b0EP/J/O8yEBVgs67VMD590UYzJEmYs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-SbhVv0A7NfO1l_pC9qOfvA-1; Wed, 29 Apr 2020 08:23:47 -0400
X-MC-Unique: SbhVv0A7NfO1l_pC9qOfvA-1
Received: by mail-wr1-f71.google.com with SMTP id g7so1615955wrw.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2020 05:23:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
 :message-id:mime-version;
 bh=P8pgV6uMHzNDOfpWIiJdoKMsBBSJGFZq++Qsl0KZjhI=;
 b=r1tzfnwZoT+vSXxgTUrl5c/FRYGICvLbi3g0gn+tSyZFbLBgbOfjdS7RIQrHhW3d3f
 O7cdqH7mzvCg1H4s1zY183MwHNSXOCltBiZbr2hA2rpBiK5PyGXooK7hpPBY3jYBCyNH
 Mva+Iqawi3Orum2vB+JuAnhk6HAr+/S9eiprKYOMZIPSms4M3ai1XHYStRC7mWoAr/rL
 Ilb1g7J9iO4bF8d3hZe4RGj4GYl7HEcYtSO4yWvtdA4ORd8mtERdf2JrIeHc2xcjL05H
 9tCiFN8DJ9P07JQDRJn3WTPp26EAjQ2eS4X7D2ghL4IiTBPjaXPlz2NifHoSKt/Go8Z8
 gjUw==
X-Gm-Message-State: AGi0PuYDWrAGGYBQFBY0WBpBGqrxq/kL04GuOXSUcjZ1h/SX7efSuQJ+
 6unurZ9AszbbHrJgS9OJFNI0MCb+uFi7il0zibozRGKJy+gbjgu4Rr6fgXjUquqtv47w3SJLgMu
 5PnUjXL4B7HEyM7T5igmw0UI/
X-Received: by 2002:a1c:8106:: with SMTP id c6mr2999796wmd.88.1588163026245;
 Wed, 29 Apr 2020 05:23:46 -0700 (PDT)
X-Google-Smtp-Source: APiQypLEQN/fKbOj2PpKvd2yk8qFu2uTYg65caL+qOuUZqYZNmiqKNZUNV+CX/Wun7VWjygdbXHKLA==
X-Received: by 2002:a1c:8106:: with SMTP id c6mr2999734wmd.88.1588163025929;
 Wed, 29 Apr 2020 05:23:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
 by smtp.gmail.com with ESMTPSA id n6sm32160645wrs.81.2020.04.29.05.23.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Apr 2020 05:23:45 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: Re: [PATCH v4 3/7] KVM: PPC: Remove redundant kvm_run from vcpu_arch
In-Reply-To: <20200427043514.16144-4-tianjia.zhang@linux.alibaba.com>
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <20200427043514.16144-4-tianjia.zhang@linux.alibaba.com>
Date: Wed, 29 Apr 2020 14:23:42 +0200
Message-ID: <87lfmeh44x.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Wed, 29 Apr 2020 12:58:34 -0400
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, david@redhat.com,
 benh@kernel.crashing.org, heiko.carstens@de.ibm.com,
 linux-kernel@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 frankja@linux.ibm.com, chenhuacai@gmail.com, mpe@ellerman.id.au,
 joro@8bytes.org, x86@kernel.org, borntraeger@de.ibm.com, mingo@redhat.com,
 thuth@redhat.com, gor@linux.ibm.com, kvm-ppc@vger.kernel.org, bp@alien8.de,
 tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, jmattson@google.com,
 tsbogend@alpha.franken.de, tianjia.zhang@linux.alibaba.com, cohuck@redhat.com,
 linux-mips@vger.kernel.org, sean.j.christopherson@intel.com, maz@kernel.org,
 pbonzini@redhat.com, linuxppc-dev@lists.ozlabs.org
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

Tianjia Zhang <tianjia.zhang@linux.alibaba.com> writes:

> The 'kvm_run' field already exists in the 'vcpu' structure, which
> is the same structure as the 'kvm_run' in the 'vcpu_arch' and
> should be deleted.
>
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  arch/powerpc/include/asm/kvm_host.h | 1 -
>  arch/powerpc/kvm/book3s_hv.c        | 6 ++----
>  arch/powerpc/kvm/book3s_hv_nested.c | 3 +--
>  3 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 1dc63101ffe1..2745ff8faa01 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -795,7 +795,6 @@ struct kvm_vcpu_arch {
>  	struct mmio_hpte_cache_entry *pgfault_cache;
>  
>  	struct task_struct *run_task;
> -	struct kvm_run *kvm_run;
>  
>  	spinlock_t vpa_update_lock;
>  	struct kvmppc_vpa vpa;
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 93493f0cbfe8..413ea2dcb10c 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -2934,7 +2934,7 @@ static void post_guest_process(struct kvmppc_vcore *vc, bool is_master)
>  
>  		ret = RESUME_GUEST;
>  		if (vcpu->arch.trap)
> -			ret = kvmppc_handle_exit_hv(vcpu->arch.kvm_run, vcpu,
> +			ret = kvmppc_handle_exit_hv(vcpu->run, vcpu,
>  						    vcpu->arch.run_task);
>  
>  		vcpu->arch.ret = ret;
> @@ -3920,7 +3920,6 @@ static int kvmppc_run_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
>  	spin_lock(&vc->lock);
>  	vcpu->arch.ceded = 0;
>  	vcpu->arch.run_task = current;
> -	vcpu->arch.kvm_run = kvm_run;
>  	vcpu->arch.stolen_logged = vcore_stolen_time(vc, mftb());
>  	vcpu->arch.state = KVMPPC_VCPU_RUNNABLE;
>  	vcpu->arch.busy_preempt = TB_NIL;
> @@ -3973,7 +3972,7 @@ static int kvmppc_run_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
>  			if (signal_pending(v->arch.run_task)) {
>  				kvmppc_remove_runnable(vc, v);
>  				v->stat.signal_exits++;
> -				v->arch.kvm_run->exit_reason = KVM_EXIT_INTR;
> +				v->run->exit_reason = KVM_EXIT_INTR;
>  				v->arch.ret = -EINTR;
>  				wake_up(&v->arch.cpu_run);
>  			}
> @@ -4049,7 +4048,6 @@ int kvmhv_run_single_vcpu(struct kvm_run *kvm_run,
>  	vc = vcpu->arch.vcore;
>  	vcpu->arch.ceded = 0;
>  	vcpu->arch.run_task = current;
> -	vcpu->arch.kvm_run = kvm_run;
>  	vcpu->arch.stolen_logged = vcore_stolen_time(vc, mftb());
>  	vcpu->arch.state = KVMPPC_VCPU_RUNNABLE;
>  	vcpu->arch.busy_preempt = TB_NIL;
> diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
> index dc97e5be76f6..5a3987f3ebf3 100644
> --- a/arch/powerpc/kvm/book3s_hv_nested.c
> +++ b/arch/powerpc/kvm/book3s_hv_nested.c
> @@ -290,8 +290,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>  			r = RESUME_HOST;
>  			break;
>  		}
> -		r = kvmhv_run_single_vcpu(vcpu->arch.kvm_run, vcpu, hdec_exp,
> -					  lpcr);
> +		r = kvmhv_run_single_vcpu(vcpu->run, vcpu, hdec_exp, lpcr);
>  	} while (is_kvmppc_resume_guest(r));
>  
>  	/* save L2 state for return */

FWIW,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
