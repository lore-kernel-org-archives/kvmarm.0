Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54527332913
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 16:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677680; cv=pass; b=pegzlUg5RSd+0h3uZF3MJh2CcOB+VyKIbN2gkTxb+aiS3rUmLbxf77TU1tU/vIijVaH3xo5RJ9iomC2A5Zy8FjGNhkLJhyGpfDDIrhv2CTxyEwOn3TIEyRg0CPLTYGAbfkTExyvGewWNoFJMFrIGVH1YgLxeViNEv/4AOzlp3u0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677680; c=relaxed/simple;
	bh=tOxeljHnGTq720BrSR+noDI4gOIddPLikMbBFWaa1qU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oQ0hHOHGDfV27auJ8id/fOqtIIgaNc1r4pb4t2T1LKb7UFyOZd2DRk5yiJSrvmcKfcSdK9APqgd0U5GunoTUk/6vfNWzWqFP9mX1nmewinT2I93pSiAzR/3ycHCNWiDBb4tg8g4SDZpwiPkFxDrS4fBP7wA3pcHMS+FYrnW8crg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dgeqKUay; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dgeqKUay"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-509069a7a7fso1159401cf.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 09:14:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773677677; cv=none;
        d=google.com; s=arc-20240605;
        b=Ge5VYAfBa8k1gfq2O9g79I7ctYe0PZjBHzmPMBzaXCTOxeadphp1eyBqoESfGibDbY
         dvMJwF9mt0mOJ0B2zqvNQwtDJCtHJFky91AuW96BH+9i0oROOwQua0/YrhapMjhL/gfb
         kIkCJqRUcf+uvM2Qojms30L0MArdSFWNuRw6Q+6dg6lp2mjbBxoaLCC01ytvW9rIxWNm
         P+PT6i22+0S89tmRXsMH1PgOYX2e/2TYX9xqRAngPh8+gBGa7eRGfTDRhh4lTAWbzZzj
         Yc+hCl2ftfZJV2OoaxETWELQovAYh4TsamL0ch49jSTsRp3beNBfUbcTVDN+82Yv+Z/J
         jK5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=h++pw9WIP69TAimAtsOxeFAyztcm80JVNUx2o4PbWUA=;
        fh=zi9KSubnedOOJk9APRGmR+SNpoer97SF7kc4Zi7AyKM=;
        b=Rx0Sshm4F/3GS4VQf4xYeQDMBuKBLujR7dyHb/96b5FBz920FfX6lI4Wcv0kyLInz8
         OpHgvwk0yYCSPROCiFyAZmLArso4HyePSxLC0tSeE7xAvYxCM3f/Dre5fHTPX3SZoiHB
         tLdGc4okm/fCCgqcfLiMKPOjRztOJZtnkbVuc0ZpwQwJYRTQhXG9TeUry+3rfRq7wVXX
         UDOI/SYu+TsB/52FUa7NwuYar9qv24FllFKx9vLAC89OPdjifYm+GkyiHcbE7Pqmo0AV
         EGq94C21c6KfnELHk2ErRNcFX7LMX8UsHFDpSEWmrMlXe0UvC8UWk78QYN17F44aHBim
         vuXg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773677677; x=1774282477; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h++pw9WIP69TAimAtsOxeFAyztcm80JVNUx2o4PbWUA=;
        b=dgeqKUayP+lRfKuhcLBFzK8GXwmuBTm9NitJs918t457A8wBZTntvSAm+c8vzl4JWg
         R3GvumD0XksQl+KrzDb1XlzsF/Y0EmYMllzG5fwCZNb+Rv5uAkAzJqS66PpM2ucqg1qm
         R6RagpdbR8pEhI0Tw9wJWOWQX30gPjO8kGUdZZ0apuZW0++B89TBiI5D4iO+CNWgnprw
         eWwPITYlrrKtT5ESmrpibqYZ7GZAi1myjoOXZUpr05PeuCEZWI3MwyKikRKMjFuqIrtX
         xY2vk6RwWaYS+XeZ0TU2PsDuWBSj5ots7sHp4KtDOqNN1ZazHXBZRcaw27xnHwDNlb/E
         JMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773677677; x=1774282477;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h++pw9WIP69TAimAtsOxeFAyztcm80JVNUx2o4PbWUA=;
        b=R3ujgChZ8tTYg8D7i5R6wNBoIlvkj2g4aNWGzYKCOgkudPoZz2NoFn/hPcllA5fZ9g
         xpQqMoXI6Ci+fG5+ULd9YRmX0w//MdV0C4SL9nIRCBnYbQKYRgbiTI08YL3NMxguh4i0
         3f8xA48gBgwkcXh+5MWdfbfSyWFXLnAalW6gPkal3UhWdfTjLs5fNJLlU7wRlokhjn5U
         chOGBLFlh3GS/BclESVL0nRZfgiFuqpNjbcyb3PdfU7GJ0FRf2POIuDDdNUIBWyGsXOy
         1XJ2DBiK2lb64oZ89otHjKWs3u4+SfOibwi1Jd6jWduTJi42+9LcQ4gLs/f5AD5xgExv
         IwTg==
