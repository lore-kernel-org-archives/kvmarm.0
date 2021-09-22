Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B71C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 06:26:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E8034611C6
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 06:26:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E8034611C6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 972344B099;
	Wed, 22 Sep 2021 02:26:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m1+yKExI-tDI; Wed, 22 Sep 2021 02:26:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 201B44064F;
	Wed, 22 Sep 2021 02:26:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1A794057F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 02:26:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kj9mPCTnhAFh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 02:26:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B348940573
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 02:26:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632291999;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=MBiMg3FiniiEqjDXbzG5q84o5gFLCF2xYeMjdShm8Ns=;
 b=F2V3P24BT/xxBY6gNs2FwObv3qICDLKFVDwLtkMWRgVqHQCXyHQZNxz4grHhVpiuK2GGqU
 mYK7DgwsnvZnRgerMWzzX3XIMfn++KwHA2vPlvdxJ19fcP/5JskDxzYDieHG4NGbzYsrwP
 xm8w6shYOCDWmHycydwTtK/1xzi/swA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-nU4b7fw1NfCZVp7TejyeOg-1; Wed, 22 Sep 2021 02:26:36 -0400
X-MC-Unique: nU4b7fw1NfCZVp7TejyeOg-1
Received: by mail-wr1-f71.google.com with SMTP id
 j16-20020adfa550000000b0016012acc443so1123860wrb.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 23:26:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=MBiMg3FiniiEqjDXbzG5q84o5gFLCF2xYeMjdShm8Ns=;
 b=PbPGKUfzQPjAGUzSGfqxh/U0E0AfvOWR4zCxpkFQIlupYLp4V+MAiW+BrGT3K1ITz/
 iG9XVp8Wnz0D2LA9tXOr3wi401W1qZd5szKvCfiK9tudUsuO605RmlmR9F6MSxW6VE1A
 ToI0ze7b4ywvdwFbuC+Zx0ejlFcEbjtdnkpT2X1O10YVo9l8bFDfrfEqNDUQ6mfTHIQn
 bCZm304yaoQlEyz0wB0waOKQTB7TNIAR4VAm+/PP1vy/1oyS3sy9KelguV+BBAmKIabM
 eg1MKojgbdqw8++fnZGYaMX65No4oxLEuf5SSCP8d2+6Jq1g+6NsL6YBPyhQJe3DF8ia
 A1Bg==
X-Gm-Message-State: AOAM533EOycxp0vUHjy7ZayIfrM6EsrT50Np2+yncIAfwftJI2eD5Kpb
 QM1ETFptaXR4n4UKhtD+ZZANAPonDMfuuAbuZl7WkvgJl4JXxhTZN6mtLSYDvYTQv6QjY0Qzp7q
 SmoHEUku49k5iXFoUZnNMa79Q
X-Received: by 2002:a5d:4e90:: with SMTP id e16mr39082831wru.243.1632291995508; 
 Tue, 21 Sep 2021 23:26:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyl20akxP3NXahRl1WcHnQKmZ1IfpNcPRYFb7QcuxtqBG6hCoEWyeXUt8EoPViJOjXQwzqFiA==
X-Received: by 2002:a5d:4e90:: with SMTP id e16mr39082789wru.243.1632291995216; 
 Tue, 21 Sep 2021 23:26:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id m4sm1326977wrx.81.2021.09.21.23.26.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Sep 2021 23:26:34 -0700 (PDT)
Subject: Re: [PATCH v3 05/16] perf: Drop dead and useless guest "support" from
 arm, csky, nds32 and riscv
To: Sean Christopherson <seanjc@google.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
 Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
 Greentime Hu <green.hu@gmail.com>, Vincent Chen <deanbo422@gmail.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>
References: <20210922000533.713300-1-seanjc@google.com>
 <20210922000533.713300-6-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2462bc44-64a5-8bac-7c3c-d837c4b3f743@redhat.com>
