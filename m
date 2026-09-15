Received: from mta0.migadu.com (out-131.mta0.migadu.com [91.218.175.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88683DB994
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 15:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789485141; cv=none; b=nN70Hfz4BIVDdG4yf+aWZdTJHNzkGtNH3Z+wIN8w6x6otljgGIEsa2rk1Yu6uAYNdWn4V/Yuwsd+TN3v5xzVflx/0cL7RN4uImmpmyXH+E2lTQv5WKZ/zNRvaHeuSy9ki5LsIggvzpiaP2xwwCOnUTUN5JwKliDjNJhBNCSG4EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789485141; c=relaxed/simple;
	bh=3r4+AODjX+xG9QP/OqvGAgcLWtNZcO4KFLsZFVHz2bQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZhGrhSxF2H9N4v2fGqZF55Kq3jZj1EHf22qVq/7w1U13gEsQSYHdfZDU0y7y8ZsXbLXeQBdpFM6OhgkyvVowxOFHVXMHjqWkg6wM6hAoVDelyqeDc8NX67s571EVwTG3SfmhOHltchrQR9oHit+H9NHDO4YVcZpNV8CnNXHv6G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GuhhPeUa; arc=none smtp.client-ip=91.218.175.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GuhhPeUa"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=3r4+AODjX+xG9QP/OqvGAgcLWtNZcO4KFLsZFVHz2bQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789485136; v=1; x=1790089936;
 b=GuhhPeUaRQBPJl3jFOF46Gq2Grg6i/9HrDJ9m6kA9B3vgKBHlTbKxQ9Jv0ePyrmnzRN78WBK
 7FgVqNwlNB47WbtSgTvjqUbV1vJYXV1661PKZZovYLvVn8K1WWXJR/hGKujSKh+0FmFcL19zizB
 C2OjtCC2lT4vN5YJQDZj55dk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c956e86cdcc6f91a;
	Tue, 15 Sep 2026 15:12:16 +0000
X-Mizu-Trace-ID: c956e86cdcc6f91a
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b78e073980so829e87.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 08:12:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzEWdc4eqRWs7oVmMBb0ov+INn60Nan1uRT8+HpL792LY/QUrrQqPOuGwHkSnXPAVnhrNi7tj4=@lists.linux.dev
X-Gm-Message-State: AFuF++ncXem5QtGbETMO93Nu4suaDuX43vs4wuce6m5xnUjo3PCTPWYD
	USJircPPgJ638NjJzueMogquyKAGDwPFzALH1mpdA+P7i7GS7V7/dArF5NDwmJBwGapUZ6hxptO
	SFLDcLGiD87eNKDJS5jGKSGXojeckXFnVEq186TmV
X-Received: by 2002:a05:6512:2390:b0:5ae:b1b3:145a with SMTP id
 2adb3069b0e04-5b8b2d4e662mr188401e87.6.1789485132544; Tue, 15 Sep 2026
 08:12:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com> <20260807164322.2970811-9-sebastianene@google.com>
In-Reply-To: <20260807164322.2970811-9-sebastianene@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 15 Sep 2026 16:11:36 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyezsXuFbw-eYUY8uPEd4bt7K=2K8HRg8tfHF2EA1O3uA@mail.gmail.com>
X-Gm-Features: AcwNN1XLaUwovCsrbP246c-_MGSA9ZbLdMWDwGYNe45yhrglwzVmarj2CpR2p1U
Message-ID: <CA+EHjTyezsXuFbw-eYUY8uPEd4bt7K=2K8HRg8tfHF2EA1O3uA@mail.gmail.com>
Subject: Re: [PATCH v2 07/13] KVM: arm64: Restrict host access to the private
 ITS tables
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

Hi Seb,

The approach is right, and it has the same gap as the command queue in
06. A few things:

On Fri, Aug 07, 2026 at 04:43:17PM +0000, Sebastian Ene wrote:

[...]

> Make the original layer innaccessible to the host by donating the table memory from the host to

nit: "innaccessible"

[...]

> +static int pkvm_host_unmap_last_level(void *shadow, size_t num_pages, u32 psz)
[...]
> +                table_addr = table[i] & PHYS_MASK;
> +                ret = __pkvm_host_donate_hyp(hyp_phys_to_pfn(table_addr), psz >> PAGE_SHIFT);

DIV_ROUND_UP(psz, PAGE_SIZE) would be safer here. psz >> PAGE_SHIFT is
zero when the ITS page size is below PAGE_SIZE, which
its_probe_baser_psz() can pick (a 4K-only ITS on a 16K or 64K kernel),
and then the L2 page is donated as zero pages and stays
host-accessible. Same in pkvm_host_map_last_level(). (Sashiko)

> +static int pkvm_share_shadow_table(void *shadow, u64 nr_pages)
> +{
> +        u64 i, ret, start_pfn = hyp_virt_to_pfn(shadow);

ret could be an int; it holds the errno from __pkvm_host_share_hyp()
and the function returns int.

> +static int pkvm_setup_its_shadow_baser(struct its_host_state *host_state)
> +{
[...]
> +                original_table = kern_hyp_va(host_state->tables[i].base);
> +                num_pages = (1 << host_state->tables[i].order);
> +
> +                ret = __pkvm_host_donate_hyp(hyp_virt_to_pfn(original_table), num_pages);

Could setup read GITS_BASER<n> and validate base and size against it?
base, order and the INDIRECT bit all come from the donated snapshot,
not the hardware, so as with the queue in 06 a compromised host
calling this hypercall can name a decoy table it owns: hyp protects
that one while the real table GITS_BASER<n> points at stays
host-writable, and the L1-pointer patching this restriction exists to
stop works on it. (Sashiko)

Cheers,
/fuad
