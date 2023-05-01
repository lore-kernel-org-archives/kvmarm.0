Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B14567B
	for <kvmarm@lists.linux.dev>; Mon,  1 May 2023 18:01:50 +0000 (UTC)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-3f315712406so138689175e9.0
        for <kvmarm@lists.linux.dev>; Mon, 01 May 2023 11:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682964109; x=1685556109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UGfxzS53bu6T6J0Ou4GBb9j+9uGsl9LMhYdI8VnO+SU=;
        b=Gsd4Zc9jxsjWdHsRoQX72VkOR4zfHqEy11VsBwLKLOUdgOTiEu7VYTmsxmZf91xIG8
         k0m9HnpuqOlOuELqweWNO4OMZdAD+cVemapLDw5yIW7fGJ6teU6QviZQBxY3+I5qD4G7
         om2Xf51JPiUXWF4yMgTaGkmFktVTNx+2us1YeJnKdHEx4Ps3tlGzATiuXRod/NII+sWh
         X/ZQqqCdGbcvlONoAXd0+e2LvRJgGfsp9EnIGtE4Xfogs399J3yasIQdpTczUfbabvoO
         ai9nWTbjhBbj7sr9Rq7Bxod/Duq/oNqUIYhuB0bGHSqIDfRbZ0V+Pr256sLwiznEmtyg
         NqIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682964109; x=1685556109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UGfxzS53bu6T6J0Ou4GBb9j+9uGsl9LMhYdI8VnO+SU=;
        b=HHhp9VIiF5DWwDBLIGQTa0koqbrUIipfVhAJG7rvDgEhVWl8nLH83nY9iczb9wByDU
         XrnMWeQ/8Atn6bKzvA1wqEQoR/nrQ6qgNIaxgv95HTofo28jeztdZe2r4oZbnKdEEgYu
         YXl9sOQFCAqQoIfMksKbjitdv/W+PsvzZF3t6ZU3HtuldUgmnAMj6iO1369yqniPeZbS
         q0lj4xjGQCQpSRI7nRHkrdIaaWf+KRdTDOACnjgnAIEKapDBigLG8rcTe62DsCvs2cIO
         3E6QIHgY4Id+zPlpuTOVNDk6Og1bHUImTbkWnYTixukXTxC63ZeJdCL9+13+tkfZT52n
         t6qg==
X-Gm-Message-State: AC+VfDy8pgUPJ8oGOmeGQWgR2h7IIDf+CmqMQw77idBiabdQFLS4J5FN
	LJJ6mbC2n4D1dVFtqXxzFMfY7ZsqzQvACzdAjS9ZVg==
X-Google-Smtp-Source: ACHHUZ56YjfJ40pnMhaesG6zsYJHPdRG1M1bkCZUAJldIumQNV8sWiZgRgRxBg+cUG2vuRpjRz7PxoEwW0S7hz2I+HY=
X-Received: by 2002:a05:600c:1d8b:b0:3f1:7619:f0f6 with SMTP id
 p11-20020a05600c1d8b00b003f17619f0f6mr13746634wms.9.1682964108932; Mon, 01
 May 2023 11:01:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-23-amoorthy@google.com>
 <CADrL8HUQWFtY+2XgT0f6fBhWrdTCvQ1n-99k9oV_5UiFnamv9Q@mail.gmail.com>
In-Reply-To: <CADrL8HUQWFtY+2XgT0f6fBhWrdTCvQ1n-99k9oV_5UiFnamv9Q@mail.gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Mon, 1 May 2023 11:01:12 -0700
Message-ID: <CAF7b7mqVPqGFkBvB2w3VahX0TFTxhnQGcXPQ04ANkO5fWO3Adg@mail.gmail.com>
Subject: Re: [PATCH v3 22/22] KVM: selftests: Handle memory fault exits in demand_paging_test
To: James Houghton <jthoughton@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 27, 2023 at 8:48=E2=80=AFAM James Houghton <jthoughton@google.c=
om> wrote:
>
> This comment sounds a little bit strange because we're always passing
> MODE_DONTWAKE to UFFDIO_COPY/CONTINUE.
>
> You *could* update the comment to reflect what this test is really
> doing, but I think you actually probably want the test to do what the
> comment suggests. That is, I think the code you should write should:
> 1. DONTWAKE if is_vcpu
> 2. UFFDIO_WAKE if !is_vcpu && UFFDIO_COPY/CONTINUE failed (with
> EEXIST, but we would have already crashed if it weren't).
>
> This way, we can save a syscall with almost no added complexity, and
> the existing userfaultfd tests remain basically untouched (i.e., no
> longer always need an explicit UFFDIO_WAKE).
>
> Thanks!

Good points, and taken: though in practice I suspect that every fault
read from the uffd will EEXIST and necessitate the wake anyways.
