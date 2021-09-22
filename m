Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF16C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 06:29:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1D282611C9
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 06:29:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1D282611C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C035840573;
	Wed, 22 Sep 2021 02:29:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qeMX+z6Yjah5; Wed, 22 Sep 2021 02:29:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B45B74A173;
	Wed, 22 Sep 2021 02:29:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 882A340573
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 02:29:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZvauEbqeeGqi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 02:29:23 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94A9B40413
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 02:29:23 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632292163;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=E/tHH9wLLtazV94QpN+BmGuu66vagS3lkpjDcUcpVzA=;
 b=PGPf9ZzB33LZyiZilg2aozwZm5TDj5p0O5vz/gJCSjvz+UFxd649DuOMY96TZ0C7Yhswar
 Jo7WK7EKH7drHXehvlque90NgI8miKqAqdhI8I3mYPRJ1+VBPU59VAOBjhjFTrRdyNQnyy
 WXSIXoeyFvkhHyhwswuM+UhVvVnYRvw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-WFdEsCn0PdKCIgG3ofoAyg-1; Wed, 22 Sep 2021 02:29:22 -0400
X-MC-Unique: WFdEsCn0PdKCIgG3ofoAyg-1
Received: by mail-wr1-f71.google.com with SMTP id
 j16-20020adfa550000000b0016012acc443so1129165wrb.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 23:29:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=E/tHH9wLLtazV94QpN+BmGuu66vagS3lkpjDcUcpVzA=;
 b=XVMyCQNyY6JWpnB/oWG0QxGRmgyjsEujyklMinH4oA3vgNcDhC3S7OhcVp22DiLe42
 FYRpU5+vPhysV//1vwavrx+R7SO/drlwdSXONM0aQmT5iSqr8ys5G5ShkvkjXfcrpmaw
 oe1a5JiPM/cyfMmUTIdg98EmsKQFBDFgQHNLBWW7VIrzTO/ylKeubIrpvoaeSV4ZGvFz
 DkmHeRb59qv0hKrmBBpIN+UHqqVKC0TJ6pLlruIRblGxk7dkbdLuz1NMm5jFV1eqx/FN
 ASEs0zeRVfO4cSVaEC0Eu/fkXirZaVEnQxq+y2M8rUODXNveHdZnxTCt+7439X7TSqwS
 vavA==
X-Gm-Message-State: AOAM5316f14oDvPOyk3n8G9MMlUyYk+1DFkb+YrzTyItqyovzwcXnqyg
 +3fCWuBylIQV+NZFVMZSefC/rmPuUwr5n+H+8LBrd1lAUkcpQ7UCrjUBDIkbPvdbWTw7BiKu6ES
 boanI0GoJ77wZxownzEbRhrQ+
X-Received: by 2002:a5d:64a7:: with SMTP id m7mr39506122wrp.171.1632292161048; 
 Tue, 21 Sep 2021 23:29:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhBqcw62XwXR9WbHiblbcM9n6+4WHbybrr5/MkhCq7T4dnVdh+qdYz2KsHuqdWFBJH3F6z5Q==
X-Received: by 2002:a5d:64a7:: with SMTP id m7mr39506073wrp.171.1632292160784; 
 Tue, 21 Sep 2021 23:29:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id n26sm4980232wmi.43.2021.09.21.23.29.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Sep 2021 23:29:20 -0700 (PDT)
Subject: Re: [PATCH v3 16/16] perf: Drop guest callback (un)register stubs
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
 <20210922000533.713300-17-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <74d2e94f-fbd3-522e-8fc5-da5a0a575838@redhat.com>
Date: Wed, 22 Sep 2021 08:29:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922000533.713300-17-seanjc@google.com>
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
> Drop perf's stubs for (un)registering guest callbacks now that KVM
> registration of callbacks is hidden behind GUEST_PERF_EVENTS=y.  The only
> other user is x86 XEN_PV, and x86 unconditionally selects PERF_EVENTS.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   include/linux/perf_event.h | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index d582dfeb4e20..20327d1046bb 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1505,11 +1505,6 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)	{ }
>   static inline void
>   perf_bp_event(struct perf_event *event, void *data)			{ }
>   
> -static inline void perf_register_guest_info_callbacks
> -(struct perf_guest_info_callbacks *cbs)					{ }
> -static inline void perf_unregister_guest_info_callbacks
> -(struct perf_guest_info_callbacks *cbs)					{ }
> -
>   static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
>   
>   typedef int (perf_ksymbol_get_name_f)(char *name, int name_len, void *data);
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
