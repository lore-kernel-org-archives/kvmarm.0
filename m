Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB908223703
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 12:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733748574; cv=none; b=mkcWM75vhdPb143xSmbR/jjtMwKMV9REajiqlHr2eHzpzRS7/7EmrAn0nt7114aKlq3JljAMDhz4uBFjsoAZRHi0IVY0MJtxbRdZVF7Hf6aqutQb0EYf7rN7hxTycFZ0SCvlBpRxtcXfXK1PDFvFHwf8o+rj+XxK/bB4fNtsj1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733748574; c=relaxed/simple;
	bh=pBBi08egI5C82g59wGFzjZR7++PR94Pl8enhZtx2LWc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FxIlaQ+5lKCfsIuKHcRfnDZZvxxIqRdLvHYAcFWwfm15d+gk/AIpHoDJCp8xt5P0uN9e8Tnary8LKV7rby0OAP5Q5EeXN/TohW9ydjk9NdY4QYrJxS8iv06XDsyhDW8m4tmqtVPlVV5dv/SNqx0xJleV+tD+gu0bbwkCfLs2bcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FIsmOsVU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FIsmOsVU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733748570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z+XKr+p6+d0vsEOub5KNiYEX8dUurRREKoGxPw+GDFI=;
	b=FIsmOsVUM+QCsy1N74XosjgqkHRFUq570nE88fvx82J82x03R2dMcLVzOJUzaLqE4e7IIM
	y4H7MHqnB74s/ZlARn4txzpl1qBOv1DTPM392LDDKtOps7D00o2NyZfUrXJ0ATStu+Ouzn
	y5VApM9wYYL6iZvJKlLIdtuMo0UZBhw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-435-bTSuDVTEMgyIdvo-oQugcg-1; Mon,
 09 Dec 2024 07:49:25 -0500
X-MC-Unique: bTSuDVTEMgyIdvo-oQugcg-1
X-Mimecast-MFC-AGG-ID: bTSuDVTEMgyIdvo-oQugcg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31C661955DCA;
	Mon,  9 Dec 2024 12:49:22 +0000 (UTC)
Received: from localhost (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9627195605A;
	Mon,  9 Dec 2024 12:49:19 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 eric.auger@redhat.com, yuzenghui@huawei.com, wangzhou1@hisilicon.com,
 jiangkunkun@huawei.com, jonathan.cameron@huawei.com,
 anthony.jebson@huawei.com, linux-arm-kernel@lists.infradead.org,
 linuxarm@huawei.com
Subject: Re: [PATCH v3 3/3] arm64: paravirt: Enable errata based on
 implementation CPUs
In-Reply-To: <20241209115311.40496-4-shameerali.kolothum.thodi@huawei.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241209115311.40496-1-shameerali.kolothum.thodi@huawei.com>
 <20241209115311.40496-4-shameerali.kolothum.thodi@huawei.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 09 Dec 2024 13:49:16 +0100
Message-ID: <875xnt10oj.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R_MkIfUMmwwmUkpv7WU-3m_pCNVzWZOrpk-pVBddgGs_1733748563
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Mon, Dec 09 2024, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> Retrieve any migration target implementation CPUs using the hypercall
> and enable associated errata.
>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
> Note:
>
> One thing I am not sure here is how to handle the hypercall error.
> Do we need to fail the Guest boot or just carry on without any
> target implementation CPU support? At the moment it just carries on.
>
> Thanks,
> Shameer
> ---
>  arch/arm64/include/asm/cputype.h  | 25 +++++++++++++++++++++++--
>  arch/arm64/include/asm/paravirt.h |  3 +++
>  arch/arm64/kernel/cpu_errata.c    | 20 +++++++++++++++++---
>  arch/arm64/kernel/cpufeature.c    |  2 ++
>  arch/arm64/kernel/image-vars.h    |  2 ++
>  arch/arm64/kernel/paravirt.c      | 31 +++++++++++++++++++++++++++++++
>  6 files changed, 78 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
> index dcf0e1ce892d..9e466f3ae9c6 100644
> --- a/arch/arm64/include/asm/cputype.h
> +++ b/arch/arm64/include/asm/cputype.h
> @@ -265,6 +265,16 @@ struct midr_range {
>  #define MIDR_REV(m, v, r) MIDR_RANGE(m, v, r, v, r)
>  #define MIDR_ALL_VERSIONS(m) MIDR_RANGE(m, 0, 0, 0xf, 0xf)
>  
> +#define MAX_TARGET_IMPL_CPUS 64
> +
> +struct target_impl_cpu {
> +	u32 midr;
> +	u32 revidr;
> +};

Doesn't this need to be u64 for both (even if the upper bits for
MIDR_EL1 are reserved?)

