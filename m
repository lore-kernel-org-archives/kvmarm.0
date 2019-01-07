From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/11] KVM: Add spte's point in the struct kvm_mmu_page
Date: Mon, 7 Jan 2019 17:34:00 +0100
Message-ID: <dfaebf54-2a01-aafc-6f86-596f49874d3c@redhat.com>
References: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
 <20190104085405.40356-4-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E77134A3F2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jan 2019 11:34:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7kTZywuRAMye for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Jan 2019 11:34:05 -0500 (EST)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A8EB4A3D4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jan 2019 11:34:04 -0500 (EST)
Received: by mail-wm1-f65.google.com with SMTP id f81so1518309wmd.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Jan 2019 08:34:04 -0800 (PST)
In-Reply-To: <20190104085405.40356-4-Tianyu.Lan@microsoft.com>
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
Cc: kvm@vger.kernel.org, benh@kernel.crashing.org, will.deacon@arm.com, linux-mips@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, x86@kernel.org, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, mingo@redhat.com, catalin.marinas@arm.com, jhogan@kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, ralf@linux-mips.org, paul.burton@mips.com, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/01/19 09:53, lantianyu1986@gmail.com wrote:
> @@ -332,6 +332,7 @@ struct kvm_mmu_page {
>  	int root_count;          /* Currently serving as active root */
>  	unsigned int unsync_children;
>  	struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
> +	u64 *sptep;

Is this really needed?  Can we put the "last" flag in the struct instead
as a bool?  In fact, if you do

	u16 unsync_children;
	bool unsync;
	bool last_level;

the struct does not grow at all. :)

(I'm not sure where "large" is tested using the sptep field, even though
it is in the commit message).

Paolo

>  	/* The page is obsolete if mmu_valid_gen != kvm->arch.mmu_valid_gen.  */
>  	unsigned long mmu_valid_gen;
