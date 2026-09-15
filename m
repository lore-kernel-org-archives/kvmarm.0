Received: from mta0.migadu.com (out-28.mta0.migadu.com [91.218.175.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E630E4A1DF6
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 15:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486095; cv=none; b=O5T/dApHyOMvfZcaW+wvtx2mUbdacOFHhOONauRGoVI7csST3Male48sJKKHzHDronJibhk7FgJ+VqfHOmqv57UxCF+Z2o5J39IMbkqgUJWJV1RdhZm1uhV8Bf20AMkStlgfgQM82wRSz/UlNFRaa5TcGolVwjWTNnrfoXuSL2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486095; c=relaxed/simple;
	bh=seZKkNZqkA1n+JFBn6WE809ZUioCrb4l3ZQsXTwS4L0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nOdXLXdbo32hRT2IrNa6FQwTfee3eBrCotbABwObKEfT7B0GhpQyMUZIxK8dQdE2h4g1Qg2E+QwuhJL/dBAkyiOSr6R1mADiulSknP4gSGLJEEpTPAE+Op+UlvjLP0qmia6ml+AMYE9J80OQvGs39HZLpFY219nErHzn3ICdTTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=at5eLmXA; arc=none smtp.client-ip=91.218.175.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="at5eLmXA"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=seZKkNZqkA1n+JFBn6WE809ZUioCrb4l3ZQsXTwS4L0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789486090; v=1; x=1790090890;
 b=at5eLmXAw7RvEADUG4BCJ4Febd+HDc0dd3JZJXVaByPP0MZlhw3YqLl2mFa00YgnDqo5W3+U
 ciWpjsmZSzNniaBoY2eHSvhic5mVX36wJ9ITFUYGIc68LMrv3HX8PE4YXe0NdxGkjOcEhyeTTV6
 E/kS0t4xbtc2OftrYgMlsf0k=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f7f7c991e9437d1f;
	Tue, 15 Sep 2026 15:28:10 +0000
X-Mizu-Trace-ID: f7f7c991e9437d1f
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so1285e87.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 08:28:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwTPxg/gUTIX3wYvpjtZu6K3CN9oYn2srefUBnRbxZn+CVybfySOPBcVoEoaPWckFxpHPdiPcE=@lists.linux.dev
X-Gm-Message-State: AFuF++nM1pXPygSYxH36eNdC1Y+k1mXlrFHkDR9zpqHwNjet89gdqZWC
	P0V8oc100sX/SCuO1U2THJmzJkU4wwE5MsHF8512iCeiKC+39a3tJH4sjl87rhGCxANhny27Yzr
	plX+uMVs7LMHzn++gvIAxMLiNoYgM5kVoGd6erpIX
X-Received: by 2002:a05:6512:2341:b0:5b4:9dba:7403 with SMTP id
 2adb3069b0e04-5b8b3201e59mr131289e87.13.1789486087447; Tue, 15 Sep 2026
 08:28:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com> <20260807164322.2970811-10-sebastianene@google.com>
In-Reply-To: <20260807164322.2970811-10-sebastianene@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 15 Sep 2026 16:27:31 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzeCib1J2fyKM42GW5rgKQEE9_Dox_tGA5YJux0YoY5rg@mail.gmail.com>
X-Gm-Features: AcwNN1WkkAN_-WeQ6aFBf7fnAFZAi-s925Hdj_6AYFNinV0IdRsiozOwPKsbvOA
Message-ID: <CA+EHjTzeCib1J2fyKM42GW5rgKQEE9_Dox_tGA5YJux0YoY5rg@mail.gmail.com>
Subject: Re: [PATCH v2 08/13] KVM: arm64: Trap & emulate the ITS MAPD command
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com, 
	maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org, 
	kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, seiden@linux.ibm.com, 
	smostafa@google.com, tglx@kernel.org, vdonnefort@google.com, 
	vladimir.murzin@arm.com, yuzenghui@huawei.com, zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Sebastian,

The MAPD emulation is the right idea, but there's a fair bit to fix.
The main ones:

On Fri, Aug 07, 2026 at 04:43:18PM +0000, Sebastian Ene wrote:

[...]

> +static int get_num_itt_pages(struct its_priv_state *its, u8 num_bits)
> +{
[...]
> +        return PAGE_ALIGN(sz) >> PAGE_SHIFT;
> +}

This needs the ITT's intra-page offset. itt_addr is only 256-byte
aligned (GENMASK(51, 8)), so PAGE_ALIGN(sz) undercounts by a page when
the ITT starts mid-page, and track_pfn() then leaves the tail page
unpinned for the host to repurpose before a MAPTI.
PAGE_ALIGN((itt_addr & ~PAGE_MASK) + sz) >> PAGE_SHIFT. (Sashiko)

> +        new_entry = snapshot_table[new_entry_index];
> +        prev_entry = original_table[new_entry_index];
> +        if (!((new_entry ^ prev_entry) & GITS_BASER_VALID))
> +                return 0;
> +
> +        if (rollback)
> +                new_entry = new_entry ^ GITS_BASER_VALID;
[...]
> +        original_table[new_entry_index] = new_entry;

The rollback here never runs. The forward pass ends with
original_table[idx] = new_entry, so on rollback the guard above sees
snapshot and original with the same valid bit and returns before the
flip. A failed MAPD then never gives the L2 back, and original stays
mapped. (Sashiko)

> +        if (new_entry & GITS_BASER_VALID)
> +                ret = __pkvm_host_donate_hyp(hyp_phys_to_pfn(new_entry & PHYS_MASK), table->psz >> PAGE_SHIFT);

Could the L2 address be checked psz-aligned first?
hyp_phys_to_pfn(new_entry & PHYS_MASK) rounds down to a page, but the
ITS uses the full address copied into original, so an unaligned entry
runs the ITS into the next, undonated page. (Sashiko)

> +                        } else {
> +                                return hyp_pin_shared_mem(virt, virt + PAGE_SIZE);
> +                        }

A duplicate MAPD for the same device and pfn pins again here, so the
refcount climbs with no new slot and track_pfn_remove()'s single unpin
can't free the page. (Sashiko)

> +                        if (ret == -EBUSY)
> +                                return 0;
[...]
> +        return -EINVAL;

Two things in track_pfn_remove(). The -EBUSY return skips the memset
that frees the dte_entry slot, so the slot leaks. And the trailing
-EINVAL, for a V=0 unmap of an ITT that isn't tracked, propagates up
and stalls the queue, where a legal unmap shouldn't. (Sashiko)

> +        ret = check_table_update(its, device_id, GITS_BASER_TYPE_DEVICE, rollback);
> +        if (ret)
> +                return ret;
> +
> +        return track_pfn(its, device_id, itt_pfn, num_pages, remove);

If track_pfn() fails after check_table_update() donated the L2,
nothing undoes the donation: process_cmd()'s forward-failure path in
cwriter_write() just returns, with no rollback. (Sashiko)

The snapshot-L1 TOCTOU during rollback (another host CPU can rewrite
it while this one holds its_lock in EL2) and the old-ITT leak on a
re-MAPD are real too. (Sashiko)

Cheers,
/fuad
