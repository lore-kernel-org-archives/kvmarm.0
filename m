Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8401C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  1 Nov 2022 20:28:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25D2F4BA2F;
	Tue,  1 Nov 2022 16:28:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eAgIg0ucEgF9; Tue,  1 Nov 2022 16:28:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13BD14BA85;
	Tue,  1 Nov 2022 16:28:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA35A4BA2F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2022 16:28:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZZkNdWeL050V for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Nov 2022 16:28:09 -0400 (EDT)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD1544B9DA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2022 16:28:09 -0400 (EDT)
Received: by mail-pj1-f47.google.com with SMTP id gw22so1368148pjb.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Nov 2022 13:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=7Q15eoBQW+ndVdEuHxmdR78/VIpdRnCY/gFW79Q5++Y=;
 b=JeRquhbkLaWQ4VXS0ZlfxU7Y8+xIVGl1+LdsPQ0hWDUsemLo7dmNUjfVG3XeWtQ+q6
 anOYfFqBxLnv8zuKUeuNSfJC6yWnnwaRxxvd3gf+tr+sN4tRYQJ9BFAcNmM51Nmm1y4/
 Ve0qZkEVA5+q3F865yXWV2l795oQInHr6YQ8EVAoPWaVtZSXmHDvtUvYOs+L9jwDIpH4
 d9gFRlhhChEJbDnUVO+mCaISyg5Rc3dqgckgKei9ZJmBfo2vdA09RgkQPWFNRdICRIjW
 QZ+tYvfviZe8jTh+Aetu+CrTUVBHson3qov5eGJuvniXk3JfoUiJeCHNjzBEM33zQVat
 HCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=7Q15eoBQW+ndVdEuHxmdR78/VIpdRnCY/gFW79Q5++Y=;
 b=G9mLGWyIfcIGUacTajCiilmubWQ5fN1c1L55Ua/85AFtE9cUFlxaMtiFquytO9RxWP
 4UsWiCR9wdNfHAUPjNtxhAUJLuIcUo6V/NZgYz3b84OL7tMlqkDsZMoXKF5kI+5vgtEU
 1Z8oerpmG8JVIYZn3DQFiohq4ZgDTnhJgsLjIXfs+yX5YwrlHMCChJwBs4WYUT9ZDRyG
 KUNFVoVRblSN+YmzCtiSyJhvL0QpCCfLPy3+A+K+GEVycIkGpTrm4GEgnrZ3t3aWTg88
 crl6q2qa2fAITtupDhvzqYjN0I//j5bSYbijVqt+WbScgOJpIKdpLTjD9PiLNh1cu52+
 BMXQ==
X-Gm-Message-State: ACrzQf0CtvxZOUWIdOWzfHoXw9cW82dBZScpJD5drAkSIAvyiXZBC/D3
 k2Q+8LHKSBTvsa9xIPib8MK03Q==
X-Google-Smtp-Source: AMsMyM7rdaSOxuZbjzEc/VEG8h7kZQ83nH1qpB3jBULH8y8Ns8Rm2Ic8D29LJAQbjO7QhKZuDJvUsQ==
X-Received: by 2002:a17:90a:54:b0:212:eb01:1ce with SMTP id
 20-20020a17090a005400b00212eb0101cemr39243143pjb.236.1667334488515; 
 Tue, 01 Nov 2022 13:28:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 u5-20020a17090a1f0500b0020dd9382124sm6315783pja.57.2022.11.01.13.28.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Nov 2022 13:28:07 -0700 (PDT)
Date: Tue, 1 Nov 2022 20:28:04 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v3 09/15] KVM: arm64: Free removed stage-2 tables in RCU
 callback
Message-ID: <Y2GBVML5MWXZE9Na@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027221752.1683510-10-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221027221752.1683510-10-oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thu, Oct 27, 2022, Oliver Upton wrote:
> There is no real urgency to free a stage-2 subtree that was pruned.
> Nonetheless, KVM does the tear down in the stage-2 fault path while
> holding the MMU lock.
> 
> Free removed stage-2 subtrees after an RCU grace period. To guarantee
> all stage-2 table pages are freed before killing a VM, add an
> rcu_barrier() to the flush path.

This is _very_ misleading.  The above paints RCU as an optimization of sorts to
avoid doing work while holding mmu_lock.  Freeing page tables in an RCU callback
is _required_ for correctness when allowing parallel page faults to remove page
tables, as holding mmu_lock for read in that case doesn't ensure no other CPU is
accessing and/or holds a reference to the to-be-freed page table.

IMO, this patch should to be squashed with the previous patch, "Protect stage-2
traversal with RCU".  One doesn't make any sense without the other.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
