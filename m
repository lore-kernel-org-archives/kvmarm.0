Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDB93AA1AE
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 08:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778833892; cv=pass; b=glVB4AeAXM8BnSVO2NepJzM1aHrsLQ1+StmRchzECUzo3jJaKZNWM+lwrO/8J0wI/li8qKy3ogC5AVdAme+9a3Il0z1BDBHQItHvQzMVNq1rSZSy6Ga/PKk/jUy90xdABoycVMS5Am+q8HcGnUflwZco/L+7ig8HaJk9Ia1MWFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778833892; c=relaxed/simple;
	bh=alzfgz1aXCJLqugLm78Sp8WFGjGW5XBGx/1DQ0VOqWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QjYuLNp+f2EI6K9qrtc9uURnnVYTG0pW/lqlzqSBnRUfop8K6XJG4YuHfpetzoOzb+5OTPVNJmqPZGPfi5BqnfVp7fYIQh62HSPBuQjVF/eRbg+y3RDOLdNni4uu2/HJU7U+1j8ktd8POWPA1dVMGjCUMxIpndyimRoTiZZEi94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ipLa2W0U; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ipLa2W0U"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-65318dafbcbso11594212d50.2
        for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 01:31:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778833890; cv=none;
        d=google.com; s=arc-20240605;
        b=JckmcINyFqBux09A3lpUMvkoKPmunJjOSyofIO65HiqNAGeNvvEUqHBk2CP2KPB3n3
         rVIpvHiCTRiMjBQoBw6xUNiTNilXrI8encJB+16N9hPVHLA1VJNFoxptWE1OVsSM+0XN
         +42a23c56yZhZm6u6TgSP8l6LdgN9Q3U7Dvy8xmCgoHjeJPVPIMbtAFTEcTrNfpHlJUL
         qfdNfAgerRMEcsmQTCUaoeYNq1rpiajN/++9/uVuSstPEFngLIC8XGNSruVYKhtN9TCg
         IaM2NkcDdjD4O0+YFpAZiiHSuTZl1hYvNn24vP5XS8FbAlCbex09AtnfUfX5wfiPdyKC
         N1gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=alzfgz1aXCJLqugLm78Sp8WFGjGW5XBGx/1DQ0VOqWk=;
        fh=O9XHO9qOphh3pRRe41r5xItGdqQAg/QaqCpF6qnUs6s=;
        b=V6WnKVYr9BpebpmniEiK5lTaHjyC/i2hkSvBKmFlga3Hgvvw5sAXtExqkqBncN0GTz
         87B7i8ca7Tnxvf2o0BoHt2wUfzAv4DD1w6AcXzDiSWcfyoJN/cePkkSU9zp9NYy5S4NB
         SXf7E6k/MXLdS+d16EBUtTQhMerGNVueLeUK/A8bnz/7Xp0GnUFmlG6M2Ghrpf+JE2Lc
         1b/6Hzach3MWboYX9X3q/QYxC2VSu83tP1lLaKrtjdvnegm6ROA3/kqDm9H2ZJaU1n10
         t/KrYSfSDnH9V7UTy94qL9Qyz9wpBZGAl4a6KTIp6rMCKk00/Y5D+QlSBempCTDLCgTc
         73ag==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1778833890; x=1779438690; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=alzfgz1aXCJLqugLm78Sp8WFGjGW5XBGx/1DQ0VOqWk=;
        b=ipLa2W0U8HzMKypJelEhtZkOLtR2P7rcDyoLbjgUSqL8A0m1Zlpnm5ZvSJwXjIaK/u
         RvmUNaXNnHt+R7JbEBFwenJgt5gtFfZDnVJm8Wz91GPIu1gHvT4ttnPVqnYrag1/VRTu
         CzlWF44Yy+5chUm5wh5rMmaQxhDEZ0rCIcMV2pD0OH5PrrmGuY0U+fb+Y//5tyNDnJXn
         LLs+FQhW5q010E2H4hD00IGHAdk4HHAq5YGlqpNUOS6Vc+fCgZ36mmqFXoRsxjkYqpeD
         JHUsXCbCF9Me4svYCxGdEu7IOfz4C2GNuSthCGvPdMk7DuVKDuvtRdmoDeS27R2gRVdv
         J3Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778833890; x=1779438690;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=alzfgz1aXCJLqugLm78Sp8WFGjGW5XBGx/1DQ0VOqWk=;
        b=h1ET/uMAv0Xk89FVjAt65/sVUHInfXgYw5JqNG81k+oi4MbdNt7m0MZ9q1T+rHPmJB
         5S7s/5WGggn2xubQxm4IOYL+be1VSpRl3kgBELuKW+t90fToZuEhPHvrHf67dwSYf8hg
         LmcmDDvj6Ge2slO2IqSNjZzrxLP2s9iGqP+oYmUMDUwWmJxRRC8hrNDBxe92CD952jB8
         e9YoqD3qtZYQEmJetkC//JKz2Yy/C+0IC+HEIufICL/QWL0LRu2bNwwvErUv0+IoD1t0
         zuGhJ4KG0ONpClY2JG384OHQOteuHBL9iQSAVAHt23C47tT7Qgk9Q8EdRVDR5Cjn7C5W
         Q3aQ==
