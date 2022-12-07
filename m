Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A228F51
	for <kvmarm@lists.linux.dev>; Wed,  7 Dec 2022 23:44:54 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso2963254pjt.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Dec 2022 15:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=I2XUVKs77jOBEVKreO6gXUrR5/C8h8dAS/nczUC+jbeUj2W+4ddSPgnp81E4cQz8J2
         qRfHyxiDCaMGsR9eFAvHDzW6zqmBAHVd1Oj73LDSIxZMrYr3CUWDnZayvtZ0XKplu8X/
         oKWJ9VwTftehUTL6PSWO5AZ/QwaGhX5NKAi7yFFwnuXplh/o6gsJxba5q1VuEI4J1ELN
         yzuyxW9JVzfPPQkSqhj5mcbm1bfvLpvihIuhY3BXfNfO1OPj1YCEE2w2WQuF2zkHc75b
         wAKf8KtT4tZxVXKUIYMaWceyFs3a1U1lfMbcnr5qnxOgItgBcJ3tdtJ3hxv/Hs2Wx4it
         wzbA==
X-Gm-Message-State: ANoB5plmgiq91Oeg/WpElYicrsDvUPq/v2br9mMldBPJ4j1LigWmpIVG
	dC2xzbMw1d8hgtD5giH7Zfi6lA==
X-Google-Smtp-Source: AA0mqf5f+HSDTe/eFvdYT1KQV50ny+OsSgkb0jaUxxexfrGcapWSrpNJd+KINOsgbiEg2Rw5vCDanA==
X-Received: by 2002:a17:90a:55c2:b0:219:f970:5119 with SMTP id o2-20020a17090a55c200b00219f9705119mr590148pjm.1.1670456693817;
        Wed, 07 Dec 2022 15:44:53 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w10-20020a170902e88a00b001868ed86a95sm15155465plg.174.2022.12.07.15.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 15:44:53 -0800 (PST)
Date: Wed, 7 Dec 2022 23:44:50 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Andrew Jones <andrew.jones@linux.dev>,
	Peter Gonda <pgonda@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] KVM: selftests: Allocate ucall pool from
 MEM_REGION_DATA
Message-ID: <Y5ElcibE2CubONgm@google.com>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-5-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207214809.489070-5-oliver.upton@linux.dev>
Message-ID: <20221207234450.53WA5M6qlWTVmdWGregDfnWGoMy09nTIshrs8vpV-5o@z>

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
