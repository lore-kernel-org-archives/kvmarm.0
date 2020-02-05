Return-Path: <SRS0=/ADY=3Z=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931BFC35247
	for <kvmarm@archiver.kernel.org>; Wed,  5 Feb 2020 22:42:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1DEF3217F4
	for <kvmarm@archiver.kernel.org>; Wed,  5 Feb 2020 22:42:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jWO0l6Tl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DEF3217F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 871C14A650;
	Wed,  5 Feb 2020 17:42:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2qp59SRiJu7q; Wed,  5 Feb 2020 17:42:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7871B4A524;
	Wed,  5 Feb 2020 17:42:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37CDE4A524
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Feb 2020 17:42:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4L3b9mxUtzoW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Feb 2020 17:42:01 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 588044A418
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Feb 2020 17:42:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580942521;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=AoV/3XjIbnAzmVCqiyYSjksDW0qIqMnLXjhY1MW1cfI=;
 b=jWO0l6TlqYT+w0kYE1t53PUmRTsOaushhI80yw3SjLXWkeP82iXUTaqUsal8X2YyT4gXVo
 ZXGV3yhl8iwkSriNLGY3D7Fe3JXkBwaYPPEppzZy1ZQKZHoECu+hASalb+B66yfqXLI3pH
 NJUuQs0HxtbNE1he24mGam1777DaqVM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-d3rd6xKLNo226K7iOmUDgg-1; Wed, 05 Feb 2020 17:41:59 -0500
Received: by mail-qt1-f198.google.com with SMTP id p12so2459805qtu.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Feb 2020 14:41:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=rH9hapDVBD03GESwcZDF6GjM5sGJp1/0m6Dm+I8b0N0=;
 b=Sqs5SYKgQJNCqnh1Hy6aXLf7Vj79bEbIpsEh6CyvCJRsm6pFUxFbVdxMs/3iKQtebT
 frnbh+3aZxTVnxDQWc3apvav/5E9kOhCloGCh5CldEO4Q9jNzE4H7/yodF5nntBoto/+
 65dyoRB+/HO8AbBbGUL7r+8ZAW+0f2kH6JlOaxTgncj2sHNVZQDhEpEqggMui/UwaxKN
 rfrJ7jVpSFHW7rNC4SKyubOd/jfGk2H74m4EuOSxPkbXD51A67Eu6Un2ZsuLrUdLidFD
 hrAjiKqJmPGw1tvZoNw8fwCrmLrLQFu9Cs9sCiq1nBPCCjciM/CzPVMP+TkV6M6JdJTv
 Dw1Q==
X-Gm-Message-State: APjAAAV0CwJEbrRelHXDACLKLudf9NU4cChMysYKogVxct4SxnS4Ewc5
 oe8PRR/QwpE1Jh+MYp0G2DJqz46ssXrn4PZ8rNWYTVupa2CAyTzfIx6VgneSQzJLgEToX5lCxJ4
 3DKBx+brpD10WxOSFHthTqQ9E
X-Received: by 2002:a37:4fc3:: with SMTP id d186mr59921qkb.100.1580942518831; 
 Wed, 05 Feb 2020 14:41:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqz7uhA3CGENCAtqy4g5GvmYMoxE6Qbx+Ub2ume93+vIa38OEJ1jq8Hx/Hw9ZpC1eb3usykd7Q==
X-Received: by 2002:a37:4fc3:: with SMTP id d186mr59892qkb.100.1580942518606; 
 Wed, 05 Feb 2020 14:41:58 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id a201sm512222qkc.134.2020.02.05.14.41.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 05 Feb 2020 14:41:57 -0800 (PST)
Date: Wed, 5 Feb 2020 17:41:54 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 04/19] KVM: PPC: Move memslot memory allocation into
 prepare_memory_region()
Message-ID: <20200205224154.GG387680@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-5-sean.j.christopherson@intel.com>
MIME-Version: 1.0
In-Reply-To: <20200121223157.15263-5-sean.j.christopherson@intel.com>
X-MC-Unique: d3rd6xKLNo226K7iOmUDgg-1
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

On Tue, Jan 21, 2020 at 02:31:42PM -0800, Sean Christopherson wrote:
>  static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
> -					struct kvm_memory_slot *memslot,
> -					const struct kvm_userspace_memory_region *mem)
> +					struct kvm_memory_slot *slot,
> +					const struct kvm_userspace_memory_region *mem,
> +					enum kvm_mr_change change)
>  {
> +	unsigned long npages = mem->memory_size >> PAGE_SHIFT;

Only in case if this patch still needs a respin: IIUC we can directly
use slot->npages below.  No matter what:

Reviewed-by: Peter Xu <peterx@redhat.com>

> +
> +	if (change == KVM_MR_CREATE) {
> +		slot->arch.rmap = vzalloc(array_size(npages,
> +					  sizeof(*slot->arch.rmap)));
> +		if (!slot->arch.rmap)
> +			return -ENOMEM;
> +	}
> +
>  	return 0;
>  }

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
