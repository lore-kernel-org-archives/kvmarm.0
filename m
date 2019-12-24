Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA86C2D0C3
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 18:19:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0CAF520643
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 18:19:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EX65cXOD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0CAF520643
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B8654AF5B;
	Tue, 24 Dec 2019 13:19:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GgLBYAXHJPXD; Tue, 24 Dec 2019 13:19:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 503344AF45;
	Tue, 24 Dec 2019 13:19:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E21D4AF3B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 13:19:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0MdiUMcQTz4Z for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 13:19:39 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DD9A4AF39
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 13:19:39 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1577211578;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Of94FGGp4Kh6qOsAiCq5CHxsSDS1gZkh3XiFNyZvlDg=;
 b=EX65cXOD4wXi8XTojplzx7K23e98uNwo/AJgHlIWLelbK5RKIUvN2XPyWN/84g4oDGBgft
 a7I1xKE62fn5k8C1N6+ABo3d+s+EsvxgkiNBe4plqK1ByjrXu/eMzuyBRMvKpa1VIWSOzi
 iu5f9K1bplAyeGz4hqDWL9YoYvhVg4A=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-3A-JRyieNCm8edppl0I0pQ-1; Tue, 24 Dec 2019 13:19:37 -0500
Received: by mail-qv1-f72.google.com with SMTP id l1so13615566qvu.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 10:19:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=10oE3mcJxbSPeGAikLZZiyP7ObdJq49Q5FPmOfsO/dc=;
 b=YZ9/T9Y8TGlmzU4WO3tKLhFDNidcsMnwKkzJHUB3X2HkQ3IY0ibY/IUtXKUxtkBqG3
 bPlNq6TkwVS8aDPuqu07E6CxevIrRq2dwEkxpDTfO8KnB2Z9AUAEQ2SFI7z2OlbeHz9T
 qGv06KL8NV6uQv+RbyMXtTpNJk5bkV93ysyBACSjCIgGlPBU9HB2QKZd5H0puPAkxI4J
 4xtde5hG5GL9NOu5F8BRmNIXtKreB4m282ECc1sz0nAbY+m1lDFN6FVT4RLDUQqtY3Rr
 lFv6isKEFmobbYwsgWHO3rJK4Qp3AfGuZZ3RNEWJ1Ju5Kp5RA43cISOmbfuQAs5Ulv+C
 4Cfw==
X-Gm-Message-State: APjAAAUiLBpkCWx7Siwt2SQ8bOf0JnHkbFzNcUx7pS5uPUpH34f3SNnO
 0Rgby7XWNEBO699DG3FxLVLk80wkODmPfNNL7eBItx/F1iaLme7ZoHkIsVBiH3DygvnpJWE8on1
 ZaP4Qj+hMHL8pL6hW6QFaTS0s
X-Received: by 2002:a37:de16:: with SMTP id h22mr32000486qkj.400.1577211573533; 
 Tue, 24 Dec 2019 10:19:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqyPlDOvamAwfkQQCQ/yrbEZ/IdA8BxSZxEa3M38XxUFXj9DeSRjaR1EpPHTj42i4TNzDYXwVw==
X-Received: by 2002:a37:de16:: with SMTP id h22mr32000473qkj.400.1577211573294; 
 Tue, 24 Dec 2019 10:19:33 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:3f::2])
 by smtp.gmail.com with ESMTPSA id 63sm7087025qki.57.2019.12.24.10.19.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 24 Dec 2019 10:19:32 -0800 (PST)
Date: Tue, 24 Dec 2019 13:19:30 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v4 16/19] KVM: Ensure validity of memslot with respect to
 kvm_get_dirty_log()
Message-ID: <20191224181930.GC17176@xz-x1>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-17-sean.j.christopherson@intel.com>
MIME-Version: 1.0
In-Reply-To: <20191217204041.10815-17-sean.j.christopherson@intel.com>
X-MC-Unique: 3A-JRyieNCm8edppl0I0pQ-1
X-Mimecast-Spam-Score: 0
Content-Disposition: inline
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
 kvm-ppc@vger.kernel.org, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On Tue, Dec 17, 2019 at 12:40:38PM -0800, Sean Christopherson wrote:
> +int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
> +		      int *is_dirty, struct kvm_memory_slot **memslot)
>  {
>  	struct kvm_memslots *slots;
> -	struct kvm_memory_slot *memslot;
>  	int i, as_id, id;
>  	unsigned long n;
>  	unsigned long any = 0;
>  
> +	*memslot = NULL;
> +	*is_dirty = 0;
> +
>  	as_id = log->slot >> 16;
>  	id = (u16)log->slot;
>  	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
>  		return -EINVAL;
>  
>  	slots = __kvm_memslots(kvm, as_id);
> -	memslot = id_to_memslot(slots, id);
> -	if (!memslot->dirty_bitmap)
> +	*memslot = id_to_memslot(slots, id);
> +	if (!(*memslot)->dirty_bitmap)
>  		return -ENOENT;
>  
> -	n = kvm_dirty_bitmap_bytes(memslot);
> +	kvm_arch_sync_dirty_log(kvm, *memslot);

Should this line belong to previous patch?

> +
> +	n = kvm_dirty_bitmap_bytes(*memslot);
>  
>  	for (i = 0; !any && i < n/sizeof(long); ++i)
> -		any = memslot->dirty_bitmap[i];
> +		any = (*memslot)->dirty_bitmap[i];
>  
> -	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
> +	if (copy_to_user(log->dirty_bitmap, (*memslot)->dirty_bitmap, n))
>  		return -EFAULT;
>  
>  	if (any)
> -- 
> 2.24.1

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
