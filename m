Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F70C43219
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 18:35:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB1474B355;
	Thu,  3 Nov 2022 14:35:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wZMhzwmL+lDo; Thu,  3 Nov 2022 14:35:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C42AE4B1B7;
	Thu,  3 Nov 2022 14:35:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A4144B199
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 14:35:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 83sOFlCb0aIV for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 14:35:10 -0400 (EDT)
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com
 [209.85.214.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35C6D410F3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 14:35:10 -0400 (EDT)
Received: by mail-pl1-f177.google.com with SMTP id y4so2762845plb.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 11:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=dgoOqWPJe20h3F3t+kWJTAR37+M7sNOsPG89iz5Bulk=;
 b=Pm4Lr3kAm7G9yhV3E+texinWexF8/BykknHnX+41QMhdAJg8Q6KGdsZlwDR9KsaQ03
 q0oiA6QGnfMNaCLi6FwippomEY2Gxx8DIbtsls7Wm3K9Y5ntAz6T/fo5rOOGqR0XZexV
 IMpIarVZKtd2r4wbd6pBH2HWWgUKLdmEcjKjz7hr2eZWqilU2ZOjSL0LQYBIbuLk+an3
 F080UdTs/Pl//2c4Y7M3MC5aXIj0L8ze9uKQnOS3RTfUxOdNjPBYkRT7wM2xznbkkPNf
 k6rWzEiCMkA6YZikO6kTaZUjEx2R8QJERpkjNDf1cNtL0uRiWX1pfQEgD4PMO8IN1GPi
 cqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=dgoOqWPJe20h3F3t+kWJTAR37+M7sNOsPG89iz5Bulk=;
 b=muBV+1kfj21/1gc1GI7En3ZS/tNVVjzwZSzoXJvGWU0yEOwBac3BVAqzUao3nHpV7X
 l5Fte7UV+Xs4zzRmu6/5y4xRh8P5bGjTR9U+1owrfZ4G0MIIGfiJmaX34FKbSqw0ECdT
 3pHcQdo2gSNKNDmv/hd7vJh/ujjtL3jEROXkFLqHfnuitO3XqBqg2r9UYwoaaPT+Ybhv
 cspmChmPZMvTZ6X9oiiqVG/a56YOZ+Ge/rIVvzS5yBrAHW5PMZR+BblK9f1Np4pPPev+
 FiGXPD4g9XuoBn5oSiAYJS/auXu+DSIXvTMeCEsM62oLQGF67/8azgJdJ8XKLEEFI4/L
 8Isw==
X-Gm-Message-State: ACrzQf1ufJA9QPpBFrHkYM7fcSwHexUJsHXgbzka/cMnEaO7cg3jtduh
 H/M53Ci3ZSgxKVbmO9c4l+RReg==
X-Google-Smtp-Source: AMsMyM7An2PKDpytAFzn8oRI/SQJomdGS1nTfx9CsrnDxhHyyoY4AD/5FsaR2YoYMTMl2oHfbxu0kQ==
X-Received: by 2002:a17:903:1250:b0:185:40c6:3c2c with SMTP id
 u16-20020a170903125000b0018540c63c2cmr31387342plh.64.1667500509087; 
 Thu, 03 Nov 2022 11:35:09 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 z4-20020a1709027e8400b0017da2798025sm914686pla.295.2022.11.03.11.35.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Nov 2022 11:35:08 -0700 (PDT)
Date: Thu, 3 Nov 2022 18:35:05 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 33/44] KVM: x86: Do VMX/SVM support checks directly in
 vendor code
Message-ID: <Y2QJ2TuyZImbFFvi@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-34-seanjc@google.com>
 <bfa98587-3b36-3834-a4b9-585a0e0aa56a@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bfa98587-3b36-3834-a4b9-585a0e0aa56a@redhat.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Yuan Yao <yuan.yao@intel.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-kernel@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

On Thu, Nov 03, 2022, Paolo Bonzini wrote:
> On 11/3/22 00:19, Sean Christopherson wrote:
> > +	if (!boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
> > +	    !boot_cpu_has(X86_FEATURE_VMX)) {
> > +		pr_err("VMX not enabled in MSR_IA32_FEAT_CTL\n");
> > +		return false;
> 
> I think the reference to the BIOS should remain in these messages and in
> svm.c (even though these days it's much less common for vendors to default
> to disabled virtualization in the system setup).

Ya, I'll figure out a way to mention BIOS/firmware.

> The check for X86_FEATURE_MSR_IA32_FEAT_CTL is not needed because
> init_ia32_feat_ctl() will clear X86_FEATURE_VMX if the rdmsr fail (and not
> set X86_FEATURE_MSR_IA32_FEAT_CTL).

It's technically required.  IA32_FEAT_CTL and thus KVM_INTEL depends on any of
CPU_SUP_{INTEL,CENATUR,ZHAOXIN}, but init_ia32_feat_ctl() is invoked if and only
if the actual CPU type matches one of the aforementioned CPU_SUP_*.

E.g. running a kernel built with

  CONFIG_CPU_SUP_INTEL=y
  CONFIG_CPU_SUP_AMD=y
  # CONFIG_CPU_SUP_HYGON is not set
  # CONFIG_CPU_SUP_CENTAUR is not set
  # CONFIG_CPU_SUP_ZHAOXIN is not set

on a Cenatur or Zhaoxin CPU will leave X86_FEATURE_VMX set but not set
X86_FEATURE_MSR_IA32_FEAT_CTL.  If VMX isn't enabled in MSR_IA32_FEAT_CTL, KVM
will get unexpected #UDs when trying to enable VMX.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
