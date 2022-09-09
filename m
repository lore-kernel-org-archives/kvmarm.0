Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B98ECAAA1
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 10:02:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 483694CAEC;
	Fri,  9 Sep 2022 06:02:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0S6KQD+mYsLk; Fri,  9 Sep 2022 06:02:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3B9D4CAED;
	Fri,  9 Sep 2022 06:02:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AF8F4CAEA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 06:02:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rsp7MMl52Z4o for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 06:02:15 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C44A94CADC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 06:02:15 -0400 (EDT)
Date: Fri, 9 Sep 2022 11:01:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1662717734;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=y+xjoGI2hXYxhtWycnHQ5wVfTyWAv6wxDKxQfifkzGE=;
 b=H/eWJT/R1Z4XEOiJ5IipKnqK4w0Ktqh9UISGSPXNj4o6TG6DnAmSkeLdTgLE79dKj1gQCu
 QLDEro/hUuZC1g8Dj3bLWkAk+UtkuFp+0JS67sUFtN8+3FZYI4/23LyMd6z/5Aiu+XWExY
 qHZcFWGLtK4ubaxK54AHX0RuMNini74=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 00/14] KVM: arm64: Parallel stage-2 fault handling
Message-ID: <YxsPFltAMvls/A9n@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <87o7vsvn4m.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87o7vsvn4m.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Ben Gardon <bgardon@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hey Marc,

On Tue, Sep 06, 2022 at 11:00:09AM +0100, Marc Zyngier wrote:

[...]

> This fails to build on -rc4:
> 
>   MODPOST vmlinux.symvers
>   MODINFO modules.builtin.modinfo
>   GEN     modules.builtin
>   CC      .vmlinux.export.o
>   LD      .tmp_vmlinux.kallsyms1
> ld: Unexpected GOT/PLT entries detected!
> ld: Unexpected run-time procedure linkages detected!
> ld: ID map text too big or misaligned
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_walk':
> (.hyp.text+0xdc0c): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xdc1c): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_get_leaf':
> (.hyp.text+0xdc80): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xdc90): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_hyp_map':
> (.hyp.text+0xddb0): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xddc0): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_hyp_unmap':
> (.hyp.text+0xde44): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xde50): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_hyp_destroy':
> (.hyp.text+0xdf40): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xdf50): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_stage2_map':
> (.hyp.text+0xe16c): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xe17c): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_stage2_set_owner':
> (.hyp.text+0xe264): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xe274): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_stage2_unmap':
> (.hyp.text+0xe2d4): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xe2e4): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_stage2_flush':
> (.hyp.text+0xe5b4): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xe5c4): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_stage2_destroy':
> (.hyp.text+0xe6f0): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xe700): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> make[3]: *** [Makefile:1169: vmlinux] Error 1
> make[2]: *** [debian/rules:7: build-arch] Error 2
> 
> as this drags the RCU read-lock into EL2, and that's not going to
> work... The following fixes it, but I wonder how you tested it.

Ugh. I was carrying a patch on top of my series to handle compilation
issues with rseq_test, I managed to squash the equivalent of below in
that patch.

Nonetheless, I *did* actually test it to get the numbers above :)

--
Thanks,
Oliver

> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index dc839db86a1a..adf170122daf 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -580,7 +580,7 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
>   */
>  enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
>  
> -#if defined(__KVM_NVHE_HYPERVISOR___)
> +#if defined(__KVM_NVHE_HYPERVISOR__)
>  
>  static inline void kvm_pgtable_walk_begin(void) {}
>  static inline void kvm_pgtable_walk_end(void) {}
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