Date: Wed, 22 Sep 2021 08:26:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922000533.713300-6-seanjc@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linux-riscv@lists.infradead.org,
 Jiri Olsa <jolsa@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Stefano Stabellini <sstabellini@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-csky@vger.kernel.org, xen-devel@lists.xenproject.org,
 Namhyung Kim <namhyung@kernel.org>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Like Xu <like.xu.linux@gmail.com>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
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

On 22/09/21 02:05, Sean Christopherson wrote:
> Drop "support" for guest callbacks from architctures that don't implement
> the guest callbacks.  Future patches will convert the callbacks to
> static_call; rather than churn a bunch of arch code (that was presumably
> copy+pasted from x86), remove it wholesale as it's useless and at best
> wasting cycles.
> 
> A future patch will also add a Kconfig to force architcture to opt into
> the callbacks to make it more difficult for uses "support" to sneak in in
> the future.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/arm/kernel/perf_callchain.c   | 33 ++++-------------------------
>   arch/csky/kernel/perf_callchain.c  | 12 -----------
>   arch/nds32/kernel/perf_event_cpu.c | 34 ++++--------------------------
>   arch/riscv/kernel/perf_callchain.c | 13 ------------
>   4 files changed, 8 insertions(+), 84 deletions(-)
> 
> diff --git a/arch/arm/kernel/perf_callchain.c b/arch/arm/kernel/perf_callchain.c
> index 1626dfc6f6ce..bc6b246ab55e 100644
> --- a/arch/arm/kernel/perf_callchain.c
> +++ b/arch/arm/kernel/perf_callchain.c
> @@ -62,14 +62,8 @@ user_backtrace(struct frame_tail __user *tail,
>   void
>   perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	struct frame_tail __user *tail;
>   
> -	if (guest_cbs && guest_cbs->is_in_guest()) {
> -		/* We don't support guest os callchain now */
> -		return;
> -	}
> -
>   	perf_callchain_store(entry, regs->ARM_pc);
>   
>   	if (!current->mm)
> @@ -99,44 +93,25 @@ callchain_trace(struct stackframe *fr,
>   void
>   perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	struct stackframe fr;
>   
> -	if (guest_cbs && guest_cbs->is_in_guest()) {
> -		/* We don't support guest os callchain now */
> -		return;
> -	}
> -
>   	arm_get_current_stackframe(regs, &fr);
>   	walk_stackframe(&fr, callchain_trace, entry);
>   }
>   
>   unsigned long perf_instruction_pointer(struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> -
> -	if (guest_cbs && guest_cbs->is_in_guest())
> -		return guest_cbs->get_guest_ip();
> -
>   	return instruction_pointer(regs);
>   }
>   
>   unsigned long perf_misc_flags(struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	int misc = 0;
>   
> -	if (guest_cbs && guest_cbs->is_in_guest()) {
> -		if (guest_cbs->is_user_mode())
> -			misc |= PERF_RECORD_MISC_GUEST_USER;
> -		else
> -			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
> -	} else {
> -		if (user_mode(regs))
> -			misc |= PERF_RECORD_MISC_USER;
> -		else
> -			misc |= PERF_RECORD_MISC_KERNEL;
> -	}
> +	if (user_mode(regs))
> +		misc |= PERF_RECORD_MISC_USER;
> +	else
> +		misc |= PERF_RECORD_MISC_KERNEL;
>   
>   	return misc;
>   }
> diff --git a/arch/csky/kernel/perf_callchain.c b/arch/csky/kernel/perf_callchain.c
> index 35318a635a5f..92057de08f4f 100644
> --- a/arch/csky/kernel/perf_callchain.c
> +++ b/arch/csky/kernel/perf_callchain.c
> @@ -86,13 +86,8 @@ static unsigned long user_backtrace(struct perf_callchain_entry_ctx *entry,
>   void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>   			 struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	unsigned long fp = 0;
>   
> -	/* C-SKY does not support virtualization. */
> -	if (guest_cbs && guest_cbs->is_in_guest())
> -		return;
> -
>   	fp = regs->regs[4];
>   	perf_callchain_store(entry, regs->pc);
>   
> @@ -111,15 +106,8 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>   void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>   			   struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	struct stackframe fr;
>   
> -	/* C-SKY does not support virtualization. */
> -	if (guest_cbs && guest_cbs->is_in_guest()) {
> -		pr_warn("C-SKY does not support perf in guest mode!");
> -		return;
> -	}
> -
>   	fr.fp = regs->regs[4];
>   	fr.lr = regs->lr;
>   	walk_stackframe(&fr, entry);
> diff --git a/arch/nds32/kernel/perf_event_cpu.c b/arch/nds32/kernel/perf_event_cpu.c
> index f38791960781..a78a879e7ef1 100644
> --- a/arch/nds32/kernel/perf_event_cpu.c
> +++ b/arch/nds32/kernel/perf_event_cpu.c
> @@ -1363,7 +1363,6 @@ void
>   perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>   		    struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	unsigned long fp = 0;
>   	unsigned long gp = 0;
>   	unsigned long lp = 0;
> @@ -1372,11 +1371,6 @@ perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>   
>   	leaf_fp = 0;
>   
> -	if (guest_cbs && guest_cbs->is_in_guest()) {
> -		/* We don't support guest os callchain now */
> -		return;
> -	}
> -
>   	perf_callchain_store(entry, regs->ipc);
>   	fp = regs->fp;
>   	gp = regs->gp;
> @@ -1480,13 +1474,8 @@ void
>   perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>   		      struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	struct stackframe fr;
>   
> -	if (guest_cbs && guest_cbs->is_in_guest()) {
> -		/* We don't support guest os callchain now */
> -		return;
> -	}
>   	fr.fp = regs->fp;
>   	fr.lp = regs->lp;
>   	fr.sp = regs->sp;
> @@ -1495,32 +1484,17 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>   
>   unsigned long perf_instruction_pointer(struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> -
> -	/* However, NDS32 does not support virtualization */
> -	if (guest_cbs && guest_cbs->is_in_guest())
> -		return guest_cbs->get_guest_ip();
> -
>   	return instruction_pointer(regs);
>   }
>   
>   unsigned long perf_misc_flags(struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	int misc = 0;
>   
> -	/* However, NDS32 does not support virtualization */
> -	if (guest_cbs && guest_cbs->is_in_guest()) {
> -		if (guest_cbs->is_user_mode())
> -			misc |= PERF_RECORD_MISC_GUEST_USER;
> -		else
> -			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
> -	} else {
> -		if (user_mode(regs))
> -			misc |= PERF_RECORD_MISC_USER;
> -		else
> -			misc |= PERF_RECORD_MISC_KERNEL;
> -	}
> +	if (user_mode(regs))
> +		misc |= PERF_RECORD_MISC_USER;
> +	else
> +		misc |= PERF_RECORD_MISC_KERNEL;
>   
>   	return misc;
>   }
> diff --git a/arch/riscv/kernel/perf_callchain.c b/arch/riscv/kernel/perf_callchain.c
> index 8ecfc4c128bc..1fc075b8f764 100644
> --- a/arch/riscv/kernel/perf_callchain.c
> +++ b/arch/riscv/kernel/perf_callchain.c
> @@ -56,13 +56,8 @@ static unsigned long user_backtrace(struct perf_callchain_entry_ctx *entry,
>   void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>   			 struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	unsigned long fp = 0;
>   
> -	/* RISC-V does not support perf in guest mode. */
> -	if (guest_cbs && guest_cbs->is_in_guest())
> -		return;
> -
>   	fp = regs->s0;
>   	perf_callchain_store(entry, regs->epc);
>   
> @@ -79,13 +74,5 @@ static bool fill_callchain(void *entry, unsigned long pc)
>   void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>   			   struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> -
> -	/* RISC-V does not support perf in guest mode. */
> -	if (guest_cbs && guest_cbs->is_in_guest()) {
> -		pr_warn("RISC-V does not support perf in guest mode!");
> -		return;
> -	}
> -
>   	walk_stackframe(NULL, regs, fill_callchain, entry);
>   }
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
