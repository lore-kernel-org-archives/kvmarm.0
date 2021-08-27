Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED82DC432BE
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 18:04:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B33360F92
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 18:04:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6B33360F92
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E23EF4B0E1;
	Fri, 27 Aug 2021 14:04:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HsH+AOgrVHt2; Fri, 27 Aug 2021 14:04:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D44D4B105;
	Fri, 27 Aug 2021 14:04:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 483274B0D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 13:23:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tY-pIcdqLjTq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 13:23:11 -0400 (EDT)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D42C4B0CE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 13:23:11 -0400 (EDT)
Received: by mail-pg1-f181.google.com with SMTP id x4so6535887pgh.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 10:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=pW2KRXINIECq2UqrMAjVuApe68m2StZHA9v7va6qTiU=;
 b=rYBmoVs975N+yu2934Kl7Ag8dNi2tkW5MPQBPsQWMJceqaAUViMJX5p8VTsmrLat2L
 1kJT1N4rNPJvHYN4v8xV4LZQQiN0gVYVxxZoK0AWZMQtgbtlsholocVLBSLsdQUjTc7K
 EO/n6pcBnNhyHknntLRnjl3c7dPZnYup1ZY4k8dYXcB6+XwMELnSDRN8GScTXVD9wLYw
 72HE/X1LKTlO7T9MyRzf3/jBybVrYz/zMXfVi26QTtQIvfOSsE3Kyet1JW3IoRhxG7Z4
 s9RsOEhsC/QREunQ94/foNgn4vxgTRk3Re13QZxXDPqu5Xx6dQ43rKJdU90h8PsbIabZ
 TDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=pW2KRXINIECq2UqrMAjVuApe68m2StZHA9v7va6qTiU=;
 b=T0cwkyKZJWon8WClDWIf2kgR631YjhRtrA+aopgVYgnmNSxC3rFHBMehlI149sji/B
 THuJd94HiJtKRW5jT1WB/oZdXFXHyg4U2VyQBT0D4RiKApTWlcOGkKwis+eWL/pIcFtG
 cZ1fqhkGxH2dqamgbKe4JJWSVVmDLdWqloirN96klxpiA9KIBv9FiGaML5pVowcpdNka
 D+hDLtrvmym+hibYgN/ZM1Dev4GPqPPqaDtlCXme8F60NbHVUXfCVOh4d5OdHsJs0o7c
 v0AjFuuo5Ey+maFX6t91+UPU5whR3DozdkDqzljY/xMupNPFSGPZ0Zc9WIrPOHKNszLG
 bPQQ==
X-Gm-Message-State: AOAM531Kon24NlI3qWW4Bi04DUWHfqxL89R2d8J8cjpt58CcblpibU7x
 GhsQ2Da0YuK8ZjMf/420Q2ZDVw==
X-Google-Smtp-Source: ABdhPJz+T5dgH3sIVem/Dht2xu+EGET8qPyEg43yvrgPII1mSQTEgb7AA1JRyZkdBQMuVGObTA+XjQ==
X-Received: by 2002:a63:ef14:: with SMTP id u20mr8773852pgh.13.1630084990019; 
 Fri, 27 Aug 2021 10:23:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id n24sm7386923pgv.60.2021.08.27.10.23.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 27 Aug 2021 10:23:09 -0700 (PDT)
Date: Fri, 27 Aug 2021 17:23:05 +0000
From: Sean Christopherson <seanjc@google.com>
To: Zhu Lingshan <lingshan.zhu@intel.com>
Subject: Re: [PATCH V10 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <YSkfeXcd6nUT3AOJ@google.com>
References: <20210806133802.3528-1-lingshan.zhu@intel.com>
 <20210806133802.3528-2-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210806133802.3528-2-lingshan.zhu@intel.com>
X-Mailman-Approved-At: Fri, 27 Aug 2021 14:04:17 -0400
Cc: wanpengli@tencent.com, Like Xu <like.xu@linux.intel.com>,
 peterz@infradead.org, eranian@google.com, Guo Ren <guoren@kernel.org>,
 linux-riscv@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kan.liang@linux.intel.com, ak@linux.intel.com,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, joro@8bytes.org,
 x86@kernel.org, linux-csky@vger.kernel.org, wei.w.wang@intel.com,
 linux-arm-kernel@lists.infradead.org, xen-devel@lists.xenproject.org,
 liuxiangdong5@huawei.com, bp@alien8.de,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, boris.ostrvsky@oracle.com,
 jmattson@google.com, like.xu.linux@gmail.com, Nick Hu <nickhu@andestech.com>,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Aug 06, 2021, Zhu Lingshan wrote:
> @@ -2944,18 +2966,21 @@ static unsigned long code_segment_base(struct pt_regs *regs)
>  
>  unsigned long perf_instruction_pointer(struct pt_regs *regs)
>  {
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
> -		return perf_guest_cbs->get_guest_ip();
> +	unsigned long ip = static_call(x86_guest_get_ip)();
> +
> +	if (likely(!ip))

Pivoting on ip==0 isn't correct, it's perfectly legal for a guest to execute
from %rip=0.  Unless there's some static_call() magic that supports this with a
default function:
	
	if (unlikely(!static_call(x86_guest_get_ip)(&ip)))
		regs->ip + code_segment_base(regs)

	return ip;

The easiest thing is keep the existing:

	if (unlikely(static_call(x86_guest_state)()))
		return static_call(x86_guest_get_ip)();

	return regs->ip + code_segment_base(regs);

It's an extra call for PMIs in guest, but I don't think any of the KVM folks care
_that_ much about the performance in this case.

> +		ip = regs->ip + code_segment_base(regs);
>  
> -	return regs->ip + code_segment_base(regs);
> +	return ip;
>  }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
