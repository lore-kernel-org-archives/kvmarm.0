Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A1CC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Dec 2021 18:34:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF4D64B0E6;
	Thu,  9 Dec 2021 13:34:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 32iA7RnGMd8F; Thu,  9 Dec 2021 13:34:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53B054B10B;
	Thu,  9 Dec 2021 13:34:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A37844B0E6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 13:34:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cd+N35asrVq1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Dec 2021 13:34:12 -0500 (EST)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com
 [209.85.208.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50AA74B0E2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 13:34:12 -0500 (EST)
Received: by mail-ed1-f52.google.com with SMTP id r11so21973265edd.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Dec 2021 10:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=VmHNjKHHTgpu8LKf+wLbu6tr5d2B6TY5WNkaxl4rmr8=;
 b=gZq6Dj67kII8EQrFcvQRrysaXkPXfgaFl8h/21JGy/fEUeqdUxugDKnd0CNL1EUdHK
 KJPwK37d4PW840KmytVunGJapbLoZk4G3qw+TbDO8UYWUa2yu8kM7BqASqD3VbTbjPSr
 uYvvS+DgMUmrivsJTJ5U61ojewQPuA8oKfTgJidcMoKvKd75dFwAseVuJPPbufqS40gT
 sn9TuVUT5jgHVAMipF5b2yN0DSs3jGlOqB8UJmtZWNWcU0Bopi2mvXa3ytZ+oA/p2nkv
 P6BXBfcqsPMiZ2N//CV0MDTVNZrb5hlDan1lqFxK+s+uKW5LM3ou1RBnyIftv4h7SWPY
 xNxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=VmHNjKHHTgpu8LKf+wLbu6tr5d2B6TY5WNkaxl4rmr8=;
 b=qmCbM0H90PDAh/a/ImvHkIWyXtFGFfA/2XOMQSRGJOBifEtn33Nd0ZSVk1nOSJosIT
 IP0HMbFd9VwCX89N3jbdR16dE8YVyNLv3Tx3QE0cqGuArMYqa29nmSSc+mx1bw+G6umu
 dWHB44A/tUEEydt7J5t2Tey/89wQlSKLkmQCUOrBkfFhhkB1nt1DfEylhVbs/FQk6vxY
 jGPmPzWc9fP7ztppaurmsR04JusAFYJUiX80WAnzcng+LIrUFZNeHhbsc9lr1GLo++5a
 5XDQf20SW0iCVMlg4Roxy8LbC+INSoH8cOzMhW90hKPfKaAcSp3/cYxUtxftcF/AMAMe
 ydJQ==
X-Gm-Message-State: AOAM531P9y1KDxBRXjpH4UtJfcqKE/iWYOwXs/Ofk5gcRexIp3GzE5Vz
 XhKMU3weeWuoT224v9iK67c=
X-Google-Smtp-Source: ABdhPJzPr2JWAHHRiyW9tf+vJ9HDTL67K/LwoYescyr21dhuVB9iq2UisCXP0bQ++tHwzdvxo9UJXA==
X-Received: by 2002:a17:906:f43:: with SMTP id
 h3mr17722168ejj.414.1639074851284; 
 Thu, 09 Dec 2021 10:34:11 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.googlemail.com with ESMTPSA id yd20sm299781ejb.47.2021.12.09.10.34.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 09 Dec 2021 10:34:10 -0800 (PST)
Message-ID: <b1bacc6f-be56-4108-6e52-4315a021184b@redhat.com>
Date: Thu, 9 Dec 2021 19:34:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 08/12] KVM: Reinstate gfn_to_pfn_cache with
 invalidation support
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
References: <20211121125451.9489-1-dwmw2@infradead.org>
 <20211121125451.9489-9-dwmw2@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211121125451.9489-9-dwmw2@infradead.org>
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 butt3rflyh4ck <butterflyhuangxx@gmail.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 "vkuznets @ redhat . com" <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Sorry for the late review...

