Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51AE5C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 29 Sep 2022 12:47:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE85A40DAE;
	Thu, 29 Sep 2022 08:47:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Oug9qoZWqBdx; Thu, 29 Sep 2022 08:47:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1E3A40D05;
	Thu, 29 Sep 2022 08:47:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B015C40DAE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Sep 2022 08:47:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AjGQcoaTLMs6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Sep 2022 08:47:28 -0400 (EDT)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com
 [209.85.128.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C9EE40BA3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Sep 2022 08:47:28 -0400 (EDT)
Received: by mail-wm1-f46.google.com with SMTP id t4so877590wmj.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Sep 2022 05:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=/jd4X0PoFWLfTb4dd6/XSxqnO/9Pw1JPWNu/UEAiCLs=;
 b=UzJR1/QhrpVoNQ6vx8b8o/LAuxQxzwp9Fvojkzml8Jtqh8nvajBpKK7UBqYIbYvB55
 86K9EZmdHroH1k2CUOcxZTMO/a3jHhqvXobkE1fDEd9o8OXL6zVzky7uvkSM0PhpHQ1a
 Qqf1whTb8vvdcnUsTbTiIA6AL7eWfKB6rd0GPjEdKqIKCcuIfrLjjTSH4S99hzLxy/al
 61uMdpcCczvTrIX8qkjyzGpZ6CtcNE7h3/QMpIaUwLNopvTOCFciWhF34bTduFugRHsD
 MIzi+YYzsAvyAdF/vyTThrlnFxt2eM7bsY1kvHexFAGBUVE2LL31LLoK5yuu95Mr92SV
 5oPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=/jd4X0PoFWLfTb4dd6/XSxqnO/9Pw1JPWNu/UEAiCLs=;
 b=PKGhBhbM7EI11itL+3favjfOsDqWp1MI4BMxpt1EccAs4dHQwoFzihflRIq/+5IV7V
 pqoxz613s4AObX/sJ6Mf85BlJKS5EI0PjhRV12Nf9tMpZtUZ/DGSxeswfITRODnlKSSk
 nowctq6u2xrbJy/RWyE4trt3Eu1ylOoArtXE3dfb0K6RbGD41zzbUTSleIUIKuhTC+ou
 vJIeSUpj6IR2+EMq9IO91b1AwzBsYLtfAqkUtr2kA9fT+svv6IYcWlP4s7rO6BCuLYn1
 JBSNo7V+HnjjRCu2b/qTWVZ/V7zSDyzV+C2KzzvyOpDwJGJKXEn5KKCXk7mCJJd2qolg
 mPZw==
X-Gm-Message-State: ACrzQf2WCi2CbL8ZJi1dDXv4makGvsfWPPjte+Y0Ni3gvpUkdtIol7+T
 +V3A1T97LDX4sicYS71SdtfeKQ==
X-Google-Smtp-Source: AMsMyM6lFmmDsnTBsYGsUilgz1qsYoqs/Bj1fKUttIQLqYZ6GsaMUyreS6XVuyHNwrGTHpteA4T6cg==
X-Received: by 2002:a05:600c:268f:b0:3b4:acef:34ab with SMTP id
 15-20020a05600c268f00b003b4acef34abmr2158749wmt.176.1664455647433; 
 Thu, 29 Sep 2022 05:47:27 -0700 (PDT)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
 by smtp.gmail.com with ESMTPSA id
 m67-20020a1c2646000000b003a342933727sm4281494wmm.3.2022.09.29.05.47.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Sep 2022 05:47:26 -0700 (PDT)
Date: Thu, 29 Sep 2022 13:47:22 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 00/25] KVM: arm64: Introduce pKVM hyp VM and vCPU
 state at EL2
Message-ID: <YzWT2lxN/u4y/YHQ@google.com>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kvmarm@lists.cs.columbia.edu
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

On Wed, Sep 14, 2022 at 09:34:35AM +0100, Will Deacon wrote:
> Hi folks,
> 
> This is v3 of the series previously posted here:
> 
>   Mega-series: https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/
>   v2: https://lore.kernel.org/all/20220630135747.26983-1-will@kernel.org/
> 
> There have been some significant changes since v2, including:
> 
> - Removal of unnecessary backpointer linking a hyp vCPU to its hyp VM in
>   favour of container_of()
> 
> - Removing confusing use of 'shadow' at EL2 in favour of 'pkvm_hyp'
>   (although this was much more work than a simple sed expression!)
> 
> - Simplified vm table lookup and removal of redundant table traversal
> 
> - Rework of the hypervisor fixmap to avoid redundant page-table walks
> 
> - Splitting of memory donations required to create a guest so that the
>   requirement for physically-contiguous pages is reduced
> 
> - Fixed a memory leak when the stage-2 pgd is configured with an
>   unsupported size
> 
> - Dropped rework of 'struct hyp_page' as it is not required by this
>   series
> 
> - Improved commit messages
> 
> - Rebased onto v6.0-rc1
> 
> Oliver -- as discussed in person, I've left the owner ID enumeration
> where it is for now since we will need to track the guest *instance* in
> future and so consolidating this into the pgtable code is unlikely to be
> beneficial.
> 
> As with the previous posting, the last patch is marked as RFC because,
> although it plumbs in the shadow state, it is woefully inefficient and
> copies to/from the host state on every vCPU run. Without the last patch,
> the new structures are unused but we move considerably closer to
> isolating guests from the host.
> 
> Cheers,

Tested on silicon, especially that all the donations are recovered on VM
teardown.

Tested-by: Vincent Donnefort <vdonnefort@google.com>

[...]
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
