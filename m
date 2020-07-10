Return-Path: <SRS0=mTyv=AV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73BB2C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jul 2020 07:57:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0DE202085B
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jul 2020 07:57:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJrDQNXg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DE202085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D81A4B185;
	Fri, 10 Jul 2020 03:57:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3-WnyDf7xtGX; Fri, 10 Jul 2020 03:57:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F2364B188;
	Fri, 10 Jul 2020 03:57:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 725754B186
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 03:57:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q5UzVL7L6QS0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2020 03:57:08 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A10984B185
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 03:57:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1594367828;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9UmlYK6TFkdH3M5DCGlsKdci4FjjHwdZByjtVurs5W4=;
 b=EJrDQNXgkCZvp3P1S26jEFVkS/Q4nEZ8uzLJIYsCfrdMZ4XFGlzrD4OWILXaxzf9NyFelf
 13L7wR5JPc1BQ6mEy6G6lv7p5P0DtVcpuuCZZg9KoHLBsN93YZbpLVZgOBpVnilAK7kecT
 mg5SfUoFIqME+4VPgA0JVqmt7fb/v68=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-nNjaQC7XP4GxDRN_bHSt0g-1; Fri, 10 Jul 2020 03:57:06 -0400
X-MC-Unique: nNjaQC7XP4GxDRN_bHSt0g-1
Received: by mail-wr1-f69.google.com with SMTP id o25so5067582wro.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 00:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=9UmlYK6TFkdH3M5DCGlsKdci4FjjHwdZByjtVurs5W4=;
 b=EDgzaEg+RDSALd1Skepvx+IRL5oi4jGclkdE1xjmXmWq33iYHy0XxSB7jy4AMkcmH4
 aGwSM5pnnJuYEwmBRISssA2cLQwxwlr6V8iTcfvtXY8rbGmAUrSQE+jTEoGrwpHvaTdG
 1z1SvZPNDwBSY9o8E11eoDVJYz6ZMv4qvh11nW2gOoTPraPZJ4lyrEdGbQml9ygdHm0r
 WzpuiNuTn5x/TR4aztIE5Df6LIMxyuGDQ8hH6jpXhHj2Z7cJlT/fQzsQqSkMAG+aFKQG
 0AQbK8P3M85XCB18elpnTNdDnmehqUZHbOnV0cHjD2cOmtQlEanUoyJR3bfExmRp4/gp
 ByyA==
X-Gm-Message-State: AOAM530gfEHcMhRkgxfbDWD6U5yS7BYV2pXOzEjoF8daBCLLIBHRtoNP
 AMELBEekuktCLL57KxKpb6gJJCdbZGMTAnLPvAqT3YluCy1xf/uU2OuRUxO/8jVLfIQAo0bAmWU
 Qby5t8cxTnW4LBFR8+qjN/5D1
X-Received: by 2002:a05:6000:d0:: with SMTP id
 q16mr35612098wrx.166.1594367825620; 
 Fri, 10 Jul 2020 00:57:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlW3Ot+LBMZYtqgHl9fPkIYjtKMwBy9LJ/7SxUDFXEtvSCRy05DGSOlP3Hhmft1U2EXpdY3Q==
X-Received: by 2002:a05:6000:d0:: with SMTP id
 q16mr35612051wrx.166.1594367825324; 
 Fri, 10 Jul 2020 00:57:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c?
 ([2001:b07:6468:f312:9541:9439:cb0f:89c])
 by smtp.gmail.com with ESMTPSA id 138sm23193764wmb.1.2020.07.10.00.57.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 10 Jul 2020 00:57:04 -0700 (PDT)
Subject: Re: [PATCH v6 3/5] KVM: PPC: clean up redundant kvm_run parameters in
 assembly
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
 tsbogend@alpha.franken.de, paulus@ozlabs.org, mpe@ellerman.id.au,
 benh@kernel.crashing.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
 david@redhat.com, cohuck@redhat.com, heiko.carstens@de.ibm.com,
 gor@linux.ibm.com, sean.j.christopherson@intel.com, vkuznets@redhat.com,
 wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com,
 chenhuacai@gmail.com
References: <20200623131418.31473-1-tianjia.zhang@linux.alibaba.com>
 <20200623131418.31473-4-tianjia.zhang@linux.alibaba.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8947174f-ce16-c076-e208-55e743d9fdf0@redhat.com>
Date: Fri, 10 Jul 2020 09:57:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200623131418.31473-4-tianjia.zhang@linux.alibaba.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On 23/06/20 15:14, Tianjia Zhang wrote:
>  
>  	/* Load non-volatile guest state from the vcpu */
> -	VCPU_LOAD_NVGPRS(r4)
> +	VCPU_LOAD_NVGPRS(r3)
>  
>  kvm_start_lightweight:
>  	/* Copy registers into shadow vcpu so we can access them in real mode */
> -	mr	r3, r4
>  	bl	FUNC(kvmppc_copy_to_svcpu)
>  	nop
> -	REST_GPR(4, r1)
> +	REST_GPR(3, r1)
>  
>  #ifdef CONFIG_PPC_BOOK3S_64
>  	/* Get the dcbz32 flag */
> @@ -146,7 +144,7 @@ after_sprg3_load:

Below, there are a bunch of references to r3 and r4 left

        rldicl  r3, r3, 0, 63           /* r3 &= 1 */
        stb     r3, HSTATE_RESTORE_HID5(r13)

        /* Load up guest SPRG3 value, since it's user readable */
        lwz     r3, VCPU_SHAREDBE(r4)				  <<<
        cmpwi   r3, 0
        ld      r5, VCPU_SHARED(r4)				  <<<

where r3 is also destroyed.  So I'd rather have three patches:

- one that is as small as possible, changing the prototypes and adding

	mr r4, r3

- one that entirely swaps out r3 and r4.  This would be the hard one to
review!

- one that cleans up the prologue and epilogue

But overall I think it's simplest to just leave out this patch.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
