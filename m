Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7409A3126D7
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 18:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772474868; cv=pass; b=AXdwN/phpbTo0fJ46rTJwaRVZxKq5e4Tp0UPHEnXfyQNGxc0klYNU4EsmZsJcBN9JRd6MW+dQ1RJs0hxuZxxcN2xVo/Anx8sbRvTbepelpq9Gymq1okeLYftuApgHBJT5a2DmEAhfoP3FbGzYvbbyPXy25Y+tj2fK0GHPxYH61U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772474868; c=relaxed/simple;
	bh=0imvWNeJKWcjp5hoFkbKFcf2HTBzQFgJ9fHGuyG9jDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cNiu1m9uuqvGPoMtg9+rZFD0dlRIYK0adGHbSWozYAAJ/rt4KfOaEryhQT9y3XG1nAs2HVtONOj8RhUguPFekphJId/SQlwNeaqdHtmBvgQSTej+nRm3odd42N+se8ClgUmmEhC9B91GofGGEfBQWiT3EglWbVOwLcNy9g5dgZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1rPUPyCy; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1rPUPyCy"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-505d3baf1a7so17281cf.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Mar 2026 10:07:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772474866; cv=none;
        d=google.com; s=arc-20240605;
        b=IgfLBM0+cH8nDbXxMdR9AGPAZHBT3+Sts4CdIFdqrfwZD8s+xY3ulTJRo4jvgchrz9
         i9ezJvLzMmKEG8yBw6YVHPfn2esDK+bKImW2pX+w7Bd49iA5q1L9aFCDLiHEUytACS1B
         vsMt2zFiWDyJy0L/bom3Kz2iJQyQnYkZf6siSOrlefK1BPy+LoSUdBLoNz0otuK5wgW6
         MToNFYnEh1sTnX+aIzS62LUKtfw+DpAHjrL9vJg4x1QfNLEsWwNe5zzkGuqMHc2tPxQF
         +gVWYinxT00OlVNID9ukc0186xSxUkOMaXl9h2tO0/6yLjOX/0Sq33J2lQSt5FJ9vX+y
         W1nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=g5L7HOH+qGHmUa2TQzLnS5V8xHXQs5WAMIno5lumxs0=;
        fh=KToBVAgQhC3Px9jyFf7rMYhpQ5QYuOm7dMoJWRu3vds=;
        b=j/+FhHZCRgak9Qux9nyJQNonFqI7NdNNIncfyYOPQwYiTciHf2KWDy/YVfcyAgNOO2
         J3E6balt3e5RAbX4aCLcXEyAGR/KqE3N9P7wfyybwSOJK9GEUmvlngyv1KzfqJ+n36aP
         rIA3b+feVq1KGYcCcJHoke9vRUJwJ+H7A64hazumU6owUv3YyLLgDgrX6pmLGMlQsD88
         2OzFjLrDOI81QnqFOlH4/0c3YSY22u5/E3LiW8mhHyvpibgCIsX8k+2jBDexbnEzer3z
         sP3pnZ70KlN2X4Ae5eIb18K3t2TKBZmquCacxY8ZY0pvlPROPgD3hYfvLk9g9hb8WVD0
         3x0g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772474866; x=1773079666; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=g5L7HOH+qGHmUa2TQzLnS5V8xHXQs5WAMIno5lumxs0=;
        b=1rPUPyCyQKDCePEmM+TzOA8cBLslOLOoo3baOtVvuyYo+0nHKl9R9elyBvjhsl4aIu
         Ivypvf/dI8OQbGV4SB/70hte0dT2Y8asuFCH2xoH2akPJtJ8CECVVRvhg639V4f8Ge0q
         XQ86ZMAmVZp4URx2zElXHFC/EHtRQtEudHoP+TmRJEoHsxb3Xzp/aAm36V5JN6Wug3KM
         IHlwT6D1jOqSwewPyTZG3pEGZkqKlpb0QVduMXjk7YXOoWC4yws3Fxq3iBD+3nIL36Au
         Ebo7qFg/y2BU3DhQMqzpu6+W9ETFd49vgQspfxSaurUtMbPqENApXE2myI+w1G5yq78+
         YI9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772474866; x=1773079666;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g5L7HOH+qGHmUa2TQzLnS5V8xHXQs5WAMIno5lumxs0=;
        b=fNexFknqmfQqNFkm05uTAnQ1tkAm6UPVkt6l4N9ahutExKMum1VtnHyi7DSaMSP+Py
         8opyn15l0NEk9TsZ13ibk3gIIRf1Kcb8BUz8i/Exhd77/e7+7mLscxlzH5qgyPQIQNA9
         zNONqoLcVmo2P2hb0fj9Mqy9wjCU8uBDWTaskF3cUM/t0aydCRWQqOXYlXI/HB5R2LHW
         sdLNvfK+dtamXvZjQPPMoG8Ds06Lw4tGdPvRNk78oKrhhM9wCB5l1I+TfRA2zXpL0MqD
         S3PbtaZ51D18HM6BTgTFlcnxk4u1tfrVxFU0sdDPpr+Rx/sGjFKypRHw3UaGnAfeuxQ7
         md7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUwAkA3Wk1ALfkoXHgfec4TZrMhZa/zfd1k+2T0j29UmTAr0F2EbvA321LRohhsvFV09s1Xa3Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx00C/ZmxmdaXSz/zTGAWT73Z0cJW4okncsRrktnab1P6xQ1MGW
	cnlQa1ybfOKw6nNnplOnGFlx4/iIyyVhxb8HfjjFq6m8lkbFr3mfzK9GFDYTt8DDi+KpsAJ/C47
	Z+ivLdpb5WkrooN+ft/Kc9FMbABvSHtruXx8YAYQc
