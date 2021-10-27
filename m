Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 634A9C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 16:14:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D5CDA60F38
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 16:14:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D5CDA60F38
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DA6E4B14C;
	Wed, 27 Oct 2021 12:14:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XrEI7LmY4oaq; Wed, 27 Oct 2021 12:14:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC0204B11E;
	Wed, 27 Oct 2021 12:14:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CADA34B11E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 12:14:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uYdXRaL8kNvq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 12:14:49 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DC044B106
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 12:14:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635351289;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=YJ1AvjILyDHE6A0xH65m+vjqkknvkqBvDuAHk95niU8=;
 b=NNZezK5I92wtIcPstDA/xymm972gQZ9WtIC5LNxfA9/cKxuo+jbIJpAKxG+WhoLmdVV01i
 NfPQgaZ9mJOfSB0HBcNLWZgEKlOhbZu9FMixihVNRp0ciu5gnbRZwRTQfUaUFD0slfDuBp
 DgWNhhGjuOT8NzyXPJVCkv+W8CekUrs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-Ij5myqF5N8GpHIAlrkhmmQ-1; Wed, 27 Oct 2021 12:14:48 -0400
X-MC-Unique: Ij5myqF5N8GpHIAlrkhmmQ-1
Received: by mail-ed1-f71.google.com with SMTP id
 z1-20020a05640235c100b003dcf0fbfbd8so2826361edc.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 09:14:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=YJ1AvjILyDHE6A0xH65m+vjqkknvkqBvDuAHk95niU8=;
 b=cMsHBMQZbk1piKg0p0W4Di5Bjav872LwQvSZpDM5o4JqSEMTZIPUi0qLRC09wnctpR
 1nSq7G6PXRkeq+i2PtMkKnLMSudpwDn3qswDOjR0C9cpa0OEIBjFNWCaM/PMvWAqw/Sj
 37VMAAFUHnyPlCvu6XDUB6vJwgoh6AZMLoBycViyFjY6tpbIZXsAJ590b3ANHMkAExaZ
 65+zU3IDKIQw2OWsEoVeNKMG20X0pYGz9MWOtIOSw58UeQMUkD/UL7bN40XapXp1D49H
 Q+j4rloWTrwOg7WWiTkHP+oHyDdgFsWvHBOxnI7lWn/46kAvQJlsBFXWM6Ed4t+kGEZD
 5PfA==
X-Gm-Message-State: AOAM531+y5nsMlMD9+gOZmmMSmUn7fzyIOVZXbDJxsBn9oS3REy7yJDu
 2QwBeSWIy7n+tc9I+dSoBgx7LPM0NstrwAert0dPDiTa89jdVBW7gPAdeuI96Ax0KhZjsmTkNyG
 7rkdEj601wjOdQKhHBQporwre
X-Received: by 2002:a17:907:16a7:: with SMTP id
 hc39mr22891307ejc.214.1635351287160; 
 Wed, 27 Oct 2021 09:14:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzO/QgQ5GMyh0vFS/oBYQIX6qwD3vL9k6RGrSUIXFucShmCvNWLSsmfmRBNY3o+Ac+4bg3ipQ==
X-Received: by 2002:a17:907:16a7:: with SMTP id
 hc39mr22891269ejc.214.1635351286915; 
 Wed, 27 Oct 2021 09:14:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id sb30sm195562ejc.45.2021.10.27.09.14.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 27 Oct 2021 09:14:46 -0700 (PDT)
Message-ID: <d0746ea4-06e9-f65d-6e45-72b1b0dea29b@redhat.com>
Date: Wed, 27 Oct 2021 18:14:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 35/43] KVM: SVM: Signal AVIC doorbell iff vCPU is in
 guest mode
To: Sean Christopherson <seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-36-seanjc@google.com>
 <0333be2a-76d8-657a-6c82-3bb5c9ff2e3b@redhat.com>
 <YXlrEWmBohaDXmqL@google.com>
 <185502d7-861e-fa5c-b225-419710fe77ed@redhat.com>
 <YXl5anv0Lyjx1cws@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YXl5anv0Lyjx1cws@google.com>
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

On 27/10/21 18:08, Sean Christopherson wrote:
>> Right, so should we drop the "if (running)" check in this patch, at the same
>> time as it's adding the IN_GUEST_MODE check?
> LOL, I think we have a Three^WTwo Stooges routine going on.  This patch does
> remove avic_vcpu_is_running() and replaces it with the vcpu->mode check.  Or am
> I completely misunderstanding what your referring to?
> 
> -       if (avic_vcpu_is_running(vcpu)) {
> +       /*
> +        * Signal the doorbell to tell hardware to inject the IRQ if the vCPU
> +        * is in the guest.  If the vCPU is not in the guest, hardware will
> +        * automatically process AVIC interrupts at VMRUN.
> +        */
> +       if (vcpu->mode == IN_GUEST_MODE) {
>                  int cpu = READ_ONCE(vcpu->cpu);

Nevermind, I confused svm_deliver_avic_intr with avic_kick_target_vcpus, 
which anyway you are handling in patch 36.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
