Return-Path: <SRS0=VfsR=K6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9AE2C07E94
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 07:17:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 697D861415
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 07:17:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 697D861415
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0E0E4B0C9;
	Fri,  4 Jun 2021 03:17:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o27W0+dV1TYp; Fri,  4 Jun 2021 03:17:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 017214B0F4;
	Fri,  4 Jun 2021 03:17:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCE0C4B0CF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 03:17:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xRf8WoSS4nSz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jun 2021 03:17:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C005E4B0AC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 03:17:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1622791072;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=oYiGBrwOVwQzTkg4cxNvQnAUyjlM8dxbSVyQ8B6K+H0=;
 b=WKYjw6DZGss2e7ZfYX7/9cRExmJoSMrz340iRvQ4rWTeS8aMde8sFIDe5U8vxmtlB+LjK9
 nqxo17YV3+Vi1lTQHBO9BLyKSV9aQ6f5hic5ddfyGZbSvDDFn60vq8Ut1hVfGRoJ3whaJk
 +CnEmJ/yI+kZIe0W3Ot6DY6HAT8RMBs=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-DlqSMc4kOMKU_HfqLxKS2w-1; Fri, 04 Jun 2021 03:17:50 -0400
X-MC-Unique: DlqSMc4kOMKU_HfqLxKS2w-1
Received: by mail-ej1-f72.google.com with SMTP id
 am5-20020a1709065685b02903eef334e563so3050233ejc.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Jun 2021 00:17:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=oYiGBrwOVwQzTkg4cxNvQnAUyjlM8dxbSVyQ8B6K+H0=;
 b=P2Mdkwafqom3MlR358RV9MyC6ZowZjeHSTg7dNCM66JHsdHq2J7BD+H6kOs9S0rYFf
 /2E/5TNIpGbWpAwWkSGT8gV/9xDeF8ufSqAEoOuBRc06cLXutUVdyMPOddUePVZZ0mmo
 MPdGfTPpbOvEXss/B5Dxba3TshYjqr+YoNc0TCVlK8g3RYp/+T9a0ZQDykQUi+1YZInM
 Oc3LlZ5WPdBewKcVYg8GYOea6pF8vQybR9kn4goW2fszZ9Cc6kjMlEqtgd4QZWKKFagG
 WcxHF0s32U2R10ELAl3XtQOEIyOwaE8KD2ndq9OkWyduQrLFV1J+UOE9ktyDJG7qEgtp
 iXRQ==
X-Gm-Message-State: AOAM530eYL158D8yBbxvNc2hF2YTV3HcbkYyrIqOaWPBNGJ9qHhWGFTy
 rmfrbmsdG+2FI0M4Blaufdqj9C7HTEwTUIyBUxdQeMrvX5i8DnABNx13ED3vz8379eD5Tq/xzMj
 Q3LHiaEWk/hljmGdw07VX/Hf4
X-Received: by 2002:a17:906:1982:: with SMTP id
 g2mr2940216ejd.184.1622791069075; 
 Fri, 04 Jun 2021 00:17:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNA+cR803OKErcII3/XiBGdUlseY07tlmT5T9SKrsahaFVgc/V2SdsxWbxXtho/hDOs9RuiA==
X-Received: by 2002:a17:906:1982:: with SMTP id
 g2mr2940199ejd.184.1622791068902; 
 Fri, 04 Jun 2021 00:17:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id um5sm2430354ejb.109.2021.06.04.00.17.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 04 Jun 2021 00:17:48 -0700 (PDT)
Subject: Re: [RFC][PATCH] kvm: add suspend pm-notifier
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Peter Zijlstra <peterz@infradead.org>
References: <20210603164315.682994-1-senozhatsky@chromium.org>
 <YLkRB3qxjrXB99He@hirez.programming.kicks-ass.net>
 <YLl2QeoziEVHvRAO@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1a460c63-89d6-b7ae-657b-2c4b841c9562@redhat.com>
Date: Fri, 4 Jun 2021 09:17:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YLl2QeoziEVHvRAO@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: linux-s390@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Huacai Chen <chenhuacai@kernel.org>,
 linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Suleiman Souhlal <suleiman@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 04/06/21 02:39, Sergey Senozhatsky wrote:
>>>   
>>> +void kvm_arch_pm_notifier(struct kvm *kvm)
>>> +{
>>> +}
>>> +
>>>   long kvm_arch_vm_ioctl(struct file *filp,
>>>   		       unsigned int ioctl, unsigned long arg)
>>>   {
>> What looks like you wants a __weak function.
> True. Thanks for the suggestion.
> 
> I thought about it, but I recalled that tglx had  __strong opinions
> on __weak functions.
> 

Alternatively, you can add a Kconfig symbol to virt/kvm/Kconfig and 
select it from arch/x86/kvm.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
