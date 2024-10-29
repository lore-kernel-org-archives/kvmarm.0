Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4871D8DFE
	for <kvmarm@lists.linux.dev>; Tue, 29 Oct 2024 17:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730221584; cv=none; b=WCI5S5R9xCjUhNetXthoLaotg8IR0ydKsgpVK9waITY912E0t8BPldkjtpUypSW6pEBseGWmzeiQh/dXusQZ4+HG4cRLkoTZ/27Ilpiu6ypnN8aWDI2oohLpA0ccln+le0aD//bfpbGkYwH19JxG9Yl+TdLEidREYTXltiCLlFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730221584; c=relaxed/simple;
	bh=ynacYz6swHjZ02f11a+UlbsVE/1P3vOR86gVEDQ9s+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KvvpcQhiyu1AXLg6568nwwHrmwtWkUj+IwBE95MXUlCrCvUAGLFjvR+cxKNWbZ0Qh+baayfRED5mkLGHtZcnUphjBiHI9ZZY/Kz2mt/rDHQA7Ht1NgcJ7f5keC8FUuuvDL/j8mgVa2DimUTtynCaiFGdq/j+Klpk73I+bWetnk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EmW1XMtz; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EmW1XMtz"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-460969c49f2so14221cf.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Oct 2024 10:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730221581; x=1730826381; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynacYz6swHjZ02f11a+UlbsVE/1P3vOR86gVEDQ9s+8=;
        b=EmW1XMtz9BiP2xpPKDRYmqUlufWQIPuOgSjxzdHqt0K9XsVEn7Ixhj3CjUJe1dG8NG
         l6LAhBr5gjr1pC9HSmoOAtKsoY0NlF0bg/vV8XzfhER82v7gIBz6X83/At0tpYUsy52Y
         5vUzhk8sV9X0L2UG2ge0XxCN/iwpfhbq8lVGrxt/WXK0Fu6Muz1zz8brmonT5aYmDdEq
         Ntmd4T6QX4jNw4XYZdTxnC8u+gIBEPMS5un0y6DqnGn9dvzU3TJt7MyWHDjIXNkavNdr
         z0Le480baYq8OWw2GbxpS6f08wmj2N5RLpYYGPlt2ByzlUJyuvl0eLgry3p/ENNZNix9
         IlcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730221581; x=1730826381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ynacYz6swHjZ02f11a+UlbsVE/1P3vOR86gVEDQ9s+8=;
        b=A05FiYPIQCXY18kT8pil8QKRBlvuOC8NaQkwKqE3Sb676FM8bdFGkxO4haLYqW8BS6
         1thhL2JVjyDkxVi6kt/X5BWGBLV1+dsqz+yq4EgmDu6K+DdNxZIRTTT3DtGv53w1SKQB
         PXwMtA7F6jWb5f5s8Ex45/3fCWwpi4JNZ9r21CtfKcr8SFUQ17HyQlAbVrXG97+67dk6
         A2OjGhJIfFg2gKLnlnlkuohLB7IiIajHqTqtTfV9yLzfe0SF/R/ZdMVK4xDUf23cMENG
         iMcvzzv/HD5Tu79FYHbo4yHTRl4tu2oZqpdrbURpZhbpgxdiZXu8xqspBeZ44dqKUSZW
         gCLg==
X-Forwarded-Encrypted: i=1; AJvYcCUeyPevNX6HOIzwmTHH+u7NgIshxMOqgCIRzi2Jxz9dmuDlJFgwnV6uCrSBU/wyvwesAvU/Oc4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwznvxXK1mFZ/Ek1s2IHqlq5YU1NVW2g2TabxRpgya4qBm5GXIA
	ywrhCwSCJh1nnJRPXx2LOMtcEehx2+ZVjTPgTy6s2n7Ysa2bfpGTZOxu6RtIYgjxAAqTW+zj+wu
	sQXxcGSs27b2803pWD+0Y9kTTqEBwl0Lcci93
X-Gm-Gg: ASbGncv8aSRMbrT4TmRcFgeLZB/TIH8xtwkKsluuCjANNhIPVZ8RCMkQngCzWzIPTpz
	aaZCAUE1irTO2XHPxx0zt4YQr575GX7JuqU8x+AikqQ8zM9yRbiRu4dwx0Xqcjlwp
X-Google-Smtp-Source: AGHT+IERQ2wd6YprqS4eYvnnD7z6rw6ImUej3A/vL1S07gFistJ64iydzViz9z7fnItMS60psPXdYpEjxesagiZuwK8=
X-Received: by 2002:ac8:5dc8:0:b0:461:43d4:fcb5 with SMTP id
 d75a77b69052e-46164eaa58fmr4706231cf.2.1730221580720; Tue, 29 Oct 2024
 10:06:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241028234533.942542-1-rananta@google.com> <868qu63mdo.wl-maz@kernel.org>
In-Reply-To: <868qu63mdo.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 29 Oct 2024 10:06:09 -0700
Message-ID: <CAJHc60x3sGdi2_mg_9uxecPYwZMBR11m1oEKPEH4RTYaF8eHdQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Get rid of userspace_irqchip_in_use
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2024 at 9:27=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Mon, 28 Oct 2024 23:45:33 +0000,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> Did you have a chance to check whether this had any negative impact on
> actual workloads? Since the entry/exit code is a bit of a hot spot,
> I'd like to make sure we're not penalising the common case (I only
> wrote this patch while waiting in an airport, and didn't test it at
> all).
>
I ran the kvm selftests, kvm-unit-tests and booted a linux guest to
test the change and noticed no failures.
Any specific test you want to try out?

> Any such data about it would be very welcome in the commit message.
>
Sure, I'll include it if we have a v3.

Thank you.
Raghavendra
