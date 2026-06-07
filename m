Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087AA18FC80
	for <kvmarm@lists.linux.dev>; Sun,  7 Jun 2026 07:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780815965; cv=pass; b=hLxN7DSdyScYtVJ78NeOzy1eCZhTNOloQVK8XSs4j7FTS7KCD4O5QTRVDEC92p4nN+IuArWDBEp86HkmVRCJnCnlUXmALtNcKJLZjLqL97HSLdXx3TIfPf2dEN53svOL62DEkB79wYQUOQUfI0AwsO6HGiaNfMU3o1bnrtuWjRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780815965; c=relaxed/simple;
	bh=mUdV0DhC//w8Ri1SkoNj46XOQCm6jOMYkSM/1+jIZmg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dddj83dMGfvRl5oIb+IBUZMKrAGryIZ4bQldd3iFkQQYrYRUklsWIc061TATeckSUdsRSKOnZFZ0xaRVbzpKQAhrRR07fBEKtPoKIPWVZjzRaWZJD0we6+t994MFJrOOf9HInJ2E6wdfRi4kNxHplrgq4goZbJWPRIMEaCDF6F8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L2EphHop; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L2EphHop"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5177d1ff061so1077041cf.1
        for <kvmarm@lists.linux.dev>; Sun, 07 Jun 2026 00:06:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780815963; cv=none;
        d=google.com; s=arc-20240605;
        b=WbVud2HDASaENKKv6PBwG6fQhy6CmLMm6Xa8GGFzHnp2meqghqwAWlBIXesH5HSFTU
         3h6/WkojQh3JjGhio/AIq7VtDLJnMAhGkHbX0RthD5K4kBjmY4t1Qp7Rqk7isF4AjjLb
         L5Qn17JB/t8yCl2I5vfN1ite6rrROFJbn87jm9PDMgWKXCABwUeDGMgDokTUgotAy4az
         UX4Sx32lUigK02O8YywLEfj3g8LJBL8/gprzJtsb51v8xf00GYev/xqEYUCCDWzWHo5y
         hlEme+jVvm7m2So/CUPiIB6HMKDnCPpbPdaXQCh+3tTYEJ1ic/HSq33+tqf7cO/MbVed
         +Gbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=uT5ydn+EqJZsAMkKj0fC6IolXW7qV5RfXWPNY69Zc+Y=;
        fh=wCyvaLyspbrGKFyVZpMf+y+X6jegAcyn3B7+rJNTPtM=;
        b=kJGJ5a8WYn9BbsltBbzkOdTVxL1UlygO44IUWg/VUozvYRhu+SDBeOF3XfK2QXjpIv
         Q1WiO47ZKmwD1PbUvQ0jelSVOgND+LcspnxvCSFhkoweZa7uuqLOcOEym8d7YdkhlACj
         kZf2Y7isIzxpFDqHZYSK0WlprIks5nrupLJzF7O/MS1BXHQxO3xWEBhUtrSqZzgxlYRo
         P8Nc88ySMQzEH80kcgK6j5bGjRdvN4Nt1f8LU+sm4TmPtHIBexCSHHpu4FNtvamvuQbm
         TFXHuZe1YyLsRwcCv2ukoEK/Zb/vR5czxKy4yd9sxwxfvx3SKeAnl14UgeXk1ud+K9lm
         oZVQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780815963; x=1781420763; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uT5ydn+EqJZsAMkKj0fC6IolXW7qV5RfXWPNY69Zc+Y=;
        b=L2EphHopexm5z5rbRsTD/0hcuxFCZTNPpLMWn+VwXExulWWW4/goEfFFKWZR232don
         k+8cgUh/IbVoC/VIWodqMZGcJdYsRrq7Z5X9MTvMl5jBzdv4U0KCxC954QHgJm47VYRW
         wA9us6UKBoxgdeGO75+ifANK2ueuoHi7NRK9Ufh9ua7ipRNbMarctorj0q+xUpE6z13H
         kVJzbMbswb/K5hfJeApcfdSGJbFuJtHEosDrATVKL8Huyp8e6R/5tkLoYhhNFYyQqZeY
         ModknQdup2uNlukO62BbWJdEzdHA7XcCA+s2/os+d//mPol6expXIi/CLJqV/yWI6Fhu
         Jehw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780815963; x=1781420763;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uT5ydn+EqJZsAMkKj0fC6IolXW7qV5RfXWPNY69Zc+Y=;
        b=tXXY0UBl9VsRVf5fPkCiMALCNTJ0/YtIh+yk05SBaEiFPfZPmVysccyRCvYwIE0ROe
         G1QbNxckGwoEQdlHv+edK8WYqBOK1v99b4gdQBZiszKqah5KJd6pPo8LALOHctGx9bhb
         acTIdfSy39O/bQynYBmCewcI5EHBnrQO0nHeHLH2WUMprPalJ73UJrbXmoS4d9E2s+Cn
         HQoFlczd2ZnLq/mUtdoEo5asS8ezlvRU9ITrdkiQRM3xLDVfmtd3QslW4OjNPhCaQx3f
         tHRVxp4CxgAPfHFoCX06mfd3UEqiW4MEOphWERyiQv2C8M6lJWIUF36l3nGN6FrYlswJ
         Lpng==
