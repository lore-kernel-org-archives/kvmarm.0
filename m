Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF100C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 06:30:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 90D29611B0
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 06:30:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 90D29611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EE3D4A173;
	Wed, 22 Sep 2021 02:30:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bu7R4Z9N7gyN; Wed, 22 Sep 2021 02:30:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E10BC4A4BE;
	Wed, 22 Sep 2021 02:30:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5905149E57
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 02:30:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9ZyG702fkDEb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 02:30:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23E3240573
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 02:30:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632292202;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=uMqrFogGHJvh/zXMgi/UYOAI5rgMXo+1p47tZLBtnbA=;
 b=jKey5BmJXlfX+G8dR4hFXyfkNL+voNpCjLFV10JcEcjDORc7SNDPYL3W275oJj4YwePLPx
 LMUmdkWUnymbD/XRuR8PuOJQkIH0OMA6T0HiWVjgnlHsnNArDeu44/LvXMtmI4zTSpghzZ
 9aUsFnsw1olLoJ6OHAIZQ12mV8HzO1E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-TuzF83ZEMa-uceo1i_muNA-1; Wed, 22 Sep 2021 02:30:00 -0400
X-MC-Unique: TuzF83ZEMa-uceo1i_muNA-1
Received: by mail-wr1-f70.google.com with SMTP id
 r7-20020a5d6947000000b0015e0f68a63bso1108040wrw.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 23:30:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=uMqrFogGHJvh/zXMgi/UYOAI5rgMXo+1p47tZLBtnbA=;
 b=ys0s6M/AWzQbAsCdHFjMA3IG9Q3oleWsA8/vn3lnFvf6oxP1IphDKbk9hDWRTTOA4J
 bmzsv1aqPncYYf9ju5pcNBNQE2k0WId+OiPpxEciVLKDN6i33w4mDvd63Dy+lzOzcVzd
 FmpvZYrbu8kseW9ulj8pEexz64rHGTrU8dfq9QqueYuTXYT+o4u+BIG/KACNVtQCTkrE
 K6nMei3K4etwh0aJ4awenpOjQdnTVaE7zB8nVkWEjmI8s5YjbW+a2pc3iHGffWCSd9rO
 9f23K6nM5N+6M0kxeMmBNQJBS4BLJwk1fejeovk+2D/jBK3CL8klcrCgFXKdGhs0NgL5
 fQZA==
X-Gm-Message-State: AOAM530itSBh6Y3nBe5dyA26Rx4LTuOQrhBPQeH7XniBjPZPs1Usgy62
 4BcwK4rCOE9lPYrAXXQF8bF1EpAIF1/gsqb+fyrb1sKN0+qP1IMJIks1SR+R174ir9V4L0318Yy
 Xfp+LyZs8MCm+3V57K2e7hFK4
X-Received: by 2002:adf:ef92:: with SMTP id d18mr40001552wro.264.1632292199588; 
 Tue, 21 Sep 2021 23:29:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6eHdpjSr8WTnz77WfeSYfS+jJfgrKqObxO+Wy3OIPCrDpgLHnqBvaUwGRJU1fc0Wlc4Hr5Q==
X-Received: by 2002:adf:ef92:: with SMTP id d18mr40001494wro.264.1632292199252; 
 Tue, 21 Sep 2021 23:29:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id k4sm947672wmj.30.2021.09.21.23.29.54
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Sep 2021 23:29:58 -0700 (PDT)
Subject: Re: [PATCH v3 07/16] perf: Add wrappers for invoking guest callbacks
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
 <20210922000533.713300-8-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a67e5fde-8b96-47b9-f1dd-c8be8ea9da7f@redhat.com>
