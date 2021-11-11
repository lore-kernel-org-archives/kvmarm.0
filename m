Return-Path: <SRS0=nF4w=P6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5B2C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 02:08:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E15BC61073
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 02:08:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E15BC61073
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 916784B25F;
	Wed, 10 Nov 2021 21:08:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l+Xe8pCLIvaB; Wed, 10 Nov 2021 21:08:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BBDE4B1FE;
	Wed, 10 Nov 2021 21:08:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 660634B25F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 21:08:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rJl5a1DKd4iJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 21:08:11 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5BFAF4B15A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 21:08:09 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 b11-20020a17090acc0b00b001a9179dc89fso472075pju.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 18:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=OsKSO91+IQOd1IkS1z06+WXQrIrb9btCelj8IT/rfjk=;
 b=UjO1QsSOEJxaGsYGL3Apu9warF+RLCb7N0O8lrT4uA7hcwAOXn0B9aIpQDfjrTQVV9
 GpUiUx0P3EvrUcerrFYJ43Q90SJS/Gs68/jHuhbKg4LsEjNWoUkdOiAjjqiiHSBSgjMG
 R7y7UnI6YE9rNtmXbNbVt3sbKA6jvhnnGELbGyK4SRL2xwd9sX+q3f8jF57/MEhgUPD+
 t/+a9Sg8Ta3/1ptTGbTPekcMLXxNe7dS033Slo6cfYWGcnVi+krIVbSkYZwCP0WX4pZh
 GTnRwbyA69uU8U608boW9DzCYJ+6PE43F4bM/b41jK5pMY5lvLJwB8NslG8L5Jh5BxcV
 /FSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=OsKSO91+IQOd1IkS1z06+WXQrIrb9btCelj8IT/rfjk=;
 b=Wxe2qvKegNy2Jz/If0cQyfMmtayl+YlEpm+RQgPXNaP3o/AooUgGyz+A+ocrbVD9ov
 2Gk010RrDaZWyUuNsSTtsF4E8pIJtrXqlfT7ga0DbboTGVbQ1ssxrBjJ1vCwbP7nG3ug
 de9yKgYNiSiItaW4CgupypVndtDugUbsR9Et1qi1YxtFYPeiNA1DQ5uYE4G2EW6yNkXB
 w44SoHqFPWahrYnmLYquJirVqPWkDREQTinTF+jlGwLoFgXDDlj5WU/UNTO/M5SMIw3p
 SIiy11Ia7r6KUynnzjplYQyPN9HyRkjZAH61DjUxEZ/4EEzm8FHQ7b6C7opcsm6us/S6
 TVUQ==
X-Gm-Message-State: AOAM532Hq4TaSBseBOCpsrzGUaOhhT3riIjeBv2glRsliR6e5qaWhPSe
 Yor77bUUfr/J8dLSd0s6juGdQY07hBM=
X-Google-Smtp-Source: ABdhPJyHlT5oqharcB3QQjRQ4qoO/10ujhci23RJu5uAP9JkYDshL4v2uHHALGrgFqagvzcYI5ZLh/T3x7g=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:1950:: with SMTP id
 16mr4223713pjh.126.1636596488573; Wed, 10 Nov 2021 18:08:08 -0800 (PST)
Date: Thu, 11 Nov 2021 02:07:38 +0000
In-Reply-To: <20211111020738.2512932-1-seanjc@google.com>
Message-Id: <20211111020738.2512932-18-seanjc@google.com>
Mime-Version: 1.0
References: <20211111020738.2512932-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v4 17/17] perf: Drop guest callback (un)register stubs
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, 
 Russell King <linux@armlinux.org.uk>, Marc Zyngier <maz@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>, 
 Nick Hu <nickhu@andestech.com>, Greentime Hu <green.hu@gmail.com>, 
 Vincent Chen <deanbo422@gmail.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Paolo Bonzini <pbonzini@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
 Juergen Gross <jgross@suse.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Jiri Olsa <jolsa@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Stefano Stabellini <sstabellini@kernel.org>, Like Xu <like.xu@linux.intel.com>,
 Joerg Roedel <joro@8bytes.org>, linux-csky@vger.kernel.org,
 xen-devel@lists.xenproject.org, Zhu Lingshan <lingshan.zhu@intel.com>,
 Namhyung Kim <namhyung@kernel.org>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Like Xu <like.xu.linux@gmail.com>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
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

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/perf_event.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0ac7d867ca0c..7b7525e9155f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1511,11 +1511,6 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)	{ }
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
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
