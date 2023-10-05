Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C001373
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 01:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2g9OxDkb"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d8191a1d5acso633788276.1
        for <kvmarm@lists.linux.dev>; Wed, 04 Oct 2023 18:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696470783; x=1697075583; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=grrioV+IuPOlzeiTfMVLnMrxd2jdrACTo36YNzEpcnI=;
        b=2g9OxDkbXYrY/9rdhquGH5zeBwPZHTWxXaQvAZgy/Xd2yZmEh2yLlL7vo0wsEhFkiu
         rbY1FSd9hYzXYqTbcpxsXkkyvU2TG2v0LIbk5ncxQgy4zvRzSRarS5TkaJIq3DxPfpmr
         cmAxoOeUuWAorUwRlNGmXuJJbTRO734iP+BPkRHx9DpktoD1B5xxB9Elzb6cVrmTptDg
         ABd9ppEHWHu7rnQ8OxgW5dZ8oBAkvjjuNuvEGJIi7BzqDj/klhEYONSdz4kUIMi8Dsf4
         uDA52NEVYRVLr33wcYPWWL0Z/wgRI4ZYHOe7xG9n+iRwi7TEElZb07pyyiDTrpG8dzGz
         yRcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696470783; x=1697075583;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=grrioV+IuPOlzeiTfMVLnMrxd2jdrACTo36YNzEpcnI=;
        b=byA55C1ZG7kHfJ8ZoarenYwvjrTvwE4C28ynpLUJCN/7mD7KGfWT8sOMYobMOOlZM1
         HdNgGp+4R79SZVmo5yIg+SVQRaINB8kiZpffa1NOOL9h0FedrNF4qyTgGOiLQ7eJoEmF
         xaaO46mMMGyZnmr8ARTjjT9+YkPWNK3EBWb7vWMKkvcGBFsHNKZpls7mhb/hiRF3EyYo
         /IM5AKUM8Xm2RitgGOs4P/8AEzF/cQqT6aU7wz3a0nuYiplyXxK5DUtgrhsqBCB8a6fI
         wihyKwIqSYcKz8+8wvwG5HYiIsOdJLsYd2JGmg3tNa7jb1DgKJJXWS8tCPkdMJBpTy2+
         d0UA==
X-Gm-Message-State: AOJu0YwZB5aJ/oihqaC5+1cWnxQTh+UIA5QzI6neQvDLxjVCSUopBGp5
	vnbb2v23dlEPJUyBdqgdVIStwJXlMZk=
X-Google-Smtp-Source: AGHT+IHyV4IRMorQjfEJtl3bCgO+6BZ9+2Q8anlpnWP+qXYS7Vaclmt7RTiW/s/YifIgopVhJqSKRRy92OU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ae52:0:b0:d7b:8d0c:43f1 with SMTP id
 g18-20020a25ae52000000b00d7b8d0c43f1mr60811ybe.9.1696470782888; Wed, 04 Oct
 2023 18:53:02 -0700 (PDT)
Date: Wed, 4 Oct 2023 18:53:01 -0700
In-Reply-To: <20230908222905.1321305-6-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-6-amoorthy@google.com>
Message-ID: <ZR4W_c_dTHuKjB5q@google.com>
Subject: Re: [PATCH v5 05/17] KVM: Annotate -EFAULTs from kvm_vcpu_read/write_guest_page()
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 08, 2023, Anish Moorthy wrote:
> Implement KVM_CAP_MEMORY_FAULT_INFO for uaccess failures in
> kvm_vcpu_read/write_guest_page()

Why?  (rhetorical question)
