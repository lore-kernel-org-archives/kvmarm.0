Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036272C0274
	for <kvmarm@lists.linux.dev>; Wed,  3 Jun 2026 10:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780481534; cv=none; b=f0v+c1j0EiSMQA8J3UyTpb+p6El5KNHNUxdaqfPzjrdO1iS6/ikuh7/AX2v7qspYg9s5egFnPs7/RXLBnz4bpxz2Igr6h6adiwinoHmNyDBFEHjPekBlUmmcxHd92QJfmXhK901xEvYge/MqvknQ7+U/rzdKB1Sg12RS2MJNkEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780481534; c=relaxed/simple;
	bh=fGTyeVYAfWL4rXKWP8jyLPVlcYjcF45jBG0YBs2uh94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UepZAwzu7i2pk0XUz5FY1nYH7Xcwb3ncdeI/iiN7sQgD4Vsas/V9Ztn5CXkmylWNrj9EnKv8t0kLW6b0xmdu97+lRdW7U0vTba6RThhn96T09k3pyct9CjgmxqgPRcVcqzTTMQqKz3R1MEHhsMEkEQK2gLnPAhP6ZF+ra2uFyXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jnhYd+Zv; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jnhYd+Zv"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490b3e03939so4475065e9.1
        for <kvmarm@lists.linux.dev>; Wed, 03 Jun 2026 03:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780481530; x=1781086330; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pIaWOz4jzomrlICte653zCUp4/MwcwzwiqZTiopmMBg=;
        b=jnhYd+ZvXNMzQb+Nhebl7AeSuv9GsYVI7FKH+zJH+je6ypwVjtFyEFyW5G906Gdl9C
         h5v1efcD21PdX4OKBu0ASmaPC1s2EsXGRgaCIrl/3caw9/wSA0ssbEOs6xXUdoNHpi2A
         MCm8QU2d6HEWDlGG4aWqGGs6EULnakXznwMJyQLxVI366dQO6o110A1erQjQ0sxUo0Em
         huIAQYFUQamiJS59ebiHyPlwN9kvrtKdIcclbag+oVMjAx5/kaZDjhbSzsmbRijMWeRt
         y1Z+PAE2QJtqpGNwcm0RX+GVvt5nRXD6t3qlwF0X94z4FFqegVBySXKkdvizZxuOa24J
         29bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780481530; x=1781086330;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pIaWOz4jzomrlICte653zCUp4/MwcwzwiqZTiopmMBg=;
        b=hdPuSGJYC9kZ2FZBuPVayZKoa1HnW1K7XIvCXZERwOpQXKg3rXBu1XU5dx2fHjZ0fS
         EtoGSIwneR/xtCOuwBuC2a7MIYCogVa2TlZ0jWU5bljlnDc0ALY6cLkyRsifF9YUA2gG
         qojPiQ248b5aqC/9yY+X8LzV3bbI2sPDpAxmDuPykys2TTKIH33eeI17PV6Tl5EJpEiM
         a5+dn2rTKkaJNqhR4Z878bE5JXHK+mJlUTfc2wWWDnjbC6EwkjsrT7hdocqoTGSQLQ4A
         3yhJgTgjv9TOkLGl8azNXwlNkbaKnn0oZ4aKXSly4DVZLDhza0s4CdJbJvb+A7WoQDrV
         pX+Q==
X-Forwarded-Encrypted: i=1; AFNElJ82S0ofB0ZINAic5ajKP+Sy60MS6PXRyd1nygr7k1g6kfqhYPSk697AFWAw/sPXehf803Zyyww=@lists.linux.dev
X-Gm-Message-State: AOJu0YysV0BVyONiEghVW5g5cEhN/LmbAulbKRHvukh6+w0eMqHKYHzT
	ng913L50DEGOwKd2J3jSnCW1Gkucw2WDFd2yLLzW+ng3/6PuE9y0uz7E7sVbbuBp4w==
