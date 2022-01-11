Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4FFC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 22:12:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE30F4B0D9;
	Tue, 11 Jan 2022 17:12:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fd8CRMGyGPFB; Tue, 11 Jan 2022 17:12:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 984B349F40;
	Tue, 11 Jan 2022 17:12:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77D5B49F3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 17:12:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UGLZ8TFG6Wrt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 17:12:46 -0500 (EST)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com
 [209.85.222.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4451F49F36
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 17:12:46 -0500 (EST)
Received: by mail-ua1-f52.google.com with SMTP id p1so1261753uap.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 14:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=r07AHSrwP7IiWaEc7XuaOpzxQqznHXlAJOTUVnC9Vs4=;
 b=SoKy7zFxyiZIdEqDDvOy55G3RyQeDHBYuXYA0ds5AFE1ghNy88MWPRSTJJu1I27m//
 Tn0zXSHitKGrBp82XAL0fqoQEQftUzzmRiRs3cYeqCqKNWnVrqdNdiGuAKiExQbrJ/pn
 PeeU8VO/ymOqvy1DR08Ddip5epHa/U+1AvWGOU5mFS00J6+PQf+GxHG7fgugyVD9q/E0
 ddcKS/8jlMs6CeE1VnGo/jSicIwx7r2YbZemenSGs2pQqqMbSFcIfSeWISIqG2Q2ZyGC
 ViHS32HwVD+VIzeEMdbcAwmlRNq7I+FmHmKrUdjmOgMg54ZCHnb/lmlKpIq4kpt3lFY1
 K3kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=r07AHSrwP7IiWaEc7XuaOpzxQqznHXlAJOTUVnC9Vs4=;
 b=NKbP+tPxY7VaCTdlZkAMLO6pt3eRzlHIijFLGefgsiLUrqo386V9siYJJQJYZ2GCzO
 V/vhzwAZs+n0YV7EjqPOO2wc1uiVzx/I+WdDKQaRXQ715//TNgunERQSGbV0f8Wg16FT
 d3T+uXRt0sEbKKh/H51ZAfVEaoIZZxaMlLO4S/uyExRLBdI4ltLKqRFUWxrFUYA+/i8S
 Vq9HWtlJXeu/cfqW75gqyA9gWcoZ3ZwWK7IzNxNmR0uyMva34wq41APGeER9y3XuHS/3
 JYAWjYkLO1QXrMRSGW6LKVEpxMV9Su1TmgUN3k8GGIgIXlC47+w/Bg+JOU5QBh0umR8U
 bQ2w==
X-Gm-Message-State: AOAM532VeR6zTwxKMG/DkP3B/9U7JX9sdTXaK1/Ixn2sdkSzRD1Tp580
 lWhGtI3a0yZbhWN1duZdtxOA0DhYNZCXMlPIIY2JLQ==
X-Google-Smtp-Source: ABdhPJykyDLPhTd+VxJJF2l6DucJ4yNqzfCKkidJatnlOChHRQstJQQgi8avKM3niDpObkvUxYiEkxdrWnFBgVBxboQ=
X-Received: by 2002:a05:6102:c46:: with SMTP id
 y6mr3403896vss.82.1641939165542; 
 Tue, 11 Jan 2022 14:12:45 -0800 (PST)
MIME-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com>
 <877db6trlc.wl-maz@kernel.org>
In-Reply-To: <877db6trlc.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 11 Jan 2022 14:12:33 -0800
Message-ID: <CAAdAUtiZ4GXkDfjeknCmN5TZAiw5roH2h8pdeUGLMva50CL6rg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] ARM64: Guest performance improvement during dirty
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>
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

