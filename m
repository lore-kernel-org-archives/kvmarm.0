From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [Resend PATCH V5 2/10] x86/hyper-v: Add HvFlushGuestAddressList
 hypercall support
Date: Fri, 21 Dec 2018 10:32:21 +0100
Message-ID: <3f936a6e-b727-c152-05fb-4d77f33e1745@redhat.com>
References: <20181206132113.2691-1-Tianyu.Lan@microsoft.com>
 <20181206132113.2691-3-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF8B94A375
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Dec 2018 04:32:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id giFdJ4Q4Fune for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Dec 2018 04:32:24 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 300C34A2F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Dec 2018 04:32:24 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id a62so4627888wmh.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Dec 2018 01:32:24 -0800 (PST)
In-Reply-To: <20181206132113.2691-3-Tianyu.Lan@microsoft.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: lantianyu1986@gmail.com
Cc: linux-mips@linux-mips.org, kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, sthemmin@microsoft.com, mpe@ellerman.id.au, x86@kernel.org, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, mingo@redhat.com, benh@kernel.crashing.org, jhogan@kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, haiyangz@microsoft.com, kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, ralf@linux-mips.org, paul.burton@mips.com, devel@linuxdriverproject.org, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/12/18 14:21, lantianyu1986@gmail.com wrote:
>  static inline int hyperv_flush_guest_mapping(u64 as) { return -1; }
> +static inline int hyperv_flush_guest_mapping_range(u64 as,
> +		hyperv_fill_flush_list_func fill_func, void *data);
> +{
> +	return -1;

This part for !IS_ENABLED(CONFIG_HYPERV) does not compile.

No big deal, but please add that to your testing procedures.

Paolo