X-Forwarded-Encrypted: i=1; AJvYcCUqlQNFfZ0aG0pfdO1T0UNn2GQYdXFXXPyRSv4TOvmUZUs3uhYj4nAG/ZwZ41eYXF94ft8lHTs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrpRwmt/EDLJBvyznsT5ZhQLJRp+0kSxwJ2srhzXCrAW4jmNa+
	e8TGgYtecQA1mVldOb56tFxBx5jyQYVaSp6J6NpGHg5qP5/LHdjMlUtdiJZPI73/6g00lc6HoGB
	PoLrhqWsMUWKMfU8azlycKTuDtGejyiOi6xKRZKNmLjcaXV3siTqYKZW+
X-Gm-Gg: ATEYQzzM9Kok5Ckxo+FxyekYSsFFFtU7Oxsa/GEXRGVtMy+DqN9ySKPL+uwCgSFBLjx
	oOZOTNj+O6cUMYkfrstd0UYlNYQQx2wCpJ9js/2pkJsHODeQ7Tp7a1l7KmuQbadY2LHmCHwTRwo
	DiJWSemngx5S2Zschp6qEMmqjXfkasiVUbRBLyBTS8T246mITlGBZ0B6fU0MwQBrwvxvuiwd5/m
	Og5ZHiYiuGy3fQx0+H4ZG4n2vhtA7DCA/Z1qcLbsfB2mAY1aKPdGp1g3u4nzRV4uMxK+H+WRc/+
	Y5rxznJ7
X-Received: by 2002:a05:622a:199b:b0:501:4eae:dbfc with SMTP id
 d75a77b69052e-5096a9f0784mr26755941cf.5.1773677676470; Mon, 16 Mar 2026
 09:14:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com> <20260310124933.830025-8-sebastianene@google.com>
In-Reply-To: <20260310124933.830025-8-sebastianene@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 16 Mar 2026 16:13:59 +0000
X-Gm-Features: AaiRm53QvV3dmSDz2dbakOlmzchiMTMtcm99u5LA8Osxffg5KY1lrEP9Ia2IXIc
Message-ID: <CA+EHjTxUbLBnyBGg58wsJQvTXPN0FTbj53H5r3sC9_TizpjvdQ@mail.gmail.com>
Subject: Re: [PATCH 07/14] KVM: arm64: Restrict host access to the ITS tables
To: Sebastian Ene <sebastianene@google.com>
Cc: alexandru.elisei@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, catalin.marinas@arm.com, dbrazdil@google.com, 
	joey.gouly@arm.com, kees@kernel.org, mark.rutland@arm.com, maz@kernel.org, 
	oupton@kernel.org, perlarsen@google.com, qperret@google.com, 
	rananta@google.com, smostafa@google.com, suzuki.poulose@arm.com, 
	tglx@kernel.org, vdonnefort@google.com, bgrzesik@google.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hi Sebastian,

On Tue, 10 Mar 2026 at 12:49, Sebastian Ene <sebastianene@google.com> wrote:
>
> Setup shadow structures for ITS indirect tables held in
> the GITS_BASER<n> registers.
> Make the last level of the Device Table and vPE Table
> inacessible to the host.

