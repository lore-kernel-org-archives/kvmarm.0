Received: from mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5204ABBD4
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 10:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792405043; cv=none; b=cuYHBBi6Lyp0mF4I7y2Iwn/CbbrPFQUP/28ZslHYkS6Vh7Vr5k3KRrM7Soyrrz9fRzdMnfReh6QUEtK9HHjJ6knRDR9FjqM03jGI7XwZc8pT9GRILc++vmcvdcMV7khEomAPV7SYEIvcw/DxpKz+IRqxbqxM1CSH7sgU6h2If9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792405043; c=relaxed/simple;
	bh=KdQ/3IzDpxWKftV/qYr7+DV/cqjN/ThlNSDqwOiouKk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GiUcxlEnJMc40Q7cKuvlzpIuwhZf86SZG1V+YWDmZs+6qqNwi/EgMyp4TNxpZvB9fgUqGdWSCQQCI+gzVGLUs9h2ekilPzQmLC/9B95qKXMkEUpEt4P3ZRkMc/5cJKz2AbjE9qTFYDaGBhO24kcKYs6D8w2KMEhxvvIn9wkfkHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ART2+/bD; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ART2+/bD"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=KdQ/3IzDpxWKftV/qYr7+DV/cqjN/ThlNSDqwOiouKk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792405038; v=1; x=1793009838;
 b=ART2+/bDSb0LrYg9w0QI5K9Rsnd94FZD7twfH+aE51sVQnLNcI9wuz1Pd4C0lMOuJuBdVcde
 qHlCzK/UPu+62q4cRxi54gq1E6082Z42Xm84hgtRIKB+YSI9lQco8zyAwERoZAxzL0tHu5HPr7o
 lQVUoZgwOrqaiLlmwJfhpNbI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 878428a0f9ad4601;
	Mon, 19 Oct 2026 10:17:18 +0000
X-Mizu-Trace-ID: 878428a0f9ad4601
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so8815e87.0
        for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 03:17:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz9tLlZvomH7zg6wB5eWX8N2q1kNG0KdndweW8ipc24J7ItuK5AFgufj1+WUgnhJh53VOcc3yo=@lists.linux.dev
X-Gm-Message-State: AFq9FYLC9S5oSt2t6lyxl3CmbtasoH3eRJK6DGpAAaGt9S67KyojK/hl
	sfIRglCMMHwhGRj/fDTFoCE30QhHQNV1os2BnUBBPqXSFKyUIgRn7RNniZAQ7mNyOmppfH1ReZN
	GaLmLkI+QoWki9jdqDh9x63MgGY1Zv1G/slh0dt4/
X-Received: by 2002:a05:6512:138a:b0:5bc:fbf6:2352 with SMTP id
 2adb3069b0e04-5be50d346f3mr193361e87.9.1792405036691; Mon, 19 Oct 2026
 03:17:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261019094258.1582756-1-vdonnefort@google.com>
In-Reply-To: <20261019094258.1582756-1-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 19 Oct 2026 11:16:40 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwMTV2-1qmHUbbnUQk54ig0kVaEAPZ8L4rz3Gg4ADH5yg@mail.gmail.com>
X-Gm-Features: AclHuK_G42tgIMfzYh22d9IE2leJ-o_hibjpBEstZjEbaxYU5LOvkaF0YazawcQ
Message-ID: <CA+EHjTwMTV2-1qmHUbbnUQk54ig0kVaEAPZ8L4rz3Gg4ADH5yg@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: Move pkvm_selftests() after all CPUs have
 initialized EL2
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 19 Oct 2026 at 10:43, 'Vincent Donnefort' via kernel-team
<kernel-team@android.com> wrote:
>
> init_subsystems() installs the hyp vector on all CPUs. By running
> pkvm_selftests() in init_hyp_mode(), there's a risk for a migration to a
> CPU where the hyp stub is still in place which would fail to run one of
> the HVCs necessary for the selftest.
>
> While init_subsystems() is the earliest we can call pkvm_selftests(),
> move it to finalize_pkvm() to avoid having to export the selftest
> function out of pkvm.c.
>
> Fixes: bd93068340e9 ("KVM: arm64: Add selftests for the pKVM heap allocator")
> Reported-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
