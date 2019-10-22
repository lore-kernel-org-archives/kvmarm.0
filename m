Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B9FCA9EA0
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 14:04:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E8B3A21783
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 14:04:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8B3A21783
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C3604A990;
	Tue, 22 Oct 2019 10:04:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L0xlb0jJMEQE; Tue, 22 Oct 2019 10:04:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F6254A96B;
	Tue, 22 Oct 2019 10:04:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 370684A96B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 10:04:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YJiGiIimkfqg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Oct 2019 10:04:22 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 45DDB4A960
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 10:04:22 -0400 (EDT)
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 7068C5117D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 14:04:21 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id i10so1124694wrp.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 07:04:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=cI7ihz+0OXiuq2sxX+N5cJBmKtQum9zSe4e7C6PdS6E=;
 b=NlOzXLpcEPzvDeLlgu8P16M7P+8uhfebTa2nnJaziMJ39W7unMLy8IJiZwGoYQJM38
 ZYzHd262InqFKOtsdei9lHArvq42XzqVLz4HvMXJlqGjxEoxK70HC+W+CV3vRn4541cy
 CUKT/xiVX3gGmq/UKK0RbLQ9eA0CxwgYjmAzU34I3bdrkDEiScly9PuaG71+5RpthFjf
 Zs0MT1FifzBUCyjFaeP2Mrrv7xRq+KZdrhuNooZayYMzXNBlC+VBZJYLz8MJumagm7e8
 UErQMYzzESah74/IPw2B4kI1IE4pxQWwjLmvKqsV4BlSab+JSpzgPKB6GFj0DgNupyE6
 f3pg==
X-Gm-Message-State: APjAAAU9S9I4vK5eovFPzBFMD+FBkRR/4VFgtCKRE5zl7jtdYRSeE7G+
 7u1Rtiy7ZC53CIMD5SSZAHJiWTs0DX+uoGOP6QFozVrW5Pinz62HzdSGrphRTxsSUYjDPlL9zUE
 Uf+qKh624pYF+NGbDvkpoEKC5
X-Received: by 2002:a1c:4c02:: with SMTP id z2mr1302169wmf.78.1571753060071;
 Tue, 22 Oct 2019 07:04:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzBB+WAq2KC5VOJdeNtgubd6CTAxDm0c28bIfc4NXYNFYsicJIJc7CEyPBTiO7yZbxm83G9Ow==
X-Received: by 2002:a1c:4c02:: with SMTP id z2mr1302127wmf.78.1571753059747;
 Tue, 22 Oct 2019 07:04:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19?
 ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
 by smtp.gmail.com with ESMTPSA id p17sm14939972wrn.4.2019.10.22.07.04.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Oct 2019 07:04:19 -0700 (PDT)
Subject: Re: [PATCH v2 14/15] KVM: Terminate memslot walks via used_slots
To: Sean Christopherson <sean.j.christopherson@intel.com>,
 James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?=
 <rkrcmar@redhat.com>, Marc Zyngier <maz@kernel.org>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-15-sean.j.christopherson@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <642f73ee-9425-0149-f4f4-f56be9ae5713@redhat.com>
Date: Tue, 22 Oct 2019 16:04:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191022003537.13013-15-sean.j.christopherson@intel.com>
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

On 22/10/19 02:35, Sean Christopherson wrote:
> +static inline int kvm_shift_memslots_forward(struct kvm_memslots *slots,
> +					     struct kvm_memory_slot *new)
> +{
> +	struct kvm_memory_slot *mslots = slots->memslots;
> +	int i;
> +
> +	if (WARN_ON_ONCE(slots->id_to_index[new->id] == -1) ||
> +	    WARN_ON_ONCE(!slots->used_slots))
> +		return -1;
> +
> +	for (i = slots->id_to_index[new->id]; i < slots->used_slots - 1; i++) {
> +		if (new->base_gfn > mslots[i + 1].base_gfn)
> +			break;
> +
> +		WARN_ON_ONCE(new->base_gfn == mslots[i + 1].base_gfn);
> +
> +		/* Shift the next memslot forward one and update its index. */
> +		mslots[i] = mslots[i + 1];
> +		slots->id_to_index[mslots[i].id] = i;
> +	}
> +	return i;
> +}
> +
> +static inline int kvm_shift_memslots_back(struct kvm_memslots *slots,
> +					  struct kvm_memory_slot *new,
> +					  int start)

This new implementation of the insertion sort loses the comments that
were there in the old one.  Please keep them as function comments.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
