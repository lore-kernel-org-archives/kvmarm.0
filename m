Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8090D1E9906
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 15:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753285115; cv=none; b=cRTm+Z1DaFV8Y23XqzDNYbH6NQjOs97JWg9djQ0hQBte8AB6zLkWRu+HQBZqD3i9IgYdqpPwutt+9Rmwaj6p6LaYAhfdXrWRNkGsMBLJD0uA+0z0ZiZNAwxbNvK4faGaeY+D1W85iCD5sAJ9WXDFv0KOmgr6WdPB/uteYi3/4vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753285115; c=relaxed/simple;
	bh=8T9TfCkafV99HUq2TR5S1MsMF69AzVNNy3QhV0IlXps=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=TJ1AoMSgZOfLQREQbNHCvcgq/aCRG+BMOtseHJKzD/s5q3ghGaopCaevlfwOzdV23K+QyZhr4V/FsboVcPO4D8ZL3mBZaxC3RZIWE/DEBnVvIE0bfiWCeHrfeqtpz/CEn8Yv76y0MWk+BeEFvTEDI7zC9yULVAmSZdtU7ueWMFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FnL0di6K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FnL0di6K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753285112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8T9TfCkafV99HUq2TR5S1MsMF69AzVNNy3QhV0IlXps=;
	b=FnL0di6KpPapMrr6g5tynH5AoimAa6fp5xnVWQHEb6PGrME9GRVCO13cMhT3qPbV/V152S
	3CzZRv4Aj6kdw2cvpAjOn1HBN9gRcZTXDZjJv7rtx1SQuMwGU6e7bP4NvVdOmabl0kE9fF
	c5cM8Fh+9QqYWW4MggHfZDeMMVYzJiA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-ihnzlhLZNj6jnr4X4kmn2A-1; Wed, 23 Jul 2025 11:38:30 -0400
X-MC-Unique: ihnzlhLZNj6jnr4X4kmn2A-1
X-Mimecast-MFC-AGG-ID: ihnzlhLZNj6jnr4X4kmn2A_1753285110
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4562985ac6aso68656615e9.3
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 08:38:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753285109; x=1753889909;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8T9TfCkafV99HUq2TR5S1MsMF69AzVNNy3QhV0IlXps=;
        b=L84UUbm6K1T13QzjM+25pcEmspogAMTOV/+d9EC0stzF9XKJaXnqNAk8hN6Oto2aRG
         buUs+T5fL4Pgo2AtVSaphPCIFTf8HcAcLyFHu+FVaHGaWREx75Y6VwZpAQghHXQAbvX/
         0TTEJjiIlIiJgY+XkAuNUUTenxeKpJ8AGdfFGQ0RiwLb8exNqfgACm9eL/iNsxjvCmGn
         Yk0zSQ2Dbdz3VOqDpmefHML31YiKGHkwzNsgRQ3JO4Jw/sL7+EjiuwHNo6QT4SiOiQGi
         cjH8u9jE7I2KvQ3FZGX6Sj2tKKiYv2tgkPaVTugxhC5RxxxpTPX+JIlEIpjO1u7kv4Hs
         cCHw==
X-Gm-Message-State: AOJu0YxiPaNmpb6WU3i9fK9Rkud2NfG9Kw15huUcPGX6k31n4lngjEok
	s5gOLZJkn3dwABp762pJ6RJQrIqryTZagRKZyZ/OQyZnUlkKQc9iC1299wewmRyIpC18MN29BbI
	VQllMBzCUjjq0XGHBX9mArC75ORXlpdF6rt4HWpWySlne8sdKNMxglSoktg==
X-Gm-Gg: ASbGncvDsjve9pUjw20NkJqLiDe5D86RkqesVQhMCmXesktb4rHEpriPSa4KQtDn7dU
	PAVVRVSVJlDx1ReOXM9eRjb3oVGWIH3kCZ/a6AWO4j6TDqtLAC0PLxIMtR9NGe953EIx46s20hv
	BgHxrC4/Uuh5/GGQQ2dV/bgc0DBViorYlCA/l8Myo215Bc+p3g7IGl62NW63ox75pjCmdvpXB5z
	G3/YqGSPN9+S+0Bodyr0Fdl+hFGSVESf3mNMLwbyo0ixkTrNEymPrIox7itXXQ4mtzH+IyLCRQs
	2ONm0r9BHS7aG8jqU6fzhA/ybNbgsIgqRR/eMDVw1dM/4lI8pqWDoPzPzGCO4r/CyU+/9/2dbhb
	G5D3J24baSg4e
X-Received: by 2002:a05:600c:80c6:b0:456:1560:7c63 with SMTP id 5b1f17b1804b1-45868ed969dmr23929825e9.3.1753285109551;
        Wed, 23 Jul 2025 08:38:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6wYI6fkFZoIyQMYYcyUTTH4h/csKxFYyTSF+4/JYLoYoXAjDzqJFF0JRN11ufGYAYyBF36w==
X-Received: by 2002:a05:600c:80c6:b0:456:1560:7c63 with SMTP id 5b1f17b1804b1-45868ed969dmr23929625e9.3.1753285109123;
        Wed, 23 Jul 2025 08:38:29 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458693f8dd5sm26144725e9.36.2025.07.23.08.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 08:38:28 -0700 (PDT)
Date: Wed, 23 Jul 2025 17:38:27 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
    kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
    Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 1/4] KVM: arm64: vgic-v3: Fix ordering of ICH_HCR_EL2
In-Reply-To: <20250718111154.104029-2-maz@kernel.org>
Message-ID: <b03eacbd-b8de-ce8e-57b6-66207c4b5559@redhat.com>
References: <20250718111154.104029-1-maz@kernel.org> <20250718111154.104029-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gI-kH6hwTE6wkCVbhv7-Ypr9c4W8NAjc3LuH--i9CPg_1753285110
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Fri, 18 Jul 2025, Marc Zyngier wrote:

> The sysreg tables are supposed to be sorted so that a binary search
> can easily find them. However, ICH_HCR_EL2 is obviously at the wrong
> spot.
>
> Move it where it belongs.
>
> Fixes: 9fe9663e47e21 ("KVM: arm64: Expose GICv3 EL2 registers via KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS")
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