On 11/21/21 13:54, David Woodhouse wrote:
> +EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_check);
> +
> +static void __release_gpc(struct kvm *kvm, kvm_pfn_t pfn, void *khva,
> +			  gpa_t gpa, bool dirty)
> +{
> +	/* Unmap the old page if it was mapped before, and release it */
> +	if (!is_error_noslot_pfn(pfn)) {
> +		if (khva) {
> +			if (pfn_valid(pfn))
> +				kunmap(pfn_to_page(pfn));
> +#ifdef CONFIG_HAS_IOMEM
> +			else
> +				memunmap(khva);
> +#endif
> +		}

Considering that the khva is passed directly to memunmap, perhaps it's
cleaner to ensure it's page-aligned:

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 13cae72d39e9..267477bd2972 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -147,7 +147,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
  
  	old_gpa = gpc->gpa;
  	old_pfn = gpc->pfn;
-	old_khva = gpc->khva;
+	old_khva = (void *)((unsigned long)gpc->khva & ~PAGE_MASK);
  	old_uhva = gpc->uhva;
  	old_valid = gpc->valid;
  	old_dirty = gpc->dirty;
@@ -209,7 +209,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
  
  		if (gpc->kernel_map) {
  			if (new_pfn == old_pfn) {
-				new_khva = (void *)((unsigned long)old_khva - page_offset);
+				new_khva = old_khva;
  				old_pfn = KVM_PFN_ERR_FAULT;
  				old_khva = NULL;
  			} else if (pfn_valid(new_pfn)) {
@@ -265,7 +265,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
  
  	gpc->valid = false;
  
-	old_khva = gpc->khva;
+	old_khva = (void *)((unsigned long)gpc->khva & ~PAGE_MASK);
  	old_dirty = gpc->dirty;
  	old_gpa = gpc->gpa;
  	old_pfn = gpc->pfn;


> 
> +	retry_map:
> +		mmu_seq = kvm->mmu_notifier_seq;
> +		smp_rmb();
> +
> +		/* We always request a writeable mapping */
> +		new_pfn = hva_to_pfn(uhva, false, NULL, true, NULL);
> +		if (is_error_noslot_pfn(new_pfn)) {
> +			ret = -EFAULT;
> +			goto map_done;
> +		}
> +
> +		KVM_MMU_READ_LOCK(kvm);
> +		retry = mmu_notifier_retry_hva(kvm, mmu_seq, uhva);
> +		KVM_MMU_READ_UNLOCK(kvm);
> +		if (retry) {
> +			cond_resched();
> +			goto retry_map;
> +		}
> +

This should also be a separate function, like

static kvm_pfn_t hva_to_pfn_retry(unsigned long uhva)
{
         kvm_pfn_t new_pfn
         unsigned long mmu_seq;
         int retry;

retry_map:
         mmu_seq = kvm->mmu_notifier_seq;
         smp_rmb();

         /* We always request a writeable mapping */
         new_pfn = hva_to_pfn(uhva, false, NULL, true, NULL);
         if (is_error_noslot_pfn(new_pfn))
                 return new_pfn;

         KVM_MMU_READ_LOCK(kvm);
         retry = mmu_notifier_retry_hva(kvm, mmu_seq, uhva);
         KVM_MMU_READ_UNLOCK(kvm);
         if (retry) {
                 cond_resched();
                 goto retry_map;
         }
         return new_pfn;
}

> 
> +		write_lock_irq(&gpc->lock);
> +		if (ret) {
> +			gpc->valid = false;
> +			gpc->pfn = KVM_PFN_ERR_FAULT;
> +			gpc->khva = NULL;
> +		} else {
> +			/* At this point, gpc->valid may already have been cleared */
> +			gpc->pfn = new_pfn;
> +			gpc->khva = new_khva + page_offset;
> +		}

Should set gpc->khva only if new_khva != NULL (i.e. only if gpc->kernel_map
is true).

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
