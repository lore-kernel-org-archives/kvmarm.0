Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F271C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  2 Apr 2022 01:06:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 021F24B1F4;
	Fri,  1 Apr 2022 21:06:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dVAZAO8CTDIe; Fri,  1 Apr 2022 21:06:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B93CE4B202;
	Fri,  1 Apr 2022 21:06:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A09624B1F4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 21:06:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YT4W3L6tHuTC for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 21:06:35 -0400 (EDT)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6713B4B1ED
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 21:06:35 -0400 (EDT)
Received: by mail-pj1-f47.google.com with SMTP id
 l4-20020a17090a49c400b001c6840df4a3so4038776pjm.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 18:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :cc:references:from:in-reply-to:content-transfer-encoding;
 bh=5o4M1jt8/ZpdgJUd2875rzc8tpkN1WNPorh2WI+3lZ8=;
 b=dc5UAyygErJO8iyx0dcQihKdzdVGEyuh+t/WdSeO66Qdkb0Ne9fhFHd6oKfXEHRbmW
 JStauTPUD8uupns8twdhv8/MWhA3BlGF7QwGbmkwh+JQMI/xVZoYP47OoVZZ5RZxJzNO
 OZGC0HWPJvuxC7tIE5rKKkTY/ejxW2P+N09s5s5TtJDUJ0dv1V2PwfTBTE+dVjucALdD
 cOXy9LxeAj9LI54O9wSVn98F3eiL3Uw34eNa8TUHyZND/J0Do+maqdPR5Fu1xJ7gRcTw
 gkVJskeS+TYnPy3kGiBHxxEALiodFO6BaUiWDvkALZHxGm7eWlgdyAvYOBSd09vV0kpx
 IsGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=5o4M1jt8/ZpdgJUd2875rzc8tpkN1WNPorh2WI+3lZ8=;
 b=ZTfQQXH+RLraS3V5Y/h+4+W7xIX/eoX0F/wKZRO2qNyxzGiHLhW7K7lfh4t32jxFMe
 ffv/z0uyYavIYPCmkj97myMwkEvDS/vBpFHAUmM8T64755pRrrvEFFD0EVJypFBkgryV
 Dy4uGPwmIIOh8YmgOhUuoq3evAY/NnNqufiQhnEYqnVgkzA5+7O+PafbH47h4M3PNaXQ
 Sae+fGnyv3EX7kiMv/+MJk4rjBv/HlRDF4rHOto5CqRYljgXoBYuYMjUgOmF5X6b+/iD
 x+xURCXSQrpg0WEeVyXQQmCrt6VncLf9znXZ99rfqLdDMcOb835PYWYlRn3D/KB28Ob7
 Feng==
X-Gm-Message-State: AOAM532rzJbqp+8qAQkKWhoc4SZ0XRWPhOdTJmZwFHxP7GwF/O14noNu
 s9V+No7QW5Ss6qG+0vbZAPjcBA==
X-Google-Smtp-Source: ABdhPJzmiwkZKL8SxSPErXY6pjhLYJDKuQFxkiRneInmGR/TOIDE0tVjGRjgIJ1HGU4g1fOWOK4DZw==
X-Received: by 2002:a17:902:b7cb:b0:154:57eb:c754 with SMTP id
 v11-20020a170902b7cb00b0015457ebc754mr12518946plz.2.1648861593168; 
 Fri, 01 Apr 2022 18:06:33 -0700 (PDT)
Received: from [192.168.86.237]
 (107-203-254-183.lightspeed.sntcca.sbcglobal.net. [107.203.254.183])
 by smtp.gmail.com with ESMTPSA id
 p19-20020a17090b011300b001ca44029199sm1718097pjz.16.2022.04.01.18.06.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 01 Apr 2022 18:06:32 -0700 (PDT)
Message-ID: <796a4d51-f697-1e99-c8ac-20ab26cc635a@google.com>
Date: Fri, 1 Apr 2022 18:06:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] KVM: arm64: Don't split hugepages outside of MMU write
 lock
Content-Language: en-US
To: Oliver Upton <oupton@google.com>, kvmarm@lists.cs.columbia.edu
References: <20220401194652.950240-1-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
In-Reply-To: <20220401194652.950240-1-oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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

On 4/1/22 12:46 PM, Oliver Upton wrote:
> It is possible to take a stage-2 permission fault on a page larger than
> PAGE_SIZE. For example, when running a guest backed by 2M HugeTLB, KVM
> eagerly maps at the largest possible block size. When dirty logging is
> enabled on a memslot, KVM does *not* eagerly split these 2M stage-2
> mappings and instead clears the write bit on the pte.
> 
> Since dirty logging is always performed at PAGE_SIZE granularity, KVM
> lazily splits these 2M block mappings down to PAGE_SIZE in the stage-2
> fault handler. This operation must be done under the write lock. Since
> commit f783ef1c0e82 ("KVM: arm64: Add fast path to handle permission
> relaxation during dirty logging"), the stage-2 fault handler
> conditionally takes the read lock on permission faults with dirty
> logging enabled. To that end, it is possible to split a 2M block mapping
> while only holding the read lock.
> 
> The problem is demonstrated by running kvm_page_table_test with 2M
> anonymous HugeTLB, which splats like so:
> 
>    WARNING: CPU: 5 PID: 15276 at arch/arm64/kvm/hyp/pgtable.c:153 stage2_map_walk_leaf+0x124/0x158
> 
>    [...]
> 
>    Call trace:
>    stage2_map_walk_leaf+0x124/0x158
>    stage2_map_walker+0x5c/0xf0
>    __kvm_pgtable_walk+0x100/0x1d4
>    __kvm_pgtable_walk+0x140/0x1d4
>    __kvm_pgtable_walk+0x140/0x1d4
>    kvm_pgtable_walk+0xa0/0xf8
>    kvm_pgtable_stage2_map+0x15c/0x198
>    user_mem_abort+0x56c/0x838
>    kvm_handle_guest_abort+0x1fc/0x2a4
>    handle_exit+0xa4/0x120
>    kvm_arch_vcpu_ioctl_run+0x200/0x448
>    kvm_vcpu_ioctl+0x588/0x664
>    __arm64_sys_ioctl+0x9c/0xd4
>    invoke_syscall+0x4c/0x144
>    el0_svc_common+0xc4/0x190
>    do_el0_svc+0x30/0x8c
>    el0_svc+0x28/0xcc
>    el0t_64_sync_handler+0x84/0xe4
>    el0t_64_sync+0x1a4/0x1a8
> 
> Fix the issue by only acquiring the read lock if the guest faulted on a
> PAGE_SIZE granule w/ dirty logging enabled. Add a WARN to catch locking
> bugs in future changes.
> 
> Fixes: f783ef1c0e82 ("KVM: arm64: Add fast path to handle permission relaxation during dirty logging")
> Cc: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
