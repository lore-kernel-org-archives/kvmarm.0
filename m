Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BD5153515
	for <kvmarm@lists.linux.dev>; Mon, 13 May 2024 13:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715607074; cv=none; b=g5MPqvzh7g6+7s4fuhtFrbrvoKaPDO1y7eDf394gSqbNJExrNnsLgssDO/XUEZLmEHzT6pyObgJAc41Rc7+VH6YHDd5RDcSHOIgkRu0dSIvbm5d9N22JsGYdI8fQ1/UVSB0/las6+ALNCKakvnJoeArKEX4PD3qyTIsxeLu5fZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715607074; c=relaxed/simple;
	bh=Fqm2Gp4Ea2AnXbueV/ZqoPCx8y1qciRzdl8bP0tCGxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZajfSHN+ezH4isrHlk8imbtbwa2T24WfbJy80AG/L0/pYibFCNENJqgIzWncGCwojWi1/JG4VJ9o+eX9/bM9tKsnb1OHe60R07bzDeEGf8k39pmiz1LVnIbqAiSLgK/0raNUZm3AZpOAVaoR4uskJ3znxfouYPtIdKIwQIwpA/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eUy5rroE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eUy5rroE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715607071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oiIb+3nFVswBrkEwxMPkqHn0y0Q1J4bxwK2n9xhUWW8=;
	b=eUy5rroEeP2jVCknj9Jd58FUGgUS9G4+5pxVqRLcj7tNrDq9tTG40qOEDWbMlL+P2o5ZLb
	ai0TRZ8uLRVXqZ1Y03Ng/W8MIo1eowk0QZrDTTZv/QYCWKBeyl/CZGB2bGwWyzAIP5OumJ
	Rx4mPjkCVNK8cx2LOmWUKJkpeGIsjQY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-gA6NzQqpP-eRTgHXNYjkYw-1; Mon, 13 May 2024 09:31:10 -0400
X-MC-Unique: gA6NzQqpP-eRTgHXNYjkYw-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7928d8217caso564852185a.3
        for <kvmarm@lists.linux.dev>; Mon, 13 May 2024 06:31:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715607069; x=1716211869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oiIb+3nFVswBrkEwxMPkqHn0y0Q1J4bxwK2n9xhUWW8=;
        b=lvCyq/VkOVRTJRWZTCVn7jZmZ/MJu6DMKP5v5YXbb133ZwTNPghezdJjpP5jNFvXyp
         h3MPxpfPJCjIh7DHdiCQON5yFm92pZrrrj6jo+mq0dZQ0GRAoNsd8l/3jS8pgBAYSSR1
         UFGDfU8TKf7SFQvZ2C9SxHYBMhdzu+lUYp9cbFMrrIz2g1egiOUUIz27213xOR7N9akB
         P/7FILBLqVIeUz25Afm2fsAxZFUOcIZJxsvVqhOZuoJusW697fQaUpMgNtq9yB+x46Ut
         /TRIK7wDV1R0xqp9nWw/HgT6ooTh1HIheRf0u/L6wSfcjYr1vMErf+aqfSUxevK8q8zH
         GM9w==
X-Forwarded-Encrypted: i=1; AJvYcCXLCSBmZteNP2oFJ25FnreYUPiYO8XwddgHDoW3coWgzCW92MPwXfch7OSJSQ62LHmkM03dRYkKnk+yNuxgBVxAX+8GEjYB
X-Gm-Message-State: AOJu0Yx0YaLspcbe/QxObjqgRI+z6ExHEiVt9zYee0wO5IjdRim3llOJ
	a1uaYG+lPz3FmqNPuBcRumvC3v+sLXthM0FHjCWZ1c6WA32MREiwq6mr82JtkEug8cYaa3DzWgZ
	51Q8Mq8YjwP4Ht4WtSEoFiXdQeQ7Pp+myJmPHW9n5qZsQkifmqs+H7g==
X-Received: by 2002:a05:620a:100b:b0:792:c32f:caf0 with SMTP id af79cd13be357-792c7600c34mr1006622985a.70.1715607069077;
        Mon, 13 May 2024 06:31:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpj8HOhXADrX5aLoJtT9KExs3Lc5Cv2uyawKonMctLWoub/CtUpkqTjUxSYvXa9xO8aQIf7A==
X-Received: by 2002:a05:620a:100b:b0:792:c32f:caf0 with SMTP id af79cd13be357-792c7600c34mr1006621385a.70.1715607068752;
        Mon, 13 May 2024 06:31:08 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792e3a40492sm59551785a.86.2024.05.13.06.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 May 2024 06:31:08 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: oliver.upton@linux.dev
Cc: james.morse@arm.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	maz@kernel.org,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH 3/7] KVM: arm64: Only reset vCPU-scoped feature ID regs once
Date: Mon, 13 May 2024 15:31:04 +0200
Message-ID: <20240513133104.14444-1-sebott@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240502233529.1958459-4-oliver.upton@linux.dev>
References: <20240502233529.1958459-4-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

> The general expecation with feature ID registers is that they're 'reset'
              ^
              expectation

> exactly once by KVM for the lifetime of a vCPU/VM, such that any
> userspace changes to the CPU features / identity are honored after a
> vCPU gets reset (e.g. PSCI_ON).
>
> KVM handles what it calls VM-scoped feature ID registers correctly, but
> feature ID registers local to a vCPU (CLIDR_EL1, MPIDR_EL1) get wiped
> after every reset. What's especially concerning is that a
> potentially-changing MPIDR_EL1 breaks MPIDR compression for indexing
> mpidr_data, as the mask of useful bits to build the index could change.
>
> This is absolutely no good. Avoid resetting vCPU feature ID registers
> more than once.

Reviewed-by: Sebastian Ott <sebott@redhat.com>

