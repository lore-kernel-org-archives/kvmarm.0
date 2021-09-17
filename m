Return-Path: <SRS0=EfdF=OJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AFFC433F5
	for <kvmarm@archiver.kernel.org>; Sun, 19 Sep 2021 10:09:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E3C9611F0
	for <kvmarm@archiver.kernel.org>; Sun, 19 Sep 2021 10:09:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2E3C9611F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 986EB4057F;
	Sun, 19 Sep 2021 06:09:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6TcEFAnkx1oD; Sun, 19 Sep 2021 06:09:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A0EB40162;
	Sun, 19 Sep 2021 06:09:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E49E4A00B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Sep 2021 12:53:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AFdbJlEWk4CG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Sep 2021 12:53:58 -0400 (EDT)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
 [209.85.215.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 242114064F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Sep 2021 12:53:58 -0400 (EDT)
Received: by mail-pg1-f169.google.com with SMTP id e7so10176677pgk.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Sep 2021 09:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=fRMxd8azh7E1BFxsMIqGYJmHYephRNLnlBlA+X7n5iE=;
 b=OCd2JnsFm+PC0WRg9Dy8nwrv0xb6S01W9Op4r/ZIu2wiEWDdIoF9l2WbVBKByhSPPF
 pgrkna7a3wLYVWEKuAik8asYNbpDEgJtdjZ+5dk4g6kfSL2XrdSoKcoPwqesfcoOwhOu
 WWbUTglAWniqlHYXmzaYzrF0F49uRRMs/V59Ek2JYLZBnMp92N934h45zumxZj/0PpGD
 /zvBIntmv3EDlaS6KVxhx1MfK4sOMy/cLwcByoT+tkw90D/Cj3jlQCjxNda2rrqk2GSV
 L6ETbBTdUnfohyRSi9IUyYAHcI9Z9pYHZQ5tjcYdmN/t6vpNHZYY3PO0hm+uRnpvMlkD
 xKpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fRMxd8azh7E1BFxsMIqGYJmHYephRNLnlBlA+X7n5iE=;
 b=bKHCbNIdcB+CGcM8sVSkvpxD2vgnGbTgFHtvyWRNHIFmuRWMWnj1t9s/+4ZUCKrc8C
 tClqjXmDxfwhSOWVbAvBlEXSQmfJ7QKDMJyF5iauFOC+Ba7zrbT2/1BaZ0PSevTjF0Pb
 /+tY4TYSaiRK4uE9tT+XJWaorU0kwWRcZ+NspdJuYZvEPJOwVLta1HLxQgsi2LuNni3+
 LWwBOAXeQ5+QVuvOT/6iKT6tLjZagE2BiC7VUvdIRNorFdCOcTFOde9VGkuYjCbBwotG
 u0Zd+i6KuifM/i242F1qXAnYTmOx5WsYZ3JG/VTjaeeNR/U9Pqndev9hx+VlvlYuCgSX
 Bflg==
X-Gm-Message-State: AOAM532LnGwkI9q99CsDgSL+5q/yw85rTibgBtx2SIiCsr964IQt6ywo
 sqfpKd0IC+H+967M8nPiYL2gNQ==
X-Google-Smtp-Source: ABdhPJyVPh/MP+xok4eNnL6IICz9yFWugy2q7G+GDgXi8Z/wRNwWTua9Dj2q+LfRii59WPG0Vad6Iw==
X-Received: by 2002:a05:6a00:174a:b0:433:9589:bdb5 with SMTP id
 j10-20020a056a00174a00b004339589bdb5mr11713777pfc.5.1631897636965; 
 Fri, 17 Sep 2021 09:53:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id h21sm6580708pfc.118.2021.09.17.09.53.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Sep 2021 09:53:56 -0700 (PDT)
Date: Fri, 17 Sep 2021 16:53:52 +0000
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 00/13] perf: KVM: Fix, optimize, and clean up callbacks
Message-ID: <YUTIIG4ZCKMbqrFi@google.com>
References: <20210828003558.713983-1-seanjc@google.com>
 <20210828201336.GD4353@worktop.programming.kicks-ass.net>
 <YUO5J/jTMa2KGbsq@google.com>
 <YURDqVZ1UXKCiKPV@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YURDqVZ1UXKCiKPV@hirez.programming.kicks-ass.net>
X-Mailman-Approved-At: Sun, 19 Sep 2021 06:09:08 -0400
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

On Fri, Sep 17, 2021, Peter Zijlstra wrote:
> On Thu, Sep 16, 2021 at 09:37:43PM +0000, Sean Christopherson wrote:
> So I don't mind exporting __static_call_return0, but exporting a raw
> static_call is much like exporting a function pointer :/

Ya, that part is quite gross.

> > The unregister path would also need its own synchronize_rcu().  In general, I
> > don't love duplicating the logic, but it's not the end of the world.
> > 
> > Either way works for me.  Paolo or Peter, do either of you have a preference?
> 
> Can we de-feature kvm as a module and only have this PT functionality
> when built-in? :-)

I agree that many of the for-KVM exports are ugly, especially several of the
perf exports, but I will fight tooth and nail to keep KVM-as-a-module.  It is
invaluable for development and testing, and in the not-too-distant future there
is KVM-maintenance related functionality that we'd like to implement that relies
on KVM being a module.

I would be more than happy to help explore approaches that reduce the for-KVM
exports, but I am strongly opposed to defeaturing KVM-as-a-module.  I have a few
nascent ideas for eliminating a handful of a random exports, but no clever ideas
for eliminating perf's for-KVM exports.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
