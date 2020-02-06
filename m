Return-Path: <SRS0=Is6r=32=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EFABC33CAC
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 19:06:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EAB7F20659
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 19:06:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BmG54Xxa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EAB7F20659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E49CD4A531;
	Thu,  6 Feb 2020 14:06:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AYgIhHArxe18; Thu,  6 Feb 2020 14:06:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC6384A534;
	Thu,  6 Feb 2020 14:06:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B7674A4CD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 14:06:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DsKxysfYAZEk for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Feb 2020 14:06:48 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C5324A389
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 14:06:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581016008;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=InYNPWLKCp8uHe4vvnIUyF7xIG6nPw8fE5CC09zI1bI=;
 b=BmG54XxaaNU9+D6EGoZS41mlDi4S2hCHHNntJjgs3ag75mapASKh+UIStvUv9LE1sVXdut
 Ru3xBhxR/UnAGdfVVef726eDlV3tk8sj2iLy+mSPmrb/tTprQvzfngsSyb2wFuZIgm+xst
 dz5D3NuAjl9NfCkQ/8LWKWnen3hhl2g=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-u1vCyT6APey4h-00lb51-w-1; Thu, 06 Feb 2020 14:06:46 -0500
Received: by mail-qt1-f200.google.com with SMTP id o18so4523179qtt.19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Feb 2020 11:06:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=vFP4U5ATaHC0RXndwUcuwuU/AxffnBhPUu6Oesq1zsE=;
 b=egNdNrTWwzM42e6abUaZ99rZFcyYeYAx/HMgz1YDlBleMd/ejf5zRWdR7qeDLyvfTk
 LEoFvjsC7TIRMVcqmbUhpOn2KhnQWUyJaDI4p/+lAV9MpZaKxECGJSuKqNFB8WLugNuE
 SgD/s+1tlfedylZ2JiefqGiqz6dGmUvIivGW8oS3XL47rLvWlES1rk6IqUdbce24taV7
 yA3+Vdy4hqt0CLYVQqp39IAYK9MK0W8v0/ow0vcn3emd07mCTrJvJCH/YiUax2W2DepA
 XxfRhorRTLPR5q1mHJfCZMMHQGzh2UuiSC+KmEiXF5KdPSn1vt5T63zNCJfZlr84vJKQ
 lRsg==
X-Gm-Message-State: APjAAAXARfPbEntMryW8Jh/nsFq0ty6ytZRnzkyGFYHocWgg9i00miZT
 wyxYVGZWTFigK6WTwJkhsExOeVIsnQbDTlPNaNLkRFbn56aHg/eZU+8TzeQkIeV19gzaYPFnG5P
 6biaAjh5BqPgnCAmxJhQDfMEu
X-Received: by 2002:a37:9d8c:: with SMTP id g134mr3831599qke.128.1581016005752; 
 Thu, 06 Feb 2020 11:06:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqwcm5P+4dPwvjCn12J5PDi86Wcm35+8jmeWD2jbAE2DUKQO5334DVnipyStraLYLoHf0dGJ6w==
X-Received: by 2002:a37:9d8c:: with SMTP id g134mr3831559qke.128.1581016005447; 
 Thu, 06 Feb 2020 11:06:45 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id m27sm111381qta.21.2020.02.06.11.06.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 06 Feb 2020 11:06:44 -0800 (PST)
Date: Thu, 6 Feb 2020 14:06:41 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 14/19] KVM: Clean up local variable usage in
 __kvm_set_memory_region()
Message-ID: <20200206190641.GA700495@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-15-sean.j.christopherson@intel.com>
MIME-Version: 1.0
In-Reply-To: <20200121223157.15263-15-sean.j.christopherson@intel.com>
X-MC-Unique: u1vCyT6APey4h-00lb51-w-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
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

On Tue, Jan 21, 2020 at 02:31:52PM -0800, Sean Christopherson wrote:

[...]

> @@ -1101,52 +1099,55 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
>  		return -EINVAL;
>  
> -	slot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> -	base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
> -	npages = mem->memory_size >> PAGE_SHIFT;
> -
> -	if (npages > KVM_MEM_MAX_NR_PAGES)
> -		return -EINVAL;
> -
>  	/*
>  	 * Make a full copy of the old memslot, the pointer will become stale
>  	 * when the memslots are re-sorted by update_memslots().
>  	 */
> -	old = *slot;
> +	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> +	old = *tmp;
> +	tmp = NULL;

Shall we keep this chunk to the patch where it will be used?  Other
than that, it looks good to me.

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
