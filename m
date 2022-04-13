Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66569C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Apr 2022 18:28:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C606C49E3A;
	Wed, 13 Apr 2022 14:28:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3y1cCD7jFItx; Wed, 13 Apr 2022 14:28:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C27C349E46;
	Wed, 13 Apr 2022 14:28:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD9D749E3A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 14:28:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RTfTA5uWwyU2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Apr 2022 14:28:21 -0400 (EDT)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C19E74141A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 14:28:21 -0400 (EDT)
Received: by mail-pg1-f173.google.com with SMTP id t4so2569263pgc.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 11:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=bpeKB101GiB4lxea+Vei5KAP2vPrN2mAl+5Iy4JIo1Y=;
 b=hSS+V6AJRz170U3P+2UqpwQ5nmzP1chGiCMEpvco/3ng23jK7nkez9K1F+P4cRXQjO
 YSsOdRh0ob/PxY68/0Y/VELl5VQowOxyFpT9XPmnxFvhgOMwtKOeko/YZwR12NjPm/AN
 rztaKQwC/WhmgPfRgIg3aarP/B37AhZS6JUH1dW7S9ZCTAhfmLAt52in0ht8+hzQwrdb
 cuqY1xSpSWScCLE+3OLpp0PfmNkLXJw+2W4WH8WJPkgIpiPFD9LktmKo59tCfPclJ4gv
 aIsOm9E4RLexPhl6n3Rg/6l3RvqmNX5LuUt+M+Evoer+5fHEseA6lLSYh4fIXsahLxbx
 191w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=bpeKB101GiB4lxea+Vei5KAP2vPrN2mAl+5Iy4JIo1Y=;
 b=Wxq1REPtYMlSRs4aO9jiQHB9IOSrKdTKIum8k2/kz1XAxRi7xD7jyqktMnMlBp4Ike
 cGjOhfwavzTF6aBpCh3z6IZ43BXbT/p5nxKLCQO84z4JcPAeuIgNT+AdR0cQ8G0oZS3X
 UUv6S4iPi1VPe9ixnPc3gH80q5e8shpKhTR34YBXJJ7A3uOGLIv79zBN06RxJVR30kSd
 fF7l0zpVctdOukWwPIzafbpuWti5pYgkNLZddGsZeVOYhILCeeunqMciCHV5ShpWJQF1
 cpAYrm/ug09u7xkPSZqoth6wAxhXUqlSX5FsPphwzbtCWpuWasFCpEBwqDtlbL8K4W/U
 F7uA==
X-Gm-Message-State: AOAM533EaQ2h+nP/KClsRcGP+DiG29AQiLASye1kqJpynzbdG+xPjcVG
 MD5pmO03IHt/0Mqii/Mg1x/+KQ==
X-Google-Smtp-Source: ABdhPJwVoOa8Dj+YAhZ33kjw7NtyqOGLBfa4tCRI9XDyKQYayiKcuB3O+jKCPUAV/nNuh3GKhHrCig==
X-Received: by 2002:a65:560e:0:b0:39d:7613:94cf with SMTP id
 l14-20020a65560e000000b0039d761394cfmr10974179pgs.196.1649874500603; 
 Wed, 13 Apr 2022 11:28:20 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 n19-20020a62e513000000b005048eef5827sm24973743pff.142.2022.04.13.11.28.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 13 Apr 2022 11:28:19 -0700 (PDT)
Date: Wed, 13 Apr 2022 18:28:15 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 00/23] KVM: Extend Eager Page Splitting to the shadow
 MMU
Message-ID: <YlcWP5Z3osvUg0Ia@google.com>
References: <20220401175554.1931568-1-dmatlack@google.com>
 <YlRhiF1O71TWQr5r@google.com>
 <CALzav=f_WY7xH_MV8-gJPAVmj1KjE_LvXupL7aA5n-vCjTETNw@mail.gmail.com>
 <YlSLuZphElMyF2sG@google.com>
 <CALzav=fGucZOZjbVE2+9PZVf1p+jP7GBYDpPph5PoU552LELsw@mail.gmail.com>
 <YlTKQz8HVPtyfwKe@google.com>
 <CALzav=dz8rSK6bs8pJ9Vv02Z7aWO+yZ5jAA8+nmLAtJe3SMAsA@mail.gmail.com>
 <YlYhO7GvjKY1cwHr@google.com> <YlcPIYJ0CB2qnfpT@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YlcPIYJ0CB2qnfpT@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Wed, Apr 13, 2022, David Matlack wrote:
> On Wed, Apr 13, 2022 at 01:02:51AM +0000, Sean Christopherson wrote:
> > There will be one wart due to unsync pages needing @vcpu, but we can pass in NULL
> > for the split case and assert that @vcpu is non-null since all of the children
> > should be direct.
> 
> The NULL vcpu check will be a little gross,

Yeah, I would even call it a lot gross :-)

> but it should never trigger in practice since eager page splitting always
> requests direct SPs. My preference has been to enforce that in code by
> splitting out

It still is enforced in code, just at different points.  The split version WARNs
and continues after finding a page, the below WARNs and rejects _while_ finding
the page.

Speaking of WARNs, that reminds me... it might be worth adding a WARN in
kvm_mmu_get_child_sp() to document (and detect, but more to document) that @direct
should never encounter an page with unsync or unsync_children, e.g. 

	union kvm_mmu_page_role role;
	struct kvm_mmu_page *sp;

	role = kvm_mmu_child_role(sptep, direct, access);
	sp = kvm_mmu_get_page(vcpu, gfn, role);

	/* Comment goes here about direct pages in shadow MMUs? */
	WARN_ON(direct && (sp->unsync || sp->unsync_children));
	return sp;

The indirect walk of FNAME(fetch)() handles unsync_children, but none of the other
callers do.  Obviously shouldn't happen, but especially in the huge page split
case it took me a second to understand exactly why it can't happen.

> but I can see the advantage of your proposal is that eager page splitting and
> faults will go through the exact same code path to get a kvm_mmu_page.
> __kvm_mmu_find_shadow_page(), but I can see the advantage of your
> proposal is that eager page splitting and faults will go through the
> exact same code path to get a kvm_mmu_page.
> 
> > 
> > 		if (sp->unsync) {
> > 			if (WARN_ON_ONCE(!vcpu)) {
> > 				kvm_mmu_prepare_zap_page(kvm, sp,
> > 							 &invalid_list);
> > 				continue;
> > 			}
> > 
> > 			/*
> > 			 * The page is good, but is stale.  kvm_sync_page does
> > 			 * get the latest guest state, but (unlike mmu_unsync_children)
> > 			 * it doesn't write-protect the page or mark it synchronized!
> > 			 * This way the validity of the mapping is ensured, but the
> > 			 * overhead of write protection is not incurred until the
> > 			 * guest invalidates the TLB mapping.  This allows multiple
> > 			 * SPs for a single gfn to be unsync.
> > 			 *
> > 			 * If the sync fails, the page is zapped.  If so, break
> > 			 * in order to rebuild it.
> > 			 */
> > 			if (!kvm_sync_page(vcpu, sp, &invalid_list))
> > 				break;
> > 
> > 			WARN_ON(!list_empty(&invalid_list));
> > 			kvm_flush_remote_tlbs(kvm);
> > 		}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
