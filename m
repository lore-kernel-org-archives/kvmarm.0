Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D994C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 17:25:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0554F49F4B;
	Thu, 10 Feb 2022 12:25:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HJEwwvp36Bgz; Thu, 10 Feb 2022 12:25:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4795449F2C;
	Thu, 10 Feb 2022 12:25:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C6F249F0B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 12:25:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JlGJPDmxEB9o for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 12:25:51 -0500 (EST)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95EB449EF3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 12:25:51 -0500 (EST)
Received: by mail-pl1-f182.google.com with SMTP id y7so2418649plp.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 09:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=RpI/Pc77MpSRjpUPrJOrramDZi3SB+e1ryNxx/yPgHo=;
 b=YXn1/quEkEPJgPghKbNEXhPloXCwF+kn0GrB0c72VWDmu5+C+iufjiqJX/Zr7tVpW0
 8tLNF97X6qmvnQBaBY8UiMvsEdFogDhcq51cd3xJnjlHtp10MEyoS6K8wvvsjfuoZ6GL
 t+mcZcxRnOedetqu/7SyA2Pwqhgh0s1LcWI7ECfu79Vim90OsZtmrhyYuap4IxhilZ2E
 sX/t8sg5u3YmXdN5ZDW9yazi1ftIZNy+CwmnPouwTvr3AdttbsByYH12cY8v0T+AtNuS
 kjC4ReI5peTud5+z+aE8jKm8jkKB3ooVnAM9lZixP/HtGqMLYuY2ge7zwlAeV07PF5Gq
 oMXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=RpI/Pc77MpSRjpUPrJOrramDZi3SB+e1ryNxx/yPgHo=;
 b=bmxRJPPFF3GSWTIRMogqAiTipkNqTZh2XR4LArXL6SemOTLDCn/q2827x6alA5gWkT
 VahMLtShVn3OaWjrJQ1LP8UXDhIzYMrK59yLgzofw/lS7/xmHLc/LFvwi3H8xEcDvkyz
 nPueaxD+T4j0uUrwrvpmdBgqp4zRPOfixdr+KqDUzRlYpZ1byyI5BTcGNrOtcZhASvDC
 0QQazMz9IgzZsMCPGoVA88ynm7YF1iciwyLEHs2Oyvr/Rle0Bs+ClMCz3C6Q+O6ssqx2
 y5+l1wMvTfkDpC3UKOmFeQB7Om07e7M5UJtU0P0VBN7nEwy34CNQbOOugXOWfT4p0Doq
 8Tsg==
X-Gm-Message-State: AOAM5336nJpLOP0YFsw38c6HgeBOqEvMbIeH98qfkgZNz+LifLX24Q8V
 gigN9UYjVZZZLK6kA5Yu7qvo8w==
X-Google-Smtp-Source: ABdhPJwGUlWFmBPzh0GMITsa52rZCyLCgNTJR2YZipN8WICLLLDonkxqL5M8Iq/HWVX+SCN8uZE1xA==
X-Received: by 2002:a17:903:2410:: with SMTP id
 e16mr8503196plo.19.1644513950416; 
 Thu, 10 Feb 2022 09:25:50 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id k16sm24344783pfu.140.2022.02.10.09.25.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 10 Feb 2022 09:25:49 -0800 (PST)
Date: Thu, 10 Feb 2022 17:25:46 +0000
From: Sean Christopherson <seanjc@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
Message-ID: <YgVKmjBnAjITQcm+@google.com>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220210150943.1280146-1-alexandru.elisei@arm.com>
Cc: thuth@redhat.com, kvm@vger.kernel.org, zixuanwang@google.com,
 kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, varad.gautam@suse.com
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

On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> I renamed --target-efi to --efi-payload in the last patch because I felt it
> looked rather confusing to do ./configure --target=qemu --target-efi when
> configuring the tests. If the rename is not acceptable, I can think of a
> few other options:

I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
seems like it would be sufficient.

> 1. Rename --target to --vmm. That was actually the original name for the
> option, but I changed it because I thought --target was more generic and
> that --target=efi would be the way going forward to compile kvm-unit-tests
> to run as an EFI payload. I realize now that separating the VMM from
> compiling kvm-unit-tests to run as an EFI payload is better, as there can
> be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> a test runner, so I think the impact on users should be minimal.

Again irrespective of --target-efi, I think --target for the VMM is a potentially
confusing name.  Target Triplet[*] and --target have specific meaning for the
compiler, usurping that for something similar but slightly different is odd.

But why is the VMM specified at ./configure time?  Why can't it be an option to
run_tests.sh?  E.g. --target-efi in configure makes sense because it currently
requires different compilation options, but even that I hope we can someday change
so that x86-64 always builds EFI-friendly tests.  I really don't want to get to a
point where tests themselves have to be recompiled to run under different VMMs.

[*] https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.69/html_node/Specifying-Target-Triplets.html
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
