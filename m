Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01E53C8735
	for <kvmarm@lists.linux.dev>; Fri, 10 Apr 2026 13:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775829183; cv=none; b=f+ZIO2B7IiahcImxyzUGM0A1EpbTrseniL+v9pD+2CltrThjVja1mOL/X+BgN24Cw6yY2HfFt4RziHGrwFAut+vM/hzfaHC2yVn/qnfqTUpGVy7UVsMjY3qRbeTAgFU6qjDvsuGg337U2Dy0wJPeGz/3LozgZdN2dEVvbdiiMpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775829183; c=relaxed/simple;
	bh=QklhJRaACASXYYk1q9CfjamjbGUKZnkk66X9ZGZ5mRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sEAQ49S1BZBx019Dq6071LJM82qqKGvPRwlTtA2Aq05XSA+hO1aYy0fHkMkXCf02IpguAyPEYAWJQi2iBwYEri8Rxi0bkzm9H6uoyMYXeeg1hmfzswX28nTyAPvpdyYpzfwUqDT01pDW8cD3z4AKp2ClYXh9KwR2chqT31ITk/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VsPFZi4F; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VsPFZi4F"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-488879dcbc3so270055e9.0
        for <kvmarm@lists.linux.dev>; Fri, 10 Apr 2026 06:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775829180; x=1776433980; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uFTHSJoWbrwAI/sIqoC5vjF60iw/CEInfS3ou5ySm6g=;
        b=VsPFZi4FzeGSlX5zFSmOiSCTSWctPwePBMSb5H3pmpHP1bomp2Kg4Q18xBharJp9r8
         1ILKAP3awyvqzFPq/BlEA7/73E37uNPbIqRc5qhHcqXtxP/zDrF+HVqWfbIfQp2w0e74
         u++aDeqXhh8Nc9bwU6vBQOcfIEMwovMcb6iTb+J+8j/eJ8u/nr3kuH1kz+WGS9CBTGTd
         aZh4ZPJTKdWp/FYt77zGzsHBvvAvq/CHEgqKFROJ1KkgK52X8yVQQacJKV50Eg9TsrYs
         cXXWAwT9OwLReMLYch3Qf5pVBwC7ZxrG9vdMAu0iiBCYWCr5uhgGE09ChZS7YbuBm6Aw
         EI9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775829180; x=1776433980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uFTHSJoWbrwAI/sIqoC5vjF60iw/CEInfS3ou5ySm6g=;
        b=k/2+cAusDH1OjCgEP/5NjDo4DacpU+kBPM4+00hxuSoxpfXq+/7qbDP73drZdTM2R4
         8q1rUHUlfhk7dvbHFyHDzH1NjO3e4Ahw5oAFHsBupaXZJrbCmjfR9oyr50FXzlto2WAY
         XU9Dvokl2uP87UxAJhpekBHzLLZbuMBjGZCOc3Tv0BV5R1FKO0xT7ueCzrnMWsdnWspU
         4rvgG8bRJNrBUfjcJ81i9FU0dKTwoEe8fvxkWZ5r9kZaSxafaSs3+ayI+M4iTOuir9Uc
         3lTFWeZSGpFjRPYKHP01tBhuoGJqDr9JaoXshwNXTUzDEW1LB9wyAVW2NVGTJbt9gZ1z
         5abg==
X-Forwarded-Encrypted: i=1; AJvYcCVv7Thl2L6mpw9m2CvFs6KU9h38xDeQUy44HH9QjICY7v+evb7o+tiRhJYUhUs1ntAyk/eOrdU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwDlHegIeinT/WhSR19j9oeBJx6+giSEQ5isv5hDCEW8VSsyZ8I
	rRDpDW+2KfHI2OJRoB5+plPPGAzPTeXsMd+shhY4Sp5jfKLni/hmbc1LSnsph3l1CA==