inacessible  -> inaccessible
> In a direct layout configuration, donate the table to
> the hypervisor since the software is not expected to
> program them directly.

This commit message is too brief and doesn't fully explain the
problem, the impact, and the mechanism of the solution. It also
appears to contradict the actual code changes.

For example, could you elaborate why must the last level of indirect
tables be inaccessible?

Can you also please explain the mechanism? You are parsing
GITS_BASER_INDIRECT to determine if a shadow Level 1 table must be
shared with the host, while unconditionally donating the original
physical tables. You also explicitly exclude Collection tables. The
msg should briefly justify why Collection tables are safe to leave
accessible to the host.

There is also a contradiction in the message. You state "In a direct
layout configuration, donate the table...". However, your code donates
the original hardware table unconditionally on every iteration of the
loop, regardless of whether GITS_BASER_INDIRECT is set. Please ensure
the commit log accurately reflects the code implementation.

Maybe you could say that the problem is Host DMA attacks via ITS table
manipulation. Whereas the mechanism is to unconditionally donate
hardware tables to EL2. For indirect Device/vPE tables, share a L1
shadow table with the host and strictly donate the L2 pages to prevent
the host from writing malicious L2 pointers.

>
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/its_emulate.c | 143 ++++++++++++++++++++++++++
>  1 file changed, 143 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> index 4a3ccc90a1a9..865a5d6353ed 100644
> --- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> +++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> @@ -141,6 +141,145 @@ static struct pkvm_protected_reg *get_region(phys_addr_t dev_addr)
>         return NULL;
>  }
>
> +static int pkvm_host_unmap_last_level(void *shadow, size_t num_pages, u32 psz)
> +{
> +       u64 *table = shadow;
> +       int ret, i, end = (num_pages << PAGE_SHIFT) / sizeof(table);
> +       phys_addr_t table_addr;

RCT, mixing initialized variables and uninitialized variables, plus
variables of conceptually different "types" in the same declaration.

Please use sizeof(*table): sizeof(table) evaluates to the size of the
pointer (8 bytes), NOT the size of the array element. In this case,
this happens to be the same, but it's still wrong.

Maybe the following is clearer:
+        int end = num_pages * (PAGE_SIZE / sizeof(*table));


> +
> +       for (i = 0; i < end; i++) {
> +               if (!(table[i] & GITS_BASER_VALID))
> +                       continue;
> +
> +               table_addr = table[i] & PHYS_MASK;
> +               ret = __pkvm_host_donate_hyp(hyp_phys_to_pfn(table_addr), psz >> PAGE_SHIFT);

The ITS-configured page size and the host page size could be
different, but the number of pages to donate for Level 2 tables is
calculated based on psz (the ITS).

If the ITS hardware is configured for 4KB pages, but the host kernel
is using (e.g.,) 64KB pages, psz >> PAGE_SHIFT evaluates to 0.

You need to account for mismatched page sizes, perhaps by using
DIV_ROUND_UP(psz, PAGE_SIZE) (or something similar) to ensure the
containing host page is donated.

> +               if (ret)
> +                       goto err_donate;
> +       }
> +
> +       return 0;
> +err_donate:
> +       for (i = i - 1; i >= 0; i--) {

Please use the while (i--) idiom for rollback loops.


> +               if (!(table[i] & GITS_BASER_VALID))
> +                       continue;
> +
> +               table_addr = table[i] & PHYS_MASK;
> +               __pkvm_hyp_donate_host(hyp_phys_to_pfn(table_addr), psz >> PAGE_SHIFT);

Please wrap this in WARN_ON(...). If donating back to the host fails
during a rollback, we have a fatal page leak that needs to be loudly
flagged, similar to how you handle it in pkvm_unshare_shadow_table.


> +       }
> +       return ret;
> +}
> +
> +static int pkvm_share_shadow_table(void *shadow, u64 nr_pages)
> +{
> +       u64 i, ret, start_pfn = hyp_virt_to_pfn(shadow);

Same comment as before with RCT and the mixing of declarations.


> +
> +       for (i = 0; i < nr_pages; i++) {
> +               ret = __pkvm_host_share_hyp(start_pfn + i);
> +               if (ret)
> +                       goto unshare;
> +       }
> +
> +       ret = hyp_pin_shared_mem(shadow, shadow + (nr_pages << PAGE_SHIFT));
> +       if (ret)
> +               goto unshare;
> +
> +       return ret;
> +unshare:

Please use the while (i--) idiom for rollback loops.

Also, please use consistent naming conventions for the labels. Here
you call it unshare, and earlier it was err_donate.


> +       for (i = i - 1; i >= 0; i--)
> +               __pkvm_host_unshare_hyp(start_pfn + i);
> +       return ret;
> +}
> +
> +static void pkvm_unshare_shadow_table(void *shadow, u64 nr_pages)
> +{
> +       u64 i, start_pfn = hyp_virt_to_pfn(shadow);
> +
> +       hyp_unpin_shared_mem(shadow, shadow + (nr_pages << PAGE_SHIFT));
> +
> +       for (i = 0; i < nr_pages; i++)
> +               WARN_ON(__pkvm_host_unshare_hyp(start_pfn + i));
> +}
> +
> +static void pkvm_host_map_last_level(void *shadow, size_t num_pages, u32 psz)
> +{
> +       u64 *table;

RCT, and you forgot to initialize table:
+       u64 *table = shadow;

> +       int i, end = (num_pages << PAGE_SHIFT) / sizeof(table);

Same sizeof(table) pointer-size bug as above.


> +       phys_addr_t table_addr;
> +
> +       for (i = 0; i < end; i++) {
> +               if (!(table[i] & GITS_BASER_VALID))
> +                       continue;
> +
> +               table_addr = table[i] & ~GITS_BASER_VALID;

Inconsistent masking logic, since in pkvm_host_unmap_last_level you
correctly used PHYS_MASK to extract the address, but here in the
rollback path you use ~GITS_BASER_VALID.

While both currently work because the upper bits and lower bits (below
the page size) are defined as RES0 in the GIC spec, ~GITS_BASER_VALID
is architecturally fragile. If a future hardware revision repurposes
the upper RES0 bits [62:52] for new attributes (e.g., memory
encryption flags), ~GITS_BASER_VALID will leak those attribute bits
into the physical address calculation.

Since PHYS_MASK correctly handles the address extraction across all
page sizes (relying on the lower bits being RES0) and safely masks off
future upper attribute bits, please standardize on using table_addr =
table[i] & PHYS_MASK; for both functions.


> +               WARN_ON(__pkvm_hyp_donate_host(hyp_phys_to_pfn(table_addr), psz >> PAGE_SHIFT));
> +       }
> +}
> +
> +static int pkvm_setup_its_shadow_baser(struct its_shadow_tables *shadow)
> +{
> +       int i, ret;
> +       u64 baser_val, num_pages, type;
> +       void *base, *host_base;
> +
> +       for (i = 0; i < GITS_BASER_NR_REGS; i++) {
> +               baser_val = shadow->tables[i].val;
> +               if (!(baser_val & GITS_BASER_VALID))
> +                       continue;
> +
> +               base = kern_hyp_va(shadow->tables[i].base);
> +               num_pages = (1 << shadow->tables[i].order);
> +
> +               ret = __pkvm_host_donate_hyp(hyp_virt_to_pfn(base), num_pages);
> +               if (ret)
> +                       goto err_donate;
> +
> +               if (baser_val & GITS_BASER_INDIRECT) {
> +                       host_base = kern_hyp_va(shadow->tables[i].shadow);
> +                       ret = pkvm_share_shadow_table(host_base, num_pages);
> +                       if (ret)
> +                               goto err_with_donation;
> +
> +                       type = GITS_BASER_TYPE(baser_val);
> +                       if (type == GITS_BASER_TYPE_COLLECTION)
> +                               continue;
> +
> +                       ret = pkvm_host_unmap_last_level(base, num_pages,
> +                                                        shadow->tables[i].psz);
> +                       if (ret)
> +                               goto err_with_share;
> +               }
> +       }
> +
> +       return 0;
> +err_with_share:
> +       pkvm_unshare_shadow_table(host_base, num_pages);
> +err_with_donation:
> +       __pkvm_hyp_donate_host(hyp_virt_to_pfn(base), num_pages);
> +err_donate:
> +       for (i = i - 1; i >= 0; i--) {

Please use the while (i--) idiom for rollback loops.


> +               baser_val = shadow->tables[i].val;
> +               if (!(baser_val & GITS_BASER_VALID))
> +                       continue;
> +
> +               base = kern_hyp_va(shadow->tables[i].base);
> +               num_pages = (1 << shadow->tables[i].order);
> +
> +               WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(base), num_pages));

