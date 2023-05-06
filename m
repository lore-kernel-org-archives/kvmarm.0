Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37B1621
	for <kvmarm@lists.linux.dev>; Sat,  6 May 2023 00:56:03 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-b980e16b27bso2203987276.2
        for <kvmarm@lists.linux.dev>; Fri, 05 May 2023 17:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683334563; x=1685926563;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uKg9ooWeNyIkgIgwiRq1E2syoa7nncxzMKLzyswsRsc=;
        b=oEYCubX2MVaZ3lIzvYofKvwQIDmS/lXvTaPe+nx4JYIouIEOq7/VZNJBz/955TtNWl
         rYZHJ+9qECqeg4RDvNtvrHP7Ui0lGMPDX2ubGmDW8gNEBQ4HBdjErLbRCtIQE4/ErBRb
         UlUMiTVsTHoQ8RelA4t0FXBYWpOlPMnSpnz4cQsoVWkXnKmP9FEXp+ofhhYThW6YyuE1
         IHUvMHy+BC8pzZGtWZNz6yAWNfS98wy2U8g8HBZK4UcJlfQuJKNgMLKe1XbotZB+DRQJ
         E6hjwHB7/x0k7bAxrYPgZylFDAG4hiLFoxg569IPVzorgRuRk9NqLc9+2y4ttTt5sYY5
         aecQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683334563; x=1685926563;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uKg9ooWeNyIkgIgwiRq1E2syoa7nncxzMKLzyswsRsc=;
        b=ILZObD/1SIhji3tOL7R6i6Ob2oBVpFXO6T3gXK0N1z89Aav+Xzib8WpivnCy2ZywMX
         U3srF1Kh4+bM5hHN4wT/53UMsFX3+4I1WBbfRPcd049/pNg6A7pF6fMATlpZCHt3xLA8
         biXMQlfyOyWuF5ggZMGWwIrlafD7TkB4DMacw7M2B1ZRRafj0Hz2E+S6eVnXaMVw5n0I
         0mgnzkpNQHG1hmRipLau0TUZmw0mCJAiKJX7zYtZ8KdT+QWF2yFYgVTfKcPrEmI1asjH
         oejbPmldIYJtdq1VWwgh+Wi8hPC5RBMsLbTj1zDvqTaZ1f4qntJLgI2kY15D3FfSE92K
         aT4A==
X-Gm-Message-State: AC+VfDxY8acI37xJdjOJTLUF7+FqyiF1rfiW2QdjA9EHpt/N+P3DFz5u
	wezGq8zuJdIapzUVK6a4A0Eh/W2romS2oG9J0Jz04g==
X-Google-Smtp-Source: ACHHUZ7wTUegv3WyR7/Hq6e7DeiGJOrweEWBdXtRxu9dBQrh9sKO2r4H3TUs5GZtQPSXUUdXPbUlcJtY7oipXngdTpg=
X-Received: by 2002:a0d:cb44:0:b0:556:b029:e101 with SMTP id
 n65-20020a0dcb44000000b00556b029e101mr3457366ywd.19.1683334562650; Fri, 05
 May 2023 17:56:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230421165305.804301-1-vipinsh@google.com> <20230421165305.804301-10-vipinsh@google.com>
 <86pm7xjh3y.wl-maz@kernel.org>
In-Reply-To: <86pm7xjh3y.wl-maz@kernel.org>
From: Vipin Sharma <vipinsh@google.com>
Date: Fri, 5 May 2023 17:55:26 -0700
Message-ID: <CAHVum0d4W0emmyS0G8_nCXQuvgZN-8utDiT6TMYrOq7dF60aAw@mail.gmail.com>
Subject: Re: [PATCH 9/9] KVM: arm64: Run clear-dirty-log under MMU read lock
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, 
	tsbogend@alpha.franken.de, anup@brainfault.org, atishp@atishpatra.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com, 
	ricarkol@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 21, 2023 at 10:11=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Fri, 21 Apr 2023 17:53:05 +0100,
> Vipin Sharma <vipinsh@google.com> wrote:
> >
> > Take MMU read lock for write protecting PTEs and use shared page table
> > walker for clearing dirty logs.
> >
> > Clearing dirty logs are currently performed under MMU write locks. This
> > means vCPUs write protection fault, which also take MMU read lock,  wil=
l
> > be blocked during this operation. This causes guest degradation and
> > especially noticeable on VMs with lot of vCPUs.
> >
> > Taking MMU read lock will allow vCPUs to execute parallelly and reduces
> > the impact on vCPUs performance.
>
> Sure. Taking no lock whatsoever would be even better.
>
> What I don't see is the detailed explanation that gives me the warm
> feeling that this is safe and correct. Such an explanation is the
> minimum condition for me to even read the patch.
>

Thanks for freaking me out. Your not getting warm feeling hunch was
right, stage2_attr_walker() and stage2_update_leaf_attrs() combo do
not retry if cmpxchg fails for write protection. Write protection
callers don't check what the return status of the API is and just
ignores cmpxchg failure. This means a vCPU (MMU read lock user) can
cause cmpxchg to fail for write protection operation (under read lock,
which this patch does) and clear ioctl will happily return as if
everything is good.

I will update the series and also work on validating the correctness
to instill more confidence.

Thanks
