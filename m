Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0129819DFB5
	for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 20:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729714985; cv=none; b=ErurdrJbtKzJoHRCV/DaBdQP0lELSr4x4VYeu615eBpwTQEpYrkCxtWiC5vI9E0H1CTvweqHx0NdOZ8E7yMlToQxnL8OFHCbWM0KNQju/wMqxUAjnbnievhV70qUw/rOvc2C4xrK0xMMHP/weFA1YVDEmw42mdZUVvoY2gefqy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729714985; c=relaxed/simple;
	bh=jbWiAyqBhiEXv3WIAR+95DU4d8rfKWrvkeP/G5neGpA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ab6miqKaxo6XJdsSQzgsY+4GjP4XYJkGI/fvxwdsEejULyxCmH5G9YittAaG26QWlLBQqG+xENdeeMoJgp2nPkoI7MjYx4cSynZAXQMK0IgeCsgo0BWGbrX7xU6fx5O5ccJ0SBBIkB+Q2eTPuom0Ck7HTKX8sY67DggF6GRnK5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kL2lP68C; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kL2lP68C"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539f84907caso169542e87.3
        for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 13:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729714982; x=1730319782; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QZD/0/u7gXlxe9du/g//Uu8khQkQ8pf7JdM6R0YxrK8=;
        b=kL2lP68CujZY++Z/bXNP77Pr+uSolhShJFokDiKmrO20sRThOPC43Z3nux7jaE3i+o
         tG0KGuMA0Sy6AFbfaaYgaedBx8mv3/Pqcn2PfZmZi1bB2d0YeuRY6j339M77BkL1HBvx
         FbLts+vaAuNZgodfXVBG+58ZIHm53j8kArLc8sRqpXL6HNfLiwYjdILxxoSknYW+22BM
         0eZYjzstzmIfHWQIywuIfE599CYFvMgPZZLhTykJbha4u47XS2E+zDFXGNByFRUuLF3M
         Tem0zu0KheZ0CctA9VTf42dmmF/aa9Q63uTLLDOkxKdi/UZn8vTQlA3MMWlZDJv9iRjM
         cLMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729714982; x=1730319782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QZD/0/u7gXlxe9du/g//Uu8khQkQ8pf7JdM6R0YxrK8=;
        b=WPmCeFGDa1fZgDvagU9hqBsNR+y1WIVuQBFfJyH6XrJxefPoFFYR86j7+ae2EUrMe7
         GTqq75D+AiIJxaI1BEHf4vUAOBLbGFa/ZdJarZ6oLxxOECP5m0C3WqOd0+2bHDPlSsEJ
         XkWgQe0L30pfWTyzWTrp6ZUmMWkUb/EHKjw1lPP0jQO0/l5yh/742tsXk6xh8kr6GDuQ
         xSqOcA7vQBNpj+Xo9AuHB8nGrCznmXJvPiY0WKvGi/tZFPW7z30NPdzrUfVy2+eScwR7
         jNdoujE4MJPxoWS1tTP2fGOWLTD8Pg2gQ0DxqemJLmfFN29NrAenh5ribMKHSXAd5OtB
         dx/g==
X-Forwarded-Encrypted: i=1; AJvYcCUg87TujJ8AczRHX8BRbdbw0egzC5f6AkNTGP0Ik/TTaPUd/QzZNyyX79Lt6zXIwnomvz5AXEo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzw/q+cxtIrQGZe45xkk073kQuQD5ikWPpatI+GdW7XD8r0eAdt
	gJ/Q5Bm0Moo/1G3/9b76x4i3Opm2iMDxfHryNoukPI1fisHidX/+xmkD2E9zUxlP+WhocauDLp3
	5IRKsEj1/F73c12oN3eUwdXteTN8z0/1xojYX
X-Google-Smtp-Source: AGHT+IGlNI9WaWM+QrYiA17yEQjL8bNc+Jh3lkHinNfgg5TW9AlhOnLoOjeid2kRXVqKu2tTh2RpWrDZehi1hSUFULk=
X-Received: by 2002:a05:6512:12d2:b0:539:f4a6:ef4b with SMTP id
 2adb3069b0e04-53b1a3bf229mr2388184e87.55.1729714981802; Wed, 23 Oct 2024
 13:23:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240704142319.728-1-jiangkunkun@huawei.com>
In-Reply-To: <20240704142319.728-1-jiangkunkun@huawei.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 23 Oct 2024 13:22:50 -0700
Message-ID: <CAAdAUtjnWqDUFfZri10HWk=U+Bsy1_Q8zEe7oucwGzNDJGQYGg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: vgic-its: Some fixes about vgic-its
To: Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Eric Auger <eauger@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	wanghaibin.wang@huawei.com, lishusen2@huawei.com, tangnianyao@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kunkun,

Do you have a plan to respin this patch series?

We encountered an issue during the VM suspend/resume test that can be
resolved by this patch series.
During VM suspending, the ITS table saving is called multiple times.
Concurrently, device table and ITT table entries are mapped/unmapped
due to devices' suspend/resume. This leaves some free entries dirty
(valid bit equals 1).
The table restore starts from the first entry to find a valid one.
There is a chance that the entry found is a free one, but with the
valid bit as 1.

Jing

On Thu, Jul 4, 2024 at 7:23=E2=80=AFAM Kunkun Jiang <jiangkunkun@huawei.com=
> wrote:
>
> There are three fixes about vgic-its:
> Patch 1: A data length check is added in vgic_its_save_*
> Patch 2-3: Fix two bugs in the scenario of continuous save and restore
>
> History:
> v1 -> v2:
> - Replaced BUG_ON() with KVM_BUG_ON()
>
> Kunkun Jiang (3):
>   KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
>   KVM: arm64: vgic-its: Clear dte when mapd unmaps a device
>   KVM: arm64: vgic-its: Clear ite when discard frees an ite
>
>  arch/arm64/kvm/vgic/vgic-its.c | 44 ++++++++++++++++++++++++++++++----
>  1 file changed, 40 insertions(+), 4 deletions(-)
>
> --
> 2.27.0
>
>