X-Gm-Gg: Acq92OGJED5HU74JwGXROuVaSr+zErl7WdLD4BfNO3XGpWkf40f8AoFLl/ZRhgkibkd
	CmcvcIYcRevMcWx9FMpoafenTr2JZLVsiy5P8RL/z51zJxorg1dXX4IPtf1hzkzYaNyK6H3jibf
	syfHZBM96efCK9vj2R+yn/rIhde6TZvOnM2vfYmfYDcfOFcATSShQRgt3UqIJDKU1whwta/wfEO
	kgfNb2QLg3cHat9GXAVcgQvg9fSIQs8f3xw7k75ORYFXL1axYPZlPE/IU67wVnKijVXiyx9vNez
	gUGGdsgTyrj8uLkqnvSXn0+fteya08KwpRd/9fawyRHeubX3Dgx+haEjkj2so/xgxV6E6puCtUS
	5LJs+Atx3wwYP5YVypNWVXZLyMYq+dPf776AI8961bTWG3vpfYVmI5nSuG56IskG27Lqs2keao+
	y6Zc1v2yGlwrNgBHTSjsrQjSGbg/kNIIvax+ebxoU/k+HK62/sy934t28h5QrUP74bOb1iPQn5t
	EyXluonD9F4ZvH3
X-Received: by 2002:a05:600c:8488:b0:490:b4cb:3866 with SMTP id 5b1f17b1804b1-490b613f181mr34363835e9.10.1780481530006;
        Wed, 03 Jun 2026 03:12:10 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490b63e63d7sm51863845e9.12.2026.06.03.03.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 03:12:09 -0700 (PDT)
Date: Wed, 3 Jun 2026 11:12:05 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: tabba@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: arm64: Fix host/hyp tracking on
 share/unshare hypercall failure
Message-ID: <ah_99d29qLuQey35@google.com>
References: <20260529121755.2923500-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529121755.2923500-1-tabba@google.com>

On Fri, May 29, 2026 at 01:17:52PM +0100, tabba@google.com wrote:
> Hi folks,
> 
> The first two started as bugs I found testing Sashiko locally with
> fixes to review-prompts. The third grew out of the v1 discussion.
> 
> share_pfn_hyp() and unshare_pfn_hyp() in arch/arm64/kvm/mmu.c maintain
> a host-side RB-tree mirroring the set of pages shared with EL2. The
> hypercalls they wrap can fail (page-state mismatch, EL2 refcount still
> held), and neither the per-pfn helpers nor the multi-page wrappers
> cleaned up correctly on failure:
> 
> - share_pfn_hyp() left its tracking node in the tree on failure,
>   leaking the allocation and presenting a phantom share to a later
>   unshare (patch 1).
> 
> - unshare_pfn_hyp() erased its tracking node before the hypercall, so
>   on failure the host lost its record while EL2 still owned the share
>   (patch 2).
> 
> - kvm_share_hyp() returned on the first per-page failure, stranding the
>   pages already shared by that call: the caller treats the whole range
>   as failed and never unshares them (patch 3).
> 
> As Vincent and Marc noted on v1, none of this compromises isolation. A
> page that cannot be unshared is simply leaked: it stays shared with the
> hypervisor and is no longer reusable for pKVM. So kvm_share_hyp() now
> rolls back on failure, and the unshare WARN_ON()s are left non-fatal
> and documented rather than promoted to BUG_ON(). The system keeps
> running, and only later pKVM reuse of a leaked page would fail. We do
> not expect any of these paths to trigger in practice.
> 
> Severity is low and this can wait for 7.2. Patch 3 builds on patch 2,
> otherwise they are independent.
> 
> Changes since v1:
>  - New patch 3: roll back partial shares in kvm_share_hyp(); document
>    the deliberate leak-on-WARN in kvm_unshare_hyp() (Vincent, Marc).
>  - Patches 1 and 2 functionally unchanged (patch 2 gains the call-site
>    comment).
>  - v1: https://lore.kernel.org/all/20260529074341.2271950-1-tabba@google.com/
> 
> Cheers,
> /fuad

For the whole series:

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> 
> Fuad Tabba (3):
>   KVM: arm64: Free hyp-share tracking node when share hypercall fails
>   KVM: arm64: Avoid host/hyp share desync on unshare hypercall failure
>   KVM: arm64: Roll back partial shares on kvm_share_hyp() failure
> 
>  arch/arm64/kvm/mmu.c | 39 +++++++++++++++++++++++++++++++++------
>  1 file changed, 33 insertions(+), 6 deletions(-)
> 
> -- 
> 2.54.0.929.g9b7fa37559-goog
> 