X-Gm-Gg: AeBDietc6sTiTBUPQO++qnzeTNiNwU3wKFGhuVD2r+CtHI7v4SpkkgSD4aHn/a3RFYt
	zCkUIP+UPUfmiCaoxEHKcRcQ8ccwU8EUi+Y7nc7LmlUxujDyAG/gPxP/Gva1X0DYd3uHEh+ZmGJ
	EbtC6IooVqZdb7QMDDALCsNL640O6ydzXT1ehSu49C62BEg+sRc6blW5KC19kjMJKWq3E5bIQ1k
	gtngIBey7YRItIdHCy36COe8wiXhxifNskbPyklOwey82E6I+KMKOtzvZEYwnevMsWMgkBeHKZ3
	LqcmjdeokRMQp9CqAkD2+SrYW+s20YFMKsKYC68VVaclE0DsblQHfqfPXC+9+zrVmUu+igd7xNe
	16UjGOdScZTJECagFVAcyUS5uonjZf7q136klw+ML2zqsSKVe0lmGAKldwNBuV+ISScKA7unmgX
	QhW4WpmQBCY9JRrrpwd+H1+t6uKRKc6d8WwD/HTjbwiX5rlQUqMe0UreZxy5MppFfkgTyQYtU1e
	Phj1L1c+mYGcMjm
X-Received: by 2002:a05:600c:474b:b0:477:95a8:3803 with SMTP id 5b1f17b1804b1-488cf2ccc1dmr2385245e9.13.1775829179778;
        Fri, 10 Apr 2026 06:52:59 -0700 (PDT)
Received: from google.com (209.13.205.35.bc.googleusercontent.com. [35.205.13.209])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d538c03esm74889465e9.13.2026.04.10.06.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 06:52:58 -0700 (PDT)
Date: Fri, 10 Apr 2026 13:52:54 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: alexandru.elisei@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, catalin.marinas@arm.com, joey.gouly@arm.com,
	kees@kernel.org, mark.rutland@arm.com, maz@kernel.org,
	oupton@kernel.org, perlarsen@google.com, qperret@google.com,
	rananta@google.com, smostafa@google.com, suzuki.poulose@arm.com,
	tglx@kernel.org, vdonnefort@google.com, bgrzesik@google.com,
	will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH 07/14] KVM: arm64: Restrict host access to the ITS tables
Message-ID: <adkAtvBiYDH3_xSA@google.com>
References: <20260310124933.830025-1-sebastianene@google.com>
 <20260310124933.830025-8-sebastianene@google.com>
 <CA+EHjTxUbLBnyBGg58wsJQvTXPN0FTbj53H5r3sC9_TizpjvdQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxUbLBnyBGg58wsJQvTXPN0FTbj53H5r3sC9_TizpjvdQ@mail.gmail.com>

On Mon, Mar 16, 2026 at 04:13:59PM +0000, Fuad Tabba wrote:

Hello Fuad,

> Hi Sebastian,
> 
> On Tue, 10 Mar 2026 at 12:49, Sebastian Ene <sebastianene@google.com> wrote:
> >
> > Setup shadow structures for ITS indirect tables held in
> > the GITS_BASER<n> registers.
> > Make the last level of the Device Table and vPE Table
> > inacessible to the host.
> 
> inacessible  -> inaccessible

Applied fix, thanks.

> > In a direct layout configuration, donate the table to
> > the hypervisor since the software is not expected to
> > program them directly.
> 
> This commit message is too brief and doesn't fully explain the
> problem, the impact, and the mechanism of the solution. It also
> appears to contradict the actual code changes.
> 
> For example, could you elaborate why must the last level of indirect
> tables be inaccessible?

For device table, a malicious host can write the ITT address that points
to hyp memory and then use MAPTI to write over that memory.

> 
> Can you also please explain the mechanism? You are parsing
> GITS_BASER_INDIRECT to determine if a shadow Level 1 table must be
> shared with the host, while unconditionally donating the original
> physical tables. You also explicitly exclude Collection tables. The
> msg should briefly justify why Collection tables are safe to leave
> accessible to the host.
> 
> There is also a contradiction in the message. You state "In a direct
> layout configuration, donate the table...". However, your code donates
> the original hardware table unconditionally on every iteration of the
> loop, regardless of whether GITS_BASER_INDIRECT is set. Please ensure
> the commit log accurately reflects the code implementation.
>

I see no contradition, I only need to shadow the first layer of the
indirect tables. Shadowing implies donation and sharing:
because we are donating the original tables from host -> hyp and we sharing the
host view of the tables with the hypervisor (which is a copy).

> Maybe you could say that the problem is Host DMA attacks via ITS table
> manipulation. Whereas the mechanism is to unconditionally donate

