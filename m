Return-Path: <SRS0=Klgp=NT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB276C432BE
	for <kvmarm@archiver.kernel.org>; Sat, 28 Aug 2021 19:45:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 350DB60EB5
	for <kvmarm@archiver.kernel.org>; Sat, 28 Aug 2021 19:45:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 350DB60EB5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E8D84B0D0;
	Sat, 28 Aug 2021 15:45:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9hKGVnN1lPK8; Sat, 28 Aug 2021 15:45:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 819FB4B120;
	Sat, 28 Aug 2021 15:45:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B19514B106
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Aug 2021 15:45:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dkWvu06hrmg9 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 Aug 2021 15:45:15 -0400 (EDT)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A94474B0D0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Aug 2021 15:45:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=XaDJo/Xp/thzakG+AyFw4gfOeYqXSd+OvToP2IAZADw=; b=iaSYaDXqR2I0RfntlzqVugj0Nj
 rXYt5kYTwyGKSPywFnw4fyUzTY9LAxxbRjtQkmlvftPwsUj5uPz2F5YspCjIPUg0EU+uNCyGQ3m1z
 lWBYQwuSheYbXudKlCIc8TNjxaN9C6VQgIvcLqNM4nad3zEOcmW0XTeahuIU8N5XEWm3P7Ut9+abN
 Q8fQ7zTfRTZ3R7RoF/QygqFwsUOnFQLkR+lOFf7wq4T+6b6moR3EFv7YMAVF9pd5Ox3uQjzGFISAV
 ivzAchA/SXjNJ8WNIC5WtqGO0JdesSU+G3xE61VeRun7z2ArlsfJGMdbJCaLwzEcpgePCOVpe7U2B
 vRqaWBQQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
 helo=worktop.programming.kicks-ass.net)
 by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1mK4Fb-00Dvei-M3; Sat, 28 Aug 2021 19:44:23 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
 id A026C98679D; Sat, 28 Aug 2021 21:44:21 +0200 (CEST)
Date: Sat, 28 Aug 2021 21:44:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2 01/13] perf: Ensure perf_guest_cbs aren't reloaded
 between !NULL check and deref
Message-ID: <20210828194421.GB4353@worktop.programming.kicks-ass.net>
References: <20210828003558.713983-1-seanjc@google.com>
 <20210828003558.713983-2-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210828003558.713983-2-seanjc@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Vincent Chen <deanbo422@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 linux-csky@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Ingo Molnar <mingo@redhat.com>, Like Xu <like.xu.linux@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Zhu Lingshan <lingshan.zhu@intel.com>,
 Will Deacon <will@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Greentime Hu <green.hu@gmail.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Namhyung Kim <namhyung@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Nick Hu <nickhu@andestech.com>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Fri, Aug 27, 2021 at 05:35:46PM -0700, Sean Christopherson wrote:

> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 2d510ad750ed..6b0405e578c1 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1237,6 +1237,14 @@ extern void perf_event_bpf_event(struct bpf_prog *prog,
>  				 u16 flags);
>  
>  extern struct perf_guest_info_callbacks *perf_guest_cbs;
> +static inline struct perf_guest_info_callbacks *perf_get_guest_cbs(void)
> +{
> +	/* Reg/unreg perf_guest_cbs waits for readers via synchronize_rcu(). */
> +	lockdep_assert_preemption_disabled();
> +
> +	/* Prevent reloading between a !NULL check and dereferences. */
> +	return READ_ONCE(perf_guest_cbs);
> +}

Nice..

>  extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
>  extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
>  
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 464917096e73..2126f6327321 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6491,14 +6491,19 @@ struct perf_guest_info_callbacks *perf_guest_cbs;
>  
>  int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
>  {
> -	perf_guest_cbs = cbs;
> +	if (WARN_ON_ONCE(perf_guest_cbs))
> +		return -EBUSY;
> +
> +	WRITE_ONCE(perf_guest_cbs, cbs);
> +	synchronize_rcu();

You're waiting for all NULL users to go away? :-) IOW, we can do without
this synchronize_rcu() call.

>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
>  
>  int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
>  {
> -	perf_guest_cbs = NULL;

	if (WARN_ON_ONCE(perf_guest_cbs != cbs))
		return -EBUSY;

?

> +	WRITE_ONCE(perf_guest_cbs, NULL);
> +	synchronize_rcu();
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);

Yes, this ought to work fine.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
