Return-Path: <SRS0=nG5+=5I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF53C10DCE
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 19:47:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2895F2070A
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 19:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zduysw3B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2895F2070A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E70F4A4BE;
	Mon, 23 Mar 2020 15:47:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rDdn+tEd8Iv4; Mon, 23 Mar 2020 15:47:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8053A4A4FC;
	Mon, 23 Mar 2020 15:47:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 435134A4BE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 15:47:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J32JhB1K62nr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2020 15:47:11 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67A564A4A4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 15:47:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584992831;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=S9IrSlxfJapkU8CWMBvfg1IPzMz8/r3SznAfCQ6EPKg=;
 b=Zduysw3BXOpqU1DMVZPPDCyEYUHg8H3684wmD+xBXRMqvkjZt0326YR2RD/1QFbf7IQthE
 14HhnuwjIhTgBaSIcyJ5GHyUFK209hQT9CKQUZ4XeUaLFdzWZF3ZBhxSz703KgTodXgz51
 113oncJdBT/xiJPNU+V6Chq0qPzdwvw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-E1WsYi_jOlGvbb4pkgCW6Q-1; Mon, 23 Mar 2020 15:47:09 -0400
X-MC-Unique: E1WsYi_jOlGvbb4pkgCW6Q-1
Received: by mail-wr1-f72.google.com with SMTP id d17so7887900wrw.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 12:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=S9IrSlxfJapkU8CWMBvfg1IPzMz8/r3SznAfCQ6EPKg=;
 b=ImSzyS3n1OSMsAxCY5nIdPXMCHJORAuoxvVG20PpxnNUNnYY19Cfr3oRseCb7is7fo
 khaDTJHeA48bjaSpcbZ7l98BVr2OabGITlyY4B+1Y1GPjVlOnBjy0gJ2XSjMC5Rz+750
 tInzrEIBVETMuZNyXg+TFaVb2EvP1dI2wykIqKWPPArngUSN5xy1gAq0qlJ0jqW0jUFZ
 2FXJIhNQLNc/H64S9+ev3YG6Ca1VLuqMbdX54r6JaFPZ+YPYqelcIHNYX62S2T+U7s+t
 8xWEHCxsEJt3LpqO39/q3j1pJ77jqCGRHX3CBJfQSzI8fw9kpL+cO02tHq3dbRH8mt+M
 T3dA==
X-Gm-Message-State: ANhLgQ152ShHAhqYt1Zl7hm29sxxQoiRSWA5Dhn8yz50TdFEyZ64IY8N
 QaTii5k+cHXwVC5fgOHQIQkFmz8Yi1eBc/O1k8M0ewsAwPjdzqWtWGQ30Y4MkBtKjS3rpv4WSyt
 zS0ZrsXA9kjVSPTN0fyR8vPkI
X-Received: by 2002:a5d:674f:: with SMTP id l15mr13381450wrw.196.1584992828073; 
 Mon, 23 Mar 2020 12:47:08 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtUWmDK4thpwexQ8hdryAgmCprB22NosAirhPOI+x5C3asXpfwyOua+gaEuAwr0M9NrGpUzvQ==
X-Received: by 2002:a5d:674f:: with SMTP id l15mr13381412wrw.196.1584992827855; 
 Mon, 23 Mar 2020 12:47:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24d8:ed40:c82a:8a01?
 ([2001:b07:6468:f312:24d8:ed40:c82a:8a01])
 by smtp.gmail.com with ESMTPSA id a186sm756486wmh.33.2020.03.23.12.47.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 23 Mar 2020 12:47:07 -0700 (PDT)
Subject: Re: [PATCH v3 2/9] KVM: x86: Move init-only kvm_x86_ops to separate
 struct
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
 <20200321202603.19355-3-sean.j.christopherson@intel.com>
 <87lfnr9sqn.fsf@vitty.brq.redhat.com>
 <20200323152909.GE28711@linux.intel.com>
 <87o8sn82ef.fsf@vitty.brq.redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <30b847cf-98db-145f-8aa0-a847146d5649@redhat.com>
Date: Mon, 23 Mar 2020 20:47:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87o8sn82ef.fsf@vitty.brq.redhat.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
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

On 23/03/20 17:24, Vitaly Kuznetsov wrote:
> Sounds cool! (not sure that with only two implementations people won't
> call it 'over-engineered' but cool). 

Yes, something like

#define KVM_X86_OP(name) .name = vmx_##name

(svm_##name for svm.c) and then

	KVM_X86_OP(check_nested_events)

etc.

> My personal wish would just be that
> function names in function implementations are not auto-generated so
> e.g. a simple 'git grep vmx_hardware_setup' works

Yes, absolutely; the function names would still be written by hand.

Paolo

> but the way how we
> fill vmx_x86_ops in can be macroed I guess.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
