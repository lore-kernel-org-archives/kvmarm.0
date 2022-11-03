Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD32C43219
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 15:08:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E15B4B18F;
	Thu,  3 Nov 2022 11:08:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kPULYScuaySh; Thu,  3 Nov 2022 11:08:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B45864B27C;
	Thu,  3 Nov 2022 11:08:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BCAB4B18F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 11:08:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KGDticIDJcKc for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 11:08:16 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4CBE41070
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 11:08:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667488096;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=MLzJVyRQvNMkBYTyqF+CAZ1OHQes3dhnjH8NkXHBEKk=;
 b=ChUPIQ1KKuEKfl7tFOU9XAUCesIAOB1U0ewwQIarSAKJ67oDLOks6NkPK/0XEEFZUyNoPz
 MWSZg/4Zl3uPlmNGqFOeXFmb1XTzyXpQb8j7taINKNsVq72ExX3niCeeK4UpX7gmYvcvK9
 OVfZBVEWdn0Nw5jSqN2GSKnj7ehSc58=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-115-cZzsKLBSMAWAlcy_aIUXDA-1; Thu, 03 Nov 2022 11:08:14 -0400
X-MC-Unique: cZzsKLBSMAWAlcy_aIUXDA-1
Received: by mail-ej1-f70.google.com with SMTP id
 qa14-20020a170907868e00b007ae24f77742so610333ejc.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 08:08:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=MLzJVyRQvNMkBYTyqF+CAZ1OHQes3dhnjH8NkXHBEKk=;
 b=HvQWYYFe96EkEIL/QYlXuaqzum+20wB9p6bRG3KDDXvwMn88SUlr5psvZyjdJ+K6si
 16QDCdyKnId8VtM+IUEOYiZNNe5iLbnebxuYQqt6UznQrcUyDeJIe3HXrrSI7UX8Us41
 hnmZDiPZka6DkOthP+D2JaglWDJLSpftEZ2PyiO9vRNxI3ZNAQ2kSqZfEl0YzpZLrZ+9
 znPJ3rXQiAJM82gy8pw/nLyu6plnmEOEdYhcrSAvZTgDDoWLSHQ7I6Ushzbx6nGB/F1n
 53oFlY+dPmO5tyKYZZD1Mnc3vKYBDg0ny4Nx03NQ5BgW3tJvf8UGnLI9v7sFQMszq6o3
 4BJA==
X-Gm-Message-State: ACrzQf2x5meF3ER2H3DiG/3tJDAjDrzogRlGTuNpCTtwasJNUwFGn78d
 OGdvMWHSPgFAxJOv1y2MMjwZ2DqGwyHAwzH2T+yAtuaO1S9CHRsXXcFpbxQw7GYlcI8VZvAB7MM
 kR+wBL10U3/sGnLd14x/0J7He
X-Received: by 2002:a05:6402:550e:b0:456:f79f:2bed with SMTP id
 fi14-20020a056402550e00b00456f79f2bedmr31117710edb.106.1667488092997; 
 Thu, 03 Nov 2022 08:08:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6ksX1XHskAylW8hRvHj1WJtzsGVm4o7GE4R3Qlz1mullFc3dI571812AyMzkQixxOznTrmOg==
X-Received: by 2002:a05:6402:550e:b0:456:f79f:2bed with SMTP id
 fi14-20020a056402550e00b00456f79f2bedmr31117664edb.106.1667488092781; 
 Thu, 03 Nov 2022 08:08:12 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c?
 ([2001:b07:6468:f312:1c09:f536:3de6:228c])
 by smtp.googlemail.com with ESMTPSA id
 s28-20020a056402037c00b0045bccd8ab83sm646641edw.1.2022.11.03.08.08.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 08:08:11 -0700 (PDT)
Message-ID: <bfa98587-3b36-3834-a4b9-585a0e0aa56a@redhat.com>
Date: Thu, 3 Nov 2022 16:08:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 33/44] KVM: x86: Do VMX/SVM support checks directly in
 vendor code
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-34-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221102231911.3107438-34-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Chao Gao <chao.gao@intel.com>, Yuan Yao <yuan.yao@intel.com>,
 kvmarm@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
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

On 11/3/22 00:19, Sean Christopherson wrote:
> +	if (!boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
> +	    !boot_cpu_has(X86_FEATURE_VMX)) {
> +		pr_err("VMX not enabled in MSR_IA32_FEAT_CTL\n");
> +		return false;

I think the reference to the BIOS should remain in these messages and in 
svm.c (even though these days it's much less common for vendors to 
default to disabled virtualization in the system setup).

The check for X86_FEATURE_MSR_IA32_FEAT_CTL is not needed because 
init_ia32_feat_ctl() will clear X86_FEATURE_VMX if the rdmsr fail (and 
not set X86_FEATURE_MSR_IA32_FEAT_CTL).

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