On Tue, Jan 11, 2022 at 3:55 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 10 Jan 2022 21:04:38 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > This patch is to reduce the performance degradation of guest workload during
> > dirty logging on ARM64. A fast path is added to handle permission relaxation
> > during dirty logging. The MMU lock is replaced with rwlock, by which all
> > permision relaxations on leaf pte can be performed under the read lock. This
> > greatly reduces the MMU lock contention during dirty logging. With this
> > solution, the source guest workload performance degradation can be improved
> > by more than 60%.
> >
> > Problem:
> >   * A Google internal live migration test shows that the source guest workload
> >   performance has >99% degradation for about 105 seconds, >50% degradation
> >   for about 112 seconds, >10% degradation for about 112 seconds on ARM64.
> >   This shows that most of the time, the guest workload degradtion is above
> >   99%, which obviously needs some improvement compared to the test result
> >   on x86 (>99% for 6s, >50% for 9s, >10% for 27s).
> >   * Tested H/W: Ampere Altra 3GHz, #CPU: 64, #Mem: 256GB
> >   * VM spec: #vCPU: 48, #Mem/vCPU: 4GB
>
> What are the host and guest page sizes?
Both are 4K and guest mem is 2M hugepage backed. Will add the info for
future posts.
>
> >
> > Analysis:
> >   * We enabled CONFIG_LOCK_STAT in kernel and used dirty_log_perf_test to get
> >     the number of contentions of MMU lock and the "dirty memory time" on
> >     various VM spec.
> >     By using test command
> >     ./dirty_log_perf_test -b 2G -m 2 -i 2 -s anonymous_hugetlb_2mb -v [#vCPU]
>
> How is this test representative of the internal live migration test
> you mention above? '-m 2' indicates a mode that varies depending on
> the HW and revision of the test (I just added a bunch of supported
> modes). Which one is it?
The "dirty memory time" is the time vCPU threads spent in KVM after
fault. Higher "dirty memory time" means higher degradation to guest
workload.
'-m 2' indicates mode "PA-bits:48,  VA-bits:48,  4K pages". Will add
this for future posts.
>
> >     Below are the results:
> >     +-------+------------------------+-----------------------+
> >     | #vCPU | dirty memory time (ms) | number of contentions |
> >     +-------+------------------------+-----------------------+
> >     | 1     | 926                    | 0                     |
> >     +-------+------------------------+-----------------------+
> >     | 2     | 1189                   | 4732558               |
> >     +-------+------------------------+-----------------------+
> >     | 4     | 2503                   | 11527185              |
> >     +-------+------------------------+-----------------------+
> >     | 8     | 5069                   | 24881677              |
> >     +-------+------------------------+-----------------------+
> >     | 16    | 10340                  | 50347956              |
> >     +-------+------------------------+-----------------------+
> >     | 32    | 20351                  | 100605720             |
> >     +-------+------------------------+-----------------------+
> >     | 64    | 40994                  | 201442478             |
> >     +-------+------------------------+-----------------------+
> >
> >   * From the test results above, the "dirty memory time" and the number of
> >     MMU lock contention scale with the number of vCPUs. That means all the
> >     dirty memory operations from all vCPU threads have been serialized by
> >     the MMU lock. Further analysis also shows that the permission relaxation
> >     during dirty logging is where vCPU threads get serialized.
> >
> > Solution:
> >   * On ARM64, there is no mechanism as PML (Page Modification Logging) and
> >     the dirty-bit solution for dirty logging is much complicated compared to
> >     the write-protection solution. The straight way to reduce the guest
> >     performance degradation is to enhance the concurrency for the permission
> >     fault path during dirty logging.
> >   * In this patch, we only put leaf PTE permission relaxation for dirty
> >     logging under read lock, all others would go under write lock.
> >     Below are the results based on the solution:
> >     +-------+------------------------+
> >     | #vCPU | dirty memory time (ms) |
> >     +-------+------------------------+
> >     | 1     | 803                    |
> >     +-------+------------------------+
> >     | 2     | 843                    |
> >     +-------+------------------------+
> >     | 4     | 942                    |
> >     +-------+------------------------+
> >     | 8     | 1458                   |
> >     +-------+------------------------+
> >     | 16    | 2853                   |
> >     +-------+------------------------+
> >     | 32    | 5886                   |
> >     +-------+------------------------+
> >     | 64    | 12190                  |
> >     +-------+------------------------+
> >     All "dirty memory time" have been reduced by more than 60% when the
> >     number of vCPU grows.
>
> How does that translate to the original problem statement with your
> live migration test?
Based on the solution, the test results from the Google internal live
migration test also shows more than 60% improvement with >99% for 30s,
>50% for 58s and >10% for 76s.
Will add this info in to future posts.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
