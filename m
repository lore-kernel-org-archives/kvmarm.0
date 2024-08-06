Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF69736AF5
	for <kvmarm@lists.linux.dev>; Tue,  6 Aug 2024 17:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722965033; cv=none; b=ifffcAFoMNNYDrDk6LZ0787uiCezsGxUJRQYOJmAeSfkXOWDD8n73AzE4q3Q6YikzAJg++b5cTJeLhjY/bJY+iXzuHhPONsNNqFV2yPZoDyMUByujwYAwaI/iXrGhusLw0k+PxY3buqqHJC+SAsdjqLo42MWfmiqxGNJnBlJ6aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722965033; c=relaxed/simple;
	bh=WbFlE5+qPAkFqLnreSC1NqqOFCvXcZe2PPM30+LdzcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HlclvovBM3beyEkZ6Bnhw2Z6ZYoXzUFk2Ypa8of2PIsqTg8IkTsAiehb5Zb4N8FuXAO5Ci/Qvc/vynTWnTjMuUZbs0pYu6HOIYs0F/iq5fddDIn0SYzcEzA8pd8I04mAiRQTWhDLlH/c95v5ZNG31VedSAmoaDTnF8ZpSwRMOMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=fu3qpcso; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="fu3qpcso"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6b79293a858so4821386d6.3
        for <kvmarm@lists.linux.dev>; Tue, 06 Aug 2024 10:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1722965031; x=1723569831; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F4rmNPnz+kGMra0RQJtqJ1i8be+boDPo204/oBt9Rcs=;
        b=fu3qpcsoEwSsedBWxU2IBxZyEfODCB5ZqRIKCIaIlljcW53NE21QWJHAbUpOQgwLan
         fFcDWCk9vcnE5WUfzWAXAjypngFud1C+cRC6g8Le+nJf5DcQMGaGLaNdMEczxks/28Uc
         Pgpmf8gXzu4nLKI6RynvOXPixafda3VzUJ8qviXIdzV2TXE6YdJ8gvypcfqIf+GN7+dl
         sUzinJRF4ymtTIywDbF4VrT5oBdzRZbO/D+2k5dCdIRrWCQXPM9Y9ZVLXGYbcWotJrnT
         Oz6yJtGoe9w2VclYei2NB6iE1602ex6d/MMn/gPEkTmVKRrOciv+KnJNXzsHbPZL0AAl
         a2FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722965031; x=1723569831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F4rmNPnz+kGMra0RQJtqJ1i8be+boDPo204/oBt9Rcs=;
        b=dPZObNxC/dUTmzHhbj4hW9VZS3WU+8dwXwwodQkOCQhBMMlG+utL4WndsN8QImKwFf
         2c5C+DlaItS9NynJwigIjF3swD1IoyKxw0tnfxUaiTBULFZuXyoutvMHaPlXgxQhQiNE
         tgfbOEE6gBfZeiS0y7iGMg9iwp91zFEEddBLC48x8lkUCnrmAKmvbhstQOaZq//TXn7+
         U/UECSPv/8ZnwHkSntDnjKEzhdJZMn57HcPwwz8nsrrwlOaVPu2Aw59wukGxE4orC3Ew
         GofXRFxDqSKVy6o6KvQjThQUjKDzS+yRRgwID904GYfDYzc/T/mJCKR16XoB/e9YUgYZ
         3sJw==
X-Forwarded-Encrypted: i=1; AJvYcCWjVEGEUO56dNqYijk1MdyjdwMI+kZpPdvikeedDfRpb0Ez6j6hmJeCdALJEwAshyqLWW7long=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+2TraZcjxEUg8EQV6AcU8krfaSf0XJXBQ6hIf12EVZKR+0szZ
	0Zyu1BL2g1ZDGpmM6kCZ6gb3LSiPPdouHbUyRyvJelue8y2YpF5qTmx/ThVEfFk=
X-Google-Smtp-Source: AGHT+IGN/g/G+FXYvmY4HkM76lkSBKmxvlD+n6uvRjDt3aMuV/oycOrSHTiQPvVwSkF6jaF3MwJXew==
X-Received: by 2002:a05:6214:5f03:b0:6b0:7ba0:ef67 with SMTP id 6a1803df08f44-6bb9840713dmr163494426d6.31.1722965030621;
        Tue, 06 Aug 2024 10:23:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb9c79744esm48263166d6.40.2024.08.06.10.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 10:23:50 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sbNuX-00FYRk-Mv;
	Tue, 06 Aug 2024 14:23:49 -0300
Date: Tue, 6 Aug 2024 14:23:49 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 05/11] mm: Add fast_only bool to test_young and
 clear_young MMU notifiers
Message-ID: <20240806172349.GQ676757@ziepe.ca>
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-6-jthoughton@google.com>
 <37ae59f2-777a-4a58-ae58-4a20066364dd@redhat.com>
 <CADrL8HUmQWDc-75p=Z2KZzHkyWCCh8xnX=+ZXm5MZ-drALjKTA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADrL8HUmQWDc-75p=Z2KZzHkyWCCh8xnX=+ZXm5MZ-drALjKTA@mail.gmail.com>

On Thu, Aug 01, 2024 at 04:13:40PM -0700, James Houghton wrote:
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -106,6 +106,18 @@ struct mmu_notifier_ops {
>          * clear_young is a lightweight version of clear_flush_young. Like the
>          * latter, it is supposed to test-and-clear the young/accessed bitflag
>          * in the secondary pte, but it may omit flushing the secondary tlb.
> +        *
> +        * The fast_only parameter indicates that this call should not block,
> +        * and this function should not cause other MMU notifier calls to
> +        * block. Usually this means that the implementation should be
> +        * lockless.
> +        *
> +        * When called with fast_only, this notifier will be a no-op unless
> +        * has_fast_aging is set on the struct mmu_notifier.

If you add a has_fast_aging I wonder if it is better to introduce new
ops instead? The semantics are a bit easier to explain that way

Jason
