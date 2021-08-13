Return-Path: <SRS0=HTLS=NE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F58C4338F
	for <kvmarm@archiver.kernel.org>; Fri, 13 Aug 2021 10:44:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D1AB610CC
	for <kvmarm@archiver.kernel.org>; Fri, 13 Aug 2021 10:44:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5D1AB610CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B806D4020A;
	Fri, 13 Aug 2021 06:44:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kGGgoE1V7RZC; Fri, 13 Aug 2021 06:44:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0F024086D;
	Fri, 13 Aug 2021 06:44:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 356AA4029F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 06:44:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C6NwLf7CiPIv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Aug 2021 06:44:31 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53B5B4020A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 06:44:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628851471;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=CCRKNaL8rUMbzILuCY+AB0BP3lwlD4VuYd7MDG+p8TM=;
 b=XgVZGXYYGNr1GMR4AMqNeGXB0sdMy1O9Zxt343adCz4JJYmafc9+qzKjld8shxomEALTS1
 xposwu/QJXiPDkr1ZWzY8rpePhQdBtYhWrcD23rdgEpdgGNoW9ocLV7v817EiptkO49JL4
 UfEhAwzwwi3qW0Kti2IzU3/bEi8DwJk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-BfUwsVV0Nt-PJBZky89BSA-1; Fri, 13 Aug 2021 06:44:29 -0400
X-MC-Unique: BfUwsVV0Nt-PJBZky89BSA-1
Received: by mail-ed1-f70.google.com with SMTP id
 p2-20020a50c9420000b02903a12bbba1ebso4653596edh.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 03:44:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=CCRKNaL8rUMbzILuCY+AB0BP3lwlD4VuYd7MDG+p8TM=;
 b=IcP3Gxz8M3JI/ehxHdj06kUfibw2MhQTCEegnViRKpbA1VV7bxZZ8/8/yfdOnbSJUa
 0dTzONzRol7WZb6Mxtb5oHVD9fb9DyQgVjeGZP43CpTccwwJoLD5ks2fTgQTRzOQPCWi
 d8ZgRXS9s682/hsJEYm8SGruAoz29Oo4MbGobMJR37tyRLT5qvgEdh58OZjZqlEINHu6
 8bvIKVZlxlf78pCiErbtuZ7dc6u+qEXUq0XHljz0zvxbGp/GroJI7wNFRuUDhgqHnN0R
 cFru3BbN+EAiaZLetOvoFPgSPhvaiCUYsb69NHB+sGz0/JMtZUNrI9SwOgDrLl+Yqpr0
 kP2g==
X-Gm-Message-State: AOAM530uLYN7qWLUQXV5HzD/j4o7gkWXdUytUV5vm2dRbnQtd451OCS3
 TMBCi+eC8WiuQYbTsIV4sTi6nrqybApZgA0bjx2J1osLOdK+BuQTsBvVPJ0MewaG/DjqYeImVio
 xdF6HuIjlbniSwA8YkNm1bAGt
X-Received: by 2002:a17:906:6b0c:: with SMTP id q12mr141885ejr.0.1628851468596; 
 Fri, 13 Aug 2021 03:44:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbOi0KwA+drc3M+Egn5GSdsceHGVvGcEGdWBkM4ljas5GpNbvsJOOdudbDSGWUVsAACOZz2w==
X-Received: by 2002:a17:906:6b0c:: with SMTP id q12mr141872ejr.0.1628851468394; 
 Fri, 13 Aug 2021 03:44:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id m19sm484596edd.38.2021.08.13.03.44.26
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 13 Aug 2021 03:44:27 -0700 (PDT)
Subject: Re: [PATCH v6 01/21] KVM: x86: Fix potential race in KVM_GET_CLOCK
To: Oliver Upton <oupton@google.com>
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-2-oupton@google.com>
 <78eeaf83-2bfa-8452-1301-a607fba7fa0c@redhat.com>
 <CAOQ_QsiwzKpaXUadGR6cWC2k0pg1P4QgkAxNdo0gpVAP1P3hSQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b415872-7a67-d38b-ae01-62c38b365be0@redhat.com>
Date: Fri, 13 Aug 2021 12:44:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAOQ_QsiwzKpaXUadGR6cWC2k0pg1P4QgkAxNdo0gpVAP1P3hSQ@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
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

On 13/08/21 12:39, Oliver Upton wrote:
> Might it make sense to fix this issue under the existing locking
> scheme, then shift to what you're proposing? I say that, but the
> locking change in 03/21 would most certainly have a short lifetime
> until this patch supersedes it.

Yes, definitely.  The seqcount change would definitely go in much later. 
  Extracting KVM_{GET,SET}_CLOCK to separate function would also be a 
patch of its own.  Give me a few more days of frantic KVM Forum 
preparation. :)

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
