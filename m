Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11987C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Feb 2022 18:57:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6054449ED7;
	Tue, 15 Feb 2022 13:57:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CVfpSBtUU05E; Tue, 15 Feb 2022 13:57:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A702749ED2;
	Tue, 15 Feb 2022 13:57:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83DAC49ECF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 13:57:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NpY9GeMz8Uje for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Feb 2022 13:57:53 -0500 (EST)
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com
 [209.85.166.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3853A49EBF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 13:57:53 -0500 (EST)
Received: by mail-io1-f54.google.com with SMTP id h5so1390132ioj.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 10:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=xYfVux+CIlABTBnGP+1TuKUKEth7AQ/+EngXOD7SJRc=;
 b=c0Itl5iwd/n5gn0l5gRQjED/Gm+0SUMu0QvAZlzu6Uunay0OCCnebIYN2QLWE/vgr0
 b1SRkggvbPIBirN3uR9G5/FqbZZKRlx3HIl6zHi42iNs9pE++n4yCWMnWxJsWqTcwU97
 y2RWZMGWmQAMWgWTGZH6Hw6PF/jimIW8xqlfEhLrp3ruxE/g8+tVDBosnyy5nZH+16bF
 RyFh4PQA5cMTq7MPRu9GGizYCvIm5yOLfVSYyjfCM01wVqZged3cV+8o2n2goyKDU05h
 E2Rf2bZhDgmsgls83iQbHlO7n8aKBGV3ARfKHLKQIIYuZ5+qtEwnDjS8agz5x+/My3w8
 OQfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xYfVux+CIlABTBnGP+1TuKUKEth7AQ/+EngXOD7SJRc=;
 b=TANFNP91yjtLh6TnXozXmFyzS0qOr8vQuH9aKtawchRTczdKiEQndjQOOyDEXf9GmJ
 HtwoQFsQc3l8TzCpSc6O/r5S9Q3ctViyOjYZ8O9Uf8n/R2yb8E6c2yLnMYSl8FpawtIs
 GhPgHlsw+QZWna7WhrjDp6v71ikRPNxpNftK9DKbOWXM3Pu+vAixTzMy/LNV01IsVLVI
 ZXb8MD0Vw66saCKRiOUgkEgtZLQwzw8aM0LbwUd2buqfS0aS45GvPoy1Ztpu6b/Q+E01
 OG5e82eIpny9kltCxSubSV+dK036tcf43qIu4yRJG9rbnTjXfJA0kkGIapVxuNTKFGb/
 vFBg==
X-Gm-Message-State: AOAM5320gQaMJjcFDYfklcGKX4WTPvYureGpdwNGMLdnLq6P8wtO/J39
 jBGutAzTR6gLcJA4a4uQOZYzdw==
X-Google-Smtp-Source: ABdhPJwBqvknVuwUJVoIKC4yoStt6Wy8q4gp/ncMH7iNUF6wTE+Enpcr3H0D3NZSs3azu2iT2aFs3Q==
X-Received: by 2002:a02:c90a:: with SMTP id t10mr220027jao.142.1644951472295; 
 Tue, 15 Feb 2022 10:57:52 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id t195sm16834393iof.47.2022.02.15.10.57.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Feb 2022 10:57:51 -0800 (PST)
Date: Tue, 15 Feb 2022 18:57:47 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v5 10/27] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
Message-ID: <Ygv3q/+arejIWnzs@google.com>
References: <20220214065746.1230608-1-reijiw@google.com>
 <20220214065746.1230608-11-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220214065746.1230608-11-reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Reiji,

On Sun, Feb 13, 2022 at 10:57:29PM -0800, Reiji Watanabe wrote:
> When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> expose the value for the guest as it is.  Since KVM doesn't support
> IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> expose 0x0 (PMU is not implemented) instead.
> 
> Change cpuid_feature_cap_perfmon_field() to update the field value
> to 0x0 when it is 0xf.

Definitely agree with the change in this patch. Do we need to tolerate
writes of 0xf for ABI compatibility (even if it is nonsensical)?
Otherwise a guest with IMP_DEF PMU cannot be migrated to a newer kernel.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