X-Forwarded-Encrypted: i=1; AFNElJ9mi8vSj5pBHje8b7IbbpqtjYqIZCIX8TZ8in2F8PPsw37EjzXTlWd5CliQhQpCE0uHdVwty+o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1fNX6dCOabyoH8tITptcrj8mYRfQG4mqYTiqu1FUXURyFokrW
	nTn7NC04BDLNUZ/R6MKi3KNXlM/yB/wxqMEjKP/NMQJ/v4Li7lKzIvm7pOj7kKZ0b3AypFvpcHZ
	nvZ9yS3NyynRfRcgvMvlG2tSMTvNcYkcQBMUYRjhMeA==
X-Gm-Gg: Acq92OGOLX8FKoeKP/EDMb5/zgTljerqb4FylDEvoVrF9BvYKxN54tqNm5m0Cs1aOnA
	//Tj12eUpmE4LrnqG8Yr0LTrW6h2OymBbklfYedJ4NvcHNTWEOzpYgmQ2HGRVNZk3lrRv/jVrWc
	q2Rmf1tePRO2O29V/R0gRdNTlOVTNfBvlogv98GwfHNICakyZMPgeMZMIgsV/FgmY4N0FYU8Vxn
	UfKpBRYFgmEoZ3XUCFPtIVyaQVYNTm9lmBANvib7NC9Lr/zb79ZgZzX0Iq4C5s1KEz4OQpb1Zcl
	g5blhasyKaUW7hpT+7Inaiw5t86KA4U1G9qUuXjNmzybQkTG0iaX/Th8ssQ+B1NxBIE=
X-Received: by 2002:a05:690e:155c:10b0:651:c234:8204 with SMTP id
 956f58d0204a3-65e226bf7dbmr2437248d50.24.1778833890611; Fri, 15 May 2026
 01:31:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260503073541.790215-1-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-1-eric.auger@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 15 May 2026 09:31:19 +0100
X-Gm-Features: AVHnY4JAVD4AJ5nfdtuw8hlYr0xUlyVi_OqdmNMtbkuR_uPHuC85swtfT1ALIAc
Message-ID: <CAFEAcA-TE-8cj6fGOYJaChRVB5GE7E8ys87cxPP4Yw1kgjh9Dg@mail.gmail.com>
Subject: Re: [PATCH v4 00/17] kvm/arm: Introduce a customizable aarch64 KVM
 host model
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
	kvmarm@lists.linux.dev, richard.henderson@linaro.org, cohuck@redhat.com, 
	sebott@redhat.com, skolothumtho@nvidia.com, philmd@linaro.org, maz@kernel.org, 
	oliver.upton@linux.dev, pbonzini@redhat.com, armbru@redhat.com, 
	berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Sun, 3 May 2026 at 08:35, Eric Auger <eric.auger@redhat.com> wrote:
>
> This series enhances the current host KVM model with capability to
> set writable ID reg fields.
>
> Since v6.7 kernel, KVM/arm allows the userspace to overwrite the values
> of a subset of ID regs. The list of writable fields continues to grow.
> The feature ID range is defined as the AArch64 System register space
> with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
>
> The end goal is to get more flexibility when migrating guests
> between different host hardware.
>
> QEMU retrieves the writable ID fields from KVM UAPI [1] and
> match them against a generated description of ID regs and their
> named fields that stem from AARCHMRS Registers.json file.
> Current description is based on latest 2026-03 edition.
> The content of the generated files was compared against kernel
> linux/arch/arm64/tools/sysreg file [3] . It is not straightforward
> to have unit tests for python scripts as there are many cases for
> field extraction.
>
> For each writable named field a uint64 property is created
> following the "SYSREG_<REG>_<FIELD>" naming convention. REG and
> FIELD names are those described in ARM ARM Reference manual.

So if the user asks to set ID registers to an architecturally
invalid combination (e.g. one that reports FEAT_X but not
FEAT_Y even though FEAT_X is supposed to imply FEAT_Y, or
one where one ID register says we have FEAT_X but a different
ID register says we don't have FEAT_X), what happens ?
Do we catch and reject that? Does the kernel reject that?
Or do we just report to the guest what the user asked for,
and if they asked for something broken they can keep both
pieces ?

thanks
-- PMM
