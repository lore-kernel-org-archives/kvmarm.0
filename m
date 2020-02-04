Return-Path: <SRS0=8yD/=3Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E39C2D0B1
	for <kvmarm@archiver.kernel.org>; Tue,  4 Feb 2020 10:35:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E33220674
	for <kvmarm@archiver.kernel.org>; Tue,  4 Feb 2020 10:35:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gNRicseZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E33220674
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60C974A610;
	Tue,  4 Feb 2020 05:35:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yqKlGtznjkRn; Tue,  4 Feb 2020 05:34:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DB174A535;
	Tue,  4 Feb 2020 05:34:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AE854A4FC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Feb 2020 05:34:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ml64UADTgViD for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Feb 2020 05:34:57 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C104A49F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Feb 2020 05:34:57 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580812496;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=N2ppv8VdQFYEFb3YbQEdr4SJtjIEKEg19DLBErWYPcY=;
 b=gNRicseZ0BtdEdDZOKj6sgX/5PJsM3ulQpVW/w/kPq75A5u3EGi7WqGvBZJ8KTOjU8dYIe
 sh2Ng5vP29seEVCdIsJmu8jumZ9GRWcTuCrvoBF8z9HrGvhOPagbKXM27LVSj8HdNTQWlF
 FebKOTufV8TT4XP38ADkmz5eadRj0mU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-Z-AHNODQMpS_xR1azR6Erw-1; Tue, 04 Feb 2020 05:34:52 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 443E9801A1F;
 Tue,  4 Feb 2020 10:34:51 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A9DD8068E;
 Tue,  4 Feb 2020 10:34:49 +0000 (UTC)
Date: Tue, 4 Feb 2020 11:34:47 +0100
From: Andrew Jones <drjones@redhat.com>
To: Beata Michalska <beata.michalska@linaro.org>
Subject: Re: [PATCH v2 1/2] target/arm: kvm: Inject events at the last stage
 of sync
Message-ID: <20200204103447.naw26xl2y2zbyrqb@kamzik.brq.redhat.com>
References: <20200129202441.12745-1-beata.michalska@linaro.org>
 <20200129202441.12745-2-beata.michalska@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20200129202441.12745-2-beata.michalska@linaro.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: Z-AHNODQMpS_xR1azR6Erw-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com,
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

On Wed, Jan 29, 2020 at 08:24:40PM +0000, Beata Michalska wrote:
> KVM_SET_VCPU_EVENTS might actually lead to vcpu registers being modified.
> As such this should be the last step of sync to avoid potential overwriting
> of whatever changes KVM might have done.
> 
> Signed-off-by: Beata Michalska <beata.michalska@linaro.org>
> ---
>  target/arm/kvm32.c | 20 ++++++++++----------
>  target/arm/kvm64.c | 20 ++++++++++----------
>  2 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/target/arm/kvm32.c b/target/arm/kvm32.c
> index 32bf8d6..cf2b47f 100644
> --- a/target/arm/kvm32.c
> +++ b/target/arm/kvm32.c
> @@ -386,17 +386,17 @@ int kvm_arch_put_registers(CPUState *cs, int level)
>          return ret;
>      }
>  
> -    ret = kvm_put_vcpu_events(cpu);
> -    if (ret) {
> -        return ret;
> -    }
> -
>      write_cpustate_to_list(cpu, true);
>  
>      if (!write_list_to_kvmstate(cpu, level)) {
>          return EINVAL;
>      }
>  
> +    ret = kvm_put_vcpu_events(cpu);
> +    if (ret) {
> +        return ret;
> +    }
> +

I think we should put a comment above this that says basically the same
thing as the commit message in order to explain why kvm_put_vcpu_events()
*must* be after write_list_to_kvmstate().

>      kvm_arm_sync_mpstate_to_kvm(cpu);
>  
>      return ret;
> @@ -462,11 +462,6 @@ int kvm_arch_get_registers(CPUState *cs)
>      }
>      vfp_set_fpscr(env, fpscr);
>  
> -    ret = kvm_get_vcpu_events(cpu);
> -    if (ret) {
> -        return ret;
> -    }
> -
>      if (!write_kvmstate_to_list(cpu)) {
>          return EINVAL;
>      }
> @@ -475,6 +470,11 @@ int kvm_arch_get_registers(CPUState *cs)
>       */
>      write_list_to_cpustate(cpu);
>  
> +    ret = kvm_get_vcpu_events(cpu);
> +    if (ret) {
> +        return ret;
> +    }
> +

Why are we moving kvm_get_vcpu_events()?

>      kvm_arm_sync_mpstate_to_qemu(cpu);
>  
>      return 0;
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index 6344113..d06fd32 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -1043,17 +1043,17 @@ int kvm_arch_put_registers(CPUState *cs, int level)
>          return ret;
>      }
>  
> -    ret = kvm_put_vcpu_events(cpu);
> -    if (ret) {
> -        return ret;
> -    }
> -
>      write_cpustate_to_list(cpu, true);
>  
>      if (!write_list_to_kvmstate(cpu, level)) {
>          return -EINVAL;
>      }
>  
> +    ret = kvm_put_vcpu_events(cpu);
> +    if (ret) {
> +        return ret;
> +    }
> +
>      kvm_arm_sync_mpstate_to_kvm(cpu);
>  
>      return ret;
> @@ -1251,11 +1251,6 @@ int kvm_arch_get_registers(CPUState *cs)
>      }
>      vfp_set_fpcr(env, fpr);
>  
> -    ret = kvm_get_vcpu_events(cpu);
> -    if (ret) {
> -        return ret;
> -    }
> -
>      if (!write_kvmstate_to_list(cpu)) {
>          return -EINVAL;
>      }
> @@ -1264,6 +1259,11 @@ int kvm_arch_get_registers(CPUState *cs)
>       */
>      write_list_to_cpustate(cpu);
>  
> +    ret = kvm_get_vcpu_events(cpu);
> +    if (ret) {
> +        return ret;
> +    }
> +
>      kvm_arm_sync_mpstate_to_qemu(cpu);
>  
>      /* TODO: other registers */
> -- 
> 2.7.4
> 
> 

Same comments for kvm64.c as for kvm32.c

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
