Return-Path: <SRS0=qWZ6=PN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B66C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 16:01:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 246DD60F70
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 16:01:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 246DD60F70
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A67E44B125;
	Mon, 25 Oct 2021 12:01:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zscNWIevOUuV; Mon, 25 Oct 2021 12:01:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C14E4B0BF;
	Mon, 25 Oct 2021 12:01:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 560744B08E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 12:01:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BOah12uJQ-qF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Oct 2021 12:01:02 -0400 (EDT)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08FC64B0E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 12:01:01 -0400 (EDT)
Received: by mail-pg1-f173.google.com with SMTP id r2so11344748pgl.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 09:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=x6eNl6O1fSvFYqdMcRuePT95mvtM6NDjKvqXNkc5pYY=;
 b=W66VdzQAiFa1xER7EM1CT10+Eh4wcd9TMpOSeNztU9mQ/b+ICWh6L1ynZPC3b8cWCA
 wuqZ3JuK0JGehSxVwtqEbTHwrBlvK53p1U6E/+mtZAETvvOLRtbYFjLFwI5UloPxv8BN
 XlYir//YmeaaWdnkVyW1uxNuSu55EoKM4Sw+NhmN68wnM6lSDD7jC6Cq+yKsA+BDT9S7
 LYFfhy6YQg08/t+jqQY9xY27FLq7qZME+IYTw4bo6b7p4vRP0wxorg/00RAZqr4kWqI+
 VviR3lssvu74tKK3FhhWMgst1k6Zz5l/r1ahbN8uJfV8tyf6Q1Oq93E9u1/e6tuuAmnW
 0NsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=x6eNl6O1fSvFYqdMcRuePT95mvtM6NDjKvqXNkc5pYY=;
 b=SCh0Ie3T9PBdhLT0cMQgsY1Q1ua7+5mMPhsec7VYWgVkv8osqQKtqGPhADexMHJsrn
 vgfAyfDZ+zgpOiFQ20YCgqTz8686MfWROTpaPjWvDUYupyezMy7l3cAbQHcJ2UboV0QZ
 c5eOM96iJvqMhals8KddH6GaetQzXAg85ElWIAMOK/wzCGhLEv2T0uX1/GJDmF6pUK0O
 1/Ev+6qWkKQXyYg+rR1re4UqyJh2T1rTL9W3EWryfN8J6ywN5MrsyLGjlofrzQ7ogRQ0
 x9avnAblPnva9CWNW/cg0MP4gRG5ISXML+0a1a2iHirsM9MHe1SwF4k8G0zPKonc/O4r
 ExdQ==
X-Gm-Message-State: AOAM531ZaEvZnlqe2ffkineZmV0N4hSWrypmXlR0EA60BD8aXJryD6VZ
 6QQOwhacYvrgQgENjtmU2LdBGA==
X-Google-Smtp-Source: ABdhPJxfd0U6TdkD95vRyewvEnv+pkmAbt8gRM1KdKD5w9N0+9AMKZEnnSCWoZvj6xIN71v2dvngIg==
X-Received: by 2002:a63:e613:: with SMTP id g19mr14679139pgh.12.1635177660627; 
 Mon, 25 Oct 2021 09:01:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id a124sm2589630pgc.15.2021.10.25.09.00.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 25 Oct 2021 09:01:00 -0700 (PDT)
Date: Mon, 25 Oct 2021 16:00:56 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 37/43] KVM: SVM: Unconditionally mark AVIC as running
 on vCPU load (with APICv)
Message-ID: <YXbUuLD4yAoNxCH4@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-38-seanjc@google.com>
 <acea3c6d-49f4-ab5e-d9fe-6c6a8a665a46@redhat.com>
 <YXbRyMQgMpHVQa3G@google.com>
 <e9509fb0-54f3-ca86-57b7-8b6d5de240b7@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e9509fb0-54f3-ca86-57b7-8b6d5de240b7@redhat.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Oct 25, 2021, Paolo Bonzini wrote:
> On 25/10/21 17:48, Sean Christopherson wrote:
> > On Mon, Oct 25, 2021, Paolo Bonzini wrote:
> > > On 09/10/21 04:12, Sean Christopherson wrote:
> > > > +	/* TODO: Document why the unblocking path checks for updates. */
> > > 
> > > Is that a riddle or what? :)
> > 
> > Yes?  I haven't been able to figure out why the unblocking path explicitly
> > checks and handles an APICv update.
> > 
> 
> Challenge accepted.  In the original code, it was because without it
> avic_vcpu_load would do nothing, and nothing would update the IS_RUNNING
> flag.
> 
> It shouldn't be necessary anymore since commit df7e4827c549 ("KVM: SVM: call
> avic_vcpu_load/avic_vcpu_put when enabling/disabling AVIC", 2021-08-20),
> where svm_refresh_apicv_exec_ctrl takes care of the avic_vcpu_load on the
> next VMRUN.

Aha!  Thanks, I'll work in a removal for the next version.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
