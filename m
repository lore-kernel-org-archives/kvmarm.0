Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409B8C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Dec 2021 18:07:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9934B4A531;
	Thu,  9 Dec 2021 13:07:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4hWM42l3nmIP; Thu,  9 Dec 2021 13:07:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 965684B0B9;
	Thu,  9 Dec 2021 13:07:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 565B0402DB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 13:07:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uZSIvSLHi3Yh for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Dec 2021 13:07:07 -0500 (EST)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com
 [209.85.208.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 58F7B40162
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 13:07:07 -0500 (EST)
Received: by mail-ed1-f49.google.com with SMTP id v1so22499859edx.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Dec 2021 10:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=/BR1/2RGDScqGY9eUb2OeC+8FFb2k7htqUCGVYcL9Ck=;
 b=Lhbpmm1UKqlpxT/ebiO1Bba267s4bE94yh07WOHh4nJeWCnmE8+23Eg5C12Rhgfpsc
 0I4D6URfKKEqBAzSviybZHxAOPOACMyExokRlTYNq44nDkWCuzRtqrXLPqBLh0Q1MX+o
 Jtx1lpBHXhEr3ddLKS6N/SSGxs76Q2vWnWxLnCwJZn1OqNjqHCU0mb7ID9NFK1G/sQ7f
 QnXai4TvqSPLltPU5wh6tLAcP4ybsTybXo1I146LDMPVWG7M5ZooS0wo6QoJtRF//8Lt
 64rO/CTBMU0ZFk+JY57EO2EnzjUHgznePMSl5XKLuc96fG3MU0lOVX14FEeAcqzIaDIb
 CLtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=/BR1/2RGDScqGY9eUb2OeC+8FFb2k7htqUCGVYcL9Ck=;
 b=01uLv37c9grLYnG/BQM+bHiUzpSUnyLBYPj3z7aQEaTlANcvA9x/b1+eTBDRjDOVBp
 oTLPDgWVnl9t0/KGMEPFjuFvOJRM+WXkAUnVQ9Y7QXmY+KNn5e8FQWRCcTMakql8bo8l
 JDvbuTkmKtuS/cl94cexjJHf8Kg24Z1RcIVBLB3StCUCj6hKiIy29crqO4KHIPVcrFxx
 uALTqTZ7KkDQnSFhehILuTj2vIhQzhbnhzV+x1XzJpLkIBIziZ7O9UNRir8NSyp4HhSU
 qDzv23OUjR31DoUy9SAJVOBoMV65aMSCEpJd5yh2FIT5Magxey0bpx5H9s77vNgbPT6G
 i8ug==
X-Gm-Message-State: AOAM531rSn6Zcqfse8NcS44ANqux0GP/6cFtLpHqNScArwn2V6sXOUQj
 D1IMgYeHvQK6mnlttUkoiFk=
X-Google-Smtp-Source: ABdhPJyCcY7SoPv6aHO9XYFGu1O783sL+OxwRl4LzsOaKHe6HzGM6Aj5sR6vgOMnSD+1083Jrn4srQ==
X-Received: by 2002:a05:6402:d05:: with SMTP id
 eb5mr31407913edb.360.1639073154112; 
 Thu, 09 Dec 2021 10:05:54 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.googlemail.com with ESMTPSA id og38sm275399ejc.5.2021.12.09.10.05.49
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 09 Dec 2021 10:05:52 -0800 (PST)
Message-ID: <048a1ef6-193a-eb82-0433-70c97e1a03e5@redhat.com>
Date: Thu, 9 Dec 2021 19:05:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 06/12] KVM: powerpc: Use Makefile.kvm for common files
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
References: <20211121125451.9489-1-dwmw2@infradead.org>
 <20211121125451.9489-7-dwmw2@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211121125451.9489-7-dwmw2@infradead.org>
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 butt3rflyh4ck <butterflyhuangxx@gmail.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 "vkuznets @ redhat . com" <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

On 11/21/21 13:54, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> It's all fairly baroque but in the end, I don't think there's any reason
> for $(KVM)/irqchip.o to have been handled differently, as they all end
> up in $(kvm-y) in the end anyway, regardless of whether they get there
> via $(common-objs-y) and the CPU-specific object lists.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
> ---
>   arch/powerpc/kvm/Makefile | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
> index 583c14ef596e..245f59118413 100644
> --- a/arch/powerpc/kvm/Makefile
> +++ b/arch/powerpc/kvm/Makefile
> @@ -4,11 +4,8 @@
>   #
>   
>   ccflags-y := -Ivirt/kvm -Iarch/powerpc/kvm
> -KVM := ../../../virt/kvm
>   
> -common-objs-y = $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
> -common-objs-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
> -common-objs-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
> +include $(srctree)/virt/kvm/Makefile.kvm
>   
>   common-objs-y += powerpc.o emulate_loadstore.o
>   obj-$(CONFIG_KVM_EXIT_TIMING) += timing.o
> @@ -125,7 +122,6 @@ kvm-book3s_32-objs := \
>   kvm-objs-$(CONFIG_KVM_BOOK3S_32) := $(kvm-book3s_32-objs)
>   
>   kvm-objs-$(CONFIG_KVM_MPIC) += mpic.o
> -kvm-objs-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
>   
>   kvm-objs := $(kvm-objs-m) $(kvm-objs-y)

Same here,

kvm-y += $(kvm-objs-m) $(kvm-objs-y)

would be slightly preferrable IMO.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
