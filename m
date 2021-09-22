Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C20C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:12:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0BAF561178
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:12:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0BAF561178
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5CD84B14D;
	Wed, 22 Sep 2021 09:12:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id waVhQwR1MacW; Wed, 22 Sep 2021 09:12:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C21DE4B1DA;
	Wed, 22 Sep 2021 09:11:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 129764048B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 20:06:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fJX7BoHExZyG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 20:06:19 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B8E44A3A5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 20:06:19 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 o9-20020ac80249000000b002a0c9fd54d5so5602939qtg.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 17:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=4BBDHyzTmFJD2PGtjmXQGbVqPzRCZc8ppu5cY3KZ5Y8=;
 b=i1hLF6bC7QippVnwD+QfcurzwPql0DTYdtvpNMOXEcTNGevY7UnIQHp4F8TFxhWOcC
 y5khcTlTsxcY03DM6I7OGwJdsNRusHePnZs48VJgz9iDl9BCd/WdBAHgBd08BkVlEctl
 qgkp34acvdJvQRinIA310i906+1pI4VRGGbTHUSEWOTyISF582eEBN0uohWrXglJ4Vha
 UiRiAJR9+rHm1hSoN64l3MLHm8i51hrtd5lKdh0LN16chuzJEtOj6NO2pvuQiZZnchZT
 2+/Nzn1kX3D5dvOeb3mhXnOtnZBTLnXfaqpsFhvkCaK7qjG4cSZxh2Y/t71DvQNuI5L1
 pIfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=4BBDHyzTmFJD2PGtjmXQGbVqPzRCZc8ppu5cY3KZ5Y8=;
 b=BjIpcNC70AznS/Y9V8d5b7P8GFfvnuxgE4SbwhMnkzPDVu/eg2eIHTvLyzRJDEhyzP
 C+sa5jXPOIRALol0gZBTO6ALyBImoATF+ZmgyelhevdEUlaGzybcsalaTYxdyQHlGAxJ
 EsghznMh+cRcnd/7lIlJ37JPeyQbRXcDyrdQzYu6YjTJ3kURn33JHJvHtbMc9UGZrKPM
 190g9HuNg09kBksTb5iPX/csY+omH0QgWWbm8EABpHr9EwCXnWfe6lrzgnkySRsRrgOc
 Id3OFVX0k0trwJwRB7dDZJWcHMJVtSmfF26SCayAYtfjFuuevxgWtiZEHoUzRYt+eph3
 twwg==
X-Gm-Message-State: AOAM532IZr0rTHMFWWstiKhTaAk8AXxHECpEGmwOgXs7ppawuxsN6k3h
 LbAvcL9HhrLD5NiOdP8hZcW8Pk6qA6w=
X-Google-Smtp-Source: ABdhPJzV8/bAA+bVdBd7d54Vy+1c6C23hub/FF/gkHwdARHRitfqPelJ1Pr98qSi4K4qg/f1+Xhzcbcxu/4=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:b022:92d6:d37b:686c])
 (user=seanjc job=sendgmr) by 2002:ad4:466a:: with SMTP id
 z10mr32596974qvv.47.1632269178759; 
 Tue, 21 Sep 2021 17:06:18 -0700 (PDT)
Date: Tue, 21 Sep 2021 17:05:33 -0700
In-Reply-To: <20210922000533.713300-1-seanjc@google.com>
Message-Id: <20210922000533.713300-17-seanjc@google.com>
Mime-Version: 1.0
References: <20210922000533.713300-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v3 16/16] perf: Drop guest callback (un)register stubs
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, 
 Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
 Nick Hu <nickhu@andestech.com>, 
 Greentime Hu <green.hu@gmail.com>, Vincent Chen <deanbo422@gmail.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>
X-Mailman-Approved-At: Wed, 22 Sep 2021 09:11:52 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 linux-riscv@lists.infradead.org, Jiri Olsa <jolsa@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Stefano Stabellini <sstabellini@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, linux-csky@vger.kernel.org,
 xen-devel@lists.xenproject.org, Zhu Lingshan <lingshan.zhu@intel.com>,
 Namhyung Kim <namhyung@kernel.org>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Like Xu <like.xu.linux@gmail.com>, Sean Christopherson <seanjc@google.com>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Drop perf's stubs for (un)registering guest callbacks now that KVM
registration of callbacks is hidden behind GUEST_PERF_EVENTS=y.  The only
other user is x86 XEN_PV, and x86 unconditionally selects PERF_EVENTS.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/perf_event.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d582dfeb4e20..20327d1046bb 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1505,11 +1505,6 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)	{ }
 static inline void
 perf_bp_event(struct perf_event *event, void *data)			{ }
 
-static inline void perf_register_guest_info_callbacks
-(struct perf_guest_info_callbacks *cbs)					{ }
-static inline void perf_unregister_guest_info_callbacks
-(struct perf_guest_info_callbacks *cbs)					{ }
-
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
 
 typedef int (perf_ksymbol_get_name_f)(char *name, int name_len, void *data);
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