This has nothing to do with Host DMA attacks, it is just the AP that can
write to memory.

> hardware tables to EL2. For indirect Device/vPE tables, share a L1
> shadow table with the host and strictly donate the L2 pages to prevent
> the host from writing malicious L2 pointers.
> 
> >
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/its_emulate.c | 143 ++++++++++++++++++++++++++
> >  1 file changed, 143 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> > index 4a3ccc90a1a9..865a5d6353ed 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> > @@ -141,6 +141,145 @@ static struct pkvm_protected_reg *get_region(phys_addr_t dev_addr)
> >         return NULL;
> >  }
> >
> > +static int pkvm_host_unmap_last_level(void *shadow, size_t num_pages, u32 psz)
> > +{
> > +       u64 *table = shadow;
> > +       int ret, i, end = (num_pages << PAGE_SHIFT) / sizeof(table);
> > +       phys_addr_t table_addr;
> 
> RCT, mixing initialized variables and uninitialized variables, plus
> variables of conceptually different "types" in the same declaration.
> 
> Please use sizeof(*table): sizeof(table) evaluates to the size of the
> pointer (8 bytes), NOT the size of the array element. In this case,
> this happens to be the same, but it's still wrong.
> 
> Maybe the following is clearer:
> +        int end = num_pages * (PAGE_SIZE / sizeof(*table));
> 
>

Will use the suggestion and do the same for the
pkvm_host_map_last_level.

> > +
> > +       for (i = 0; i < end; i++) {
> > +               if (!(table[i] & GITS_BASER_VALID))
> > +                       continue;
> > +
> > +               table_addr = table[i] & PHYS_MASK;
> > +               ret = __pkvm_host_donate_hyp(hyp_phys_to_pfn(table_addr), psz >> PAGE_SHIFT);
> 
> The ITS-configured page size and the host page size could be
> different, but the number of pages to donate for Level 2 tables is
> calculated based on psz (the ITS).
> 
> If the ITS hardware is configured for 4KB pages, but the host kernel
> is using (e.g.,) 64KB pages, psz >> PAGE_SHIFT evaluates to 0.

I need to revisit this, thanks for pointing out.

> 
> You need to account for mismatched page sizes, perhaps by using
> DIV_ROUND_UP(psz, PAGE_SIZE) (or something similar) to ensure the
> containing host page is donated.
> 
> > +               if (ret)
> > +                       goto err_donate;
> > +       }
> > +
> > +       return 0;
> > +err_donate:
> > +       for (i = i - 1; i >= 0; i--) {
> 
> Please use the while (i--) idiom for rollback loops.
> 
> 
> > +               if (!(table[i] & GITS_BASER_VALID))
> > +                       continue;
> > +
> > +               table_addr = table[i] & PHYS_MASK;
> > +               __pkvm_hyp_donate_host(hyp_phys_to_pfn(table_addr), psz >> PAGE_SHIFT);
> 
> Please wrap this in WARN_ON(...). If donating back to the host fails
> during a rollback, we have a fatal page leak that needs to be loudly
> flagged, similar to how you handle it in pkvm_unshare_shadow_table.
> 
> 
> > +       }
> > +       return ret;
> > +}
> > +
> > +static int pkvm_share_shadow_table(void *shadow, u64 nr_pages)
> > +{
> > +       u64 i, ret, start_pfn = hyp_virt_to_pfn(shadow);
> 
> Same comment as before with RCT and the mixing of declarations.
> 
> 
> > +
> > +       for (i = 0; i < nr_pages; i++) {
> > +               ret = __pkvm_host_share_hyp(start_pfn + i);
> > +               if (ret)
> > +                       goto unshare;
> > +       }
> > +
> > +       ret = hyp_pin_shared_mem(shadow, shadow + (nr_pages << PAGE_SHIFT));
> > +       if (ret)
> > +               goto unshare;
> > +
> > +       return ret;
> > +unshare:
> 
> Please use the while (i--) idiom for rollback loops.
> 
> Also, please use consistent naming conventions for the labels. Here
> you call it unshare, and earlier it was err_donate.
> 
> 
> > +       for (i = i - 1; i >= 0; i--)
> > +               __pkvm_host_unshare_hyp(start_pfn + i);
> > +       return ret;
> > +}
> > +
> > +static void pkvm_unshare_shadow_table(void *shadow, u64 nr_pages)
> > +{
> > +       u64 i, start_pfn = hyp_virt_to_pfn(shadow);
> > +
> > +       hyp_unpin_shared_mem(shadow, shadow + (nr_pages << PAGE_SHIFT));
> > +
> > +       for (i = 0; i < nr_pages; i++)
> > +               WARN_ON(__pkvm_host_unshare_hyp(start_pfn + i));
> > +}
> > +
> > +static void pkvm_host_map_last_level(void *shadow, size_t num_pages, u32 psz)
> > +{
> > +       u64 *table;
> 
> RCT, and you forgot to initialize table:
> +       u64 *table = shadow;

Fixed this, thanks. I never ended up on this code path during testing,
maybe I should create a test for it to trigger it.

> 
> > +       int i, end = (num_pages << PAGE_SHIFT) / sizeof(table);
> 
> Same sizeof(table) pointer-size bug as above.
> 
> 
> > +       phys_addr_t table_addr;
> > +
> > +       for (i = 0; i < end; i++) {
> > +               if (!(table[i] & GITS_BASER_VALID))
> > +                       continue;
> > +
> > +               table_addr = table[i] & ~GITS_BASER_VALID;
> 
> Inconsistent masking logic, since in pkvm_host_unmap_last_level you
> correctly used PHYS_MASK to extract the address, but here in the
> rollback path you use ~GITS_BASER_VALID.
> 
> While both currently work because the upper bits and lower bits (below
> the page size) are defined as RES0 in the GIC spec, ~GITS_BASER_VALID
> is architecturally fragile. If a future hardware revision repurposes
> the upper RES0 bits [62:52] for new attributes (e.g., memory
> encryption flags), ~GITS_BASER_VALID will leak those attribute bits
> into the physical address calculation.
> 
> Since PHYS_MASK correctly handles the address extraction across all
> page sizes (relying on the lower bits being RES0) and safely masks off
> future upper attribute bits, please standardize on using table_addr =
> table[i] & PHYS_MASK; for both functions.
> 
>

Fixed the inconsistency and used PHYS_MASK everywhere.

> > +               WARN_ON(__pkvm_hyp_donate_host(hyp_phys_to_pfn(table_addr), psz >> PAGE_SHIFT));
> > +       }
> > +}
> > +
> > +static int pkvm_setup_its_shadow_baser(struct its_shadow_tables *shadow)
> > +{
> > +       int i, ret;
> > +       u64 baser_val, num_pages, type;
> > +       void *base, *host_base;
> > +
> > +       for (i = 0; i < GITS_BASER_NR_REGS; i++) {
> > +               baser_val = shadow->tables[i].val;
> > +               if (!(baser_val & GITS_BASER_VALID))
> > +                       continue;
> > +
> > +               base = kern_hyp_va(shadow->tables[i].base);
> > +               num_pages = (1 << shadow->tables[i].order);
> > +
> > +               ret = __pkvm_host_donate_hyp(hyp_virt_to_pfn(base), num_pages);
> > +               if (ret)
> > +                       goto err_donate;
> > +
> > +               if (baser_val & GITS_BASER_INDIRECT) {
> > +                       host_base = kern_hyp_va(shadow->tables[i].shadow);
> > +                       ret = pkvm_share_shadow_table(host_base, num_pages);
> > +                       if (ret)
> > +                               goto err_with_donation;
> > +
> > +                       type = GITS_BASER_TYPE(baser_val);
> > +                       if (type == GITS_BASER_TYPE_COLLECTION)
> > +                               continue;
> > +
> > +                       ret = pkvm_host_unmap_last_level(base, num_pages,
> > +                                                        shadow->tables[i].psz);
> > +                       if (ret)
> > +                               goto err_with_share;
> > +               }
> > +       }
> > +
> > +       return 0;
> > +err_with_share:
> > +       pkvm_unshare_shadow_table(host_base, num_pages);
> > +err_with_donation:
> > +       __pkvm_hyp_donate_host(hyp_virt_to_pfn(base), num_pages);
> > +err_donate:
> > +       for (i = i - 1; i >= 0; i--) {
> 
> Please use the while (i--) idiom for rollback loops.
> 
> 
> > +               baser_val = shadow->tables[i].val;
> > +               if (!(baser_val & GITS_BASER_VALID))
> > +                       continue;
> > +
> > +               base = kern_hyp_va(shadow->tables[i].base);
> > +               num_pages = (1 << shadow->tables[i].order);
> > +
> > +               WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(base), num_pages));
> 
> The sequence of rollback operations here creates a TOCTOU vulnerability.
> 

