From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Move kvm_call_hyp back to its original
 localtion
Date: Tue, 1 Mar 2016 14:14:23 +0100
Message-ID: <CAKv+Gu-nVVoSLNrv21R23zqZQCKzJGXifMkyHAZ7DKMp9u5xrw@mail.gmail.com>
References: <1456837964-10325-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEBB941145
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 08:07:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0gk9J5cUPybG for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Mar 2016 08:07:17 -0500 (EST)
Received: from mail-io0-f179.google.com (mail-io0-f179.google.com
 [209.85.223.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A2378410EB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 08:07:17 -0500 (EST)
Received: by mail-io0-f179.google.com with SMTP id b188so3786927iof.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Mar 2016 05:14:24 -0800 (PST)
In-Reply-To: <1456837964-10325-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 1 March 2016 at 14:12, Marc Zyngier <marc.zyngier@arm.com> wrote:
> In order to reduce the risk of a bad merge, let's move the new
> kvm_call_hyp back to its original location in the file. This has
> zero impact from a code point of view.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
> Catalin,
>
> Would you mind merging this on top of arm64/for-next/core? I just
> verified that this prevents yet another mismerge between the arm64 and
> KVM trees.
>
> Thanks,
>
>         M.
>
>  arch/arm64/include/asm/kvm_host.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e3d67ff..e465b6d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -308,6 +308,8 @@ struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
>  struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
>
>  u64 __kvm_call_hyp(void *hypfn, ...);
> +#define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__)
> +
>  void force_vm_exit(const cpumask_t *mask);
>  void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
>
> @@ -343,6 +345,4 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
>
> -#define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__)
> -
>  #endif /* __ARM64_KVM_HOST_H__ */
> --
> 2.1.4
>
