Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF340C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 21 Apr 2022 16:37:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6940E49F13;
	Thu, 21 Apr 2022 12:37:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VPK0kEl88Svi; Thu, 21 Apr 2022 12:37:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 555ED4B1FC;
	Thu, 21 Apr 2022 12:37:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1D014B1D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:37:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id shYemI0kGunx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 12:37:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90D9149F13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:37:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1650559072;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=brgeju7NODhN/2dLIKQ/IUJ0B+QHaX9FBW60LEyuxpw=;
 b=g5HhzwzLkYARRJTuroHs4ILD2WekEzvIBN0rZc0waA3+ia8Vrp4rdqFMp6HlXTKEDd+P3i
 o0c6lqUIW27fbRuHnQteZ7wAYYy8m/mhyP8lOcEmWhG223UKz4Y2gbTJ3xUxnNd2uMqt9j
 n99VdYxmebfrwgriR/5aLyO7Q5h+3hg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-e8mZ83gJNy6tsG28Vdp-5g-1; Thu, 21 Apr 2022 12:37:50 -0400
X-MC-Unique: e8mZ83gJNy6tsG28Vdp-5g-1
Received: by mail-wm1-f70.google.com with SMTP id
 n4-20020a1ca404000000b00392b49c7ae3so1121076wme.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 09:37:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=brgeju7NODhN/2dLIKQ/IUJ0B+QHaX9FBW60LEyuxpw=;
 b=Utxo4v39kF9iI/bEQ0RfoiNVQZ9hmJvqUM3NdJ6lUZh42vVILxHFoyUh7J+zmcXsNj
 nbFBkcATNCOTAcJS/vF6raA/Kv50ynUFxyLCqwHE5FJfHVqbfsgsubD0CtS/c5VPAjgn
 GAXyi5e/bZrnT5+7USUp+qScp6zSPc+jqw6tsiVKrKzcIkJeqVtd9laSiBt0ShEcqTu8
 p2DNnemU4Q7J19xkQG0mgF87+kVxLHQp41BVTN1BagPQvLGWASX9aUMGReC8CKngUfhD
 y7jLNSjgme0QbxW7KOI5YYGmjZZykbXsVHT9NrU8ksGc7Bc6Oj89baRI7yS1NaK53IZs
 gVkQ==
X-Gm-Message-State: AOAM531A98p4ML7op8xaj0l620t6QxeqTSiVJBmw729XMG7zQoNt1e5E
 L++5GLAAQ5Gz73f7UlsyEWYI6TGVYViQZYUEUPFIKf7CtFj5Q8ybrK0lCjaAUtq/bn8z3p1gAGM
 XoqVkQYavN0Sm2c6OhkaXbeoN
X-Received: by 2002:a7b:c384:0:b0:38e:6b47:58c4 with SMTP id
 s4-20020a7bc384000000b0038e6b4758c4mr9375216wmj.134.1650559069622; 
 Thu, 21 Apr 2022 09:37:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvIVdBeolfle0+MQhnrKJDPjFQuSaQU4IprZ5TNOACBXAXD4rsWSDLK/lc/MIeOlpdQg3O+A==
X-Received: by 2002:a7b:c384:0:b0:38e:6b47:58c4 with SMTP id
 s4-20020a7bc384000000b0038e6b4758c4mr9375186wmj.134.1650559069366; 
 Thu, 21 Apr 2022 09:37:49 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.googlemail.com with ESMTPSA id
 c3-20020a05600c148300b0038ebc8ad740sm2812873wmh.1.2022.04.21.09.37.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 21 Apr 2022 09:37:48 -0700 (PDT)
Message-ID: <bf1ba747-ee89-35b4-7095-eafa91536b4e@redhat.com>
Date: Thu, 21 Apr 2022 18:37:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [RFC PATCH 00/17] KVM: arm64: Parallelize stage 2 fault handling
To: Ben Gardon <bgardon@google.com>, Oliver Upton <oupton@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <CANgfPd8V5AdH0dEAox2PvKJpqDrqmfJyiwoLpxEGqVfb7EEP9Q@mail.gmail.com>
 <CAOQ_QsieUXOFXLkZ=ya0RUpU8Mv2sd9hmskwEW99tH26cjjX_A@mail.gmail.com>
 <CANgfPd80wTYX92Q9dP7irMdZW+Y0_VNFQ19xJaf5DvndEaa7dw@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CANgfPd80wTYX92Q9dP7irMdZW+Y0_VNFQ19xJaf5DvndEaa7dw@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel@lists.infradead.org
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

On 4/21/22 18:30, Ben Gardon wrote:
> Completely agree. I'm surprised that ARM doesn't have a need for a
> metadata structure associated with each page of the stage 2 paging
> structure, but if you don't need it, that definitely makes things
> simpler.

The uses of struct kvm_mmu_page in the TDP MMU are all relatively new, 
for the work_struct and the roots' reference count.  sp->ptep is only 
used to in a very specific path, kvm_recover_nx_lpages.

I wouldn't be surprised if ARM grows more metadata later, but in fact 
it's not _that_ surprising that it doesn't need it yet!

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
