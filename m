Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F31FC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 19:18:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 667144B0DB;
	Mon, 29 Nov 2021 14:18:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FlHnfXsNmt+O; Mon, 29 Nov 2021 14:18:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E4764B0AC;
	Mon, 29 Nov 2021 14:18:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9B834B08F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 14:18:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rRaW+MWMz2+N for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 14:18:54 -0500 (EST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com
 [209.85.208.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A84514B08E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 14:18:54 -0500 (EST)
Received: by mail-ed1-f46.google.com with SMTP id x6so76050701edr.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 11:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=b6e11+CJLAryPIw/7DDSWmANxwHaOEFVgPmI0eD1ehw=;
 b=Yv9EDK6h14i2Dbj+iAIYK0HlvK2JERVyMLo4AC4eEaaM5uGAacc8HtxG8w/Y/N1eKa
 zoqVyYrJgoymLJ79VszdPFvZOcROHF7XsZML04k5ATYUCAQQQYdmRFM1zliBw5sA+fUR
 rGCOh7Dkwc25orqYcXeHYn5++zj+NoIkUF+txgA7cbkgTIdSaLJPMhb1GiDwryyn0Wfc
 MU5Gbh+ysqRcMgmq6XO0rBfKo/INnGwUPA9nBrqjSM7nJ1s+plFGQd3Vr5vlky9IMZdn
 wkdyjWJAJzkiJ+6yukZdQ5xwMk5wTjTGyWuy1lXhP9nJ6WRZVyGbloAAqLRFAE+sHa2m
 tnMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=b6e11+CJLAryPIw/7DDSWmANxwHaOEFVgPmI0eD1ehw=;
 b=JX2xTc51cLxAx73uv7WU77rNDulYsCHihPZzi3zlClf7jHol6g7oZghhDHxcHmcFtw
 iXuFj3EO59YRpIGD2JaeHu95Kp8p6l6lYvsaVbNO5HENFB8eQ+DBTuZEiKWzD6HT/5xa
 MAByI0iUtHWXFxSPKDuZTph/wOU1aOxFmRj4CuCVKMAW8pFLENCA0wpDRP5gsFL2Axzy
 zdJcAunUHMN/mA4ze2XG+jlu1+RhnpjCD/QIKDOHfwkWe1LkhbtyW187XS2I07tSyott
 QM3xdguzUhSEAaa9G43Pn8X007VdqMgAPwDYdNHA5tot6Rxl5wrx3fpRyrW0rNdbKE9D
 GDeQ==
X-Gm-Message-State: AOAM5326zXuwB45jaUS6LnxX0eNgLztroF0BB2dAmgG6lgOrM7lo1n9Z
 ut7bo08HX4WM6Li6ck62A3dRkr4SMII=
X-Google-Smtp-Source: ABdhPJx2YJ0juUfs4Yk6vuSEcojrZsOKQtVYCvzwUVoRUJT0twH/9lzRN0MjKMCkmooXwTOepr8KsQ==
X-Received: by 2002:a17:906:c9d2:: with SMTP id
 hk18mr4315253ejb.523.1638213533689; 
 Mon, 29 Nov 2021 11:18:53 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.googlemail.com with ESMTPSA id ch28sm9615535edb.72.2021.11.29.11.18.51
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 29 Nov 2021 11:18:53 -0800 (PST)
Message-ID: <880a5727-69d1-72a1-b129-b053781625ad@redhat.com>
Date: Mon, 29 Nov 2021 20:18:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-12-seanjc@google.com>
 <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
 <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
 <YaUNBfJh35WXMV0M@google.com>
 <496c2fc6-26b0-9b5d-32f4-2f9e9dd6a064@redhat.com>
 <YaUiEquKYi5eqWC0@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YaUiEquKYi5eqWC0@google.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Maxim Levitsky <mlevitsk@redhat.com>,
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

On 11/29/21 19:55, Sean Christopherson wrote:
>> Still it does seem to be a race that happens when IS_RUNNING=true but
>> vcpu->mode == OUTSIDE_GUEST_MODE.  This patch makes the race easier to
>> trigger because it moves IS_RUNNING=false later.
> 
> Oh!  Any chance the bug only repros with preemption enabled?  That would explain
> why I don't see problems, I'm pretty sure I've only run AVIC with a PREEMPT=n.

Me too.

> svm_vcpu_{un}blocking() are called with preemption enabled, and avic_set_running()
> passes in vcpu->cpu.  If the vCPU is preempted and scheduled in on a different CPU,
> avic_vcpu_load() will overwrite the vCPU's entry with the wrong CPU info.

That would make a lot of sense.  avic_vcpu_load() can handle 
svm->avic_is_running = false, but avic_set_running still needs its body 
wrapped by preempt_disable/preempt_enable.

Fedora's kernel is CONFIG_PREEMPT_VOLUNTARY, but I know Maxim uses his 
own build so it would not surprise me if he used CONFIG_PREEMPT=y.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