X-Gm-Gg: ATEYQzxGSluekwL7VB1L5vAqOFurRkjOXlZnLfpiEnVOfyBEvT3gLe4L7AjXBeAo40J
	UeZqITNAKUIqkIWPoAp5DLW6kRMYqFSwuhdM1GmyoG1qzCbG5v5ZJxes6Pq/GfwC8CXHgsv9+T4
	kVR6ypXHw+TVWOlSewMz5rYyF4suid+1kvVtN2M/Yo6VGZ0PmSDlNAzaolmKmxAWtb4GI0LNIXM
	zVGsDB0P1gK9DjkeFetjoIWsSvP7Hm+7s3fMevF756ZNUzCvyc2aPIKiWoLgAbr/oR7XNkZWqfq
	Yb8doReR
X-Received: by 2002:ac8:5995:0:b0:4ff:cb72:7c03 with SMTP id
 d75a77b69052e-507617532dcmr23954281cf.3.1772474864882; Mon, 02 Mar 2026
 10:07:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260302115653.1517326-1-maz@kernel.org>
In-Reply-To: <20260302115653.1517326-1-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Mar 2026 18:07:07 +0000
X-Gm-Features: AaiRm53f0ov5VDjDbU0EYarSY2nR7SD28ese3HWFZAeLmItAD8SpdFlW8YjuVQQ
Message-ID: <CA+EHjTxgfarNCipjYwfEp1fyF6oicxDw2_tbAQ9JNAjM90w6rQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] arm64: Fully disable configured-out features
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 2 Mar 2026 at 11:57, Marc Zyngier <maz@kernel.org> wrote:
>
> This is v2 of this series attempting at making the handling of
> features that are disabled at compile time a bit less awkward for
> non-userspace consumers of the sanitised feature bits.
>
> A few things have changed, thanks to Fuad and Suzuki spending time on
> reviewing this, but the overall behaviour is the same.
>
> * From v1 [1]:
>
>   - Mark ALL_HIDDEN and HIGHER_SAFE as incompatible
>
>   - Don't update a feature that is ALL_HIDDEN (or overridden) on the
>     secondary boot path
>
>   - Reduce the size of struct arm64_ftr_bits
>
>   - Add a helper for setting a field to its safe value
>
> [1] https://lore.kernel.org/r/20260219195533.2455736-1-maz@kernel.org

For the series:
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad





>
> Marc Zyngier (11):
>   arm64: Skip update of an idreg field affected by an override
>   arm64: Add a helper setting a feature field to its safe value
>   arm64: Add logic to fully remove features from sanitised id registers
>   arm64: Convert CONFIG_ARM64_PTR_AUTH to FTR_CONFIG()
>   arm64: Convert CONFIG_ARM64_SVE to FTR_CONFIG()
>   arm64: Convert CONFIG_ARM64_SME to FTR_CONFIG()
>   arm64: Convert CONFIG_ARM64_GCS to FTR_CONFIG()
>   arm64: Convert CONFIG_ARM64_MTE to FTR_CONFIG()
>   arm64: Convert CONFIG_ARM64_POE to FTR_CONFIG()
>   arm64: Convert CONFIG_ARM64_BTI to FTR_CONFIG()
>   arm64: Remove FTR_VISIBLE_IF_IS_ENABLED()
>
>  arch/arm64/include/asm/cpufeature.h |  15 +--
>  arch/arm64/kernel/cpufeature.c      | 141 +++++++++++++++++-----------
>  2 files changed, 94 insertions(+), 62 deletions(-)
>
> --
> 2.47.3
>
