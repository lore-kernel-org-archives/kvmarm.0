Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5450CA9EB7
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 15:31:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6ED7B2084B
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 15:31:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6ED7B2084B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC15D4A977;
	Tue, 22 Oct 2019 11:31:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DBWzQbSA+XxU; Tue, 22 Oct 2019 11:31:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7C3B4A97F;
	Tue, 22 Oct 2019 11:31:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3FE74A977
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 11:31:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FqzGFg-xNgjB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Oct 2019 11:31:02 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 81C404A950
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 11:31:02 -0400 (EDT)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id A038B4628B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 15:31:01 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id o8so7663061wmc.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 08:31:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=bYuISgCPeW5+MVYfOIxCD24v5h78aw8/fY5c9Ec2zaE=;
 b=Nl4o+LHB3Xcy+wudCMPHBDWaryuorsV8WwSPoWW6qFA5RQKF48S2l2PM7yeAkuq9yc
 OquajFerhBwg6IoKF+Andu2RltNfm7y4ZHZcYd+vXrw7eSlOqAbhJxeE/Pik2ey/1W6c
 VgPS/3SRS+lPDPVLDc/rjr/VFBlv9ZxR0dqJoGqjIATIEJewy6cg0AwfQdGCH5m3MChs
 q8gY+qfpdm2tfVdcTWzmFXSPGLvBUqFY6L/mrPEXQz+jmufUGDR0etZAaIe/tZcl0q+5
 h0T2Fk5JSIFRfxPykBN35zKztUYo+jSD0TO2Ig6HvTCkNPFj8lAB4IaZgJNecRsyrYvv
 /PJQ==
X-Gm-Message-State: APjAAAX+43E6WwKpWeaYzlpRFgfpe4wfJGdNpY8OhNDlqT1DtbHKJ+3g
 XSQs+xm67hE5nHuTcsII57zMP3na2+O+p0OkrHckHseQD89vUw5tXZV8JDVdMUbFSoXNgH6gL5Z
 TRdwErMi8IshuKyblz3x5luTI
X-Received: by 2002:a7b:c4c6:: with SMTP id g6mr3605240wmk.126.1571758260077; 
 Tue, 22 Oct 2019 08:31:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzRNIaPW2VC3E0u/tx9jObrvh39A/kSU1/g2oCY4LzK3jFChqIF1uPjGeoTV55xRLqzG4HUGw==
X-Received: by 2002:a7b:c4c6:: with SMTP id g6mr3605195wmk.126.1571758259666; 
 Tue, 22 Oct 2019 08:30:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19?
 ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
 by smtp.gmail.com with ESMTPSA id i18sm17512175wrx.14.2019.10.22.08.30.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Oct 2019 08:30:59 -0700 (PDT)
Subject: Re: [PATCH v2 14/15] KVM: Terminate memslot walks via used_slots
To: Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-15-sean.j.christopherson@intel.com>
 <642f73ee-9425-0149-f4f4-f56be9ae5713@redhat.com>
 <20191022152827.GC2343@linux.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <625e511f-bd35-3b92-0c6d-550c10fc5827@redhat.com>
Date: Tue, 22 Oct 2019 17:30:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191022152827.GC2343@linux.intel.com>
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

On 22/10/19 17:28, Sean Christopherson wrote:
> On Tue, Oct 22, 2019 at 04:04:18PM +0200, Paolo Bonzini wrote:
>> On 22/10/19 02:35, Sean Christopherson wrote:
>>> +static inline int kvm_shift_memslots_forward(struct kvm_memslots *slots,
>>> +					     struct kvm_memory_slot *new)
>>> +{
>>> +	struct kvm_memory_slot *mslots = slots->memslots;
>>> +	int i;
>>> +
>>> +	if (WARN_ON_ONCE(slots->id_to_index[new->id] == -1) ||
>>> +	    WARN_ON_ONCE(!slots->used_slots))
>>> +		return -1;
>>> +
>>> +	for (i = slots->id_to_index[new->id]; i < slots->used_slots - 1; i++) {
>>> +		if (new->base_gfn > mslots[i + 1].base_gfn)
>>> +			break;
>>> +
>>> +		WARN_ON_ONCE(new->base_gfn == mslots[i + 1].base_gfn);
>>> +
>>> +		/* Shift the next memslot forward one and update its index. */
>>> +		mslots[i] = mslots[i + 1];
>>> +		slots->id_to_index[mslots[i].id] = i;
>>> +	}
>>> +	return i;
>>> +}
>>> +
>>> +static inline int kvm_shift_memslots_back(struct kvm_memslots *slots,
>>> +					  struct kvm_memory_slot *new,
>>> +					  int start)
>>
>> This new implementation of the insertion sort loses the comments that
>> were there in the old one.  Please keep them as function comments.
> 
> I assume you're talking about this blurb in particular?
> 
> 	 * The ">=" is needed when creating a slot with base_gfn == 0,
> 	 * so that it moves before all those with base_gfn == npages == 0.

Yes, well all of the comments.  You can also keep them in the caller, as
you prefer.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
