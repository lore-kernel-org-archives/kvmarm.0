Return-Path: <SRS0=qWZ6=PN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 471D6C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 15:57:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF80A60F6F
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 15:57:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AF80A60F6F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 446FA4B08E;
	Mon, 25 Oct 2021 11:57:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yaIlezAlARQw; Mon, 25 Oct 2021 11:57:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBF404B0DF;
	Mon, 25 Oct 2021 11:57:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E98FA4B08E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 11:57:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gaKHF6g9FplX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Oct 2021 11:57:45 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6973A4ACC9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 11:57:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635177465;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=MCI+8dQa/U6UbsL5gbfoLfO4WAaUcQYsMls2gbgANLc=;
 b=d5fBTafVsle7rlJGdQNqsXio/F72LOo2tQDiG5d8pnwkxANT5JCfW5IUfmH6YSz68+2OF2
 lAqa8X9kupvqCKBQnpBdImbNZ51Ze4GOgRx9pIDgn+blDJGJf+IJq2SdetOZO6PUGA7yLL
 C/y2qcIGdg5S5spV4/4PRPahunXd4rs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-ADF35c9PNGGyvNDOz0HFOQ-1; Mon, 25 Oct 2021 11:57:43 -0400
X-MC-Unique: ADF35c9PNGGyvNDOz0HFOQ-1
Received: by mail-wm1-f71.google.com with SMTP id
 s3-20020a1ca903000000b0032326edebe1so3685399wme.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 08:57:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=MCI+8dQa/U6UbsL5gbfoLfO4WAaUcQYsMls2gbgANLc=;
 b=SNPvdbITLxZB5o5AH6qJkNPJ9ArDpg4eVLgqJne9jcPEiRICs/lwjwd40vfYTIsng6
 wQLz59KDG8fMgX4jCg0jrW9Kz9Y6vn1I1yCvYVV/o2cqv66XDOkyPRIpROZ4vsd9c0af
 WnDibPhdPSX+e5FTXNEnKAkPo9M+eGK8GPNW4FQkmP+F8bUEVGLZpwEnZ8TWI1SQGZ7I
 MMLAx2pZKfVD9jgU+tuMocNRs3tWarF6p0IV9n8OeYCbtr75R/xCF8XYpCyKMcm/CFQ/
 ynepXKT51T7AX83R5t35HhJIz1YgysTLL6bBEVGWot8sgqjdeNSpn3ejvzBS8w42yk7j
 XqHg==
X-Gm-Message-State: AOAM530O6lf7tEnvEqWNfZOnGNPENpVpoEijvVIwtTouq8fnWylyXEYx
 1BnDX08WHvuVvkfk61yyngZ3OXyRj+M6XSpfGiXuVCXxEvJTNohzHuLkw2vd+7Xpw+9PJtcO7D/
 uJDICBvVfoDf66cLj/Zbe2lgp
X-Received: by 2002:a1c:ac86:: with SMTP id v128mr20601944wme.3.1635177462567; 
 Mon, 25 Oct 2021 08:57:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTyw0n0fr/6Esub1t61IkuBW8xshfxOi+C+/6mJQnqMkQEum3VdKMAAqawVcu+H74+uWZwJg==
X-Received: by 2002:a1c:ac86:: with SMTP id v128mr20601909wme.3.1635177462345; 
 Mon, 25 Oct 2021 08:57:42 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id q18sm19326723wmc.7.2021.10.25.08.57.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 25 Oct 2021 08:57:41 -0700 (PDT)
Message-ID: <e9509fb0-54f3-ca86-57b7-8b6d5de240b7@redhat.com>
Date: Mon, 25 Oct 2021 17:57:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 37/43] KVM: SVM: Unconditionally mark AVIC as running
 on vCPU load (with APICv)
To: Sean Christopherson <seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-38-seanjc@google.com>
 <acea3c6d-49f4-ab5e-d9fe-6c6a8a665a46@redhat.com>
 <YXbRyMQgMpHVQa3G@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YXbRyMQgMpHVQa3G@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Anup Patel <anup.patel@wdc.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
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

On 25/10/21 17:48, Sean Christopherson wrote:
> On Mon, Oct 25, 2021, Paolo Bonzini wrote:
>> On 09/10/21 04:12, Sean Christopherson wrote:
>>> +	/* TODO: Document why the unblocking path checks for updates. */
>>
>> Is that a riddle or what? :)
> 
> Yes?  I haven't been able to figure out why the unblocking path explicitly
> checks and handles an APICv update.
> 

Challenge accepted.  In the original code, it was because without it 
avic_vcpu_load would do nothing, and nothing would update the IS_RUNNING 
flag.

It shouldn't be necessary anymore since commit df7e4827c549 ("KVM: SVM: 
call avic_vcpu_load/avic_vcpu_put when enabling/disabling AVIC", 
2021-08-20), where svm_refresh_apicv_exec_ctrl takes care of the 
avic_vcpu_load on the next VMRUN.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
