Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7837C43334
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jul 2022 21:11:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2728E4BA53;
	Thu,  7 Jul 2022 17:11:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hnQ50RSU8WJZ; Thu,  7 Jul 2022 17:11:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0891E4BA5A;
	Thu,  7 Jul 2022 17:11:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A7194BA53
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jul 2022 17:11:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5iIatMV9lIYs for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jul 2022 17:11:32 -0400 (EDT)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 075564B9DD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jul 2022 17:11:31 -0400 (EDT)
Received: by mail-pf1-f170.google.com with SMTP id o12so8286169pfp.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Jul 2022 14:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ZTnfo6xRgRnDJAawujjn6RVFJwv9JbaWoUFvSQYT7gc=;
 b=b6mVfEU3B1Kz+nxNI3jjT4RpusLpAVsVtGCThcqz2WxsNk8Y3tI17P9xznRGksBAb+
 8GtcLKGD6SqLecoii/sJRZBzYe/oHHfCmBQ6KyjOUKEs9JbhsSO8LlGC7Gg3qZOKpu6t
 R+U7jZ4wKm/B+FwKq2Z/bXAYtTf5NK7zJgDRNJHgaUVfPSOGNvaRqHsaiOSfkPwSd99I
 8OUzNcHpzBwaMfSLWuFKpCaWhXyShGNvFjcSuQGRbO512wy3OM/j+/9PUvBMJJDZlQt4
 pVg+ex6bvlhCnCQYp6vGAzpwe0MyOM/LaQwAKdRF13SuWllj3O+oHHym/YUmAyOh3Fqs
 358g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ZTnfo6xRgRnDJAawujjn6RVFJwv9JbaWoUFvSQYT7gc=;
 b=Ll8lmwWKxif+sn9YEtnzoOEaJcVXBbvA0ZFNVDtEMhGUrkzExfs+zOSotmQ7k0x1XX
 VIeC9RZ+oVrPnxhEJAPcaaD1UobPf1ZUG5jLlLpXdOkd+pQ8NFOZf40Sz5Ly8yNN8QI7
 1Yb1psey1I0+AKL5mV3f+zcjqxq9/1k94gb0TnVyVVZLjrZ8vJ0jkdoblY60MCL145qy
 KtBeyldAnsjc2G2SBpoe0F/Ax04EN/FgNNCojl1HFFOZhIIcuCvDlrYfAOtBCFGjQGvs
 Pp4iyzNMFbLBwu1xixrFS5rpnrW5EKFH4NvLls3rcWfbABXV59SplILNUE/iktgcnRjA
 99CA==
X-Gm-Message-State: AJIora9tCMb49LubxA5zyaPhypU0SVce6uz+M0gIRjfbnuc3nnmq3vIU
 KNu/StaauUGzinpuJvM4U26aXg==
X-Google-Smtp-Source: AGRyM1so1CUFpRb/W+9u8G0bNWrE/aR8hrt1uZojq1495gVto4hEMFt63EXSJhIZ1QbYWGtmOiiswQ==
X-Received: by 2002:aa7:9215:0:b0:528:56ba:ccec with SMTP id
 21-20020aa79215000000b0052856baccecmr179112pfo.24.1657228290881; 
 Thu, 07 Jul 2022 14:11:30 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 k23-20020a628417000000b005289fad1bbesm3853638pfd.94.2022.07.07.14.11.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 Jul 2022 14:11:30 -0700 (PDT)
Date: Thu, 7 Jul 2022 21:11:26 +0000
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v6 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
Message-ID: <YsdL/mgrbCCM/mtr@google.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-4-yosryahmed@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220628220938.3657876-4-yosryahmed@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, linux-mm@kvack.org,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org, Huang@google.com,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> Count the pages used by KVM mmu on x86 in memory stats under secondary
> pagetable stats (e.g. "SecPageTables" in /proc/meminfo) to give better
> visibility into the memory consumption of KVM mmu in a similar way to
> how normal user page tables are accounted.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
