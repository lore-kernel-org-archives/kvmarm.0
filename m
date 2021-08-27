Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF92FC43214
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 08:32:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3087561027
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 08:32:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3087561027
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9F1C4B103;
	Fri, 27 Aug 2021 04:32:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IBbfS9bs2PGP; Fri, 27 Aug 2021 04:32:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C94BC4B10A;
	Fri, 27 Aug 2021 04:32:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 345204B0F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 04:02:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y22TcBjD7iQg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 04:02:03 -0400 (EDT)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
 [209.85.210.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F7894B0F2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 04:02:03 -0400 (EDT)
Received: by mail-pf1-f175.google.com with SMTP id 18so5012840pfh.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 01:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=subject:to:cc:references:from:organization:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Cswhnu+o8kyBBIxzcLABF5rjUJeD7g9ZDLkYCWGDY3Y=;
 b=OqohcBTPo1bx+g+Uhy5kq56l7yUOxLEugEOLnrrHFGOE9q6fl4GSY8Z1g4cy28v8/H
 /L1w4p4Sg8b+ljDLiH9Gb1+GZJmzWV6ysvxelEZyI9D8Ew3G/bqelIPClmFt9as7aEEu
 nk0NoXFPWc3E70qTNobmYIJyHjN8UsaDJ8PQd9G9IThDwB0Rbm6047rMIfrYiIaoPol8
 83YdQMipI9Ef5oiCjCXNrqRhdPiM1lKbwLomBu4t1pdAiwluLh1kv3kaFwWDZpIPSD+6
 7uC9Sledzc7uwLe6e/cdddOBkwHJ7y8MIBF8ETXjcZo+yjuo33qz1BEAi+Qpk6kRxoes
 Y0ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=Cswhnu+o8kyBBIxzcLABF5rjUJeD7g9ZDLkYCWGDY3Y=;
 b=CQfqAJyfm52UfVS9TyBCgjr33mDRXvdpbjA/OrvZFzx7F66uUN2Be2bpNqloG8mAAQ
 WugDN5U88x9k1cR7VNn2U0AbwFrI0f0iXXnIzP9faTnKHOoMD/Vxp6mZKeICsGit0hVD
 wPgD4RwUMJiarJ2zpDFSmrnE23yZo47A4xr1uELp2X+fdNt3hnbIHyA08ahSl3EuuW5Y
 ePWD7nkZZ91JtiKkQDuvKxlhXM3CPExNCfQLmccgiuTSTXbr3oqmy1wzPs6e9VW+inm4
 JN2lKHkDdx+AapjeW/w7bq2mL0xi42R703zHHHYBWpEJ9rDOSpRuBxbUGG4ECDO0oEjg
 AcFg==
X-Gm-Message-State: AOAM530B29cYjcZYYkxic88/8ljd6d7Z+x7uRdZ043/2fKKVqXcgCC78
 JpNTN2eed8lENon/4t1IfRk=
X-Google-Smtp-Source: ABdhPJz93kkIvT1VtOeM07aufGlsPC5VcsFoOF9FFZYwZ3Du0G+C1ytyrpDJPIrEyio9g37sV046Cg==
X-Received: by 2002:a05:6a00:1748:b0:3e2:ace4:82b7 with SMTP id
 j8-20020a056a00174800b003e2ace482b7mr7814214pfc.56.1630051322226; 
 Fri, 27 Aug 2021 01:02:02 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
 by smtp.gmail.com with ESMTPSA id d15sm5390883pfd.115.2021.08.27.01.01.51
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 27 Aug 2021 01:02:01 -0700 (PDT)
Subject: Re: [PATCH 00/15] perf: KVM: Fix, optimize, and clean up callbacks
To: Peter Zijlstra <peterz@infradead.org>
References: <20210827005718.585190-1-seanjc@google.com>
 <fd3dcd6c-b3d5-4453-93fb-b46d0595534e@gmail.com>
 <YSiX9OPcrDsr3P4C@hirez.programming.kicks-ass.net>
From: Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Message-ID: <3bd4955a-1219-20b0-058b-d23f1e30aa77@gmail.com>
Date: Fri, 27 Aug 2021 16:01:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YSiX9OPcrDsr3P4C@hirez.programming.kicks-ass.net>
Content-Language: en-US
X-Mailman-Approved-At: Fri, 27 Aug 2021 04:32:34 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Josh Poimboeuf <jpoimboe@redhat.com>, Guo Ren <guoren@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Vincent Chen <deanbo422@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Stefano Stabellini <sstabellini@kernel.org>,
 Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 linux-csky@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
 Steven Rostedt <rostedt@goodmis.org>, xen-devel@lists.xenproject.org,
 Juergen Gross <jgross@suse.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Zhu Lingshan <lingshan.zhu@intel.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Jason Baron <jbaron@akamai.com>,
 Borislav Petkov <bp@alien8.de>, Greentime Hu <green.hu@gmail.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Namhyung Kim <namhyung@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Nick Hu <nickhu@andestech.com>,
 Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
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

On 27/8/2021 3:44 pm, Peter Zijlstra wrote:
> On Fri, Aug 27, 2021 at 02:52:25PM +0800, Like Xu wrote:
>> + STATIC BRANCH/CALL friends.
>>
>> On 27/8/2021 8:57 am, Sean Christopherson wrote:
>>> This started out as a small series[1] to fix a KVM bug related to Intel PT
>>> interrupt handling and snowballed horribly.
>>>
>>> The main problem being addressed is that the perf_guest_cbs are shared by
>>> all CPUs, can be nullified by KVM during module unload, and are not
>>> protected against concurrent access from NMI context.
>>
>> Shouldn't this be a generic issue of the static_call() usage ?
>>
>> At the beginning, we set up the static entry assuming perf_guest_cbs != NULL:
>>
>> 	if (perf_guest_cbs && perf_guest_cbs->handle_intel_pt_intr) {
>> 		static_call_update(x86_guest_handle_intel_pt_intr,
>> 				   perf_guest_cbs->handle_intel_pt_intr);
>> 	}
>>
>> and then we unset the perf_guest_cbs and do the static function call like this:
>>
>> DECLARE_STATIC_CALL(x86_guest_handle_intel_pt_intr,
>> *(perf_guest_cbs->handle_intel_pt_intr));
>> static int handle_pmi_common(struct pt_regs *regs, u64 status)
>> {
>> 		...
>> 		if (!static_call(x86_guest_handle_intel_pt_intr)())
>> 			intel_pt_interrupt();
>> 		...
>> }
> 
> You just have to make sure all static_call() invocations that started
> before unreg are finished before continuing with the unload.
> synchronize_rcu() can help with that.

Do you mean something like that:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 64e310ff4f3a..e7d310af7509 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8465,6 +8465,7 @@ void kvm_arch_exit(void)
  #endif
  	kvm_lapic_exit();
  	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
+	synchronize_rcu();

  	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
  		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e466fc8176e1..63ae56c5d133 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6508,6 +6508,7 @@ EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
  int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
  {
  	perf_guest_cbs = NULL;
+	arch_perf_update_guest_cbs();
  	return 0;
  }
  EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);

> 
> This is module unload 101. Nothing specific to static_call().
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
