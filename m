Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5D138643E
	for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 21:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776202858; cv=pass; b=gEdZ2vVatnL4l2eKE3m+tvm9u+7OUDolOP9J+4NmM+fjgsiDrAkpcVqppOezmqgSTjjxgbqn2DDeWtji4Ft8Zp7SN6vLAqJIDoI7j2swoPCCconHKLYkcoS68++Mfn5PqPphRNX2A4WrALudjKnYUG79W9lAxQKZqei5ZebyaCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776202858; c=relaxed/simple;
	bh=kbQceU69YI8zlRogIjlJ0Jefj/2QvndFBDUyO3J/F8k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b87WAbg0p79DRq08fTMXbVQ1QEhKAsGIiOcKXAuhyqpMFd11tWq7jY84pSfzckYQpBkTWqNCp8NpW2RdZsbtbOywfrIvrTzYBY8VdklykuTDz18pnXSz9ynwyT3Cy6QyxSnbAjnWX/1+wWy4JtRWXra0YJK9ovNw48AUb056AI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jG3UHQyp; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jG3UHQyp"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8a016799d2cso67499626d6.1
        for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 14:40:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776202856; cv=none;
        d=google.com; s=arc-20240605;
        b=VwUBWQDxzESl8MKuqzx02pxDbm48O92mWB9oh5RlSqUnUyPyd1dx1T7HC3DTURXPJU
         e2uuKkRqSn7lzdKBMQP3pQ1PZ2me7gxKnl854VFf/5lTbmSmnSkf91GzEOMjBw6I2Sva
         erxC7qKs6GoXpIguta0K8au5KiCIBAocFk9UH7taElLYkU4hsco/JiwaNp2dA6h6Kr4/
         BbZQC0J+LSINebtpXJLvmr4KvF7vsVR7o4zZoBAGrDBjNhIII90u5Kypc6RWkW83eTlL
         6v2HVxT1+j+s5ZZIiMPKiSMCECIPnfbTJhyfqa+1RnA4JKD8LluQ+8uy6C4KSgMIX74U
         a0Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kbQceU69YI8zlRogIjlJ0Jefj/2QvndFBDUyO3J/F8k=;
        fh=bBBezMl/qJIRSK4w5BgsvwCe9CYXA+cDOB9lxGCqxJE=;
        b=VoC2tP/qzWKxstQQ5LwUiNQ9cqrKDUJBfT0IIpPVX4LMXtBIcV+dklEfe6iY88fzdL
         e7hG2xkXWN3SV46tNp+8JpH5rPv8ao4V566mSaK9zZTUtzBCf2b4V/0brr/ZIT2rxkDj
         lQH/7ZUH2/Snkjjfh1v0B7VFwnYdIEiArorwYLfVFD4SmN4eV3/zi3Ay/FUPoSmbDeIx
         y8OWdXcDFHHqUNuHVSPJTY90a7SK/EU2qZPEyNyTHwP+ok63I8hRDf0tQrVISZACWa8g
         Iczjg6IIT5xwXhuiCcivHRx491L6/Lq+h7F1kG/zb++RFDMuuNPv+znNs3PtEb7NFBDz
         a88g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776202856; x=1776807656; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kbQceU69YI8zlRogIjlJ0Jefj/2QvndFBDUyO3J/F8k=;
        b=jG3UHQypZYlKiCjJfKc4gig6/5zMv4494DfuFI2VUqeT9WzqZOTsBSfQJ3RzQncGPv
         SDPKkTVcuh0BdqPjs0ZBGWfnCe7KU8NhVC88i7L8sfFFXcsGj7t6ZLMsZwEIKhEj+iY3
         F+sY1ED+zxyZ2Jt0XvBN2rFmc4glgNoKsL+HCZ+z5ZTvBYQj9GKz0H9rI/5rqOPq6azO
         ae53QJNDr+osrA8Hu7O8piaAWzEjvqgJMeE6o8NhX2f6J60GSnEYD6qGwOs0H/sRsvYS
         vWvRZLbwNDCsLru3pE/ASxzh/O3bOe8UKbJ5lATLAUjZxM64olwuxNr2AYs08mmg5g/y
         zfpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776202856; x=1776807656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kbQceU69YI8zlRogIjlJ0Jefj/2QvndFBDUyO3J/F8k=;
        b=QoVM3rDGpR893W3X5Qv7JEdZcnn+DUymF/n/NOO9uEnRmULOeWagm2yB0T+ArtZVrR
         1Ey23/Ng/zQYXD7jbYlf4k2B4pKlzDyhI8WOH8ldu11ATr24lPfUs/j0zupyvZWpixV+
         h8tg+/ef16XEPoxHZw8hUOx8T0sOzS/67NwzmnQfxGPjT9KVm7XR6yIqe0ek4dSDkbh7
         8R5WKmzztV20iyqFUKWOlqndTOBT2Fua2DxVkhRnJENwIs90abS9+FE3i0yeLrgLxbsW
         3cw3vKJMliqMCgp0f3cCVt8epKfAB+6CUICg7ei8yVpAaGNxmdyQjFYug8QdIHeZt0bZ
         ZSew==
X-Forwarded-Encrypted: i=1; AFNElJ+3pNcyeH95ECKx2SXGAKCXiTQl/vfD+tQl49w9+DCTTxUo38FRKGfL4y4+uhwpEjh27zq6ukg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxkKLxC0tyE6RI9HY8/lxT+ZFAjwBTH8ehr6usSSU0o9766qfJc
	vFUiyh6UKpLDrVUnMYXH8opQz3xvu96thgHkl0QsjH9oW9ERv6nHn/kJzr8kOIZHTZ+FALhFd8F
	eWoW+3/iz5BuAGf2c2ZikBG/jru9ZgHe3Q6hI0+Fe
