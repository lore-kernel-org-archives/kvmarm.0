Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0532E0FC
	for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 21:24:41 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-54ff478ab88so62932a12.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 14:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686864280; x=1689456280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BTZ5wBqtEZTdQvE+t4svmHg7qfGpYuHSch0PJIYuwpc=;
        b=UAVsbD+rOMz++YgcW9tDED5JpE4OtPhi8YPdcJXBtp9QX/IuUNehT65/Ow0C2MVATA
         EGkOw9+hzLJ/cne35+LiVmqq2VTyNPYprLQrF9PLovES/6rq+ysn1ynLSIPg9dxR0QcP
         ohnL9z8scervdEXxdk8w4DmpOq30/cvInSmT5Gg8XN4EymRebuq04qWWupQWdLUWsAl9
         /oLD4P/6IaBzJWYwS1JXtGKIvkCsJwaGsLRIh5HRYg26diQc+RPmV3rRY2yHtn5phe+V
         00L3TnFD95hRUUoX3sWZZv7weYp4e19oOTv/Axg4x7EepYQ1PmPoMjahS3ar1I7WQNkm
         guqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686864280; x=1689456280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BTZ5wBqtEZTdQvE+t4svmHg7qfGpYuHSch0PJIYuwpc=;
        b=GPAno3fPK8BFpLMqsehmpXthyIh2pVJJFxdEH/vfEgXmdWSQ4s1y23S1V3ar2f0wLp
         X1Xkiq3AROpXCx3cXsX8eeYHqS4JJiHQwLYqHQzw7SlfRyeY256+pyPLU7H2wdJ2cPlQ
         1DlC1NvBVMrvJeb7bGQl/RbDRqm6Pwmax5lIP89X+iTYyXXBM2/a7GA0KNer9hQgiCYR
         8ShYYzQqltB7moV9aG6WGxKGuLykX53skgCqoaQJ4oyb7HBepIA2cS3izkX7fcU89RZL
         27myMqIaWtkJNS4HBjvRXWUifpH8t1WSoLOSRrfMTqALWNRLpChezR4ipG4tyPBOG5JA
         3Nsw==
X-Gm-Message-State: AC+VfDxjOAYMn067E5UB/+AKiM7AMM171CgEfnnqj6utHD4jfVpsJhKJ
	DfEEPLxkKrif4WD84VQkHQz3vbA1Nv4=
X-Google-Smtp-Source: ACHHUZ7KzdQOHShTf1QUgNGdz/w2OVyoX+Tv6bGUzNqpJKuWr7Ua1EYxLokpQ+pxGv3Ta28uZLEjEQEgwWQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5559:0:b0:54f:73ef:f3a with SMTP id
 f25-20020a635559000000b0054f73ef0f3amr2104031pgm.9.1686864280542; Thu, 15 Jun
 2023 14:24:40 -0700 (PDT)
Date: Thu, 15 Jun 2023 14:24:38 -0700
In-Reply-To: <20230615054259.14911-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230615054259.14911-1-gshan@redhat.com>
Message-ID: <ZIuBliqWsgGmXpzJ@google.com>
Subject: Re: [PATCH v3] KVM: Avoid illegal stage2 mapping on invalid memory slot
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pbonzini@redhat.com, mtosatti@redhat.com, maz@kernel.org, will@kernel.org, 
	c.dall@virtualopensystems.com, peterx@redhat.com, david@redhat.com, 
	aarcange@redhat.com, shahuang@redhat.com, hshuai@redhat.com, 
	zhenyzha@redhat.com, shan.gavin@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 15, 2023, Gavin Shan wrote:
> Cc: stable@vger.kernel.org # v3.9+
> Fixes: d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")
> Reported-by: Shuai Hu <hshuai@redhat.com>
> Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---

With Oliver's comment suggestion,

Reviewed-by: Sean Christopherson <seanjc@google.com>