Date: Wed, 22 Sep 2021 08:29:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922000533.713300-8-seanjc@google.com>
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
> Add helpers for the guest callbacks to prepare for burying the callbacks
> behind a Kconfig (it's a lot easier to provide a few stubs than to #ifdef
> piles of code), and also to prepare for converting the callbacks to
> static_call().  perf_instruction_pointer() in particular will have subtle
> semantics with static_call(), as the "no callbacks" case will return 0 if
> the callbacks are unregistered between querying guest state and getting
> the IP.  Implement the change now to avoid a functional change when adding
> static_call() support, and because the new helper needs to return
> _something_ in this case.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/arm64/kernel/perf_callchain.c | 16 +++++-----------
>   arch/x86/events/core.c             | 15 +++++----------
>   arch/x86/events/intel/core.c       |  5 +----
>   include/linux/perf_event.h         | 24 ++++++++++++++++++++++++
>   4 files changed, 35 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
> index 274dc3e11b6d..db04a55cee7e 100644
> --- a/arch/arm64/kernel/perf_callchain.c
> +++ b/arch/arm64/kernel/perf_callchain.c
> @@ -102,9 +102,7 @@ compat_user_backtrace(struct compat_frame_tail __user *tail,
>   void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>   			 struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> -
> -	if (guest_cbs && guest_cbs->state()) {
> +	if (perf_guest_state()) {
>   		/* We don't support guest os callchain now */
>   		return;
>   	}
> @@ -149,10 +147,9 @@ static bool callchain_trace(void *data, unsigned long pc)
>   void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>   			   struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	struct stackframe frame;
>   
> -	if (guest_cbs && guest_cbs->state()) {
> +	if (perf_guest_state()) {
>   		/* We don't support guest os callchain now */
>   		return;
>   	}
> @@ -163,18 +160,15 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>   
>   unsigned long perf_instruction_pointer(struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> -
> -	if (guest_cbs && guest_cbs->state())
> -		return guest_cbs->get_ip();
> +	if (perf_guest_state())
> +		return perf_guest_get_ip();
>   
>   	return instruction_pointer(regs);
>   }
>   
>   unsigned long perf_misc_flags(struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> -	unsigned int guest_state = guest_cbs ? guest_cbs->state() : 0;
> +	unsigned int guest_state = perf_guest_state();
>   	int misc = 0;
>   
>   	if (guest_state) {
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 3a7630fdd340..d20e4f8d1aef 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -2761,11 +2761,10 @@ static bool perf_hw_regs(struct pt_regs *regs)
>   void
>   perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	struct unwind_state state;
>   	unsigned long addr;
>   
> -	if (guest_cbs && guest_cbs->state()) {
> +	if (perf_guest_state()) {
>   		/* TODO: We don't support guest os callchain now */
>   		return;
>   	}
> @@ -2865,11 +2864,10 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry_ctx *ent
>   void
>   perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	struct stack_frame frame;
>   	const struct stack_frame __user *fp;
>   
> -	if (guest_cbs && guest_cbs->state()) {
> +	if (perf_guest_state()) {
>   		/* TODO: We don't support guest os callchain now */
>   		return;
>   	}
> @@ -2946,18 +2944,15 @@ static unsigned long code_segment_base(struct pt_regs *regs)
>   
>   unsigned long perf_instruction_pointer(struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> -
> -	if (guest_cbs && guest_cbs->state())
> -		return guest_cbs->get_ip();
> +	if (perf_guest_state())
> +		return perf_guest_get_ip();
>   
>   	return regs->ip + code_segment_base(regs);
>   }
>   
>   unsigned long perf_misc_flags(struct pt_regs *regs)
>   {
> -	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> -	unsigned int guest_state = guest_cbs ? guest_cbs->state() : 0;
> +	unsigned int guest_state = perf_guest_state();
>   	int misc = 0;
>   
>   	if (guest_state) {
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 524ad1f747bd..f5b02017ba16 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -2786,7 +2786,6 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
>   {
>   	struct perf_sample_data data;
>   	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
> -	struct perf_guest_info_callbacks *guest_cbs;
>   	int bit;
>   	int handled = 0;
>   	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
> @@ -2853,9 +2852,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
>   	 */
>   	if (__test_and_clear_bit(GLOBAL_STATUS_TRACE_TOPAPMI_BIT, (unsigned long *)&status)) {
>   		handled++;
> -
> -		guest_cbs = perf_get_guest_cbs();
> -		if (likely(!guest_cbs || !guest_cbs->handle_intel_pt_intr()))
> +		if (!perf_guest_handle_intel_pt_intr())
>   			intel_pt_interrupt();
>   	}
>   
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index f9be88a47434..c0a6eaf55fb1 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1247,6 +1247,30 @@ static inline struct perf_guest_info_callbacks *perf_get_guest_cbs(void)
>   	/* Prevent reloading between a !NULL check and dereferences. */
>   	return READ_ONCE(perf_guest_cbs);
>   }
> +static inline unsigned int perf_guest_state(void)
> +{
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> +
> +	return guest_cbs ? guest_cbs->state() : 0;
> +}
> +static inline unsigned long perf_guest_get_ip(void)
> +{
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> +
> +	/*
> +	 * Arbitrarily return '0' in the unlikely scenario that the callbacks
> +	 * are unregistered between checking guest state and getting the IP.
> +	 */
> +	return guest_cbs ? guest_cbs->get_ip() : 0;
> +}
> +static inline unsigned int perf_guest_handle_intel_pt_intr(void)
> +{
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> +
> +	if (guest_cbs && guest_cbs->handle_intel_pt_intr)
> +		return guest_cbs->handle_intel_pt_intr();
> +	return 0;
> +}
>   extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
>   extern void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
>   
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
