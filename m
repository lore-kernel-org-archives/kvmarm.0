Return-Path: <SRS0=qWZ6=PN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D49C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 13:48:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DF72A60FBF
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 13:48:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DF72A60FBF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 424934B17B;
	Mon, 25 Oct 2021 09:48:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X0hUCov7MoxI; Mon, 25 Oct 2021 09:48:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86CF34B125;
	Mon, 25 Oct 2021 09:48:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FFAE4B0FB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 09:48:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e7YTq26e6y3R for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Oct 2021 09:48:27 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1D024B0E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 09:48:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635169707;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=rAI1rvJIZVwx71e91km04CwkX5jtmNRsQSKYM+y4LQM=;
 b=OgQfAz+Et8aZ/5O33dzEdbXp8BUTPmUcX5F+31gv6aKDvDxnkwmItPTmmvvfGUKTsSHBq9
 gdK0ph45qeMBAviBHi3be2NNQarH3w4vYJinKumaczCmbDSaL+WtpOfCJ1rY6s2H0tAsqM
 vkxd0pTeaCZ3oEzYOx7dBqs1pPettVk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-_EKAYdJ5MRmFhc0PfOgeSg-1; Mon, 25 Oct 2021 09:48:24 -0400
X-MC-Unique: _EKAYdJ5MRmFhc0PfOgeSg-1
Received: by mail-wr1-f69.google.com with SMTP id
 d13-20020adf9b8d000000b00160a94c235aso3252926wrc.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 06:48:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=rAI1rvJIZVwx71e91km04CwkX5jtmNRsQSKYM+y4LQM=;
 b=e9rajMcyqorXRaH8DIwMNt0ZRHDP2X8EGuv01fUid3IQjtRWvFuMZ18GnqBmKGaDLW
 C1Gdlay8/bM0uGOxLGnFrduCVe2dJSzKnuKxorgkFn/0hXqML++ILUw45iTIyVwvJdin
 2Pp/ofSG5JHOWihZCed1sXakJXoUkIpqs3t1/Vz4480fQgxMK6IIvtD/db4quWrcB56y
 A+j8JpcrgX6bXDzV3e1iW4lSUx2NDAZNMB6Fettms0Hg2FOF1NwnBmydQKAcJi20U4jE
 MGwRis/gz+VX3GShSUcIakF3VlDe2U5Vp0r5ds3SR09sbrr2AXG/sjjr4ikEp/eMbC5K
 yb2A==
X-Gm-Message-State: AOAM531l7bMedKjwAk17Vyf++as43t/Ob1KJcY5TFdSdF6k7ZqlkEzKF
 sK3vz4nlt/Tkf+a2qi51vxH+dR0K2Ew2GyKHf9o9a76zthid57EuvnqvB1NqMzo71RELgJnRyLD
 uCBKRmC6yQ7Ab5OPvscwLEvHT
X-Received: by 2002:adf:d1ee:: with SMTP id g14mr24355638wrd.264.1635169703594; 
 Mon, 25 Oct 2021 06:48:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvh4UiZag1iqCL0Yxmhmh7ghHaPzeCY1G7nZe+NYuublJxNb7HJYi3GJafbpt4P4VqHirR5w==
X-Received: by 2002:adf:d1ee:: with SMTP id g14mr24355558wrd.264.1635169703285; 
 Mon, 25 Oct 2021 06:48:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id m12sm3661638wrq.69.2021.10.25.06.48.21
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 25 Oct 2021 06:48:22 -0700 (PDT)
Message-ID: <1537b693-80ee-4f9e-2c4e-6e1c62ccca92@redhat.com>
Date: Mon, 25 Oct 2021 15:48:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 20/43] KVM: VMX: Skip Posted Interrupt updates if APICv
 is hard disabled
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Anup Patel <anup.patel@wdc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-21-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-21-seanjc@google.com>
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

On 09/10/21 04:12, Sean Christopherson wrote:
> +	/* Nothing to do if PI.SN==0 and the vCPU isn't being migrated. */
>   	if (!pi_test_sn(pi_desc) && vcpu->cpu == cpu)
>   		return;

This does not quite say "why", so:

         /* Nothing to do if PI.SN and PI.NDST both have the desired value. */

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
