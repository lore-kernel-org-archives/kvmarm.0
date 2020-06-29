Return-Path: <SRS0=R6td=AK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC9DFC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 08:15:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B9102085B
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 08:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D93GV8OQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B9102085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A546F4B3DA;
	Mon, 29 Jun 2020 04:15:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OGNcd5h0zPAD; Mon, 29 Jun 2020 04:15:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 237BA4B3D5;
	Mon, 29 Jun 2020 04:15:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95E8F4B3D2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 04:15:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 39BrvIj2rWkR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2020 04:15:33 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A99FA4B3D1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 04:15:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593418533;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=YeWPv4LwNFbOE8U+vD3kd+cE46oiG3QsCgfJx5ZNa3E=;
 b=D93GV8OQb1Kr31ANLLsvW8u8GrlEI2Wv3qOoviipMRDeUb4wHxarJF8WmnS3HEy+L80b7t
 ydyoWXD7wDHBWHRNCbE1sPMlBbEkhQrWhT/PS6Ne+UtPLNoDTWzutS6Py5IAaBeIkQAy2s
 9XuTockkEor9V94fvfXT48i9wgTXgiY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-T--9kbTgNmax7a29LikzDQ-1; Mon, 29 Jun 2020 04:15:17 -0400
X-MC-Unique: T--9kbTgNmax7a29LikzDQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8C90A0BDA;
 Mon, 29 Jun 2020 08:15:15 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.151])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B702D10016EB;
 Mon, 29 Jun 2020 08:15:13 +0000 (UTC)
Date: Mon, 29 Jun 2020 10:15:10 +0200
From: Andrew Jones <drjones@redhat.com>
To: Beata Michalska <beata.michalska@linaro.org>
Subject: Re: [PATCH v8 1/2] target/arm: kvm: Handle DABT with no valid ISS
Message-ID: <20200629081510.ochvmmmikhe62bsm@kamzik.brq.redhat.com>
References: <20200628150459.18566-1-beata.michalska@linaro.org>
 <20200628150459.18566-2-beata.michalska@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20200628150459.18566-2-beata.michalska@linaro.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

On Sun, Jun 28, 2020 at 04:04:58PM +0100, Beata Michalska wrote:
> On ARMv7 & ARMv8 some load/store instructions might trigger a data abort
> exception with no valid ISS info to be decoded. The lack of decode info
> makes it at least tricky to emulate those instruction which is one of the
> (many) reasons why KVM will not even try to do so.
> 
> Add support for handling those by requesting KVM to inject external
> dabt into the quest.
> 
> Signed-off-by: Beata Michalska <beata.michalska@linaro.org>
> ---
>  target/arm/kvm.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index eef3bbd..2dd8a9a 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -39,6 +39,7 @@ const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
>  
>  static bool cap_has_mp_state;
>  static bool cap_has_inject_serror_esr;
> +static bool cap_has_inject_ext_dabt;
>  
>  static ARMHostCPUFeatures arm_host_cpu_features;
>  
> @@ -245,6 +246,16 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>          ret = -EINVAL;
>      }
>  
> +    if (kvm_check_extension(s, KVM_CAP_ARM_NISV_TO_USER)) {
> +        if (kvm_vm_enable_cap(s, KVM_CAP_ARM_NISV_TO_USER, 0)) {
> +            error_report("Failed to enable KVM_CAP_ARM_NISV_TO_USER cap");
> +        } else {
> +            /* Set status for supporting the external dabt injection */
> +            cap_has_inject_ext_dabt = kvm_check_extension(s,
> +                                    KVM_CAP_ARM_INJECT_EXT_DABT);
> +        }
> +    }
> +
>      return ret;
>  }
>  
> @@ -810,6 +821,45 @@ void kvm_arm_vm_state_change(void *opaque, int running, RunState state)
>      }
>  }
>  
> +/**
> + * kvm_arm_handle_dabt_nisv:
> + * @cs: CPUState
> + * @esr_iss: ISS encoding (limited) for the exception from Data Abort
> + *           ISV bit set to '0b0' -> no valid instruction syndrome
> + * @fault_ipa: faulting address for the synchronous data abort
> + *
> + * Returns: 0 if the exception has been handled, < 0 otherwise
> + */
> +static int kvm_arm_handle_dabt_nisv(CPUState *cs, uint64_t esr_iss,
> +                             uint64_t fault_ipa)

The indent of 'uint64_t fault_ipa' is off. Should be under CPUState.

> +{
> +    /*
> +     * Request KVM to inject the external data abort into the guest
> +     */
> +    if (cap_has_inject_ext_dabt) {
> +        struct kvm_vcpu_events events = { };
> +        /*
> +         * The external data abort event will be handled immediately by KVM
> +         * using the address fault that triggered the exit on given VCPU.
> +         * Requesting injection of the external data abort does not rely
> +         * on any other VCPU state. Therefore, in this particular case, the VCPU
> +         * synchronization can be exceptionally skipped.
> +         */
> +        events.exception.ext_dabt_pending = 1;
> +        /*
> +         * KVM_CAP_ARM_INJECT_EXT_DABT implies KVM_CAP_VCPU_EVENTS
> +         */

Single line comments may be done with /* ... */ 

> +        return kvm_vcpu_ioctl(cs, KVM_SET_VCPU_EVENTS, &events);
> +

Extra blank line here.

> +    } else {
> +        error_report("Data abort exception triggered by guest memory access "
> +                     "at physical address: 0x"  TARGET_FMT_lx,
> +                     (target_ulong)fault_ipa);
> +        error_printf("KVM unable to emulate faulting instruction.\n");
> +    }
> +    return -1;
> +}
> +
>  int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>  {
>      int ret = 0;
> @@ -820,7 +870,12 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>              ret = EXCP_DEBUG;
>          } /* otherwise return to guest */
>          break;
> -    default:
> +    case KVM_EXIT_ARM_NISV:
> +        /* External DABT with no valid iss to decode */
> +        ret = kvm_arm_handle_dabt_nisv(cs, run->arm_nisv.esr_iss,
> +                                       run->arm_nisv.fault_ipa);
> +        break;
> +     default:

An extra space got added in front of 'default:'

>          qemu_log_mask(LOG_UNIMP, "%s: un-handled exit reason %d\n",
>                        __func__, run->exit_reason);
>          break;
> -- 
> 2.7.4
> 
> 

Besides the format changes

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
