Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550DFC2D0CE
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 14:24:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CFFA824655
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 14:24:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gEcewj+6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFFA824655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52C584AFEF;
	Tue, 21 Jan 2020 09:24:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cqus+ktJC8YH; Tue, 21 Jan 2020 09:24:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44BD44AFF8;
	Tue, 21 Jan 2020 09:24:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 856F74AFEF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 09:24:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 037jIWmOP+ej for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 09:24:36 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92A724AFDE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 09:24:36 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579616676;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=iietA04mTbBj3y8KEP1nE87RzCPxCIolbi4wDz4ohvY=;
 b=gEcewj+6vNDNPjxB+44kCmZ+rItN4DxLbT80VCVg8+N8fu2PTt+twUsu1wDr/D0rhQ+htq
 pjrJwChUdeFVogbZrrFU7UQuydVQ40ZrMocDW15OSzZa/GxCcaxL9c20F/SiGJtea9qG74
 GschU2NtrPgdD7YCRnE/Wc71nDtcVvs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-a9MGI32rMt2gy_FJ0v6DiQ-1; Tue, 21 Jan 2020 09:24:35 -0500
Received: by mail-wm1-f70.google.com with SMTP id 7so426119wmf.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 06:24:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=iietA04mTbBj3y8KEP1nE87RzCPxCIolbi4wDz4ohvY=;
 b=SARxfyJTCaCaTMm/dZfYkZbo5jSLwwXVGfBxQvxdxvJZ5YcV6/1ovrIVQDz/UBls4z
 AyXJC2xBlTCAHuDb+dWTyyurMVk0qP7zgJoChmKVdpVKjZN2thQ9lfZ8WpuCXJQymTCd
 PaQnQbx9GF+AdIIb2rqMZNko1ChfshfILwJsJIkowzAtDXk3ZDnh5k0xARQ0rywd0jxj
 NYPWcQB0Ab1HjhOb+Y+eErrEQ6ZTF++vujFGNfwgx0y009Jzc5Dst0+aSOTy1qknWOQa
 Pbskrrd0VSLQFnr4JDqo5otXZn54TuDERZwKeLsLe98BTK0dOKGK8BLOf62WJjruzpIU
 x6uQ==
X-Gm-Message-State: APjAAAX0VXEL3o0LQygqf8feC6lIO1jKWreNuelK6qOKkF6BBodk5puW
 Haz6WjGNTUluqGayfUoX/r4Z9RocCWb80kHemT8wbgtDEfEBPqyxaENNtWoxFnyMqUYylSYDUmC
 IU5+9XMhJYRIM3CsTUs3wZFns
X-Received: by 2002:a5d:4d06:: with SMTP id z6mr5440107wrt.339.1579616673970; 
 Tue, 21 Jan 2020 06:24:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqyTZsEeiVXo1aYXs9MoGNtX19umLmm3R/ZbsXqxiGO2rVQCtL37lQcA37U+6PdsUBw/nSKlMg==
X-Received: by 2002:a5d:4d06:: with SMTP id z6mr5440056wrt.339.1579616673641; 
 Tue, 21 Jan 2020 06:24:33 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a?
 ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
 by smtp.gmail.com with ESMTPSA id m3sm51279088wrs.53.2020.01.21.06.24.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Jan 2020 06:24:33 -0800 (PST)
Subject: Re: [PATCH 04/14] KVM: Play nice with read-only memslots when
 querying host page size
To: Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
 <20200108202448.9669-5-sean.j.christopherson@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2c091d40-8e32-1e55-2eff-27a4b43e0674@redhat.com>
Date: Tue, 21 Jan 2020 15:24:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200108202448.9669-5-sean.j.christopherson@intel.com>
Content-Language: en-US
X-MC-Unique: a9MGI32rMt2gy_FJ0v6DiQ-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Paul Mackerras <paulus@ozlabs.org>,
 linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu,
 Dave Jiang <dave.jiang@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com,
 Barret Rhoden <brho@google.com>, kvm-ppc@vger.kernel.org,
 Liran Alon <liran.alon@oracle.com>, Andy Lutomirski <luto@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 linux-kernel@vger.kernel.org, Jason Zeng <jason.zeng@intel.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On 08/01/20 21:24, Sean Christopherson wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 5f7f06824c2b..d9aced677ddd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1418,15 +1418,23 @@ EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
>  
>  unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
>  {
> +	struct kvm_memory_slot *slot;
>  	struct vm_area_struct *vma;
>  	unsigned long addr, size;
>  
>  	size = PAGE_SIZE;
>  
> -	addr = kvm_vcpu_gfn_to_hva(vcpu, gfn);
> -	if (kvm_is_error_hva(addr))
> +	/*
> +	 * Manually do the equivalent of kvm_vcpu_gfn_to_hva() to avoid the
> +	 * "writable" check in __gfn_to_hva_many(), which will always fail on
> +	 * read-only memslots due to gfn_to_hva() assuming writes.
> +	 */
> +	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> +	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
>  		return PAGE_SIZE;
>  
> +	addr = __gfn_to_hva_memslot(slot, gfn);
> +
>  	down_read(&current->mm->mmap_sem);
>  	vma = find_vma(current->mm, addr);
>  	if (!vma)
> 

Even simpler: use kvm_vcpu_gfn_to_hva_prot

-	addr = kvm_vcpu_gfn_to_hva(vcpu, gfn);
+	addr = kvm_vcpu_gfn_to_hva_prot(vcpu, gfn, NULL);

"You are in a maze of twisty little functions, all alike".

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
