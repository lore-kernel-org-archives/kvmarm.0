Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFF913F017
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 17:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708709820; cv=none; b=Rk7qvElz0FcJxnC991owkWCafYByVhZqWTGojc54fOp3CUiErCEDyxPYlzppu5Tb36mz+ucm51p3m/McKP3+7f/S+Pvx6xbdK5RnZBid8sJrv6nrjsJ+DYvV5s4u4s6sXCG2ODcHKYDMa2lXUpJntwQQjXEAELbxNH+ebVEhBJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708709820; c=relaxed/simple;
	bh=mPq99SHVDAlyu/Lw6k/HCBY8a5P8RgeYGBIuIYVU8jU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VzduhiXoJZ5eCAlJ/KuqFbYlDeZfLBrtBtfRq7VvYmTaoKBv8TKm9QzwE4noUaIHuHw20Q2CU1VlJlWei1ybYhy0EUSANnck18o+AqSFh6J61Df/bRX/rtIcRN9/2GSdtSBEyNCatlGmgx4FmNn2u6QLTJVSiQ+XOnYfjG7WJO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nlKQ98pO; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nlKQ98pO"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbf216080f5so1758816276.1
        for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 09:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708709818; x=1709314618; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vQFkD/yeaXafYTambjNc8nGAaM5dCANMqU9RXbu0aLA=;
        b=nlKQ98pO+4639zvSpowPTyZNRKD1xC+HdEMEL8cNEliZ8LwQ0ybCqPq0FX6mpvdN2g
         7CaX7zFo53kaAlVNKBID/8iP4dmOK55JRIQS3RlJLEopk7Ixao1iD5dUA6E5ps+xQ1N7
         IqfeHK2CAgTp+wN2EmZFpRUYU+iyA3nr+73Pq6rzrUdg8gLZ5AGvF5PJ977P4ewWa3md
         yTcGU/595u+KLbgokxqOsQUp5zYrZkSsX/nHdjQBeJdXIWmKL/tbauGxtMDzxAwZ/n/7
         KtLL/5YDSKkFFe/6G4t6XhF/N+09WfuG2dpF9sk3yKMTfHoJ3Tmr8iU1ubMQTnbrybl/
         r7ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708709818; x=1709314618;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vQFkD/yeaXafYTambjNc8nGAaM5dCANMqU9RXbu0aLA=;
        b=lpRVP/cIAWCTS6dKEOghTJfHg6WcBux5J6zLypj7ybiI7aMKyo+b3UH8fED/lQWV6j
         RVwALBpXXt6SShrOAQ/FfoaTYEVAqiNbAKrtjAnukv18QBb1dBeYGo8slx/4HGSRlrOW
         BK945/no6NPxKTQKDqtUoUiRF/NV5mDbwA3oWPaxCASz2tLG3CXEOGxq9pWsC+uiWkAq
         kGNF6SWf3NVV0rLdWsWlZic6fOZiiZWCbDCW2ZDmqObB8ppAK3kkQYIIFPcMPUOO8U5w
         EswyUR/L2Lra32NIwKZ7FQ2vAcxI5sAmqwukRPWiS6OIes+214Tu3ahilYxkxUii5Erv
         ZYLg==
X-Forwarded-Encrypted: i=1; AJvYcCVmobSJFY2lhtI2G+noBgvH3H7AoB/TZlR4Xr7yPqnH+FTuKuv/Iy7PLCnNe43Lbu631FaNtJnWHQ2jGRmNT3Nky6t0ZZ9c
X-Gm-Message-State: AOJu0YwS8nqT0NXW9ENMudcYgxpAyQJ6h2+zhddkABk2DmnDTPNSDrdQ
	6fNMCyNCE5Lg9LVRhJ513wAkHmicca5BMe5tEmUukQMfBlYS4uwY3mQOt6ZrMnvutZ0kMOCdqkS
	wuw==
X-Google-Smtp-Source: AGHT+IF6qHLLb++rm38SnHHY1oMkxzeH9qs55zcOOM7YnS3PnobaoRSUe6xFvYZWf184A1ED5DElZhno5QQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ad9a:0:b0:dc2:550b:a4f4 with SMTP id
 z26-20020a25ad9a000000b00dc2550ba4f4mr124968ybi.1.1708709817812; Fri, 23 Feb
 2024 09:36:57 -0800 (PST)
Date: Fri, 23 Feb 2024 09:36:56 -0800
In-Reply-To: <20240221072528.2702048-10-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240221072528.2702048-1-stevensd@google.com> <20240221072528.2702048-10-stevensd@google.com>
Message-ID: <ZdjXuH4jBaAZCrgy@google.com>
Subject: Re: [PATCH v10 7/8] KVM: x86/mmu: Track if sptes refer to refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 21, 2024, David Stevens wrote:
> + * Extra bits are only available for TDP SPTEs, since bits 62:52 are reserved
> + * for PAE paging, including NPT PAE. When a tracking bit isn't available, we
> + * will reject mapping non-refcounted struct pages.
> + */
> +static inline bool spte_has_refcount_bit(void)
> +{
> +	return tdp_enabled && IS_ENABLED(CONFIG_X86_64);
> +}
> +
> +static inline bool is_refcounted_page_spte(u64 spte)
> +{
> +	return !spte_has_refcount_bit() || (spte & SPTE_MMU_PAGE_REFCOUNTED);

The preferred way to handle this in KVM's MMU is to use a global variable, e.g.

  extern u64 __read_mostly shadow_refcounted_mask;

that avoids conditional branches when creating SPTEs, and arguably yields slightly
more readable code, e.g.

	return !shadow_refcounted_mask || (spte & shadow_refcounted_mask);