The sequence of rollback operations here creates a TOCTOU vulnerability.

- First, you donate base (the Level 1 indirect table) back to the host.
- Then, you pass base into pkvm_host_map_last_level().
- Finally, pkvm_host_map_last_level() reads table[i] out of base to
determine which Level 2 pages to donate back to the host.

Because the host regains ownership of base _first_, it can be running
concurrently on another CPU. A malicious host can overwrite the Level
1 table with pointers to arbitrary hypervisor-owned memory. The
hypervisor will then read those malicious pointers and dutifully grant
the host access to its own secure memory.

The order of operations needs to be reversed: you must read base to
roll back the L2 pages, unshare the shadow table, and *only then*
donate base back to the host.

Also, num_pages = (1 << shadow->tables[i].order); calculates a 32-bit
signed integer because the literal 1 is a signed 32-bit int. If order
is 31, this evaluates to a negative number. If order is 32 or higher,
this is undefined behavior. Because num_pages is declared as a u64,
you should use the standard kernel macro BIT_ULL().

Here's my suggested fix (not tested). Reorder the operations to safely
rollback L2 before donating L1, use the standard `while (i--)` loop,
and fix the page calculation:

+    while (i--) {
+        baser_val = shadow->tables[i].val;
+        if (!(baser_val & GITS_BASER_VALID))
+                continue;
+
+        base = kern_hyp_va(shadow->tables[i].base);
+        num_pages = BIT_ULL(shadow->tables[i].order);
+
+        if (baser_val & GITS_BASER_INDIRECT) {
+                host_base = kern_hyp_va(shadow->tables[i].shadow);
+
+            type = GITS_BASER_TYPE(baser_val);
+            if (type != GITS_BASER_TYPE_COLLECTION)
+                    pkvm_host_map_last_level(base, num_pages,
+                                 shadow->tables[i].psz);
+
+            pkvm_unshare_shadow_table(host_base, num_pages);
+        }
+
+        WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(base), num_pages));
+    }



