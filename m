Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD7BC2D0CE
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 14:26:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 24808217F4
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 14:26:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SkNEywdQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24808217F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FD5E4AFC5;
	Tue, 21 Jan 2020 09:26:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SGE1OJRcOHbe; Tue, 21 Jan 2020 09:26:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAE7A4AFF8;
	Tue, 21 Jan 2020 09:26:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA2D54AFC9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 09:26:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 048X3ls-5yRu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 09:26:34 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A0A64AFC5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 09:26:34 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579616793;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wB7oBUxPFMMo41Dhy/A6/q8IlRImdTJH/qsnmSwn8s8=;
 b=SkNEywdQxA2MNtBg974Sn0ZydviqoFf7LucDrjpzy39Tsk8ub9HgZig3tiUC1+XV8YjbVC
 dTZMVC1+cXJQ0Y9JvlxcvsQVNTw2JT79hjDojprlb9ehkrPWMN4i5j+ONb6/mm5FEXWbh0
 xgCF491KvV5JkAxjJhjWm2briBhiIR8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-Y6cku3gIPYWA6k5aWJ7YYg-1; Tue, 21 Jan 2020 09:26:31 -0500
Received: by mail-wr1-f72.google.com with SMTP id z14so1394878wrs.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 06:26:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=wB7oBUxPFMMo41Dhy/A6/q8IlRImdTJH/qsnmSwn8s8=;
 b=BwqkAd4SgeH5Eah2n+5zlxC4l/KhMIIe2r/ZEI/8tmeor+iPjLpjv5XL7eTsatiOhg
 GqT02JSZCoGPqxJEifdrBPLO0ooOdvIropeM2keqK7YlbzAm0e8ut1FWgt0bVva8MOVS
 7KkJz9EEwXZw+S24I7gkhsCaZdY+3MGGV6vzgd7uR3ooXoscbRW/14PvNnFV0jNUqxsN
 Z0HCJvpCyuQH1dRPgZ8GTReB5nel2gCcDhaJu3jdj6xS1g4DXJWTPUhToGBKuDcvqPQS
 eJO+eqWoj04Pi5LDZ5iWslpQ/UaCufsfaLPpJdLs+Lz/oX6ppgwLlR96LNKRiHogL5YF
 uyjw==
X-Gm-Message-State: APjAAAW3SNjFMFbZrwPVOBiuxL2z4a/loZQERvdmz/3allKrsxcVtkLR
 PWX/IgIOmQVTOjAqHScoKTwPJICnQPMiO2nULv8/uRoBIbBluRZKgI+Sb+xQza26rfe/+Z9lIhO
 T4aWIcOc6Q28VRVy6NSZbFsS6
X-Received: by 2002:a5d:6089:: with SMTP id w9mr5614967wrt.228.1579616790219; 
 Tue, 21 Jan 2020 06:26:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqxWjz4Oe+H/gSHDnoSQ5o2pah30WIinDPbt454AQ/QK4v/OQZOFatnXxkc9zEh4soAyNb9f2w==
X-Received: by 2002:a5d:6089:: with SMTP id w9mr5614921wrt.228.1579616789896; 
 Tue, 21 Jan 2020 06:26:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a?
 ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
 by smtp.gmail.com with ESMTPSA id q68sm4727432wme.14.2020.01.21.06.26.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Jan 2020 06:26:29 -0800 (PST)
Subject: Re: [PATCH 05/14] x86/mm: Introduce lookup_address_in_mm()
To: Thomas Gleixner <tglx@linutronix.de>,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
 <20200108202448.9669-6-sean.j.christopherson@intel.com>
 <871rs8batm.fsf@nanos.tec.linutronix.de>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <175cef39-1e0e-d1b7-69bc-95a3a2a651a7@redhat.com>
Date: Tue, 21 Jan 2020 15:26:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <871rs8batm.fsf@nanos.tec.linutronix.de>
Content-Language: en-US
X-MC-Unique: Y6cku3gIPYWA6k5aWJ7YYg-1
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

On 09/01/20 22:04, Thomas Gleixner wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
>> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
>> index b5e49e6bac63..400ac8da75e8 100644
>> --- a/arch/x86/include/asm/pgtable_types.h
>> +++ b/arch/x86/include/asm/pgtable_types.h
>> @@ -561,6 +561,10 @@ static inline void update_page_count(int level, unsigned long pages) { }
>>  extern pte_t *lookup_address(unsigned long address, unsigned int *level);
>>  extern pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
>>  				    unsigned int *level);
>> +
>> +struct mm_struct;
>> +pte_t *lookup_address_in_mm(struct mm_struct *mm, unsigned long address,
>> +			    unsigned int *level);
> 
> Please keep the file consistent and use extern even if not required.
> 
> Other than that:
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> 

Adjusted, thanks for the review.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
