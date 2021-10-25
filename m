Return-Path: <SRS0=qWZ6=PN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A61C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 14:01:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 76AFC60F9B
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 14:01:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 76AFC60F9B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2ED14B15A;
	Mon, 25 Oct 2021 10:01:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IeCerDgM7S+W; Mon, 25 Oct 2021 10:01:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A27B4B0B9;
	Mon, 25 Oct 2021 10:01:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDE584B0B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 10:01:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9DSKoi3mzO27 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Oct 2021 10:01:48 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 739B74B0B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 10:01:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635170508;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5GxuWusEjMHZ4JQn5qLWUyg1MyGQPS66ltUGy4HnHFU=;
 b=LTAJJXA6gfcvH8FfYagOIEjcLjtfU1pf6A1jqzc9+E74Nzq4xvgT/emRiNrwGpl7EeuaZG
 rxMUo8rjBjFRlw1ujqmRYrN8yaly/emG/PCs4jUIsivvieTF3mvRkJFgXU3CWw2VIHMg+V
 IBTgj3rYwZXMbdSyiBwwtz/OPhEVtfA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-LsAdj3JmP9G0zH6gEWKtNA-1; Mon, 25 Oct 2021 10:01:46 -0400
X-MC-Unique: LsAdj3JmP9G0zH6gEWKtNA-1
Received: by mail-wr1-f72.google.com with SMTP id
 v15-20020adfa1cf000000b00160940b17a2so3234172wrv.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 07:01:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=5GxuWusEjMHZ4JQn5qLWUyg1MyGQPS66ltUGy4HnHFU=;
 b=LAqocajIt/+ysOrOn4LWmWPgEBMNC7vVK+8VhJeM66LnpmbxStfhciTQYkA8ZDQhLX
 JWnTSpOUMiPSdKw3IskvGmmrGQE4x+I6Rq1UrV0SdxSnv+XnAS5Df659nO6nX1mn43mW
 76tcfhMRIrrzOPRCfrtx1HvzsAOgaJ1X04lr/2uK/D2fR1FknMMzYoKAhEW8wfkBiFO9
 RqYjmQZUD4TkIlt/a+ipOfXMc+d+ziQP5m5ehtTsX24UW6pMDR6qInVyJyIZ4sIzyvFa
 3giUoEQrwfZbsVO2oG58DK3pvvVVKqgVCewf9g6iSHMzDVykmAHQrq9UhTrrvLkHDmw0
 epXg==
X-Gm-Message-State: AOAM5308HZlgaDO83g8iIc7AaQ8dJ6qpEJqoPJxQ+jlptmg4qvmMDDHS
 +KUGS3wdQrC9i37Gy9yJRhFGwdTwk2ejKjIYRJ17sj8jWAzNgNFK5ca/LEXjE6Z43xm9NaV1HIH
 R4qf/YvaAet1wkT/lb2jI6axE
X-Received: by 2002:a5d:59ae:: with SMTP id p14mr23589897wrr.76.1635170505454; 
 Mon, 25 Oct 2021 07:01:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiqFlcSYWH7tg/r7nyk/acEU7XFm6PKMcaIfNQ0d2l1GPzyRzlNJCdOi1PnQIqdfTr2oUQaw==
X-Received: by 2002:a5d:59ae:: with SMTP id p14mr23589820wrr.76.1635170505123; 
 Mon, 25 Oct 2021 07:01:45 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id x2sm5765371wmj.3.2021.10.25.07.01.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 25 Oct 2021 07:01:44 -0700 (PDT)
Message-ID: <18e6a656-f583-0ad4-6770-9678be3f5cf4@redhat.com>
Date: Mon, 25 Oct 2021 16:01:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 24/43] KVM: VMX: Drop pointless PI.NDST update when
 blocking
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Anup Patel <anup.patel@wdc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-25-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-25-seanjc@google.com>
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
> Don't update Posted Interrupt's NDST, a.k.a. the target pCPU, in the
> pre-block path, as NDST is guaranteed to be up-to-date.  The comment
> about the vCPU being preempted during the update is simply wrong, as the
> update path runs with IRQs disabled (from before snapshotting vcpu->cpu,
> until after the update completes).

Right, it didn't as of commit bf9f6ac8d74969690df1485b33b7c238ca9f2269 
(when VT-d posted interrupts were introduced).

The interrupt disable/enable pair was added in the same commit that 
motivated the introduction of the sanity checks:

     commit 8b306e2f3c41939ea528e6174c88cfbfff893ce1
     Author: Paolo Bonzini <pbonzini@redhat.com>
     Date:   Tue Jun 6 12:57:05 2017 +0200

     KVM: VMX: avoid double list add with VT-d posted interrupts

     In some cases, for example involving hot-unplug of assigned
     devices, pi_post_block can forget to remove the vCPU from the
     blocked_vcpu_list.  When this happens, the next call to
     pi_pre_block corrupts the list.

     Fix this in two ways.  First, check vcpu->pre_pcpu in pi_pre_block
     and WARN instead of adding the element twice in the list.  Second,
     always do the list removal in pi_post_block if vcpu->pre_pcpu is
     set (not -1).

     The new code keeps interrupts disabled for the whole duration of
     pi_pre_block/pi_post_block.  This is not strictly necessary, but
     easier to follow.  For the same reason, PI.ON is checked only
     after the cmpxchg, and to handle it we just call the post-block
     code.  This removes duplication of the list removal code.

At the time, I didn't notice the now useless NDST update.

Paolo

> The vCPU can get preempted_before_  the update starts, but not during.
> And if the vCPU is preempted before, vmx_vcpu_pi_load() is responsible
> for updating NDST when the vCPU is scheduled back in.  In that case, the
> check against the wakeup vector in vmx_vcpu_pi_load() cannot be true as
> that would require the notification vector to have been set to the wakeup
> vector_before_  blocking.
> 
> Opportunistically switch to using vcpu->cpu for the list/lock lookups,
> which presumably used pre_pcpu only for some phantom preemption logic.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