> +               if (baser_val & GITS_BASER_INDIRECT) {
> +                       host_base = kern_hyp_va(shadow->tables[i].shadow);
> +                       pkvm_unshare_shadow_table(host_base, num_pages);
> +
> +                       type = GITS_BASER_TYPE(baser_val);
> +                       if (type == GITS_BASER_TYPE_COLLECTION)
> +                               continue;
> +
> +                       pkvm_host_map_last_level(base, num_pages, shadow->tables[i].psz);
> +               }
> +       }

You have duplicated the entire table decoding logic (calculating base,
num_pages, checking INDIRECT...) down here in the rollback path.
Consider abstracting "setup one table" and "teardown one table" into
helper functions to make pkvm_setup_its_shadow_baser more readable and
less prone to copy-pasta errors.

Cheers,
/fuad


> +
> +       return ret;
> +}
> +
>  static int pkvm_setup_its_shadow_cmdq(struct its_shadow_tables *shadow)
>  {
>         int ret, i, num_pages;
> @@ -205,6 +344,10 @@ int pkvm_init_gic_its_emulation(phys_addr_t dev_addr, void *host_priv_state,
>         if (ret)
>                 goto err_with_shadow;
>
> +       ret = pkvm_setup_its_shadow_baser(shadow);
> +       if (ret)
> +               goto err_with_shadow;
> +
>         its_reg->priv = priv_state;
>
>         hyp_spin_lock_init(&priv_state->its_lock);
> --
> 2.53.0.473.g4a7958ca14-goog
>
