Return-Path: <SRS0=qWZ6=PN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D897C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 14:26:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BFCBE60EE3
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 14:26:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BFCBE60EE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44CEB4B129;
	Mon, 25 Oct 2021 10:26:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X19+MIqELS+R; Mon, 25 Oct 2021 10:26:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2C194B08F;
	Mon, 25 Oct 2021 10:26:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 442F74B08A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 10:26:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SyI2oFKl4IWK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Oct 2021 10:26:14 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F6384ACC9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 10:26:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635171973;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=bye7ObUVwxXJ2WkSXV7ATW6vdQkdYkTKPDS9mWywO4k=;
 b=VG20wsfW81XXPKqAw5GP7sPzbhA4Uz7GMRjfobhJBnMpVfvvUHWtqpsDWNV2Ht62lM784j
 pmJYBcOfQP8oznAKfuriTSHgRiFZxel+Z5PdBLZkPiya2ceE8r5gdUcHnnS6TYFTDxslEe
 4hEwvDnnw9gXIQwLAumNBYRTW6lPNLM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-JsOVj5fQP0WKqs5E4FRIhw-1; Mon, 25 Oct 2021 10:26:12 -0400
X-MC-Unique: JsOVj5fQP0WKqs5E4FRIhw-1
Received: by mail-ed1-f69.google.com with SMTP id
 j17-20020aa7ca51000000b003dd395c0389so5232856edt.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 07:26:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=bye7ObUVwxXJ2WkSXV7ATW6vdQkdYkTKPDS9mWywO4k=;
 b=0IakIjSOLlIVCIj9FArwigvaPUXFUUtcLom0azo8C44JnWZE0Y9c8LC8Rx+Osqe9Tf
 LLKH4Bi4ju9t2PNMjnJQjly5CPKOFd4/JN19U6KWjSz7y95Syl7FDwaWScfFwgWsGbcj
 ZIbkN1BR0c2J0C7KzskrfrENy+wIUshkw86OLzYQ2hUSlNHYaIVtQkDr2Fuzhj1+xhDu
 y6QQDwVaKYVw6RfwEH77FTq+KRA761WvN4epmiULsv961Y1Qwc/5puBU8qzVOTyw1kR0
 KXDE8+bqsMn1TXEFMRwmVm8pQr1aAEh3JZ825syKXXEnMVzIn4fBb4v8gVsty6ChQeCu
 QokQ==
X-Gm-Message-State: AOAM531LkETV1TzTAPz3JawRDdFWzFaddXau2ka2TXb63tAv7NvgU6r6
 zkJzUPCei8eImmkGYGVKNLpuYnNJTvZQRbm4ZqYWPAeB6XHfmpRJuE42esnfiYXiR8QISEapDoH
 UCLoChYOzPWVO8Fg+/b5XDVQI
X-Received: by 2002:a17:906:c0cf:: with SMTP id
 bn15mr21819130ejb.54.1635171971316; 
 Mon, 25 Oct 2021 07:26:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1tQyM0wVdwMUOMrIgmjrbrmjI7F4R9FGcgAmNEuZGC3NNZA+IU7BqgOO63yxAXGZ3HmbepA==
X-Received: by 2002:a17:906:c0cf:: with SMTP id
 bn15mr21819096ejb.54.1635171971137; 
 Mon, 25 Oct 2021 07:26:11 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id g14sm5171403edp.31.2021.10.25.07.26.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 25 Oct 2021 07:26:10 -0700 (PDT)
Message-ID: <0072221e-02e8-4d60-9b0f-80d8c423bf4e@redhat.com>
Date: Mon, 25 Oct 2021 16:26:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 16/43] KVM: Don't redo ktime_get() when calculating
 halt-polling stop/deadline
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Anup Patel <anup.patel@wdc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-17-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-17-seanjc@google.com>
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
> Calculate the halt-polling "stop" time using "cur" instead of redoing
> ktime_get().  In the happy case where hardware correctly predicts
> do_halt_poll, "cur" is only a few cycles old.  And if the branch is
> mispredicted, arguably that extra latency should count toward the
> halt-polling time.
> 
> In all likelihood, the numbers involved are in the noise and either
> approach is perfectly ok.

Using "start" makes the change even more obvious, so:

     Calculate the halt-polling "stop" time using "start" instead of redoing
     ktime_get().  In practice, the numbers involved are in the noise (e.g.,
     in the happy case where hardware correctly predicts do_halt_poll and
     there are no interrupts, "start" is probably only a few cycles old)
     and either approach is perfectly ok.  But it's more precise to count
     any extra latency toward the halt-polling time.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
