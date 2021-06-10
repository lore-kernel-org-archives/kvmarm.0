Return-Path: <SRS0=KFVQ=LE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F9DC47094
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 06:55:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 412F5613E2
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 06:55:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 412F5613E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A686E49E93;
	Thu, 10 Jun 2021 02:55:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kBv91Ck5D3VJ; Thu, 10 Jun 2021 02:55:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 803EB407EF;
	Thu, 10 Jun 2021 02:55:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62BC4407EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 02:55:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pbSiuhsUFGj0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jun 2021 02:55:01 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70D4F40617
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 02:55:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623308101;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=/GOWHlANnDBXMOgWQ7qYUSqp48aMNk3hEFsxwtf6GI4=;
 b=TO8jILrxWW5ZGj/hlrnDofkeMp9hHJch6CSji+/btUu+SAqNYwdL1qea6RTHEOLC9E9RL0
 ay2TyInr75okGqI9hOSOoM6DqhzycBnsQu7N6W2txFmflg5/3k9nICUSN+ko/kP/UCfqbI
 M7/fjBwQxR3fCy1OcHNCZQP2q5FmOEI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-3VIEf6kiNqeEm_GcoWV2nw-1; Thu, 10 Jun 2021 02:54:59 -0400
X-MC-Unique: 3VIEf6kiNqeEm_GcoWV2nw-1
Received: by mail-wr1-f71.google.com with SMTP id
 v15-20020a5d4a4f0000b0290118dc518878so439694wrs.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Jun 2021 23:54:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=/GOWHlANnDBXMOgWQ7qYUSqp48aMNk3hEFsxwtf6GI4=;
 b=bEFOgus7n+tiK554DttiJ5e5dHmzsp6a0NC/Z7Eeb1Qw89RrwD6iP5xVFsiLYMOaIp
 4pTqsWlfzgDpPmMy1GDFOlFjzvIKZJ5xrKBPu22XKxtu7Ckq9ujCXCUA3g2lrI92bpIH
 vOp9MUApb4tEmRCCWNSyDP1mnHHupS5S3Skczniw3/dqI1xJ4dxKHXybuoTzLswboIJ5
 nX9V5dfLQv9GJ2NeQADrakkEeNu2uULMUysbmo7IkKkDshiLiwU8ciOzgoEA6K1a6MJf
 08cQcrGPCEb1QnNnqZMy87js2j0jqRjWnnguYxJCslbhXDVbgjE5azU1iFfwC0VT9XVc
 Rh8g==
X-Gm-Message-State: AOAM533bju33+72EmcrasUqS6zAFabGuHNqxAjSuqc+C3VELqDjDOelY
 sLmLQ2faUrJHu6uslntxmIbWqj7x9ENY4zN5xAznGDlH6S0qdlHInHr3BhaM1MPrNflsgqslweH
 cXokVexmXx+f0yFWUA67gUVrd
X-Received: by 2002:a5d:64c7:: with SMTP id f7mr3541382wri.36.1623308098566;
 Wed, 09 Jun 2021 23:54:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHulzoaGG46GCG3Zz8U85n2skBqB8M0q5MPNAlPWi9ft6Enx/RPu1WvPDXG/UOusNXSWsxiQ==
X-Received: by 2002:a5d:64c7:: with SMTP id f7mr3541358wri.36.1623308098404;
 Wed, 09 Jun 2021 23:54:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id l3sm2026815wmh.2.2021.06.09.23.54.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Jun 2021 23:54:57 -0700 (PDT)
Subject: Re: [PATCH 02/10] KVM: arm64: Implement initial support for
 KVM_CAP_SYSTEM_COUNTER_STATE
To: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>
References: <20210608214742.1897483-1-oupton@google.com>
 <20210608214742.1897483-3-oupton@google.com> <877dj3z68p.wl-maz@kernel.org>
 <CAOQ_QsgobctkqS5SQdqGaM-vjH7685zGPdDXZpcOCS8xWJxegA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <624ab379-b7f1-9753-81f7-d813faa25978@redhat.com>
Date: Thu, 10 Jun 2021 08:54:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOQ_QsgobctkqS5SQdqGaM-vjH7685zGPdDXZpcOCS8xWJxegA@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm list <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
 Peter Shier <pshier@google.com>, Raghavendra Rao Anata <rananta@google.com>,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
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

On 09/06/21 16:51, Oliver Upton wrote:
>> - You seem to allow each vcpu to get its own offset. I don't think
>>    that's right. The architecture defines that all PEs have the same
>>    view of the counters, and an EL1 guest should be given that
>>    illusion.
> Agreed. I would have preferred a VM-wide ioctl to do this, but since
> x86 explicitly allows for drifted TSCs that can't be the case in a
> generic ioctl. I can do the same broadcasting as we do in the case of
> a VMM write to CNTVCT_EL0.
> 

If you use VM-wide GET/SET_DEVICE_ATTR, please make it retrieve the host 
CLOCK_REALTIME and counter at the same time.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
