Return-Path: <SRS0=qWZ6=PN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A68C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 13:22:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E96B6054F
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 13:22:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8E96B6054F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED00E4B173;
	Mon, 25 Oct 2021 09:22:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XOjuoDYpxNgS; Mon, 25 Oct 2021 09:22:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 503BB4B131;
	Mon, 25 Oct 2021 09:22:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 040A34B10B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 09:22:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hSmBkXGlM7Gi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Oct 2021 09:22:09 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E16574B0C5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 09:22:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635168129;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=48+IikSlKyqTNmxyr4q4VEcqSYZJGRNhdXCK/IFcjJk=;
 b=KE/riBNfAXvmdioUpEupdNXCo16fRq3CU6y433SjTnpscTb3trlrymitszXrkgp+SEiGpy
 IGGDdOs7tgVpF7D1koLvgvjkFQKxcb+ae8BAvfZAtAiPQnnSY7t0w4DQ9M14UID9quLJ6O
 qMkZ0+yPB8SV6/WH/73VfrMRwVbUjyY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-I0x6-kNNNp6OZrYe0FyNDg-1; Mon, 25 Oct 2021 09:22:08 -0400
X-MC-Unique: I0x6-kNNNp6OZrYe0FyNDg-1
Received: by mail-ed1-f69.google.com with SMTP id
 g6-20020a056402424600b003dd2b85563bso7176785edb.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 06:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=48+IikSlKyqTNmxyr4q4VEcqSYZJGRNhdXCK/IFcjJk=;
 b=EilzZwmMyGKuQLIMtb6Tn39OmlD/++uDr97C8PXiZZZAkKOsyHdk2QW7Y6fqJ0RiQF
 uZ43oPolFAufV+Uts8sdLVhRXNbQMWEFhLknso/57IPFGON2hzWJ9YPt8PlQnIZT/6fv
 xChkq3XBawVt53R71aNF5oqo9dA7gD5G/0EUvODnJIzPQO6VDY5pUSk/H+g4aSGqey+m
 DhXEfZHlLwX3/QIvh2bG8+aQesmse/YMh6RQOBRzL3V7jG0qd+N2BtjPKJ9ydoiZAs91
 0T9c9/LLETpazt5g/nJbbHun/W6F3ItDioVWQ37TvfyqKJPiSqiqSmfHAiQcvPpIIiDc
 l/ug==
X-Gm-Message-State: AOAM532wb6Tqo00TIoXMs1rzqfK39MPFtXV8gmD82/jU2rZ8RSqj48nF
 SDBUNBIT0egEhs0l1PwWkUdJ+Dq79qafHVj/TbiXq2idPbn/hDmJB2SCWmBFIgNoaJKzxxqjUNz
 oSEbGprKVV/46Mq5unCsVm2/j
X-Received: by 2002:a50:d783:: with SMTP id w3mr20253048edi.380.1635168126980; 
 Mon, 25 Oct 2021 06:22:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfRKsXz9JGMpnMaISmnOtZN3rndX1G8rsIOCD7EyDtzp44dz76SyjuCafVUoIKeNPaL6dxIA==
X-Received: by 2002:a50:d783:: with SMTP id w3mr20253015edi.380.1635168126752; 
 Mon, 25 Oct 2021 06:22:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id j15sm9152968edl.34.2021.10.25.06.22.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 25 Oct 2021 06:22:06 -0700 (PDT)
Message-ID: <e360d085-8fba-e8de-b65e-fc7a4e13ad7b@redhat.com>
Date: Mon, 25 Oct 2021 15:21:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 02/43] KVM: SVM: Ensure target pCPU is read once when
 signalling AVIC doorbell
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Anup Patel <anup.patel@wdc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-3-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-3-seanjc@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 09/10/21 04:11, Sean Christopherson wrote:
> +		 * point, which could result in signalling the wrong/previous
> +		 * pCPU.  But if that happens the vCPU is guaranteed to do a
> +		 * VMRUN (after being migrated) and thus will process pending
> +		 * interrupts, i.e. a doorbell is not needed (and the spurious)

... one is harmless, I suppose.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
