Return-Path: <SRS0=tvNx=YR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D682CCA9EBC
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 20:24:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 66A3E21928
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 20:24:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66A3E21928
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC02A4A52B;
	Thu, 24 Oct 2019 16:24:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1zJW+ti9R3Nn; Thu, 24 Oct 2019 16:24:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB7934A5C3;
	Thu, 24 Oct 2019 16:24:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 324714A5A1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 16:24:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cKwVQVkVQNoY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Oct 2019 16:24:14 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 220364A52B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 16:24:14 -0400 (EDT)
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 0CACB369AC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 20:24:13 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id a15so13507852wrr.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 13:24:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=ZRT3dVDu4csQhfGia5nCcLIZe2YAZImGVAl5gr6pUcE=;
 b=G73ED3+XA7VcSTX65tqH4HpHTGEpUfcxmhn0OHiQeF2F+QUrNlKM5oviGG1X9zbuCS
 ZDpi9SgEziSSTADtjDpjOi2eVDor2dW5e73GH0EpXFTrcsBeAnVZHjbHFtusxlLZd8a7
 W4kfEIngxo7pp+RjBUbukRtJB0boPSVvsfeMnYn6pHfzEhgX/rCI/1qp7jgNFLeuYUne
 qN+ovJpjYJ4jMO+qfF9a84m8oPbZN5oXZWZqyBYwa6WYonxtNe7hITzKTIdGPwcI/Dio
 a/1qzM8B92ST1niAu33GyYxxR759j+kQMrFONqyc5CaDItI5GseMdHno5Lkz7Dnn6l9S
 /FYw==
X-Gm-Message-State: APjAAAWvhAAnPdYYczcTzqZk4atVxbyXZAxJeFf9Ik/H2Bl822WeSvJs
 9Qdh6u4Pjw50mNJy2+hloAtoz2mjnOHNpt3Cr/gOa40iwvahP/V9GOy05HLvdJzysvVj8GylIrz
 lgarD85raj47wGs77RSOlaJfT
X-Received: by 2002:a5d:4a03:: with SMTP id m3mr5578396wrq.359.1571948651617; 
 Thu, 24 Oct 2019 13:24:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx4p9hq+y70/y8WlLn0/OTguCJ96CcuhVxxvxeJyvnyp8Rzk3Jc6wiDxI+nnKN+OJXQKdf4DA==
X-Received: by 2002:a5d:4a03:: with SMTP id m3mr5578369wrq.359.1571948651305; 
 Thu, 24 Oct 2019 13:24:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:302c:998e:a769:c583?
 ([2001:b07:6468:f312:302c:998e:a769:c583])
 by smtp.gmail.com with ESMTPSA id v128sm5252067wmb.14.2019.10.24.13.24.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 24 Oct 2019 13:24:10 -0700 (PDT)
Subject: Re: [PATCH v2 14/15] KVM: Terminate memslot walks via used_slots
To: Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-15-sean.j.christopherson@intel.com>
 <642f73ee-9425-0149-f4f4-f56be9ae5713@redhat.com>
 <20191022152827.GC2343@linux.intel.com>
 <625e511f-bd35-3b92-0c6d-550c10fc5827@redhat.com>
 <20191022155220.GD2343@linux.intel.com>
 <5c61c094-ee32-4dcf-b3ae-092eba0159c5@redhat.com>
 <20191024193856.GA28043@linux.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5320341c-1abb-610b-8f5e-090a6726a9b1@redhat.com>
Date: Thu, 24 Oct 2019 22:24:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191024193856.GA28043@linux.intel.com>
Content-Language: en-US
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On 24/10/19 21:38, Sean Christopherson wrote:
> only
>  * its new index into the array is update.

s/update/tracked/?

  Returns the changed memslot's
>  * current index into the memslots array.
>  */
> static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
> 					    struct kvm_memory_slot *memslot)
> {
> 	struct kvm_memory_slot *mslots = slots->memslots;
> 	int i;
> 
> 	if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
> 	    WARN_ON_ONCE(!slots->used_slots))
> 		return -1;
> 
> 	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots - 1; i++) {
> 		if (memslot->base_gfn > mslots[i + 1].base_gfn)
> 			break;
> 
> 		WARN_ON_ONCE(memslot->base_gfn == mslots[i + 1].base_gfn);
> 
> 		/* Shift the next memslot forward one and update its index. */
> 		mslots[i] = mslots[i + 1];
> 		slots->id_to_index[mslots[i].id] = i;
> 	}
> 	return i;
> }
> 
> /*
>  * Move a changed memslot forwards in the array by shifting existing slots with
>  * a lower GFN toward the back of the array.  Note, the changed memslot itself
>  * is not preserved in the array, i.e. not swapped at this time, only its new
>  * index into the array is updated

Same here?

>  * Note, slots are sorted from highest->lowest instead of lowest->highest for
>  * historical reasons.

Not just that, the largest slot (with all RAM above 4GB) is also often
at the highest address at least on x86.  But we could sort them by size
now, so I agree to call these historical reasons.

The code itself is fine, thanks for the work on documenting it.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
