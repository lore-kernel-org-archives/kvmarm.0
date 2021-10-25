Return-Path: <SRS0=qWZ6=PN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6E7C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 14:26:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7994D60F92
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 14:26:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7994D60F92
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12DDE4B08F;
	Mon, 25 Oct 2021 10:26:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vIszU3XF0kcb; Mon, 25 Oct 2021 10:26:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E36044B09C;
	Mon, 25 Oct 2021 10:26:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F73B4B08A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 10:26:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Am5SWVm8cUUV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Oct 2021 10:26:25 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93D484ACC9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 10:26:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635171985;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0JDFR/w0BO+fJnaqyJz0KqLIzoSXAKAPvBzPCJS8rh0=;
 b=IJCW8YDusdAByoM8EljhamfiBtfv6hI8BZGTdfvYvUitKk0oG0vC9jA5k7wlzZSDS8NehD
 oalURdeL+dSisK3J31hJNXlg5KI3RSNXCPQLeGKM4+wHQpBv+Zk3emF5xoceMkTFmF0s2f
 J8z53FEFRlGefUQF8Z0MDNapIAi0YeE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-teZMUzIoN5WBLNj7_ql_nA-1; Mon, 25 Oct 2021 10:26:22 -0400
X-MC-Unique: teZMUzIoN5WBLNj7_ql_nA-1
Received: by mail-ed1-f72.google.com with SMTP id
 w7-20020a056402268700b003dd46823a18so4197203edd.18
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 07:26:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=0JDFR/w0BO+fJnaqyJz0KqLIzoSXAKAPvBzPCJS8rh0=;
 b=JFtyIaEBjlagUjXk+ZOfJ8W4W5E8J1BuV7yqaUO35N5XPIM31RjFCLmt1DbE3Ct91P
 kRxgTWwFaNRKsnThK2NXh6Usw2RsWREgMO3tbN3fKr7ojtT0vofl5fya1IYVC+2jHeR7
 2HpHBQjatPKg866SbCm4zDYjFkAJMg0vTCgVYf3cs0j/RgZYPEDtDS2usKSN95UfxSOl
 1IFoQwjByrb+HxChxqnzE6kqz+EuPULW4CuFjnuWijyCQ0lc/M4l3y/cTcDvVw8GyiuP
 5T2oTDeeE3zCxDdGRtr9vAuSL0O85yE7XGehl+HZG5kzXkKIdePTJUXyAiX5l5cr2+FF
 ZGVg==
X-Gm-Message-State: AOAM533CLLhcA5YcJXGE5DYf/8MNSvkyDcbpW7CmVJ4G+kxJilLMnbTr
 taxtQS3/stoH8e/vfeIXSXIqkpzYg5Pni4YnGEW6YUQYNbkpIbe4af96CvrkYSkwW9BXMo3c89o
 gaOqhnnxpfQJ/RWcer5sKO7KP
X-Received: by 2002:a50:d78c:: with SMTP id w12mr26913806edi.147.1635171980781; 
 Mon, 25 Oct 2021 07:26:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKDlcJy9Ggfa6iOgv+1CVaZWvopovsowDbFDE9dApjZRuZhu/xUobrIcg2Oe5NEBC4id/OJQ==
X-Received: by 2002:a50:d78c:: with SMTP id w12mr26913764edi.147.1635171980582; 
 Mon, 25 Oct 2021 07:26:20 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id hs28sm1430847ejc.111.2021.10.25.07.26.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 25 Oct 2021 07:26:19 -0700 (PDT)
Message-ID: <0333be2a-76d8-657a-6c82-3bb5c9ff2e3b@redhat.com>
Date: Mon, 25 Oct 2021 16:26:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 35/43] KVM: SVM: Signal AVIC doorbell iff vCPU is in
 guest mode
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Anup Patel <anup.patel@wdc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-36-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-36-seanjc@google.com>
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
> +	 */
> +	if (vcpu->mode == IN_GUEST_MODE) {
>   		int cpu = READ_ONCE(vcpu->cpu);
>   
>   		/*
> @@ -687,8 +692,13 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
>   		if (cpu != get_cpu())
>   			wrmsrl(SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
>   		put_cpu();
> -	} else
> +	} else {
> +		/*
> +		 * Wake the vCPU if it was blocking.  KVM will then detect the
> +		 * pending IRQ when checking if the vCPU has a wake event.
> +		 */
>   		kvm_vcpu_wake_up(vcpu);
> +	}
>   

Does this still need to check the "running" flag?  That should be a 
strict superset of vcpu->mode == IN_GUEST_MODE.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
