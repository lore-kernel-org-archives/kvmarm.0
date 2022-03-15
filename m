Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219C1C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 08:15:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F1C149EF0;
	Tue, 15 Mar 2022 04:15:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LzHslMCfFigt; Tue, 15 Mar 2022 04:15:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68F7D49ECC;
	Tue, 15 Mar 2022 04:15:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB3D349ECC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 04:15:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x926cF4-QgdI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 04:15:31 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2DC340BF0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 04:15:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647332131;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=a0cNYdPs691U7NzI+aLZjWfo6CR3sI4nXipmf6Gsq0k=;
 b=A8Lo4tlYaFUuWG1m3hIw/kc43h9PjrPx595IJ8VKre5OzkVXAN82hjPb5FkEXTuBQsQ94Y
 FPBF/exqkQzYTTuPbafo7CjhdYY5SxrNEsjDf/fADquXJ0ZvFNi3P2jr7E3YaYZVtN+XYN
 RhT9CiDLBrEjTvQ7TsePzjSw992UDWA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-gx1YyVk2O7KHsyz7mJwPiA-1; Tue, 15 Mar 2022 04:15:28 -0400
X-MC-Unique: gx1YyVk2O7KHsyz7mJwPiA-1
Received: by mail-pj1-f71.google.com with SMTP id
 mt1-20020a17090b230100b001beef010919so1492152pjb.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 01:15:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=a0cNYdPs691U7NzI+aLZjWfo6CR3sI4nXipmf6Gsq0k=;
 b=uSRvhwMw5nBK1lv0RvgT5VtE1ExAGHBbU+JwwzUdoYbT8OmozYo9539az8+hG9bqzf
 KK84VB5qjo2ixNPz1RhQZj2wPIwB+tPPH3PmnWRNKHOSF2O4zYqKLXnakvXqF/EL+cfL
 pdq+wJbb9dlLLU4QHlHw8B7WDANa0wUE6zQMR0n+9a109EbQJrdtV3gYLAj+FwwlqDb+
 t4pO2LTBDgnpYt6rjPv3Wdzc+PkKkxBIPEd3ktf9zp2dF8Yky/rmCUlqbm5CkOSFuaDD
 2p9gS3WrNDFx1Fq3GjQQuXnmWO0o/4r3tg8Hp9EVXPzrf50argLUtniG21aOctET+BIW
 09zw==
X-Gm-Message-State: AOAM5322KaMuQIR90G4DDmrNtTEb0fO08d4ogNFMlZ3yWWhblo3x5g0p
 sdOFY9R6q5oBhqeL5kgP63wjg64thH+D+4CABsykA9/igGg399id9I6iPcKICt0LFPO6ZtLF5ST
 NSi0eSFSmYe7TtDB/TF2e0sxH
X-Received: by 2002:a17:902:db0b:b0:151:fa8c:d6cd with SMTP id
 m11-20020a170902db0b00b00151fa8cd6cdmr27148081plx.147.1647332127008; 
 Tue, 15 Mar 2022 01:15:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwq0uq77YNHp6fuhCYE/x4KhDRlcGw0u3EOCCh2qj9qDt6uuauAuzikZPkm8QDqCFMb2dJYNA==
X-Received: by 2002:a17:902:db0b:b0:151:fa8c:d6cd with SMTP id
 m11-20020a170902db0b00b00151fa8cd6cdmr27148041plx.147.1647332126587; 
 Tue, 15 Mar 2022 01:15:26 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43]) by smtp.gmail.com with ESMTPSA id
 o7-20020a056a00214700b004c169d45699sm22890891pfk.184.2022.03.15.01.15.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 01:15:26 -0700 (PDT)
Date: Tue, 15 Mar 2022 16:15:17 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 03/26] KVM: x86/mmu: Derive shadow MMU page role from
 parent
Message-ID: <YjBLFZWtdfwhNosG@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-4-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-4-dmatlack@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=peterx@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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
 maciej.szmigiero@oracle.com,
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

On Fri, Mar 11, 2022 at 12:25:05AM +0000, David Matlack wrote:
> Instead of computing the shadow page role from scratch for every new
> page, we can derive most of the information from the parent shadow page.
> This avoids redundant calculations and reduces the number of parameters
> to kvm_mmu_get_page().
> 
> Preemptively split out the role calculation to a separate function for
> use in a following commit.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Looks right..

Reviewed-by: Peter Xu <peterx@redhat.com>

Two more comments/questions below.

> +static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
> +{
> +	struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
> +	union kvm_mmu_page_role role;
> +
> +	role = parent_sp->role;
> +	role.level--;
> +	role.access = access;
> +	role.direct = direct;
> +
> +	/*
> +	 * If the guest has 4-byte PTEs then that means it's using 32-bit,
> +	 * 2-level, non-PAE paging. KVM shadows such guests using 4 PAE page
> +	 * directories, each mapping 1/4 of the guest's linear address space
> +	 * (1GiB). The shadow pages for those 4 page directories are
> +	 * pre-allocated and assigned a separate quadrant in their role.
> +	 *
> +	 * Since we are allocating a child shadow page and there are only 2
> +	 * levels, this must be a PG_LEVEL_4K shadow page. Here the quadrant
> +	 * will either be 0 or 1 because it maps 1/2 of the address space mapped
> +	 * by the guest's PG_LEVEL_4K page table (or 4MiB huge page) that it
> +	 * is shadowing. In this case, the quadrant can be derived by the index
> +	 * of the SPTE that points to the new child shadow page in the page
> +	 * directory (parent_sp). Specifically, every 2 SPTEs in parent_sp
> +	 * shadow one half of a guest's page table (or 4MiB huge page) so the
> +	 * quadrant is just the parity of the index of the SPTE.
> +	 */
> +	if (role.has_4_byte_gpte) {
> +		BUG_ON(role.level != PG_LEVEL_4K);
> +		role.quadrant = (sptep - parent_sp->spt) % 2;
> +	}

This made me wonder whether role.quadrant can be dropped, because it seems
it can be calculated out of the box with has_4_byte_gpte, level and spte
offset.  I could have missed something, though..

> +
> +	return role;
> +}
> +
> +static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
> +						 u64 *sptep, gfn_t gfn,
> +						 bool direct, u32 access)
> +{
> +	union kvm_mmu_page_role role;
> +
> +	role = kvm_mmu_child_role(sptep, direct, access);
> +	return kvm_mmu_get_page(vcpu, gfn, role);

Nit: it looks nicer to just drop the temp var?

        return kvm_mmu_get_page(vcpu, gfn,
                                kvm_mmu_child_role(sptep, direct, access));

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