There is a different problem here related to functionality rather than
this: donating the base to the host first and then iterating over it
will make the hypervisor explode. I fixed this.

> - First, you donate base (the Level 1 indirect table) back to the host.
> - Then, you pass base into pkvm_host_map_last_level().
> - Finally, pkvm_host_map_last_level() reads table[i] out of base to
> determine which Level 2 pages to donate back to the host.
>
> Because the host regains ownership of base _first_, it can be running
> concurrently on another CPU. A malicious host can overwrite the Level
> 1 table with pointers to arbitrary hypervisor-owned memory. The
> hypervisor will then read those malicious pointers and dutifully grant
> the host access to its own secure memory.
> 
> The order of operations needs to be reversed: you must read base to
> roll back the L2 pages, unshare the shadow table, and *only then*
> donate base back to the host.
> 
> Also, num_pages = (1 << shadow->tables[i].order); calculates a 32-bit
> signed integer because the literal 1 is a signed 32-bit int. If order
> is 31, this evaluates to a negative number. If order is 32 or higher,
> this is undefined behavior. Because num_pages is declared as a u64,
> you should use the standard kernel macro BIT_ULL().
> 
> Here's my suggested fix (not tested). Reorder the operations to safely
> rollback L2 before donating L1, use the standard `while (i--)` loop,
> and fix the page calculation:
> 
> +    while (i--) {
> +        baser_val = shadow->tables[i].val;
> +        if (!(baser_val & GITS_BASER_VALID))
> +                continue;
> +
> +        base = kern_hyp_va(shadow->tables[i].base);
> +        num_pages = BIT_ULL(shadow->tables[i].order);
> +
> +        if (baser_val & GITS_BASER_INDIRECT) {
> +                host_base = kern_hyp_va(shadow->tables[i].shadow);
> +
> +            type = GITS_BASER_TYPE(baser_val);
> +            if (type != GITS_BASER_TYPE_COLLECTION)
> +                    pkvm_host_map_last_level(base, num_pages,
> +                                 shadow->tables[i].psz);
> +
> +            pkvm_unshare_shadow_table(host_base, num_pages);
> +        }
> +
> +        WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(base), num_pages));
> +    }
> 
> 
> 
> > +               if (baser_val & GITS_BASER_INDIRECT) {
> > +                       host_base = kern_hyp_va(shadow->tables[i].shadow);
> > +                       pkvm_unshare_shadow_table(host_base, num_pages);
> > +
> > +                       type = GITS_BASER_TYPE(baser_val);
> > +                       if (type == GITS_BASER_TYPE_COLLECTION)
> > +                               continue;
> > +
> > +                       pkvm_host_map_last_level(base, num_pages, shadow->tables[i].psz);
> > +               }
> > +       }
> 
> You have duplicated the entire table decoding logic (calculating base,
> num_pages, checking INDIRECT...) down here in the rollback path.
> Consider abstracting "setup one table" and "teardown one table" into
> helper functions to make pkvm_setup_its_shadow_baser more readable and
> less prone to copy-pasta errors.
>
> Cheers,
> /fuad
> 

Thanks,
Sebastian

> 
> > +
> > +       return ret;
> > +}
> > +
> >  static int pkvm_setup_its_shadow_cmdq(struct its_shadow_tables *shadow)
> >  {
> >         int ret, i, num_pages;
> > @@ -205,6 +344,10 @@ int pkvm_init_gic_its_emulation(phys_addr_t dev_addr, void *host_priv_state,
> >         if (ret)
> >                 goto err_with_shadow;
> >
> > +       ret = pkvm_setup_its_shadow_baser(shadow);
> > +       if (ret)
> > +               goto err_with_shadow;
> > +
> >         its_reg->priv = priv_state;
> >
> >         hyp_spin_lock_init(&priv_state->its_lock);
> > --
> > 2.53.0.473.g4a7958ca14-goog
> >
