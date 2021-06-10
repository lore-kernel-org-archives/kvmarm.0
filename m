Return-Path: <SRS0=KFVQ=LE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6489DC47094
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 06:26:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C98D8613CB
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 06:26:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C98D8613CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DCD549E8C;
	Thu, 10 Jun 2021 02:26:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id efPkLs50VvQm; Thu, 10 Jun 2021 02:26:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31A4840878;
	Thu, 10 Jun 2021 02:26:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA34540878
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 02:26:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gogd1HNxLYj1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jun 2021 02:26:08 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C640540874
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 02:26:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623306360;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=VGs+0yvbM3aZSFiSqmWvFiKGejTxJX5EbFXyaERoXAM=;
 b=QGeBaRSlgfvoHJURMW7y3HJ9bj2Gr/pgz8QKBxMZGr8QJfcWTUJHw8jXj4ogMntwIvZcYL
 X4qPYaG65S6XFzlQFT1Ycfptuylf4lPYuIL0t/JdPLwbYxI52HD25aJPZ6fH3B9gVLPbzl
 FmGgrcWTWdlqMhiCuTh/n7ZpMUQe9DY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-Zz9jhI0APbGUv6cl3XL6Iw-1; Thu, 10 Jun 2021 02:26:07 -0400
X-MC-Unique: Zz9jhI0APbGUv6cl3XL6Iw-1
Received: by mail-wr1-f69.google.com with SMTP id
 l13-20020adfe9cd0000b0290119a0645c8fso407311wrn.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Jun 2021 23:26:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=VGs+0yvbM3aZSFiSqmWvFiKGejTxJX5EbFXyaERoXAM=;
 b=fSFG30X/quSIVOY5g0yBan5xY8kGD9tkMxsw46OdPI2z0qOp1xAI2ESm5k0B8NZMlZ
 r3zblBymo+mBjSTxO6ysrBJXjcNxI9UlokgD48fkYLG5ZOQ5jWfPqaiH3zCBVoN98B+W
 qEtcqb8WJyjXVv8qGUmdVXmaKdk0g6fzOuQAZhCgoc1ArcTNcpXWJh53z8sIIMJoC9mh
 F9IJ1HL3h2PEb4HNWYH0sr2AtpK1MOBHur9sX6a3NjtW5k01gRkICiSfbpICk8RcL4aL
 fTd1jKLHaNpWNkd6vfy0dblMehSaqnaDJf97NnDh5cp4gcYPbXbyiRvF+CKACLO4tbUI
 t1FA==
X-Gm-Message-State: AOAM530bsHSEL2d4HO2OByx7XHH9iiXcX+xrAkOe0XNEf652ZopGX78d
 5NW7wmGgr7z3WNnS5XISEXz2S1MyWPYLpUbg91OqDwx9JBf3X+4/X6864phUY4HM5ROi2XH2sEi
 I1YIXCgL5+Aq9jODiSjqxFpQg
X-Received: by 2002:a05:6000:1542:: with SMTP id 2mr3538355wry.4.1623306366273; 
 Wed, 09 Jun 2021 23:26:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBGG55buqU3+VfqpCmTr0MOmTfLZq6Ft4s83qkvKAaEg+eogzlxEYnXIApfOL9adnMCh2brA==
X-Received: by 2002:a05:6000:1542:: with SMTP id 2mr3538326wry.4.1623306366038; 
 Wed, 09 Jun 2021 23:26:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id k16sm1840159wmr.42.2021.06.09.23.26.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Jun 2021 23:26:05 -0700 (PDT)
Subject: Re: [PATCH 02/10] KVM: arm64: Implement initial support for
 KVM_CAP_SYSTEM_COUNTER_STATE
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
References: <20210608214742.1897483-1-oupton@google.com>
 <20210608214742.1897483-3-oupton@google.com> <877dj3z68p.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9c5f19f9-b303-573a-aa2a-cf5a91110db8@redhat.com>
Date: Thu, 10 Jun 2021 08:26:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <877dj3z68p.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
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

On 09/06/21 12:23, Marc Zyngier wrote:
>> Implement initial support for KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls
>> to migrate the value of CNTVOFF_EL2. These ioctls yield precise control
>> of the virtual counter-timers to userspace, allowing it to define its
>> own heuristics for managing vCPU offsets.
> I'm not really in favour of inventing a completely new API, for
> multiple reasons:
> 
> - CNTVOFF is an EL2 concept. I'd rather not expose it as such as it
>    becomes really confusing with NV (which does expose its own CNTVOFF
>    via the ONE_REG interface)
> 
> - You seem to allow each vcpu to get its own offset. I don't think
>    that's right. The architecture defines that all PEs have the same
>    view of the counters, and an EL1 guest should be given that
>    illusion.
> 
> - by having a parallel save/restore interface, you make it harder to
>    reason about what happens with concurrent calls to both interfaces
> 
> - the userspace API is already horribly bloated, and I'm not overly
>    keen on adding more if we can avoid it.
> 
> I'd rather you extend the current ONE_REG interface and make it modal,
> either allowing the restore of an absolute value or an offset for
> CNTVCT_EL0. This would also keep a consistent behaviour when restoring
> vcpus. The same logic would apply to the physical offset.

What about using KVM_GET/SET_DEVICE_ATTR?  It makes sense that the guest 
value for nested virt goes through ONE_REG, while the host value goes 
through DEVICE_ATTR.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
