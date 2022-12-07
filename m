Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD64C63703
	for <kvmarm@archiver.kernel.org>; Wed,  7 Dec 2022 23:45:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54F9E4B638;
	Wed,  7 Dec 2022 18:45:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GJ7ZXAE1HxLk; Wed,  7 Dec 2022 18:45:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17D424B285;
	Wed,  7 Dec 2022 18:45:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D0534B841
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 18:45:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yFy+CLsye7pn for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Dec 2022 18:44:58 -0500 (EST)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 44F7B4B802
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 18:44:58 -0500 (EST)
Received: by mail-pj1-f54.google.com with SMTP id
 q17-20020a17090aa01100b002194cba32e9so2944292pjp.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Dec 2022 15:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=6iCaSQa1HFCfJ8+bX1upEoM6MTaIn0UmKgjdPtgAjjc=;
 b=KkMIutKijaPJLWWpORIH3M7DoEIXJXVArWkiJXMSz8T5xYL8iAo5sVXEy6sqiKL4Q6
 GzONfdpncDOio5lHMt6K32MFchEpLDDS74m0k84wySF8/xUSWPDlRO2qHTFx5CJMTPXs
 Pz6umlCMMEx5buAmxJt9/iKpq4sAYZrlfHRHXCB8Qi05gvNYWM87iJwBVi1GJFkHaJdf
 ee9nlI6HgLtZD0zr9k1FZwi8siSZ1tDbxVjExGf5o7x44QyiPbec1tbcxkvIpEzPWM9t
 c8szkfNSqQIk+eipVkW44sLAkuj6/o8y3vDsWwtHW9Cp/VMEqkIeC4CwH84SP4Y+4+N9
 mnbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=6iCaSQa1HFCfJ8+bX1upEoM6MTaIn0UmKgjdPtgAjjc=;
 b=Ne/QDCDbEeeWUc4zaqprMDta6cgd9dIgkUzKMUoXYWt6v+cEu+/FVatUCTFXjFXv5x
 dYg8UWBGPOS4wk+Bhsnam5RBaoAAjCKrf3o+69mxgyRdNUPr43mOu6LUgyYS+uQCwBTY
 wfn34qGdCnua9ouETfH2bKlAS76E4xqMmt0WBUA9IzkSaOYv1bnWzzHT9XPGgIEfJV4K
 wjHjs61AmOl50dQ9HsA4ZeHbDPwb0cXLKbU0UQMwGyhVrVDnnXwKw/ooatlr9wo+XNzq
 hYdw/64k0NYSB2ygbk3c7jPNYhUGIGWJlLrnF/qhbDVX+jFZKjIAj1MK7rBjW/hJZ2lh
 tVgA==
X-Gm-Message-State: ANoB5pk9hVOq46W6t2e98UKX1tLIE52Fsn3Ie1MkUBg9BtyUC8ZDJVgj
 pgy+RQJToCgYZGsbU6GQK/uI9w==
X-Google-Smtp-Source: AA0mqf5f+HSDTe/eFvdYT1KQV50ny+OsSgkb0jaUxxexfrGcapWSrpNJd+KINOsgbiEg2Rw5vCDanA==
X-Received: by 2002:a17:90a:55c2:b0:219:f970:5119 with SMTP id
 o2-20020a17090a55c200b00219f9705119mr590148pjm.1.1670456693817; 
 Wed, 07 Dec 2022 15:44:53 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 w10-20020a170902e88a00b001868ed86a95sm15155465plg.174.2022.12.07.15.44.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 07 Dec 2022 15:44:53 -0800 (PST)
Date: Wed, 7 Dec 2022 23:44:50 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 4/4] KVM: selftests: Allocate ucall pool from
 MEM_REGION_DATA
Message-ID: <Y5ElcibE2CubONgm@google.com>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-5-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221207214809.489070-5-oliver.upton@linux.dev>
Cc: linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Andrew Jones <andrew.jones@linux.dev>, Peter Gonda <pgonda@google.com>,
 kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Wed, Dec 07, 2022, Oliver Upton wrote:
> MEM_REGION_TEST_DATA is meant to hold data explicitly used by a
> selftest, not implicit allocations due to the selftests infrastructure.
> Allocate the ucall pool from MEM_REGION_DATA much like the rest of the
> selftests library allocations.
> 
> Fixes: 426729b2cf2e ("KVM: selftests: Add ucall pool based implementation")

Not that it really matters because no one will backport this verbatim, but this
is the wrong commit to blame.  As of commit 426729b2cf2e, MEM_REGION_DATA does not
exist.  And similarly, the common ucall code didn't exist when Ricardo's series
introduced MEM_REGION_DATA.

  $ git show 426729b2cf2e:tools/testing/selftests/kvm/include/kvm_util_base.h | grep MEM_REGION_DATA
  $ git show 290c5b54012b7:tools/testing/selftests/kvm/lib/ucall_common.c
  fatal: path 'tools/testing/selftests/kvm/lib/ucall_common.c' exists on disk, but not in '290c5b54012b7'

The commit where the two collided is:

Fixes: cc7544101eec ("Merge tag 'kvmarm-6.2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD")

> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---

Fixes nit aside,

Reviewed-by: Sean Christopherson <seanjc@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
