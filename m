Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D8034CD2
	for <kvmarm@lists.linux.dev>; Thu,  8 Jun 2023 22:14:22 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-33d928a268eso182855ab.0
        for <kvmarm@lists.linux.dev>; Thu, 08 Jun 2023 15:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686262461; x=1688854461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3VvOVkeoZOg8bLOTHO/XPAd+duFpOWtxmm7bgNMjwIY=;
        b=SMu023XUb3hUwIzFGWt7VF8BORxCe6qv0OHg6vdrhD5Q4hLPfovNAjr0cpYZV8z2I/
         qHID6Y26hyv84vgV4sRxmcjOHqHB9zneqOuERsO+QZqGoJD6EuPi/tCWSD6tbQaA3fou
         PwdFkNkXuG3YYckZyScVzMBNineCRvCgVZisP4yKzy8widSfC3WO5Rdswlha0rTnzQ5x
         lApzjhUZW0UOMN1V5LrmyLByurKV6qUtslTaxRWs0xEvEXHZg8EXB/xjasb5LBpcVLJj
         MnAkI+Foz+xbPY49w7StsDbIO5zpJ8/FSA44sxcMv/ksNtaKeDsul2wT1XNl9XBpGcC8
         /O2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686262461; x=1688854461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3VvOVkeoZOg8bLOTHO/XPAd+duFpOWtxmm7bgNMjwIY=;
        b=kyjwPAKrD4mGy2arYgGHxeXQ0RA81JvUJNuSMSKtp0dJ3g0D+RxtjuWLKbFW7QcvhM
         DvkLBQ3TsJf6EO6YaZzYGjkhTv52pExfrLqkWQ8IXA7qLYA8NmsyQoh5dh7K6e6NMfGN
         qYQ2heqGrIu2FIXPF5dlahmqK3d594mEOBx9fLCNIe1NYSZaW0hryFRHcmIXV7mUYPvg
         0JDZNy7fFJVoCnBa45RJ59BvXYdzZT4BUa+RCUEYOUbFbpchBHyM1rtcakbmBEFsnJfk
         YaWrJO4o8vrinuk0/gXklEAcNNYBdV+ykhV2hl+U4topiPxOCsdzRzseJv5BTJhhj5yh
         v9ng==
X-Gm-Message-State: AC+VfDxWHH6RmttGvqcpCiDFGZFMf/oKIKbHOUD0z6kRcxAputSBkb1Y
	cJvau7awi0PyaXv4R/yKXJHT+HqEps9TS6fbW7G2QA==
X-Google-Smtp-Source: ACHHUZ5SxX7JBSREEC9RUhJHHbRZp5/FKA22DLCloyyUQOmkMcWK0C3/vAV2Gz47nH3Lc8iVEjZJCz7r4IZtJz/+T4g=
X-Received: by 2002:a05:6e02:1bac:b0:33b:5343:c1d6 with SMTP id
 n12-20020a056e021bac00b0033b5343c1d6mr215059ili.21.1686262461249; Thu, 08 Jun
 2023 15:14:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230608220558.39094-1-ctshao@google.com>
In-Reply-To: <20230608220558.39094-1-ctshao@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Thu, 8 Jun 2023 16:13:44 -0600
Message-ID: <CAOUHufbik3N9+K78=yGMZyERfD2o1o3kNgVoR73qKxWyQ2_3VQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] KVM: arm64: Consistently use free_removed_table()
 for stage-2
To: Chun-Tse Shao <ctshao@google.com>
Cc: linux-kernel@vger.kernel.org, oliver.upton@linux.dev, 
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 8, 2023 at 4:06=E2=80=AFPM Chun-Tse Shao <ctshao@google.com> wr=
ote:
>
> From: Oliver Upton <oliver.upton@linux.dev>
>
> free_removed_table() is essential to the RCU-protected parallel walking
> scheme, as behind the scenes the cleanup is deferred until an RCU grace
> period. Nonetheless, the stage-2 unmap path calls put_page() directly,
> which leads to table memory being freed inline with the table walk.
>
> This is safe for the time being, as the stage-2 unmap walker is called
> while holding the write lock. A future change to KVM will further relax
> the locking mechanics around the stage-2 page tables to allow lock-free
> walkers protected only by RCU. As such, switch to the RCU-safe mechanism
> for freeing table memory.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Chun-Tse Shao <ctshao@google.com>

Acked-by: Yu Zhao <yuzhao@google.com>
