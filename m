Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED22489FA5
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 17:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790875395; cv=none; b=nG6yW+TYAZ0wutwcin73IRuatAhjOBVQ81zKRkxf6CaXs9zagT5YHGe831rlM7CYCCVl5Q/adcTw54vUR7ZxPwA3zvX/tesBKQpSudRs/DBxqbVwoL+vBqlWfrRJfQ56qbF/3lrvzEqZaDLvq6q+3GonLt8IaCZXdPEzxZy1bkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790875395; c=relaxed/simple;
	bh=u5/HMj3CdChqx/OnjqHNwMZ4vGC0r+b7BgrrwRCt8O8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nIIDvio0nSKyaB1/dqT+j3WwbsuBrSvsHnOTZfTijcmZo/oGPzD8t/K3DDhpHFMYwuzDFuddp9CODzVuoduJQSUWFY3/UabQzwAz84JX2ahFIt0vKHL9AfGVX+kinMDPxK/q5Q4yrV/Rd1jEGGOe3kucZ8q2UpPVZ5YoXTvzM48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LsgpwmtM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LsgpwmtM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790875392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5SoYEmzKElkGom7H29Ym98qwP5JJ7+ldvMW5qXiXXtg=;
	b=LsgpwmtMI1Lv672MhpWZfopSZhOju/RgD7DWQsdVJvKOXfjgzE4QquoGGBAEokosbPblIP
	STmDxvxqgHQhNDH8Li6yhhI21bWoHeGWbi62dJA80G889U9trr/NoyOnTrBEZu9tKwhLI0
	XHBkwLm3SfEW7wXVKTG7CoU+9NAMu38=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-FGu9FaXmPTKW1-UaOhS1SQ-1; Thu, 01 Oct 2026 13:23:10 -0400
X-MC-Unique: FGu9FaXmPTKW1-UaOhS1SQ-1
X-Mimecast-MFC-AGG-ID: FGu9FaXmPTKW1-UaOhS1SQ_1790875390
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48af4a0bd0fso1799730f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 10:23:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790875390; x=1791480190;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5SoYEmzKElkGom7H29Ym98qwP5JJ7+ldvMW5qXiXXtg=;
        b=NBeBMnawMP+gXahbvw1XM8NeWTJyTWP4njU3Pfc+iArR4l5BdRY/quvM94753+1c6e
         9MTJO7UPvB9nHbc5ytSfFo+cClBaUckQN0y4XPMbqWftx7fcOATQlVSMcSk+14H9G2zT
         9vz++lVbBlOCWwQQXODHQvAwxMA5OPzuPEUqn2D9uef+j8xVZNVgRIQ0zMh9HJ/prGEG
         pxNQChy5MwQPtGY0rd1Q8f0Wd01gvIJJ/DpeExYg5eRV0peZyyfaet61wMzyOoNN1FJC
         mepHnktUqHrb/p2cuCdXlACRik0qNExTMl1YnUno7SFxICZvqq2uoQFLxzY0TqW9vGFi
         GHtQ==
X-Forwarded-Encrypted: i=1; AKwUvBxyLgmmnCleRHID0GLiUj+HAE7aQNbZpkJaYTOCJ4BLeJUAJDI8xPy8oRFXrQfbQ2c8KF89Pls=@lists.linux.dev
X-Gm-Message-State: AFq9FYIEYQ6mh7AYbAnqR49gkUL6Q6WAxbY3WTQkaWt+sJMkgoDOlJ18
	KGTNgrgru7ll9GohBAmjpgZf1KcOdB3XMaTjzriI7yNuwC1PPSiB91pAcUaCGgDnj6yVDC5UZQp
	UbiHBPhrC7vpaQIj7/D5f0Ezxz4W0ZlMjt9k2QWT/tU9HBdjghs7tmw+ckU6L7+hfvWxK2tPFk8
	WSaxdEtcyfy7MZ1DjSAwA4TAqCSBd/bHdRvUxjyPSl
X-Gm-Gg: AYBFou1rhCHloLOKo84g3/JQiIqfv2IaKL6QDpbHSYJy9uGfOhwiUSqbvtxY1+eVQmP
	Ny+pHMutWDlrw6/LPREe74y7XbQbxinYrGPSPacI/T4ibx5K7rmZBcc/ntpVSvJQlURXx5DX3Py
	rWNwAzVb6h0Q/oXJSnSszIGQ2mV58b0SdjGlMRz2sf0sciQfdrsK2Sr0Z9du3GyElO5vjvG184G
	VY6pbpMD+Qo+cGiaz0f30mXDLuG6FyIwH3Z8mio6gpTl1jdiN7t/fBvOu8=
X-Received: by 2002:adf:f584:0:b0:488:8352:cbfd with SMTP id ffacd0b85a97d-48b1275c0bamr297594f8f.46.1790875389661;
        Thu, 01 Oct 2026 10:23:09 -0700 (PDT)
X-Received: by 2002:adf:f584:0:b0:488:8352:cbfd with SMTP id
 ffacd0b85a97d-48b1275c0bamr297572f8f.46.1790875389262; Thu, 01 Oct 2026
 10:23:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ar4HJw9zON0mG2_t@kernel.org>
In-Reply-To: <ar4HJw9zON0mG2_t@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 1 Oct 2026 19:22:55 +0200
X-Gm-Features: AclHuK-JbEz6Qj_Cdd61kEB-q91RWVXCa2Z9BMHFYGHf6lD5dkvwRUXQ_AoHM8M
Message-ID: <CABgObfZhmJsjciLG7U2DVmRtzL0nHnqytnRwEoava9-sCT=TUA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 changes for 7.3, take #3
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: I7O9Y8iXXycHGMVrecmqQasTMT32OGpGbVpFiwR-VOE_1790875390
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 1, 2026 at 9:09=E2=80=AFAM Oliver Upton <oupton@kernel.org> wro=
te:
>
> Hi Paolo,
>
> As promised, the patches I was waiting on have baked and we have another
> batch of fixes for 7.3. Continuing with the trend, the VGIC is getting
> some additional attention, particularly on the handling of a vCPU's AP
> list.
>
> Unless there's something truly horrible brewing in the next couple of
> weeks, I expect this to be the last fixes pull for 7.3 with Marc taking
> over the tree for 7.4.

Thanks, pulled and sent to Linus.

Paolo

> Please pull.
>
> Thanks,
> Oliver
>
> The following changes since commit bc502b86a3cfd89e6740f877c90d06b0263593=
5d:
>
>   KVM: arm64: Use stage-1 leaf size for VM_PFNMAP (2026-09-30 11:03:16 -0=
700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags=
/kvmarm-fixes-7.3-2
>
> for you to fetch changes up to bc502b86a3cfd89e6740f877c90d06b02635935d:
>
>   KVM: arm64: Use stage-1 leaf size for VM_PFNMAP (2026-09-30 11:03:16 -0=
700)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 7.3, round #2
>
>  - Take a reference on the last IRQ loaded into an LR to prevent it
>    from being freed while running the guest (Marc Zyngier)
>
>  - Ensure that the ITS MOVALL command only affects LPIs that were
>    previously affined to the source redistributor (Marc Zyngier)
>
>  - Fix + test for honoring the host's trap configuration when running
>    non-protected VMs while KVM is in protected mode (Fuad Tabba)
>
>  - Use the host stage-1 mapping granularity for VM_PFNMAP mappings at
>    stage-2 (Mostafa Saleh)
>
> ----------------------------------------------------------------
>