X-Gm-Gg: AeBDies+EGR5Hn4bJDmHGM5LaQQmqDmVlNWw3WrBwZXIb1Ekqt+7ssi+SlxqbuiKBHF
	+mXyydMWppGtp3URBkKUSkayvtmPAiA/DgUr5EbZbBIHAiPvMbwuFGDXiCylbULIotd9viOp7+A
	IXuoBD1ejZdFTGlQEypbNzv1ZEC16zWsOdeYGuMSADxRNt4kPUzbAMZKZi2tLU/otMAszFadVS/
	DOdc7H3xlTxWiYoXKig1Upn+CY5THcCfozqT6hEHXfb8wwAXJ8oSrcIYc59cxUVXpxysdVR7pRQ
	jSnbkMmYLY/b7zzaqVBNd2h2+z4=
X-Received: by 2002:a05:6214:c21:b0:8ac:7e8d:859b with SMTP id
 6a1803df08f44-8ac861b77f6mr303189226d6.16.1776202855012; Tue, 14 Apr 2026
 14:40:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260318155413.793430-1-steven.price@arm.com>
In-Reply-To: <20260318155413.793430-1-steven.price@arm.com>
From: Alper Gun <alpergun@google.com>
Date: Tue, 14 Apr 2026 14:40:43 -0700
X-Gm-Features: AQROBzAobYGs6qZALJkhuUvP32YWYfFdjJZKqlEWIdyyyT7N50O82BunKYW5J_Y
Message-ID: <CABpDEukEO4Y_fg8fv5Nr1_Pw_qOK=2UmioXk=WyPEzoEprPcGA@mail.gmail.com>
Subject: Re: [PATCH v13 00/48] arm64: Support for Arm CCA in KVM
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, 
	Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 18, 2026 at 8:54=E2=80=AFAM Steven Price <steven.price@arm.com>=
 wrote:
>
> This series adds support for running protected VMs using KVM under the
> Arm Confidential Compute Architecture (CCA).
>
> New major version number! This now targets RMM v2.0-bet0[1]. And unlike
> for Linux this represents a significant change.
>
> RMM v2.0 brings with it the ability to configure the RMM to have the
> same page size as the host (so no more RMM_PAGE_SIZE and dealing with
> granules being different from host pages). It also introduces range
> based APIs for many operations which should be more efficient and
> simplifies the code in places.
>
> The handling of the GIC has changed, so the system registers are used to
> pass the GIC state rather than memory. This means fewer changes to the
> KVM code as it looks much like a normal VM in this respect.
>
> And of course the new uAPI introduced in the previous v12 posting is
> retained so that also remains simplified compared to earlier postings.
>
> The RMM support for v2.0 is still early and so this series includes a
> few hacks to ease the integration. Of note are that there are some RMM
> v1.0 SMCs added to paper over areas where the RMM implementation isn't
> quite ready for v2.0, and "SROs" (see below) are deferred to the final
> patch in the series.
>
> The PMU in RMM v2.0 requires more handling on the RMM-side (and
> therefore simplifies the implementation on Linux), but this isn't quite
> ready yet. The Linux side is implemented (but untested).
>
> PSCI still requires the VMM to provide the "target" REC for operations
> that affect another vCPU. This is likely to change in a future version
> of the specification. There's also a desire to force PSCI to be handled
> in the VMM for realm guests - this isn't implemented yet as I'm waiting
> for the dust to settle on the RMM interface first.
>
> Stateful RMI Operations
> -----------------------
>
> The RMM v2.0 spec brings a new concept of Stateful RMI Operations (SROs)
> which allow the RMM to complete an operation over several SMC calls and
> requesting/returning memory to the host. This has the benefit of
> allowing interrupts to be handled in the middle of an operation (by
> returning to the host to handle the interrupt without completing the
> operation) and enables the RMM to dynamically allocate memory for
> internal tracking purposes. One example of this is RMI_REC_CREATE no
> longer needs "auxiliary granules" provided upfront but can request the
> memory needed during the RMI_REC_CREATE operation.
>
> There are a fairly large number of operations that are defined as SROs
> in the specification, but current both Linux and RMM only have support
> for RMI_REC_CREATE and RMI_REC_DESTROY. There a number of TODOs/FIXMEs
> in the code where support is missing.
>
> Given the early stage support for this, the SRO handling is all confined
> to the final patch. This patch can be dropped to return to a pre-SRO
> state (albeit a mixture of RMM v1.0 and v2.0 APIs) for testing purposes.
>
> A future posting will reorder the series to move the generic SRO support
> to an early patch and will implement the proper support for this in all
> RMI SMCs.
>
> One aspect of SROs which is not yet well captured is that in some
> circumstances the Linux kernel will need to call an SRO call in a
> context where memory allocation is restricted (e.g. because a spinlock
> is held). In this case the intention is that the SRO will be cancelled,
> the spinlock dropped so the memory allocation can be completed, and then
> the SRO restarted (obviously after rechecking the state that the
> spinlock was protecting). For this reason the code stores the memory
> allocations within a struct rmi_sro_state object - see the final patch
> for more details.
>
> This series is based on v7.0-rc1. It is also available as a git
> repository:
>
> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v13
>
>

Hi Steven,

I have a question regarding host kexec and kdump scenarios, and
whether there is any plan to make them work in this initial series.

Intel TDX and AMD SEV-SNP both have a firmware shutdown command that
is invoked during the kexec or panic code paths to safely bypass
hardware memory protections and boot into the new kernel. As far as
I know, there is no similar global teardown command available for
the RMM.

What is the roadmap for supporting both general kexec and
more specifically kdump (panic) scenarios with CCA?

Thanks,
Alper
