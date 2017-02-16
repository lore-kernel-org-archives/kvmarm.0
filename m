From: David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] KVM: race-free exit from KVM_RUN without POSIX signals
Date: Thu, 16 Feb 2017 20:26:38 +0100
Message-ID: <8a0f0818-07eb-c33e-9488-5a69c6bb67b1@redhat.com>
References: <1487169821-14806-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33ADE40C8E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Feb 2017 14:25:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Frct0czgFmmA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Feb 2017 14:25:55 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E29E40C21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Feb 2017 14:25:55 -0500 (EST)
In-Reply-To: <1487169821-14806-1-git-send-email-pbonzini@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: james.hogan@imgtec.com, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, borntraeger@de.ibm.com, paulus@samba.org, cornelia.huck@de.ibm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

>  	post_kvm_run_save(vcpu);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 7964b970b9ad..f51d5082a377 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -218,7 +218,8 @@ struct kvm_hyperv_exit {
>  struct kvm_run {
>  	/* in */
>  	__u8 request_interrupt_window;
> -	__u8 padding1[7];
> +	__u8 immediate_exit;

As mentioned already on IRC, maybe something like "block_vcpu_run" would
fit better now.

But this is also ok and looks good to me.

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David