X-Forwarded-Encrypted: i=1; AFNElJ/f29NTIfgcDbBxTRiofGelvfekc5LP0vN5mJ+HbQWckImGbuY36wv8roCjlUj0Vg5VO8sd0es=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLOIN2diaqF9imAvqUfUZsdJQ8S51DKUyK8Vsm7puRTjAJPClb
	HPqpuT+Z71VJEFUKlW3jroZJdjWsE32XTJ9QHo1iXkTAUcw2UzXooglJ6ubk82/Op4Qm/hDBriI
	cul05qCZaDbU68NWZAJJxTERzO5km58Jp94UM768V
X-Gm-Gg: Acq92OEOsHTdb1jmXSkPdyLkfk0OXXukEHQtejm9/NePVSfOb5JLL17D0CA/MfTyzyX
	HpLgK8FydgcWVXeD+Hw0ZZMlBHTuDE/tDXRHIkM4jRBp83AXAKEODlSJZJ9DK9ImznoA9xWYQkF
	daK0yi0yLLaox8T5f80eJgbHx5RMBRQQrXXz2JxuM4TZVlJ/jgQ96X6zlb7/FSTlZ1Ot/R2VXrw
	Sf6ZTvzXfelqjPkmjYg2TOfoDPbjAlgGpy9kH4gDmMPjpcuPs26zXU/4+tzNP8qx3CxuRnciZeW
	E5zD+6rM+OwSdkPk2HA=
X-Received: by 2002:a05:622a:6d01:10b0:50f:b69a:f4a8 with SMTP id
 d75a77b69052e-5179806b242mr16836941cf.7.1780815962364; Sun, 07 Jun 2026
 00:06:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260606175614.83273-1-imv4bel@gmail.com>
In-Reply-To: <20260606175614.83273-1-imv4bel@gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 7 Jun 2026 08:05:25 +0100
X-Gm-Features: AVVi8CdRhmH9BYOsHsmFgRsg2rtea41QIta7Nrzuj5tjiY1ErqsUXnoxLXLi0HA
Message-ID: <CA+EHjTxSsPvT11WRUJ5hRS7c6xNwmKK2ZbU_mCcBLBqdFM=xNw@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] KVM: arm64: Sanitise host vCPU fields copied in flush_hyp_vcpu()
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 6 Jun 2026 at 18:57, Hyunwoo Kim <imv4bel@gmail.com> wrote:
>
> flush_hyp_vcpu() copies the host vCPU context and vGIC state into the
> hyp's private vCPU on every run. This series sanitises two fields that
> it currently copies verbatim (host -> EL2): __hyp_running_vcpu is
> cleared in the guest context, and used_lrs is bounded by the number of
> implemented list registers.

From my side I think you've addressed Marc's feedback. For the latest series:

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>
> Changes in v3:
> - 2/2: replicate kvm_vgic_global_state.nr_lr into hyp_gicv3_nr_lr
>   once at init (guarded by gicv3_cpuif), instead of reading
>   ICH_VTR_EL2 on every entry behind a gicv3_cpuif gate. (Marc)
> - v2: https://lore.kernel.org/all/20260604151210.1304051-1-imv4bel@gmail.com/
>
> Changes in v2:
> - split into two patches, one per field, per review.
> - v1: https://lore.kernel.org/all/aiFe-CXo-XVTFz1g@v4bel/
>
> Hyunwoo Kim (2):
>   KVM: arm64: Clear __hyp_running_vcpu when flushing the pKVM hyp vCPU
>   KVM: arm64: Bound used_lrs when flushing the pKVM hyp vCPU
>
>  arch/arm64/include/asm/kvm_hyp.h   |  1 +
>  arch/arm64/kvm/arm.c               |  2 ++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 12 ++++++++++++
>  3 files changed, 15 insertions(+)
>
> --
> 2.43.0
>
