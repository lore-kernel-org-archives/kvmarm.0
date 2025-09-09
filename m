Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF056301007
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 18:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757442667; cv=none; b=joQe6W6eGFJnZS0L4LIzdFW7u1El5OGY5VnAyQyzOqsjw3xc1TvkCA5Y911I7dF2UQO498kKnZqD9DfHyxA1VzBcwOk2dOoRvBlq+sFwvCko6tHkKo+LEV2X2VUj/muM2fHA5OzR9S90GUl3y+mSpeOpz70k+G4GtZgeBNjRfps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757442667; c=relaxed/simple;
	bh=yM0Xnr5mgLbhYQekgENeXiwmJdvFW1b1xD3j7t4hWgo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oZu08BkCAHiln3C7HBdhVjrGPZfJzIZi9FI6MsrS38rprBbHRQd7GP7m4JswFfq7MvrSmqTt7d/9o2aRzHU1n3+xKQg3cxBOwtew0WKRYMlqw0SygqpYdrC+M+ExlPIpIDWdM+rv18GUP8LBd5Fbl7KmhaXd1ga2qfIpofU/uYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2LHQ6PkH; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2LHQ6PkH"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b350971a2eso20991cf.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 11:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757442659; x=1758047459; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TfxcLFfDrPkIJiNUWhVN3N4fK2AjPT82pZU1A16szcs=;
        b=2LHQ6PkHHmNAZWQtRjbtwTyiNxL+fK5tUPzjW2uZPxsVY4HEnjBE11mfIulXoZQ+lT
         H57MJc2mX6eWEK2BDZ8k69Xfpt8Vz+u1eAjPhDys6Uc7amDfFBgyj2OQqKBIp4Lt5Ms2
         KHhC2LO+pmsqx7v+TMy3N23WuPz0L+nj+Q0bJDrI+8CilygncLEJxD+D1vrM82GZnekc
         DNuJOwdx3J2LU+RaxEqu8lUqhTI3L0ct3DPepCagWYgWihQ5lcyieQeOO6yY/cjCwcD9
         UGShd9x9UxHb5/koXqwc11m3PhJu792n8iVcrwrkwUquotfb4xeKA4MFmRP4/3hJwXe4
         0A5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757442659; x=1758047459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TfxcLFfDrPkIJiNUWhVN3N4fK2AjPT82pZU1A16szcs=;
        b=Q9diZSAo+3mxJrLcsajxKk/fuuuG8JuLSyy51n8oaqgwdbUTheSmr7f0SI+SxB0899
         atUK7Cg0arHX6/GAkpSIV1cEBE/aytNw08bhkmDHBcjkfetSU22vguMvPAS9SAPK142Q
         5u0ScVLRCrYZOdIoDsvEXVI7tc+TMVDoFlGKO/FN8SRvVV799J8fMlSSvyykPQjbG6Kr
         OxiwGQOFjqARUCKSYMkQWW2+CU4e9rI2GiZB0+wWmo9KrZIlkRW3pWcI8qK0jjvbiqDR
         1bgDcVy9CP/rTEd4Gcm313t1SFUYKrH5qcCN1fMz22ICeVryOHoAk2fTbJJodgvPNF5f
         7RfA==
X-Forwarded-Encrypted: i=1; AJvYcCWRgc9J+xloeyAqFv0HGPuL5f/8dbWeoD2GE4ZOVM+QkoZIkspNzsJMx3AHjhDzQYKCi9eMh3M=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqHnZIjq8Vrbw0ECUSliI+nmG64Z/B4epuoUEXqBqO2gqLtT1f
	iBOHa2eOUDkoC2rR+xTKKvVESbEFOtgVU8VQYjjA30UxujgoOJwspzcy5Hjbb73btrV1LZcPLYG
	AwrYOV2XxMEnNhrVj+CwEesdmlub3hN6SAhWGQQUphtZnZIOyHJxboDhyYhM=
X-Gm-Gg: ASbGncvHI2PIcUmJC4eT6GhjQMuO6CW+5fS/Qt/m1koCNJegVVd8ZBpdJFIic0NmOLM
	8qNm3B4SlDIB1X/lxEQC59jnvSrjEjR16j9tlTaO/+iKFd0vtuUKWuUNupidQBXtqzOG8M+yzXk
	lRId8a4uzXAG4tB6zm2Ub5ChUpdXl6gmHQVK8s58eqkP5GlIzlumt46mWzGnLrt7/jaudzF7CFn
	xEZhnA2KPIOw7sRmupR6A==
X-Google-Smtp-Source: AGHT+IGf+Q8hPzzej9xbfaEr60LoJgETjDgKDHy0ML31wiaO21T7Ktg8vRU8pvPgmGyM85KMJM70NWIugrUwyx3yAfE=
X-Received: by 2002:a05:622a:14e:b0:4b4:979d:8764 with SMTP id
 d75a77b69052e-4b62569f89bmr232071cf.19.1757442659042; Tue, 09 Sep 2025
 11:30:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250819215156.2494305-1-smostafa@google.com> <20250819215156.2494305-17-smostafa@google.com>
In-Reply-To: <20250819215156.2494305-17-smostafa@google.com>
From: Daniel Mentz <danielmentz@google.com>
Date: Tue, 9 Sep 2025 11:30:48 -0700
X-Gm-Features: Ac12FXyo44kEPGnZiMSM0NG36OMtjkd65ZSJDU9pCejgoL2I9Mvg7O8L88TNYvU
Message-ID: <CAE2F3rDc-4SirDDrQeZJQDqjdv67-QFfQhHfwyd+O6f5OsBSpw@mail.gmail.com>
Subject: Re: [PATCH v4 16/28] iommu/arm-smmu-v3-kvm: Create array for hyp SMMUv3
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	robin.murphy@arm.com, jean-philippe@linaro.org, qperret@google.com, 
	tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025 at 2:55=E2=80=AFPM Mostafa Saleh <smostafa@google.com>=
 wrote:
>
> +               if (kvm_arm_smmu_array[i].mmio_size < SZ_128K) {
> +                       pr_err("SMMUv3(%s) has unsupported size(0x%lx)\n"=
, np->name,
> +                              kvm_arm_smmu_array[i].mmio_size);

Use format specifier %pOF to print device tree node.
If mmio_size is a size_t type, use format specifier %zx.
Align language of error message with kernel driver which prints "MMIO
region too small (%pr)\n".
I'm wondering if we should use kvm_err instead of pr_err.
